// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let bWelcome = try? newJSONDecoder().decode(BWelcome.self, from: jsonData)

import Foundation

// MARK: - BWelcomeElement
struct BWelcomeElement: Codable {
    var name: String
    var isInstantiable, isReference, hasIndexing, isKeyed: Bool
    var constructors: [BConstructor]
    var constants: [BConstant]
    var methods: [BConstructor]
    var members: [BMember]
    var operators: [BOperator]

    enum CodingKeys: String, CodingKey {
        case name
        case isInstantiable = "is_instantiable"
        case isReference = "is_reference"
        case hasIndexing = "has_indexing"
        case isKeyed = "is_keyed"
        case constructors, constants, methods, members, operators
    }
}

// MARK: - BConstant
struct BConstant: Codable {
    var name: String
    var type: BType
    var value: String
}

enum BType: String, Codable {
    case basis = "Basis"
    case color = "Color"
    case float = "float"
    case int = "int"
    case plane = "Plane"
    case quat = "Quat"
    case transform = "Transform"
    case transform2D = "Transform2D"
    case vector2 = "Vector2"
    case vector2I = "Vector2i"
    case vector3 = "Vector3"
    case vector3I = "Vector3i"
}

// MARK: - BConstructor
struct BConstructor: Codable {
    var name, returnType: String
    var isConst, hasVarargs: Bool
    var arguments: [BArgument]

    enum CodingKeys: String, CodingKey {
        case name
        case returnType = "return_type"
        case isConst = "is_const"
        case hasVarargs = "has_varargs"
        case arguments
    }
}

// MARK: - BArgument
struct BArgument: Codable {
    var name, type: String
    var hasDefaultValue: Bool
    var defaultValue: String

    enum CodingKeys: String, CodingKey {
        case name, type
        case hasDefaultValue = "has_default_value"
        case defaultValue = "default_value"
    }
}

// MARK: - BMember
struct BMember: Codable {
    var name: String
    var type: BType
}

// MARK: - BOperator
struct BOperator: Codable {
    var name: String
    var operatorOperator: Int
    var otherType, returnType: String

    enum CodingKeys: String, CodingKey {
        case name
        case operatorOperator = "operator"
        case otherType = "other_type"
        case returnType = "return_type"
    }
}

typealias BWelcome = [BWelcomeElement]
