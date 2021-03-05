//
//  File.swift
//  
//
//  Created by Miguel de Icaza on 3/4/21.
//

import Foundation

class SimpleClass: Sprite3D {
    public required init (nativeHandle: UnsafeRawPointer)
    {
        super.init(nativeHandle: nativeHandle)
        print ("Swift: SimpleClass Ctor")
    }
}

func manualRegister () {
    print ("Swift: ** Manual Register")
    // Registers the class
    let cb = Godot.registerClass(SimpleClass.self)!
    cb.registerProperty (name: "name", defaultValue: Variant (""), kind: .string, getFunc: { obj  in
        print ("I am on the registered property!")
        return Variant("SimpleClass")
    })
    cb.registerMethod(name: "method") { instance, args in
        print ("Swift: 'method' invoked, returning: \(args[0])")
        return args[0]
    }
    cb.registerMethod(name: "_init") { instance, args in
        print ("Swift: _init called")
        return Variant(false)
    }

    cb.registerMethod(name: "_process") { instance, args in
        print ("Swift: _process called")
        return Variant(false)
    }
}
