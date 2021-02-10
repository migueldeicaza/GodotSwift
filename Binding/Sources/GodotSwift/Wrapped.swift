//
// Wrapped.swift: Base type definition for wrapped objects
//
// Released under the terms of the MIT license
//
// Authors:
//  Miguel de Icaza on 3/4/20.
//

import Foundation
import Godot
open class Wrapped {
    internal var handle: UnsafeRawPointer
    // var typeTag: Int64
    
    init (nativeHandle: UnsafeRawPointer){
        self.handle = nativeHandle
    }
}
