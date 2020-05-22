// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    var name, baseClass: String
    var apiType: APIType
    var singleton: Bool
    var singletonName: String
    var instanciable, isReference: Bool
    var constants: [String: Int]
    var properties: [Property]
    var signals: [Signal]
    var methods: [Method]
    var enums: [Enum]

    enum CodingKeys: String, CodingKey {
        case name
        case baseClass = "base_class"
        case apiType = "api_type"
        case singleton
        case singletonName = "singleton_name"
        case instanciable
        case isReference = "is_reference"
        case constants, properties, signals, methods, enums
    }
}

enum APIType: String, Codable {
    case core = "core"
    case tools = "tools"
}

// MARK: - Enum
struct Enum: Codable {
    var name: String
    var values: [String: Int]
}

// MARK: - Method
struct Method: Codable {
    var name, returnType: String
    var isEditor, isNoscript, isConst, isReverse: Bool
    var isVirtual, hasVarargs, isFromScript: Bool
    var arguments: [Argument]

    enum CodingKeys: String, CodingKey {
        case name
        case returnType = "return_type"
        case isEditor = "is_editor"
        case isNoscript = "is_noscript"
        case isConst = "is_const"
        case isReverse = "is_reverse"
        case isVirtual = "is_virtual"
        case hasVarargs = "has_varargs"
        case isFromScript = "is_from_script"
        case arguments
    }
}

// MARK: - Argument
struct Argument: Codable {
    var name, type: String
    var hasDefaultValue: Bool?
    var defaultValue: String

    enum CodingKeys: String, CodingKey {
        case name, type
        case hasDefaultValue = "has_default_value"
        case defaultValue = "default_value"
    }
}

// MARK: - Property
struct Property: Codable {
    var name, type, getter, setter: String
    var index: Int
}

// MARK: - Signal
struct Signal: Codable {
    var name: String
    var arguments: [Argument]
}

typealias Welcome = [WelcomeElement]
