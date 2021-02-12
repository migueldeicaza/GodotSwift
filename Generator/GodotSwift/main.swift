//
//  main.swift
//  GodotSwift
//
//  Created by Miguel de Icaza on 5/20/20.
//  Copyright © 2020-2021 Miguel de Icaza. MIT Licensed
//
// TODO: Remap method name `init` to initialize


import Foundation

typealias GodotApiElement = WelcomeElement
typealias GodotApi = Welcome
typealias GodotBuiltinApiElement = BWelcomeElement
typealias GodotBuiltinApi = BWelcome

// IF we want a single file, or one file per type
var singleFile = true

var args = CommandLine.arguments

let projectDir = args.count > 1 ? args [1] : "/Users/miguel/cvs/godot-master/godot"
var peer = "../../../../../../Binding/Sources/GodotSwift/generated"

let outputDir = args.count > 2 ? args [2] : peer

print ("Usage is: generator [godot-main-directory [output-directory]]")
print ("where godot-main-directory contains api.json and builtin-api.json")
print ("If unspecified, this will default to the built-in versions")

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

var p = FileManager.default.currentDirectoryPath + "/" + peer

print ("Running with projectDir=$(projectDir) and output=\(outputDir)")
builtinBind (start: jsonBuiltinApi)
genBind(start: jsonApi)
print ("Done")
