//
//  main.swift
//  GodotSwift
//
//  Created by Miguel de Icaza on 5/20/20.
//  Copyright © 2020 Miguel de Icaza. All rights reserved.
//
// TODO: Variant
// TODO: Remap method name `init` to initialize
// Create the lazy variables to create the method call handle
// Create the C# method that calls the C API that calls the C++ API
// Create the swift bridge header file and C++ code
// Properties
// Generate the top-level constants rather than rely on the old C++ generator


import Foundation

typealias GodotApiElement = WelcomeElement
typealias GodotApi = Welcome
typealias GodotBuiltinApiElement = BWelcomeElement
typealias GodotBuiltinApi = BWelcome

let projectDir = "/Users/miguel/cvs/godot-master/godot"
let swiftGodot = projectDir + "/modules/swift"
let swiftOutput = swiftGodot + "/glue/GodotSwift/Sources/GodotSwift/Generated"
let swiftCout = swiftGodot + "/glue"
let jsonData = try! Data(contentsOf: URL(fileURLWithPath: projectDir + "/api.json"))
let jsonBuiltinData = try! Data(contentsOf: URL(fileURLWithPath: projectDir + "/builtin-api.json"))
let jsonApi = try! JSONDecoder().decode(GodotApi.self, from: jsonData)
let jsonBuiltinApi = try! JSONDecoder().decode(GodotBuiltinApi.self, from: jsonBuiltinData)
var methodBindCount = 0

func snakeToPascal (_ s: String) -> String {
    let parts = s.split (separator: "_")
    return parts.map { x in x.prefix (1).capitalized + x.dropFirst().lowercased() }.joined()
}

extension String {
    public func cleverLowercase () -> String
    {
        var upper = false
        var lower = false
        
        for x in self {
            upper = upper || x.isUppercase
            lower = lower || x.isLowercase
        }
        if upper && lower {
            return self
        }
        return self.lowercased()
    }
}

func typeRemap (_ t: String) -> String
{
    switch t {
    case "Type": return "GType"
    case "Dictionary": return "GDictionary"
    case "Array": return "GArray"
    default: return t
    }
}

func remapArgName (_ name: String) -> String {
    switch name {
    case "var": return "variant"
    case "abort": return "shouldAbort"
    default: return name
    }
}

var classes: [String: Class] = [:]

func determineEnumPrefix (e: Enum) -> Int
{
    guard let front = e.values.first else {
        return 0
    }
    let rest = e.values.dropFirst()
    let front_parts = front.key.split(separator: "_")
    var candidate_len = front_parts.count - 1

    if candidate_len == 0 {
        return 0
    }
    
    for kv in rest {
        let ename = kv.key
        let parts = ename.split (separator: "_")
        var i = 0
        
        while i < candidate_len && i < parts.count {
            defer { i += 1 }
            if front_parts[i] != parts[i] {
                // HARDCODED: Some Flag enums have the prefix 'FLAG_' for everything except 'FLAGS_DEFAULT' (same for 'METHOD_FLAG_' and'METHOD_FLAGS_DEFAULT').
                let hardcoded_exc = (i == candidate_len - 1 && ((front_parts[i] == "FLAGS" && parts[i] == "FLAG") || (front_parts[i] == "FLAG" && parts[i] == "FLAGS")))
                if !hardcoded_exc {
                    break
                }
            }
        }
        candidate_len = i

        if candidate_len == 0 {
            return 0
        }
    }

    return candidate_len
}

class Type {
    /// The name as found on api.json
    var apiName: String
    
    /// The name as it is going to be surfaced in the Swift API
    var swiftName: String?
    
    /// The code to marshal the parameter encoded as %1$@ to the C proxy
    var swiftToC: String
    
    /// The C type that will be declared
    var ctype: String
    
    /// The type that is used to declare the return value
    var crettmp: String
    
    /// The code to marshal the parameter into the expected code from Godot ptrcall, defaults to the name of the parameter
    var cpass: String
    
    /// The code to return the C value to Swift, should reference "ret" as the return value, output is passed to return, defauls to 'return ret;'
    var ctoSwift: String
    
    /// The code in Swift to wrap the C return to Swift, defaults to "return tmp"
    var swiftWrap: String
    
    /// Whether this type can be nullable on return
    var swiftNullable: Bool
    
    public init (apiName: String, swiftName: String?, swiftToC: String? = nil, ctype: String? = nil, crettmp: String? = nil, cpass: String? = nil, ctoSwift: String? = nil, swiftWrap: String? = nil, swiftNullable: Bool = false)
    {
        self.apiName = apiName
        self.swiftName = swiftName
        self.swiftToC = swiftToC ?? "%1$@"
        self.ctype = ctype ?? apiName
        self.cpass = cpass ?? "%1$@"
        self.crettmp = crettmp ?? "void" // This should break the C compilation if not provided
        self.ctoSwift = ctoSwift ?? "return ret;"
        self.swiftWrap = swiftWrap ?? "return tmp"
        self.swiftNullable = swiftNullable
    }
    
    static var all: [String:Type] = [:]
    
    static func make (apiName: String, swiftName: String, swiftToC: String? = nil, ctype: String? = nil, crettmp: String? = nil, cpass: String? = nil, ctoSwift: String? = nil, swiftWrap: String? = nil, swiftNullable: Bool = false)
    {
        if apiName.contains ("enum"){
            //print ("here")
        }
        all [apiName] = Type (apiName: apiName, swiftName: swiftName, swiftToC: swiftToC, ctype: ctype, crettmp: crettmp, cpass: cpass, ctoSwift: ctoSwift, swiftWrap: swiftWrap, swiftNullable: swiftNullable)
    }
    
    static func get (_ apiName: String) -> Type {
        if let r = all [apiName] {
            return r
        }
        print ("Did not find \(apiName)")
        abort()
    }
}

func mapType (_ str: String)-> String
{
    if let t = Type.all[str] {
        return t.swiftName ?? "ERROR"
    }
    return typeRemap (str)
}

// Contains all the C header signatures
var sigs: String = ""
var ccode: String = ""
var ctr = 0
var maxCtr = 4
class Class {
    var j: GodotApiElement
    var name: String
    
    init (j: GodotApiElement)
    {
        self.j = j
        switch j.name {
        //case "Object": name = "GObject"
        case "Type": name = "GType"
        default: name = j.name
        }
    }

    var filename: String { isExtension() ? name + ".ext.swift" : name + ".swift" }
    func isExtension () -> Bool
    {
        if name == "Object" {
            return true
        }
        return false
    }
    
    var strpublic: String { isExtension() ? "" : "public" }
    func oldgenerateenums () -> String
    {
        var r = ""
        
        for e in j.enums {
            r += "    \(strpublic) enum \(snakeToPascal (typeRemap (e.name))): Int32 {\n"
            for (k,v) in e.values {
                r += "        case \(k) = \(v)\n"
            }
            r += "    }\n\n"
        }
        return r
    }
    
    func makeProxyName (_ m: Method) -> String
    {
        return "godot_swift_\(j.name)_\(m.name)"
    }
    
    func makeCFunc (proxyName: String, m: Method) -> String
    {
        var r = ""
        let rett = Type.get (m.returnType)

        //
        var args = ""
        for a in m.arguments {
            // TODO: Variant
            if a.type.contains("Variant") {
                continue
            }
            let at = Type.get (a.type)
            args += ", \(at.ctype) \(a.name)"
        }

        let sig = "\(rett.ctype) \(proxyName) (MethodBind *method, Object *object\(args))"
        sigs += sig + ";\n"
        let ptrcall_ret_param = rett.apiName == "void" ? "NULL" : "&ret"
        var ptrcall_args: String
        if args == "" {
            ptrcall_args = "NULL"
        } else {
            ptrcall_args = "call_args"
        }
        var retTmp = "\(rett.crettmp) ret;"
        if rett.apiName == "void" {
            retTmp = ""
        }
        r += """
\(sig)
{
    \(retTmp)
    method->ptrcall (object, \(ptrcall_args), \(ptrcall_ret_param));
    \(rett.ctoSwift)
}

"""
        return r
    }

    func makeSwiftFunc (bind: String, proxyName: String, m: Method) -> String
    {
        var r = ""
        let rett = Type.get (m.returnType)
        //
        var args = ""
        for a in m.arguments {
            // TODO: Variant
            if a.type.contains("Variant") {
                continue
            }
            let at = Type.get (a.type)
            args += ", \(at.ctype) \(a.name)"
        }
        let lets: String
        let convert: String
        if rett.apiName != "void" {
            lets = "let tmp = "
            convert = "\n        \(rett.swiftWrap)"
        } else {
            lets = ""
            convert = ""
        }
        
        r += """
        \(lets)\(proxyName) (Self.\(bind), self.handle!)\(convert)

"""
        return r
    }

    func generateFunctions () -> (String, String)
    {
        var r = ""
        var c = ""
        let optStatic = j.singleton ? "static " : ""
        let optPublic = isExtension() ? "" : "public "
        
        
        var explore = false
        for m in j.methods {
            var args = ""
            var plainOrOverride = ""
            methodBindCount += 1
            let methodbindname = "method_bind_\(methodBindCount)"
            var ns = ""
            
            if true || (explore && ctr < maxCtr) {
                let rett = Type.get (m.returnType)
                ns = rett.swiftNullable ? "?" : ""
            } else {
                ns = ""
            }
            
            r += "\n    static var \(methodbindname): OpaquePointer = { Object.classDBgetMethod (type: \"\(j.name)\", method: \"\(m.name)\") } ()\n"
            if let p = classes [j.baseClass] {
                if p.j.methods.first(where: { $0.name == m.name }) != nil {
                    plainOrOverride = "override "
                }
            }
            if m.name.starts(with: "_") {
                continue
            }
            
            // TODO: Variant
            if m.returnType.contains("Variant") {
                continue
            }

            for a in m.arguments {
                // TODO: Variant
                if a.type.contains("Variant") {
                    continue
                }
                if args != "" { args += ", " }
                args += "\(escapeSwift(remapArgName (a.name))): \(mapType (a.type))";
                explore = true
            }
            r += "    \(optPublic)\(optStatic)\(plainOrOverride)" + "func \(escapeSwift (snakeToCamel(m.name))) (\(args))"
            if m.returnType != "void" {
                r += "-> \(mapType (m.returnType))\(ns)\n"
                explore = true
            } else { r += "\n"}
            r += "    {\n"
            if explore && ctr < maxCtr {
                print ("Processing \(j.name) method \(m.name)")
                
                let proxyName = makeProxyName (m)
                c += makeCFunc(proxyName: proxyName, m: m)
                r += makeSwiftFunc (bind: methodbindname, proxyName: proxyName, m: m)
                ctr += 1
            } else {
                r += "        abort()\n"
            }
            r += "    }\n\n"
        }
        return (r, c)
    }
    
    func semanticEnums (_ container: String, _ enums: inout [Enum]) {
        guard enums.count > 0 else {
            return
        }
        for i in 0..<enums.count {
            let e = enums [i]
            let prefixLen = determineEnumPrefix(e: e)
            let currentPrefixLen = prefixLen
            var newValues : [String:Int] = [:]
        
            if e.name == "FilterDB" {
                print ()
            }
            for v in e.values.keys {
                // Process any dupplicate/deprecated Swift elements
                if e.name == "RPCMode" {
                    if v == "RPC_MODE_SLAVE" || v == "RPC_MODE_SYNC" {
                        continue
                    }
                } else if e.name == "FeedImage" {
                    if v == "FEED_YCBCR_IMAGE" || v == "FEED_Y_IMAGE" {
                        continue
                    }
                }
                if v == "FLAGS_DEFAULT" {
                    continue
                }
                
                
                let parts = v.split (separator: "_")
                if parts.count <= prefixLen {
                    continue
                }
                var constant_name = ""
                if let f = parts[currentPrefixLen].first {
                    // The name of enum constants may begin with a numeric digit when strip from the enum prefix,
                    // so we make the prefix for this constant one word shorter in those cases.
                    if f >= "0" && f <= "9"  {
                        constant_name = "c"
                    }
                }
                

                for i in currentPrefixLen..<parts.count {
                    if i > currentPrefixLen {
                        constant_name += "_"
                    }
                    constant_name += parts[i]
                }

                newValues [escapeSwift (snakeToCamel(constant_name))] = e.values [v]
            }
            //print ("Registering handler for " + "enum.\(container)::\(e.name)")
            let enumName = "\(container).\(snakeToPascal (typeRemap (e.name)))"
            Type.make(apiName: "enum.\(container)::\(e.name)",
                      swiftName: enumName,
                      swiftToC: "%1$@.rawValue",
                      ctype: "uint32_t",
                      crettmp: "uint64_t",
                      //cpass: <#T##String?#>,
                      //ctoSwift: <#T##String?#>,
                      swiftWrap: "return \(enumName).init (rawValue: tmp)",
                      swiftNullable: false)
            enums [i].values = newValues
        }
    }
    
    func semantic ()
    {
        if j.enums.count > 0 {
            semanticEnums (j.name, &j.enums)
        }
    }
    
    func generateFullClass () -> String
    {
        let baseClass = j.baseClass == "" ? nil : classes [j.baseClass]
        let baseClassDecl = j.baseClass != "" ? ": " + classes [j.baseClass]!.name : ""
        let classOrExtension = isExtension () ? "extension" : "class"
        var r = ""
        
        r = """
import Foundation
import CApiGodotSwift

public \(classOrExtension) \(name) \(baseClassDecl) {

"""

        if !isExtension() {
            if j.instantiable {
                let overrideStr = (baseClass?.j.instantiable ?? false) ? "override " : ""
            r += """
    public \(overrideStr)init () {
        super.init (owns: true, handle: nil)
        self.handle = OpaquePointer (Unmanaged.passRetained (self).toOpaque())
    }


"""
            }
            r += """
    required init (owns: Bool, handle: OpaquePointer?){
        super.init (owns: owns, handle: handle)
    }

"""
        }
        r += oldgenerateenums ()
        let (swiftcode,cfun) = generateFunctions()
        r += swiftcode
        r += "}\n"
        ccode += cfun
        return r
    }
}

// Populates the type registry with the various built-in types
func registerCoreTypes ()
{
    Type.make(apiName: "void", swiftName: "")
    Type.make(apiName: "float", swiftName: "Float")
    Type.make(apiName: "double", swiftName: "Double")
    Type.make(apiName: "Plane", swiftName: "Plane")
    Type.make(apiName: "Vector2", swiftName: "Vector2")
    Type.make(apiName: "Vector2i", swiftName: "Vector2i")
    Type.make(apiName: "Rect2", swiftName: "Rect2")
    Type.make(apiName: "Vector3", swiftName: "Vector3")
    Type.make(apiName: "Vector3i", swiftName: "Vector3i")
    Type.make(apiName: "Basis", swiftName: "Basis")
    Type.make(apiName: "Quat", swiftName: "Quat")
    Type.make(apiName: "Transform", swiftName: "Transform")
    Type.make(apiName: "Transform2D", swiftName: "Transform2D")
    Type.make(apiName: "Color", swiftName: "Color")
    Type.make(apiName: "RID", swiftName: "RID")
    Type.make(apiName: "Array", swiftName: "GArray")
    Type.make(apiName: "Dictionary", swiftName: "GDictionary")
    Type.make(apiName: "AABB", swiftName: "AABB")
    Type.make(apiName: "int",
              swiftName: "Int32",
              swiftToC: nil,
              ctype: "int32_t",
              crettmp: "int64_t",
              cpass: "(int64_t) %1$@",
              ctoSwift: "return (int32_t) ret;",
              swiftWrap: nil)

    Type.make(apiName: "bool",
              swiftName: "Bool",
              ctype: "_Bool",
              crettmp: "_Bool",
              cpass: "swift_string_to_godot (%1$@)",
              ctoSwift: nil,
              swiftWrap: nil,
              swiftNullable: false)
    Type.make(apiName: "String",
              swiftName: "String",
              ctype: "const char *",
              crettmp: "String",
              cpass: "swift_string_to_godot (%1$@)",
              ctoSwift: "return ret.utf8().get_data();",
              swiftWrap: "return tmp == nil ? nil : String (cString: tmp!)",
              swiftNullable: true)
    Type.make(apiName: "NodePath", swiftName: "NodePath")
    Type.make(apiName: "PoolByteArray", swiftName: "[UInt8]")
    Type.make(apiName: "PoolIntArray", swiftName: "[UInt8]")
    Type.make(apiName: "PoolVector2Array", swiftName: "[Vector2]")
    Type.make(apiName: "PoolVector3Array", swiftName: "[Vector3]")
    Type.make(apiName: "PoolStringArray", swiftName: "[String]")
    Type.make(apiName: "PoolColorArray", swiftName: "[String]")
    Type.make(apiName: "PoolRealArray", swiftName: "[GFloat]")
    Type.make (apiName: "enum.Vector3::Axis", swiftName: "Axis2D")
    Type.make (apiName: "enum.Vector2::Axis", swiftName: "Axis3D")
    Type.make (apiName: "enum.Variant::Type", swiftName: "Variant.GType")
    Type.make (apiName: "enum.Variant::Operator", swiftName: "Variant.Operator")
    Type.make (apiName: "Variant", swiftName: "Variant")
    Type.make (apiName: "PackedByteArray", swiftName: "PackedByteArray")
    Type.make (apiName: "PackedInt32Array", swiftName: "PackedInt32Array")
    Type.make (apiName: "PackedInt64Array", swiftName: "PackedInt64Array")
    Type.make (apiName: "PackedVector3Array", swiftName: "PackedVector3Array")
    Type.make (apiName: "PackedVector2Array", swiftName: "PackedVector2Array")
    Type.make (apiName: "StringName", swiftName: "StringName")
    Type.make (apiName: "PackedStringArray", swiftName: "PackedStringArray")
    Type.make (apiName: "PackedColorArray", swiftName: "PackedColorArray")
    Type.make (apiName: "PackedFloat32Array", swiftName: "PackedFloat32Array")
    Type.make (apiName: "PackedFloat64Array", swiftName: "PackedFloat64Array")
    Type.make (apiName: "Callable", swiftName: "Callable")
    Type.make (apiName: "Rect2i", swiftName: "Rect2i")
}

// POpulates the type registry with the types defined in api.json
func registerBindingTypes ()
{
    for (name, ctype) in classes {
        Type.make(
            apiName: name,
            swiftName: ctype.name,
            swiftToC: "OpaquePointer (%1$@.handle)",
            ctype: "const void *",
            crettmp: "void *",
            cpass: "%1$@",
            ctoSwift: "return ret;",
            swiftWrap: "if tmp == nil { return nil }; let wrapped: \(ctype.name) = Object.lookupInstance (ptr: OpaquePointer (tmp!)); return wrapped",
            swiftNullable: true)
    }
}

func highlevelBind () {
    for x in jsonApi {
        let c = Class (j: x)
        classes [x.name] = c
    }
    registerCoreTypes()
    registerBindingTypes ()
    
    // Temp:
    Type.make (apiName: "enum.Error", swiftName: "Error")
    
    for c in classes.values {
        c.semantic ()
    }
    
    ccode = """
/* THIS FILE IS GENERATED DO NOT EDIT */
#include "glue_header.h"

"""
    
    var count = 0
    for c in classes.values.sorted(by: { $0.name < $1.name }) {
        count += 1
        if c.name == "GlobalConstants" {
            continue
        }
        let res = c.generateFullClass()
        let outfile = swiftOutput + "/\(c.filename)"
        try! res.write(toFile: outfile, atomically: true, encoding: .utf8)
    }
    
    try! ccode.write(toFile: "\(swiftCout)/swift_glue.gen.cpp", atomically: true, encoding: .utf8)
    try! sigs.write(toFile: "\(swiftCout)/swift_glue.gen.inc", atomically: true, encoding: .utf8)
    print ("Generated \(count) classes")
}

builtinBind (start: jsonBuiltinApi)
genBind(start: jsonApi)
