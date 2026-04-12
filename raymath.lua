---@meta
---@class raymath
---Complete FFI bindings for raymath (math utilities from raylib)
---Load with: local rm = require("raymath") or via raylib: local rl = require("raylib")

local ffi = require("ffi")

---@class raymath
---
--- Raymath: utility functions
---
---@field clamp fun(value: number, min: number, max: number): number Clamp float value
---@field lerp fun(start: number, endVal: number, amount: number): number Calculate linear interpolation between two floats
---@field normalize fun(value: number, start: number, endVal: number): number Normalize input value within input range
---@field remap fun(value: number, inputStart: number, inputEnd: number, outputStart: number, outputEnd: number): number Remap input value within input range to output range
---@field wrap fun(value: number, min: number, max: number): number Wrap input value from min to max
---@field float_equals fun(x: number, y: number): integer Check whether two given floats are almost equal
---
--- Raymath: Vector2 functions
---
---@field vector2_zero fun(): Vector2 Vector with components value 0.0f
---@field vector2_one fun(): Vector2 Vector with components value 1.0f
---@field vector2_add fun(v1: Vector2, v2: Vector2): Vector2 Add two vectors (v1 + v2)
---@field vector2_add_value fun(v: Vector2, add: number): Vector2 Add vector and float value
---@field vector2_subtract fun(v1: Vector2, v2: Vector2): Vector2 Subtract two vectors (v1 - v2)
---@field vector2_subtract_value fun(v: Vector2, sub: number): Vector2 Subtract vector by float value
---@field vector2_length fun(v: Vector2): number Calculate vector length
---@field vector2_length_sqr fun(v: Vector2): number Calculate vector square length
---@field vector2_dot_product fun(v1: Vector2, v2: Vector2): number Calculate two vectors dot product
---@field vector2_distance fun(v1: Vector2, v2: Vector2): number Calculate distance between two vectors
---@field vector2_distance_sqr fun(v1: Vector2, v2: Vector2): number Calculate square distance between two vectors
---@field vector2_angle fun(v1: Vector2, v2: Vector2): number Calculate angle between two vectors
---@field vector2_line_angle fun(start: Vector2, endPos: Vector2): number Calculate angle defined by a two vectors line
---@field vector2_scale fun(v: Vector2, scale: number): Vector2 Scale vector (multiply by value)
---@field vector2_multiply fun(v1: Vector2, v2: Vector2): Vector2 Multiply vector by vector
---@field vector2_negate fun(v: Vector2): Vector2 Negate vector
---@field vector_2d_ivide fun(v1: Vector2, v2: Vector2): Vector2 Divide vector by vector
---@field vector2_normalize fun(v: Vector2): Vector2 Normalize provided vector
---@field vector2_transform fun(v: Vector2, mat: Matrix): Vector2 Transforms a Vector2 by a given Matrix
---@field vector2_lerp fun(v1: Vector2, v2: Vector2, amount: number): Vector2 Calculate linear interpolation between two vectors
---@field vector2_reflect fun(v: Vector2, normal: Vector2): Vector2 Calculate reflected vector to normal
---@field vector2_min fun(v1: Vector2, v2: Vector2): Vector2 Get min value for each pair of components
---@field vector2_max fun(v1: Vector2, v2: Vector2): Vector2 Get max value for each pair of components
---@field vector2_rotate fun(v: Vector2, angle: number): Vector2 Rotate vector by angle
---@field vector2_move_towards fun(v: Vector2, target: Vector2, maxDistance: number): Vector2 Move vector towards target
---@field vector2_invert fun(v: Vector2): Vector2 Invert the given vector
---@field vector2_clamp fun(v: Vector2, min: Vector2, max: Vector2): Vector2 Clamp the components of the vector between min and max values
---@field vector2_clamp_value fun(v: Vector2, min: number, max: number): Vector2 Clamp the magnitude of the vector between two values
---@field vector2_equals fun(p: Vector2, q: Vector2): integer Check whether two given vectors are almost equal
---@field vector2_refract fun(v: Vector2, n: Vector2, r: number): Vector2 Compute the direction of a refracted ray
---@field vector2_cross_product fun(v1: Vector2, v2: Vector2): number Calculate two vectors cross product (2D, returns scalar)
---
--- Raymath: Vector3 functions
---
---@field vector3_zero fun(): Vector3 Vector with components value 0.0f
---@field vector3_one fun(): Vector3 Vector with components value 1.0f
---@field vector3_add fun(v1: Vector3, v2: Vector3): Vector3 Add two vectors
---@field vector3_add_value fun(v: Vector3, add: number): Vector3 Add vector and float value
---@field vector3_subtract fun(v1: Vector3, v2: Vector3): Vector3 Subtract two vectors
---@field vector3_subtract_value fun(v: Vector3, sub: number): Vector3 Subtract vector by float value
---@field vector3_scale fun(v: Vector3, scalar: number): Vector3 Multiply vector by scalar
---@field vector3_multiply fun(v1: Vector3, v2: Vector3): Vector3 Multiply vector by vector
---@field vector3_cross_product fun(v1: Vector3, v2: Vector3): Vector3 Calculate two vectors cross product
---@field vector3_perpendicular fun(v: Vector3): Vector3 Calculate one vector perpendicular vector
---@field vector3_length fun(v: Vector3): number Calculate vector length
---@field vector3_length_sqr fun(v: Vector3): number Calculate vector square length
---@field vector3_dot_product fun(v1: Vector3, v2: Vector3): number Calculate two vectors dot product
---@field vector3_distance fun(v1: Vector3, v2: Vector3): number Calculate distance between two vectors
---@field vector3_distance_sqr fun(v1: Vector3, v2: Vector3): number Calculate square distance between two vectors
---@field vector3_angle fun(v1: Vector3, v2: Vector3): number Calculate angle between two vectors
---@field vector3_negate fun(v: Vector3): Vector3 Negate provided vector (invert direction)
---@field vector_3d_ivide fun(v1: Vector3, v2: Vector3): Vector3 Divide vector by vector
---@field vector3_normalize fun(v: Vector3): Vector3 Normalize provided vector
---@field vector3_project fun(v1: Vector3, v2: Vector3): Vector3 Calculate the projection of the vector v1 on to v2
---@field vector3_reject fun(v1: Vector3, v2: Vector3): Vector3 Calculate the rejection of the vector v1 on to v2
---@field vector3_ortho_normalize fun(v1: Vector3, v2: Vector3) Orthonormalize provided vectors (makes vectors normalized and orthogonal to each other)
---@field vector3_transform fun(v: Vector3, mat: Matrix): Vector3 Transforms a Vector3 by a given Matrix
---@field vector3_rotate_by_quaternion fun(v: Vector3, q: Vector4): Vector3 Transform a vector by quaternion rotation
---@field vector3_rotate_by_axis_angle fun(v: Vector3, axis: Vector3, angle: number): Vector3 Rotates a vector around an axis
---@field vector3_move_towards fun(v: Vector3, target: Vector3, maxDistance: number): Vector3 Move vector towards target
---@field vector3_lerp fun(v1: Vector3, v2: Vector3, amount: number): Vector3 Calculate linear interpolation between two vectors
---@field vector3_cubic_hermite fun(v1: Vector3, tangent1: Vector3, v2: Vector3, tangent2: Vector3, amount: number): Vector3 Calculate cubic hermite interpolation between two vectors
---@field vector3_reflect fun(v: Vector3, normal: Vector3): Vector3 Calculate reflected vector to normal
---@field vector3_min fun(v1: Vector3, v2: Vector3): Vector3 Get min value for each pair of components
---@field vector3_max fun(v1: Vector3, v2: Vector3): Vector3 Get max value for each pair of components
---@field vector3_barycenter fun(p: Vector3, a: Vector3, b: Vector3, c: Vector3): Vector3 Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
---@field vector3_unproject fun(source: Vector3, projection: Matrix, view: Matrix): Vector3 Projects a Vector3 from screen space into object space
---@field vector3_invert fun(v: Vector3): Vector3 Invert the given vector
---@field vector3_clamp fun(v: Vector3, min: Vector3, max: Vector3): Vector3 Clamp the components of the vector between min and max values
---@field vector3_clamp_value fun(v: Vector3, min: number, max: number): Vector3 Clamp the magnitude of the vector between two min and max values
---@field vector3_equals fun(p: Vector3, q: Vector3): integer Check whether two given vectors are almost equal
---@field vector3_refract fun(v: Vector3, n: Vector3, r: number): Vector3 Compute the direction of a refracted ray
---@field vector3_to_float_v fun(v: Vector3): float3 Get Vector3 as float array
---
--- Raymath: Vector4 functions
---
---@field vector4_zero fun(): Vector4 Vector with components value 0.0f
---@field vector4_one fun(): Vector4 Vector with components value 1.0f
---@field vector4_add fun(v1: Vector4, v2: Vector4): Vector4 Add two vectors
---@field vector4_add_value fun(v: Vector4, add: number): Vector4 Add vector and float value
---@field vector4_subtract fun(v1: Vector4, v2: Vector4): Vector4 Subtract two vectors
---@field vector4_subtract_value fun(v: Vector4, sub: number): Vector4 Subtract vector by float value
---@field vector4_length fun(v: Vector4): number Calculate vector length
---@field vector4_length_sqr fun(v: Vector4): number Calculate vector square length
---@field vector4_dot_product fun(v1: Vector4, v2: Vector4): number Calculate two vectors dot product
---@field vector4_distance fun(v1: Vector4, v2: Vector4): number Calculate distance between two vectors
---@field vector4_distance_sqr fun(v1: Vector4, v2: Vector4): number Calculate square distance between two vectors
---@field vector4_scale fun(v: Vector4, scale: number): Vector4 Scale vector by float value
---@field vector4_multiply fun(v1: Vector4, v2: Vector4): Vector4 Multiply vector by vector
---@field vector4_negate fun(v: Vector4): Vector4 Negate vector
---@field vector_4d_ivide fun(v1: Vector4, v2: Vector4): Vector4 Divide vector by vector
---@field vector4_normalize fun(v: Vector4): Vector4 Normalize provided vector
---@field vector4_min fun(v1: Vector4, v2: Vector4): Vector4 Get min value for each pair of components
---@field vector4_max fun(v1: Vector4, v2: Vector4): Vector4 Get max value for each pair of components
---@field vector4_lerp fun(v1: Vector4, v2: Vector4, amount: number): Vector4 Calculate linear interpolation between two vectors
---@field vector4_move_towards fun(v: Vector4, target: Vector4, maxDistance: number): Vector4 Move vector towards target
---@field vector4_invert fun(v: Vector4): Vector4 Invert the given vector
---@field vector4_equals fun(p: Vector4, q: Vector4): integer Check whether two given vectors are almost equal
---
--- Raymath: Matrix functions
---
---@field matrix_determinant fun(mat: Matrix): number Compute matrix determinant
---@field matrix_trace fun(mat: Matrix): number Get the trace of the matrix (sum of the values along the main diagonal)
---@field matrix_transpose fun(mat: Matrix): Matrix Transposes provided matrix
---@field matrix_invert fun(mat: Matrix): Matrix Invert provided matrix
---@field matrix_identity fun(): Matrix Get identity matrix
---@field matrix_add fun(left: Matrix, right: Matrix): Matrix Add two matrices
---@field matrix_subtract fun(left: Matrix, right: Matrix): Matrix Subtract two matrices
---@field matrix_multiply fun(left: Matrix, right: Matrix): Matrix Get two matrix multiplication
---@field matrix_translate fun(x: number, y: number, z: number): Matrix Get translation matrix
---@field matrix_rotate fun(axis: Vector3, angle: number): Matrix Get rotation matrix for angle around axis
---@field matrix_rotate_x fun(angle: number): Matrix Get x-rotation matrix for angle in radians
---@field matrix_rotate_y fun(angle: number): Matrix Get y-rotation matrix for angle in radians
---@field matrix_rotate_z fun(angle: number): Matrix Get z-rotation matrix for angle in radians
---@field matrix_rotate_xyz fun(angle: Vector3): Matrix Get xyz rotation matrix for angles in radians
---@field matrix_rotate_zyx fun(angle: Vector3): Matrix Get zyx rotation matrix for angles in radians
---@field matrix_scale fun(x: number, y: number, z: number): Matrix Get scaling matrix
---@field matrix_frustum fun(left: number, right: number, bottom: number, top: number, nearPlane: number, farPlane: number): Matrix Get perspective projection matrix
---@field matrix_perspective fun(fovY: number, aspect: number, nearPlane: number, farPlane: number): Matrix Get perspective projection matrix
---@field matrix_ortho fun(left: number, right: number, bottom: number, top: number, nearPlane: number, farPlane: number): Matrix Get orthographic projection matrix
---@field matrix_look_at fun(eye: Vector3, target: Vector3, up: Vector3): Matrix Get look at matrix (view matrix)
---@field matrix_to_float_v fun(mat: Matrix): float16 Get matrix as float array
---@field matrix_multiply_value fun(mat: Matrix, value: number): Matrix Multiply matrix by scalar
---@field matrix_compose fun(translation: Vector3, rotation: Vector4, scale: Vector3): Matrix Build matrix from translation, rotation and scale
---@field matrix_decompose fun(mat: Matrix, translation: Vector3, rotation: Vector4, scale: Vector3) Decompose a matrix into translation, rotation and scale
---
--- Raymath: Quaternion functions
---
---@field quaternion_add fun(q1: Vector4, q2: Vector4): Vector4 Add two quaternions
---@field quaternion_add_value fun(q: Vector4, add: number): Vector4 Add quaternion and float value
---@field quaternion_subtract fun(q1: Vector4, q2: Vector4): Vector4 Subtract two quaternions
---@field quaternion_subtract_value fun(q: Vector4, sub: number): Vector4 Subtract quaternion by float value
---@field quaternion_identity fun(): Vector4 Get identity quaternion
---@field quaternion_length fun(q: Vector4): number Compute quaternion length
---@field quaternion_normalize fun(q: Vector4): Vector4 Normalize provided quaternion
---@field quaternion_invert fun(q: Vector4): Vector4 Invert provided quaternion
---@field quaternion_multiply fun(q1: Vector4, q2: Vector4): Vector4 Calculate two quaternion multiplication
---@field quaternion_scale fun(q: Vector4, mul: number): Vector4 Scale quaternion by float value
---@field quaternion_divide fun(q1: Vector4, q2: Vector4): Vector4 Divide two quaternions
---@field quaternion_lerp fun(q1: Vector4, q2: Vector4, amount: number): Vector4 Calculate linear interpolation between two quaternions
---@field quaternion_nlerp fun(q1: Vector4, q2: Vector4, amount: number): Vector4 Calculate slerp-optimized interpolation between two quaternions
---@field quaternion_slerp fun(q1: Vector4, q2: Vector4, amount: number): Vector4 Calculate spherical linear interpolation between two quaternions
---@field quaternion_cubic_hermite_spline fun(q1: Vector4, outTangent1: Vector4, q2: Vector4, inTangent2: Vector4, t: number): Vector4 Calculate cubic hermite interpolation between two quaternions
---@field quaternion_from_vector3_to_vector3 fun(from: Vector3, to: Vector3): Vector4 Get the quaternion equivalent to a rotation from one vector to another
---@field quaternion_from_matrix fun(mat: Matrix): Vector4 Get the quaternion equivalent to rotation matrix
---@field quaternion_to_matrix fun(q: Vector4): Matrix Get the matrix equivalent to a quaternion rotation
---@field quaternion_from_axis_angle fun(axis: Vector3, angle: number): Vector4 Get the rotation quaternion for an angle around a given axis
---@field quaternion_to_axis_angle fun(q: Vector4, outAxis: Vector3, outAngle: number) Get the rotation angle and axis for a given quaternion
---@field quaternion_from_euler fun(pitch: number, yaw: number, roll: number): Vector4 Get the quaternion equivalent to Euler angles
---@field quaternion_to_euler fun(q: Vector4): Vector3 Get the Euler angles equivalent to rotation quaternion
---@field quaternion_transform fun(q: Vector4, mat: Matrix): Vector4 Transform a quaternion given a transformation matrix
---@field quaternion_equals fun(p: Vector4, q: Vector4): integer Check whether two given quaternions are almost equal
---
--- FFI library handle (includes raymath functions)
---
---@field lib any Raw FFI library handle for raymath/raylib
---@field Vector2Add fun(v1: Vector2, v2: Vector2): Vector2 Add two vectors (v1 + v2)
---@field Vector2AddValue fun(v: Vector2, add: number): Vector2 Add vector and float value
---@field Vector2Subtract fun(v1: Vector2, v2: Vector2): Vector2 Subtract two vectors (v1 - v2)
---@field Vector2SubtractValue fun(v: Vector2, sub: number): Vector2 Subtract vector by float value
---@field Vector2Multiply fun(v1: Vector2, v2: Vector2): Vector2 Multiply vector by vector
---@field Vector2Scale fun(v: Vector2, scale: number): Vector2 Scale vector (multiply by value)
---@field Vector2Divide fun(v1: Vector2, v2: Vector2): Vector2 Divide vector by vector
---@field Vector2Negate fun(v: Vector2): Vector2 Negate vector
---@field Vector2Invert fun(v: Vector2): Vector2 Invert the given vector
---@field Vector2Length fun(v: Vector2): number Calculate vector length
---@field Vector2Equals fun(p: Vector2, q: Vector2): integer Check whether two given vectors are almost equal
---@field Vector3Add fun(v1: Vector3, v2: Vector3): Vector3 Add two vectors
---@field Vector3AddValue fun(v: Vector3, add: number): Vector3 Add vector and float value
---@field Vector3Subtract fun(v1: Vector3, v2: Vector3): Vector3 Subtract two vectors
---@field Vector3SubtractValue fun(v: Vector3, sub: number): Vector3 Subtract vector by float value
---@field Vector3Multiply fun(v1: Vector3, v2: Vector3): Vector3 Multiply vector by vector
---@field Vector3Scale fun(v: Vector3, scalar: number): Vector3 Multiply vector by scalar
---@field Vector3Divide fun(v1: Vector3, v2: Vector3): Vector3 Divide vector by vector
---@field Vector3Negate fun(v: Vector3): Vector3 Negate provided vector
---@field Vector3Invert fun(v: Vector3): Vector3 Invert the given vector
---@field Vector3Length fun(v: Vector3): number Calculate vector length
---@field Vector3Equals fun(p: Vector3, q: Vector3): integer Check whether two given vectors are almost equal
---@field Vector4Add fun(v1: Vector4, v2: Vector4): Vector4 Add two vectors
---@field Vector4AddValue fun(v: Vector4, add: number): Vector4 Add vector and float value
---@field Vector4Subtract fun(v1: Vector4, v2: Vector4): Vector4 Subtract two vectors
---@field Vector4SubtractValue fun(v: Vector4, sub: number): Vector4 Subtract vector by float value
---@field Vector4Multiply fun(v1: Vector4, v2: Vector4): Vector4 Multiply vector by vector
---@field Vector4Scale fun(v: Vector4, scale: number): Vector4 Scale vector by float value
---@field Vector4Divide fun(v1: Vector4, v2: Vector4): Vector4 Divide vector by vector
---@field Vector4Negate fun(v: Vector4): Vector4 Negate vector
---@field Vector4Invert fun(v: Vector4): Vector4 Invert the given vector
---@field Vector4Length fun(v: Vector4): number Calculate vector length
---@field Vector4Equals fun(p: Vector4, q: Vector4): integer Check whether two given vectors are almost equal
---@field MatrixAdd fun(left: Matrix, right: Matrix): Matrix Add two matrices
---@field MatrixSubtract fun(left: Matrix, right: Matrix): Matrix Subtract two matrices
---@field MatrixMultiply fun(left: Matrix, right: Matrix): Matrix Get two matrix multiplication
---
--- Constructor functions
---
---@field vector2 fun(x?: number, y?: number): Vector2 Create a Vector2
---@field vector3 fun(x?: number, y?: number, z?: number): Vector3 Create a Vector3
---@field vector4 fun(x?: number, y?: number, z?: number, w?: number): Vector4 Create a Vector4
---@field matrix fun(): Matrix Create a Matrix (identity)
---@field quaternion fun(x?: number, y?: number, z?: number, w?: number): Vector4 Create a Quaternion (as Vector4)
local rm = {}

-- ============================================================================
-- HEADER PARSING
-- ============================================================================

---Find header file in common locations
---@param name string
---@return string|nil
local function findHeader(name)
	local paths = {
		"/usr/include/" .. name,
		"/usr/local/include/" .. name,
		"/opt/homebrew/include/" .. name,
		name,
	}
	for _, path in ipairs(paths) do
		local f = io.open(path, "r")
		if f then
			f:close()
			return path
		end
	end
	return nil
end

---Preprocess header file with cpp
---@param header_path string
---@return string|nil
local function preprocessHeader(header_path)
	if not header_path then return nil end

	local cmd = "cpp -P -E " .. header_path .. " 2>/dev/null"
	local handle = io.popen(cmd)
	---@type string|nil
	local content = nil
	if handle then
		content = handle:read("*a")
		handle:close()
	end
	if not content then return nil end

	local filtered = {}
	for line in content:gmatch("[^\r\n]+") do
		if line:match("%S") and
		   not line:match("__builtin") and
		   not line:match("__gnuc") and
		   not line:match("__asm__") and
		   not line:match("__attribute__") then
			table.insert(filtered, line)
		end
	end

	return table.concat(filtered, "\n")
end

-- Try to require raylib to get Vector2/Vector3/Vector4/Matrix types
-- If raylib isn't available, load raylib.h directly
local has_raylib, rl = pcall(require, "raylib")
if not has_raylib then
	-- Load raylib.h ourselves to get the base types
	local raylib_path = findHeader("raylib.h")
	if raylib_path then
		local raylib_h = preprocessHeader(raylib_path)
		if raylib_h then
			-- Filter out only struct definitions to avoid redefining functions
			local filtered = {}
			for line in raylib_h:gmatch("[^\r\n]+") do
				-- Keep typedefs and struct definitions, skip function declarations
				if line:match("^%s*typedef") or line:match("^%s*struct") or line:match("}%s*[%w_,%s]*;%s*$") then
					table.insert(filtered, line)
				end
			end
			if #filtered > 0 then
				ffi.cdef(table.concat(filtered, "\n"))
			end
		end
	end
end

-- Raymath: float3/float16 types are only in raymath.h, not raylib.h
ffi.cdef[[
	typedef struct float3 { float v[3]; } float3;
	typedef struct float16 { float v[16]; } float16;
]]

-- Raymath function declarations (inline in raymath.h but exported from libraylib)
-- Auto-parse raymath.h when available, extracting declarations from inline definitions.
-- Falls back to hardcoded declarations for reliability.
---@param header_path string
---@return string|nil
local function extractRaymathDecls(header_path)
	local content = preprocessHeader(header_path)
	if not content then return nil end

	local decls = {}
	for line in content:gmatch("[^\r\n]+") do
		local sig = line:match("^%s*inline%s+(.*%))%s*$")
		if sig then
			table.insert(decls, sig .. ";")
		end
	end

	if #decls == 0 then return nil end
	return table.concat(decls, "\n")
end

local raymath_path = findHeader("raymath.h")
local raymath_decls = raymath_path and extractRaymathDecls(raymath_path)

if raymath_decls then
	ffi.cdef(raymath_decls)
else
	-- Fallback: hardcoded declarations for raylib 6.0 raymath
	ffi.cdef[[
	float Clamp(float value, float min, float max);
	float Lerp(float start, float end, float amount);
	float Normalize(float value, float start, float end);
	float Remap(float value, float inputStart, float inputEnd, float outputStart, float outputEnd);
	float Wrap(float value, float min, float max);
	int FloatEquals(float x, float y);

	Vector2 Vector2Zero(void);
	Vector2 Vector2One(void);
	Vector2 Vector2Add(Vector2 v1, Vector2 v2);
	Vector2 Vector2AddValue(Vector2 v, float add);
	Vector2 Vector2Subtract(Vector2 v1, Vector2 v2);
	Vector2 Vector2SubtractValue(Vector2 v, float sub);
	float Vector2Length(Vector2 v);
	float Vector2LengthSqr(Vector2 v);
	float Vector2DotProduct(Vector2 v1, Vector2 v2);
	float Vector2CrossProduct(Vector2 v1, Vector2 v2);
	float Vector2Distance(Vector2 v1, Vector2 v2);
	float Vector2DistanceSqr(Vector2 v1, Vector2 v2);
	float Vector2Angle(Vector2 v1, Vector2 v2);
	float Vector2LineAngle(Vector2 start, Vector2 end);
	Vector2 Vector2Scale(Vector2 v, float scale);
	Vector2 Vector2Multiply(Vector2 v1, Vector2 v2);
	Vector2 Vector2Negate(Vector2 v);
	Vector2 Vector2Divide(Vector2 v1, Vector2 v2);
	Vector2 Vector2Normalize(Vector2 v);
	Vector2 Vector2Transform(Vector2 v, Matrix mat);
	Vector2 Vector2Lerp(Vector2 v1, Vector2 v2, float amount);
	Vector2 Vector2Reflect(Vector2 v, Vector2 normal);
	Vector2 Vector2Min(Vector2 v1, Vector2 v2);
	Vector2 Vector2Max(Vector2 v1, Vector2 v2);
	Vector2 Vector2Rotate(Vector2 v, float angle);
	Vector2 Vector2MoveTowards(Vector2 v, Vector2 target, float maxDistance);
	Vector2 Vector2Invert(Vector2 v);
	Vector2 Vector2Clamp(Vector2 v, Vector2 min, Vector2 max);
	Vector2 Vector2ClampValue(Vector2 v, float min, float max);
	int Vector2Equals(Vector2 p, Vector2 q);
	Vector2 Vector2Refract(Vector2 v, Vector2 n, float r);

	Vector3 Vector3Zero(void);
	Vector3 Vector3One(void);
	Vector3 Vector3Add(Vector3 v1, Vector3 v2);
	Vector3 Vector3AddValue(Vector3 v, float add);
	Vector3 Vector3Subtract(Vector3 v1, Vector3 v2);
	Vector3 Vector3SubtractValue(Vector3 v, float sub);
	Vector3 Vector3Scale(Vector3 v, float scalar);
	Vector3 Vector3Multiply(Vector3 v1, Vector3 v2);
	Vector3 Vector3CrossProduct(Vector3 v1, Vector3 v2);
	Vector3 Vector3Perpendicular(Vector3 v);
	float Vector3Length(const Vector3 v);
	float Vector3LengthSqr(const Vector3 v);
	float Vector3DotProduct(Vector3 v1, Vector3 v2);
	float Vector3Distance(Vector3 v1, Vector3 v2);
	float Vector3DistanceSqr(Vector3 v1, Vector3 v2);
	float Vector3Angle(Vector3 v1, Vector3 v2);
	Vector3 Vector3Negate(Vector3 v);
	Vector3 Vector3Divide(Vector3 v1, Vector3 v2);
	Vector3 Vector3Normalize(Vector3 v);
	Vector3 Vector3Project(Vector3 v1, Vector3 v2);
	Vector3 Vector3Reject(Vector3 v1, Vector3 v2);
	void Vector3OrthoNormalize(Vector3 *v1, Vector3 *v2);
	Vector3 Vector3Transform(Vector3 v, Matrix mat);
	Vector3 Vector3RotateByQuaternion(Vector3 v, Vector4 q);
	Vector3 Vector3RotateByAxisAngle(Vector3 v, Vector3 axis, float angle);
	Vector3 Vector3MoveTowards(Vector3 v, Vector3 target, float maxDistance);
	Vector3 Vector3Lerp(Vector3 v1, Vector3 v2, float amount);
	Vector3 Vector3CubicHermite(Vector3 v1, Vector3 tangent1, Vector3 v2, Vector3 tangent2, float amount);
	Vector3 Vector3Reflect(Vector3 v, Vector3 normal);
	Vector3 Vector3Min(Vector3 v1, Vector3 v2);
	Vector3 Vector3Max(Vector3 v1, Vector3 v2);
	Vector3 Vector3Barycenter(Vector3 p, Vector3 a, Vector3 b, Vector3 c);
	Vector3 Vector3Unproject(Vector3 source, Matrix projection, Matrix view);
	Vector3 Vector3Invert(Vector3 v);
	Vector3 Vector3Clamp(Vector3 v, Vector3 min, Vector3 max);
	Vector3 Vector3ClampValue(Vector3 v, float min, float max);
	int Vector3Equals(Vector3 p, Vector3 q);
	Vector3 Vector3Refract(Vector3 v, Vector3 n, float r);
	float3 Vector3ToFloatV(Vector3 v);

	Vector4 Vector4Zero(void);
	Vector4 Vector4One(void);
	Vector4 Vector4Add(Vector4 v1, Vector4 v2);
	Vector4 Vector4AddValue(Vector4 v, float add);
	Vector4 Vector4Subtract(Vector4 v1, Vector4 v2);
	Vector4 Vector4SubtractValue(Vector4 v, float sub);
	float Vector4Length(Vector4 v);
	float Vector4LengthSqr(Vector4 v);
	float Vector4DotProduct(Vector4 v1, Vector4 v2);
	float Vector4Distance(Vector4 v1, Vector4 v2);
	float Vector4DistanceSqr(Vector4 v1, Vector4 v2);
	Vector4 Vector4Scale(Vector4 v, float scale);
	Vector4 Vector4Multiply(Vector4 v1, Vector4 v2);
	Vector4 Vector4Negate(Vector4 v);
	Vector4 Vector4Divide(Vector4 v1, Vector4 v2);
	Vector4 Vector4Normalize(Vector4 v);
	Vector4 Vector4Min(Vector4 v1, Vector4 v2);
	Vector4 Vector4Max(Vector4 v1, Vector4 v2);
	Vector4 Vector4Lerp(Vector4 v1, Vector4 v2, float amount);
	Vector4 Vector4MoveTowards(Vector4 v, Vector4 target, float maxDistance);
	Vector4 Vector4Invert(Vector4 v);
	int Vector4Equals(Vector4 p, Vector4 q);

	float MatrixDeterminant(Matrix mat);
	float MatrixTrace(Matrix mat);
	Matrix MatrixTranspose(Matrix mat);
	Matrix MatrixInvert(Matrix mat);
	Matrix MatrixIdentity(void);
	Matrix MatrixAdd(Matrix left, Matrix right);
	Matrix MatrixSubtract(Matrix left, Matrix right);
	Matrix MatrixMultiply(Matrix left, Matrix right);
	Matrix MatrixTranslate(float x, float y, float z);
	Matrix MatrixRotate(Vector3 axis, float angle);
	Matrix MatrixRotateX(float angle);
	Matrix MatrixRotateY(float angle);
	Matrix MatrixRotateZ(float angle);
	Matrix MatrixRotateXYZ(Vector3 angle);
	Matrix MatrixRotateZYX(Vector3 angle);
	Matrix MatrixScale(float x, float y, float z);
	Matrix MatrixFrustum(double left, double right, double bottom, double top, double nearPlane, double farPlane);
	Matrix MatrixPerspective(double fovY, double aspect, double nearPlane, double farPlane);
	Matrix MatrixOrtho(double left, double right, double bottom, double top, double nearPlane, double farPlane);
	Matrix MatrixLookAt(Vector3 eye, Vector3 target, Vector3 up);
	float16 MatrixToFloatV(Matrix mat);
	Matrix MatrixMultiplyValue(Matrix left, float value);
	Matrix MatrixCompose(Vector3 translation, Vector4 rotation, Vector3 scale);
	void MatrixDecompose(Matrix mat, Vector3 *translation, Vector4 *rotation, Vector3 *scale);

	Vector4 QuaternionAdd(Vector4 q1, Vector4 q2);
	Vector4 QuaternionAddValue(Vector4 q, float add);
	Vector4 QuaternionSubtract(Vector4 q1, Vector4 q2);
	Vector4 QuaternionSubtractValue(Vector4 q, float sub);
	Vector4 QuaternionIdentity(void);
	float QuaternionLength(Vector4 q);
	Vector4 QuaternionNormalize(Vector4 q);
	Vector4 QuaternionInvert(Vector4 q);
	Vector4 QuaternionMultiply(Vector4 q1, Vector4 q2);
	Vector4 QuaternionScale(Vector4 q, float mul);
	Vector4 QuaternionDivide(Vector4 q1, Vector4 q2);
	Vector4 QuaternionLerp(Vector4 q1, Vector4 q2, float amount);
	Vector4 QuaternionNlerp(Vector4 q1, Vector4 q2, float amount);
	Vector4 QuaternionSlerp(Vector4 q1, Vector4 q2, float amount);
	Vector4 QuaternionCubicHermiteSpline(Vector4 q1, Vector4 outTangent1, Vector4 q2, Vector4 inTangent2, float t);
	Vector4 QuaternionFromVector3ToVector3(Vector3 from, Vector3 to);
	Vector4 QuaternionFromMatrix(Matrix mat);
	Matrix QuaternionToMatrix(Vector4 q);
	Vector4 QuaternionFromAxisAngle(Vector3 axis, float angle);
	void QuaternionToAxisAngle(Vector4 q, Vector3 *outAxis, float *outAngle);
	Vector4 QuaternionFromEuler(float pitch, float yaw, float roll);
	Vector3 QuaternionToEuler(Vector4 q);
	Vector4 QuaternionTransform(Vector4 q, Matrix mat);
	int QuaternionEquals(Vector4 p, Vector4 q);
	]]
end

---@type any
rm.lib = ffi.load("raylib")

-- ============================================================================
-- TYPE DEFINITIONS (for LSP)
-- ============================================================================

---@class Vector2
---@field x number
---@field y number

---@class Vector3
---@field x number
---@field y number
---@field z number

---@class Vector4
---@field x number
---@field y number
---@field z number
---@field w number

---@alias Quaternion Vector4

---@class Matrix
---@field m0 number
---@field m4 number
---@field m8 number
---@field m12 number
---@field m1 number
---@field m5 number
---@field m9 number
---@field m13 number
---@field m2 number
---@field m6 number
---@field m10 number
---@field m14 number
---@field m3 number
---@field m7 number
---@field m11 number
---@field m15 number

---@class float3
---@field v number[]

---@class float16
---@field v number[]

-- ============================================================================
-- CONSTRUCTOR FUNCTIONS
-- ============================================================================

---Create a Vector2
---@param x? number
---@param y? number
---@return Vector2
function rm.vector2(x, y)
	return ffi.new("Vector2", x or 0, y or 0)
end

---Create a Vector3
---@param x? number
---@param y? number
---@param z? number
---@return Vector3
function rm.vector3(x, y, z)
	return ffi.new("Vector3", x or 0, y or 0, z or 0)
end

---Create a Vector4 (or Quaternion)
---@param x? number
---@param y? number
---@param z? number
---@param w? number
---@return Vector4
function rm.vector4(x, y, z, w)
	return ffi.new("Vector4", x or 0, y or 0, z or 0, w or 0)
end

---Create a Matrix (identity)
---@return Matrix
function rm.matrix()
	return rm.lib.MatrixIdentity()
end

---Create a Quaternion (as Vector4)
---@param x? number
---@param y? number
---@param z? number
---@param w? number
---@return Vector4
function rm.quaternion(x, y, z, w)
	return ffi.new("Vector4", x or 0, y or 0, z or 0, w or 1)
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

---Create a new FFI type (shortcut to ffi.new)
---@param ctype string
---@param ... any
---@return any
function rm.new(ctype, ...)
	return ffi.new(ctype, ...)
end

---Create a pointer reference to a value (for out parameters)
---@param ctype string
---@param value? any
---@return any
function rm.ref(ctype, value)
	if value then
		return ffi.new(ctype .. "[1]", value)
	else
		return ffi.new(ctype .. "[1]")
	end
end

---Check if a value is a valid FFI cdata
---@param value any
---@return boolean
function rm.istype(ctype, value)
	return ffi.istype(ctype, value)
end

---Get the size of a C type
---@param ctype string The C type name
---@return integer
function rm.sizeof(ctype)
	return ffi.sizeof(ctype)
end

-- ============================================================================
-- METATABLE (runtime dispatch to FFI)
-- ============================================================================

-- Convert snake_case to CamelCase for FFI lookups
-- Handles special cases: 2d/3d -> 2D/3D, fps -> FPS, dpi -> DPI, etc.
local snake_word_map = {
	fps = "FPS", dpi = "DPI", url = "URL", utf8 = "UTF8",
	hsv = "HSV", pot = "POT", nn = "NN", cw = "CW", ccw = "CCW",
	das = "DAS", crc32 = "CRC32", md5 = "MD5", sha1 = "SHA1",
	sha256 = "SHA256", xyz = "XYZ", zyx = "ZYX",
	npatch = "NPatch",
	["2d"] = "2D", ["3d"] = "3D",
}

local function snake_to_camel(s)
	return (s:gsub("([%w]+)", function(word)
		-- Check if the whole word has a special mapping
		local mapped = snake_word_map[word]
		if mapped then return mapped end
		-- Normal word: capitalize first letter
		return word:sub(1, 1):upper() .. word:sub(2)
	end):gsub("_", ""))
end

-- Forward all undefined function calls to rm.lib
setmetatable(rm, {
	__index = function(t, k)
		-- Try direct lookup first (for CamelCase, etc.)
		local ok, v = pcall(function() return rm.lib[k] end)
		if ok and v then
			rawset(t, k, v)
			return v
		end
		-- Try converting snake_case to CamelCase
		local camel = snake_to_camel(k)
		if camel ~= k then
			ok, v = pcall(function() return rm.lib[camel] end)
			if ok and v then
				rawset(t, k, v)
				return v
			end
		end
		return nil
	end
})

-- ============================================================================
-- VECTOR OPERATOR OVERLOADS
-- ============================================================================

-- Only set metatypes if they haven't been set yet
-- (wrapped in pcall to handle case where raylib already set basic ones)
local function safe_metatype(ct, mt)
	local ok = pcall(function() return ffi.metatype(ct, mt) end)
	-- Return true if set successfully, false if already set
	return ok
end

safe_metatype("Vector2", {
	__add = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector2AddValue(a, b)
		elseif type(a) == "number" then
			return rm.lib.Vector2AddValue(b, a)
		else
			return rm.lib.Vector2Add(a, b)
		end
	end,
	__sub = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector2SubtractValue(a, b)
		elseif type(a) == "number" then
			-- number - vector = vector(number, number) - vector
			return rm.lib.Vector2Subtract(rm.vector2(a, a), b)
		else
			return rm.lib.Vector2Subtract(a, b)
		end
	end,
	__mul = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector2Scale(a, b)
		elseif type(a) == "number" then
			return rm.lib.Vector2Scale(b, a)
		else
			return rm.lib.Vector2Multiply(a, b)
		end
	end,
	__div = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector2Scale(a, 1.0 / b)
		elseif type(a) == "number" then
			error("Cannot divide number by vector")
		else
			return rm.lib.Vector2Divide(a, b)
		end
	end,
	__unm = function(a)
		return rm.lib.Vector2Negate(a)
	end,
	__eq = function(a, b) if not a or not b then return false end return rm.lib.Vector2Equals(a, b) == 1 end,
	__len = function(a) return rm.lib.Vector2Length(a) end,
	__tostring = function(v) return string.format("Vector2(%.3f, %.3f)", v.x, v.y) end,
})

safe_metatype("Vector3", {
	__add = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector3AddValue(a, b)
		elseif type(a) == "number" then
			return rm.lib.Vector3AddValue(b, a)
		else
			return rm.lib.Vector3Add(a, b)
		end
	end,
	__sub = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector3SubtractValue(a, b)
		elseif type(a) == "number" then
			error("Cannot subtract vector from number")
		else
			return rm.lib.Vector3Subtract(a, b)
		end
	end,
	__mul = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector3Scale(a, b)
		elseif type(a) == "number" then
			return rm.lib.Vector3Scale(b, a)
		else
			return rm.lib.Vector3Multiply(a, b)
		end
	end,
	__div = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector3Scale(a, 1.0 / b)
		elseif type(a) == "number" then
			error("Cannot divide number by vector")
		else
			return rm.lib.Vector3Divide(a, b)
		end
	end,
	__unm = function(a)
		return rm.lib.Vector3Negate(a)
	end,
	__eq = function(a, b) if not a or not b then return false end return rm.lib.Vector3Equals(a, b) == 1 end,
	__len = function(a) return rm.lib.Vector3Length(a) end,
	__tostring = function(v) return string.format("Vector3(%.3f, %.3f, %.3f)", v.x, v.y, v.z) end,
})

safe_metatype("Vector4", {
	__add = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector4AddValue(a, b)
		elseif type(a) == "number" then
			return rm.lib.Vector4AddValue(b, a)
		else
			return rm.lib.Vector4Add(a, b)
		end
	end,
	__sub = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector4SubtractValue(a, b)
		elseif type(a) == "number" then
			error("Cannot subtract vector from number")
		else
			return rm.lib.Vector4Subtract(a, b)
		end
	end,
	__mul = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector4Scale(a, b)
		elseif type(a) == "number" then
			return rm.lib.Vector4Scale(b, a)
		else
			return rm.lib.Vector4Multiply(a, b)
		end
	end,
	__div = function(a, b)
		if type(b) == "number" then
			return rm.lib.Vector4Scale(a, 1.0 / b)
		elseif type(a) == "number" then
			error("Cannot divide number by vector")
		else
			return rm.lib.Vector4Divide(a, b)
		end
	end,
	__unm = function(a)
		return rm.lib.Vector4Negate(a)
	end,
	__eq = function(a, b) if not a or not b then return false end return rm.lib.Vector4Equals(a, b) == 1 end,
	__len = function(a) return rm.lib.Vector4Length(a) end,
	__tostring = function(v) return string.format("Vector4(%.3f, %.3f, %.3f, %.3f)", v.x, v.y, v.z, v.w) end,
})

safe_metatype("Matrix", {
	__add = function(a, b) return rm.lib.MatrixAdd(a, b) end,
	__sub = function(a, b) return rm.lib.MatrixSubtract(a, b) end,
	__mul = function(a, b)
		if type(b) == "number" then
			return rm.lib.MatrixMultiplyValue(a, b)
		elseif type(a) == "number" then
			return rm.lib.MatrixMultiplyValue(b, a)
		else
			return rm.lib.MatrixMultiply(a, b)
		end
	end,
	__tostring = function(m)
		return string.format(
			"Matrix[\n  %.3f %.3f %.3f %.3f\n  %.3f %.3f %.3f %.3f\n  %.3f %.3f %.3f %.3f\n  %.3f %.3f %.3f %.3f\n]",
			m.m0, m.m4, m.m8, m.m12,
			m.m1, m.m5, m.m9, m.m13,
			m.m2, m.m6, m.m10, m.m14,
			m.m3, m.m7, m.m11, m.m15
		)
	end,
})

return rm
