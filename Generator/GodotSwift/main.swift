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

builtinBind (start: jsonBuiltinApi)
genBind(start: jsonApi)
