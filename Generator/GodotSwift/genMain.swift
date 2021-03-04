//
//  genMain.swift
//  GodotSwift
//
//  Created by Miguel de Icaza on 2/3/21.
//  Copyright © 2021 Miguel de Icaza. MIT Licensed
//

import Foundation

// Populated with the types loaded from the api.json, we assume they are all reference types
// anything else is not
var referenceTypes: [String:Bool] = [:]

// Maps a typename to its toplevel Json element
var tree: [String:WelcomeElement] = [:]

// Flags types that should be "open", because they contain
// a virtual method that the user can override
var openType: [String: Bool] = [:]

// The list of enum values that have been seen, so that
// constants can be introduced for any missing values
var seenEnumKeys = Set<String>()

var typeToChildren: [String:[String]] = [:]


func isOverride (_ member: String, on: String, arguments: inout [PArgument]) -> Bool {
    guard var current = tree [on] else {
        return false
    }
    while true {
        guard let base = tree [current.baseClass] else {
            return false
        }
        for m in base.methods {
            if m.name == member {
                arguments = m.arguments
                return true
            }
        }
        current = base
    }
}

func genBind (start: GodotApi)
{
    // Assemble all the reference types, we use to test later
    for x in start {
        referenceTypes[stripName (x.name)] = true
    }
    // Also a convenient hash to go from name to json
    // And track which types must be opened up
    for x in start {
        tree [x.name] = x
        openType [x.name] = x.methods.contains { x in x.isVirtual }
        var base = x.baseClass
        if base != "" {
            if var v = typeToChildren [x.name] {
                v.append(x.baseClass)
            } else {
                typeToChildren [x.name] = [x.baseClass]
            }
        }
    }
    // Now patch all the way to the top, so we can annotate all the open types in the hierarchy
    for (typeName,isOpen) in openType {
        if !isOpen { continue }
        
        var start = typeName
        while start != "" {
            guard let base = tree [start]?.baseClass else {
                continue
            }
            openType [base] = true
            start = base
        }
    }
    
    var res = setupResult()
    for x in start {
        if !singleFile {
            res = setupResult()
        }

        let typeName = stripName (x.name)
        //print ("General: \(typeName)")
//        if !(typeName == "Object" || typeName == "Reference" || typeName == "Engine" || typeName == "MainLoop") {
//            continue
//        }
        let baseClass = x.baseClass == "" ? "Wrapped" : stripName(x.baseClass)
        let classModifier = openType [x.name] ?? false ? "open" : "public"
        res += "\(classModifier) class \(typeName):  \(baseClass) {\n"
        let gdname = builtinTypeToGdName (typeName)
        let typeEnum = builtinTypeToGdNativeEnum (typeName)
        
        
        res += indent ("public required init (nativeHandle: UnsafeRawPointer) {\n")
        res += indent ("    super.init (nativeHandle: nativeHandle)\n")
        res += indent ("}\n\n")
        
        //res += indent (generateMainCtors (x.constructors, gdname, typeName, typeEnum))
        var propertyReferenceMethods = Set<String> ()
        res += indent (generateProperties (x.properties, x.methods, &propertyReferenceMethods))
        res += indent (generateMainMethods (x.methods, gdname, typeName, x.name, typeEnum, usedMethods: propertyReferenceMethods))
        res += indent (generateEnums (x.enums))
        res += indent (generateMainConstants (x.constants))
        //res += indent (generateMainMembers (x.members, gdname, typeName, typeEnum))
        //res += indent (generateMainOperators (x.operators, gdname, typeName, typeEnum))
        res += "}\n\n"
        
        if !singleFile {
            try! res.write(toFile: "\(outputDir)/\(typeName).gen.swift", atomically: true, encoding: .utf8)
        }
    }
    if singleFile {
        try! res.write(toFile: "\(outputDir)/main.gen.swift", atomically: true, encoding: .utf8)
    }
}

// Returns an ideal prefix that should be dropped from enumeration keys,
// based on assorted heuristics
func getDropPrefix (_ e: Enum) -> String
{
    // For an enum type MyType it will attempt to drop
    // MY_TYPE, MY, TYPE.   Then it also attempts for
    // scenarios where the type ends in "Mode" to drop
    // the "Mode" prefix, and same for Flag
    var prefixes = camelToSnake(e.name).split(separator: "_").map {String ($0).uppercased()}
    prefixes.insert(camelToSnake (e.name).uppercased(), at: 0)
    if e.name.hasSuffix("Mode") {
        let drop = String (e.name.dropLast (4))
        
        prefixes.insert (camelToSnake (drop).uppercased(), at: 1)
    }
    if e.name.hasSuffix ("Flags") {
        prefixes.insert ("FLAG", at: 1)
    }
    for prefix in prefixes {
        var failed = false
        for entry in e.values {
            if !entry.key.starts(with: prefix + "_") {
                failed = true
                break
            }
        }
        if !failed {
            //print ("Found prefix for \(e.name) to be \(prefix)")
            return prefix + "_"
        }
    }
    return ""
}

func generateProperties (_ properties: [Property], _ methods: [Method], _ referencedMethods: inout Set<String>) -> String
{
    var generated = ""
    if properties.count > 0 {
        generated += "\n/* Properties */\n\n"
    }
    
    for p in properties {
        var mr: String = ""
        var type: String?
    
        if p.index != -1 {
            // TODO: the challenge is that we need to lookup the getter/setter method
            // to lookup the type of the parameter, and then cast this integer value to
            // it, some of the issues are:
            // Int to Enum
            // Int to bool
            // Int to Double
            continue
        }
        // blend_point_0/node - no idea what this is
        if p.name.contains("/"){
            continue
        }
        // Ignore properties that only have getters, just let the setter
        // method be surfaced instead
        if p.getter == "" {
            continue
        }
        // Lookup the type from the method, not the property
        for x in methods {
            if x.name == p.getter {
                type = getGodotType(x.returnType)
            }
        }
        // There are properties declared, but they do not actually exist
        // CurveTexture claims to have a get_width, but the method does not exist
        if type == nil {
            continue
        }
        if type!.hasPrefix("Vector3.Axis") {
            continue
        }
        var optSet = p.index == -1 ? "" : ", \(p.index)"
        var optGet = p.index == -1 ? "" : "\(p.index)"
        mr += "public var \(escapeSwift (snakeToCamel(p.name))): \(type!) {\n"
        mr += "   get {\n"
        mr += "        return \(escapeSwift (snakeToCamel(p.getter))) (\(optGet))\n"
        mr += "   }\n"
        if p.setter != "" {
            mr += "   set {\n"
            mr += "       \(escapeSwift (snakeToCamel(p.setter))) (newValue\(optSet))\n"
            mr += "   }\n"
            
            referencedMethods.insert (p.setter)
        }
        mr += "}\n\n"
        generated += mr
        if p.getter != "get_name" {
            referencedMethods.insert (p.getter)
        }
    }
    return generated
}

func generateEnums (_ enums: [Enum]) -> String
{
    var generated = ""
    if enums.count > 0 {
        generated += "\n/* Enumerations */\n\n"
    }
    for e in enums {
        var mr: String = ""
        let ename = e.name == "Type" ? "GType" : e.name
        
        mr += "public enum \(ename): Int {\n"
        //print ("enum \(e.name)")
        let drop = getDropPrefix(e)
        //let tsnake = camelToSnake(e.name)
        
        // Godot has a handful of aliases, and Swift does not like that
        // we pick the first
        var seenValues = Set<Int> ()
        for v in e.values {
            if seenValues.contains(v.value) {
                continue
            }
            seenValues.insert(v.value)
            seenEnumKeys.insert(v.key)
            var k = v.key
            k = snakeToCamel(String (k.dropFirst(drop.count)))
            if k.first!.isNumber {
                k = e.name.first!.lowercased() + k
            }
            
            //print ("   enum \(v.key) -> \(k)")
            mr += "    case \(escapeSwift (k)) = \(v.value)\n"
        }
//        if e.name.contains("Flag") {
//            print (mr)
//        }
        mr += "}\n\n"
        generated += mr
    }
    return generated
}

func generateMainMethods (_ methods: [Method], _ gdname: String, _ typeName: String, _ originalTypeName: String, _ typeEnum: String, usedMethods: Set<String>) -> String
{
    var generated = ""
    if methods.count > 0 {
        generated += "\n/* Methods */\n"
    }
    var n = 0
    
    // There are some duplicates in the API file, probably a transient problem
    // see: SyntaxHighlighter's _get_line_syntax_highlighting_
    for m in methods {
        var mr: String
        var returnType = m.returnType
        
        let ret = getGodotType(returnType)

        // This is referenced, but does not exist?
        if returnType == ("enum.Vector3::Axis") {
            continue
        }
        n += 1
        if n == 1000 {
            //break
        }
        let retSig = ret == "" ? "" : "-> \(ret)"
        var args = ""

        let ptrName = "method_\(m.name)"
        mr = "private static var \(ptrName): UnsafeMutablePointer<godot_method_bind> = godot_method_bind_get_method (\"\(originalTypeName)\", \"\(m.name)\")!\n"

        var arguments: [PArgument] = m.arguments
        var override = ""
        
        // Setters sometimes have the wrong type (the base type), but getters have the right one (the enum)
        // so fetch that
        if (m.name.hasPrefix("set") || m.name.hasPrefix ("_set")) && usedMethods.contains (m.name) {
            if m.name == "_set_type_cache" {
                print ()
            }
            let rest = m.name.hasPrefix ("_") ? "_get" + m.name.dropFirst(4) : "get" + m.name.dropFirst(3)
            
            for n in methods {
                if n.name == rest  {
                    arguments [0].type = n.returnType
                    break
                }
            }
        }


        // Override lookup is expensive, as it scans methods one by one in an array
        // so limit the damager
        //
        // Additionally, we need to fetch the original argument names, because Godot is
        // inconsitent with the argument names, and Swift does not like that
        
        if m.name == "get_name" || m.name == "_unhandled_input" || m.name == "_input"  {
            if isOverride(m.name, on: typeName, arguments: &arguments) {
                override = "override "
            }
        }
        
        // If this is internal, and being reference by a property, hide it
        var visibility: String
        var eliminate: String
        if usedMethods.contains (m.name) {
            visibility = "private"
            eliminate = "_ "
        } else {
            visibility = "public"
            eliminate = ""
        }
        for arg in arguments {
            if args != "" { args += ", " }
            args += getArgumentDeclaration(arg, eliminate: eliminate)
        }

        let has_return = returnType != "void"

        // This is more complicated, we need to find all the children, and
        // make sure no children is overriding this, so we only flag final
        // those methods that we do not explicitly override
        // let modifier = m.isVirtual ? "" : "final "
        let modifier = ""

        mr += "\(visibility)\(modifier) \(override)func \(escapeSwift (snakeToCamel(m.name))) (\(args))\(retSig) {\n"
        var body = ""
        let resultTypeName = builtinTypeToGdName(returnType)
        if isCoreType(name: returnType) {
            body += (has_return ? "var _result: \(resultTypeName) = \(resultTypeName)()" : "") + "\n"
        } else {
            body += (has_return ? "var _result: Int = 0" : "") + "\n"
        }

        let (argPrep, warnDelete) = generateArgPrepare(arguments)
        body += argPrep
        let ptrArgs = arguments.count > 0 ? "&args" : "nil"
        let ptrResult = has_return ? "&_result" : "nil"

        body += "miguel_proxy (\(typeName).\(ptrName), handle, \(ptrArgs), \(ptrResult))"
        body += "\n"
        if has_return {
            if let _ = referenceTypes [returnType] {
                body += "return \(returnType) (nativeHandle: UnsafeRawPointer (bitPattern: _result)!)\n"
            } else {
                let cast = castGodotToSwift (returnType, "_result")
                body += "return \(cast) /* \(returnType) */\n"
            }
        }
        mr += indent (body)
        mr += warnDelete
        mr += "}\n"
        generated += mr
        
    }
    return generated
}

func generateMainConstants (_ constants: [String:Int]) -> String
{
    var generated = ""
    var first = true
    for c in constants.keys {
        var mr = ""

        if seenEnumKeys.contains(c) {
            continue
        }

        if first {
            generated += "\n/* Constants */\n"
            first = false
        }
        mr += "public let \(c): Int = \(constants [c]!)\n"
        generated += mr
    }
    return generated
}


//func generateMainOperators (_ operators: [BOperator], _ gdname: String, _ typeName: String, _ typeEnum: String) -> String
//{
//    var generated = ""
//    if operators.count > 0 {
//        generated += "\n/* Operators */\n"
//    }
//    for op in operators {
//        var mr = ""
//        let code = op.operatorOperator
//        let rightEnum = builtinTypeToGdNativeEnum (op.otherType)
//        let name = op.name
//        if getOperatorName(code: op.operatorOperator) == "in" {
//            // TODO: figure out operator "in" later
//            continue;
//        }
//        mr += "static var op_\(code)_\(op.otherType): godot_ptr_operator_evaluator = godot_variant_get_ptr_operator_evaluator (godot_variant_operator(\(code)), \(typeEnum), \(rightEnum))\n"
//        mr += "public static func \(getOperatorName (code: op.operatorOperator)) (left: \(typeName), right: \(getGodotType (op.otherType))) -> \(getGodotType (op.returnType)) {\n"
//        var resultTypeName = builtinTypeToGdName(op.returnType)
//        var right: String
//        if isCoreType(name: op.otherType) {
//            right = "right._\(builtinTypeToGdName(op.otherType))"
//        } else {
//            right = "copy"
//            mr += "    var copy = right\n"
//        }
//        mr += "    var result: \(resultTypeName) = \(resultTypeName)()\n"
//        mr += "    op_\(code)_\(op.otherType) (&left._\(gdname), &\(right), &result)\n"
//        mr += "    return \(castGodotToSwift (op.returnType, "result"))\n"
//        mr += "}\n"
//
//        generated += mr
//    }
//    return generated
//}
//
//func generateMainMembers (_ members: [BMember], _ gdname: String, _ typeName: String, _ typeEnum: String) -> String
//{
//    var generated = ""
//    if members.count > 0 {
//        generated += "\n/* Properties */\n"
//    }
//
//    for m in members {
//        var mr = ""
//        let name = m.name
//        let memberType = getGodotType (m.type.rawValue)
//        var resultTypeName = builtinTypeToGdName(m.type.rawValue)
//        mr += "static var get_\(name): godot_ptr_getter = godot_variant_get_ptr_getter_with_cstring (\(typeEnum), \"\(m.name)\")\n"
//        mr += "static var set_\(name): godot_ptr_setter = godot_variant_get_ptr_setter_with_cstring (\(typeEnum), \"\(m.name)\")\n"
//        mr += "public var \(name): \(memberType) {\n"
//        mr += "    get {\n"
//        mr += "        var result: \(resultTypeName) = \(resultTypeName)()\n"
//        mr += "        \(typeName).get_\(name) (&_\(gdname), &result)\n"
//        let cast = castGodotToSwift(m.type.rawValue, "result")
//        mr += "        return \(cast)\n"
//        mr += "    }\n"
//        mr += "    set {\n"
//        var arg: String
//        if !isCoreType (name: m.type.rawValue) {
//            mr += "        var copy = newValue\n"
//            arg = "copy"
//        } else {
//            let argType = builtinTypeToGdName(m.type.rawValue)
//            arg = "newValue._\(argType)"
//        }
//        mr += "        \(typeName).set_\(name) (&_\(gdname), &\(arg))\n"
//        mr += "        abort()\n"
//        mr += "    }\n"
//        mr += "}\n"
//
//        generated += mr
//    }
//    return generated
//}
//
//func generateMainCtors (_ methods: [BConstructor], _ gdname: String, _ typeName: String, _ typeEnum: String) -> String
//{
//    var generated = ""
//    var ctorCount = 0
//    for m in methods {
//        var mr: String
//
//        var args = ""
//
//        let ptrName = "constructor\(ctorCount)"
//        mr = "static var \(ptrName): godot_ptr_constructor = godot_variant_get_ptr_constructor (\(typeEnum), \(ctorCount))\n"
//        ctorCount += 1
//        for arg in m.arguments {
//            if args != "" { args += ", " }
//            args += getArgumentDeclaration(arg)
//        }
//
//        mr += "public init (\(args)) {\n"
//        var body = ""
//
//        let (argPrep, warnDelete) = generateArgPrepare(m.arguments)
//        body += argPrep
//
//        let ptrArgs = m.arguments.count > 0 ? "&args" : "nil"
//
//        body += "\(typeName).\(ptrName) (&_\(gdname), \(ptrArgs))"
//        body += "\n"
//        mr += indent (body)
//        mr += warnDelete
//        mr += "}\n"
//        generated += mr
//    }
//    return generated
//}
