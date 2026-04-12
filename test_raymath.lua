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
-- Raymath Scalar Functions
-- ============================================================================
TestRaymathScalar = {}

function TestRaymathScalar:testClampInRange()
	lu.assertEquals(rm.clamp(5.0, 0.0, 10.0), 5.0)
end

function TestRaymathScalar:testClampBelowMin()
	lu.assertEquals(rm.clamp(-5.0, 0.0, 10.0), 0.0)
end

function TestRaymathScalar:testClampAboveMax()
	lu.assertEquals(rm.clamp(15.0, 0.0, 10.0), 10.0)
end

function TestRaymathScalar:testLerpMidpoint()
	lu.assertTrue(approx(rm.lerp(0.0, 10.0, 0.5), 5.0))
end

function TestRaymathScalar:testLerpStart()
	lu.assertTrue(approx(rm.lerp(0.0, 10.0, 0.0), 0.0))
end

function TestRaymathScalar:testLerpEnd()
	lu.assertTrue(approx(rm.lerp(0.0, 10.0, 1.0), 10.0))
end

function TestRaymathScalar:testNormalizeMid()
	lu.assertTrue(approx(rm.normalize(5.0, 0.0, 10.0), 0.5))
end

function TestRaymathScalar:testRemap()
	lu.assertTrue(approx(rm.remap(5.0, 0.0, 10.0, 0.0, 100.0), 50.0))
end

function TestRaymathScalar:testWrapAbove()
	lu.assertTrue(approx(rm.wrap(12.0, 0.0, 10.0), 2.0))
end

function TestRaymathScalar:testWrapBelow()
	lu.assertTrue(approx(rm.wrap(-2.0, 0.0, 10.0), 8.0))
end

function TestRaymathScalar:testFloatEqualsTrue()
	lu.assertEquals(rm.float_equals(1.0, 1.0000001), 1)
end

function TestRaymathScalar:testFloatEqualsFalse()
	lu.assertEquals(rm.float_equals(1.0, 2.0), 0)
end

-- ============================================================================
-- Vector2 Math Functions
-- ============================================================================
TestVector2Math = {}

function TestVector2Math:testVector2Zero()
	local v = rm.vector2_zero()
	lu.assertEquals(v.x, 0.0)
	lu.assertEquals(v.y, 0.0)
end

function TestVector2Math:testVector2One()
	local v = rm.vector2_one()
	lu.assertEquals(v.x, 1.0)
	lu.assertEquals(v.y, 1.0)
end

function TestVector2Math:testVector2Add()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(3, 4)
	local result = rm.vector2_add(v1, v2)
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function TestVector2Math:testVector2Subtract()
	local v1 = rm.vector2(5, 5)
	local v2 = rm.vector2(2, 3)
	local result = rm.vector2_subtract(v1, v2)
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
end

function TestVector2Math:testVector2Scale()
	local v = rm.vector2(2, 3)
	local result = rm.vector2_scale(v, 2.0)
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function TestVector2Math:testVector2Length()
	local v = rm.vector2(3, 4)
	lu.assertTrue(approx(rm.vector2_length(v), 5.0))
end

function TestVector2Math:testVector2LengthSqr()
	local v = rm.vector2(3, 4)
	lu.assertTrue(approx(rm.vector2_length_sqr(v), 25.0))
end

function TestVector2Math:testVector2DotProductPerpendicular()
	local v1 = rm.vector2(1, 0)
	local v2 = rm.vector2(0, 1)
	lu.assertTrue(approx(rm.vector2_dot_product(v1, v2), 0.0))
end

function TestVector2Math:testVector2DotProductParallel()
	local v1 = rm.vector2(1, 0)
	local v2 = rm.vector2(2, 0)
	lu.assertTrue(approx(rm.vector2_dot_product(v1, v2), 2.0))
end

function TestVector2Math:testVector2Distance()
	local v1 = rm.vector2(0, 0)
	local v2 = rm.vector2(3, 4)
	lu.assertTrue(approx(rm.vector2_distance(v1, v2), 5.0))
end

function TestVector2Math:testVector2Normalize()
	local v = rm.vector2(3, 4)
	local result = rm.vector2_normalize(v)
	lu.assertTrue(approx(rm.vector2_length(result), 1.0))
end

function TestVector2Math:testVector2Negate()
	local v = rm.vector2(1, 2)
	local result = rm.vector2_negate(v)
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
end

function TestVector2Math:testVector2Lerp()
	local v1 = rm.vector2(0, 0)
	local v2 = rm.vector2(10, 20)
	local result = rm.vector2_lerp(v1, v2, 0.5)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 10.0))
end

function TestVector2Math:testVector2Reflect()
	local v = rm.vector2(1, -1)
	local normal = rm.vector2(0, 1)
	local result = rm.vector2_reflect(v, normal)
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 1.0))
end

function TestVector2Math:testVector2Rotate()
	local v = rm.vector2(1, 0)
	local result = rm.vector2_rotate(v, math.pi / 2)
	lu.assertTrue(approx(result.x, 0.0, 0.01))
	lu.assertTrue(approx(result.y, 1.0, 0.01))
end

function TestVector2Math:testVector2Min()
	local v1 = rm.vector2(1, 5)
	local v2 = rm.vector2(3, 2)
	local result = rm.vector2_min(v1, v2)
	lu.assertEquals(result.x, 1.0)
	lu.assertEquals(result.y, 2.0)
end

function TestVector2Math:testVector2Max()
	local v1 = rm.vector2(1, 5)
	local v2 = rm.vector2(3, 2)
	local result = rm.vector2_max(v1, v2)
	lu.assertEquals(result.x, 3.0)
	lu.assertEquals(result.y, 5.0)
end

function TestVector2Math:testVector2Invert()
	local v = rm.vector2(2, 4)
	local result = rm.vector2_invert(v)
	lu.assertTrue(approx(result.x, 0.5))
	lu.assertTrue(approx(result.y, 0.25))
end

function TestVector2Math:testVector2Equals()
	local v1 = rm.vector2(1.0, 2.0)
	local v2 = rm.vector2(1.0, 2.0)
	lu.assertEquals(rm.vector2_equals(v1, v2), 1)
end

-- ============================================================================
-- Vector3 Math Functions
-- ============================================================================
TestVector3Math = {}

function TestVector3Math:testVector3Zero()
	local v = rm.vector3_zero()
	lu.assertEquals(v.x, 0.0)
	lu.assertEquals(v.y, 0.0)
	lu.assertEquals(v.z, 0.0)
end

function TestVector3Math:testVector3One()
	local v = rm.vector3_one()
	lu.assertEquals(v.x, 1.0)
	lu.assertEquals(v.y, 1.0)
	lu.assertEquals(v.z, 1.0)
end

function TestVector3Math:testVector3Add()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(4, 5, 6)
	local result = rm.vector3_add(v1, v2)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 7.0))
	lu.assertTrue(approx(result.z, 9.0))
end

function TestVector3Math:testVector3Subtract()
	local v1 = rm.vector3(5, 5, 5)
	local v2 = rm.vector3(2, 3, 4)
	local result = rm.vector3_subtract(v1, v2)
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 1.0))
end

function TestVector3Math:testVector3Scale()
	local v = rm.vector3(1, 2, 3)
	local result = rm.vector3_scale(v, 2.0)
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
end

function TestVector3Math:testVector3Length()
	local v = rm.vector3(1, 2, 2)
	lu.assertTrue(approx(rm.vector3_length(v), 3.0))
end

function TestVector3Math:testVector3DotProduct()
	local v1 = rm.vector3(1, 0, 0)
	local v2 = rm.vector3(0, 1, 0)
	lu.assertTrue(approx(rm.vector3_dot_product(v1, v2), 0.0))
end

function TestVector3Math:testVector3CrossProduct()
	local v1 = rm.vector3(1, 0, 0)
	local v2 = rm.vector3(0, 1, 0)
	local result = rm.vector3_cross_product(v1, v2)
	lu.assertTrue(approx(result.x, 0.0))
	lu.assertTrue(approx(result.y, 0.0))
	lu.assertTrue(approx(result.z, 1.0))
end

function TestVector3Math:testVector3Distance()
	local v1 = rm.vector3(0, 0, 0)
	local v2 = rm.vector3(1, 2, 2)
	lu.assertTrue(approx(rm.vector3_distance(v1, v2), 3.0))
end

function TestVector3Math:testVector3Normalize()
	local v = rm.vector3(1, 2, 2)
	local result = rm.vector3_normalize(v)
	lu.assertTrue(approx(rm.vector3_length(result), 1.0))
end

function TestVector3Math:testVector3Negate()
	local v = rm.vector3(1, 2, 3)
	local result = rm.vector3_negate(v)
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
	lu.assertTrue(approx(result.z, -3.0))
end

function TestVector3Math:testVector3Lerp()
	local v1 = rm.vector3(0, 0, 0)
	local v2 = rm.vector3(10, 20, 30)
	local result = rm.vector3_lerp(v1, v2, 0.5)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 10.0))
	lu.assertTrue(approx(result.z, 15.0))
end

function TestVector3Math:testVector3Reflect()
	local v = rm.vector3(1, -1, 0)
	local normal = rm.vector3(0, 1, 0)
	local result = rm.vector3_reflect(v, normal)
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 1.0))
	lu.assertTrue(approx(result.z, 0.0))
end

function TestVector3Math:testVector3Min()
	local v1 = rm.vector3(1, 5, 3)
	local v2 = rm.vector3(4, 2, 6)
	local result = rm.vector3_min(v1, v2)
	lu.assertEquals(result.x, 1.0)
	lu.assertEquals(result.y, 2.0)
	lu.assertEquals(result.z, 3.0)
end

function TestVector3Math:testVector3Max()
	local v1 = rm.vector3(1, 5, 3)
	local v2 = rm.vector3(4, 2, 6)
	local result = rm.vector3_max(v1, v2)
	lu.assertEquals(result.x, 4.0)
	lu.assertEquals(result.y, 5.0)
	lu.assertEquals(result.z, 6.0)
end

function TestVector3Math:testVector3Invert()
	local v = rm.vector3(2, 4, 5)
	local result = rm.vector3_invert(v)
	lu.assertTrue(approx(result.x, 0.5))
	lu.assertTrue(approx(result.y, 0.25))
	lu.assertTrue(approx(result.z, 0.2))
end

function TestVector3Math:testVector3Equals()
	local v1 = rm.vector3(1.0, 2.0, 3.0)
	local v2 = rm.vector3(1.0, 2.0, 3.0)
	lu.assertEquals(rm.vector3_equals(v1, v2), 1)
end

function TestVector3Math:testVector3MoveTowards()
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
TestVector4Math = {}

function TestVector4Math:testVector4Zero()
	local v = rm.vector4_zero()
	lu.assertEquals(v.x, 0.0)
	lu.assertEquals(v.y, 0.0)
	lu.assertEquals(v.z, 0.0)
	lu.assertEquals(v.w, 0.0)
end

function TestVector4Math:testVector4One()
	local v = rm.vector4_one()
	lu.assertEquals(v.x, 1.0)
	lu.assertEquals(v.y, 1.0)
	lu.assertEquals(v.z, 1.0)
	lu.assertEquals(v.w, 1.0)
end

function TestVector4Math:testVector4Add()
	local v1 = rm.vector4(1, 2, 3, 4)
	local v2 = rm.vector4(5, 6, 7, 8)
	local result = rm.vector4_add(v1, v2)
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 8.0))
	lu.assertTrue(approx(result.z, 10.0))
	lu.assertTrue(approx(result.w, 12.0))
end

function TestVector4Math:testVector4Scale()
	local v = rm.vector4(1, 2, 3, 4)
	local result = rm.vector4_scale(v, 2.0)
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
	lu.assertTrue(approx(result.w, 8.0))
end

function TestVector4Math:testVector4Length()
	local v = rm.vector4(1, 2, 2, 2)
	lu.assertTrue(approx(rm.vector4_length(v), 3.60555, 0.01))
end

function TestVector4Math:testVector4Normalize()
	local v = rm.vector4(1, 2, 2, 4)
	local result = rm.vector4_normalize(v)
	lu.assertTrue(approx(rm.vector4_length(result), 1.0, 0.01))
end

function TestVector4Math:testVector4Lerp()
	local v1 = rm.vector4(0, 0, 0, 0)
	local v2 = rm.vector4(10, 20, 30, 40)
	local result = rm.vector4_lerp(v1, v2, 0.5)
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 10.0))
	lu.assertTrue(approx(result.z, 15.0))
	lu.assertTrue(approx(result.w, 20.0))
end

function TestVector4Math:testVector4Equals()
	local v1 = rm.vector4(1.0, 2.0, 3.0, 4.0)
	local v2 = rm.vector4(1.0, 2.0, 3.0, 4.0)
	lu.assertEquals(rm.vector4_equals(v1, v2), 1)
end

function TestVector4Math:testVector4DotProduct()
	local v1 = rm.vector4(1, 0, 0, 0)
	local v2 = rm.vector4(0, 1, 0, 0)
	lu.assertTrue(approx(rm.vector4_dot_product(v1, v2), 0.0))
end

function TestVector4Math:testVector4Min()
	local v1 = rm.vector4(1, 5, 3, 7)
	local v2 = rm.vector4(4, 2, 6, 0)
	local result = rm.vector4_min(v1, v2)
	lu.assertEquals(result.x, 1.0)
	lu.assertEquals(result.y, 2.0)
	lu.assertEquals(result.z, 3.0)
	lu.assertEquals(result.w, 0.0)
end

function TestVector4Math:testVector4Max()
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
TestMatrixMath = {}

function TestMatrixMath:testMatrixIdentity()
	local m = rm.matrix_identity()
	lu.assertTrue(approx(m.m0, 1.0))
	lu.assertTrue(approx(m.m5, 1.0))
	lu.assertTrue(approx(m.m10, 1.0))
	lu.assertTrue(approx(m.m15, 1.0))
	lu.assertTrue(approx(m.m1, 0.0))
end

function TestMatrixMath:testMatrixTranslate()
	local m = rm.matrix_translate(1, 2, 3)
	lu.assertTrue(approx(m.m12, 1.0))
	lu.assertTrue(approx(m.m13, 2.0))
	lu.assertTrue(approx(m.m14, 3.0))
end

function TestMatrixMath:testMatrixScale()
	local m = rm.matrix_scale(2, 3, 4)
	lu.assertTrue(approx(m.m0, 2.0))
	lu.assertTrue(approx(m.m5, 3.0))
	lu.assertTrue(approx(m.m10, 4.0))
end

function TestMatrixMath:testMatrixMultiplyIdentity()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = rm.matrix_multiply(m1, m2)
	lu.assertTrue(approx(result.m0, 1.0))
	lu.assertTrue(approx(result.m5, 1.0))
end

function TestMatrixMath:testMatrixDeterminantIdentity()
	local m = rm.matrix_identity()
	lu.assertTrue(approx(rm.matrix_determinant(m), 1.0))
end

function TestMatrixMath:testMatrixDeterminantScale()
	local m = rm.matrix_scale(2, 3, 4)
	lu.assertTrue(approx(rm.matrix_determinant(m), 24.0))
end

function TestMatrixMath:testMatrixTraceIdentity()
	local m = rm.matrix_identity()
	lu.assertTrue(approx(rm.matrix_trace(m), 4.0))
end

function TestMatrixMath:testMatrixTranspose()
	local m = rm.matrix()
	m.m1 = 1.0
	m.m4 = 2.0
	local result = rm.matrix_transpose(m)
	lu.assertTrue(approx(result.m4, 1.0))
	lu.assertTrue(approx(result.m1, 2.0))
end

function TestMatrixMath:testMatrixInvert()
	local m = rm.matrix_scale(2, 2, 2)
	local result = rm.matrix_invert(m)
	lu.assertTrue(approx(result.m0, 0.5))
	lu.assertTrue(approx(result.m5, 0.5))
end

function TestMatrixMath:testMatrixRotateXZero()
	local m = rm.matrix_rotate_x(0)
	lu.assertTrue(approx(m.m0, 1.0))
end

function TestMatrixMath:testMatrixRotateYZero()
	local m = rm.matrix_rotate_y(0)
	lu.assertTrue(approx(m.m5, 1.0))
end

function TestMatrixMath:testMatrixRotateZZero()
	local m = rm.matrix_rotate_z(0)
	lu.assertTrue(approx(m.m10, 1.0))
end

function TestMatrixMath:testMatrixAddIdentity()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = rm.matrix_add(m1, m2)
	lu.assertTrue(approx(result.m0, 2.0))
end

function TestMatrixMath:testMatrixSubtractIdentity()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = rm.matrix_subtract(m1, m2)
	lu.assertTrue(approx(result.m0, 0.0))
end

-- ============================================================================
-- Quaternion Functions
-- ============================================================================
TestQuaternion = {}

function TestQuaternion:testQuaternionIdentity()
	local q = rm.quaternion_identity()
	lu.assertTrue(approx(q.x, 0.0))
	lu.assertTrue(approx(q.y, 0.0))
	lu.assertTrue(approx(q.z, 0.0))
	lu.assertTrue(approx(q.w, 1.0))
end

function TestQuaternion:testQuaternionLength()
	local q = rm.quaternion(0, 0, 0, 1)
	lu.assertTrue(approx(rm.quaternion_length(q), 1.0))
end

function TestQuaternion:testQuaternionNormalize()
	local q = rm.quaternion(1, 2, 2, 4)
	local result = rm.quaternion_normalize(q)
	lu.assertTrue(approx(rm.quaternion_length(result), 1.0, 0.01))
end

function TestQuaternion:testQuaternionInvert()
	local q = rm.quaternion(0, 0, 0, 1)
	local result = rm.quaternion_invert(q)
	lu.assertTrue(approx(result.w, 1.0))
end

function TestQuaternion:testQuaternionMultiplyIdentity()
	local q1 = rm.quaternion_identity()
	local q2 = rm.quaternion_identity()
	local result = rm.quaternion_multiply(q1, q2)
	lu.assertTrue(approx(result.w, 1.0))
end

function TestQuaternion:testQuaternionFromEulerZero()
	local q = rm.quaternion_from_euler(0, 0, 0)
	lu.assertTrue(approx(q.w, 1.0))
end

function TestQuaternion:testQuaternionToEuler()
	local q = rm.quaternion_identity()
	local result = rm.quaternion_to_euler(q)
	lu.assertTrue(approx(result.x, 0.0))
end

function TestQuaternion:testQuaternionFromAxisAngleZero()
	local axis = rm.vector3(0, 1, 0)
	local q = rm.quaternion_from_axis_angle(axis, 0)
	lu.assertTrue(approx(q.w, 1.0))
end

function TestQuaternion:testQuaternionFromAxisAnglePi()
	local axis = rm.vector3(0, 1, 0)
	local q = rm.quaternion_from_axis_angle(axis, math.pi)
	-- 180 degree rotation around Y
	lu.assertTrue(approx(q.w, 0.0, 0.01))
end

function TestQuaternion:testQuaternionSlerp()
	local q1 = rm.quaternion_identity()
	local q2 = rm.quaternion_from_euler(0, math.pi, 0)
	local result = rm.quaternion_slerp(q1, q2, 0.5)
	lu.assertTrue(approx(rm.quaternion_length(result), 1.0))
end

function TestQuaternion:testQuaternionEquals()
	local q1 = rm.quaternion(0, 0, 0, 1)
	local q2 = rm.quaternion(0, 0, 0, 1)
	lu.assertEquals(rm.quaternion_equals(q1, q2), 1)
end

function TestQuaternion:testQuaternionAdd()
	local q1 = rm.quaternion(1, 0, 0, 0)
	local q2 = rm.quaternion(0, 1, 0, 0)
	local result = rm.quaternion_add(q1, q2)
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 1.0))
end

function TestQuaternion:testQuaternionScale()
	local q = rm.quaternion(1, 2, 3, 4)
	local result = rm.quaternion_scale(q, 2.0)
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
end

function TestQuaternion:testQuaternionToMatrix()
	local q = rm.quaternion_identity()
	local m = rm.quaternion_to_matrix(q)
	lu.assertTrue(approx(m.m0, 1.0))
	lu.assertTrue(approx(m.m5, 1.0))
	lu.assertTrue(approx(m.m10, 1.0))
end

-- ============================================================================
-- Vector Operator Overloads (via metatypes)
-- ============================================================================
TestVector2Operators = {}

function TestVector2Operators:testAddVecVec()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(3, 4)
	local result = v1 + v2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function TestVector2Operators:testAddVecNum()
	local v = rm.vector2(1, 2)
	local result = v + 5
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 7.0))
end

function TestVector2Operators:testAddNumVec()
	local v = rm.vector2(1, 2)
	local result = 5 + v
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 7.0))
end

function TestVector2Operators:testSubVecVec()
	local v1 = rm.vector2(5, 5)
	local v2 = rm.vector2(2, 3)
	local result = v1 - v2
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
end

function TestVector2Operators:testSubVecNum()
	local v = rm.vector2(5, 5)
	local result = v - 2
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 3.0))
end

function TestVector2Operators:testSubNumVec()
	local v = rm.vector2(1, 2)
	local result = 5 - v
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 3.0))
end

function TestVector2Operators:testMulVecVec()
	local v1 = rm.vector2(2, 3)
	local v2 = rm.vector2(4, 5)
	local result = v1 * v2
	lu.assertTrue(approx(result.x, 8.0))
	lu.assertTrue(approx(result.y, 15.0))
end

function TestVector2Operators:testMulVecNum()
	local v = rm.vector2(2, 3)
	local result = v * 2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function TestVector2Operators:testMulNumVec()
	local v = rm.vector2(2, 3)
	local result = 2 * v
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function TestVector2Operators:testDivVecVec()
	local v1 = rm.vector2(8, 15)
	local v2 = rm.vector2(2, 3)
	local result = v1 / v2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 5.0))
end

function TestVector2Operators:testDivVecNum()
	local v = rm.vector2(8, 12)
	local result = v / 2
	lu.assertTrue(approx(result.x, 4.0))
	lu.assertTrue(approx(result.y, 6.0))
end

function TestVector2Operators:testUnm()
	local v = rm.vector2(1, 2)
	local result = -v
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
end

function TestVector2Operators:testEqSame()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(1, 2)
	lu.assertTrue(v1 == v2)
end

function TestVector2Operators:testEqDifferent()
	local v1 = rm.vector2(1, 2)
	local v2 = rm.vector2(3, 4)
	lu.assertFalse(v1 == v2)
end

function TestVector2Operators:testLen()
	local v = rm.vector2(3, 4)
	lu.assertTrue(approx(#v, 5.0))
end

TestVector3Operators = {}

function TestVector3Operators:testAddVecVec()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(4, 5, 6)
	local result = v1 + v2
	lu.assertTrue(approx(result.x, 5.0))
	lu.assertTrue(approx(result.y, 7.0))
	lu.assertTrue(approx(result.z, 9.0))
end

function TestVector3Operators:testAddVecNum()
	local v = rm.vector3(1, 2, 3)
	local result = v + 5
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 7.0))
	lu.assertTrue(approx(result.z, 8.0))
end

function TestVector3Operators:testSubVecVec()
	local v1 = rm.vector3(5, 5, 5)
	local v2 = rm.vector3(2, 3, 4)
	local result = v1 - v2
	lu.assertTrue(approx(result.x, 3.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 1.0))
end

function TestVector3Operators:testMulVecNum()
	local v = rm.vector3(1, 2, 3)
	local result = v * 2
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
end

function TestVector3Operators:testDivVecNum()
	local v = rm.vector3(2, 4, 6)
	local result = v / 2
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 3.0))
end

function TestVector3Operators:testUnm()
	local v = rm.vector3(1, 2, 3)
	local result = -v
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
	lu.assertTrue(approx(result.z, -3.0))
end

function TestVector3Operators:testEqSame()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(1, 2, 3)
	lu.assertTrue(v1 == v2)
end

function TestVector3Operators:testEqDifferent()
	local v1 = rm.vector3(1, 2, 3)
	local v2 = rm.vector3(4, 5, 6)
	lu.assertFalse(v1 == v2)
end

function TestVector3Operators:testLen()
	local v = rm.vector3(0, 3, 4)
	lu.assertTrue(approx(#v, 5.0))
end

TestVector4Operators = {}

function TestVector4Operators:testAddVecVec()
	local v1 = rm.vector4(1, 2, 3, 4)
	local v2 = rm.vector4(5, 6, 7, 8)
	local result = v1 + v2
	lu.assertTrue(approx(result.x, 6.0))
	lu.assertTrue(approx(result.y, 8.0))
	lu.assertTrue(approx(result.z, 10.0))
	lu.assertTrue(approx(result.w, 12.0))
end

function TestVector4Operators:testSubVecVec()
	local v1 = rm.vector4(10, 10, 10, 10)
	local v2 = rm.vector4(3, 4, 5, 6)
	local result = v1 - v2
	lu.assertTrue(approx(result.x, 7.0))
	lu.assertTrue(approx(result.y, 6.0))
	lu.assertTrue(approx(result.z, 5.0))
	lu.assertTrue(approx(result.w, 4.0))
end

function TestVector4Operators:testMulVecNum()
	local v = rm.vector4(1, 2, 3, 4)
	local result = v * 2
	lu.assertTrue(approx(result.x, 2.0))
	lu.assertTrue(approx(result.y, 4.0))
	lu.assertTrue(approx(result.z, 6.0))
	lu.assertTrue(approx(result.w, 8.0))
end

function TestVector4Operators:testDivVecNum()
	local v = rm.vector4(2, 4, 6, 8)
	local result = v / 2
	lu.assertTrue(approx(result.x, 1.0))
	lu.assertTrue(approx(result.y, 2.0))
	lu.assertTrue(approx(result.z, 3.0))
	lu.assertTrue(approx(result.w, 4.0))
end

function TestVector4Operators:testUnm()
	local v = rm.vector4(1, 2, 3, 4)
	local result = -v
	lu.assertTrue(approx(result.x, -1.0))
	lu.assertTrue(approx(result.y, -2.0))
	lu.assertTrue(approx(result.z, -3.0))
	lu.assertTrue(approx(result.w, -4.0))
end

function TestVector4Operators:testEqSame()
	local v1 = rm.vector4(1, 2, 3, 4)
	local v2 = rm.vector4(1, 2, 3, 4)
	lu.assertTrue(v1 == v2)
end

function TestVector4Operators:testLen()
	local v = rm.vector4(1, 2, 2, 4)
	-- sqrt(1^2 + 2^2 + 2^2 + 4^2) = sqrt(1+4+4+16) = sqrt(25) = 5
	lu.assertTrue(approx(#v, 5.0, 0.01))
end

TestMatrixOperators = {}

function TestMatrixOperators:test_add()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = m1 + m2
	lu.assertTrue(approx(result.m0, 2.0))
end

function TestMatrixOperators:test_sub()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = m1 - m2
	lu.assertTrue(approx(result.m0, 0.0))
end

function TestMatrixOperators:test_mul()
	local m1 = rm.matrix_identity()
	local m2 = rm.matrix_identity()
	local result = m1 * m2
	lu.assertTrue(approx(result.m0, 1.0))
end

function TestMatrixOperators:test_tostring()
	local m = rm.matrix_identity()
	local s = tostring(m)
	lu.assertStrContains(s, "Matrix[")
end

-- ============================================================================
-- Run tests
-- ============================================================================
os.exit(lu.LuaUnit.run())
