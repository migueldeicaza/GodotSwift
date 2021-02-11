import GodotSwift
import Godot

@_cdecl("godot_gdnative_init")
func godot_gdnative_init (options: godot_gdnative_init_options)
{
    print ("swift: godot_gdnative_init\n")
}

@_cdecl("godot_nativescript_init")
func godot_nativescript_init (handle: Int) {
    print ("swift: godot_nativescript_init\n")
}