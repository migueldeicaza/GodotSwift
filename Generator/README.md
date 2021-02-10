# GodotSwift

These scripts produce a Swift API that can be used to access the Godot
API.

To build, you will need both the `builtin-api.json` and `api.json`
that are produced by Godot 4.0 (at the time of this writing in
February 2021, it is the development version of Godot).

Build your Godot, and then run these commands:

```
# bin/godot.osx.tools.x86_64 --gdnative-generate-json-builtin-api builtin-api.json

# bin/godot.osx.tools.x86_64 --gdnative-generate-json-api api.json
```

In addition, for now, you need the supporting infrastructure for this
binding, which comes from `Binding` directory, a peer to this
directory.  

Then open this project in Xcode and run.   You will need to change the paths
in the main file to point to your Godot directory as well as the output
directory.

The result will be a binding for Godot.