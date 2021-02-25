//
// Defs.swift: definitions that mimic the Godot definitions for these constants
//
// Released under the terms of the MIT license
//
// Authors:
//  Miguel de Icaza on 3/4/20.
//

public enum ClockDirection: Int {
    case clockwise
    case counterClockwise
}

public enum Orientation: Int {
    case horizontal
    case vertical
}

public enum HAlign: Int {
    case left
    case center
    case right
    case fill
}

public enum VAlign: Int {
    case top
    case center
    case bottom
}

public enum Side: Int {
    case left
    case top
    case right
    case bottom
}

public enum Corner: Int {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
}