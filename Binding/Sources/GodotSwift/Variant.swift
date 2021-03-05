//
// Variant.swift: bindings for variants in Godot GDNative
//
// Released under the terms of the MIT license
//
// Authors:
//  Created by Miguel de Icaza on 2/1/21.
//
	
import Foundation
import Godot

/**
 * Variant is a wrapper for varios Godot Data types, similar to `AnyObject` in Swift, but
 * used for interoperability with the Godot APIs.   A variant can contain any of the values
 * defined in `Variant.Kind` and there are constructors from various fundamental
 * data types into a Variant.
 *
 * For example, you can wrap a number into a Variant like this:
 * ```
 * let myWrappedNumer = Variant (14)
 * ```
 *
 * In addition, there are failable initializer for all the native types that can be created
 * from a variant, to do this:
 * ```
 * if let myNumber = Int (myWrappedNumber) {
 *    print ("The number is \(myNumber)")
 * }
 * ```
 *
 * You can determine the kind of object wrapped by the variant by examining the `kind` property.
 *
 */
public class Variant: CustomDebugStringConvertible {
    var _godot_variant: godot_variant = godot_variant ()
    
    init (_ native: godot_variant)
    {
        _godot_variant = native
    }

    public enum Kind: Int {
    	case nilKind = 0
        // atomic types
        case bool
        case int
        case float
        case string

        // math types
        case vector2
        case vector2i
        case rect2
        case rect2i
        case vector3
        case vector3i
        case transform2d
        case plane
        case quat
        case aabb
        case basis
        case transform

        // misc types
        case color
        case stringName
        case nodePath
        case rid
        case object
        case callable
        case signal
        case dictionary
        case array

        // typed arrays
        case packedByteArray
        case packedInt32Array
        case packedInt64Array
        case packedFloat32Array
        case packedFloat64Array
        case packedStringArray
        case packedVector2Array
        case packedVector3Array
        case packedColorArray
    }

    public enum Operator: Int {
        case equal
        case notEqual
        case less
        case lessEqual
        case greater
        case greaterEqual

        case add
        case subtract
        case multiply
        case divide
        case negate
        case positive
        case module

        case shiftLeft
        case shiftRight
        case bitAnd
        case bitOr
        case bitXor
        case bitNegate

        case and
        case or
        case xor
        case not

        case `in`
        case max
    }
    
    public init ()
    {
        godot_variant_new_nil(&_godot_variant)
    }
    
    public init (_ other: Variant) {
        godot_variant_new_copy(&_godot_variant, &other._godot_variant)
    }
    
    public init (_ bool: Bool) {
        godot_variant_new_bool(&_godot_variant, bool ? 1 : 0)
    }
    
    public init (_ value: Int64) {
        godot_variant_new_int(&_godot_variant, Int64(value))
    }

    public init (_ value: Double) {
        godot_variant_new_float(&_godot_variant, value)
    }
    
    public init (_ value: String) {
        godot_variant_new_string(&_godot_variant, &value._godot_string)
    }
    
    public init (_ value: Swift.String) {
        let str = String (value)
        godot_variant_new_string(&_godot_variant, &str._godot_string)
    }
    
    public init (_ value: Vector2) {
        godot_variant_new_vector2(&_godot_variant, &value._godot_vector2)
    }

    public init (_ value: Vector2i) {
        godot_variant_new_vector2i(&_godot_variant, &value._godot_vector2i)
    }

    public init (_ value: Rect2) {
        godot_variant_new_rect2(&_godot_variant, &value._godot_rect2)
    }

    public init (_ value: Rect2i) {
        godot_variant_new_rect2i(&_godot_variant, &value._godot_rect2i)
    }
    
    public init (_ value: Vector3) {
        godot_variant_new_vector3(&_godot_variant, &value._godot_vector3)
    }

    public init (_ value: Vector3i) {
        godot_variant_new_vector3i(&_godot_variant, &value._godot_vector3i)
    }

    public init (_ value: Plane) {
        godot_variant_new_plane(&_godot_variant, &value._godot_plane)
    }

    public init (_ value: AABB) {
        godot_variant_new_aabb(&_godot_variant, &value._godot_aabb)
    }

    public init (_ value: Quat) {
        godot_variant_new_quat(&_godot_variant, &value._godot_quat)
    }

    public init (_ value: Basis) {
        godot_variant_new_basis(&_godot_variant, &value._godot_basis)
    }

    public init (_ value: Transform) {
        godot_variant_new_transform(&_godot_variant, &value._godot_transform)
    }

    public init (_ value: Transform2D) {
        godot_variant_new_transform2d(&_godot_variant, &value._godot_transform2d)
    }

    public init (_ value: Color) {
        godot_variant_new_color(&_godot_variant, &value._godot_color)
    }

    public init (_ value: NodePath) {
        godot_variant_new_node_path(&_godot_variant, &value._godot_node_path)
    }

    public init (_ value: RID) {
        godot_variant_new_rid(&_godot_variant, &value._godot_rid)
    }

    public init (_ value: Object) {
        godot_variant_new_object(&_godot_variant, &value.handle)
    }

    public init (_ value: Dictionary) {
        godot_variant_new_dictionary(&_godot_variant, &value._godot_dictionary)
    }

    public init (_ value: Array) {
        godot_variant_new_array(&_godot_variant, &value._godot_array)
    }

    public init (_ value: PackedByteArray) {
        godot_variant_new_packed_byte_array(&_godot_variant, &value._godot_packed_byte_array)
    }

    public init (_ value: PackedInt32Array) {
        godot_variant_new_packed_int32_array(&_godot_variant, &value._godot_packed_int32_array)
    }

    public init (_ value: PackedInt64Array) {
        godot_variant_new_packed_int64_array(&_godot_variant, &value._godot_packed_int64_array)
    }

    public init (_ value: PackedFloat32Array) {
        godot_variant_new_packed_float32_array(&_godot_variant, &value._godot_packed_float32_array)
    }

    public init (_ value: PackedFloat64Array) {
        godot_variant_new_packed_float64_array(&_godot_variant, &value._godot_packed_float64_array)
    }

    public init (_ value: PackedStringArray) {
        godot_variant_new_packed_string_array(&_godot_variant, &value._godot_packed_string_array)
    }

    public init (_ value: PackedVector2Array) {
        godot_variant_new_packed_vector2_array(&_godot_variant, &value._godot_packed_vector2_array)
    }
    public init (_ value: PackedVector3Array) {
        godot_variant_new_packed_vector3_array(&_godot_variant, &value._godot_packed_vector3_array)
    }

    public init (_ value: PackedColorArray) {
        godot_variant_new_packed_color_array(&_godot_variant, &value._godot_packed_color_array)
    }
    
    /// Returns the kind of this variant
    public var kind: Kind {
        get {
            let t = godot_variant_get_type(&_godot_variant)
            return Kind (rawValue: Int (t.rawValue)) ?? .nilKind
        }
    }
    
    public var debugDescription: Swift.String {
        get {
            let t = godot_variant_get_type(&_godot_variant)
            if let k = Kind (rawValue: Int (t.rawValue)) {
                return "\(k)"
            }
            return "\(t)"            
        }
    }
    
    /// Returns the variant as an `object`, which is an UnsafeMutableRawPointer
    public func asObject () -> UnsafeMutableRawPointer?
    {
        if godot_variant_get_type(&_godot_variant) == GODOT_VARIANT_TYPE_OBJECT {
            Godot.api.godot_variant_as_object (&_godot_variant)
        }
        return nil
    }
}

public extension Bool {
    public init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_BOOL {
            self.init(Godot.api.godot_variant_as_bool (&source._godot_variant) != 0 ? true : false)
        } else {
            return nil
        }
    }
}

public extension Int {
    public init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_INT {
            self.init(Godot.api.godot_variant_as_int (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Double {
    public init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_FLOAT {
            self.init(Godot.api.godot_variant_as_float (&source._godot_variant) != 0 ? true : false)
        } else {
            return nil
        }
    }
}

public extension String {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_STRING {
            self.init(Godot.api.godot_variant_as_string (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Vector2 {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_VECTOR2 {
            self.init(Godot.api.godot_variant_as_vector2 (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Vector2i {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_VECTOR2I {
            self.init(Godot.api.godot_variant_as_vector2i (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Vector3 {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_VECTOR3 {
            self.init(Godot.api.godot_variant_as_vector3 (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Vector3i {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_VECTOR3I {
            self.init(Godot.api.godot_variant_as_vector3i (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Rect2 {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_RECT2 {
            self.init(Godot.api.godot_variant_as_rect2 (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Rect2i {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_RECT2I {
            self.init(Godot.api.godot_variant_as_rect2i (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Plane {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PLANE {
            self.init(Godot.api.godot_variant_as_plane (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension AABB {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_AABB {
            self.init(Godot.api.godot_variant_as_aabb (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Quat {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_QUAT {
            self.init(Godot.api.godot_variant_as_quat (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Basis {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_BASIS {
            self.init(Godot.api.godot_variant_as_basis (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Transform {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_TRANSFORM {
            self.init(Godot.api.godot_variant_as_transform (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Transform2D {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_TRANSFORM2D {
            self.init(Godot.api.godot_variant_as_transform2d (&source._godot_variant))
        } else {
            return nil
        }
    }
}
public extension Color {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_COLOR {
            self.init(Godot.api.godot_variant_as_color (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension NodePath {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_NODE_PATH {
            self.init(Godot.api.godot_variant_as_node_path (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension RID {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_RID {
            self.init(Godot.api.godot_variant_as_rid (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Dictionary {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_DICTIONARY {
            self.init(Godot.api.godot_variant_as_dictionary (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension Array {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_ARRAY {
            self.init(Godot.api.godot_variant_as_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedByteArray {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_BYTE_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_byte_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedInt32Array {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_INT32_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_int32_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedInt64Array {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_INT64_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_int64_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedFloat32Array {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_FLOAT32_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_float32_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedFloat64Array {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_FLOAT64_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_float64_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedStringArray {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_STRING_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_string_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedVector2Array {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_VECTOR2_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_vector2_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedVector3Array {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_VECTOR3_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_vector3_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}

public extension PackedColorArray {
    public convenience init? (_ source: Variant) {
        if godot_variant_get_type(&source._godot_variant) == GODOT_VARIANT_TYPE_PACKED_COLOR_ARRAY {
            self.init(Godot.api.godot_variant_as_packed_color_array (&source._godot_variant))
        } else {
            return nil
        }
    }
}
