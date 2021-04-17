/// @description Remove Singleton ID and Free Surfaces From Texture Memory

// Don't clean up uninitialized data if the effect handler object was a duplicate of the existing singleton
if (global.singletonID[? EFFECT_HANDLER] != id) {return;}

remove_singleton_object();
clear_surfaces();

// Re-enable automatic drawing of the application surface
application_surface_draw_enable(false);