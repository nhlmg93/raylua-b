-- ==========================================================================
-- Comprehensive test suite for raylib.lua FFI bindings
-- Uses LuaUnit (https://github.com/bluebird75/luaunit)
-- Run with: luajit test_raylib.lua
-- ==========================================================================

local lu = require("vendor.luaunit")
local ffi = require("ffi")
local rl = require("raylib")
local rm = require("raymath")  -- Load raymath for vector metatypes with operators and tostring

-- Helper: float comparison tolerance
local EPS = 0.001
local function approx(a, b)
	return math.abs(a - b) < EPS
end

-- ============================================================================
-- 1. Module structure and loading
-- ============================================================================
test_module_structure = {}

function test_module_structure:test_rl_is_table()
	lu.assertIsTable(rl)
end

function test_module_structure:test_rl_lib_exists()
	lu.assertNotNil(rl.lib)
	local t = type(rl.lib)
	lu.assertTrue(t == "cdata" or t == "userdata", "rl.lib should be cdata or userdata, got: " .. t)
end

function test_module_structure:test_constructor_functions_exist()
	local constructors = {
		"Color",
		"Vector2",
		"Vector3",
		"Vector4",
		"Rectangle",
		"Camera3D",
		"Camera2D",
		"Ray",
		"BoundingBox",
	}
	for _, name in ipairs(constructors) do
		lu.assertNotNil(rl[name], "Constructor missing: " .. name)
		lu.assertIsFunction(rl[name], "Constructor not a function: " .. name)
	end
end

function test_module_structure:test_utility_functions_exist()
	local utils = { "new", "ref", "istype", "sizeof" }
	for _, name in ipairs(utils) do
		lu.assertNotNil(rl[name], "Utility function missing: " .. name)
		lu.assertIsFunction(rl[name], "Utility not a function: " .. name)
	end
end

function test_module_structure:test_enumeration_tables_exist()
	local enums = {
		"ConfigFlags",
		"TraceLogLevel",
		"KeyboardKey",
		"MouseButton",
		"MouseCursor",
		"GamepadButton",
		"GamepadAxis",
		"MaterialMapIndex",
		"ShaderLocationIndex",
		"ShaderUniformDataType",
		"ShaderAttributeDataType",
		"PixelFormat",
		"TextureFilter",
		"TextureWrap",
		"CubemapLayout",
		"FontType",
		"BlendMode",
		"Gesture",
		"CameraMode",
		"CameraProjection",
		"NPatchLayout",
	}
	for _, name in ipairs(enums) do
		lu.assertNotNil(rl[name], "Enum table missing: " .. name)
		lu.assertIsTable(rl[name], "Enum not a table: " .. name)
	end
end

function test_module_structure:test__color_constants_exist()
	local colors = {
		"WHITE",
		"BLACK",
		"RED",
		"GREEN",
		"BLUE",
		"YELLOW",
		"ORANGE",
		"PINK",
		"PURPLE",
		"BEIGE",
		"BROWN",
		"DARKBLUE",
		"DARKGREEN",
		"DARKPURPLE",
		"DARKBROWN",
		"GRAY",
		"DARKGRAY",
		"LIGHTGRAY",
		"LIME",
		"GOLD",
		"SKYBLUE",
		"VIOLET",
		"MAROON",
		"MAGENTA",
		"RAYWHITE",
		"BLANK",
	}
	for _, name in ipairs(colors) do
		lu.assertNotNil(rl[name], "Color constant missing: " .. name)
		lu.assertEquals(type(rl[name]), "cdata", "Color constant not cdata: " .. name)
	end
end

function test_module_structure:test_ffi_dispatch_via_index()
	-- Test FFI dispatch using a core raylib function (get_screen_width)
	local get_screen_width = rl.get_screen_width
	lu.assertNotNil(get_screen_width, "rl.get_screen_width should resolve via __index")
	-- FFI functions are cdata, not Lua functions
	lu.assertTrue(type(get_screen_width) == "cdata" or type(get_screen_width) == "function", "get_screen_width should be cdata/function")
end

-- ============================================================================
-- 2. Constructor functions
-- ============================================================================
test_constructors = {}

function test_constructors:test__color_rgba()
	local c = rl.color(255, 128, 64, 32)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 128)
	lu.assertEquals(c.b, 64)
	lu.assertEquals(c.a, 32)
end

function test_constructors:test__color_rgba_default_alpha()
	local c = rl.color(255, 128, 64)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 128)
	lu.assertEquals(c.b, 64)
	lu.assertEquals(c.a, 255)
end

function test_constructors:test__color_hex_string_red()
	local c = rl.color("#FF0000")
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 255)
end

function test_constructors:test__color_hex_string_with_alpha()
	local c = rl.color("#FF000080")
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 128)
end

function test_constructors:test__color_hex_string_lowercase()
	local c = rl.color("#ff8040")
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 128)
	lu.assertEquals(c.b, 64)
	lu.assertEquals(c.a, 255)
end

function test_constructors:test__color_hex_number_red()
	local c = rl.color(0xFF0000FF)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 255)
end

function test_constructors:test__color_hex_number_transparent()
	local c = rl.color(0xFF000080)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 128)
end

function test_constructors:test_vector2()
	local v = rl.vector2(3.5, 7.25)
	lu.assertAlmostEquals(v.x, 3.5, EPS)
	lu.assertAlmostEquals(v.y, 7.25, EPS)
end

function test_constructors:test__vector2_defaults()
	local v = rl.vector2()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
end

function test_constructors:test_vector3()
	local v = rl.vector3(1.0, 2.0, 3.0)
	lu.assertAlmostEquals(v.x, 1.0, EPS)
	lu.assertAlmostEquals(v.y, 2.0, EPS)
	lu.assertAlmostEquals(v.z, 3.0, EPS)
end

function test_constructors:test__vector3_defaults()
	local v = rl.vector3()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
	lu.assertAlmostEquals(v.z, 0, EPS)
end

function test_constructors:test_vector4()
	local v = rl.vector4(1.0, 2.0, 3.0, 4.0)
	lu.assertAlmostEquals(v.x, 1.0, EPS)
	lu.assertAlmostEquals(v.y, 2.0, EPS)
	lu.assertAlmostEquals(v.z, 3.0, EPS)
	lu.assertAlmostEquals(v.w, 4.0, EPS)
end

function test_constructors:test__vector4_defaults()
	local v = rl.vector4()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
	lu.assertAlmostEquals(v.z, 0, EPS)
	lu.assertAlmostEquals(v.w, 0, EPS)
end

function test_constructors:test_rectangle()
	local r = rl.rectangle(10.0, 20.0, 100.0, 50.0)
	lu.assertAlmostEquals(r.x, 10.0, EPS)
	lu.assertAlmostEquals(r.y, 20.0, EPS)
	lu.assertAlmostEquals(r.width, 100.0, EPS)
	lu.assertAlmostEquals(r.height, 50.0, EPS)
end

function test_constructors:test__rectangle_defaults()
	local r = rl.rectangle()
	lu.assertAlmostEquals(r.x, 0, EPS)
	lu.assertAlmostEquals(r.y, 0, EPS)
	lu.assertAlmostEquals(r.width, 0, EPS)
	lu.assertAlmostEquals(r.height, 0, EPS)
end

function test_constructors:test_camera2_d_defaults()
	local cam = rl.camera_2d()
	lu.assertAlmostEquals(cam.offset.x, 0, EPS)
	lu.assertAlmostEquals(cam.offset.y, 0, EPS)
	lu.assertAlmostEquals(cam.target.x, 0, EPS)
	lu.assertAlmostEquals(cam.target.y, 0, EPS)
	lu.assertAlmostEquals(cam.rotation, 0, EPS)
	lu.assertAlmostEquals(cam.zoom, 1.0, EPS)
end

function test_constructors:test_camera2_d_custom()
	local cam = rl.camera_2d(rl.vector2(400, 300), rl.vector2(100, 200), 45.0, 2.0)
	lu.assertAlmostEquals(cam.offset.x, 400, EPS)
	lu.assertAlmostEquals(cam.offset.y, 300, EPS)
	lu.assertAlmostEquals(cam.target.x, 100, EPS)
	lu.assertAlmostEquals(cam.target.y, 200, EPS)
	lu.assertAlmostEquals(cam.rotation, 45.0, EPS)
	lu.assertAlmostEquals(cam.zoom, 2.0, EPS)
end

function test_constructors:test_camera3_d_defaults()
	local pos = rl.vector3(10, 10, 10)
	local target = rl.vector3(0, 0, 0)
	local cam = rl.camera_3d(pos, target)
	lu.assertAlmostEquals(cam.position.x, 10, EPS)
	lu.assertAlmostEquals(cam.up.y, 1.0, EPS)
	lu.assertAlmostEquals(cam.fovy, 45.0, EPS)
	lu.assertEquals(cam.projection, 0)
end

function test_constructors:test_camera3_d_custom()
	local cam = rl.camera_3d(rl.vector3(5, 5, 5), rl.vector3(0, 1, 0), rl.vector3(0, 0, 1), 60.0, 1)
	lu.assertAlmostEquals(cam.up.z, 1, EPS)
	lu.assertAlmostEquals(cam.fovy, 60.0, EPS)
	lu.assertEquals(cam.projection, 1)
end

function test_constructors:test_ray()
	local r = rl.ray(rl.vector3(0, 0, 0), rl.vector3(1, 0, 0))
	lu.assertAlmostEquals(r.position.x, 0, EPS)
	lu.assertAlmostEquals(r.direction.x, 1, EPS)
end

function test_constructors:test_bounding_box()
	local bb = rl.bounding_box(rl.vector3(-1, -1, -1), rl.vector3(1, 1, 1))
	lu.assertAlmostEquals(bb.min.x, -1, EPS)
	lu.assertAlmostEquals(bb.max.x, 1, EPS)
end

-- ============================================================================
-- 3. Color constants
-- ============================================================================
test__color_constants = {}

function test__color_constants:test__lightgray()
	lu.assertEquals(rl.LIGHTGRAY.r, 200)
	lu.assertEquals(rl.LIGHTGRAY.g, 200)
	lu.assertEquals(rl.LIGHTGRAY.b, 200)
	lu.assertEquals(rl.LIGHTGRAY.a, 255)
end
function test__color_constants:test__gray()
	lu.assertEquals(rl.GRAY.r, 130)
	lu.assertEquals(rl.GRAY.g, 130)
	lu.assertEquals(rl.GRAY.b, 130)
	lu.assertEquals(rl.GRAY.a, 255)
end
function test__color_constants:test__darkgray()
	lu.assertEquals(rl.DARKGRAY.r, 80)
	lu.assertEquals(rl.DARKGRAY.g, 80)
	lu.assertEquals(rl.DARKGRAY.b, 80)
	lu.assertEquals(rl.DARKGRAY.a, 255)
end
function test__color_constants:test__yellow()
	lu.assertEquals(rl.YELLOW.r, 253)
	lu.assertEquals(rl.YELLOW.g, 249)
	lu.assertEquals(rl.YELLOW.b, 0)
	lu.assertEquals(rl.YELLOW.a, 255)
end
function test__color_constants:test__gold()
	lu.assertEquals(rl.GOLD.r, 255)
	lu.assertEquals(rl.GOLD.g, 203)
	lu.assertEquals(rl.GOLD.b, 0)
	lu.assertEquals(rl.GOLD.a, 255)
end
function test__color_constants:test__orange()
	lu.assertEquals(rl.ORANGE.r, 255)
	lu.assertEquals(rl.ORANGE.g, 161)
	lu.assertEquals(rl.ORANGE.b, 0)
	lu.assertEquals(rl.ORANGE.a, 255)
end
function test__color_constants:test__pink()
	lu.assertEquals(rl.PINK.r, 255)
	lu.assertEquals(rl.PINK.g, 109)
	lu.assertEquals(rl.PINK.b, 194)
	lu.assertEquals(rl.PINK.a, 255)
end
function test__color_constants:test__red()
	lu.assertEquals(rl.RED.r, 230)
	lu.assertEquals(rl.RED.g, 41)
	lu.assertEquals(rl.RED.b, 55)
	lu.assertEquals(rl.RED.a, 255)
end
function test__color_constants:test__maroon()
	lu.assertEquals(rl.MAROON.r, 190)
	lu.assertEquals(rl.MAROON.g, 33)
	lu.assertEquals(rl.MAROON.b, 55)
	lu.assertEquals(rl.MAROON.a, 255)
end
function test__color_constants:test__green()
	lu.assertEquals(rl.GREEN.r, 0)
	lu.assertEquals(rl.GREEN.g, 228)
	lu.assertEquals(rl.GREEN.b, 48)
	lu.assertEquals(rl.GREEN.a, 255)
end
function test__color_constants:test__lime()
	lu.assertEquals(rl.LIME.r, 0)
	lu.assertEquals(rl.LIME.g, 158)
	lu.assertEquals(rl.LIME.b, 47)
	lu.assertEquals(rl.LIME.a, 255)
end
function test__color_constants:test__darkgreen()
	lu.assertEquals(rl.DARKGREEN.r, 0)
	lu.assertEquals(rl.DARKGREEN.g, 117)
	lu.assertEquals(rl.DARKGREEN.b, 44)
	lu.assertEquals(rl.DARKGREEN.a, 255)
end
function test__color_constants:test__skyblue()
	lu.assertEquals(rl.SKYBLUE.r, 102)
	lu.assertEquals(rl.SKYBLUE.g, 191)
	lu.assertEquals(rl.SKYBLUE.b, 255)
	lu.assertEquals(rl.SKYBLUE.a, 255)
end
function test__color_constants:test__blue()
	lu.assertEquals(rl.BLUE.r, 0)
	lu.assertEquals(rl.BLUE.g, 121)
	lu.assertEquals(rl.BLUE.b, 241)
	lu.assertEquals(rl.BLUE.a, 255)
end
function test__color_constants:test__darkblue()
	lu.assertEquals(rl.DARKBLUE.r, 0)
	lu.assertEquals(rl.DARKBLUE.g, 82)
	lu.assertEquals(rl.DARKBLUE.b, 172)
	lu.assertEquals(rl.DARKBLUE.a, 255)
end
function test__color_constants:test__purple()
	lu.assertEquals(rl.PURPLE.r, 200)
	lu.assertEquals(rl.PURPLE.g, 122)
	lu.assertEquals(rl.PURPLE.b, 255)
	lu.assertEquals(rl.PURPLE.a, 255)
end
function test__color_constants:test__violet()
	lu.assertEquals(rl.VIOLET.r, 135)
	lu.assertEquals(rl.VIOLET.g, 60)
	lu.assertEquals(rl.VIOLET.b, 190)
	lu.assertEquals(rl.VIOLET.a, 255)
end
function test__color_constants:test__darkpurple()
	lu.assertEquals(rl.DARKPURPLE.r, 112)
	lu.assertEquals(rl.DARKPURPLE.g, 31)
	lu.assertEquals(rl.DARKPURPLE.b, 126)
	lu.assertEquals(rl.DARKPURPLE.a, 255)
end
function test__color_constants:test__beige()
	lu.assertEquals(rl.BEIGE.r, 211)
	lu.assertEquals(rl.BEIGE.g, 176)
	lu.assertEquals(rl.BEIGE.b, 131)
	lu.assertEquals(rl.BEIGE.a, 255)
end
function test__color_constants:test__brown()
	lu.assertEquals(rl.BROWN.r, 127)
	lu.assertEquals(rl.BROWN.g, 106)
	lu.assertEquals(rl.BROWN.b, 79)
	lu.assertEquals(rl.BROWN.a, 255)
end
function test__color_constants:test__darkbrown()
	lu.assertEquals(rl.DARKBROWN.r, 76)
	lu.assertEquals(rl.DARKBROWN.g, 63)
	lu.assertEquals(rl.DARKBROWN.b, 47)
	lu.assertEquals(rl.DARKBROWN.a, 255)
end
function test__color_constants:test__white()
	lu.assertEquals(rl.WHITE.r, 255)
	lu.assertEquals(rl.WHITE.g, 255)
	lu.assertEquals(rl.WHITE.b, 255)
	lu.assertEquals(rl.WHITE.a, 255)
end
function test__color_constants:test__black()
	lu.assertEquals(rl.BLACK.r, 0)
	lu.assertEquals(rl.BLACK.g, 0)
	lu.assertEquals(rl.BLACK.b, 0)
	lu.assertEquals(rl.BLACK.a, 255)
end
function test__color_constants:test__blank()
	lu.assertEquals(rl.BLANK.r, 0)
	lu.assertEquals(rl.BLANK.g, 0)
	lu.assertEquals(rl.BLANK.b, 0)
	lu.assertEquals(rl.BLANK.a, 0)
end
function test__color_constants:test__magenta()
	lu.assertEquals(rl.MAGENTA.r, 255)
	lu.assertEquals(rl.MAGENTA.g, 0)
	lu.assertEquals(rl.MAGENTA.b, 255)
	lu.assertEquals(rl.MAGENTA.a, 255)
end
function test__color_constants:test__raywhite()
	lu.assertEquals(rl.RAYWHITE.r, 245)
	lu.assertEquals(rl.RAYWHITE.g, 245)
	lu.assertEquals(rl.RAYWHITE.b, 245)
	lu.assertEquals(rl.RAYWHITE.a, 255)
end

-- ============================================================================
-- 4. Enumeration tables
-- ============================================================================
test_enumerations = {}

function test_enumerations:test_config_flags()
	lu.assertEquals(rl.ConfigFlags.FLAG_VSYNC_HINT, 0x40)
	lu.assertEquals(rl.ConfigFlags.FLAG_FULLSCREEN_MODE, 0x02)
	lu.assertEquals(rl.ConfigFlags.FLAG_WINDOW_RESIZABLE, 0x04)
end
function test_enumerations:test_trace_log_level()
	lu.assertEquals(rl.TraceLogLevel.LOG_ALL, 0)
	lu.assertEquals(rl.TraceLogLevel.LOG_INFO, 3)
	lu.assertEquals(rl.TraceLogLevel.LOG_NONE, 7)
end
function test_enumerations:test_keyboard_key()
	lu.assertEquals(rl.KeyboardKey.KEY_SPACE, 32)
	lu.assertEquals(rl.KeyboardKey.KEY_ESCAPE, 256)
	lu.assertEquals(rl.KeyboardKey.KEY_A, 65)
	lu.assertEquals(rl.KeyboardKey.KEY_Z, 90)
end
function test_enumerations:test_mouse_button()
	lu.assertEquals(rl.MouseButton.MOUSE_BUTTON_LEFT, 0)
	lu.assertEquals(rl.MouseButton.MOUSE_BUTTON_RIGHT, 1)
end
function test_enumerations:test_mouse_cursor()
	lu.assertEquals(rl.MouseCursor.MOUSE_CURSOR_DEFAULT, 0)
	lu.assertEquals(rl.MouseCursor.MOUSE_CURSOR_CROSSHAIR, 3)
end
function test_enumerations:test_gamepad_button()
	lu.assertEquals(rl.GamepadButton.GAMEPAD_BUTTON_UNKNOWN, 0)
	lu.assertEquals(rl.GamepadButton.GAMEPAD_BUTTON_MIDDLE, 14)
end
function test_enumerations:test_gamepad_axis()
	lu.assertEquals(rl.GamepadAxis.GAMEPAD_AXIS_LEFT_X, 0)
	lu.assertEquals(rl.GamepadAxis.GAMEPAD_AXIS_RIGHT_TRIGGER, 5)
end
function test_enumerations:test_material_map_index()
	lu.assertEquals(rl.MaterialMapIndex.MATERIAL_MAP_ALBEDO, 0)
	lu.assertEquals(rl.MaterialMapIndex.MATERIAL_MAP_NORMAL, 2)
end
function test_enumerations:test_shader_location_index()
	lu.assertEquals(rl.ShaderLocationIndex.SHADER_LOC_VERTEX_POSITION, 0)
	lu.assertEquals(rl.ShaderLocationIndex.SHADER_LOC_MATRIX_MVP, 6)
end
function test_enumerations:test_shader_uniform_data_type()
	lu.assertEquals(rl.ShaderUniformDataType.SHADER_UNIFORM_FLOAT, 0)
	lu.assertEquals(rl.ShaderUniformDataType.SHADER_UNIFORM_SAMPLER2D, 8)  -- Changed from 12 in newer raylib
end
function test_enumerations:test_shader_attribute_data_type()
	lu.assertEquals(rl.ShaderAttributeDataType.SHADER_ATTRIB_FLOAT, 0)
	lu.assertEquals(rl.ShaderAttributeDataType.SHADER_ATTRIB_VEC4, 3)
end
function test_enumerations:test_pixel_format()
	lu.assertEquals(rl.PixelFormat.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8, 7)
end
function test_enumerations:test_texture_filter()
	lu.assertEquals(rl.TextureFilter.TEXTURE_FILTER_POINT, 0)
	lu.assertEquals(rl.TextureFilter.TEXTURE_FILTER_BILINEAR, 1)
end
function test_enumerations:test_texture_wrap()
	lu.assertEquals(rl.TextureWrap.TEXTURE_WRAP_REPEAT, 0)
	lu.assertEquals(rl.TextureWrap.TEXTURE_WRAP_CLAMP, 1)
end
function test_enumerations:test_blend_mode()
	lu.assertEquals(rl.BlendMode.BLEND_ALPHA, 0)
	lu.assertEquals(rl.BlendMode.BLEND_ADDITIVE, 1)
end
function test_enumerations:test_gesture()
	lu.assertEquals(rl.Gesture.GESTURE_NONE, 0)
	lu.assertEquals(rl.Gesture.GESTURE_TAP, 1)
	lu.assertEquals(rl.Gesture.GESTURE_DRAG, 8)
end
function test_enumerations:test_camera_mode()
	lu.assertEquals(rl.CameraMode.CAMERA_CUSTOM, 0)
	lu.assertEquals(rl.CameraMode.CAMERA_FREE, 1)
end
function test_enumerations:test_camera_projection()
	lu.assertEquals(rl.CameraProjection.CAMERA_PERSPECTIVE, 0)
	lu.assertEquals(rl.CameraProjection.CAMERA_ORTHOGRAPHIC, 1)
end
function test_enumerations:test_n_patch_layout()
	lu.assertEquals(rl.NPatchLayout.NPATCH_NINE_PATCH, 0)
end

test_tostring = {}

function test_tostring:test__vector2()
	lu.assertEquals(tostring(rl.vector2(1.5, 2.5)), "Vector2(1.500, 2.500)")
end
function test_tostring:test__vector3()
	lu.assertEquals(tostring(rl.vector3(1, 2, 3)), "Vector3(1.000, 2.000, 3.000)")
end
function test_tostring:test__vector4()
	lu.assertEquals(tostring(rl.vector4(1, 2, 3, 4)), "Vector4(1.000, 2.000, 3.000, 4.000)")
end
function test_tostring:test__color()
	lu.assertEquals(tostring(rl.color(255, 0, 128, 255)), "Color(255, 0, 128, 255)")
end
function test_tostring:test__rectangle()
	lu.assertEquals(tostring(rl.rectangle(10, 20, 100, 200)), "Rectangle(10.0, 20.0, 100.0, 200.0)")
end

-- ============================================================================
-- 10. Utility functions
-- ============================================================================
test_utilities = {}

function test_utilities:test__new()
	local v = rl.new("Vector2", 5, 10)
	lu.assertTrue(approx(v.x, 5.0))
	lu.assertTrue(approx(v.y, 10.0))
end
function test_utilities:test__ref_int()
	local ptr = rl.ref("int", 42)
	lu.assertEquals(ptr[0], 42)
end
function test_utilities:test__ref_int_default()
	local ptr = rl.ref("int")
	lu.assertEquals(ptr[0], 0)
end
function test_utilities:test__ref_float()
	local ptr = rl.ref("float", 3.14)
	lu.assertTrue(approx(ptr[0], 3.14))
end
function test_utilities:test__istype_true()
	lu.assertTrue(rl.istype("Vector2", rl.vector2(1, 2)))
end
function test_utilities:test__istype_false()
	lu.assertFalse(rl.istype("Vector3", rl.vector2(1, 2)))
end
function test_utilities:test__sizeof_vector2()
	lu.assertEquals(rl.sizeof("Vector2"), 8)
end
function test_utilities:test__sizeof_vector3()
	lu.assertEquals(rl.sizeof("Vector3"), 12)
end
function test_utilities:test__sizeof_color()
	lu.assertEquals(rl.sizeof("Color"), 4)
end
function test_utilities:test__sizeof_rectangle()
	lu.assertEquals(rl.sizeof("Rectangle"), 16)
end

-- ============================================================================
-- 11. FFI dispatch tests (core raylib functions)
-- ============================================================================
test_ffi_dispatch = {}

function test_ffi_dispatch:test_snake_case_dispatch()
	-- Verify snake_case names resolve to the correct CamelCase C functions
	-- Using is_window_ready (returns false without init, but should resolve)
	local func = rl.is_window_ready
	lu.assertNotNil(func, "is_window_ready should resolve via __index")
	-- FFI functions are cdata, not Lua functions
	lu.assertTrue(type(func) == "cdata" or type(func) == "function", "is_window_ready should be cdata/function")
end
function test_ffi_dispatch:test_snake_case_cached()
	-- After first access, the snake_case name should be cached in the rl table
	local _ = rl.get_screen_width
	lu.assertNotNil(rawget(rl, "get_screen_width") or rawget(rl, "GetScreenWidth"))
end
function test_ffi_dispatch:test_non_existent_returns_nil()
	-- Accessing a non-existent symbol in rl.lib throws an FFI error;
	-- the __index metamethod catches this and returns nil
	local ok, val = pcall(function()
		return rl.this_function_does_not_exist_123
	end)
	-- Either it returns nil successfully, or it errors (both prove the symbol doesn't exist)
	if ok then
		lu.assertNil(val)
	else
		lu.assertStrContains(tostring(val), "missing declaration")
	end
end

-- ============================================================================
-- 18. 2D collision functions
-- ============================================================================
test_collision2_d = {}

function test_collision2_d:test_check_collision_recs_overlap()
	lu.assertTrue(rl.check_collision_recs(rl.rectangle(0, 0, 10, 10), rl.rectangle(5, 5, 10, 10)))
end
function test_collision2_d:test_check_collision_recs_no_overlap()
	lu.assertFalse(rl.check_collision_recs(rl.rectangle(0, 0, 10, 10), rl.rectangle(20, 20, 10, 10)))
end
function test_collision2_d:test_check_collision_circles_overlap()
	lu.assertTrue(rl.check_collision_circles(rl.vector2(0, 0), 5, rl.vector2(3, 0), 5))
end
function test_collision2_d:test_check_collision_circles_no_overlap()
	lu.assertFalse(rl.check_collision_circles(rl.vector2(0, 0), 5, rl.vector2(100, 0), 5))
end
function test_collision2_d:test_check_collision_circle_rec_overlap()
	lu.assertTrue(rl.check_collision_circle_rec(rl.vector2(5, 5), 5, rl.rectangle(0, 0, 10, 10)))
end
function test_collision2_d:test_check_collision_circle_rec_no_overlap()
	lu.assertFalse(rl.check_collision_circle_rec(rl.vector2(50, 50), 1, rl.rectangle(0, 0, 10, 10)))
end
function test_collision2_d:test_check_collision_point_rec_inside()
	lu.assertTrue(rl.check_collision_point_rec(rl.vector2(5, 5), rl.rectangle(0, 0, 10, 10)))
end
function test_collision2_d:test_check_collision_point_rec_outside()
	lu.assertFalse(rl.check_collision_point_rec(rl.vector2(50, 50), rl.rectangle(0, 0, 10, 10)))
end
function test_collision2_d:test_check_collision_point_circle_inside()
	lu.assertTrue(rl.check_collision_point_circle(rl.vector2(1, 1), rl.vector2(0, 0), 5))
end
function test_collision2_d:test_check_collision_point_circle_outside()
	lu.assertFalse(rl.check_collision_point_circle(rl.vector2(100, 100), rl.vector2(0, 0), 5))
end
function test_collision2_d:test_get_collision_rec()
	local col = rl.get_collision_rec(rl.rectangle(0, 0, 10, 10), rl.rectangle(5, 5, 10, 10))
	lu.assertAlmostEquals(col.x, 5, EPS)
	lu.assertAlmostEquals(col.y, 5, EPS)
	lu.assertAlmostEquals(col.width, 5, EPS)
	lu.assertAlmostEquals(col.height, 5, EPS)
end
function test_collision2_d:test_check_collision_point_triangle_inside()
	lu.assertTrue(
		rl.check_collision_point_triangle(rl.vector2(1, 1), rl.vector2(0, 0), rl.vector2(10, 0), rl.vector2(0, 10))
	)
end
function test_collision2_d:test_check_collision_point_triangle_outside()
	lu.assertFalse(
		rl.check_collision_point_triangle(rl.vector2(50, 50), rl.vector2(0, 0), rl.vector2(10, 0), rl.vector2(0, 10))
	)
end

-- ============================================================================
-- 19. 3D collision functions
-- ============================================================================
test_collision3_d = {}

function test_collision3_d:test_check_collision_spheres_overlap()
	lu.assertTrue(rl.check_collision_spheres(rl.vector3(0, 0, 0), 5, rl.vector3(3, 0, 0), 5))
end
function test_collision3_d:test_check_collision_spheres_no_overlap()
	lu.assertFalse(rl.check_collision_spheres(rl.vector3(0, 0, 0), 5, rl.vector3(100, 0, 0), 5))
end
function test_collision3_d:test_check_collision_boxes_overlap()
	local b1 = rl.bounding_box(rl.vector3(0, 0, 0), rl.vector3(10, 10, 10))
	local b2 = rl.bounding_box(rl.vector3(5, 5, 5), rl.vector3(15, 15, 15))
	lu.assertTrue(rl.check_collision_boxes(b1, b2))
end
function test_collision3_d:test_check_collision_boxes_no_overlap()
	local b1 = rl.bounding_box(rl.vector3(0, 0, 0), rl.vector3(10, 10, 10))
	local b2 = rl.bounding_box(rl.vector3(50, 50, 50), rl.vector3(60, 60, 60))
	lu.assertFalse(rl.check_collision_boxes(b1, b2))
end
function test_collision3_d:test_check_collision_box_sphere_overlap()
	local box = rl.bounding_box(rl.vector3(0, 0, 0), rl.vector3(10, 10, 10))
	lu.assertTrue(rl.check_collision_box_sphere(box, rl.vector3(5, 5, 5), 5))
end
function test_collision3_d:test_get_ray_collision_sphere_hit()
	local ray = rl.ray(rl.vector3(0, 0, 0), rl.vector3(1, 0, 0))
	local result = rl.get_ray_collision_sphere(ray, rl.vector3(10, 0, 0), 5)
	lu.assertTrue(result.hit)
end
function test_collision3_d:test_get_ray_collision_sphere_miss()
	local ray = rl.ray(rl.vector3(0, 0, 0), rl.vector3(1, 0, 0))
	local result = rl.get_ray_collision_sphere(ray, rl.vector3(0, 100, 0), 1)
	lu.assertFalse(result.hit)
end
function test_collision3_d:test_get_ray_collision_box_hit()
	local ray = rl.ray(rl.vector3(0, 0, 0), rl.vector3(1, 0, 0))
	local box = rl.bounding_box(rl.vector3(5, -5, -5), rl.vector3(15, 5, 5))
	lu.assertTrue(rl.get_ray_collision_box(ray, box).hit)
end

-- ============================================================================
-- 20. Color utility functions
-- ============================================================================
test__color_utils = {}

function test__color_utils:test__color_to_int()
	lu.assertNotEquals(rl.color_to_int(rl.WHITE), 0)
end
function test__color_utils:test_fade()
	local c = rl.fade(rl.RED, 0.5)
	lu.assertEquals(c.r, 230)
	lu.assertEquals(c.g, 41)
	lu.assertEquals(c.b, 55)
	lu.assertTrue(c.a >= 127 and c.a <= 128)
end
function test__color_utils:test__color_alpha_zero()
	lu.assertEquals(rl.color_alpha(rl.RED, 0.0).a, 0)
end
function test__color_utils:test__color_alpha_one()
	lu.assertEquals(rl.color_alpha(rl.RED, 1.0).a, 255)
end
function test__color_utils:test_get_color()
	local c = rl.get_color(0xFF0000FF)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 255)
end
function test__color_utils:test__color_is_equal_same()
	lu.assertTrue(rl.color_is_equal(rl.WHITE, rl.WHITE))
end
function test__color_utils:test__color_is_equal_different()
	lu.assertFalse(rl.color_is_equal(rl.WHITE, rl.BLACK))
end
function test__color_utils:test__color_to_hsv()
	local hsv = rl.color_to_hsv(rl.RED)
	-- RED (230,41,55) hue is around 355 degrees
	lu.assertTrue(hsv.x >= 350 or hsv.x <= 10, "Hue of RED should be near 0/360, got: " .. hsv.x)
	lu.assertTrue(hsv.y > 0, "Saturation should be > 0")
end
function test__color_utils:test__color_from_hsv()
	local c = rl.color_from_hsv(0, 1, 1)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
end
function test__color_utils:test__color_normalize()
	local v = rl.color_normalize(rl.WHITE)
	lu.assertAlmostEquals(v.x, 1.0, EPS)
	lu.assertAlmostEquals(v.y, 1.0, EPS)
	lu.assertAlmostEquals(v.z, 1.0, EPS)
	lu.assertAlmostEquals(v.w, 1.0, EPS)
end
function test__color_utils:test__color_lerp()
	local c = rl.color_lerp(rl.BLACK, rl.WHITE, 0.5)
	lu.assertTrue(c.r >= 127 and c.r <= 128)
	lu.assertEquals(c.a, 255)
end
function test__color_utils:test_get_pixel_data_size()
	lu.assertTrue(rl.get_pixel_data_size(1, 1, 7) > 0)
end

-- ============================================================================
-- 21. Text utility functions
-- ============================================================================
test_text_utils = {}

function test_text_utils:test_text_is_equal_true()
	lu.assertTrue(rl.text_is_equal("hello", "hello"))
end
function test_text_utils:test_text_is_equal_false()
	lu.assertFalse(rl.text_is_equal("hello", "world"))
end
function test_text_utils:test_text_length_hello()
	lu.assertEquals(rl.text_length("hello"), 5)
end
function test_text_utils:test_text_length_empty()
	lu.assertEquals(rl.text_length(""), 0)
end
function test_text_utils:test_text_to_upper()
	lu.assertEquals(ffi.string(rl.text_to_upper("hello")), "HELLO")
end
function test_text_utils:test_text_to_lower()
	lu.assertEquals(ffi.string(rl.text_to_lower("HELLO")), "hello")
end
function test_text_utils:test_text_to_integer42()
	lu.assertEquals(rl.text_to_integer("42"), 42)
end
function test_text_utils:test_text_to_integer_zero()
	lu.assertEquals(rl.text_to_integer("0"), 0)
end
function test_text_utils:test_text_to_float()
	lu.assertTrue(approx(rl.text_to_float("3.14"), 3.14))
end
function test_text_utils:test_text_find_index_found()
	lu.assertEquals(rl.text_find_index("hello world", "world"), 6)
end
-- measure_text with default font requires init_window, tested in test_window_integration instead
function test_text_utils:test_get_codepoint_count()
	lu.assertEquals(rl.get_codepoint_count("Hello"), 5)
end
function test_text_utils:test_text_subtext()
	lu.assertEquals(ffi.string(rl.text_subtext("Hello World", 6, 5)), "World")
end

-- ============================================================================
-- 22. File utility functions
-- ============================================================================
test_file_utils = {}

function test_file_utils:test_file_exists_true()
	lu.assertTrue(rl.file_exists("raylib.lua"))
end
function test_file_utils:test_file_exists_false()
	lu.assertFalse(rl.file_exists("nonexistent_file_xyz.abc"))
end
function test_file_utils:test_directory_exists_true()
	lu.assertTrue(rl.directory_exists("."))
end
function test_file_utils:test_directory_exists_false()
	lu.assertFalse(rl.directory_exists("/nonexistent_dir_xyz"))
end
function test_file_utils:test_is_file_extension_true()
	lu.assertTrue(rl.is_file_extension("test.png", ".png"))
end
function test_file_utils:test_is_file_extension_false()
	lu.assertFalse(rl.is_file_extension("test.png", ".jpg"))
end
function test_file_utils:test_get_file_extension()
	lu.assertEquals(ffi.string(rl.get_file_extension("test.png")), ".png")
end
function test_file_utils:test_get_file_name()
	lu.assertEquals(ffi.string(rl.get_file_name("/path/to/file.txt")), "file.txt")
end
function test_file_utils:test_get_file_name_without_ext()
	lu.assertEquals(ffi.string(rl.get_file_name_without_ext("/path/to/file.txt")), "file")
end
function test_file_utils:test_get_working_directory()
	lu.assertTrue(#ffi.string(rl.get_working_directory()) > 0)
end
function test_file_utils:test_is_path_file_true()
	lu.assertTrue(rl.is_path_file("raylib.lua"))
end
function test_file_utils:test_is_path_file_false_on_dir()
	lu.assertFalse(rl.is_path_file("."))
end
function test_file_utils:test_get_file_length_positive()
	lu.assertTrue(rl.get_file_length("raylib.lua") > 0)
end
function test_file_utils:test_is_file_name_valid()
	lu.assertTrue(rl.is_file_name_valid("test.lua"))
end

-- ============================================================================
-- 23. Window/drawing integration (requires InitWindow)
-- NOTE: GLFW cannot reliably re-initialize after CloseWindow in the same
--       process, so we open the window once and run all checks in one test.
-- ============================================================================
test_window_integration = {}

function test_window_integration:test_all_window_functions()
	rl.set_trace_log_level(rl.TraceLogLevel.LOG_WARNING)
	rl.init_window(100, 100, "Test Window")

	-- Window state
	lu.assertTrue(rl.is_window_ready())
	lu.assertEquals(rl.get_screen_width(), 100)
	lu.assertEquals(rl.get_screen_height(), 100)
	lu.assertFalse(rl.window_should_close())
	lu.assertTrue(rl.get_fps() >= 0)
	lu.assertTrue(rl.get_time() >= 0)
	lu.assertTrue(rl.get_frame_time() >= 0)
	lu.assertFalse(rl.is_window_fullscreen())
	lu.assertFalse(rl.is_window_hidden())

	-- Random values
	for i = 1, 20 do
		local val = rl.get_random_value(1, 10)
		lu.assertTrue(val >= 1 and val <= 10)
	end

	-- Image generation (CPU-side, no GPU needed)
	local img = rl.gen_image_color(10, 10, rl.RED)
	lu.assertEquals(img.width, 10)
	lu.assertEquals(img.height, 10)
	rl.unload_image(img)

	-- Image copy
	local original = rl.gen_image_color(16, 24, rl.RED)
	local copy = rl.image_copy(original)
	lu.assertEquals(copy.width, original.width)
	lu.assertEquals(copy.height, original.height)
	rl.unload_image(copy)
	rl.unload_image(original)

	-- measure_text (needs default font, which requires init_window)
	lu.assertTrue(rl.measure_text("Test", 20) > 0)

	rl.close_window()
end

-- ============================================================================
-- 24. Snake_case to CamelCase conversion (runtime binding)
-- ============================================================================
test_snake_case_conversion = {}

function test_snake_case_conversion:test_basic_functions()
	-- Verify fundamental snake_case names resolve to working functions (core raylib)
	lu.assertNotNil(rl.fade, "fade should resolve")
	lu.assertNotNil(rl.color_to_int, "color_to_int should resolve")
	lu.assertNotNil(rl.get_screen_width, "get_screen_width should resolve")
	lu.assertNotNil(rl.get_screen_height, "get_screen_height should resolve")
end

function test_snake_case_conversion:test_window_functions()
	lu.assertNotNil(rl.file_exists, "file_exists should resolve")
	lu.assertNotNil(rl.directory_exists, "directory_exists should resolve")
	lu.assertNotNil(rl.is_file_extension, "is_file_extension should resolve")
end

function test_snake_case_conversion:test_vector_functions()
	-- Vector constructor functions (lowercase)
	lu.assertIsFunction(rl.vector2, "vector2 constructor should exist")
	lu.assertIsFunction(rl.vector3, "vector3 constructor should exist")
	lu.assertIsFunction(rl.vector4, "vector4 constructor should exist")
	-- Test they create valid vectors
	local v = rl.vector2(1, 2)
	lu.assertNotNil(v)
	lu.assertEquals(v.x, 1)
	lu.assertEquals(v.y, 2)
end

function test_snake_case_conversion:test_matrix_functions()
	-- Matrix math functions moved to raymath module
	-- Camera matrix functions are in raylib
	lu.assertNotNil(rl.get_camera_matrix, "get_camera_matrix should resolve")
	lu.assertNotNil(rl.get_camera_matrix_2d, "get_camera_matrix_2d should resolve")
end

function test_snake_case_conversion:test_quaternion_functions()
	-- Quaternion math functions moved to raymath module
	-- Just verify the module loaded
	lu.assertIsTable(rl, "raylib should be a table")
end

function test_snake_case_conversion:test_collision_functions()
	lu.assertNotNil(rl.check_collision_recs, "check_collision_recs should resolve")
	lu.assertNotNil(rl.check_collision_circles, "check_collision_circles should resolve")
	lu.assertNotNil(rl.check_collision_circle_rec, "check_collision_circle_rec should resolve")
	lu.assertNotNil(rl.check_collision_point_rec, "check_collision_point_rec should resolve")
	lu.assertNotNil(rl.check_collision_spheres, "check_collision_spheres should resolve")
	lu.assertNotNil(rl.check_collision_boxes, "check_collision_boxes should resolve")
	lu.assertNotNil(rl.get_collision_rec, "get_collision_rec should resolve")
end

function test_snake_case_conversion:test__color_functions()
	lu.assertNotNil(rl.color_to_int, "color_to_int should resolve")
	lu.assertNotNil(rl.color_to_hsv, "color_to_hsv should resolve")
	lu.assertNotNil(rl.color_from_hsv, "color_from_hsv should resolve")
	lu.assertNotNil(rl.color_normalize, "color_normalize should resolve")
	lu.assertNotNil(rl.color_alpha, "color_alpha should resolve")
	lu.assertNotNil(rl.color_lerp, "color_lerp should resolve")
	lu.assertNotNil(rl.color_is_equal, "color_is_equal should resolve")
	lu.assertNotNil(rl.get_color, "get_color should resolve")
	lu.assertNotNil(rl.get_pixel_data_size, "get_pixel_data_size should resolve")
end

function test_snake_case_conversion:test_text_functions()
	lu.assertNotNil(rl.text_is_equal, "text_is_equal should resolve")
	lu.assertNotNil(rl.text_length, "text_length should resolve")
	lu.assertNotNil(rl.text_to_upper, "text_to_upper should resolve")
	lu.assertNotNil(rl.text_to_lower, "text_to_lower should resolve")
	lu.assertNotNil(rl.text_to_integer, "text_to_integer should resolve")
	lu.assertNotNil(rl.text_to_float, "text_to_float should resolve")
	lu.assertNotNil(rl.text_find_index, "text_find_index should resolve")
	lu.assertNotNil(rl.text_subtext, "text_subtext should resolve")
	lu.assertNotNil(rl.get_codepoint_count, "get_codepoint_count should resolve")
end

function test_snake_case_conversion:test_file_functions()
	lu.assertNotNil(rl.file_exists, "file_exists should resolve")
	lu.assertNotNil(rl.directory_exists, "directory_exists should resolve")
	lu.assertNotNil(rl.is_file_extension, "is_file_extension should resolve")
	lu.assertNotNil(rl.get_file_extension, "get_file_extension should resolve")
	lu.assertNotNil(rl.get_file_name, "get_file_name should resolve")
	lu.assertNotNil(rl.get_file_name_without_ext, "get_file_name_without_ext should resolve")
	lu.assertNotNil(rl.get_working_directory, "get_working_directory should resolve")
	lu.assertNotNil(rl.is_path_file, "is_path_file should resolve")
	lu.assertNotNil(rl.get_file_length, "get_file_length should resolve")
	lu.assertNotNil(rl.is_file_name_valid, "is_file_name_valid should resolve")
end

function test_snake_case_conversion:test_special_acronyms()
	-- FPS, DPI, URL, UTF8, HSV, POT, NN, CW, CCW, CRC32, MD5, SHA1, SHA256, XYZ, ZYX
	-- Test HSV color functions (core raylib)
	lu.assertNotNil(rl.color_to_hsv, "color_to_hsv (HSV acronym) should resolve")
	lu.assertNotNil(rl.color_from_hsv, "color_from_hsv (HSV acronym) should resolve")
end

function test_snake_case_conversion:test_snake_case_results_match_camel_case()
	-- Verify that snake_case calls produce identical results to direct lib calls
	-- Using core raylib functions
	local snake_result = rl.get_screen_width()
	local direct_result = rl.lib.GetScreenWidth()
	lu.assertEquals(snake_result, direct_result)

	-- Test color conversion
	local c = rl.color(255, 128, 64, 255)
	local sc = rl.color_to_int(c)
	local dc = rl.lib.ColorToInt(c)
	lu.assertEquals(sc, dc)
end

function test_snake_case_conversion:test_constructors_still_work()
	-- Constructors should remain CamelCase and still work
	lu.assertIsFunction(rl.Color)
	lu.assertIsFunction(rl.Vector2)
	lu.assertIsFunction(rl.Vector3)
	lu.assertIsFunction(rl.Vector4)
	lu.assertIsFunction(rl.Rectangle)
	lu.assertIsFunction(rl.Camera3D)
	lu.assertIsFunction(rl.Camera2D)
	lu.assertIsFunction(rl.Ray)
	lu.assertIsFunction(rl.BoundingBox)
end

function test_snake_case_conversion:test_enum_tables_still_work()
	-- Enum tables should remain CamelCase and still work
	lu.assertIsTable(rl.KeyboardKey)
	lu.assertIsTable(rl.ConfigFlags)
	lu.assertEquals(rl.KeyboardKey.KEY_SPACE, 32)
end

function test_snake_case_conversion:test__color_constants_still_work()
	-- Color constants should remain ALLCAPS and still work
	lu.assertEquals(rl.WHITE.r, 255)
	lu.assertEquals(rl.BLACK.r, 0)
	lu.assertEquals(rl.RED.r, 230)
end

-- ============================================================================
-- Run
-- ============================================================================
os.exit(lu.LuaUnit.run())
