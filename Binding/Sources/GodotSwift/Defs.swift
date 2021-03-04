//
// Defs.swift: definitions that mimic the Godot definitions for these constants
//
// Released under the terms of the MIT license
//
// Authors:
//  Miguel de Icaza on 3/4/20.
//
import Godot

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


public enum GodotMethodRpcMode {
    case disabled
    case remote
    case master
    case puppet
    case remoteSync
    case masterSync
    case puppetSync
    
    func toNative () -> godot_nativescript_method_rpc_mode {
        switch self {
        case .disabled:
            return GODOT_METHOD_RPC_MODE_DISABLED
        case .remote:
            return GODOT_METHOD_RPC_MODE_REMOTE
        case .master:
            return GODOT_METHOD_RPC_MODE_MASTER
        case .puppet:
            return GODOT_METHOD_RPC_MODE_PUPPET
        case .remoteSync:
            return GODOT_METHOD_RPC_MODE_REMOTESYNC
        case .masterSync:
            return GODOT_METHOD_RPC_MODE_MASTERSYNC
        case .puppetSync:
            return GODOT_METHOD_RPC_MODE_PUPPETSYNC
        }
    }
}

public enum GodotPropertyUsage {
    case storage
    case editor
    case network
    case editorHelper
    case checkable
    case checked
    case internationalized
    case group
    case category
    case subgroup
    case noInstanceState
    case restartIfChanged
    case scriptVariable
    case storeIfNull
    case animateAsTrigger
    case updateAllIfModified
    case `default`
    case defaultIntl
    case noeditor
    
    func toNative () -> godot_nativescript_property_usage_flags {
        switch self {
        case .storage:
            return GODOT_PROPERTY_USAGE_STORAGE
        case .editor:
            return GODOT_PROPERTY_USAGE_EDITOR
        case .network:
            return GODOT_PROPERTY_USAGE_NETWORK
        case .editorHelper:
            return GODOT_PROPERTY_USAGE_EDITOR_HELPER
        case .checkable:
            return GODOT_PROPERTY_USAGE_CHECKABLE
        case .checked:
            return GODOT_PROPERTY_USAGE_CHECKED
        case .internationalized:
            return GODOT_PROPERTY_USAGE_INTERNATIONALIZED
        case .group:
            return GODOT_PROPERTY_USAGE_GROUP
        case .category:
            return GODOT_PROPERTY_USAGE_CATEGORY
        case .subgroup:
            return GODOT_PROPERTY_USAGE_SUBGROUP
        case .noInstanceState:
            return GODOT_PROPERTY_USAGE_NO_INSTANCE_STATE
        case .restartIfChanged:
            return GODOT_PROPERTY_USAGE_RESTART_IF_CHANGED
        case .scriptVariable:
            return GODOT_PROPERTY_USAGE_SCRIPT_VARIABLE
        case .storeIfNull:
            return GODOT_PROPERTY_USAGE_STORE_IF_NULL
        case .animateAsTrigger:
            return GODOT_PROPERTY_USAGE_ANIMATE_AS_TRIGGER
        case .updateAllIfModified:
            return GODOT_PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED
        case .`default`:
            return GODOT_PROPERTY_USAGE_DEFAULT
        case .defaultIntl:
            return GODOT_PROPERTY_USAGE_DEFAULT_INTL
        case .noeditor:
            return GODOT_PROPERTY_USAGE_NOEDITOR
        }
    }
}
    
public enum GodotPropertyHint {
    case none
    case range
    case expRange
    case enumeration
    case expEasing
    case length
    case keyAccel
    case flags
    case layers2dRender
    case layers2dPhysics
    case layers3dRender
    case layers3dPhysics
    case file
    case dir
    case globalFile
    case globalDir
    case resourceType
    case multilineText
    case placeholderText
    case colorNoAlpha
    case imageCompressLossy
    case imageCompressLossless
    case objectId
    case typeString
    case nodePathToEditedNode
    case methodOfVariantType
    case methodOfBaseType
    case methodOfInstance
    case methodOfScript
    case propertyOfVariantType
    case propertyOfBaseType
    case propertyOfInstance
    case propertyOfScript
    case max
    
    func toNative () -> godot_nativescript_property_hint {
        switch self {
        case .none:
            return GODOT_PROPERTY_HINT_NONE
        case .range:
            return GODOT_PROPERTY_HINT_RANGE
        case .expRange:
            return GODOT_PROPERTY_HINT_EXP_RANGE
        case .enumeration:
            return GODOT_PROPERTY_HINT_ENUM
        case .expEasing:
            return GODOT_PROPERTY_HINT_EXP_EASING
        case .length:
            return GODOT_PROPERTY_HINT_LENGTH
        case .keyAccel:
            return GODOT_PROPERTY_HINT_KEY_ACCEL
        case .flags:
            return GODOT_PROPERTY_HINT_FLAGS
        case .layers2dRender:
            return GODOT_PROPERTY_HINT_LAYERS_2D_RENDER
        case .layers2dPhysics:
            return GODOT_PROPERTY_HINT_LAYERS_2D_PHYSICS
        case .layers3dRender:
            return GODOT_PROPERTY_HINT_LAYERS_3D_RENDER
        case .layers3dPhysics:
            return GODOT_PROPERTY_HINT_LAYERS_3D_PHYSICS
        case .file:
            return GODOT_PROPERTY_HINT_FILE
        case .dir:
            return GODOT_PROPERTY_HINT_DIR
        case .globalFile:
            return GODOT_PROPERTY_HINT_GLOBAL_FILE
        case .globalDir:
            return GODOT_PROPERTY_HINT_GLOBAL_DIR
        case .resourceType:
            return GODOT_PROPERTY_HINT_RESOURCE_TYPE
        case .multilineText:
            return GODOT_PROPERTY_HINT_MULTILINE_TEXT
        case .placeholderText:
            return GODOT_PROPERTY_HINT_PLACEHOLDER_TEXT
        case .colorNoAlpha:
            return GODOT_PROPERTY_HINT_COLOR_NO_ALPHA
        case .imageCompressLossy:
            return GODOT_PROPERTY_HINT_IMAGE_COMPRESS_LOSSY
        case .imageCompressLossless:
            return GODOT_PROPERTY_HINT_IMAGE_COMPRESS_LOSSLESS
        case .objectId:
            return GODOT_PROPERTY_HINT_OBJECT_ID
        case .typeString:
            return GODOT_PROPERTY_HINT_TYPE_STRING
        case .nodePathToEditedNode:
            return GODOT_PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE
        case .methodOfVariantType:
            return GODOT_PROPERTY_HINT_METHOD_OF_VARIANT_TYPE
        case .methodOfBaseType:
            return GODOT_PROPERTY_HINT_METHOD_OF_BASE_TYPE
        case .methodOfInstance:
            return GODOT_PROPERTY_HINT_METHOD_OF_INSTANCE
        case .methodOfScript:
            return GODOT_PROPERTY_HINT_METHOD_OF_SCRIPT
        case .propertyOfVariantType:
            return GODOT_PROPERTY_HINT_PROPERTY_OF_VARIANT_TYPE
        case .propertyOfBaseType:
            return GODOT_PROPERTY_HINT_PROPERTY_OF_BASE_TYPE
        case .propertyOfInstance:
            return GODOT_PROPERTY_HINT_PROPERTY_OF_INSTANCE
        case .propertyOfScript:
            return GODOT_PROPERTY_HINT_PROPERTY_OF_SCRIPT
        case .max:
            return GODOT_PROPERTY_HINT_MAX
        }
    }
}
