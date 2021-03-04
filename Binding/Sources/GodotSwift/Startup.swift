import GodotSwift
import Godot

var poorMansMap: [UnsafeMutableRawPointer:Wrapped] = [:]

@_cdecl("_createTypeInstance")
func createTypeInstance (instance: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
{
    print ("createTypeIntance2")
    guard let md = methodData else {
        return nil
    }
    let mp = md.assumingMemoryBound(to: Any.self)
    let wrappedType = mp.pointee as! Wrapped.Type

    let swiftInstance = wrappedType.init(nativeHandle: instance!)
    poorMansMap [instance!] = swiftInstance
    let o = Unmanaged.passRetained (swiftInstance).toOpaque ()
    print ("Creating ins=\(instance) o=\(o)")
    
    return o
}

@_cdecl("_destroyTypeInstance")
func destroyTypeInstance (instance: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, data: UnsafeMutableRawPointer?)
{
    print ("destroyInstance2")
    guard let wptr = data else {
        return
    }
    poorMansMap.removeValue(forKey: instance!)
    var w: Unmanaged<Wrapped> = Unmanaged.fromOpaque(wptr)
    w.release()
}
class ProxyWrappers {
    var getFunc: ((Wrapped)-> Variant)? = nil
    var setFunc: ((Wrapped, Variant) -> ())? = nil
}
    

/**
 * ClassBuilder allows you to surface properties, methods and signals implemented in Swift to the Godot world
 */
public struct ClassBuilder<T:Wrapped> {
    var className: Swift.String
    public init (className: Swift.String) {
        self.className = className
    }
    
    /// Registers a property for the class
    public func registerProperty (name: Swift.String, defaultValue: Variant, kind: Variant.Kind, getFunc: ((Wrapped)-> Variant)? = nil, setFunc: ((Wrapped, Variant) -> ())? = nil, rpcMode: GodotMethodRpcMode = .disabled, usage: GodotPropertyUsage = .`default`, hint: GodotPropertyHint = .none, hintString: Swift.String = "")
    {
        var attr = godot_nativescript_property_attributes ()
        attr.type = Int64 (Variant.Kind.string.rawValue)
        attr.hint = hint.toNative ()
        attr.rset_type = rpcMode.toNative ()
        attr.default_value = defaultValue._godot_variant
        attr.usage = usage.toNative ()
                
        
        func getProxy (object: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, userData: UnsafeMutableRawPointer?) -> godot_variant {
            
            print ("*** ON GETPROXY got \(object)")
            let getAny : Unmanaged<ProxyWrappers> = Unmanaged.fromOpaque(methodData!)
            let u = getAny.takeUnretainedValue()
            let getter = u.getFunc
            
            var instance = poorMansMap [object!]!
            
            return getter! (instance)._godot_variant
        }

        func setProxy (object: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, userData: UnsafeMutableRawPointer?, newValue: UnsafeMutablePointer<godot_variant>?) {
            let setAny : Unmanaged<ProxyWrappers> = Unmanaged.fromOpaque(methodData!)
            let setter = setAny.takeRetainedValue().setFunc
            var instance = poorMansMap [object!]!
            
            return setter! (instance , Variant (newValue!.pointee))
        }
        var d = ProxyWrappers()
        d.getFunc = getFunc
        d.setFunc = setFunc
        var dptr = Unmanaged.passRetained(d).toOpaque()
        
        var getDesc = godot_nativescript_property_get_func ()
        var setDesc = godot_nativescript_property_set_func ()
        
        if let getter = getFunc {
            getDesc.free_func = Godot.api.godot_free
            getDesc.get_func = getProxy
            //getDesc.method_data = Unmanaged.passRetained (getter as AnyObject).toOpaque()
            getDesc.method_data = dptr
        }
        if let setter = setFunc {
            setDesc.free_func = Godot.api.godot_free
            setDesc.set_func = setProxy
            //setDesc.method_data = Unmanaged.passRetained (setter as AnyObject).toOpaque()
            setDesc.method_data = dptr
        }

        Godot.nativescript_api.godot_nativescript_register_property (Godot.nativeScriptHandle, className, name, &attr, setDesc, getDesc)
    }
}

public class Godot {
    static var initOptions = godot_gdnative_init_options ()
    static var api = godot_gdnative_core_api_struct ()
    static var nativescript_api = godot_gdnative_ext_nativescript_api_struct ()
    static var pluginscript_api = godot_gdnative_ext_pluginscript_api_struct ()
    static var net_api = godot_gdnative_ext_net_api_struct ()
    static var library: UnsafeMutableRawPointer!
    static var language_index: Int32 = 0
    static var nativeScriptHandle: UnsafeMutableRawPointer?
    
    /**
     * Registers a subclass of type `Wrapped` with Godot.  By default this will register the type name, and the base type name, but these can be overwritten
     * - Parameter type: the Swift type to register with Godot
     * - Parameter asName: optional, used to override the name by which the type will be registered with godot
     * - Parameter asBaseClassName: optional, used to override the baseclass name for the type being registered
     *
     * Example:
     * ```
     * class Demo {
     *    public required init (nativeHandle: UnsafeRawPointer) {
     *        super.init (nativeHandle)
     *    }
     * }
     *
     * Godot.registerClass (Demo.self)
     * ```
     *
     * The above will register the class `Demo` with Godot.   In addition to registering the class, the user must manually
     * register the properties and methods that will be surfaced.
     */
    public static func registerClass<T:Wrapped> (_ type: T.Type, asName: Swift.String? = nil, asBaseClassName: Swift.String? = nil) -> ClassBuilder<T>? {
        guard let superclass = Swift._getSuperclass (type) else {
            print ("Attempted to register the Wrapped class")
            return nil
        }
        var name = asName ?? "\(type)"
        var baseName = asBaseClassName ?? "\(superclass)"
        var payload = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Any>.stride, alignment: MemoryLayout<Any>.stride)
        payload.storeBytes(of: type, as: Any.self)
        
        var create = godot_nativescript_instance_create_func ()
        create.create_func = createTypeInstance
        create.method_data = payload
        
        var destroy = godot_nativescript_instance_destroy_func ()
        destroy.destroy_func = destroyTypeInstance
        destroy.method_data = payload
        
        Godot.nativescript_api.godot_nativescript_register_class (Godot.nativeScriptHandle, name, baseName, create, destroy)
        return ClassBuilder<T> (className: name)
    }

}

@_cdecl("_godot_swift_wrapper_create")
func wrapper_create (data: UnsafeMutableRawPointer?, typeTag: UnsafeRawPointer?, instance: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
{
    print ("Wrapper create\n")
    guard let ins = instance else {
        return nil
    }
    let wrapped = Wrapped(nativeHandle: ins, typeTag: OpaquePointer(typeTag!))
    let o = Unmanaged.passRetained(wrapped).toOpaque()
    print ("Creating ins=\(ins) o=\(o)")
    return o
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

class SimpleClass: Node {
    public required init (nativeHandle: UnsafeRawPointer)
    {
        super.init(nativeHandle: nativeHandle)
        print ("SimpleClass Ctor")
    }
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
    let ret = GodotSwift.String (from: str)
        
    let addr = withUnsafePointer(to: &ret._godot_string) { $0 }
    return UnsafeMutableRawPointer (OpaquePointer (addr))
}

func manualRegister () {
    print ("** Manual Register")
    // Registers the class
    let cb = Godot.registerClass(SimpleClass.self)!
    cb.registerProperty (name: "name", defaultValue: Variant (""), kind: .string, getFunc: { obj  in
        print ("I am on the registered property!")
        return Variant("SimpleName")
    })
//
//    // Registers the property
//    var attr = godot_nativescript_property_attributes ()
//    attr.type = Int64 (Variant.Kind.string.rawValue)
//    attr.hint = GODOT_PROPERTY_HINT_NONE
//    attr.rset_type = GODOT_METHOD_RPC_MODE_DISABLED
//    attr.default_value = Variant (String ("SimpleDefault"))._godot_variant
//    attr.usage = GODOT_PROPERTY_USAGE_DEFAULT
//
//    func myGet (object: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, userData: UnsafeMutableRawPointer?) -> godot_variant {
//        var variant = Variant ("SimpleClass")
//
//        return variant._godot_variant
//    }
//    var getFunc = godot_nativescript_property_get_func ()
//    getFunc.free_func = Godot.api.godot_free
//    getFunc.get_func = myGet
//    var setFunc = godot_nativescript_property_set_func ()
//
//    Godot.nativescript_api.godot_nativescript_register_property (Godot.nativeScriptHandle, "SimpleClass", "name", &attr, setFunc, getFunc)
//
    func myMethod (object: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, userData: UnsafeMutableRawPointer?, argc: Int32, argv: UnsafeMutablePointer<UnsafeMutablePointer<godot_variant>?>?) -> godot_variant
    {
        if let args = argv {
            if let t = args.pointee {
                return t.pointee
            }
        }
        return Variant ("Hello")._godot_variant
    }
    
    var mattr = godot_nativescript_method_attributes ()
    mattr.rpc_type = GODOT_METHOD_RPC_MODE_DISABLED
    var method = godot_nativescript_instance_method ()
    method.method = myMethod
    Godot.nativescript_api.godot_nativescript_register_method (Godot.nativeScriptHandle, "SimpleClass", "method", mattr, method)
    
    func myUpdate (object: UnsafeMutableRawPointer?, methodData: UnsafeMutableRawPointer?, userData: UnsafeMutableRawPointer?, argc: Int32, argv: UnsafeMutablePointer<UnsafeMutablePointer<godot_variant>?>?) -> godot_variant
    {
        print ("Update called")
        if let args = argv {
            if let t = args.pointee {
                return t.pointee
            }
        }
        return Variant ("Hello")._godot_variant
    }
    method.method = myUpdate
    Godot.nativescript_api.godot_nativescript_register_method (Godot.nativeScriptHandle, "SimpleClass", "_process", mattr, method)
    
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
