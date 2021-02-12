import GodotSwift
import Godot

public class Godot {
    static var initOptions = godot_gdnative_init_options ()
    static var api = godot_gdnative_core_api_struct ()
    static var nativescript_api = godot_gdnative_ext_nativescript_api_struct ()
    static var pluginscript_api = godot_gdnative_ext_pluginscript_api_struct ()
    static var net_api = godot_gdnative_ext_net_api_struct ()
    static var library: UnsafeMutableRawPointer!
    
}

@_cdecl("_godot_swift_wrapper_create")
func wrapper_create (data: UnsafeMutableRawPointer?, typeTag: UnsafeRawPointer?, instance: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
{
    guard let ins = instance else {
        return nil
    }
    let wrapped = Wrapped(nativeHandle: ins, typeTag: OpaquePointer(typeTag!))
    return Unmanaged.passRetained(wrapped).toOpaque()
}

@_cdecl ("_godot_swift_wrapper_destroy")
func wrapper_destroy (data: UnsafeMutableRawPointer?, wrapper: UnsafeMutableRawPointer?)
{
    guard let wptr = wrapper else {
        return
    }
    var w: Unmanaged<Wrapped> = Unmanaged.fromOpaque(wptr)
    w.release()
    
}

@_cdecl("godot_gdnative_init")
func godot_gdnative_init (options: UnsafePointer<godot_gdnative_init_options>)
{
    print ("swift: godot_gdnative_init\n")
    Godot.initOptions = options.pointee
    
    Godot.api = UnsafePointer<godot_gdnative_core_api_struct> (options.pointee.api_struct).pointee
    Godot.library = Godot.initOptions.gd_native_library

    for i in 0..<Int(Godot.api.num_extensions) {
        if let slot = Godot.api.extensions.advanced(by: i).pointee {
            switch slot.pointee.type {
            case GDNATIVE_EXT_NATIVESCRIPT.rawValue:
                Godot.nativescript_api = UnsafePointer<godot_gdnative_ext_nativescript_api_struct> (OpaquePointer (slot)).pointee
            case GDNATIVE_EXT_NET.rawValue:
                Godot.net_api = UnsafePointer<godot_gdnative_ext_net_api_struct> (OpaquePointer (slot)).pointee
                break
            case GDNATIVE_EXT_PLUGINSCRIPT.rawValue:
                Godot.pluginscript_api = UnsafePointer<godot_gdnative_ext_pluginscript_api_struct> (OpaquePointer (slot)).pointee
                break
            default:
                print ("Skipping Extension value \(slot.pointee.type)")
            }
        }
    }
    
    var bf = godot_nativescript_instance_binding_functions ()
    bf.alloc_instance_binding_data = wrapper_create
    bf.free_instance_binding_data = wrapper_destroy
    Godot.nativescript_api.godot_nativescript_register_instance_binding_data_functions (bf)
}

@_cdecl("godot_nativescript_init")
func godot_nativescript_init (handle: Int) {
    print ("swift: godot_nativescript_init\n")
    abort()
}

@_cdecl("godot_gdnative_terminate")
func godot_gdnative_terminate (options: godot_gdnative_terminate_options) {
        print ("terminate")
        abort()
}
