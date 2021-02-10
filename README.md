
Swift bindings for the [Godot Game Engine](https://godotengine.org)

This is currently a work in progress, and is aimed at the Godot 4.0
release.

Today, Godot support both GDScript and C# via Mono as scripting
languages.  The intent of this binding is to provide a compiled
alternative that does not use a garbage collector while still
surfacing a modern, user-friendly, and productive programming language
to developers.

Under the `Generator` directory, you will find the API generator that
parses the Godot API files and produces the Swift binding.  The
`Binding` directory contains the manual parts of the Swift support
that are combined with the generated pieces to produce the Swift API
that developers can use.

To build this, first build the Xcode project in `Generator` and run it,
and then use `swift build` in the Binding directory.

# Inspiration

The inspiration from this binding comes from both the Mono bindings
in Godot, as well as Godot-cpp.