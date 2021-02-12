/* THIS FILE IS GENERATED DO NOT EDIT */
#ifndef GODOT_GDNATIVE_API_STRUCT_H
#define GODOT_GDNATIVE_API_STRUCT_H

#include <gdnative/gdnative.h>
#include <android/godot_android.h>
#include <xr/godot_xr.h>
#include <nativescript/godot_nativescript.h>
#include <net/godot_net.h>
#include <pluginscript/godot_pluginscript.h>
#include <videodecoder/godot_videodecoder.h>
#include <text/godot_text.h>

#ifdef __cplusplus
extern "C" {
#endif

enum GDNATIVE_API_TYPES {
	GDNATIVE_CORE,
	GDNATIVE_EXT_NATIVESCRIPT,
	GDNATIVE_EXT_PLUGINSCRIPT,
	GDNATIVE_EXT_ANDROID,
	GDNATIVE_EXT_XR,
	GDNATIVE_EXT_VIDEODECODER,
	GDNATIVE_EXT_NET,
	GDNATIVE_EXT_TEXT,
};

typedef struct godot_gdnative_ext_nativescript_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	void (*godot_nativescript_register_class)(void *p_gdnative_handle, const char *p_name, const char *p_base, godot_nativescript_instance_create_func p_create_func, godot_nativescript_instance_destroy_func p_destroy_func);
	void (*godot_nativescript_register_tool_class)(void *p_gdnative_handle, const char *p_name, const char *p_base, godot_nativescript_instance_create_func p_create_func, godot_nativescript_instance_destroy_func p_destroy_func);
	void (*godot_nativescript_register_method)(void *p_gdnative_handle, const char *p_name, const char *p_function_name, godot_nativescript_method_attributes p_attr, godot_nativescript_instance_method p_method);
	void (*godot_nativescript_set_method_argument_information)(void *p_gdnative_handle, const char *p_name, const char *p_function_name, int p_num_args, const godot_nativescript_method_argument *p_args);
	void (*godot_nativescript_register_property)(void *p_gdnative_handle, const char *p_name, const char *p_path, godot_nativescript_property_attributes *p_attr, godot_nativescript_property_set_func p_set_func, godot_nativescript_property_get_func p_get_func);
	void (*godot_nativescript_register_signal)(void *p_gdnative_handle, const char *p_name, const godot_nativescript_signal *p_signal);
	void *(*godot_nativescript_get_userdata)(godot_object *p_instance);
	void (*godot_nativescript_set_class_documentation)(void *p_gdnative_handle, const char *p_name, godot_string p_documentation);
	void (*godot_nativescript_set_method_documentation)(void *p_gdnative_handle, const char *p_name, const char *p_function_name, godot_string p_documentation);
	void (*godot_nativescript_set_property_documentation)(void *p_gdnative_handle, const char *p_name, const char *p_path, godot_string p_documentation);
	void (*godot_nativescript_set_signal_documentation)(void *p_gdnative_handle, const char *p_name, const char *p_signal_name, godot_string p_documentation);
	void (*godot_nativescript_set_global_type_tag)(int p_idx, const char *p_name, const void *p_type_tag);
	const void *(*godot_nativescript_get_global_type_tag)(int p_idx, const char *p_name);
	void (*godot_nativescript_set_type_tag)(void *p_gdnative_handle, const char *p_name, const void *p_type_tag);
	const void *(*godot_nativescript_get_type_tag)(const godot_object *p_object);
	int (*godot_nativescript_register_instance_binding_data_functions)(godot_nativescript_instance_binding_functions p_binding_functions);
	void (*godot_nativescript_unregister_instance_binding_data_functions)(int p_idx);
	void *(*godot_nativescript_get_instance_binding_data)(int p_idx, godot_object *p_object);
	void (*godot_nativescript_profiling_add_data)(const char *p_signature, uint64_t p_line);
} godot_gdnative_ext_nativescript_api_struct;

typedef struct godot_gdnative_ext_pluginscript_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	void (*godot_pluginscript_register_language)(const godot_pluginscript_language_desc *language_desc);
} godot_gdnative_ext_pluginscript_api_struct;

typedef struct godot_gdnative_ext_android_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	JNIEnv*(*godot_android_get_env)();
	jobject (*godot_android_get_activity)();
	jobject (*godot_android_get_surface)();
	bool (*godot_android_is_activity_resumed)();
} godot_gdnative_ext_android_api_struct;

typedef struct godot_gdnative_ext_xr_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	void (*godot_xr_register_interface)(const godot_xr_interface_gdnative *p_interface);
	godot_float (*godot_xr_get_worldscale)();
	godot_transform (*godot_xr_get_reference_frame)();
	void (*godot_xr_blit)(godot_int p_eye, godot_rid *p_render_target, godot_rect2 *p_screen_rect);
	godot_int (*godot_xr_get_texid)(godot_rid *p_render_target);
	godot_int (*godot_xr_add_controller)(char *p_device_name, godot_int p_hand, godot_bool p_tracks_orientation, godot_bool p_tracks_position);
	void (*godot_xr_remove_controller)(godot_int p_controller_id);
	void (*godot_xr_set_controller_transform)(godot_int p_controller_id, godot_transform *p_transform, godot_bool p_tracks_orientation, godot_bool p_tracks_position);
	void (*godot_xr_set_controller_button)(godot_int p_controller_id, godot_int p_button, godot_bool p_is_pressed);
	void (*godot_xr_set_controller_axis)(godot_int p_controller_id, godot_int p_exis, godot_float p_value, godot_bool p_can_be_negative);
	godot_float (*godot_xr_get_controller_rumble)(godot_int p_controller_id);
} godot_gdnative_ext_xr_api_struct;

typedef struct godot_gdnative_ext_videodecoder_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	godot_int (*godot_videodecoder_file_read)(void *file_ptr, uint8_t *buf, int buf_size);
	int64_t (*godot_videodecoder_file_seek)(void *file_ptr, int64_t pos, int whence);
	void (*godot_videodecoder_register_decoder)(const godot_videodecoder_interface_gdnative *p_interface);
} godot_gdnative_ext_videodecoder_api_struct;

typedef struct godot_gdnative_ext_net_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	void (*godot_net_bind_stream_peer)(godot_object *p_obj, const godot_net_stream_peer *p_interface);
	void (*godot_net_bind_packet_peer)(godot_object *p_obj, const godot_net_packet_peer *p_interface);
	void (*godot_net_bind_multiplayer_peer)(godot_object *p_obj, const godot_net_multiplayer_peer *p_interface);
	godot_error (*godot_net_set_webrtc_library)(const godot_net_webrtc_library *p_library);
	void (*godot_net_bind_webrtc_peer_connection)(godot_object *p_obj, const godot_net_webrtc_peer_connection *p_interface);
	void (*godot_net_bind_webrtc_data_channel)(godot_object *p_obj, const godot_net_webrtc_data_channel *p_interface);
} godot_gdnative_ext_net_api_struct;

typedef struct godot_gdnative_ext_text_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	void (*godot_text_register_interface)(const godot_text_interface_gdnative *p_interface, const godot_string *p_name, uint32_t p_features);
	void (*godot_glyph_new)(godot_glyph *r_dest);
	godot_vector2i (*godot_glyph_get_range)(const godot_glyph *p_self);
	void (*godot_glyph_set_range)(godot_glyph *p_self, const godot_vector2i *p_range);
	godot_int (*godot_glyph_get_count)(const godot_glyph *p_self);
	void (*godot_glyph_set_count)(godot_glyph *p_self, godot_int p_count);
	godot_int (*godot_glyph_get_repeat)(const godot_glyph *p_self);
	void (*godot_glyph_set_repeat)(godot_glyph *p_self, godot_int p_repeat);
	godot_int (*godot_glyph_get_flags)(const godot_glyph *p_self);
	void (*godot_glyph_set_flags)(godot_glyph *p_self, godot_int p_flags);
	godot_vector2 (*godot_glyph_get_offset)(const godot_glyph *p_self);
	void (*godot_glyph_set_offset)(godot_glyph *p_self, const godot_vector2 *p_offset);
	godot_float (*godot_glyph_get_advance)(const godot_glyph *p_self);
	void (*godot_glyph_set_advance)(godot_glyph *p_self, godot_float p_advance);
	godot_rid (*godot_glyph_get_font)(const godot_glyph *p_self);
	void (*godot_glyph_set_font)(godot_glyph *p_self, godot_rid *p_font);
	godot_int (*godot_glyph_get_font_size)(const godot_glyph *p_self);
	void (*godot_glyph_set_font_size)(godot_glyph *p_self, godot_int p_size);
	godot_int (*godot_glyph_get_index)(const godot_glyph *p_self);
	void (*godot_glyph_set_index)(godot_glyph *p_self, godot_int p_index);
	void (*godot_packed_glyph_array_new)(godot_packed_glyph_array *r_dest);
	void (*godot_packed_glyph_array_new_copy)(godot_packed_glyph_array *r_dest, const godot_packed_glyph_array *p_src);
	godot_bool (*godot_packed_glyph_array_is_empty)(const godot_packed_glyph_array *p_self);
	void (*godot_packed_glyph_array_append)(godot_packed_glyph_array *p_self, const godot_glyph *p_data);
	void (*godot_packed_glyph_array_append_array)(godot_packed_glyph_array *p_self, const godot_packed_glyph_array *p_array);
	godot_error (*godot_packed_glyph_array_insert)(godot_packed_glyph_array *p_self, const godot_int p_idx, const godot_glyph *p_data);
	godot_bool (*godot_packed_glyph_array_has)(godot_packed_glyph_array *p_self, const godot_glyph *p_value);
	void (*godot_packed_glyph_array_sort)(godot_packed_glyph_array *p_self);
	void (*godot_packed_glyph_array_invert)(godot_packed_glyph_array *p_self);
	void (*godot_packed_glyph_array_push_back)(godot_packed_glyph_array *p_self, const godot_glyph *p_data);
	void (*godot_packed_glyph_array_remove)(godot_packed_glyph_array *p_self, const godot_int p_idx);
	void (*godot_packed_glyph_array_resize)(godot_packed_glyph_array *p_self, const godot_int p_size);
	const godot_glyph *(*godot_packed_glyph_array_ptr)(const godot_packed_glyph_array *p_self);
	godot_glyph *(*godot_packed_glyph_array_ptrw)(godot_packed_glyph_array *p_self);
	void (*godot_packed_glyph_array_set)(godot_packed_glyph_array *p_self, const godot_int p_idx, const godot_glyph *p_data);
	godot_glyph (*godot_packed_glyph_array_get)(const godot_packed_glyph_array *p_self, const godot_int p_idx);
	godot_int (*godot_packed_glyph_array_size)(const godot_packed_glyph_array *p_self);
	void (*godot_packed_glyph_array_destroy)(godot_packed_glyph_array *p_self);
} godot_gdnative_ext_text_api_struct;

typedef struct godot_gdnative_core_api_struct {
	unsigned int type;
	godot_gdnative_api_version version;
	const godot_gdnative_api_struct *next;
	unsigned int num_extensions;
	const godot_gdnative_api_struct **extensions;
	void (*godot_object_destroy)(godot_object *p_o);
	godot_object *(*godot_global_get_singleton)(char *p_name);
	godot_method_bind *(*godot_method_bind_get_method)(const char *p_classname, const char *p_methodname);
	void (*godot_method_bind_ptrcall)(godot_method_bind *p_method_bind, godot_object *p_instance, const void **p_args, void *p_ret);
	godot_variant (*godot_method_bind_call)(godot_method_bind *p_method_bind, godot_object *p_instance, const godot_variant **p_args, const int p_arg_count, godot_variant_call_error *p_call_error);
	godot_class_constructor (*godot_get_class_constructor)(const char *p_classname);
	godot_dictionary (*godot_get_global_constants)();
	void (*godot_register_native_call_type)(const char *call_type, native_call_cb p_callback);
	void *(*godot_alloc)(int p_bytes);
	void *(*godot_realloc)(void *p_ptr, int p_bytes);
	void (*godot_free)(void *p_ptr);
	void (*godot_print_error)(const char *p_description, const char *p_function, const char *p_file, int p_line);
	void (*godot_print_warning)(const char *p_description, const char *p_function, const char *p_file, int p_line);
	void (*godot_print_script_error)(const char *p_description, const char *p_function, const char *p_file, int p_line);
	void *(*godot_get_class_tag)(const godot_string_name *p_class);
	godot_object *(*godot_object_cast_to)(const godot_object *p_object, void *p_class_tag);
	godot_object *(*godot_instance_from_id)(uint64_t p_instance_id);
	uint64_t (*godot_object_get_instance_id)(const godot_object *p_object);
	void (*godot_variant_new_copy)(godot_variant *r_dest, const godot_variant *p_src);
	void (*godot_variant_new_nil)(godot_variant *r_dest);
	void (*godot_variant_new_bool)(godot_variant *r_dest, const godot_bool p_b);
	void (*godot_variant_new_int)(godot_variant *r_dest, const int64_t p_i);
	void (*godot_variant_new_float)(godot_variant *r_dest, const double p_f);
	void (*godot_variant_new_string)(godot_variant *r_dest, const godot_string *p_s);
	void (*godot_variant_new_string_name)(godot_variant *r_dest, const godot_string_name *p_s);
	void (*godot_variant_new_vector2)(godot_variant *r_dest, const godot_vector2 *p_v2);
	void (*godot_variant_new_vector2i)(godot_variant *r_dest, const godot_vector2i *p_v2);
	void (*godot_variant_new_rect2)(godot_variant *r_dest, const godot_rect2 *p_rect2);
	void (*godot_variant_new_rect2i)(godot_variant *r_dest, const godot_rect2i *p_rect2);
	void (*godot_variant_new_vector3)(godot_variant *r_dest, const godot_vector3 *p_v3);
	void (*godot_variant_new_vector3i)(godot_variant *r_dest, const godot_vector3i *p_v3);
	void (*godot_variant_new_transform2d)(godot_variant *r_dest, const godot_transform2d *p_t2d);
	void (*godot_variant_new_plane)(godot_variant *r_dest, const godot_plane *p_plane);
	void (*godot_variant_new_quat)(godot_variant *r_dest, const godot_quat *p_quat);
	void (*godot_variant_new_aabb)(godot_variant *r_dest, const godot_aabb *p_aabb);
	void (*godot_variant_new_basis)(godot_variant *r_dest, const godot_basis *p_basis);
	void (*godot_variant_new_transform)(godot_variant *r_dest, const godot_transform *p_trans);
	void (*godot_variant_new_color)(godot_variant *r_dest, const godot_color *p_color);
	void (*godot_variant_new_node_path)(godot_variant *r_dest, const godot_node_path *p_np);
	void (*godot_variant_new_rid)(godot_variant *r_dest, const godot_rid *p_rid);
	void (*godot_variant_new_object)(godot_variant *r_dest, const godot_object *p_obj);
	void (*godot_variant_new_callable)(godot_variant *r_dest, const godot_callable *p_cb);
	void (*godot_variant_new_signal)(godot_variant *r_dest, const godot_signal *p_signal);
	void (*godot_variant_new_dictionary)(godot_variant *r_dest, const godot_dictionary *p_dict);
	void (*godot_variant_new_array)(godot_variant *r_dest, const godot_array *p_arr);
	void (*godot_variant_new_packed_byte_array)(godot_variant *r_dest, const godot_packed_byte_array *p_pba);
	void (*godot_variant_new_packed_int32_array)(godot_variant *r_dest, const godot_packed_int32_array *p_pia);
	void (*godot_variant_new_packed_int64_array)(godot_variant *r_dest, const godot_packed_int64_array *p_pia);
	void (*godot_variant_new_packed_float32_array)(godot_variant *r_dest, const godot_packed_float32_array *p_pra);
	void (*godot_variant_new_packed_float64_array)(godot_variant *r_dest, const godot_packed_float64_array *p_pra);
	void (*godot_variant_new_packed_string_array)(godot_variant *r_dest, const godot_packed_string_array *p_psa);
	void (*godot_variant_new_packed_vector2_array)(godot_variant *r_dest, const godot_packed_vector2_array *p_pv2a);
	void (*godot_variant_new_packed_vector3_array)(godot_variant *r_dest, const godot_packed_vector3_array *p_pv3a);
	void (*godot_variant_new_packed_color_array)(godot_variant *r_dest, const godot_packed_color_array *p_pca);
	godot_bool (*godot_variant_as_bool)(const godot_variant *p_self);
	int64_t (*godot_variant_as_int)(const godot_variant *p_self);
	double (*godot_variant_as_float)(const godot_variant *p_self);
	godot_string (*godot_variant_as_string)(const godot_variant *p_self);
	godot_string_name (*godot_variant_as_string_name)(const godot_variant *p_self);
	godot_vector2 (*godot_variant_as_vector2)(const godot_variant *p_self);
	godot_vector2i (*godot_variant_as_vector2i)(const godot_variant *p_self);
	godot_rect2 (*godot_variant_as_rect2)(const godot_variant *p_self);
	godot_rect2i (*godot_variant_as_rect2i)(const godot_variant *p_self);
	godot_vector3 (*godot_variant_as_vector3)(const godot_variant *p_self);
	godot_vector3i (*godot_variant_as_vector3i)(const godot_variant *p_self);
	godot_transform2d (*godot_variant_as_transform2d)(const godot_variant *p_self);
	godot_plane (*godot_variant_as_plane)(const godot_variant *p_self);
	godot_quat (*godot_variant_as_quat)(const godot_variant *p_self);
	godot_aabb (*godot_variant_as_aabb)(const godot_variant *p_self);
	godot_basis (*godot_variant_as_basis)(const godot_variant *p_self);
	godot_transform (*godot_variant_as_transform)(const godot_variant *p_self);
	godot_color (*godot_variant_as_color)(const godot_variant *p_self);
	godot_node_path (*godot_variant_as_node_path)(const godot_variant *p_self);
	godot_rid (*godot_variant_as_rid)(const godot_variant *p_self);
	godot_object *(*godot_variant_as_object)(const godot_variant *p_self);
	godot_callable (*godot_variant_as_callable)(const godot_variant *p_self);
	godot_signal (*godot_variant_as_signal)(const godot_variant *p_self);
	godot_dictionary (*godot_variant_as_dictionary)(const godot_variant *p_self);
	godot_array (*godot_variant_as_array)(const godot_variant *p_self);
	godot_packed_byte_array (*godot_variant_as_packed_byte_array)(const godot_variant *p_self);
	godot_packed_int32_array (*godot_variant_as_packed_int32_array)(const godot_variant *p_self);
	godot_packed_int64_array (*godot_variant_as_packed_int64_array)(const godot_variant *p_self);
	godot_packed_float32_array (*godot_variant_as_packed_float32_array)(const godot_variant *p_self);
	godot_packed_float64_array (*godot_variant_as_packed_float64_array)(const godot_variant *p_self);
	godot_packed_string_array (*godot_variant_as_packed_string_array)(const godot_variant *p_self);
	godot_packed_vector2_array (*godot_variant_as_packed_vector2_array)(const godot_variant *p_self);
	godot_packed_vector3_array (*godot_variant_as_packed_vector3_array)(const godot_variant *p_self);
	godot_packed_color_array (*godot_variant_as_packed_color_array)(const godot_variant *p_self);
	void (*godot_variant_destroy)(godot_variant *p_self);
	void (*godot_variant_call)(godot_variant *p_self, const godot_string_name *p_method, const godot_variant **p_args, const godot_int p_argument_count, godot_variant *r_return, godot_variant_call_error *r_error);
	void (*godot_variant_evaluate)(godot_variant_operator p_op, const godot_variant *p_a, const godot_variant *p_b, godot_variant *r_return, bool *r_valid);
	void (*godot_variant_set)(godot_variant *p_self, const godot_variant *p_key, const godot_variant *p_value, bool *r_valid);
	void (*godot_variant_set_named)(godot_variant *p_self, const godot_string_name *p_name, const godot_variant *p_value, bool *r_valid);
	void (*godot_variant_set_keyed)(godot_variant *p_self, const godot_variant *p_key, const godot_variant *p_value, bool *r_valid);
	void (*godot_variant_set_indexed)(godot_variant *p_self, godot_int p_index, const godot_variant *p_value, bool *r_valid, bool *r_oob);
	godot_variant (*godot_variant_get)(const godot_variant *p_self, const godot_variant *p_key, bool *r_valid);
	godot_variant (*godot_variant_get_named)(const godot_variant *p_self, const godot_string_name *p_key, bool *r_valid);
	godot_variant (*godot_variant_get_keyed)(const godot_variant *p_self, const godot_variant *p_key, bool *r_valid);
	godot_variant (*godot_variant_get_indexed)(const godot_variant *p_self, godot_int p_index, bool *r_valid, bool *r_oob);
	bool (*godot_variant_iter_init)(const godot_variant *p_self, godot_variant *r_iter, bool *r_valid);
	bool (*godot_variant_iter_next)(const godot_variant *p_self, godot_variant *r_iter, bool *r_valid);
	godot_variant (*godot_variant_iter_get)(const godot_variant *p_self, godot_variant *r_iter, bool *r_valid);
	godot_bool (*godot_variant_hash_compare)(const godot_variant *p_self, const godot_variant *p_other);
	godot_bool (*godot_variant_booleanize)(const godot_variant *p_self);
	void (*godot_variant_blend)(const godot_variant *p_a, const godot_variant *p_b, float p_c, godot_variant *r_dst);
	void (*godot_variant_interpolate)(const godot_variant *p_a, const godot_variant *p_b, float p_c, godot_variant *r_dst);
	godot_variant (*godot_variant_duplicate)(const godot_variant *p_self, godot_bool p_deep);
	godot_string (*godot_variant_stringify)(const godot_variant *p_self);
	godot_validated_operator_evaluator (*godot_variant_get_validated_operator_evaluator)(godot_variant_operator p_operator, godot_variant_type p_type_a, godot_variant_type p_type_b);
	godot_ptr_operator_evaluator (*godot_variant_get_ptr_operator_evaluator)(godot_variant_operator p_operator, godot_variant_type p_type_a, godot_variant_type p_type_b);
	godot_variant_type (*godot_variant_get_operator_return_type)(godot_variant_operator p_operator, godot_variant_type p_type_a, godot_variant_type p_type_b);
	godot_string (*godot_variant_get_operator_name)(godot_variant_operator p_operator);
	bool (*godot_variant_has_builtin_method)(godot_variant_type p_type, const godot_string_name *p_method);
	bool (*godot_variant_has_builtin_method_with_cstring)(godot_variant_type p_type, const char *p_method);
	godot_validated_builtin_method (*godot_variant_get_validated_builtin_method)(godot_variant_type p_type, const godot_string_name *p_method);
	godot_validated_builtin_method (*godot_variant_get_validated_builtin_method_with_cstring)(godot_variant_type p_type, const char *p_method);
	godot_ptr_builtin_method (*godot_variant_get_ptr_builtin_method)(godot_variant_type p_type, const godot_string_name *p_method);
	godot_ptr_builtin_method (*godot_variant_get_ptr_builtin_method_with_cstring)(godot_variant_type p_type, const char *p_method);
	int (*godot_variant_get_builtin_method_argument_count)(godot_variant_type p_type, const godot_string_name *p_method);
	int (*godot_variant_get_builtin_method_argument_count_with_cstring)(godot_variant_type p_type, const char *p_method);
	godot_variant_type (*godot_variant_get_builtin_method_argument_type)(godot_variant_type p_type, const godot_string_name *p_method, int p_argument);
	godot_variant_type (*godot_variant_get_builtin_method_argument_type_with_cstring)(godot_variant_type p_type, const char *p_method, int p_argument);
	godot_string (*godot_variant_get_builtin_method_argument_name)(godot_variant_type p_type, const godot_string_name *p_method, int p_argument);
	godot_string (*godot_variant_get_builtin_method_argument_name_with_cstring)(godot_variant_type p_type, const char *p_method, int p_argument);
	bool (*godot_variant_has_builtin_method_return_value)(godot_variant_type p_type, const godot_string_name *p_method);
	bool (*godot_variant_has_builtin_method_return_value_with_cstring)(godot_variant_type p_type, const char *p_method);
	godot_variant_type (*godot_variant_get_builtin_method_return_type)(godot_variant_type p_type, const godot_string_name *p_method);
	godot_variant_type (*godot_variant_get_builtin_method_return_type_with_cstring)(godot_variant_type p_type, const char *p_method);
	bool (*godot_variant_is_builtin_method_const)(godot_variant_type p_type, const godot_string_name *p_method);
	bool (*godot_variant_is_builtin_method_const_with_cstring)(godot_variant_type p_type, const char *p_method);
	bool (*godot_variant_is_builtin_method_vararg)(godot_variant_type p_type, const godot_string_name *p_method);
	bool (*godot_variant_is_builtin_method_vararg_with_cstring)(godot_variant_type p_type, const char *p_method);
	int (*godot_variant_get_builtin_method_count)(godot_variant_type p_type);
	void (*godot_variant_get_builtin_method_list)(godot_variant_type p_type, godot_string_name *r_list);
	int (*godot_variant_get_constructor_count)(godot_variant_type p_type);
	godot_validated_constructor (*godot_variant_get_validated_constructor)(godot_variant_type p_type, int p_constructor);
	godot_ptr_constructor (*godot_variant_get_ptr_constructor)(godot_variant_type p_type, int p_constructor);
	int (*godot_variant_get_constructor_argument_count)(godot_variant_type p_type, int p_constructor);
	godot_variant_type (*godot_variant_get_constructor_argument_type)(godot_variant_type p_type, int p_constructor, int p_argument);
	godot_string (*godot_variant_get_constructor_argument_name)(godot_variant_type p_type, int p_constructor, int p_argument);
	void (*godot_variant_construct)(godot_variant_type p_type, godot_variant *p_base, const godot_variant **p_args, int p_argument_count, godot_variant_call_error *r_error);
	godot_variant_type (*godot_variant_get_member_type)(godot_variant_type p_type, const godot_string_name *p_member);
	godot_variant_type (*godot_variant_get_member_type_with_cstring)(godot_variant_type p_type, const char *p_member);
	int (*godot_variant_get_member_count)(godot_variant_type p_type);
	void (*godot_variant_get_member_list)(godot_variant_type p_type, godot_string_name *r_list);
	godot_validated_setter (*godot_variant_get_validated_setter)(godot_variant_type p_type, const godot_string_name *p_member);
	godot_validated_setter (*godot_variant_get_validated_setter_with_cstring)(godot_variant_type p_type, const char *p_member);
	godot_validated_getter (*godot_variant_get_validated_getter)(godot_variant_type p_type, const godot_string_name *p_member);
	godot_validated_getter (*godot_variant_get_validated_getter_with_cstring)(godot_variant_type p_type, const char *p_member);
	godot_ptr_setter (*godot_variant_get_ptr_setter)(godot_variant_type p_type, const godot_string_name *p_member);
	godot_ptr_setter (*godot_variant_get_ptr_setter_with_cstring)(godot_variant_type p_type, const char *p_member);
	godot_ptr_getter (*godot_variant_get_ptr_getter)(godot_variant_type p_type, const godot_string_name *p_member);
	godot_ptr_getter (*godot_variant_get_ptr_getter_with_cstring)(godot_variant_type p_type, const char *p_member);
	bool (*godot_variant_has_indexing)(godot_variant_type p_type);
	godot_variant_type (*godot_variant_get_indexed_element_type)(godot_variant_type p_type);
	godot_validated_indexed_setter (*godot_variant_get_validated_indexed_setter)(godot_variant_type p_type);
	godot_validated_indexed_getter (*godot_variant_get_validated_indexed_getter)(godot_variant_type p_type);
	godot_ptr_indexed_setter (*godot_variant_get_ptr_indexed_setter)(godot_variant_type p_type);
	godot_ptr_indexed_getter (*godot_variant_get_ptr_indexed_getter)(godot_variant_type p_type);
	uint64_t (*godot_variant_get_indexed_size)(const godot_variant *p_self);
	bool (*godot_variant_is_keyed)(godot_variant_type p_type);
	godot_validated_keyed_setter (*godot_variant_get_validated_keyed_setter)(godot_variant_type p_type);
	godot_validated_keyed_getter (*godot_variant_get_validated_keyed_getter)(godot_variant_type p_type);
	godot_validated_keyed_checker (*godot_variant_get_validated_keyed_checker)(godot_variant_type p_type);
	godot_ptr_keyed_setter (*godot_variant_get_ptr_keyed_setter)(godot_variant_type p_type);
	godot_ptr_keyed_getter (*godot_variant_get_ptr_keyed_getter)(godot_variant_type p_type);
	godot_ptr_keyed_checker (*godot_variant_get_ptr_keyed_checker)(godot_variant_type p_type);
	int (*godot_variant_get_constants_count)(godot_variant_type p_type);
	void (*godot_variant_get_constants_list)(godot_variant_type p_type, godot_string_name *r_list);
	bool (*godot_variant_has_constant)(godot_variant_type p_type, const godot_string_name *p_constant);
	bool (*godot_variant_has_constant_with_cstring)(godot_variant_type p_type, const char *p_constant);
	godot_variant (*godot_variant_get_constant_value)(godot_variant_type p_type, const godot_string_name *p_constant);
	godot_variant (*godot_variant_get_constant_value_with_cstring)(godot_variant_type p_type, const char *p_constant);
	bool (*godot_variant_has_utility_function)(const godot_string_name *p_function);
	bool (*godot_variant_has_utility_function_with_cstring)(const char *p_function);
	void (*godot_variant_call_utility_function)(const godot_string_name *p_function, godot_variant *r_ret, const godot_variant **p_args, int p_argument_count, godot_variant_call_error *r_error);
	void (*godot_variant_call_utility_function_with_cstring)(const char *p_function, godot_variant *r_ret, const godot_variant **p_args, int p_argument_count, godot_variant_call_error *r_error);
	godot_ptr_utility_function (*godot_variant_get_ptr_utility_function)(const godot_string_name *p_function);
	godot_ptr_utility_function (*godot_variant_get_ptr_utility_function_with_cstring)(const char *p_function);
	godot_validated_utility_function (*godot_variant_get_validated_utility_function)(const godot_string_name *p_function);
	godot_validated_utility_function (*godot_variant_get_validated_utility_function_with_cstring)(const char *p_function);
	godot_variant_utility_function_type (*godot_variant_get_utility_function_type)(const godot_string_name *p_function);
	godot_variant_utility_function_type (*godot_variant_get_utility_function_type_with_cstring)(const char *p_function);
	int (*godot_variant_get_utility_function_argument_count)(const godot_string_name *p_function);
	int (*godot_variant_get_utility_function_argument_count_with_cstring)(const char *p_function);
	godot_variant_type (*godot_variant_get_utility_function_argument_type)(const godot_string_name *p_function, int p_argument);
	godot_variant_type (*godot_variant_get_utility_function_argument_type_with_cstring)(const char *p_function, int p_argument);
	godot_string (*godot_variant_get_utility_function_argument_name)(const godot_string_name *p_function, int p_argument);
	godot_string (*godot_variant_get_utility_function_argument_name_with_cstring)(const char *p_function, int p_argument);
	bool (*godot_variant_has_utility_function_return_value)(const godot_string_name *p_function);
	bool (*godot_variant_has_utility_function_return_value_with_cstring)(const char *p_function);
	godot_variant_type (*godot_variant_get_utility_function_return_type)(const godot_string_name *p_function);
	godot_variant_type (*godot_variant_get_utility_function_return_type_with_cstring)(const char *p_function);
	bool (*godot_variant_is_utility_function_vararg)(const godot_string_name *p_function);
	bool (*godot_variant_is_utility_function_vararg_with_cstring)(const char *p_function);
	int (*godot_variant_get_utility_function_count)();
	void (*godot_variant_get_utility_function_list)(godot_string_name *r_functions);
	godot_variant_type (*godot_variant_get_type)(const godot_variant *p_self);
	bool (*godot_variant_has_method)(const godot_variant *p_self, const godot_string_name *p_method);
	bool (*godot_variant_has_member)(godot_variant_type p_type, const godot_string_name *p_member);
	bool (*godot_variant_has_key)(const godot_variant *p_self, const godot_variant *p_key, bool *r_valid);
	godot_string (*godot_variant_get_type_name)(godot_variant_type p_type);
	bool (*godot_variant_can_convert)(godot_variant_type p_from, godot_variant_type p_to);
	bool (*godot_variant_can_convert_strict)(godot_variant_type p_from, godot_variant_type p_to);
	void (*godot_aabb_new)(godot_aabb *p_self);
	void (*godot_array_new)(godot_array *p_self);
	void (*godot_array_destroy)(godot_array *p_self);
	godot_variant *(*godot_array_operator_index)(godot_array *p_self, godot_int p_index);
	const godot_variant *(*godot_array_operator_index_const)(const godot_array *p_self, godot_int p_index);
	void (*godot_basis_new)(godot_basis *p_self);
	godot_vector3 *(*godot_basis_operator_index)(godot_basis *p_self, godot_int p_index);
	const godot_vector3 *(*godot_basis_operator_index_const)(const godot_basis *p_self, godot_int p_index);
	void (*godot_callable_new)(godot_callable *p_self);
	void (*godot_callable_destroy)(godot_callable *p_self);
	void (*godot_color_new)(godot_color *p_self);
	float *(*godot_color_operator_index)(godot_color *p_self, godot_int p_index);
	const float *(*godot_color_operator_index_const)(const godot_color *p_self, godot_int p_index);
	void (*godot_dictionary_new)(godot_dictionary *p_self);
	void (*godot_dictionary_destroy)(godot_dictionary *p_self);
	godot_variant *(*godot_dictionary_operator_index)(godot_dictionary *p_self, const godot_variant *p_key);
	const godot_variant *(*godot_dictionary_operator_index_const)(const godot_dictionary *p_self, const godot_variant *p_key);
	void (*godot_node_path_new)(godot_node_path *p_self);
	void (*godot_node_path_destroy)(godot_node_path *p_self);
	void (*godot_packed_byte_array_new)(godot_packed_byte_array *p_self);
	void (*godot_packed_byte_array_destroy)(godot_packed_byte_array *p_self);
	uint8_t *(*godot_packed_byte_array_operator_index)(godot_packed_byte_array *p_self, godot_int p_index);
	const uint8_t *(*godot_packed_byte_array_operator_index_const)(const godot_packed_byte_array *p_self, godot_int p_index);
	void (*godot_packed_int32_array_new)(godot_packed_int32_array *p_self);
	void (*godot_packed_int32_array_destroy)(godot_packed_int32_array *p_self);
	int32_t *(*godot_packed_int32_array_operator_index)(godot_packed_int32_array *p_self, godot_int p_index);
	const int32_t *(*godot_packed_int32_array_operator_index_const)(const godot_packed_int32_array *p_self, godot_int p_index);
	void (*godot_packed_int64_array_new)(godot_packed_int64_array *p_self);
	void (*godot_packed_int64_array_destroy)(godot_packed_int64_array *p_self);
	int64_t *(*godot_packed_int64_array_operator_index)(godot_packed_int64_array *p_self, godot_int p_index);
	const int64_t *(*godot_packed_int64_array_operator_index_const)(const godot_packed_int64_array *p_self, godot_int p_index);
	void (*godot_packed_float32_array_new)(godot_packed_float32_array *p_self);
	void (*godot_packed_float32_array_destroy)(godot_packed_float32_array *p_self);
	float *(*godot_packed_float32_array_operator_index)(godot_packed_float32_array *p_self, godot_int p_index);
	const float *(*godot_packed_float32_array_operator_index_const)(const godot_packed_float32_array *p_self, godot_int p_index);
	void (*godot_packed_float64_array_new)(godot_packed_float64_array *p_self);
	void (*godot_packed_float64_array_destroy)(godot_packed_float64_array *p_self);
	double *(*godot_packed_float64_array_operator_index)(godot_packed_float64_array *p_self, godot_int p_index);
	const double *(*godot_packed_float64_array_operator_index_const)(const godot_packed_float64_array *p_self, godot_int p_index);
	void (*godot_packed_string_array_new)(godot_packed_string_array *p_self);
	void (*godot_packed_string_array_destroy)(godot_packed_string_array *p_self);
	godot_string *(*godot_packed_string_array_operator_index)(godot_packed_string_array *p_self, godot_int p_index);
	const godot_string *(*godot_packed_string_array_operator_index_const)(const godot_packed_string_array *p_self, godot_int p_index);
	void (*godot_packed_vector2_array_new)(godot_packed_vector2_array *p_self);
	void (*godot_packed_vector2_array_destroy)(godot_packed_vector2_array *p_self);
	godot_vector2 *(*godot_packed_vector2_array_operator_index)(godot_packed_vector2_array *p_self, godot_int p_index);
	const godot_vector2 *(*godot_packed_vector2_array_operator_index_const)(const godot_packed_vector2_array *p_self, godot_int p_index);
	void (*godot_packed_vector2i_array_new)(godot_packed_vector2i_array *p_self);
	void (*godot_packed_vector2i_array_destroy)(godot_packed_vector2i_array *p_self);
	godot_vector2i *(*godot_packed_vector2i_array_operator_index)(godot_packed_vector2i_array *p_self, godot_int p_index);
	const godot_vector2i *(*godot_packed_vector2i_array_operator_index_const)(const godot_packed_vector2i_array *p_self, godot_int p_index);
	void (*godot_packed_vector3_array_new)(godot_packed_vector3_array *p_self);
	void (*godot_packed_vector3_array_destroy)(godot_packed_vector3_array *p_self);
	godot_vector3 *(*godot_packed_vector3_array_operator_index)(godot_packed_vector3_array *p_self, godot_int p_index);
	const godot_vector3 *(*godot_packed_vector3_array_operator_index_const)(const godot_packed_vector3_array *p_self, godot_int p_index);
	void (*godot_packed_vector3i_array_new)(godot_packed_vector3i_array *p_self);
	void (*godot_packed_vector3i_array_destroy)(godot_packed_vector3i_array *p_self);
	godot_vector3i *(*godot_packed_vector3i_array_operator_index)(godot_packed_vector3i_array *p_self, godot_int p_index);
	const godot_vector3i *(*godot_packed_vector3i_array_operator_index_const)(const godot_packed_vector3i_array *p_self, godot_int p_index);
	void (*godot_packed_color_array_new)(godot_packed_color_array *p_self);
	void (*godot_packed_color_array_destroy)(godot_packed_color_array *p_self);
	godot_color *(*godot_packed_color_array_operator_index)(godot_packed_color_array *p_self, godot_int p_index);
	const godot_color *(*godot_packed_color_array_operator_index_const)(const godot_packed_color_array *p_self, godot_int p_index);
	void (*godot_plane_new)(godot_plane *p_self);
	void (*godot_quat_new)(godot_quat *p_self);
	godot_real_t *(*godot_quat_operator_index)(godot_quat *p_self, godot_int p_index);
	const godot_real_t *(*godot_quat_operator_index_const)(const godot_quat *p_self, godot_int p_index);
	void (*godot_rect2_new)(godot_rect2 *p_self);
	void (*godot_rect2i_new)(godot_rect2i *p_self);
	void (*godot_rid_new)(godot_rid *p_self);
	void (*godot_signal_new)(godot_signal *p_self);
	void (*godot_signal_destroy)(godot_signal *p_self);
	void (*godot_string_new)(godot_string *r_dest);
	void (*godot_string_new_copy)(godot_string *r_dest, const godot_string *p_src);
	void (*godot_string_destroy)(godot_string *p_self);
	void (*godot_string_new_with_latin1_chars)(godot_string *r_dest, const char *p_contents);
	void (*godot_string_new_with_utf8_chars)(godot_string *r_dest, const char *p_contents);
	void (*godot_string_new_with_utf16_chars)(godot_string *r_dest, const char16_t *p_contents);
	void (*godot_string_new_with_utf32_chars)(godot_string *r_dest, const char32_t *p_contents);
	void (*godot_string_new_with_wide_chars)(godot_string *r_dest, const wchar_t *p_contents);
	void (*godot_string_new_with_latin1_chars_and_len)(godot_string *r_dest, const char *p_contents, const int p_size);
	void (*godot_string_new_with_utf8_chars_and_len)(godot_string *r_dest, const char *p_contents, const int p_size);
	void (*godot_string_new_with_utf16_chars_and_len)(godot_string *r_dest, const char16_t *p_contents, const int p_size);
	void (*godot_string_new_with_utf32_chars_and_len)(godot_string *r_dest, const char32_t *p_contents, const int p_size);
	void (*godot_string_new_with_wide_chars_and_len)(godot_string *r_dest, const wchar_t *p_contents, const int p_size);
	void (*godot_string_name_new)(godot_string_name *r_dest);
	void (*godot_string_name_new_copy)(godot_string_name *r_dest, const godot_string_name *p_src);
	void (*godot_string_name_destroy)(godot_string_name *p_self);
	void (*godot_string_name_new_with_latin1_chars)(godot_string_name *r_dest, const char *p_contents);
	void (*godot_transform_new)(godot_transform *r_dest);
	void (*godot_transform2d_new)(godot_transform2d *r_dest);
	godot_vector2 *(*godot_transform2d_operator_index)(godot_transform2d *p_self, godot_int p_index);
	const godot_vector2 *(*godot_transform2d_operator_index_const)(const godot_transform2d *p_self, godot_int p_index);
	void (*godot_vector2_new)(godot_vector2 *r_dest);
	godot_real_t *(*godot_vector2_operator_index)(godot_vector2 *p_self, godot_int p_index);
	const godot_real_t *(*godot_vector2_operator_index_const)(const godot_vector2 *p_self, godot_int p_index);
	void (*godot_vector2i_new)(godot_vector2i *r_dest);
	int32_t *(*godot_vector2i_operator_index)(godot_vector2i *p_self, godot_int p_index);
	const int32_t *(*godot_vector2i_operator_index_const)(const godot_vector2i *p_self, godot_int p_index);
	void (*godot_vector3_new)(godot_vector3 *r_dest);
	godot_real_t *(*godot_vector3_operator_index)(godot_vector3 *p_self, godot_int p_index);
	const godot_real_t *(*godot_vector3_operator_index_const)(const godot_vector3 *p_self, godot_int p_index);
	void (*godot_vector3i_new)(godot_vector3i *r_dest);
	int32_t *(*godot_vector3i_operator_index)(godot_vector3i *p_self, godot_int p_index);
	const int32_t *(*godot_vector3i_operator_index_const)(const godot_vector3i *p_self, godot_int p_index);
} godot_gdnative_core_api_struct;

#ifdef __cplusplus
}
#endif

#endif // GODOT_GDNATIVE_API_STRUCT_H
