//
//  Sample.swift
//  
//
//  Created by Miguel de Icaza on 3/9/21.
//

import Foundation
import GodotSwift

class DemoScript: Sprite3D {
    public required init (nativeHandle: UnsafeRawPointer)
    {
        super.init(nativeHandle: nativeHandle)
        print ("DemoScript: SimpleClass Ctor")
    }
    
    public override func _init() {
        print ("Init calleds")
    }
}
