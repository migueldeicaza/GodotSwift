//
//  File.c
//  
//
//  Created by Miguel de Icaza on 2/1/21.
//

#include "Godot.h"

// XCode can see the symbol, but at compile time, the symbol "godot_method_bind_ptrcall" is not visible?
void miguel_proxy (godot_method_bind *p_method_bind, const void *p_instance, const void **p_args, void *p_ret)
{
    godot_method_bind_ptrcall(p_method_bind, p_instance, p_args, p_ret);
}
