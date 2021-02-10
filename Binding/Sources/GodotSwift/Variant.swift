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

public class Variant {
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
        case stringCame
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
}

