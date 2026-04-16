-- ==========================================================================
-- Test suite for raymath.lua FFI bindings
-- Uses LuaUnit (https://github.com/bluebird75/luaunit)
-- Run with: luajit test_raymath.lua
-- ==========================================================================

local lu = require("vendor.luaunit")
local ffi = require("ffi")
local rm = require("raymath")

-- Helper: float comparison tolerance
local EPS = 0.001
local function approx(a, b)
	return math.abs(a - b) < EPS
end

-- ============================================================================
-- Module structure and constructors
-- ============================================================================
test_module_structure = {}

function test_module_structure:test_rm_is_table()
	lu.assertIsTable(rm)
end

function test_module_structure:test_rm_lib_exists()
	lu.assertNotNil(rm.lib)
	local t = type(rm.lib)
	lu.assertTrue(t == "cdata" or t == "userdata", "rm.lib should be cdata or userdata, got: " .. t)
end

function test_module_structure:test_constructor_functions_exist()
	for _, name in ipairs({ "vector2", "vector3", "vector4", "matrix", "quaternion" }) do
		lu.assertIsFunction(rm[name], "Constructor missing: " .. name)
	end
end

test_constructors = {}

function test_constructors:test_vector2_constructor_and_defaults()
	local a = rm.vector2(3.5, 7.25)
	lu.assertAlmostEquals(a.x, 3.5, EPS)
	lu.assertAlmostEquals(a.y, 7.25, EPS)

	local b = rm.vector2()
	lu.assertAlmostEquals(b.x, 0, EPS)
	lu.assertAlmostEquals(b.y, 0, EPS)
end

function test_constructors:test_vector3_constructor_and_defaults()
	local a = rm.vector3(1, 2, 3)
	lu.assertAlmostEquals(a.x, 1, EPS)
	lu.assertAlmostEquals(a.y, 2, EPS)
	lu.assertAlmostEquals(a.z, 3, EPS)

	local b = rm.vector3()
	lu.assertAlmostEquals(b.x, 0, EPS)
	lu.assertAlmostEquals(b.y, 0, EPS)
	lu.assertAlmostEquals(b.z, 0, EPS)
end

function test_constructors:test_vector4_constructor_and_defaults()
	local a = rm.vector4(1, 2, 3, 4)
	lu.assertAlmostEquals(a.x, 1, EPS)
	lu.assertAlmostEquals(a.y, 2, EPS)
	lu.assertAlmostEquals(a.z, 3, EPS)
	lu.assertAlmostEquals(a.w, 4, EPS)

	local b = rm.vector4()
	lu.assertAlmostEquals(b.x, 0, EPS)
	lu.assertAlmostEquals(b.y, 0, EPS)
	lu.assertAlmostEquals(b.z, 0, EPS)
	lu.assertAlmostEquals(b.w, 0, EPS)
end

function test_constructors:test_matrix_constructor_returns_identity()
	local m = rm.matrix()
	lu.assertAlmostEquals(m.m0, 1, EPS)
	lu.assertAlmostEquals(m.m5, 1, EPS)
	lu.assertAlmostEquals(m.m10, 1, EPS)
	lu.assertAlmostEquals(m.m15, 1, EPS)
end

function test_constructors:test_quaternion_constructor_defaults_w_to_one()
	local q = rm.quaternion()
	lu.assertAlmostEquals(q.x, 0, EPS)
	lu.assertAlmostEquals(q.y, 0, EPS)
	lu.assertAlmostEquals(q.z, 0, EPS)
	lu.assertAlmostEquals(q.w, 1, EPS)
end

test_tostring = {}

function test_tostring:test_vector2()
	lu.assertEquals(tostring(rm.vector2(1.5, 2.5)), "Vector2(1.500, 2.500)")
end

function test_tostring:test_vector3()
	lu.assertEquals(tostring(rm.vector3(1, 2, 3)), "Vector3(1.000, 2.000, 3.000)")
end

function test_tostring:test_vector4()
	lu.assertEquals(tostring(rm.vector4(1, 2, 3, 4)), "Vector4(1.000, 2.000, 3.000, 4.000)")
end

-- ============================================================================
-- Raymath Scalar Functions
-- ============================================================================
test_raymath_scalar = {}

function test_raymath_scalar:test_clamp_in_range()
	lu.assertEquals(rm.clamp(5.0, 0.0, 10.0), 5.0)
end

function test_raymath_scalar:test_clamp_below_min()
	lu.assertEquals(rm.clamp(-5.0, 0.0, 10.0), 0.0)
end

function test_raymath_scalar:test_clamp_above_max()
	lu.assertEquals(rm.clamp(15.0, 0.0, 10.0), 10.0)
end

function test_raymath_scalar:test_lerp_midpoint()
	lu.assertTrue(approx(rm.lerp(0.0, 10.0, 0.5), 5.0))
end

function test_raymath_scalar:test_lerp_start()
	lu.assertTrue(approx(rm.lerp(0.0, 10.0, 0.0), 0.0))
end

function test_raymath_scalar:test_lerp_end()
	lu.assertTrue(approx(rm.lerp(0.0, 10.0, 1.0), 10.0))
end

function test_raymath_scalar:test_normalize_mid()
	lu.assertTrue(approx(rm.normalize(5.0, 0.0, 10.0), 0.5))
end

function test_raymath_scalar:test_remap()
	lu.assertTrue(approx(rm.remap(5.0, 0.0, 10.0, 0.0, 100.0), 50.0))
end

function test_raymath_scalar:test_wrap_above()
	lu.assertTrue(approx(rm.wrap(12.0, 0.0, 10.0), 2.0))
end

function test_raymath_scalar:test_wrap_below()
	lu.assertTrue(approx(rm.wrap(-2.0, 0.0, 10.0), 8.0))
end

function test_raymath_scalar:test_float_equals_true()
	lu.assertEquals(rm.float_equals(1.0, 1.0000001), 1)
end

function test_raymath_scalar:test_float_equals_false()
	lu.assertEquals(rm.float_equals(1.0, 2.0), 0)
end

-- ============================================================================
-- Vector2 Math Functions
-- ============================================================================
test_vector2_math = {}

function test_vector2_math:test_vector2_zero()
	local v = rm.vector2_zero()
	lu.assertEquals(v.x, 0.0)
	lu.assertEquals(v.y, 0.0)
end

function test_vector2_math:test_vector2_one()
	local v = rm.vector2_one()
	lu.assertEquals(v.x, 1.0)
	lu.assertEquals(v.y, 1.0)
end

function test_vector2_math:test_vector2_add()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(3, 4)
	local result = rm.vector2_add(v1, v2)
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function test_vector2_math:test_vector2_subtract()
	local v1 = rm.vector2(5, 5)
	local v2 = rm.vector2(2, 3)
	local result = rm.vector2_subtract(v1, v2)
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
end

function test_vector2_math:test_vector2_scale()
	local v = rm.vector2(2, 3)
	local result = rm.vector2_scale(v, 2.0)
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function test_vector2_math:test_vector2_length()
	local v = rm.vector2(3, 4)
	lu.assertTrue(approx(rm.vector2_length(v), 5.0))
end

function test_vector2_math:test_vector2_length_sqr()
	local v = rm.vector2(3, 4)
	lu.assertTrue(approx(rm.vector2_length_sqr(v), 25.0))
end

function test_vector2_math:test_vector2_dot_product_perpendicular()
	local v1 = rm.vector2(1, 0)
	local v2 = rm.vector2(0, 1)
	lu.assertTrue(approx(rm.vector2_dot_product(v1, v2), 0.0))
end

function test_vector2_math:test_vector2_dot_product_parallel()
	local v1 = rm.vector2(1, 0)
	local v2 = rm.vector2(2, 0)
	lu.assertTrue(approx(rm.vector2_dot_product(v1, v2), 2.0))
end

function test_vector2_math:test_vector2_distance()
	local v1 = rm.vector2(0, 0)
	local v2 = rm.vector2(3, 4)
	lu.assertTrue(approx(rm.vector2_distance(v1, v2), 5.0))
end

function test_vector2_math:test_vector2_normalize()
	local v = rm.vector2(3, 4)
	local result = rm.vector2_normalize(v)
	lu.assertTrue(approx(rm.vector2_length(result), 1.0))
end

function test_vector2_math:test_vector2_negate()
	local v = rm.vector2(1, 2)
	local result = rm.vector2_negate(v)
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
end

function test_vector2_math:test_vector2_lerp()
	local v1 = rm.vector2(0, 0)
	local v2 = rm.vector2(10, 20)
	local result = rm.vector2_lerp(v1, v2, 0.5)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 10.0))
end

function test_vector2_math:test_vector2_reflect()
	local v = rm.vector2(1, -1)
	local normal = rm.vector2(0, 1)
	local result = rm.vector2_reflect(v, normal)
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 1.0))
end

function test_vector2_math:test_vector2_rotate()
	local v = rm.vector2(1, 0)
	local result = rm.vector2_rotate(v, math.pi / 2)
	lu.assertTrue(approx(result.x, 0.0, 0.01))
	lu.assertTrue(approx(result.y, 1.0, 0.01))
end

function test_vector2_math:test_vector2_min()
	local v1 = rm.vector2(1, 5)
	local v2 = rm.vector2(3, 2)
	local result = rm.vector2_min(v1, v2)
	lu.assertEquals(result.x, 1.0)
	lu.assertEquals(result.y, 2.0)
end

function test_vector2_math:test_vector2_max()
	local v1 = rm.vector2(1, 5)
	local v2 = rm.vector2(3, 2)
	local result = rm.vector2_max(v1, v2)
	lu.assertEquals(result.x, 3.0)
	lu.assertEquals(result.y, 5.0)
end

function test_vector2_math:test_vector2_invert()
	local v = rm.vector2(2, 4)
	local result = rm.vector2_invert(v)
	lu.assertTrue(approx(result.x, 0.5))
	lu.assertTrue(approx(result.y, 0.25))
end

function test_vector2_math:test_vector2_equals()
	local v1 = rm.vector2(1.0, 2.0)
	local v2 = rm.vector2(1.0, 2.0)
	lu.assertEquals(rm.vector2_equals(v1, v2), 1)
end

-- ============================================================================
-- Vector3 Math Functions
-- ============================================================================
test_vector3_math = {}

function test_vector3_math:test_vector3_zero()
	local v = rm.vector3_zero()
	lu.assertEquals(v.x, 0.0)
	lu.assertEquals(v.y, 0.0)
	lu.assertEquals(v.z, 0.0)
end

function test_vector3_math:test_vector3_one()
	local v = rm.vector3_one()
	lu.assertEquals(v.x, 1.0)
	lu.assertEquals(v.y, 1.0)
	lu.assertEquals(v.z, 1.0)
end

function test_vector3_math:test_vector3_add()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(4, 5, 6)
	local result = rm.vector3_add(v1, v2)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 7.0))
	lu.assertTrue(approx(result.z, 9.0))
end

function test_vector3_math:test_vector3_subtract()
	local v1 = rm.vector3(5, 5, 5)
	local v2 = rm.vector3(2, 3, 4)
	local result = rm.vector3_subtract(v1, v2)
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 1.0))
end

function test_vector3_math:test_vector3_scale()
	local v = rm.vector3(1, 2, 3)
	local result = rm.vector3_scale(v, 2.0)
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
end

function test_vector3_math:test_vector3_length()
	local v = rm.vector3(1, 2, 2)
	lu.assertTrue(approx(rm.vector3_length(v), 3.0))
end

function test_vector3_math:test_vector3_dot_product()
	local v1 = rm.vector3(1, 0, 0)
	local v2 = rm.vector3(0, 1, 0)
	lu.assertTrue(approx(rm.vector3_dot_product(v1, v2), 0.0))
end

function test_vector3_math:test_vector3_cross_product()
	local v1 = rm.vector3(1, 0, 0)
	local v2 = rm.vector3(0, 1, 0)
	local result = rm.vector3_cross_product(v1, v2)
	lu.assertTrue(approx(result.x, 0.0))
	lu.assertTrue(approx(result.y, 0.0))
	lu.assertTrue(approx(result.z, 1.0))
end

function test_vector3_math:test_vector3_distance()
	local v1 = rm.vector3(0, 0, 0)
	local v2 = rm.vector3(1, 2, 2)
	lu.assertTrue(approx(rm.vector3_distance(v1, v2), 3.0))
end

function test_vector3_math:test_vector3_normalize()
	local v = rm.vector3(1, 2, 2)
	local result = rm.vector3_normalize(v)
	lu.assertTrue(approx(rm.vector3_length(result), 1.0))
end

function test_vector3_math:test_vector3_negate()
	local v = rm.vector3(1, 2, 3)
	local result = rm.vector3_negate(v)
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
	lu.assertTrue(approx(result.z, -3.0))
end

function test_vector3_math:test_vector3_lerp()
	local v1 = rm.vector3(0, 0, 0)
	local v2 = rm.vector3(10, 20, 30)
	local result = rm.vector3_lerp(v1, v2, 0.5)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 10.0))
	lu.assertTrue(approx(result.z, 15.0))
end

function test_vector3_math:test_vector3_reflect()
	local v = rm.vector3(1, -1, 0)
	local normal = rm.vector3(0, 1, 0)
	local result = rm.vector3_reflect(v, normal)
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 1.0))
	lu.assertTrue(approx(result.z, 0.0))
end

function test_vector3_math:test_vector3_min()
	local v1 = rm.vector3(1, 5, 3)
	local v2 = rm.vector3(4, 2, 6)
	local result = rm.vector3_min(v1, v2)
	lu.assertEquals(result.x, 1.0)
	lu.assertEquals(result.y, 2.0)
	lu.assertEquals(result.z, 3.0)
end

function test_vector3_math:test_vector3_max()
	local v1 = rm.vector3(1, 5, 3)
	local v2 = rm.vector3(4, 2, 6)
	local result = rm.vector3_max(v1, v2)
	lu.assertEquals(result.x, 4.0)
	lu.assertEquals(result.y, 5.0)
	lu.assertEquals(result.z, 6.0)
end

function test_vector3_math:test_vector3_invert()
	local v = rm.vector3(2, 4, 5)
	local result = rm.vector3_invert(v)
	lu.assertTrue(approx(result.x, 0.5))
	lu.assertTrue(approx(result.y, 0.25))
	lu.assertTrue(approx(result.z, 0.2))
end

function test_vector3_math:test_vector3_equals()
	local v1 = rm.vector3(1.0, 2.0, 3.0)
	local v2 = rm.vector3(1.0, 2.0, 3.0)
	lu.assertEquals(rm.vector3_equals(v1, v2), 1)
end

function test_vector3_math:test_vector3_move_towards()
	local v = rm.vector3(0, 0, 0)
	local target = rm.vector3(10, 0, 0)
	local result = rm.vector3_move_towards(v, target, 3.0)
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 0.0))
	lu.assertTrue(approx(result.z, 0.0))
end

-- ============================================================================
-- Vector4 Math Functions
-- ============================================================================
test_vector4_math = {}

function test_vector4_math:test_vector4_zero()
	local v = rm.vector4_zero()
	lu.assertEquals(v.x, 0.0)
	lu.assertEquals(v.y, 0.0)
	lu.assertEquals(v.z, 0.0)
	lu.assertEquals(v.w, 0.0)
end

function test_vector4_math:test_vector4_one()
	local v = rm.vector4_one()
	lu.assertEquals(v.x, 1.0)
	lu.assertEquals(v.y, 1.0)
	lu.assertEquals(v.z, 1.0)
	lu.assertEquals(v.w, 1.0)
end

function test_vector4_math:test_vector4_add()
	local v1 = rm.vector4(1, 2, 3, 4)
	local v2 = rm.vector4(5, 6, 7, 8)
	local result = rm.vector4_add(v1, v2)
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 8.0))
	lu.assertTrue(approx(result.z, 10.0))
	lu.assertTrue(approx(result.w, 12.0))
end

function test_vector4_math:test_vector4_scale()
	local v = rm.vector4(1, 2, 3, 4)
	local result = rm.vector4_scale(v, 2.0)
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
	lu.assertTrue(approx(result.w, 8.0))
end

function test_vector4_math:test_vector4_length()
	local v = rm.vector4(1, 2, 2, 2)
	lu.assertTrue(approx(rm.vector4_length(v), 3.60555, 0.01))
end

function test_vector4_math:test_vector4_normalize()
	local v = rm.vector4(1, 2, 2, 4)
	local result = rm.vector4_normalize(v)
	lu.assertTrue(approx(rm.vector4_length(result), 1.0, 0.01))
end

function test_vector4_math:test_vector4_lerp()
	local v1 = rm.vector4(0, 0, 0, 0)
	local v2 = rm.vector4(10, 20, 30, 40)
	local result = rm.vector4_lerp(v1, v2, 0.5)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 10.0))
	lu.assertTrue(approx(result.z, 15.0))
	lu.assertTrue(approx(result.w, 20.0))
end

function test_vector4_math:test_vector4_equals()
	local v1 = rm.vector4(1.0, 2.0, 3.0, 4.0)
	local v2 = rm.vector4(1.0, 2.0, 3.0, 4.0)
	lu.assertEquals(rm.vector4_equals(v1, v2), 1)
end

function test_vector4_math:test_vector4_dot_product()
	local v1 = rm.vector4(1, 0, 0, 0)
	local v2 = rm.vector4(0, 1, 0, 0)
	lu.assertTrue(approx(rm.vector4_dot_product(v1, v2), 0.0))
end

function test_vector4_math:test_vector4_min()
	local v1 = rm.vector4(1, 5, 3, 7)
	local v2 = rm.vector4(4, 2, 6, 0)
	local result = rm.vector4_min(v1, v2)
	lu.assertEquals(result.x, 1.0)
	lu.assertEquals(result.y, 2.0)
	lu.assertEquals(result.z, 3.0)
	lu.assertEquals(result.w, 0.0)
end

function test_vector4_math:test_vector4_max()
	local v1 = rm.vector4(1, 5, 3, 7)
	local v2 = rm.vector4(4, 2, 6, 0)
	local result = rm.vector4_max(v1, v2)
	lu.assertEquals(result.x, 4.0)
	lu.assertEquals(result.y, 5.0)
	lu.assertEquals(result.z, 6.0)
	lu.assertEquals(result.w, 7.0)
end

-- ============================================================================
-- Matrix Math Functions
-- ============================================================================
test_matrix_math = {}

function test_matrix_math:test_matrix_identity()
	local m = rm.matrix_identity()
	lu.assertTrue(approx(m.m0, 1.0))
	lu.assertTrue(approx(m.m5, 1.0))
	lu.assertTrue(approx(m.m10, 1.0))
	lu.assertTrue(approx(m.m15, 1.0))
	lu.assertTrue(approx(m.m1, 0.0))
end

function test_matrix_math:test_matrix_translate()
	local m = rm.matrix_translate(1, 2, 3)
	lu.assertTrue(approx(m.m12, 1.0))
	lu.assertTrue(approx(m.m13, 2.0))
	lu.assertTrue(approx(m.m14, 3.0))
end

function test_matrix_math:test_matrix_scale()
	local m = rm.matrix_scale(2, 3, 4)
	lu.assertTrue(approx(m.m0, 2.0))
	lu.assertTrue(approx(m.m5, 3.0))
	lu.assertTrue(approx(m.m10, 4.0))
end

function test_matrix_math:test_matrix_multiply_identity()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = rm.matrix_multiply(m1, m2)
	lu.assertTrue(approx(result.m0, 1.0))
	lu.assertTrue(approx(result.m5, 1.0))
end

function test_matrix_math:test_matrix_determinant_identity()
	local m = rm.matrix_identity()
	lu.assertTrue(approx(rm.matrix_determinant(m), 1.0))
end

function test_matrix_math:test_matrix_determinant_scale()
	local m = rm.matrix_scale(2, 3, 4)
	lu.assertTrue(approx(rm.matrix_determinant(m), 24.0))
end

function test_matrix_math:test_matrix_trace_identity()
	local m = rm.matrix_identity()
	lu.assertTrue(approx(rm.matrix_trace(m), 4.0))
end

function test_matrix_math:test_matrix_transpose()
	local m = rm.matrix()
	m.m1 = 1.0
	m.m4 = 2.0
	local result = rm.matrix_transpose(m)
	lu.assertTrue(approx(result.m4, 1.0))
	lu.assertTrue(approx(result.m1, 2.0))
end

function test_matrix_math:test_matrix_invert()
	local m = rm.matrix_scale(2, 2, 2)
	local result = rm.matrix_invert(m)
	lu.assertTrue(approx(result.m0, 0.5))
	lu.assertTrue(approx(result.m5, 0.5))
end

function test_matrix_math:test_matrix_rotate_x_zero()
	local m = rm.matrix_rotate_x(0)
	lu.assertTrue(approx(m.m0, 1.0))
end

function test_matrix_math:test_matrix_rotate_y_zero()
	local m = rm.matrix_rotate_y(0)
	lu.assertTrue(approx(m.m5, 1.0))
end

function test_matrix_math:test_matrix_rotate_z_zero()
	local m = rm.matrix_rotate_z(0)
	lu.assertTrue(approx(m.m10, 1.0))
end

function test_matrix_math:test_matrix_add_identity()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = rm.matrix_add(m1, m2)
	lu.assertTrue(approx(result.m0, 2.0))
end

function test_matrix_math:test_matrix_subtract_identity()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = rm.matrix_subtract(m1, m2)
	lu.assertTrue(approx(result.m0, 0.0))
end

-- ============================================================================
-- Quaternion Functions
-- ============================================================================
test_quaternion = {}

function test_quaternion:test_quaternion_identity()
	local q = rm.quaternion_identity()
	lu.assertTrue(approx(q.x, 0.0))
	lu.assertTrue(approx(q.y, 0.0))
	lu.assertTrue(approx(q.z, 0.0))
	lu.assertTrue(approx(q.w, 1.0))
end

function test_quaternion:test_quaternion_length()
	local q = rm.quaternion(0, 0, 0, 1)
	lu.assertTrue(approx(rm.quaternion_length(q), 1.0))
end

function test_quaternion:test_quaternion_normalize()
	local q = rm.quaternion(1, 2, 2, 4)
	local result = rm.quaternion_normalize(q)
	lu.assertTrue(approx(rm.quaternion_length(result), 1.0, 0.01))
end

function test_quaternion:test_quaternion_invert()
	local q = rm.quaternion(0, 0, 0, 1)
	local result = rm.quaternion_invert(q)
	lu.assertTrue(approx(result.w, 1.0))
end

function test_quaternion:test_quaternion_multiply_identity()
	local q1 = rm.quaternion_identity()
	local q2 = rm.quaternion_identity()
	local result = rm.quaternion_multiply(q1, q2)
	lu.assertTrue(approx(result.w, 1.0))
end

function test_quaternion:test_quaternion_from_euler_zero()
	local q = rm.quaternion_from_euler(0, 0, 0)
	lu.assertTrue(approx(q.w, 1.0))
end

function test_quaternion:test_quaternion_to_euler()
	local q = rm.quaternion_identity()
	local result = rm.quaternion_to_euler(q)
	lu.assertTrue(approx(result.x, 0.0))
end

function test_quaternion:test_quaternion_from_axis_angle_zero()
	local axis = rm.vector3(0, 1, 0)
	local q = rm.quaternion_from_axis_angle(axis, 0)
	lu.assertTrue(approx(q.w, 1.0))
end

function test_quaternion:test_quaternion_from_axis_angle_pi()
	local axis = rm.vector3(0, 1, 0)
	local q = rm.quaternion_from_axis_angle(axis, math.pi)
	-- 180 degree rotation around Y
	lu.assertTrue(approx(q.w, 0.0, 0.01))
end

function test_quaternion:test_quaternion_slerp()
	local q1 = rm.quaternion_identity()
	local q2 = rm.quaternion_from_euler(0, math.pi, 0)
	local result = rm.quaternion_slerp(q1, q2, 0.5)
	lu.assertTrue(approx(rm.quaternion_length(result), 1.0))
end

function test_quaternion:test_quaternion_equals()
	local q1 = rm.quaternion(0, 0, 0, 1)
	local q2 = rm.quaternion(0, 0, 0, 1)
	lu.assertEquals(rm.quaternion_equals(q1, q2), 1)
end

function test_quaternion:test_quaternion_add()
	local q1 = rm.quaternion(1, 0, 0, 0)
	local q2 = rm.quaternion(0, 1, 0, 0)
	local result = rm.quaternion_add(q1, q2)
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 1.0))
end

function test_quaternion:test_quaternion_scale()
	local q = rm.quaternion(1, 2, 3, 4)
	local result = rm.quaternion_scale(q, 2.0)
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
end

function test_quaternion:test_quaternion_to_matrix()
	local q = rm.quaternion_identity()
	local m = rm.quaternion_to_matrix(q)
	lu.assertTrue(approx(m.m0, 1.0))
	lu.assertTrue(approx(m.m5, 1.0))
	lu.assertTrue(approx(m.m10, 1.0))
end

-- ============================================================================
-- Vector Operator Overloads (via metatypes)
-- ============================================================================
test_vector2_operators = {}

function test_vector2_operators:test__add_vec_vec()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(3, 4)
	local result = v1 + v2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function test_vector2_operators:test__add_vec_num()
	local v = rm.vector2(1, 2)
	local result = v + 5
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 7.0))
end

function test_vector2_operators:test__add_num_vec()
	local v = rm.vector2(1, 2)
	local result = 5 + v
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 7.0))
end

function test_vector2_operators:test__sub_vec_vec()
	local v1 = rm.vector2(5, 5)
	local v2 = rm.vector2(2, 3)
	local result = v1 - v2
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
end

function test_vector2_operators:test__sub_vec_num()
	local v = rm.vector2(5, 5)
	local result = v - 2
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 3.0))
end

function test_vector2_operators:test__sub_num_vec()
	local v = rm.vector2(1, 2)
	local result = 5 - v
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 3.0))
end

function test_vector2_operators:test__mul_vec_vec()
	local v1 = rm.vector2(2, 3)
	local v2 = rm.vector2(4, 5)
	local result = v1 * v2
	lu.assertTrue(approx(result.x, 8.0))
	lu.assertTrue(approx(result.y, 15.0))
end

function test_vector2_operators:test__mul_vec_num()
	local v = rm.vector2(2, 3)
	local result = v * 2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function test_vector2_operators:test__mul_num_vec()
	local v = rm.vector2(2, 3)
	local result = 2 * v
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function test_vector2_operators:test_div_vec_vec()
	local v1 = rm.vector2(8, 15)
	local v2 = rm.vector2(2, 3)
	local result = v1 / v2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 5.0))
end

function test_vector2_operators:test_div_vec_num()
	local v = rm.vector2(8, 12)
	local result = v / 2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function test_vector2_operators:test_unm()
	local v = rm.vector2(1, 2)
	local result = -v
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
end

function test_vector2_operators:test_eq_same()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(1, 2)
	lu.assertTrue(v1 == v2)
end

function test_vector2_operators:test_eq_different()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(3, 4)
	lu.assertFalse(v1 == v2)
end

function test_vector2_operators:test_len()
	local v = rm.vector2(3, 4)
	lu.assertTrue(approx(#v, 5.0))
end

test_vector3_operators = {}

function test_vector3_operators:test__add_vec_vec()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(4, 5, 6)
	local result = v1 + v2
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 7.0))
	lu.assertTrue(approx(result.z, 9.0))
end

function test_vector3_operators:test__add_vec_num()
	local v = rm.vector3(1, 2, 3)
	local result = v + 5
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 7.0))
	lu.assertTrue(approx(result.z, 8.0))
end

function test_vector3_operators:test__sub_vec_vec()
	local v1 = rm.vector3(5, 5, 5)
	local v2 = rm.vector3(2, 3, 4)
	local result = v1 - v2
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 1.0))
end

function test_vector3_operators:test__mul_vec_num()
	local v = rm.vector3(1, 2, 3)
	local result = v * 2
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
end

function test_vector3_operators:test_div_vec_num()
	local v = rm.vector3(2, 4, 6)
	local result = v / 2
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 3.0))
end

function test_vector3_operators:test_unm()
	local v = rm.vector3(1, 2, 3)
	local result = -v
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
	lu.assertTrue(approx(result.z, -3.0))
end

function test_vector3_operators:test_eq_same()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(1, 2, 3)
	lu.assertTrue(v1 == v2)
end

function test_vector3_operators:test_eq_different()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(4, 5, 6)
	lu.assertFalse(v1 == v2)
end

function test_vector3_operators:test_len()
	local v = rm.vector3(0, 3, 4)
	lu.assertTrue(approx(#v, 5.0))
end

test_vector4_operators = {}

function test_vector4_operators:test__add_vec_vec()
	local v1 = rm.vector4(1, 2, 3, 4)
	local v2 = rm.vector4(5, 6, 7, 8)
	local result = v1 + v2
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 8.0))
	lu.assertTrue(approx(result.z, 10.0))
	lu.assertTrue(approx(result.w, 12.0))
end

function test_vector4_operators:test__sub_vec_vec()
	local v1 = rm.vector4(10, 10, 10, 10)
	local v2 = rm.vector4(3, 4, 5, 6)
	local result = v1 - v2
	lu.assertTrue(approx(result.x, 7.0))
	lu.assertTrue(approx(result.y, 6.0))
	lu.assertTrue(approx(result.z, 5.0))
	lu.assertTrue(approx(result.w, 4.0))
end

function test_vector4_operators:test__mul_vec_num()
	local v = rm.vector4(1, 2, 3, 4)
	local result = v * 2
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
	lu.assertTrue(approx(result.w, 8.0))
end

function test_vector4_operators:test_div_vec_num()
	local v = rm.vector4(2, 4, 6, 8)
	local result = v / 2
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 3.0))
	lu.assertTrue(approx(result.w, 4.0))
end

function test_vector4_operators:test_unm()
	local v = rm.vector4(1, 2, 3, 4)
	local result = -v
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
	lu.assertTrue(approx(result.z, -3.0))
	lu.assertTrue(approx(result.w, -4.0))
end

function test_vector4_operators:test_eq_same()
	local v1 = rm.vector4(1, 2, 3, 4)
	local v2 = rm.vector4(1, 2, 3, 4)
	lu.assertTrue(v1 == v2)
end

function test_vector4_operators:test_len()
	local v = rm.vector4(1, 2, 2, 4)
	-- sqrt(1^2 + 2^2 + 2^2 + 4^2) = sqrt(1+4+4+16) = sqrt(25) = 5
	lu.assertTrue(approx(#v, 5.0, 0.01))
end

test_matrix_operators = {}

function test_matrix_operators:test__add()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = m1 + m2
	lu.assertTrue(approx(result.m0, 2.0))
end

function test_matrix_operators:test__sub()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = m1 - m2
	lu.assertTrue(approx(result.m0, 0.0))
end

function test_matrix_operators:test__mul()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = m1 * m2
	lu.assertTrue(approx(result.m0, 1.0))
end

function test_matrix_operators:test__tostring()
	local m = rm.matrix_identity()
	local s = tostring(m)
	lu.assertStrContains(s, "Matrix[")
end

-- ============================================================================
-- Run tests
-- ============================================================================
os.exit(lu.LuaUnit.run())
