//
//  Util.swift
//  GodotSwift
//
//  Created by Miguel de Icaza on 2/1/21.
//  Copyright © 2021 Miguel de Icaza. All rights reserved.
//

import Foundation

extension String {
    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return self.processCamalCaseRegex(pattern: acronymPattern)?
            .processCamalCaseRegex(pattern: normalPattern)?.lowercased() ?? self.lowercased()
    }
    
    fileprivate func processCamalCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}

func isEnum (name: String) -> Bool {
    name.starts(with: "enum.")
}

func isClassType (name: String) -> Bool {
    !(isCoreType(name: name) || isPrimitiveType(name: name))
}

var core_types = [
              "String",
              "Vector2",
              "Vector2i",
              "Rect2",
              "Rect2i",
              "Vector3",
              "Vector3i",
              "Transform2D",
              "Plane",
              "Quat",
              "AABB",
              "Basis",
              "Transform",
              "Color",
              "StringName",
              "NodePath",
              "RID",
              "Callable",
              "Signal",
              "Dictionary",
              "Array",
              "PackedByteArray",
              "PackedInt32Array",
              "PackedInt64Array",
              "PackedFloat32Array",
              "PackedFloat64Array",
              "PackedStringArray",
              "PackedVector2Array",
              "PackedVector3Array",
              "PackedColorArray",
              "Error",
              "Variant",
]

func isCoreType (name: String) -> Bool {
    core_types.contains(name)
}

func isPrimitiveType (name: String) -> Bool {
    return name == "int" || name == "bool" || name == "float" || name == "void"
}

func escapeSwift (_ id: String) -> String {
    switch id {
    case "protocol", "func", "inout", "in", "self", "case", "repeat", "static", "default", "import", "init", "continue":
        return "`\(id)`"
    default:
        return id
    }
}

func snakeToCamel (_ s: String) -> String {
    let parts = s.split (separator: "_")
    let r = parts [0].lowercased() + parts.dropFirst().map { x in x.prefix (1).capitalized + String (x.dropFirst()).cleverLowercase() }.joined()
    return r
}

func camelToSnake (_ s: String) -> String {
    s.camelCaseToSnakeCase()
        .replacingOccurrences(of: "2_D", with: "2D").replacingOccurrences(of: "3_D", with: "3D")
        .replacingOccurrences(of: "2_d", with: "2d").replacingOccurrences(of: "3_d", with: "3d")
}

func isNestedType (name: String, ofType: String = "") -> Bool {
    name.contains(ofType + "::")
}

func indent (_ str: String) -> String {
    var res = ""
    for x in str.split(separator: "\n") {
        res += "    \(x)\n"
    }
    return res
}

func getGodotType (_ t: String) -> String {
    switch t {
    case "int":
        return "Int"
    case "float", "real":
        return "Double"
    case "Nil":
        return "Variant"
    case "void":
        return ""
    case "bool":
        return "Bool"
    default:
        return t
    }
}

func builtinTypeToGdNativeEnum (_ t: String) -> String {
    "GODOT_VARIANT_TYPE_" + (camelToSnake(t).uppercased())
}

func getArgumentDeclaration (_ argument: BArgument) -> String {
    let optNeedInOut = isCoreType(name: argument.type) ? "inout " : ""
    return "\(escapeSwift (snakeToCamel (argument.name))): \(optNeedInOut)\(getGodotType(argument.type))"
}

func builtinTypeToGdName (_ name: String) -> String {
    return "godot_" + camelToSnake (name)
}

func castGodotToSwift (_ type: String, _ arg: String) -> String {
    
    switch (type){
    case "int":
        return "Int (\(arg))"
    case "bool":
        return "\(arg) == 0 ? false : true"
    default:
        if isCoreType(name: type){
            return "\(type) (\(arg))"
        }
        print ("cast \(type)")
        return arg
    }
    return ""
}
