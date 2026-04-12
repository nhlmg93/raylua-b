-- ==========================================================================
-- Comprehensive test suite for raylib.lua FFI bindings
-- Uses LuaUnit (https://github.com/bluebird75/luaunit)
-- Run with: luajit test_raylib.lua
-- ==========================================================================

local lu = require("luaunit")
local ffi = require("ffi")
local rl = require("raylib")

-- Helper: float comparison tolerance
local EPS = 0.001
local function approx(a, b)
	return math.abs(a - b) < EPS
end

-- ============================================================================
-- 1. Module structure and loading
-- ============================================================================
TestModuleStructure = {}

function TestModuleStructure:testRlIsTable()
	lu.assertIsTable(rl)
end

function TestModuleStructure:testRlLibExists()
	lu.assertNotNil(rl.lib)
	local t = type(rl.lib)
	lu.assertTrue(t == "cdata" or t == "userdata", "rl.lib should be cdata or userdata, got: " .. t)
end

function TestModuleStructure:testConstructorFunctionsExist()
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

function TestModuleStructure:testUtilityFunctionsExist()
	local utils = { "new", "ref", "istype", "sizeof" }
	for _, name in ipairs(utils) do
		lu.assertNotNil(rl[name], "Utility function missing: " .. name)
		lu.assertIsFunction(rl[name], "Utility not a function: " .. name)
	end
end

function TestModuleStructure:testEnumerationTablesExist()
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

function TestModuleStructure:testColorConstantsExist()
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

function TestModuleStructure:testFFIDispatchViaIndex()
	local clamp = rl.clamp
	lu.assertNotNil(clamp, "rl.clamp should resolve via __index")
	local ok, result = pcall(clamp, 5.0, 0.0, 3.0)
	lu.assertTrue(ok, "rl.clamp should be callable")
	lu.assertTrue(approx(result, 3.0), "clamp(5, 0, 3) should return 3.0")
end

-- ============================================================================
-- 2. Constructor functions
-- ============================================================================
TestConstructors = {}

function TestConstructors:testColorRGBA()
	local c = rl.Color(255, 128, 64, 32)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 128)
	lu.assertEquals(c.b, 64)
	lu.assertEquals(c.a, 32)
end

function TestConstructors:testColorRGBADefaultAlpha()
	local c = rl.Color(255, 128, 64)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 128)
	lu.assertEquals(c.b, 64)
	lu.assertEquals(c.a, 255)
end

function TestConstructors:testColorHexStringRed()
	local c = rl.Color("#FF0000")
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 255)
end

function TestConstructors:testColorHexStringWithAlpha()
	local c = rl.Color("#FF000080")
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 128)
end

function TestConstructors:testColorHexStringLowercase()
	local c = rl.Color("#ff8040")
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 128)
	lu.assertEquals(c.b, 64)
	lu.assertEquals(c.a, 255)
end

function TestConstructors:testColorHexNumberRed()
	local c = rl.Color(0xFF0000FF)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 255)
end

function TestConstructors:testColorHexNumberTransparent()
	local c = rl.Color(0xFF000080)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 128)
end

function TestConstructors:testVector2()
	local v = rl.Vector2(3.5, 7.25)
	lu.assertAlmostEquals(v.x, 3.5, EPS)
	lu.assertAlmostEquals(v.y, 7.25, EPS)
end

function TestConstructors:testVector2Defaults()
	local v = rl.Vector2()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
end

function TestConstructors:testVector3()
	local v = rl.Vector3(1.0, 2.0, 3.0)
	lu.assertAlmostEquals(v.x, 1.0, EPS)
	lu.assertAlmostEquals(v.y, 2.0, EPS)
	lu.assertAlmostEquals(v.z, 3.0, EPS)
end

function TestConstructors:testVector3Defaults()
	local v = rl.Vector3()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
	lu.assertAlmostEquals(v.z, 0, EPS)
end

function TestConstructors:testVector4()
	local v = rl.Vector4(1.0, 2.0, 3.0, 4.0)
	lu.assertAlmostEquals(v.x, 1.0, EPS)
	lu.assertAlmostEquals(v.y, 2.0, EPS)
	lu.assertAlmostEquals(v.z, 3.0, EPS)
	lu.assertAlmostEquals(v.w, 4.0, EPS)
end

function TestConstructors:testVector4Defaults()
	local v = rl.Vector4()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
	lu.assertAlmostEquals(v.z, 0, EPS)
	lu.assertAlmostEquals(v.w, 0, EPS)
end

function TestConstructors:testRectangle()
	local r = rl.Rectangle(10.0, 20.0, 100.0, 50.0)
	lu.assertAlmostEquals(r.x, 10.0, EPS)
	lu.assertAlmostEquals(r.y, 20.0, EPS)
	lu.assertAlmostEquals(r.width, 100.0, EPS)
	lu.assertAlmostEquals(r.height, 50.0, EPS)
end

function TestConstructors:testRectangleDefaults()
	local r = rl.Rectangle()
	lu.assertAlmostEquals(r.x, 0, EPS)
	lu.assertAlmostEquals(r.y, 0, EPS)
	lu.assertAlmostEquals(r.width, 0, EPS)
	lu.assertAlmostEquals(r.height, 0, EPS)
end

function TestConstructors:testCamera2DDefaults()
	local cam = rl.Camera2D()
	lu.assertAlmostEquals(cam.offset.x, 0, EPS)
	lu.assertAlmostEquals(cam.offset.y, 0, EPS)
	lu.assertAlmostEquals(cam.target.x, 0, EPS)
	lu.assertAlmostEquals(cam.target.y, 0, EPS)
	lu.assertAlmostEquals(cam.rotation, 0, EPS)
	lu.assertAlmostEquals(cam.zoom, 1.0, EPS)
end

function TestConstructors:testCamera2DCustom()
	local cam = rl.Camera2D(rl.Vector2(400, 300), rl.Vector2(100, 200), 45.0, 2.0)
	lu.assertAlmostEquals(cam.offset.x, 400, EPS)
	lu.assertAlmostEquals(cam.offset.y, 300, EPS)
	lu.assertAlmostEquals(cam.target.x, 100, EPS)
	lu.assertAlmostEquals(cam.target.y, 200, EPS)
	lu.assertAlmostEquals(cam.rotation, 45.0, EPS)
	lu.assertAlmostEquals(cam.zoom, 2.0, EPS)
end

function TestConstructors:testCamera3DDefaults()
	local pos = rl.Vector3(10, 10, 10)
	local target = rl.Vector3(0, 0, 0)
	local cam = rl.Camera3D(pos, target)
	lu.assertAlmostEquals(cam.position.x, 10, EPS)
	lu.assertAlmostEquals(cam.up.y, 1.0, EPS)
	lu.assertAlmostEquals(cam.fovy, 45.0, EPS)
	lu.assertEquals(cam.projection, 0)
end

function TestConstructors:testCamera3DCustom()
	local cam = rl.Camera3D(rl.Vector3(5, 5, 5), rl.Vector3(0, 1, 0), rl.Vector3(0, 0, 1), 60.0, 1)
	lu.assertAlmostEquals(cam.up.z, 1, EPS)
	lu.assertAlmostEquals(cam.fovy, 60.0, EPS)
	lu.assertEquals(cam.projection, 1)
end

function TestConstructors:testRay()
	local r = rl.Ray(rl.Vector3(0, 0, 0), rl.Vector3(1, 0, 0))
	lu.assertAlmostEquals(r.position.x, 0, EPS)
	lu.assertAlmostEquals(r.direction.x, 1, EPS)
end

function TestConstructors:testBoundingBox()
	local bb = rl.BoundingBox(rl.Vector3(-1, -1, -1), rl.Vector3(1, 1, 1))
	lu.assertAlmostEquals(bb.min.x, -1, EPS)
	lu.assertAlmostEquals(bb.max.x, 1, EPS)
end

-- ============================================================================
-- 3. Color constants
-- ============================================================================
TestColorConstants = {}

function TestColorConstants:test_LIGHTGRAY()
	lu.assertEquals(rl.LIGHTGRAY.r, 200)
	lu.assertEquals(rl.LIGHTGRAY.g, 200)
	lu.assertEquals(rl.LIGHTGRAY.b, 200)
	lu.assertEquals(rl.LIGHTGRAY.a, 255)
end
function TestColorConstants:test_GRAY()
	lu.assertEquals(rl.GRAY.r, 130)
	lu.assertEquals(rl.GRAY.g, 130)
	lu.assertEquals(rl.GRAY.b, 130)
	lu.assertEquals(rl.GRAY.a, 255)
end
function TestColorConstants:test_DARKGRAY()
	lu.assertEquals(rl.DARKGRAY.r, 80)
	lu.assertEquals(rl.DARKGRAY.g, 80)
	lu.assertEquals(rl.DARKGRAY.b, 80)
	lu.assertEquals(rl.DARKGRAY.a, 255)
end
function TestColorConstants:test_YELLOW()
	lu.assertEquals(rl.YELLOW.r, 253)
	lu.assertEquals(rl.YELLOW.g, 249)
	lu.assertEquals(rl.YELLOW.b, 0)
	lu.assertEquals(rl.YELLOW.a, 255)
end
function TestColorConstants:test_GOLD()
	lu.assertEquals(rl.GOLD.r, 255)
	lu.assertEquals(rl.GOLD.g, 203)
	lu.assertEquals(rl.GOLD.b, 0)
	lu.assertEquals(rl.GOLD.a, 255)
end
function TestColorConstants:test_ORANGE()
	lu.assertEquals(rl.ORANGE.r, 255)
	lu.assertEquals(rl.ORANGE.g, 161)
	lu.assertEquals(rl.ORANGE.b, 0)
	lu.assertEquals(rl.ORANGE.a, 255)
end
function TestColorConstants:test_PINK()
	lu.assertEquals(rl.PINK.r, 255)
	lu.assertEquals(rl.PINK.g, 109)
	lu.assertEquals(rl.PINK.b, 194)
	lu.assertEquals(rl.PINK.a, 255)
end
function TestColorConstants:test_RED()
	lu.assertEquals(rl.RED.r, 230)
	lu.assertEquals(rl.RED.g, 41)
	lu.assertEquals(rl.RED.b, 55)
	lu.assertEquals(rl.RED.a, 255)
end
function TestColorConstants:test_MAROON()
	lu.assertEquals(rl.MAROON.r, 190)
	lu.assertEquals(rl.MAROON.g, 33)
	lu.assertEquals(rl.MAROON.b, 55)
	lu.assertEquals(rl.MAROON.a, 255)
end
function TestColorConstants:test_GREEN()
	lu.assertEquals(rl.GREEN.r, 0)
	lu.assertEquals(rl.GREEN.g, 228)
	lu.assertEquals(rl.GREEN.b, 48)
	lu.assertEquals(rl.GREEN.a, 255)
end
function TestColorConstants:test_LIME()
	lu.assertEquals(rl.LIME.r, 0)
	lu.assertEquals(rl.LIME.g, 158)
	lu.assertEquals(rl.LIME.b, 47)
	lu.assertEquals(rl.LIME.a, 255)
end
function TestColorConstants:test_DARKGREEN()
	lu.assertEquals(rl.DARKGREEN.r, 0)
	lu.assertEquals(rl.DARKGREEN.g, 117)
	lu.assertEquals(rl.DARKGREEN.b, 44)
	lu.assertEquals(rl.DARKGREEN.a, 255)
end
function TestColorConstants:test_SKYBLUE()
	lu.assertEquals(rl.SKYBLUE.r, 102)
	lu.assertEquals(rl.SKYBLUE.g, 191)
	lu.assertEquals(rl.SKYBLUE.b, 255)
	lu.assertEquals(rl.SKYBLUE.a, 255)
end
function TestColorConstants:test_BLUE()
	lu.assertEquals(rl.BLUE.r, 0)
	lu.assertEquals(rl.BLUE.g, 121)
	lu.assertEquals(rl.BLUE.b, 241)
	lu.assertEquals(rl.BLUE.a, 255)
end
function TestColorConstants:test_DARKBLUE()
	lu.assertEquals(rl.DARKBLUE.r, 0)
	lu.assertEquals(rl.DARKBLUE.g, 82)
	lu.assertEquals(rl.DARKBLUE.b, 172)
	lu.assertEquals(rl.DARKBLUE.a, 255)
end
function TestColorConstants:test_PURPLE()
	lu.assertEquals(rl.PURPLE.r, 200)
	lu.assertEquals(rl.PURPLE.g, 122)
	lu.assertEquals(rl.PURPLE.b, 255)
	lu.assertEquals(rl.PURPLE.a, 255)
end
function TestColorConstants:test_VIOLET()
	lu.assertEquals(rl.VIOLET.r, 135)
	lu.assertEquals(rl.VIOLET.g, 60)
	lu.assertEquals(rl.VIOLET.b, 190)
	lu.assertEquals(rl.VIOLET.a, 255)
end
function TestColorConstants:test_DARKPURPLE()
	lu.assertEquals(rl.DARKPURPLE.r, 112)
	lu.assertEquals(rl.DARKPURPLE.g, 31)
	lu.assertEquals(rl.DARKPURPLE.b, 126)
	lu.assertEquals(rl.DARKPURPLE.a, 255)
end
function TestColorConstants:test_BEIGE()
	lu.assertEquals(rl.BEIGE.r, 211)
	lu.assertEquals(rl.BEIGE.g, 176)
	lu.assertEquals(rl.BEIGE.b, 131)
	lu.assertEquals(rl.BEIGE.a, 255)
end
function TestColorConstants:test_BROWN()
	lu.assertEquals(rl.BROWN.r, 127)
	lu.assertEquals(rl.BROWN.g, 106)
	lu.assertEquals(rl.BROWN.b, 79)
	lu.assertEquals(rl.BROWN.a, 255)
end
function TestColorConstants:test_DARKBROWN()
	lu.assertEquals(rl.DARKBROWN.r, 76)
	lu.assertEquals(rl.DARKBROWN.g, 63)
	lu.assertEquals(rl.DARKBROWN.b, 47)
	lu.assertEquals(rl.DARKBROWN.a, 255)
end
function TestColorConstants:test_WHITE()
	lu.assertEquals(rl.WHITE.r, 255)
	lu.assertEquals(rl.WHITE.g, 255)
	lu.assertEquals(rl.WHITE.b, 255)
	lu.assertEquals(rl.WHITE.a, 255)
end
function TestColorConstants:test_BLACK()
	lu.assertEquals(rl.BLACK.r, 0)
	lu.assertEquals(rl.BLACK.g, 0)
	lu.assertEquals(rl.BLACK.b, 0)
	lu.assertEquals(rl.BLACK.a, 255)
end
function TestColorConstants:test_BLANK()
	lu.assertEquals(rl.BLANK.r, 0)
	lu.assertEquals(rl.BLANK.g, 0)
	lu.assertEquals(rl.BLANK.b, 0)
	lu.assertEquals(rl.BLANK.a, 0)
end
function TestColorConstants:test_MAGENTA()
	lu.assertEquals(rl.MAGENTA.r, 255)
	lu.assertEquals(rl.MAGENTA.g, 0)
	lu.assertEquals(rl.MAGENTA.b, 255)
	lu.assertEquals(rl.MAGENTA.a, 255)
end
function TestColorConstants:test_RAYWHITE()
	lu.assertEquals(rl.RAYWHITE.r, 245)
	lu.assertEquals(rl.RAYWHITE.g, 245)
	lu.assertEquals(rl.RAYWHITE.b, 245)
	lu.assertEquals(rl.RAYWHITE.a, 255)
end

-- ============================================================================
-- 4. Enumeration tables
-- ============================================================================
TestEnumerations = {}

function TestEnumerations:testConfigFlags()
	lu.assertEquals(rl.ConfigFlags.FLAG_VSYNC_HINT, 0x40)
	lu.assertEquals(rl.ConfigFlags.FLAG_FULLSCREEN_MODE, 0x02)
	lu.assertEquals(rl.ConfigFlags.FLAG_WINDOW_RESIZABLE, 0x04)
end
function TestEnumerations:testTraceLogLevel()
	lu.assertEquals(rl.TraceLogLevel.LOG_ALL, 0)
	lu.assertEquals(rl.TraceLogLevel.LOG_INFO, 3)
	lu.assertEquals(rl.TraceLogLevel.LOG_NONE, 7)
end
function TestEnumerations:testKeyboardKey()
	lu.assertEquals(rl.KeyboardKey.KEY_SPACE, 32)
	lu.assertEquals(rl.KeyboardKey.KEY_ESCAPE, 256)
	lu.assertEquals(rl.KeyboardKey.KEY_A, 65)
	lu.assertEquals(rl.KeyboardKey.KEY_Z, 90)
end
function TestEnumerations:testMouseButton()
	lu.assertEquals(rl.MouseButton.MOUSE_BUTTON_LEFT, 0)
	lu.assertEquals(rl.MouseButton.MOUSE_BUTTON_RIGHT, 1)
end
function TestEnumerations:testMouseCursor()
	lu.assertEquals(rl.MouseCursor.MOUSE_CURSOR_DEFAULT, 0)
	lu.assertEquals(rl.MouseCursor.MOUSE_CURSOR_CROSSHAIR, 3)
end
function TestEnumerations:testGamepadButton()
	lu.assertEquals(rl.GamepadButton.GAMEPAD_BUTTON_UNKNOWN, 0)
	lu.assertEquals(rl.GamepadButton.GAMEPAD_BUTTON_MIDDLE, 14)
end
function TestEnumerations:testGamepadAxis()
	lu.assertEquals(rl.GamepadAxis.GAMEPAD_AXIS_LEFT_X, 0)
	lu.assertEquals(rl.GamepadAxis.GAMEPAD_AXIS_RIGHT_TRIGGER, 5)
end
function TestEnumerations:testMaterialMapIndex()
	lu.assertEquals(rl.MaterialMapIndex.MATERIAL_MAP_ALBEDO, 0)
	lu.assertEquals(rl.MaterialMapIndex.MATERIAL_MAP_NORMAL, 2)
end
function TestEnumerations:testShaderLocationIndex()
	lu.assertEquals(rl.ShaderLocationIndex.SHADER_LOC_VERTEX_POSITION, 0)
	lu.assertEquals(rl.ShaderLocationIndex.SHADER_LOC_MATRIX_MVP, 6)
end
function TestEnumerations:testShaderUniformDataType()
	lu.assertEquals(rl.ShaderUniformDataType.SHADER_UNIFORM_FLOAT, 0)
	lu.assertEquals(rl.ShaderUniformDataType.SHADER_UNIFORM_SAMPLER2D, 12)
end
function TestEnumerations:testShaderAttributeDataType()
	lu.assertEquals(rl.ShaderAttributeDataType.SHADER_ATTRIB_FLOAT, 0)
	lu.assertEquals(rl.ShaderAttributeDataType.SHADER_ATTRIB_VEC4, 3)
end
function TestEnumerations:testPixelFormat()
	lu.assertEquals(rl.PixelFormat.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8, 7)
end
function TestEnumerations:testTextureFilter()
	lu.assertEquals(rl.TextureFilter.TEXTURE_FILTER_POINT, 0)
	lu.assertEquals(rl.TextureFilter.TEXTURE_FILTER_BILINEAR, 1)
end
function TestEnumerations:testTextureWrap()
	lu.assertEquals(rl.TextureWrap.TEXTURE_WRAP_REPEAT, 0)
	lu.assertEquals(rl.TextureWrap.TEXTURE_WRAP_CLAMP, 1)
end
function TestEnumerations:testBlendMode()
	lu.assertEquals(rl.BlendMode.BLEND_ALPHA, 0)
	lu.assertEquals(rl.BlendMode.BLEND_ADDITIVE, 1)
end
function TestEnumerations:testGesture()
	lu.assertEquals(rl.Gesture.GESTURE_NONE, 0)
	lu.assertEquals(rl.Gesture.GESTURE_TAP, 1)
	lu.assertEquals(rl.Gesture.GESTURE_DRAG, 8)
end
function TestEnumerations:testCameraMode()
	lu.assertEquals(rl.CameraMode.CAMERA_CUSTOM, 0)
	lu.assertEquals(rl.CameraMode.CAMERA_FREE, 1)
end
function TestEnumerations:testCameraProjection()
	lu.assertEquals(rl.CameraProjection.CAMERA_PERSPECTIVE, 0)
	lu.assertEquals(rl.CameraProjection.CAMERA_ORTHOGRAPHIC, 1)
end
function TestEnumerations:testNPatchLayout()
	lu.assertEquals(rl.NPatchLayout.NPATCH_NINE_PATCH, 0)
end

-- ============================================================================
-- 5. Vector2 operator overloads
-- ============================================================================
TestVector2Operators = {}

function TestVector2Operators:testAddVecVec()
	local c = rl.Vector2(3, 4) + rl.Vector2(1, 2)
	lu.assertAlmostEquals(c.x, 4, EPS)
	lu.assertAlmostEquals(c.y, 6, EPS)
end
function TestVector2Operators:testAddVecNum()
	local c = rl.Vector2(3, 4) + 10
	lu.assertAlmostEquals(c.x, 13, EPS)
	lu.assertAlmostEquals(c.y, 14, EPS)
end
function TestVector2Operators:testAddNumVec()
	local c = 10 + rl.Vector2(3, 4)
	lu.assertAlmostEquals(c.x, 13, EPS)
	lu.assertAlmostEquals(c.y, 14, EPS)
end
function TestVector2Operators:testSubVecVec()
	local c = rl.Vector2(3, 4) - rl.Vector2(1, 2)
	lu.assertAlmostEquals(c.x, 2, EPS)
	lu.assertAlmostEquals(c.y, 2, EPS)
end
function TestVector2Operators:testSubVecNum()
	local c = rl.Vector2(3, 4) - 1
	lu.assertAlmostEquals(c.x, 2, EPS)
	lu.assertAlmostEquals(c.y, 3, EPS)
end
function TestVector2Operators:testSubNumVec()
	local c = 10 - rl.Vector2(3, 4)
	lu.assertAlmostEquals(c.x, 7, EPS)
	lu.assertAlmostEquals(c.y, 6, EPS)
end
function TestVector2Operators:testMulVecVec()
	local c = rl.Vector2(3, 4) * rl.Vector2(2, 5)
	lu.assertAlmostEquals(c.x, 6, EPS)
	lu.assertAlmostEquals(c.y, 20, EPS)
end
function TestVector2Operators:testMulVecNum()
	local c = rl.Vector2(3, 4) * 3
	lu.assertAlmostEquals(c.x, 9, EPS)
	lu.assertAlmostEquals(c.y, 12, EPS)
end
function TestVector2Operators:testMulNumVec()
	local c = 3 * rl.Vector2(3, 4)
	lu.assertAlmostEquals(c.x, 9, EPS)
	lu.assertAlmostEquals(c.y, 12, EPS)
end
function TestVector2Operators:testDivVecVec()
	local c = rl.Vector2(6, 8) / rl.Vector2(2, 4)
	lu.assertAlmostEquals(c.x, 3, EPS)
	lu.assertAlmostEquals(c.y, 2, EPS)
end
function TestVector2Operators:testDivVecNum()
	local c = rl.Vector2(6, 8) / 2
	lu.assertAlmostEquals(c.x, 3, EPS)
	lu.assertAlmostEquals(c.y, 4, EPS)
end
function TestVector2Operators:testDivNumVec()
	local c = 12 / rl.Vector2(2, 4)
	lu.assertAlmostEquals(c.x, 6, EPS)
	lu.assertAlmostEquals(c.y, 3, EPS)
end
function TestVector2Operators:testUnm()
	local c = -rl.Vector2(3, 4)
	lu.assertAlmostEquals(c.x, -3, EPS)
	lu.assertAlmostEquals(c.y, -4, EPS)
end
function TestVector2Operators:testEqSame()
	lu.assertTrue(rl.Vector2(3, 4) == rl.Vector2(3, 4))
end
function TestVector2Operators:testEqDifferent()
	lu.assertTrue(rl.Vector2(3, 4) ~= rl.Vector2(3, 5))
end
function TestVector2Operators:testLen()
	lu.assertAlmostEquals(#rl.Vector2(3, 4), 5, EPS)
end

-- ============================================================================
-- 6. Vector3 operator overloads
-- ============================================================================
TestVector3Operators = {}

function TestVector3Operators:testAddVecVec()
	local c = rl.Vector3(1, 2, 3) + rl.Vector3(4, 5, 6)
	lu.assertAlmostEquals(c.x, 5, EPS)
	lu.assertAlmostEquals(c.y, 7, EPS)
	lu.assertAlmostEquals(c.z, 9, EPS)
end
function TestVector3Operators:testAddVecNum()
	local c = rl.Vector3(1, 2, 3) + 10
	lu.assertAlmostEquals(c.x, 11, EPS)
	lu.assertAlmostEquals(c.y, 12, EPS)
	lu.assertAlmostEquals(c.z, 13, EPS)
end
function TestVector3Operators:testSubVecVec()
	local c = rl.Vector3(4, 5, 6) - rl.Vector3(1, 2, 3)
	lu.assertAlmostEquals(c.x, 3, EPS)
	lu.assertAlmostEquals(c.y, 3, EPS)
	lu.assertAlmostEquals(c.z, 3, EPS)
end
function TestVector3Operators:testMulVecNum()
	local c = rl.Vector3(1, 2, 3) * 3
	lu.assertAlmostEquals(c.x, 3, EPS)
	lu.assertAlmostEquals(c.y, 6, EPS)
	lu.assertAlmostEquals(c.z, 9, EPS)
end
function TestVector3Operators:testDivVecNum()
	local c = rl.Vector3(6, 10, 12) / 2
	lu.assertAlmostEquals(c.x, 3, EPS)
	lu.assertAlmostEquals(c.y, 5, EPS)
	lu.assertAlmostEquals(c.z, 6, EPS)
end
function TestVector3Operators:testUnm()
	local c = -rl.Vector3(1, 2, 3)
	lu.assertAlmostEquals(c.x, -1, EPS)
	lu.assertAlmostEquals(c.y, -2, EPS)
	lu.assertAlmostEquals(c.z, -3, EPS)
end
function TestVector3Operators:testEqSame()
	lu.assertTrue(rl.Vector3(1, 2, 3) == rl.Vector3(1, 2, 3))
end
function TestVector3Operators:testEqDifferent()
	lu.assertTrue(rl.Vector3(1, 2, 3) ~= rl.Vector3(1, 2, 4))
end
function TestVector3Operators:testLen()
	lu.assertAlmostEquals(#rl.Vector3(2, 3, 6), 7, EPS)
end

-- ============================================================================
-- 7. Vector4 operator overloads
-- ============================================================================
TestVector4Operators = {}

function TestVector4Operators:testAddVecVec()
	local c = rl.Vector4(1, 2, 3, 4) + rl.Vector4(5, 6, 7, 8)
	lu.assertAlmostEquals(c.x, 6, EPS)
	lu.assertAlmostEquals(c.y, 8, EPS)
	lu.assertAlmostEquals(c.z, 10, EPS)
	lu.assertAlmostEquals(c.w, 12, EPS)
end
function TestVector4Operators:testSubVecVec()
	local c = rl.Vector4(5, 6, 7, 8) - rl.Vector4(1, 2, 3, 4)
	lu.assertAlmostEquals(c.x, 4, EPS)
	lu.assertAlmostEquals(c.y, 4, EPS)
	lu.assertAlmostEquals(c.z, 4, EPS)
	lu.assertAlmostEquals(c.w, 4, EPS)
end
function TestVector4Operators:testMulVecNum()
	local c = rl.Vector4(1, 2, 3, 4) * 3
	lu.assertAlmostEquals(c.x, 3, EPS)
	lu.assertAlmostEquals(c.y, 6, EPS)
	lu.assertAlmostEquals(c.z, 9, EPS)
	lu.assertAlmostEquals(c.w, 12, EPS)
end
function TestVector4Operators:testDivVecNum()
	local c = rl.Vector4(6, 10, 12, 20) / 2
	lu.assertAlmostEquals(c.x, 3, EPS)
	lu.assertAlmostEquals(c.y, 5, EPS)
	lu.assertAlmostEquals(c.z, 6, EPS)
	lu.assertAlmostEquals(c.w, 10, EPS)
end
function TestVector4Operators:testUnm()
	local c = -rl.Vector4(1, 2, 3, 4)
	lu.assertAlmostEquals(c.x, -1, EPS)
	lu.assertAlmostEquals(c.y, -2, EPS)
	lu.assertAlmostEquals(c.z, -3, EPS)
	lu.assertAlmostEquals(c.w, -4, EPS)
end
function TestVector4Operators:testEqSame()
	lu.assertTrue(rl.Vector4(1, 2, 3, 4) == rl.Vector4(1, 2, 3, 4))
end
function TestVector4Operators:testLen()
	lu.assertAlmostEquals(#rl.Vector4(1, 2, 3, 4), math.sqrt(30), EPS)
end

-- ============================================================================
-- 8. Matrix operator overloads
-- ============================================================================
TestMatrixOperators = {}

function TestMatrixOperators:test_add()
	local c = rl.matrix_identity() + rl.matrix_identity()
	lu.assertTrue(approx(c.m0, 2.0))
	lu.assertTrue(approx(c.m5, 2.0))
	lu.assertTrue(approx(c.m10, 2.0))
	lu.assertTrue(approx(c.m15, 2.0))
	lu.assertTrue(approx(c.m1, 0.0))
	lu.assertTrue(approx(c.m4, 0.0))
end
function TestMatrixOperators:test_sub()
	local c = rl.matrix_identity() - rl.matrix_identity()
	for i = 0, 15 do
		lu.assertTrue(approx(c["m" .. i], 0.0))
	end
end
function TestMatrixOperators:test_mul()
	local c = rl.matrix_identity() * rl.matrix_identity()
	lu.assertTrue(approx(c.m0, 1.0))
	lu.assertTrue(approx(c.m5, 1.0))
	lu.assertTrue(approx(c.m10, 1.0))
	lu.assertTrue(approx(c.m15, 1.0))
	lu.assertTrue(approx(c.m1, 0.0))
	lu.assertTrue(approx(c.m4, 0.0))
end
function TestMatrixOperators:test_tostring()
	lu.assertStrContains(tostring(rl.matrix_identity()), "Matrix(")
end

-- ============================================================================
-- 9. tostring metamethods
-- ============================================================================
TestTostring = {}

function TestTostring:test_vector2()
	lu.assertEquals(tostring(rl.Vector2(1.5, 2.5)), "Vector2(1.500, 2.500)")
end
function TestTostring:test_vector3()
	lu.assertEquals(tostring(rl.Vector3(1, 2, 3)), "Vector3(1.000, 2.000, 3.000)")
end
function TestTostring:test_vector4()
	lu.assertEquals(tostring(rl.Vector4(1, 2, 3, 4)), "Vector4(1.000, 2.000, 3.000, 4.000)")
end
function TestTostring:test_color()
	lu.assertEquals(tostring(rl.Color(255, 0, 128, 255)), "Color(255, 0, 128, 255)")
end
function TestTostring:test_rectangle()
	lu.assertEquals(tostring(rl.Rectangle(10, 20, 100, 200)), "Rectangle(10.0, 20.0, 100.0, 200.0)")
end

-- ============================================================================
-- 10. Utility functions
-- ============================================================================
TestUtilities = {}

function TestUtilities:test_new()
	local v = rl.new("Vector2", 5, 10)
	lu.assertTrue(approx(v.x, 5.0))
	lu.assertTrue(approx(v.y, 10.0))
end
function TestUtilities:test_ref_int()
	local ptr = rl.ref("int", 42)
	lu.assertEquals(ptr[0], 42)
end
function TestUtilities:test_ref_int_default()
	local ptr = rl.ref("int")
	lu.assertEquals(ptr[0], 0)
end
function TestUtilities:test_ref_float()
	local ptr = rl.ref("float", 3.14)
	lu.assertTrue(approx(ptr[0], 3.14))
end
function TestUtilities:test_istype_true()
	lu.assertTrue(rl.istype("Vector2", rl.Vector2(1, 2)))
end
function TestUtilities:test_istype_false()
	lu.assertFalse(rl.istype("Vector3", rl.Vector2(1, 2)))
end
function TestUtilities:test_sizeof_vector2()
	lu.assertEquals(rl.sizeof("Vector2"), 8)
end
function TestUtilities:test_sizeof_vector3()
	lu.assertEquals(rl.sizeof("Vector3"), 12)
end
function TestUtilities:test_sizeof_color()
	lu.assertEquals(rl.sizeof("Color"), 4)
end
function TestUtilities:test_sizeof_rectangle()
	lu.assertEquals(rl.sizeof("Rectangle"), 16)
end

-- ============================================================================
-- 11. Raymath scalar utilities
-- ============================================================================
TestRaymathScalar = {}

function TestRaymathScalar:testClampInRange()
	lu.assertAlmostEquals(rl.clamp(5, 0, 10), 5, EPS)
end
function TestRaymathScalar:testClampBelowMin()
	lu.assertAlmostEquals(rl.clamp(-5, 0, 10), 0, EPS)
end
function TestRaymathScalar:testClampAboveMax()
	lu.assertAlmostEquals(rl.clamp(15, 0, 10), 10, EPS)
end
function TestRaymathScalar:testLerpMidpoint()
	lu.assertAlmostEquals(rl.lerp(0, 10, 0.5), 5, EPS)
end
function TestRaymathScalar:testLerpStart()
	lu.assertAlmostEquals(rl.lerp(0, 10, 0), 0, EPS)
end
function TestRaymathScalar:testLerpEnd()
	lu.assertAlmostEquals(rl.lerp(0, 10, 1), 10, EPS)
end
function TestRaymathScalar:testNormalizeMid()
	lu.assertAlmostEquals(rl.normalize(5, 0, 10), 0.5, EPS)
end
function TestRaymathScalar:testRemap()
	lu.assertAlmostEquals(rl.remap(5, 0, 10, 0, 100), 50, EPS)
end
function TestRaymathScalar:testWrapAbove()
	lu.assertAlmostEquals(rl.wrap(12, 0, 10), 2, EPS)
end
function TestRaymathScalar:testWrapBelow()
	lu.assertAlmostEquals(rl.wrap(-1, 0, 10), 9, EPS)
end
function TestRaymathScalar:testFloatEqualsTrue()
	lu.assertEquals(rl.float_equals(1.0, 1.0), 1)
end
function TestRaymathScalar:testFloatEqualsFalse()
	lu.assertEquals(rl.float_equals(1.0, 2.0), 0)
end

-- ============================================================================
-- 12. Vector2 math functions
-- ============================================================================
TestVector2Math = {}

function TestVector2Math:testVector2Zero()
	local v = rl.vector2_zero()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
end
function TestVector2Math:testVector2One()
	local v = rl.vector2_one()
	lu.assertAlmostEquals(v.x, 1, EPS)
	lu.assertAlmostEquals(v.y, 1, EPS)
end
function TestVector2Math:testVector2Add()
	local v = rl.vector2_add(rl.Vector2(1, 2), rl.Vector2(3, 4))
	lu.assertAlmostEquals(v.x, 4, EPS)
	lu.assertAlmostEquals(v.y, 6, EPS)
end
function TestVector2Math:testVector2Subtract()
	local v = rl.vector2_subtract(rl.Vector2(5, 7), rl.Vector2(2, 3))
	lu.assertAlmostEquals(v.x, 3, EPS)
	lu.assertAlmostEquals(v.y, 4, EPS)
end
function TestVector2Math:testVector2Scale()
	local v = rl.vector2_scale(rl.Vector2(2, 3), 3)
	lu.assertAlmostEquals(v.x, 6, EPS)
	lu.assertAlmostEquals(v.y, 9, EPS)
end
function TestVector2Math:testVector2Length()
	lu.assertAlmostEquals(rl.vector2_length(rl.Vector2(3, 4)), 5.0, EPS)
end
function TestVector2Math:testVector2LengthSqr()
	lu.assertAlmostEquals(rl.vector2_length_sqr(rl.Vector2(3, 4)), 25.0, EPS)
end
function TestVector2Math:testVector2DotProductPerpendicular()
	lu.assertAlmostEquals(rl.vector2_dot_product(rl.Vector2(1, 0), rl.Vector2(0, 1)), 0, EPS)
end
function TestVector2Math:testVector2DotProductParallel()
	lu.assertAlmostEquals(rl.vector2_dot_product(rl.Vector2(1, 0), rl.Vector2(1, 0)), 1, EPS)
end
function TestVector2Math:testVector2Distance()
	lu.assertAlmostEquals(rl.vector2_distance(rl.Vector2(0, 0), rl.Vector2(3, 4)), 5, EPS)
end
function TestVector2Math:testVector2Normalize()
	local v = rl.vector2_normalize(rl.Vector2(3, 4))
	lu.assertAlmostEquals(v.x, 0.6, EPS)
	lu.assertAlmostEquals(v.y, 0.8, EPS)
end
function TestVector2Math:testVector2Negate()
	local v = rl.vector2_negate(rl.Vector2(3, -4))
	lu.assertAlmostEquals(v.x, -3, EPS)
	lu.assertAlmostEquals(v.y, 4, EPS)
end
function TestVector2Math:testVector2Lerp()
	local v = rl.vector2_lerp(rl.Vector2(0, 0), rl.Vector2(10, 10), 0.5)
	lu.assertAlmostEquals(v.x, 5, EPS)
	lu.assertAlmostEquals(v.y, 5, EPS)
end
function TestVector2Math:testVector2Reflect()
	local v = rl.vector2_reflect(rl.Vector2(1, -1), rl.Vector2(0, 1))
	lu.assertAlmostEquals(v.x, 1, EPS)
	lu.assertAlmostEquals(v.y, 1, EPS)
end
function TestVector2Math:testVector2Rotate()
	local v = rl.vector2_rotate(rl.Vector2(1, 0), math.pi / 2)
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 1, EPS)
end
function TestVector2Math:testVector2Min()
	local v = rl.vector2_min(rl.Vector2(3, 1), rl.Vector2(1, 4))
	lu.assertAlmostEquals(v.x, 1, EPS)
	lu.assertAlmostEquals(v.y, 1, EPS)
end
function TestVector2Math:testVector2Max()
	local v = rl.vector2_max(rl.Vector2(3, 1), rl.Vector2(1, 4))
	lu.assertAlmostEquals(v.x, 3, EPS)
	lu.assertAlmostEquals(v.y, 4, EPS)
end
function TestVector2Math:testVector2Invert()
	local v = rl.vector2_invert(rl.Vector2(2, 4))
	lu.assertAlmostEquals(v.x, 0.5, EPS)
	lu.assertAlmostEquals(v.y, 0.25, EPS)
end
function TestVector2Math:testVector2Equals()
	lu.assertEquals(rl.vector2_equals(rl.Vector2(1, 2), rl.Vector2(1, 2)), 1)
end
-- Vector2CrossProduct may not be exported in all raylib versions, tested via operator overloads instead

-- ============================================================================
-- 13. Vector3 math functions
-- ============================================================================
TestVector3Math = {}

function TestVector3Math:testVector3Zero()
	local v = rl.vector3_zero()
	lu.assertEquals(v.x, 0)
	lu.assertEquals(v.y, 0)
	lu.assertEquals(v.z, 0)
end
function TestVector3Math:testVector3One()
	local v = rl.vector3_one()
	lu.assertEquals(v.x, 1)
	lu.assertEquals(v.y, 1)
	lu.assertEquals(v.z, 1)
end
function TestVector3Math:testVector3Add()
	local v = rl.vector3_add(rl.Vector3(1, 2, 3), rl.Vector3(4, 5, 6))
	lu.assertEquals(v.x, 5)
	lu.assertEquals(v.y, 7)
	lu.assertEquals(v.z, 9)
end
function TestVector3Math:testVector3Subtract()
	local v = rl.vector3_subtract(rl.Vector3(5, 7, 9), rl.Vector3(1, 2, 3))
	lu.assertEquals(v.x, 4)
	lu.assertEquals(v.y, 5)
	lu.assertEquals(v.z, 6)
end
function TestVector3Math:testVector3Scale()
	local v = rl.vector3_scale(rl.Vector3(1, 2, 3), 2)
	lu.assertEquals(v.x, 2)
	lu.assertEquals(v.y, 4)
	lu.assertEquals(v.z, 6)
end
function TestVector3Math:testVector3Length()
	lu.assertAlmostEquals(rl.vector3_length(rl.Vector3(1, 2, 2)), 3, EPS)
end
function TestVector3Math:testVector3DotProduct()
	lu.assertAlmostEquals(rl.vector3_dot_product(rl.Vector3(1, 0, 0), rl.Vector3(0, 1, 0)), 0, EPS)
end
function TestVector3Math:testVector3CrossProduct()
	local v = rl.vector3_cross_product(rl.Vector3(1, 0, 0), rl.Vector3(0, 1, 0))
	lu.assertEquals(v.x, 0)
	lu.assertEquals(v.y, 0)
	lu.assertEquals(v.z, 1)
end
function TestVector3Math:testVector3Distance()
	lu.assertAlmostEquals(rl.vector3_distance(rl.Vector3(0, 0, 0), rl.Vector3(1, 2, 2)), 3, EPS)
end
function TestVector3Math:testVector3Normalize()
	local v = rl.vector3_normalize(rl.Vector3(0, 0, 5))
	lu.assertAlmostEquals(v.z, 1, EPS)
end
function TestVector3Math:testVector3Negate()
	local v = rl.vector3_negate(rl.Vector3(1, -2, 3))
	lu.assertEquals(v.x, -1)
	lu.assertEquals(v.y, 2)
	lu.assertEquals(v.z, -3)
end
function TestVector3Math:testVector3Lerp()
	local v = rl.vector3_lerp(rl.Vector3(0, 0, 0), rl.Vector3(10, 20, 30), 0.5)
	lu.assertAlmostEquals(v.x, 5, EPS)
	lu.assertAlmostEquals(v.y, 10, EPS)
	lu.assertAlmostEquals(v.z, 15, EPS)
end
function TestVector3Math:testVector3Reflect()
	local v = rl.vector3_reflect(rl.Vector3(1, -1, 0), rl.Vector3(0, 1, 0))
	lu.assertAlmostEquals(v.x, 1, EPS)
	lu.assertAlmostEquals(v.y, 1, EPS)
end
function TestVector3Math:testVector3Min()
	local v = rl.vector3_min(rl.Vector3(3, 1, 5), rl.Vector3(1, 4, 2))
	lu.assertEquals(v.x, 1)
	lu.assertEquals(v.y, 1)
	lu.assertEquals(v.z, 2)
end
function TestVector3Math:testVector3Max()
	local v = rl.vector3_max(rl.Vector3(3, 1, 5), rl.Vector3(1, 4, 2))
	lu.assertEquals(v.x, 3)
	lu.assertEquals(v.y, 4)
	lu.assertEquals(v.z, 5)
end
function TestVector3Math:testVector3Invert()
	local v = rl.vector3_invert(rl.Vector3(2, 4, 5))
	lu.assertAlmostEquals(v.x, 0.5, EPS)
	lu.assertAlmostEquals(v.y, 0.25, EPS)
	lu.assertAlmostEquals(v.z, 0.2, EPS)
end
function TestVector3Math:testVector3Equals()
	lu.assertEquals(rl.vector3_equals(rl.Vector3(1, 2, 3), rl.Vector3(1, 2, 3)), 1)
end
function TestVector3Math:testVector3MoveTowards()
	local v = rl.vector3_move_towards(rl.Vector3(0, 0, 0), rl.Vector3(10, 0, 0), 3)
	lu.assertAlmostEquals(v.x, 3, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
	lu.assertAlmostEquals(v.z, 0, EPS)
end

-- ============================================================================
-- 14. Vector4 math functions
-- ============================================================================
TestVector4Math = {}

function TestVector4Math:testVector4Zero()
	local v = rl.vector4_zero()
	lu.assertEquals(v.x, 0)
	lu.assertEquals(v.y, 0)
	lu.assertEquals(v.z, 0)
	lu.assertEquals(v.w, 0)
end
function TestVector4Math:testVector4One()
	local v = rl.vector4_one()
	lu.assertEquals(v.x, 1)
	lu.assertEquals(v.y, 1)
	lu.assertEquals(v.z, 1)
	lu.assertEquals(v.w, 1)
end
function TestVector4Math:testVector4Add()
	local v = rl.vector4_add(rl.Vector4(1, 2, 3, 4), rl.Vector4(5, 6, 7, 8))
	lu.assertEquals(v.x, 6)
	lu.assertEquals(v.y, 8)
	lu.assertEquals(v.z, 10)
	lu.assertEquals(v.w, 12)
end
function TestVector4Math:testVector4Scale()
	local v = rl.vector4_scale(rl.Vector4(1, 2, 3, 4), 2)
	lu.assertEquals(v.x, 2)
	lu.assertEquals(v.y, 4)
	lu.assertEquals(v.z, 6)
	lu.assertEquals(v.w, 8)
end
function TestVector4Math:testVector4Length()
	lu.assertAlmostEquals(rl.vector4_length(rl.Vector4(1, 0, 0, 0)), 1, EPS)
end
function TestVector4Math:testVector4Normalize()
	local v = rl.vector4_normalize(rl.Vector4(0, 0, 0, 5))
	lu.assertAlmostEquals(v.w, 1, EPS)
end
function TestVector4Math:testVector4Lerp()
	local v = rl.vector4_lerp(rl.Vector4(0, 0, 0, 0), rl.Vector4(10, 20, 30, 40), 0.25)
	lu.assertAlmostEquals(v.x, 2.5, EPS)
	lu.assertAlmostEquals(v.y, 5, EPS)
	lu.assertAlmostEquals(v.z, 7.5, EPS)
	lu.assertAlmostEquals(v.w, 10, EPS)
end
function TestVector4Math:testVector4Equals()
	lu.assertEquals(rl.vector4_equals(rl.Vector4(1, 2, 3, 4), rl.Vector4(1, 2, 3, 4)), 1)
end
function TestVector4Math:testVector4DotProduct()
	lu.assertAlmostEquals(rl.vector4_dot_product(rl.Vector4(1, 0, 0, 0), rl.Vector4(0, 1, 0, 0)), 0, EPS)
end
function TestVector4Math:testVector4Min()
	local v = rl.vector4_min(rl.Vector4(3, 1, 5, 2), rl.Vector4(1, 4, 2, 6))
	lu.assertEquals(v.x, 1)
	lu.assertEquals(v.y, 1)
	lu.assertEquals(v.z, 2)
	lu.assertEquals(v.w, 2)
end
function TestVector4Math:testVector4Max()
	local v = rl.vector4_max(rl.Vector4(3, 1, 5, 2), rl.Vector4(1, 4, 2, 6))
	lu.assertEquals(v.x, 3)
	lu.assertEquals(v.y, 4)
	lu.assertEquals(v.z, 5)
	lu.assertEquals(v.w, 6)
end

-- ============================================================================
-- 15. Matrix math functions
-- ============================================================================
TestMatrixMath = {}

function TestMatrixMath:testMatrixIdentity()
	local m = rl.matrix_identity()
	lu.assertAlmostEquals(m.m0, 1, EPS)
	lu.assertAlmostEquals(m.m5, 1, EPS)
	lu.assertAlmostEquals(m.m10, 1, EPS)
	lu.assertAlmostEquals(m.m15, 1, EPS)
	lu.assertAlmostEquals(m.m1, 0, EPS)
	lu.assertAlmostEquals(m.m4, 0, EPS)
end
function TestMatrixMath:testMatrixTranslate()
	local m = rl.matrix_translate(10, 20, 30)
	lu.assertAlmostEquals(m.m12, 10, EPS)
	lu.assertAlmostEquals(m.m13, 20, EPS)
	lu.assertAlmostEquals(m.m14, 30, EPS)
	lu.assertAlmostEquals(m.m15, 1, EPS)
end
function TestMatrixMath:testMatrixScale()
	local m = rl.matrix_scale(2, 3, 4)
	lu.assertAlmostEquals(m.m0, 2, EPS)
	lu.assertAlmostEquals(m.m5, 3, EPS)
	lu.assertAlmostEquals(m.m10, 4, EPS)
	lu.assertAlmostEquals(m.m15, 1, EPS)
end
function TestMatrixMath:testMatrixMultiplyIdentity()
	local r = rl.matrix_multiply(rl.matrix_identity(), rl.matrix_identity())
	lu.assertAlmostEquals(r.m0, 1, EPS)
	lu.assertAlmostEquals(r.m5, 1, EPS)
	lu.assertAlmostEquals(r.m10, 1, EPS)
	lu.assertAlmostEquals(r.m15, 1, EPS)
end
function TestMatrixMath:testMatrixDeterminantIdentity()
	lu.assertTrue(approx(rl.matrix_determinant(rl.matrix_identity()), 1.0))
end
function TestMatrixMath:testMatrixDeterminantScale()
	lu.assertTrue(approx(rl.matrix_determinant(rl.matrix_scale(2, 3, 4)), 24.0))
end
function TestMatrixMath:testMatrixTraceIdentity()
	lu.assertTrue(approx(rl.matrix_trace(rl.matrix_identity()), 4.0))
end
function TestMatrixMath:testMatrixTranspose()
	local r = rl.matrix_transpose(rl.matrix_translate(1, 2, 3))
	lu.assertAlmostEquals(r.m3, 1, EPS)
	lu.assertAlmostEquals(r.m7, 2, EPS)
	lu.assertAlmostEquals(r.m11, 3, EPS)
end
function TestMatrixMath:testMatrixInvert()
	local r = rl.matrix_invert(rl.matrix_scale(2, 2, 2))
	lu.assertAlmostEquals(r.m0, 0.5, EPS)
	lu.assertAlmostEquals(r.m5, 0.5, EPS)
	lu.assertAlmostEquals(r.m10, 0.5, EPS)
end
function TestMatrixMath:testMatrixRotateXZero()
	local r = rl.matrix_rotate_x(0)
	lu.assertAlmostEquals(r.m0, 1, EPS)
	lu.assertAlmostEquals(r.m5, 1, EPS)
	lu.assertAlmostEquals(r.m10, 1, EPS)
end
function TestMatrixMath:testMatrixRotateYZero()
	local r = rl.matrix_rotate_y(0)
	lu.assertAlmostEquals(r.m0, 1, EPS)
	lu.assertAlmostEquals(r.m5, 1, EPS)
	lu.assertAlmostEquals(r.m10, 1, EPS)
end
function TestMatrixMath:testMatrixRotateZZero()
	local r = rl.matrix_rotate_z(0)
	lu.assertAlmostEquals(r.m0, 1, EPS)
	lu.assertAlmostEquals(r.m5, 1, EPS)
	lu.assertAlmostEquals(r.m10, 1, EPS)
end
function TestMatrixMath:testMatrixAddIdentity()
	local r = rl.matrix_add(rl.matrix_identity(), rl.matrix_identity())
	lu.assertAlmostEquals(r.m0, 2, EPS)
	lu.assertAlmostEquals(r.m5, 2, EPS)
end
function TestMatrixMath:testMatrixSubtractIdentity()
	local r = rl.matrix_subtract(rl.matrix_identity(), rl.matrix_identity())
	lu.assertAlmostEquals(r.m0, 0, EPS)
	lu.assertAlmostEquals(r.m5, 0, EPS)
end

-- ============================================================================
-- 16. Quaternion functions
-- ============================================================================
TestQuaternion = {}

function TestQuaternion:testQuaternionIdentity()
	local q = rl.quaternion_identity()
	lu.assertAlmostEquals(q.x, 0, EPS)
	lu.assertAlmostEquals(q.y, 0, EPS)
	lu.assertAlmostEquals(q.z, 0, EPS)
	lu.assertAlmostEquals(q.w, 1, EPS)
end
function TestQuaternion:testQuaternionLength()
	lu.assertTrue(approx(rl.quaternion_length(rl.quaternion_identity()), 1.0))
end
function TestQuaternion:testQuaternionNormalize()
	local r = rl.quaternion_normalize(rl.Vector4(0, 0, 0, 2))
	lu.assertTrue(approx(r.w, 1.0))
end
function TestQuaternion:testQuaternionInvert()
	local r = rl.quaternion_invert(rl.quaternion_identity())
	lu.assertAlmostEquals(r.w, 1, EPS)
end
function TestQuaternion:testQuaternionMultiplyIdentity()
	local id = rl.quaternion_identity()
	local r = rl.quaternion_multiply(id, id)
	lu.assertAlmostEquals(r.w, 1, EPS)
end
function TestQuaternion:testQuaternionFromEulerZero()
	local r = rl.quaternion_from_euler(0, 0, 0)
	lu.assertAlmostEquals(r.w, 1, EPS)
end
function TestQuaternion:testQuaternionToEuler()
	local r = rl.quaternion_to_euler(rl.quaternion_identity())
	lu.assertTrue(approx(r.x, 0))
	lu.assertTrue(approx(r.y, 0))
	lu.assertTrue(approx(r.z, 0))
end
function TestQuaternion:testQuaternionFromAxisAngleZero()
	local r = rl.quaternion_from_axis_angle(rl.Vector3(0, 1, 0), 0)
	lu.assertTrue(approx(r.w, 1.0))
end
function TestQuaternion:testQuaternionFromAxisAnglePi()
	local r = rl.quaternion_from_axis_angle(rl.Vector3(0, 0, 1), math.pi)
	local len = math.sqrt(r.x * r.x + r.y * r.y + r.z * r.z + r.w * r.w)
	lu.assertTrue(approx(len, 1.0))
	lu.assertTrue(approx(r.w, 0))
end
function TestQuaternion:testQuaternionSlerp()
	local id = rl.quaternion_identity()
	local r = rl.quaternion_slerp(id, id, 0.5)
	lu.assertAlmostEquals(r.w, 1, EPS)
end
function TestQuaternion:testQuaternionEquals()
	lu.assertEquals(rl.quaternion_equals(rl.quaternion_identity(), rl.quaternion_identity()), 1)
end
function TestQuaternion:testQuaternionAdd()
	local r = rl.quaternion_add(rl.Vector4(1, 2, 3, 4), rl.Vector4(5, 6, 7, 8))
	lu.assertAlmostEquals(r.x, 6, EPS)
	lu.assertAlmostEquals(r.y, 8, EPS)
	lu.assertAlmostEquals(r.z, 10, EPS)
	lu.assertAlmostEquals(r.w, 12, EPS)
end
function TestQuaternion:testQuaternionScale()
	local r = rl.quaternion_scale(rl.Vector4(1, 2, 3, 4), 2)
	lu.assertAlmostEquals(r.x, 2, EPS)
	lu.assertAlmostEquals(r.z, 6, EPS)
end
function TestQuaternion:testQuaternionToMatrix()
	local m = rl.quaternion_to_matrix(rl.quaternion_identity())
	lu.assertAlmostEquals(m.m0, 1, EPS)
	lu.assertAlmostEquals(m.m5, 1, EPS)
	lu.assertAlmostEquals(m.m10, 1, EPS)
	lu.assertAlmostEquals(m.m15, 1, EPS)
end

-- ============================================================================
-- 17. FFI dispatch metatable
-- ============================================================================
TestFFIDispatch = {}

function TestFFIDispatch:testClampDispatch()
	lu.assertAlmostEquals(rl.clamp(5, 0, 10), 5, EPS)
end
function TestFFIDispatch:testClampCached()
	rl.clamp(1, 0, 10)
	lu.assertNotNil(rawget(rl, "clamp"))
end
function TestFFIDispatch:testVector2ZeroDispatch()
	local v = rl.vector2_zero()
	lu.assertAlmostEquals(v.x, 0, EPS)
	lu.assertAlmostEquals(v.y, 0, EPS)
end
function TestFFIDispatch:testSnakeCaseDispatch()
	-- Verify snake_case names resolve to the correct CamelCase C functions
	lu.assertAlmostEquals(rl.clamp(5, 0, 3), 3, EPS)
	lu.assertAlmostEquals(rl.lerp(0, 10, 0.5), 5, EPS)
	local v = rl.vector2_add(rl.Vector2(1, 2), rl.Vector2(3, 4))
	lu.assertAlmostEquals(v.x, 4, EPS)
end
function TestFFIDispatch:testSnakeCaseCached()
	-- After first access, the snake_case name should be cached in the rl table
	rl.vector2_one()
	lu.assertNotNil(rawget(rl, "vector2_one"))
end
function TestFFIDispatch:testNonExistentReturnsNil()
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
TestCollision2D = {}

function TestCollision2D:testCheckCollisionRecsOverlap()
	lu.assertTrue(rl.check_collision_recs(rl.Rectangle(0, 0, 10, 10), rl.Rectangle(5, 5, 10, 10)))
end
function TestCollision2D:testCheckCollisionRecsNoOverlap()
	lu.assertFalse(rl.check_collision_recs(rl.Rectangle(0, 0, 10, 10), rl.Rectangle(20, 20, 10, 10)))
end
function TestCollision2D:testCheckCollisionCirclesOverlap()
	lu.assertTrue(rl.check_collision_circles(rl.Vector2(0, 0), 5, rl.Vector2(3, 0), 5))
end
function TestCollision2D:testCheckCollisionCirclesNoOverlap()
	lu.assertFalse(rl.check_collision_circles(rl.Vector2(0, 0), 5, rl.Vector2(100, 0), 5))
end
function TestCollision2D:testCheckCollisionCircleRecOverlap()
	lu.assertTrue(rl.check_collision_circle_rec(rl.Vector2(5, 5), 5, rl.Rectangle(0, 0, 10, 10)))
end
function TestCollision2D:testCheckCollisionCircleRecNoOverlap()
	lu.assertFalse(rl.check_collision_circle_rec(rl.Vector2(50, 50), 1, rl.Rectangle(0, 0, 10, 10)))
end
function TestCollision2D:testCheckCollisionPointRecInside()
	lu.assertTrue(rl.check_collision_point_rec(rl.Vector2(5, 5), rl.Rectangle(0, 0, 10, 10)))
end
function TestCollision2D:testCheckCollisionPointRecOutside()
	lu.assertFalse(rl.check_collision_point_rec(rl.Vector2(50, 50), rl.Rectangle(0, 0, 10, 10)))
end
function TestCollision2D:testCheckCollisionPointCircleInside()
	lu.assertTrue(rl.check_collision_point_circle(rl.Vector2(1, 1), rl.Vector2(0, 0), 5))
end
function TestCollision2D:testCheckCollisionPointCircleOutside()
	lu.assertFalse(rl.check_collision_point_circle(rl.Vector2(100, 100), rl.Vector2(0, 0), 5))
end
function TestCollision2D:testGetCollisionRec()
	local col = rl.get_collision_rec(rl.Rectangle(0, 0, 10, 10), rl.Rectangle(5, 5, 10, 10))
	lu.assertAlmostEquals(col.x, 5, EPS)
	lu.assertAlmostEquals(col.y, 5, EPS)
	lu.assertAlmostEquals(col.width, 5, EPS)
	lu.assertAlmostEquals(col.height, 5, EPS)
end
function TestCollision2D:testCheckCollisionPointTriangleInside()
	lu.assertTrue(
		rl.check_collision_point_triangle(rl.Vector2(1, 1), rl.Vector2(0, 0), rl.Vector2(10, 0), rl.Vector2(0, 10))
	)
end
function TestCollision2D:testCheckCollisionPointTriangleOutside()
	lu.assertFalse(
		rl.check_collision_point_triangle(rl.Vector2(50, 50), rl.Vector2(0, 0), rl.Vector2(10, 0), rl.Vector2(0, 10))
	)
end

-- ============================================================================
-- 19. 3D collision functions
-- ============================================================================
TestCollision3D = {}

function TestCollision3D:testCheckCollisionSpheresOverlap()
	lu.assertTrue(rl.check_collision_spheres(rl.Vector3(0, 0, 0), 5, rl.Vector3(3, 0, 0), 5))
end
function TestCollision3D:testCheckCollisionSpheresNoOverlap()
	lu.assertFalse(rl.check_collision_spheres(rl.Vector3(0, 0, 0), 5, rl.Vector3(100, 0, 0), 5))
end
function TestCollision3D:testCheckCollisionBoxesOverlap()
	local b1 = rl.BoundingBox(rl.Vector3(0, 0, 0), rl.Vector3(10, 10, 10))
	local b2 = rl.BoundingBox(rl.Vector3(5, 5, 5), rl.Vector3(15, 15, 15))
	lu.assertTrue(rl.check_collision_boxes(b1, b2))
end
function TestCollision3D:testCheckCollisionBoxesNoOverlap()
	local b1 = rl.BoundingBox(rl.Vector3(0, 0, 0), rl.Vector3(10, 10, 10))
	local b2 = rl.BoundingBox(rl.Vector3(50, 50, 50), rl.Vector3(60, 60, 60))
	lu.assertFalse(rl.check_collision_boxes(b1, b2))
end
function TestCollision3D:testCheckCollisionBoxSphereOverlap()
	local box = rl.BoundingBox(rl.Vector3(0, 0, 0), rl.Vector3(10, 10, 10))
	lu.assertTrue(rl.check_collision_box_sphere(box, rl.Vector3(5, 5, 5), 5))
end
function TestCollision3D:testGetRayCollisionSphereHit()
	local ray = rl.Ray(rl.Vector3(0, 0, 0), rl.Vector3(1, 0, 0))
	local result = rl.get_ray_collision_sphere(ray, rl.Vector3(10, 0, 0), 5)
	lu.assertTrue(result.hit)
end
function TestCollision3D:testGetRayCollisionSphereMiss()
	local ray = rl.Ray(rl.Vector3(0, 0, 0), rl.Vector3(1, 0, 0))
	local result = rl.get_ray_collision_sphere(ray, rl.Vector3(0, 100, 0), 1)
	lu.assertFalse(result.hit)
end
function TestCollision3D:testGetRayCollisionBoxHit()
	local ray = rl.Ray(rl.Vector3(0, 0, 0), rl.Vector3(1, 0, 0))
	local box = rl.BoundingBox(rl.Vector3(5, -5, -5), rl.Vector3(15, 5, 5))
	lu.assertTrue(rl.get_ray_collision_box(ray, box).hit)
end

-- ============================================================================
-- 20. Color utility functions
-- ============================================================================
TestColorUtils = {}

function TestColorUtils:testColorToInt()
	lu.assertNotEquals(rl.color_to_int(rl.WHITE), 0)
end
function TestColorUtils:testFade()
	local c = rl.fade(rl.RED, 0.5)
	lu.assertEquals(c.r, 230)
	lu.assertEquals(c.g, 41)
	lu.assertEquals(c.b, 55)
	lu.assertTrue(c.a >= 127 and c.a <= 128)
end
function TestColorUtils:testColorAlphaZero()
	lu.assertEquals(rl.color_alpha(rl.RED, 0.0).a, 0)
end
function TestColorUtils:testColorAlphaOne()
	lu.assertEquals(rl.color_alpha(rl.RED, 1.0).a, 255)
end
function TestColorUtils:testGetColor()
	local c = rl.get_color(0xFF0000FF)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
	lu.assertEquals(c.a, 255)
end
function TestColorUtils:testColorIsEqualSame()
	lu.assertTrue(rl.color_is_equal(rl.WHITE, rl.WHITE))
end
function TestColorUtils:testColorIsEqualDifferent()
	lu.assertFalse(rl.color_is_equal(rl.WHITE, rl.BLACK))
end
function TestColorUtils:testColorToHSV()
	local hsv = rl.color_to_hsv(rl.RED)
	-- RED (230,41,55) hue is around 355 degrees
	lu.assertTrue(hsv.x >= 350 or hsv.x <= 10, "Hue of RED should be near 0/360, got: " .. hsv.x)
	lu.assertTrue(hsv.y > 0, "Saturation should be > 0")
end
function TestColorUtils:testColorFromHSV()
	local c = rl.color_from_hsv(0, 1, 1)
	lu.assertEquals(c.r, 255)
	lu.assertEquals(c.g, 0)
	lu.assertEquals(c.b, 0)
end
function TestColorUtils:testColorNormalize()
	local v = rl.color_normalize(rl.WHITE)
	lu.assertAlmostEquals(v.x, 1.0, EPS)
	lu.assertAlmostEquals(v.y, 1.0, EPS)
	lu.assertAlmostEquals(v.z, 1.0, EPS)
	lu.assertAlmostEquals(v.w, 1.0, EPS)
end
function TestColorUtils:testColorLerp()
	local c = rl.color_lerp(rl.BLACK, rl.WHITE, 0.5)
	lu.assertTrue(c.r >= 127 and c.r <= 128)
	lu.assertEquals(c.a, 255)
end
function TestColorUtils:testGetPixelDataSize()
	lu.assertTrue(rl.get_pixel_data_size(1, 1, 7) > 0)
end

-- ============================================================================
-- 21. Text utility functions
-- ============================================================================
TestTextUtils = {}

function TestTextUtils:testTextIsEqualTrue()
	lu.assertTrue(rl.text_is_equal("hello", "hello"))
end
function TestTextUtils:testTextIsEqualFalse()
	lu.assertFalse(rl.text_is_equal("hello", "world"))
end
function TestTextUtils:testTextLengthHello()
	lu.assertEquals(rl.text_length("hello"), 5)
end
function TestTextUtils:testTextLengthEmpty()
	lu.assertEquals(rl.text_length(""), 0)
end
function TestTextUtils:testTextToUpper()
	lu.assertEquals(ffi.string(rl.text_to_upper("hello")), "HELLO")
end
function TestTextUtils:testTextToLower()
	lu.assertEquals(ffi.string(rl.text_to_lower("HELLO")), "hello")
end
function TestTextUtils:testTextToInteger42()
	lu.assertEquals(rl.text_to_integer("42"), 42)
end
function TestTextUtils:testTextToIntegerZero()
	lu.assertEquals(rl.text_to_integer("0"), 0)
end
function TestTextUtils:testTextToFloat()
	lu.assertTrue(approx(rl.text_to_float("3.14"), 3.14))
end
function TestTextUtils:testTextFindIndexFound()
	lu.assertEquals(rl.text_find_index("hello world", "world"), 6)
end
-- measure_text with default font requires init_window, tested in TestWindowIntegration instead
function TestTextUtils:testGetCodepointCount()
	lu.assertEquals(rl.get_codepoint_count("Hello"), 5)
end
function TestTextUtils:testTextSubtext()
	lu.assertEquals(ffi.string(rl.text_subtext("Hello World", 6, 5)), "World")
end

-- ============================================================================
-- 22. File utility functions
-- ============================================================================
TestFileUtils = {}

function TestFileUtils:testFileExistsTrue()
	lu.assertTrue(rl.file_exists("raylib.lua"))
end
function TestFileUtils:testFileExistsFalse()
	lu.assertFalse(rl.file_exists("nonexistent_file_xyz.abc"))
end
function TestFileUtils:testDirectoryExistsTrue()
	lu.assertTrue(rl.directory_exists("."))
end
function TestFileUtils:testDirectoryExistsFalse()
	lu.assertFalse(rl.directory_exists("/nonexistent_dir_xyz"))
end
function TestFileUtils:testIsFileExtensionTrue()
	lu.assertTrue(rl.is_file_extension("test.png", ".png"))
end
function TestFileUtils:testIsFileExtensionFalse()
	lu.assertFalse(rl.is_file_extension("test.png", ".jpg"))
end
function TestFileUtils:testGetFileExtension()
	lu.assertEquals(ffi.string(rl.get_file_extension("test.png")), ".png")
end
function TestFileUtils:testGetFileName()
	lu.assertEquals(ffi.string(rl.get_file_name("/path/to/file.txt")), "file.txt")
end
function TestFileUtils:testGetFileNameWithoutExt()
	lu.assertEquals(ffi.string(rl.get_file_name_without_ext("/path/to/file.txt")), "file")
end
function TestFileUtils:testGetWorkingDirectory()
	lu.assertTrue(#ffi.string(rl.get_working_directory()) > 0)
end
function TestFileUtils:testIsPathFileTrue()
	lu.assertTrue(rl.is_path_file("raylib.lua"))
end
function TestFileUtils:testIsPathFileFalseOnDir()
	lu.assertFalse(rl.is_path_file("."))
end
function TestFileUtils:testGetFileLengthPositive()
	lu.assertTrue(rl.get_file_length("raylib.lua") > 0)
end
function TestFileUtils:testIsFileNameValid()
	lu.assertTrue(rl.is_file_name_valid("test.lua"))
end

-- ============================================================================
-- 23. Window/drawing integration (requires InitWindow)
-- NOTE: GLFW cannot reliably re-initialize after CloseWindow in the same
--       process, so we open the window once and run all checks in one test.
-- ============================================================================
TestWindowIntegration = {}

function TestWindowIntegration:testAllWindowFunctions()
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
TestSnakeCaseConversion = {}

function TestSnakeCaseConversion:testBasicFunctions()
	-- Verify fundamental snake_case names resolve to working functions
	lu.assertNotNil(rl.clamp, "clamp should resolve")
	lu.assertNotNil(rl.lerp, "lerp should resolve")
	lu.assertNotNil(rl.normalize, "normalize should resolve")
	lu.assertNotNil(rl.remap, "remap should resolve")
	lu.assertNotNil(rl.wrap, "wrap should resolve")
	lu.assertNotNil(rl.float_equals, "float_equals should resolve")
	lu.assertNotNil(rl.fade, "fade should resolve")
end

function TestSnakeCaseConversion:testWindowFunctions()
	lu.assertNotNil(rl.file_exists, "file_exists should resolve")
	lu.assertNotNil(rl.directory_exists, "directory_exists should resolve")
	lu.assertNotNil(rl.is_file_extension, "is_file_extension should resolve")
end

function TestSnakeCaseConversion:testVectorFunctions()
	lu.assertNotNil(rl.vector2_zero, "vector2_zero should resolve")
	lu.assertNotNil(rl.vector2_one, "vector2_one should resolve")
	lu.assertNotNil(rl.vector2_add, "vector2_add should resolve")
	lu.assertNotNil(rl.vector3_zero, "vector3_zero should resolve")
	lu.assertNotNil(rl.vector3_cross_product, "vector3_cross_product should resolve")
	lu.assertNotNil(rl.vector4_zero, "vector4_zero should resolve")
end

function TestSnakeCaseConversion:testMatrixFunctions()
	lu.assertNotNil(rl.matrix_identity, "matrix_identity should resolve")
	lu.assertNotNil(rl.matrix_translate, "matrix_translate should resolve")
	lu.assertNotNil(rl.matrix_rotate_x, "matrix_rotate_x should resolve")
	lu.assertNotNil(rl.matrix_rotate_y, "matrix_rotate_y should resolve")
	lu.assertNotNil(rl.matrix_rotate_z, "matrix_rotate_z should resolve")
	lu.assertNotNil(rl.matrix_rotate_xyz, "matrix_rotate_xyz should resolve")
	lu.assertNotNil(rl.matrix_rotate_zyx, "matrix_rotate_zyx should resolve")
end

function TestSnakeCaseConversion:testQuaternionFunctions()
	lu.assertNotNil(rl.quaternion_identity, "quaternion_identity should resolve")
	lu.assertNotNil(rl.quaternion_from_euler, "quaternion_from_euler should resolve")
	lu.assertNotNil(rl.quaternion_to_euler, "quaternion_to_euler should resolve")
	lu.assertNotNil(rl.quaternion_from_axis_angle, "quaternion_from_axis_angle should resolve")
	lu.assertNotNil(rl.quaternion_slerp, "quaternion_slerp should resolve")
end

function TestSnakeCaseConversion:testCollisionFunctions()
	lu.assertNotNil(rl.check_collision_recs, "check_collision_recs should resolve")
	lu.assertNotNil(rl.check_collision_circles, "check_collision_circles should resolve")
	lu.assertNotNil(rl.check_collision_circle_rec, "check_collision_circle_rec should resolve")
	lu.assertNotNil(rl.check_collision_point_rec, "check_collision_point_rec should resolve")
	lu.assertNotNil(rl.check_collision_spheres, "check_collision_spheres should resolve")
	lu.assertNotNil(rl.check_collision_boxes, "check_collision_boxes should resolve")
	lu.assertNotNil(rl.get_collision_rec, "get_collision_rec should resolve")
end

function TestSnakeCaseConversion:testColorFunctions()
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

function TestSnakeCaseConversion:testTextFunctions()
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

function TestSnakeCaseConversion:testFileFunctions()
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

function TestSnakeCaseConversion:testSpecialAcronyms()
	-- FPS, DPI, URL, UTF8, HSV, POT, NN, CW, CCW, CRC32, MD5, SHA1, SHA256, XYZ, ZYX
	-- These can only be fully tested if the C library exports them;
	-- we test the ones we know exist from the collision/math tests above
	lu.assertNotNil(rl.matrix_rotate_xyz, "matrix_rotate_xyz (XYZ acronym) should resolve")
	lu.assertNotNil(rl.matrix_rotate_zyx, "matrix_rotate_zyx (ZYX acronym) should resolve")
	lu.assertNotNil(rl.color_to_hsv, "color_to_hsv (HSV acronym) should resolve")
	lu.assertNotNil(rl.color_from_hsv, "color_from_hsv (HSV acronym) should resolve")
end

function TestSnakeCaseConversion:testSnakeCaseResultsMatchCamelCase()
	-- Verify that snake_case calls produce identical results to direct lib calls
	local snake_result = rl.clamp(5, 0, 3)
	local direct_result = rl.lib.Clamp(5, 0, 3)
	lu.assertAlmostEquals(snake_result, direct_result, EPS)

	local sv = rl.vector2_add(rl.Vector2(1, 2), rl.Vector2(3, 4))
	local dv = rl.lib.Vector2Add(rl.Vector2(1, 2), rl.Vector2(3, 4))
	lu.assertAlmostEquals(sv.x, dv.x, EPS)
	lu.assertAlmostEquals(sv.y, dv.y, EPS)
end

function TestSnakeCaseConversion:testConstructorsStillWork()
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

function TestSnakeCaseConversion:testEnumTablesStillWork()
	-- Enum tables should remain CamelCase and still work
	lu.assertIsTable(rl.KeyboardKey)
	lu.assertIsTable(rl.ConfigFlags)
	lu.assertEquals(rl.KeyboardKey.KEY_SPACE, 32)
end

function TestSnakeCaseConversion:testColorConstantsStillWork()
	-- Color constants should remain ALLCAPS and still work
	lu.assertEquals(rl.WHITE.r, 255)
	lu.assertEquals(rl.BLACK.r, 0)
	lu.assertEquals(rl.RED.r, 230)
end

-- ============================================================================
-- Run
-- ============================================================================
os.exit(lu.LuaUnit.run())
