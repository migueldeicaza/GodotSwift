import GodotSwift
import Godot

public class Godot {
    static var initOptions = godot_gdnative_init_options ()
    static var api = godot_gdnative_core_api_struct ()
    static var nativescript_api = godot_gdnative_ext_nativescript_api_struct ()
    static var pluginscript_api = godot_gdnative_ext_pluginscript_api_struct ()
    static var net_api = godot_gdnative_ext_net_api_struct ()
    static var library: UnsafeMutableRawPointer!
    static var language_index: Int32 = 0
    static var nativeScriptHandle: UnsafeMutableRawPointer?
}

@_cdecl("_godot_swift_wrapper_create")
func wrapper_create (data: UnsafeMutableRawPointer?, typeTag: UnsafeRawPointer?, instance: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
{
    print ("Wrapper create\n")
    guard let ins = instance else {
        return nil
    }
    let wrapped = Wrapped(nativeHandle: ins, typeTag: OpaquePointer(typeTag!))
    return Unmanaged.passRetained(wrapped).toOpaque()
}

@_cdecl ("_godot_swift_wrapper_destroy")
func wrapper_destroy (data: UnsafeMutableRawPointer?, wrapper: UnsafeMutableRawPointer?)
{
    print ("Wrapper destroy\n")
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
            print ("Extension value \(slot.pointee.type)")
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
    Godot.language_index  = Godot.nativescript_api.godot_nativescript_register_instance_binding_data_functions (bf)
}

class SimpleClass {
    init ()
    {
        print ("SimpleClass Ctor")
    }
    var name: Swift.String {
        get {
            return "Hello from SimpleClass"
        }
    }
}

@_cdecl("_createInstance")
func createInstace (instance: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
{
    Unmanaged.passRetained (SimpleClass ()).toOpaque ()
}

@_cdecl("_destroyInstance")
func destroyInstance (instance: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, data: UnsafeMutableRawPointer?)
{
    print ("destroyInstance")
    guard let wptr = data else {
        return
    }
    var w: Unmanaged<SimpleClass> = Unmanaged.fromOpaque(wptr)
    w.release()
}

@_cdecl ("propertyGetData")
func propertyGetData (instance: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, userData: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
{
    print ("propertyGetData")
    guard let wptr = instance else {
        return nil
    }
    var w: Unmanaged<SimpleClass> = Unmanaged.fromOpaque(wptr)
    let retained = w.takeRetainedValue()
    let str = retained.name
    let ret = GodotSwift.String (str)
        
    let addr = withUnsafePointer(to: &ret._godot_string) { $0 }
    return UnsafeMutableRawPointer (OpaquePointer (addr))
}

func manualRegister () {
    var create = godot_nativescript_instance_create_func ()
    create.create_func = createInstace
    var destroy = godot_nativescript_instance_destroy_func ()
    destroy.destroy_func = destroyInstance
    
    // Registers the class
    Godot.nativescript_api.godot_nativescript_register_class (Godot.nativeScriptHandle, "SimpleClass", "Reference", create, destroy)
    Godot.nativescript_api.godot_nativescript_set_type_tag (Godot.nativeScriptHandle, "SimpleClass", UnsafeRawPointer (bitPattern: 0xdeadbeef))
    
    // Registers the property
    var attr = godot_nativescript_property_attributes ()
    attr.type = Int64 (Variant.Kind.string.rawValue)
    attr.hint = GODOT_PROPERTY_HINT_NONE
    attr.rset_type = GODOT_METHOD_RPC_MODE_DISABLED
    attr.default_value = Variant (String ("SimpleDefault"))._godot_variant
    attr.usage = GODOT_PROPERTY_USAGE_DEFAULT
    
    var getFunc = godot_nativescript_property_get_func ()
    var setFunc = godot_nativescript_property_set_func ()
    
//    void GDAPI godot_nativescript_register_property(void *p_gdnative_handle, const char *p_name, const char *p_path, godot_nativescript_property_attributes *p_attr, godot_nativescript_property_set_func p_set_func, godot_nativescript_property_get_func p_get_func);

    
    print ("This turd does not compile, Swift refuses because it claims it is ambigious")
//    Godot.nativescript_api.godot_nativescript_register_property (Godot.nativeScriptHandle, "SimpleClass", "name", &attr, getFunc, setFunc)
//    var x: UnsafePointer<Int8>? = nil
//    var y: UnsafeMutablePointer<godot_nativescript_property_attributes>? = nil
//    
//    print ("This turd does not compile")
    // Godot.nativescript_api.godot_nativescript_register_property (Godot.nativeScriptHandle, x, x, y, getFunc, setFunc)
    
}

@_cdecl("godot_nativescript_init")
func godot_nativescript_init (handle: UnsafeMutableRawPointer?) {
    print ("swift: godot_nativescript_init\n")
    Godot.nativeScriptHandle = handle
    
    manualRegister ()
}

@_cdecl("godot_gdnative_terminate")
func godot_gdnative_terminate (options: godot_gdnative_terminate_options) {
    print ("terminate")
}
