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
Copy the `builtin-api.json` and `api.json` into `intoGodotApi` directory.

Then run `swift run gen` in this directory.   You may need to specify the path of 
`api.json` directory after the command if you don't copy these files into default 
directory `GodotApi`. eg. `swift run gen /godot-master/godot`  Also you can specify
output directory after it.

The result will be a binding for Godot.