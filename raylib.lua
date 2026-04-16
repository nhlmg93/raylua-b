---@meta
---@class raylib
---Complete FFI bindings for raylib 6.0 with full LSP support
---Load with: local rl = require("vendor.raylib")

local ffi = require("ffi")

---@class raylib
---
--- Window-related functions
---
---@field init_window fun(width: integer, height: integer, title: string) Initialize window and OpenGL context
---@field close_window fun() Close window and unload OpenGL context
---@field window_should_close fun(): boolean Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
---@field is_window_ready fun(): boolean Check if window has been initialized successfully
---@field is_window_fullscreen fun(): boolean Check if window is currently fullscreen
---@field is_window_hidden fun(): boolean Check if window is currently hidden
---@field is_window_minimized fun(): boolean Check if window is currently minimized
---@field is_window_maximized fun(): boolean Check if window is currently maximized
---@field is_window_focused fun(): boolean Check if window is currently focused
---@field is_window_resized fun(): boolean Check if window has been resized last frame
---@field is_window_state fun(flag: integer): boolean Check if one specific window flag is enabled
---@field set_window_state fun(flags: integer) Set window configuration state using flags
---@field clear_window_state fun(flags: integer) Clear window configuration state flags
---@field toggle_fullscreen fun() Toggle window state: fullscreen/windowed, resizes monitor to match window resolution
---@field toggle_borderless_windowed fun() Toggle window state: borderless windowed, resizes window to match monitor resolution
---@field maximize_window fun() Set window state: maximized, if resizable
---@field minimize_window fun() Set window state: minimized, if resizable
---@field restore_window fun() Set window state: not minimized/maximized
---@field set_window_icon fun(image: Image) Set icon for window (single image, RGBA 32bit)
---@field set_window_icons fun(images: Image[], count: integer) Set icon for window (multiple images, RGBA 32bit)
---@field set_window_title fun(title: string) Set title for window
---@field set_window_position fun(x: integer, y: integer) Set window position on screen
---@field set_window_monitor fun(monitor: integer) Set monitor for the current window
---@field set_window_min_size fun(width: integer, height: integer) Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
---@field set_window_max_size fun(width: integer, height: integer) Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE)
---@field set_window_size fun(width: integer, height: integer) Set window dimensions
---@field set_window_opacity fun(opacity: number) Set window opacity [0.0f..1.0f]
---@field set_window_focused fun() Set window focused
---@field get_window_handle fun(): lightuserdata Get native window handle
---@field get_screen_width fun(): integer Get current screen width
---@field get_screen_height fun(): integer Get current screen height
---@field get_render_width fun(): integer Get current render width (it considers HiDPI)
---@field get_render_height fun(): integer Get current render height (it considers HiDPI)
---@field get_monitor_count fun(): integer Get number of connected monitors
---@field get_current_monitor fun(): integer Get current monitor where window is placed
---@field get_monitor_position fun(monitor: integer): Vector2 Get specified monitor position
---@field get_monitor_width fun(monitor: integer): integer Get specified monitor width (current video mode used by monitor)
---@field get_monitor_height fun(monitor: integer): integer Get specified monitor height (current video mode used by monitor)
---@field get_monitor_physical_width fun(monitor: integer): integer Get specified monitor physical width in millimetres
---@field get_monitor_physical_height fun(monitor: integer): integer Get specified monitor physical height in millimetres
---@field get_monitor_refresh_rate fun(monitor: integer): integer Get specified monitor refresh rate
---@field get_window_position fun(): Vector2 Get window position XY on monitor
---@field get_window_scale_dpi fun(): Vector2 Get window scale DPI factor
---@field get_monitor_name fun(monitor: integer): string Get the human-readable, UTF-8 encoded name of the specified monitor
---@field set_clipboard_text fun(text: string) Set clipboard text content
---@field get_clipboard_text fun(): string Get clipboard text content
---@field get_clipboard_image fun(): Image Get clipboard image content
---@field enable_event_waiting fun() Enable waiting for events on EndDrawing(), no automatic event polling
---@field disable_event_waiting fun() Disable waiting for events on EndDrawing(), automatic events polling
---
--- Cursor-related functions
---
---@field show_cursor fun() Shows cursor
---@field hide_cursor fun() Hides cursor
---@field is_cursor_hidden fun(): boolean Check if cursor is not visible
---@field enable_cursor fun() Enables cursor (unlock cursor)
---@field disable_cursor fun() Disables cursor (lock cursor)
---@field is_cursor_on_screen fun(): boolean Check if cursor is on the screen
---
--- Drawing-related functions
---
---@field clear_background fun(color: Color) Set background color (framebuffer clear color)
---@field begin_drawing fun() Setup canvas (framebuffer) to start drawing
---@field end_drawing fun() End canvas drawing and swap buffers (double buffering)
---@field begin_mode_2d fun(camera: Camera2D) Begin 2D mode with custom camera (2D)
---@field end_mode_2d fun() Ends 2D mode with custom camera
---@field begin_mode_3d fun(camera: Camera3D) Begin 3D mode with custom camera (3D)
---@field end_mode_3d fun() Ends 3D mode and returns to default 2D orthographic mode
---@field begin_texture_mode fun(target: RenderTexture2D) Begin drawing to render texture
---@field end_texture_mode fun() Ends drawing to render texture
---@field begin_shader_mode fun(shader: Shader) Begin custom shader drawing
---@field end_shader_mode fun() End custom shader drawing (use default shader)
---@field begin_blend_mode fun(mode: integer) Begin blending mode (alpha, additive, multiplied, subtract, custom)
---@field end_blend_mode fun() End blending mode (reset to default: alpha blending)
---@field begin_scissor_mode fun(x: integer, y: integer, width: integer, height: integer) Begin scissor mode (define screen area for following drawing)
---@field end_scissor_mode fun() End scissor mode
---@field begin_vr_stereo_mode fun(config: VrStereoConfig) Begin stereo rendering (requires VR simulator)
---@field end_vr_stereo_mode fun() End stereo rendering (requires VR simulator)
---
--- VR stereo config functions
---
---@field load_vr_stereo_config fun(device: VrDeviceInfo): VrStereoConfig Load VR stereo config for VR simulator device parameters
---@field unload_vr_stereo_config fun(config: VrStereoConfig) Unload VR stereo config
---
--- Shader management functions
---
---@field load_shader fun(vsFileName: string, fsFileName: string): Shader Load shader from files and bind default locations
---@field load_shader_from_memory fun(vsCode: string, fsCode: string): Shader Load shader from code strings and bind default locations
---@field is_shader_valid fun(shader: Shader): boolean Check if a shader is valid (loaded on GPU)
---@field get_shader_location fun(shader: Shader, uniformName: string): integer Get shader uniform location
---@field get_shader_location_attrib fun(shader: Shader, attribName: string): integer Get shader attribute location
---@field set_shader_value fun(shader: Shader, locIndex: integer, value: number[]|integer[], uniformType: integer) Set shader uniform value
---@field set_shader_value_v fun(shader: Shader, locIndex: integer, value: number[]|integer[], uniformType: integer, count: integer) Set shader uniform value vector
---@field set_shader_value_matrix fun(shader: Shader, locIndex: integer, mat: Matrix) Set shader uniform value (matrix 4x4)
---@field set_shader_value_texture fun(shader: Shader, locIndex: integer, texture: Texture2D) Set shader uniform value for texture (sampler2d)
---@field unload_shader fun(shader: Shader) Unload shader from GPU memory (VRAM)
---
--- Screen-space-related functions
---
---@field get_screen_to_world_ray fun(position: Vector2, camera: Camera3D): Ray Get a ray trace from screen position (i.e mouse)
---@field get_screen_to_world_ray_ex fun(position: Vector2, camera: Camera3D, width: integer, height: integer): Ray Get a ray trace from screen position (i.e mouse) in a viewport
---@field get_world_to_screen fun(position: Vector3, camera: Camera3D): Vector2 Get the screen space position for a 3d world space position
---@field get_world_to_screen_ex fun(position: Vector3, camera: Camera3D, width: integer, height: integer): Vector2 Get size position for a 3d world space position
---@field get_world_to_screen_2d fun(position: Vector2, camera: Camera2D): Vector2 Get the screen space position for a 2d camera world space position
---@field get_screen_to_world_2d fun(position: Vector2, camera: Camera2D): Vector2 Get the world space position for a 2d camera screen space position
---@field get_camera_matrix fun(camera: Camera3D): Matrix Get camera transform matrix (view matrix)
---@field get_camera_matrix_2d fun(camera: Camera2D): Matrix Get camera 2d transform matrix
---
--- Timing-related functions
---
---@field set_target_fps fun(fps: integer) Set target FPS (maximum)
---@field get_frame_time fun(): number Get time in seconds for last frame drawn (delta time)
---@field get_time fun(): number Get elapsed time in seconds since InitWindow()
---@field get_fps fun(): integer Get current FPS
---
--- Misc functions
---
---@field swap_screen_buffer fun() Swap back buffer with front buffer (screen drawing)
---@field poll_input_events fun() Register all input events
---@field wait_time fun(seconds: number) Wait for some time (halt program execution)
---@field set_random_seed fun(seed: integer) Set the seed for the random number generator
---@field get_random_value fun(min: integer, max: integer): integer Get a random value between min and max (both included)
---@field load_random_sequence fun(count: integer, min: integer, max: integer): integer[] Load random values sequence, no values repeated
---@field unload_random_sequence fun(sequence: integer[]) Unload random values sequence
---@field take_screenshot fun(fileName: string) Takes a screenshot of current screen (filename extension defines format)
---@field set_config_flags fun(flags: integer) Setup init configuration flags (view FLAGS)
---@field open_url fun(url: string) Open URL with default system browser (if available)
---@field trace_log fun(logLevel: integer, text: string, ...: any) Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
---@field set_trace_log_level fun(logLevel: integer) Set the current threshold (minimum) log level
---@field mem_alloc fun(size: integer): lightuserdata Internal memory allocator
---@field mem_realloc fun(ptr: lightuserdata, size: integer): lightuserdata Internal memory reallocator
---@field mem_free fun(ptr: lightuserdata) Internal memory free
---@field set_trace_log_callback fun(callback: function) Set custom trace log
---@field set_load_file_data_callback fun(callback: function) Set custom file binary data loader
---@field set_save_file_data_callback fun(callback: function) Set custom file binary data saver
---@field set_load_file_text_callback fun(callback: function) Set custom file text data loader
---@field set_save_file_text_callback fun(callback: function) Set custom file text data saver
---
--- File management functions
---
---@field load_file_data fun(fileName: string, dataSize: integer[]): lightuserdata Load file data as byte array (read)
---@field unload_file_data fun(data: lightuserdata) Unload file data allocated by LoadFileData()
---@field save_file_data fun(fileName: string, data: lightuserdata, dataSize: integer): boolean Save data to file from byte array (write), returns true on success
---@field export_data_as_code fun(data: lightuserdata, dataSize: integer, fileName: string): boolean Export data to code (.h), returns true on success
---@field load_file_text fun(fileName: string): string Load text data from file (read), returns a '\0' terminated string
---@field unload_file_text fun(text: string) Unload file text data allocated by LoadFileText()
---@field save_file_text fun(fileName: string, text: string): boolean Save text data to file (write), string must be '\0' terminated, returns true on success
---@field file_exists fun(fileName: string): boolean Check if file exists
---@field directory_exists fun(dirPath: string): boolean Check if a directory path exists
---@field is_file_extension fun(fileName: string, ext: string): boolean Check file extension (including point: .png, .wav)
---@field get_file_length fun(fileName: string): integer Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
---@field get_file_extension fun(fileName: string): string Get pointer to extension for a filename string (includes dot: '.png')
---@field get_file_name fun(filePath: string): string Get pointer to filename for a path string
---@field get_file_name_without_ext fun(filePath: string): string Get filename string without extension (uses static string)
---@field get_directory_path fun(filePath: string): string Get full path for a given fileName with path (uses static string)
---@field get_prev_directory_path fun(dirPath: string): string Get previous directory path for a given path (uses static string)
---@field get_working_directory fun(): string Get current working directory (uses static string)
---@field get_application_directory fun(): string Get the directory of the running application (uses static string)
---@field make_directory fun(dirPath: string): integer Create directories (including full path requested), returns 0 on success
---@field change_directory fun(dir: string): boolean Change working directory, return true on success
---@field is_path_file fun(path: string): boolean Check if a given path is a file or a directory
---@field is_file_name_valid fun(fileName: string): boolean Check if fileName is valid for the platform/OS
---@field load_directory_files fun(dirPath: string): FilePathList Load directory filepaths
---@field load_directory_files_ex fun(basePath: string, filter: string, scanSubdirs: boolean): FilePathList Load directory filepaths with extension filtering and recursive directory scan. Use 'DIR' in the filter string to include directories in the result
---@field unload_directory_files fun(files: FilePathList) Unload filepaths
---@field is_file_dropped fun(): boolean Check if a file has been dropped into window
---@field load_dropped_files fun(): FilePathList Load dropped filepaths
---@field unload_dropped_files fun(files: FilePathList) Unload dropped filepaths
---@field get_file_mod_time fun(fileName: string): integer Get file modification time (last write time)
---@field file_rename fun(fileName: string, fileRename: string): integer Rename a file, returns 0 on success
---@field file_remove fun(fileName: string): integer Remove a file, returns 0 on success
---@field file_copy fun(srcPath: string, dstPath: string): integer Copy a file, returns 0 on success
---@field file_move fun(srcPath: string, dstPath: string): integer Move/rename a file, returns 0 on success
---@field file_text_replace fun(fileName: string, search: string, replacement: string): integer Replace text in a file, returns 0 on success
---@field file_text_find_index fun(fileName: string, search: string): integer Find text in a file, returns first occurrence index
---@field get_directory_file_count fun(dirPath: string): integer Get directory file count
---@field get_directory_file_count_ex fun(basePath: string, filter: string, scanSubdirs: boolean): integer Get directory file count with filtering
---
--- Compression/encoding functions
---
---@field compress_data fun(data: lightuserdata, dataSize: integer, compDataSize: integer[]): lightuserdata Compress data (DEFLATE algorithm), memory must be MemFree()
---@field decompress_data fun(compData: lightuserdata, compDataSize: integer, dataSize: integer[]): lightuserdata Decompress data (DEFLATE algorithm), memory must be MemFree()
---@field encode_data_base64 fun(data: lightuserdata, dataSize: integer, outputSize: integer[]): string Encode data to Base64 string, memory must be MemFree()
---@field decode_data_base64 fun(text: string, outputSize: integer[]): lightuserdata Decode Base64 string data, memory must be MemFree()
---
--- Hash functions
---
---@field compute_crc32 fun(data: lightuserdata, dataSize: integer): integer Compute CRC32 hash code
---@field compute_md5 fun(data: lightuserdata, dataSize: integer): integer[] Compute MD5 hash code, returns static int[4] (16 bytes)
---@field compute_sha1 fun(data: lightuserdata, dataSize: integer): integer[] Compute SHA1 hash code, returns static int[5] (20 bytes)
---@field compute_sha256 fun(data: lightuserdata, dataSize: integer): integer[] Compute SHA256 hash code, returns static int[8] (32 bytes)
---
--- Automation events functions
---
---@field load_automation_event_list fun(fileName: string): AutomationEventList Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS
---@field unload_automation_event_list fun(list: AutomationEventList) Unload automation events list from file
---@field export_automation_event_list fun(list: AutomationEventList, fileName: string): boolean Export automation events list as text file
---@field set_automation_event_list fun(list: AutomationEventList) Set automation event list to record to
---@field set_automation_event_base_frame fun(frame: integer) Set automation event internal base frame to start recording
---@field start_automation_event_recording fun() Start recording automation events (AutomationEventList must be set)
---@field stop_automation_event_recording fun() Stop recording automation events
---@field play_automation_event fun(event: AutomationEvent) Play a recorded automation event
---
--- Input: keyboard functions
---
---@field is_key_pressed fun(key: integer): boolean Check if a key has been pressed once
---@field is_key_pressed_repeat fun(key: integer): boolean Check if a key has been pressed again
---@field is_key_down fun(key: integer): boolean Check if a key is being pressed
---@field is_key_released fun(key: integer): boolean Check if a key has been released once
---@field is_key_up fun(key: integer): boolean Check if a key is NOT being pressed
---@field get_key_pressed fun(): integer Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
---@field get_char_pressed fun(): integer Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
---@field get_key_name fun(key: integer): string Get name of a key, returns string
---@field set_exit_key fun(key: integer) Set a custom key to exit program (default is ESC)
---
--- Input: gamepad functions
---
---@field is_gamepad_available fun(gamepad: integer): boolean Check if a gamepad is available
---@field get_gamepad_name fun(gamepad: integer): string Get gamepad internal name id
---@field is_gamepad_button_pressed fun(gamepad: integer, button: integer): boolean Check if a gamepad button has been pressed once
---@field is_gamepad_button_down fun(gamepad: integer, button: integer): boolean Check if a gamepad button is being pressed
---@field is_gamepad_button_released fun(gamepad: integer, button: integer): boolean Check if a gamepad button has been released once
---@field is_gamepad_button_up fun(gamepad: integer, button: integer): boolean Check if a gamepad button is NOT being pressed
---@field get_gamepad_button_pressed fun(): integer Get the last gamepad button pressed
---@field get_gamepad_axis_count fun(gamepad: integer): integer Get gamepad axis count for a gamepad
---@field get_gamepad_axis_movement fun(gamepad: integer, axis: integer): number Get axis movement value for a gamepad axis
---@field set_gamepad_mappings fun(mappings: string): integer Set internal gamepad mappings (SDL_GameControllerDB)
---@field set_gamepad_vibration fun(gamepad: integer, leftMotor: number, rightMotor: number, duration: number) Set gamepad vibration for both motors (duration in seconds)
---
--- Input: mouse functions
---
---@field is_mouse_button_pressed fun(button: integer): boolean Check if a mouse button has been pressed once
---@field is_mouse_button_down fun(button: integer): boolean Check if a mouse button is being pressed
---@field is_mouse_button_released fun(button: integer): boolean Check if a mouse button has been released once
---@field is_mouse_button_up fun(button: integer): boolean Check if a mouse button is NOT being pressed
---@field get_mouse_x fun(): integer Get mouse position X
---@field get_mouse_y fun(): integer Get mouse position Y
---@field get_mouse_position fun(): Vector2 Get mouse position XY
---@field get_mouse_delta fun(): Vector2 Get mouse delta between frames
---@field set_mouse_position fun(x: integer, y: integer) Set mouse position XY
---@field set_mouse_offset fun(offsetX: integer, offsetY: integer) Set mouse offset
---@field set_mouse_scale fun(scaleX: number, scaleY: number) Set mouse scaling
---@field get_mouse_wheel_move fun(): number Get mouse wheel movement for X or Y, whichever is larger
---@field get_mouse_wheel_move_v fun(): Vector2 Get mouse wheel movement for both X and Y
---@field set_mouse_cursor fun(cursor: integer) Set mouse cursor
---
--- Input: touch functions
---
---@field get_touch_x fun(): integer Get touch position X for touch point 0 (relative to screen size)
---@field get_touch_y fun(): integer Get touch position Y for touch point 0 (relative to screen size)
---@field get_touch_position fun(index: integer): Vector2 Get touch position XY for a touch point index (relative to screen size)
---@field get_touch_point_id fun(index: integer): integer Get touch point identifier for given index
---@field get_touch_point_count fun(): integer Get number of touch points
---
--- Input: gesture functions
---
---@field set_gestures_enabled fun(flags: integer) Enable a set of gestures using flags
---@field is_gesture_detected fun(gesture: integer): boolean Check if a gesture have been detected
---@field get_gesture_detected fun(): integer Get latest detected gesture
---@field get_gesture_hold_duration fun(): number Get gesture hold time in seconds
---@field get_gesture_drag_vector fun(): Vector2 Get gesture drag vector
---@field get_gesture_drag_angle fun(): number Get gesture drag angle
---@field get_gesture_pinch_vector fun(): Vector2 Get gesture pinch delta
---@field get_gesture_pinch_angle fun(): number Get gesture pinch angle
---
--- Camera functions
---
---@field update_camera fun(camera: Camera3D, mode: integer) Update camera position for selected mode
---@field update_camera_pro fun(camera: Camera3D, movement: Vector3, rotation: Vector3, zoom: number) Update camera movement/rotation
---
--- Shapes: basic drawing functions
---
---@field set_shapes_texture fun(texture: Texture2D, source: Rectangle) Set texture and rectangle to be used on shapes drawing
---@field get_shapes_texture fun(): Texture2D Get texture that is used for shapes drawing
---@field get_shapes_texture_rectangle fun(): Rectangle Get texture source rectangle that is used for shapes drawing
---@field draw_pixel fun(posX: integer, posY: integer, color: Color) Draw a pixel using geometry [Can be slow, use with care]
---@field draw_pixel_v fun(position: Vector2, color: Color) Draw a pixel using geometry (Vector version) [Can be slow, use with care]
---@field draw_line fun(startPosX: integer, startPosY: integer, endPosX: integer, endPosY: integer, color: Color) Draw a line
---@field draw_line_v fun(startPos: Vector2, endPos: Vector2, color: Color) Draw a line (using gl lines)
---@field draw_line_ex fun(startPos: Vector2, endPos: Vector2, thick: number, color: Color) Draw a line (using triangles/quads)
---@field draw_line_strip fun(points: Vector2[], pointCount: integer, color: Color) Draw lines sequence (using gl lines)
---@field draw_line_bezier fun(startPos: Vector2, endPos: Vector2, thick: number, color: Color) Draw line segment cubic-bezier in-out interpolation
---@field draw_line_dashed fun(startPos: Vector2, endPos: Vector2, dashSize: integer, spaceSize: integer, color: Color) Draw a dashed line
---@field draw_circle fun(centerX: integer, centerY: integer, radius: number, color: Color) Draw a color-filled circle
---@field draw_circle_sector fun(center: Vector2, radius: number, startAngle: number, endAngle: number, segments: integer, color: Color) Draw a piece of a circle
---@field draw_circle_sector_lines fun(center: Vector2, radius: number, startAngle: number, endAngle: number, segments: integer, color: Color) Draw circle sector outline
---@field draw_circle_gradient fun(centerX: integer, centerY: integer, radius: number, inner: Color, outer: Color) Draw a gradient-filled circle
---@field draw_circle_v fun(center: Vector2, radius: number, color: Color) Draw a color-filled circle (Vector version)
---@field draw_circle_lines fun(centerX: integer, centerY: integer, radius: number, color: Color) Draw circle outline
---@field draw_circle_lines_v fun(center: Vector2, radius: number, color: Color) Draw circle outline (Vector version)
---@field draw_ellipse fun(centerX: integer, centerY: integer, radiusH: number, radiusV: number, color: Color) Draw ellipse
---@field draw_ellipse_v fun(center: Vector2, radiusH: number, radiusV: number, color: Color) Draw ellipse (Vector version)
---@field draw_ellipse_lines fun(centerX: integer, centerY: integer, radiusH: number, radiusV: number, color: Color) Draw ellipse outline
---@field draw_ellipse_lines_v fun(center: Vector2, radiusH: number, radiusV: number, color: Color) Draw ellipse outline (Vector version)
---@field draw_ring fun(center: Vector2, innerRadius: number, outerRadius: number, startAngle: number, endAngle: number, segments: integer, color: Color) Draw ring
---@field draw_ring_lines fun(center: Vector2, innerRadius: number, outerRadius: number, startAngle: number, endAngle: number, segments: integer, color: Color) Draw ring outline
---@field draw_rectangle fun(posX: integer, posY: integer, width: integer, height: integer, color: Color) Draw a color-filled rectangle
---@field draw_rectangle_v fun(position: Vector2, size: Vector2, color: Color) Draw a color-filled rectangle (Vector version)
---@field draw_rectangle_rec fun(rec: Rectangle, color: Color) Draw a color-filled rectangle
---@field draw_rectangle_pro fun(rec: Rectangle, origin: Vector2, rotation: number, color: Color) Draw a color-filled rectangle with pro parameters
---@field draw_rectangle_gradient_v fun(posX: integer, posY: integer, width: integer, height: integer, top: Color, bottom: Color) Draw a vertical-gradient-filled rectangle
---@field draw_rectangle_gradient_h fun(posX: integer, posY: integer, width: integer, height: integer, left: Color, right: Color) Draw a horizontal-gradient-filled rectangle
---@field draw_rectangle_gradient_ex fun(rec: Rectangle, topLeft: Color, bottomLeft: Color, bottomRight: Color, topRight: Color) Draw a gradient-filled rectangle with custom vertex colors
---@field draw_rectangle_lines fun(posX: integer, posY: integer, width: integer, height: integer, color: Color) Draw rectangle outline
---@field draw_rectangle_lines_ex fun(rec: Rectangle, lineThick: number, color: Color) Draw rectangle outline with extended parameters
---@field draw_rectangle_rounded fun(rec: Rectangle, roundness: number, segments: integer, color: Color) Draw rectangle with rounded edges
---@field draw_rectangle_rounded_lines fun(rec: Rectangle, roundness: number, segments: integer, color: Color) Draw rectangle lines with rounded edges
---@field draw_rectangle_rounded_lines_ex fun(rec: Rectangle, roundness: number, segments: integer, lineThick: number, color: Color) Draw rectangle with rounded edges outline
---@field draw_triangle fun(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) Draw a color-filled triangle (vertex in counter-clockwise order!)
---@field draw_triangle_lines fun(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) Draw triangle outline (vertex in counter-clockwise order!)
---@field draw_triangle_fan fun(points: Vector2[], pointCount: integer, color: Color) Draw a triangle fan defined by points (first vertex is the center)
---@field draw_triangle_strip fun(points: Vector2[], pointCount: integer, color: Color) Draw a triangle strip defined by points
---@field draw_poly fun(center: Vector2, sides: integer, radius: number, rotation: number, color: Color) Draw a regular polygon (Vector version)
---@field draw_poly_lines fun(center: Vector2, sides: integer, radius: number, rotation: number, color: Color) Draw a polygon outline of n sides
---@field draw_poly_lines_ex fun(center: Vector2, sides: integer, radius: number, rotation: number, lineThick: number, color: Color) Draw a polygon outline of n sides with extended parameters
---
--- Shapes: spline functions
---
---@field draw_spline_linear fun(points: Vector2[], pointCount: integer, thick: number, color: Color) Draw spline: Linear, minimum 2 points
---@field draw_spline_basis fun(points: Vector2[], pointCount: integer, thick: number, color: Color) Draw spline: B-Spline, minimum 4 points
---@field draw_spline_catmull_rom fun(points: Vector2[], pointCount: integer, thick: number, color: Color) Draw spline: Catmull-Rom, minimum 4 points
---@field draw_spline_bezier_quadratic fun(points: Vector2[], pointCount: integer, thick: number, color: Color) Draw spline: Quadratic Bezier, minimum 3 points (1 control point): [p1, c2, p3, c4...]
---@field draw_spline_bezier_cubic fun(points: Vector2[], pointCount: integer, thick: number, color: Color) Draw spline: Cubic Bezier, minimum 4 points (2 control points): [p1, c2, c3, p4, c5, c6...]
---@field draw_spline_segment_linear fun(p1: Vector2, p2: Vector2, thick: number, color: Color) Draw spline segment: Linear, 2 points
---@field draw_spline_segment_basis fun(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: number, color: Color) Draw spline segment: B-Spline, 4 points
---@field draw_spline_segment_catmull_rom fun(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: number, color: Color) Draw spline segment: Catmull-Rom, 4 points
---@field draw_spline_segment_bezier_quadratic fun(p1: Vector2, c2: Vector2, p3: Vector2, thick: number, color: Color) Draw spline segment: Quadratic Bezier, 2 points, 1 control point
---@field draw_spline_segment_bezier_cubic fun(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, thick: number, color: Color) Draw spline segment: Cubic Bezier, 2 points, 2 control points
---@field get_spline_point_linear fun(startPos: Vector2, endPos: Vector2, t: number): Vector2 Get (evaluate) spline point: Linear
---@field get_spline_point_basis fun(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: number): Vector2 Get (evaluate) spline point: B-Spline
---@field get_spline_point_catmull_rom fun(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: number): Vector2 Get (evaluate) spline point: Catmull-Rom
---@field get_spline_point_bezier_quad fun(p1: Vector2, c2: Vector2, p3: Vector2, t: number): Vector2 Get (evaluate) spline point: Quadratic Bezier
---@field get_spline_point_bezier_cubic fun(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, t: number): Vector2 Get (evaluate) spline point: Cubic Bezier
---
--- Shapes: collision functions
---
---@field check_collision_recs fun(rec1: Rectangle, rec2: Rectangle): boolean Check collision between two rectangles
---@field check_collision_circles fun(center1: Vector2, radius1: number, center2: Vector2, radius2: number): boolean Check collision between two circles
---@field check_collision_circle_rec fun(center: Vector2, radius: number, rec: Rectangle): boolean Check collision between circle and rectangle
---@field check_collision_circle_line fun(center: Vector2, radius: number, p1: Vector2, p2: Vector2): boolean Check if circle collides with a line created betweeen two points [p1] and [p2]
---@field check_collision_point_rec fun(point: Vector2, rec: Rectangle): boolean Check if point is inside rectangle
---@field check_collision_point_circle fun(point: Vector2, center: Vector2, radius: number): boolean Check if point is inside circle
---@field check_collision_point_triangle fun(point: Vector2, p1: Vector2, p2: Vector2, p3: Vector2): boolean Check if point is inside a triangle
---@field check_collision_point_line fun(point: Vector2, p1: Vector2, p2: Vector2, threshold: integer): boolean Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
---@field check_collision_point_poly fun(point: Vector2, points: Vector2[], pointCount: integer): boolean Check if point is within a polygon described by array of vertices
---@field check_collision_lines fun(startPos1: Vector2, endPos1: Vector2, startPos2: Vector2, endPos2: Vector2, collisionPoint: Vector2): boolean Check the collision between two lines defined by two points each, returns collision point by reference
---@field get_collision_rec fun(rec1: Rectangle, rec2: Rectangle): Rectangle Get collision rectangle for two rectangles collision
---
--- Textures: image loading functions
---
---@field load_image fun(fileName: string): Image Load image from file into CPU memory (RAM)
---@field load_image_raw fun(fileName: string, width: integer, height: integer, format: integer, headerSize: integer): Image Load image from RAW file data
---@field load_image_anim fun(fileName: string, frames: integer[]): Image Load image sequence from file (frames appended to image.data)
---@field load_image_anim_from_memory fun(fileType: string, fileData: lightuserdata, dataSize: integer, frames: integer[]): Image Load image sequence from memory buffer
---@field load_image_from_memory fun(fileType: string, fileData: lightuserdata, dataSize: integer): Image Load image from memory buffer, fileType refers to extension: i.e. '.png'
---@field load_image_from_texture fun(texture: Texture2D): Image Load image from GPU texture data
---@field load_image_from_screen fun(): Image Load image from screen buffer and (screenshot)
---@field is_image_valid fun(image: Image): boolean Check if an image is valid (data and parameters)
---@field unload_image fun(image: Image) Unload image from CPU memory (RAM)
---@field export_image fun(image: Image, fileName: string): boolean Export image data to file, returns true on success
---@field export_image_to_memory fun(image: Image, fileType: string, fileSize: integer[]): lightuserdata Export image to memory buffer
---@field export_image_as_code fun(image: Image, fileName: string): boolean Export image as code file defining an array of bytes, returns true on success
---
--- Textures: image generation functions
---
---@field gen_image_color fun(width: integer, height: integer, color: Color): Image Generate image: plain color
---@field gen_image_gradient_linear fun(width: integer, height: integer, direction: integer, start: Color, end: Color): Image Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
---@field gen_image_gradient_radial fun(width: integer, height: integer, density: number, inner: Color, outer: Color): Image Generate image: radial gradient
---@field gen_image_gradient_square fun(width: integer, height: integer, density: number, inner: Color, outer: Color): Image Generate image: square gradient
---@field gen_image_checked fun(width: integer, height: integer, checksX: integer, checksY: integer, col1: Color, col2: Color): Image Generate image: checked
---@field gen_image_white_noise fun(width: integer, height: integer, factor: number): Image Generate image: white noise
---@field gen_image_perlin_noise fun(width: integer, height: integer, offsetX: integer, offsetY: integer, scale: number): Image Generate image: perlin noise
---@field gen_image_cellular fun(width: integer, height: integer, tileSize: integer): Image Generate image: cellular algorithm, bigger tileSize means bigger cells
---@field gen_image_text fun(width: integer, height: integer, text: string): Image Generate image: grayscale image from text data
---
--- Textures: image manipulation functions
---
---@field image_copy fun(image: Image): Image Create an image duplicate (useful for transformations)
---@field image_from_image fun(image: Image, rec: Rectangle): Image Create an image from another image piece
---@field image_from_channel fun(image: Image, selectedChannel: integer): Image Create an image from a selected channel of another image (GRAYSCALE)
---@field image_text fun(text: string, fontSize: integer, color: Color): Image Create an image from text (default font)
---@field image_text_ex fun(font: Font, text: string, fontSize: number, spacing: number, tint: Color): Image Create an image from text (custom sprite font)
---@field image_format fun(image: Image, newFormat: integer) Convert image data to desired format
---@field image_to_pot fun(image: Image, fill: Color) Convert image to POT (power-of-two)
---@field image_crop fun(image: Image, crop: Rectangle) Crop an image to a defined rectangle
---@field image_alpha_crop fun(image: Image, threshold: number) Crop image depending on alpha value
---@field image_alpha_clear fun(image: Image, color: Color, threshold: number) Clear alpha channel to desired color
---@field image_alpha_mask fun(image: Image, alphaMask: Image) Apply alpha mask to image
---@field image_alpha_premultiply fun(image: Image) Premultiply alpha channel
---@field image_blur_gaussian fun(image: Image, blurSize: integer) Apply Gaussian blur using a box blur approximation
---@field image_kernel_convolution fun(image: Image, kernel: number[], kernelSize: integer) Apply custom square convolution kernel to image
---@field image_resize fun(image: Image, newWidth: integer, newHeight: integer) Resize image (Bicubic scaling algorithm)
---@field image_resize_nn fun(image: Image, newWidth: integer, newHeight: integer) Resize image (Nearest-Neighbor scaling algorithm)
---@field image_resize_canvas fun(image: Image, newWidth: integer, newHeight: integer, offsetX: integer, offsetY: integer, fill: Color) Resize canvas and fill with color
---@field image_mipmaps fun(image: Image) Compute all mipmap levels for a provided image
---@field image_dither fun(image: Image, rBpp: integer, gBpp: integer, bBpp: integer, aBpp: integer) Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
---@field image_flip_vertical fun(image: Image) Flip image vertically
---@field image_flip_horizontal fun(image: Image) Flip image horizontally
---@field image_rotate fun(image: Image, degrees: integer) Rotate image by input angle in degrees (-359 to 359)
---@field image_rotate_cw fun(image: Image) Rotate image clockwise 90deg
---@field image_rotate_ccw fun(image: Image) Rotate image counter-clockwise 90deg
---@field image_color_tint fun(image: Image, color: Color) Modify image color: tint
---@field image_color_invert fun(image: Image) Modify image color: invert
---@field image_color_grayscale fun(image: Image) Modify image color: grayscale
---@field image_color_contrast fun(image: Image, contrast: number) Modify image color: contrast (-100 to 100)
---@field image_color_brightness fun(image: Image, brightness: integer) Modify image color: brightness (-255 to 255)
---@field image_color_replace fun(image: Image, color: Color, replace: Color) Modify image color: replace color
---
--- Textures: image color functions
---
---@field load_image_colors fun(image: Image): Color[] Load color data from image as a Color array (RGBA - 32bit)
---@field load_image_palette fun(image: Image, maxPaletteSize: integer, colorCount: integer[]): Color[] Load colors palette from image as a Color array (RGBA - 32bit)
---@field unload_image_colors fun(colors: Color[]) Unload color data loaded with LoadImageColors()
---@field unload_image_palette fun(colors: Color[]) Unload colors palette loaded with LoadImagePalette()
---@field get_image_alpha_border fun(image: Image, threshold: number): Rectangle Get image alpha border rectangle
---@field get_image_color fun(image: Image, x: integer, y: integer): Color Get image pixel color at (x, y) position
---
--- Textures: image drawing functions
---
---@field image_clear_background fun(dst: Image, color: Color) Clear image background with given color
---@field image_draw_pixel fun(dst: Image, posX: integer, posY: integer, color: Color) Draw pixel within an image
---@field image_draw_pixel_v fun(dst: Image, position: Vector2, color: Color) Draw pixel within an image (Vector version)
---@field image_draw_line fun(dst: Image, startPosX: integer, startPosY: integer, endPosX: integer, endPosY: integer, color: Color) Draw line within an image
---@field image_draw_line_v fun(dst: Image, start: Vector2, endPos: Vector2, color: Color) Draw line within an image (Vector version)
---@field image_draw_line_ex fun(dst: Image, start: Vector2, endPos: Vector2, thick: integer, color: Color) Draw a line defining thickness within an image
---@field image_draw_circle fun(dst: Image, centerX: integer, centerY: integer, radius: integer, color: Color) Draw a filled circle within an image
---@field image_draw_circle_v fun(dst: Image, center: Vector2, radius: integer, color: Color) Draw a filled circle within an image (Vector version)
---@field image_draw_circle_lines fun(dst: Image, centerX: integer, centerY: integer, radius: integer, color: Color) Draw circle outline within an image
---@field image_draw_circle_lines_v fun(dst: Image, center: Vector2, radius: integer, color: Color) Draw circle outline within an image (Vector version)
---@field image_draw_rectangle fun(dst: Image, posX: integer, posY: integer, width: integer, height: integer, color: Color) Draw rectangle within an image
---@field image_draw_rectangle_v fun(dst: Image, position: Vector2, size: Vector2, color: Color) Draw rectangle within an image (Vector version)
---@field image_draw_rectangle_rec fun(dst: Image, rec: Rectangle, color: Color) Draw rectangle within an image
---@field image_draw_rectangle_lines fun(dst: Image, rec: Rectangle, thick: integer, color: Color) Draw rectangle lines within an image
---@field image_draw_triangle fun(dst: Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) Draw triangle within an image
---@field image_draw_triangle_ex fun(dst: Image, v1: Vector2, v2: Vector2, v3: Vector2, c1: Color, c2: Color, c3: Color) Draw triangle with interpolated colors within an image
---@field image_draw_triangle_lines fun(dst: Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) Draw triangle outline within an image
---@field image_draw_triangle_fan fun(dst: Image, points: Vector2[], pointCount: integer, color: Color) Draw a triangle fan defined by points within an image (first vertex is the center)
---@field image_draw_triangle_strip fun(dst: Image, points: Vector2[], pointCount: integer, color: Color) Draw a triangle strip defined by points within an image
---@field image_draw fun(dst: Image, src: Image, srcRec: Rectangle, dstRec: Rectangle, tint: Color) Draw a source image within a destination image (tint applied to source)
---@field image_draw_text fun(dst: Image, text: string, posX: integer, posY: integer, fontSize: integer, color: Color) Draw text (using default font) within an image (destination)
---@field image_draw_text_ex fun(dst: Image, font: Font, text: string, position: Vector2, fontSize: number, spacing: number, tint: Color) Draw text (custom sprite font) within an image (destination)
---
--- Textures: loading functions
---
---@field load_texture fun(fileName: string): Texture2D Load texture from file into GPU memory (VRAM)
---@field load_texture_from_image fun(image: Image): Texture2D Load texture from image data
---@field load_texture_cubemap fun(image: Image, layout: integer): TextureCubemap Load cubemap from image, multiple image cubemap layouts supported
---@field load_render_texture fun(width: integer, height: integer): RenderTexture2D Load texture for rendering (framebuffer)
---@field is_texture_valid fun(texture: Texture2D): boolean Check if a texture is valid (loaded in GPU)
---@field unload_texture fun(texture: Texture2D) Unload texture from GPU memory (VRAM)
---@field is_render_texture_valid fun(target: RenderTexture2D): boolean Check if a render texture is valid (loaded in GPU)
---@field unload_render_texture fun(target: RenderTexture2D) Unload render texture from GPU memory (VRAM)
---@field update_texture fun(texture: Texture2D, pixels: lightuserdata) Update GPU texture with new data
---@field update_texture_rec fun(texture: Texture2D, rec: Rectangle, pixels: lightuserdata) Update GPU texture rectangle with new data
---@field gen_texture_mipmaps fun(texture: Texture2D) Generate GPU mipmaps for a texture
---@field set_texture_filter fun(texture: Texture2D, filter: integer) Set texture scaling filter mode
---@field set_texture_wrap fun(texture: Texture2D, wrap: integer) Set texture wrapping mode
---
--- Textures: drawing functions
---
---@field draw_texture fun(texture: Texture2D, posX: integer, posY: integer, tint: Color) Draw a Texture2D
---@field draw_texture_v fun(texture: Texture2D, position: Vector2, tint: Color) Draw a Texture2D with position defined as Vector2
---@field draw_texture_ex fun(texture: Texture2D, position: Vector2, rotation: number, scale: number, tint: Color) Draw a Texture2D with extended parameters
---@field draw_texture_rec fun(texture: Texture2D, source: Rectangle, position: Vector2, tint: Color) Draw a part of a texture defined by a rectangle
---@field draw_texture_pro fun(texture: Texture2D, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: number, tint: Color) Draw a part of a texture defined by a rectangle with 'pro' parameters
---@field draw_texture_npatch fun(texture: Texture2D, nPatchInfo: NPatchInfo, dest: Rectangle, origin: Vector2, rotation: number, tint: Color) Draws a texture (or part of it) that stretches or shrinks nicely
---
--- Color/pixel functions
---
---@field color_is_equal fun(col1: Color, col2: Color): boolean Check if two colors are equal
---@field fade fun(color: Color, alpha: number): Color Get color with alpha applied, alpha goes from 0.0f to 1.0f
---@field color_to_int fun(color: Color): integer Get hexadecimal value for a Color (0xRRGGBBAA)
---@field color_normalize fun(color: Color): Vector4 Get Color normalized as float [0..1]
---@field color_from_normalized fun(normalized: Vector4): Color Get Color from normalized values [0..1]
---@field color_to_hsv fun(color: Color): Vector3 Get HSV values for a Color, hue [0..360], saturation/value [0..1]
---@field color_from_hsv fun(hue: number, saturation: number, value: number): Color Get a Color from HSV values, hue [0..360], saturation/value [0..1]
---@field color_tint fun(color: Color, tint: Color): Color Get color multiplied with another color
---@field color_brightness fun(color: Color, factor: number): Color Get color with brightness correction, brightness factor goes from -1.0f to 1.0f
---@field color_contrast fun(color: Color, contrast: number): Color Get color with contrast correction, contrast values between -1.0f and 1.0f
---@field color_alpha fun(color: Color, alpha: number): Color Get color with alpha applied, alpha goes from 0.0f to 1.0f
---@field color_alpha_blend fun(dst: Color, src: Color, tint: Color): Color Get src alpha-blended into dst color with tint
---@field color_lerp fun(color1: Color, color2: Color, factor: number): Color Get color lerp interpolation between two colors, factor [0.0f..1.0f]
---@field get_color fun(hexValue: integer): Color Get Color structure from hexadecimal value
---@field get_pixel_color fun(srcPtr: lightuserdata, format: integer): Color Get Color from a source pixel pointer of certain format
---@field set_pixel_color fun(dstPtr: lightuserdata, color: Color, format: integer) Set color formatted into destination pixel pointer
---@field get_pixel_data_size fun(width: integer, height: integer, format: integer): integer Get pixel data size in bytes for certain format
---
--- Text: font loading functions
---
---@field get_font_default fun(): Font Get the default Font
---@field load_font fun(fileName: string): Font Load font from file into GPU memory (VRAM)
---@field load_font_ex fun(fileName: string, fontSize: integer, codepoints: integer[]|nil, codepointCount: integer): Font Load font from file with extended parameters, use NULL for codepoints and 0 for codepointCount to load the default character set, font size is provided in pixels height
---@field load_font_from_image fun(image: Image, key: Color, firstChar: integer): Font Load font from Image (XNA style)
---@field load_font_from_memory fun(fileType: string, fileData: lightuserdata, dataSize: integer, fontSize: integer, codepoints: integer[]|nil, codepointCount: integer): Font Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
---@field is_font_valid fun(font: Font): boolean Check if a font is valid (font data loaded, WARNING: GPU texture not checked)
---@field load_font_data fun(fileData: lightuserdata, dataSize: integer, fontSize: integer, codepoints: integer[]|nil, codepointCount: integer, type: integer, glyphCount: integer[]): GlyphInfo[] Load font data for further use
---@field gen_image_font_atlas fun(glyphs: GlyphInfo[], glyphRecs: Rectangle[][], glyphCount: integer, fontSize: integer, padding: integer, packMethod: integer): Image Generate image font atlas using chars info
---@field unload_font_data fun(glyphs: GlyphInfo[], glyphCount: integer) Unload font chars info data (RAM)
---@field unload_font fun(font: Font) Unload font from GPU memory (VRAM)
---@field export_font_as_code fun(font: Font, fileName: string): boolean Export font as code file, returns true on success
---
--- Text: drawing functions
---
---@field draw_fps fun(posX: integer, posY: integer) Draw current FPS
---@field draw_text fun(text: string, posX: integer, posY: integer, fontSize: integer, color: Color) Draw text (using default font)
---@field draw_text_ex fun(font: Font, text: string, position: Vector2, fontSize: number, spacing: number, tint: Color) Draw text using font and additional parameters
---@field draw_text_pro fun(font: Font, text: string, position: Vector2, origin: Vector2, rotation: number, fontSize: number, spacing: number, tint: Color) Draw text using Font and pro parameters (rotation)
---@field draw_text_codepoint fun(font: Font, codepoint: integer, position: Vector2, fontSize: number, tint: Color) Draw one character (codepoint)
---@field draw_text_codepoints fun(font: Font, codepoints: integer[], codepointCount: integer, position: Vector2, fontSize: number, spacing: number, tint: Color) Draw multiple character (codepoint)
---@field set_text_line_spacing fun(spacing: integer) Set vertical line spacing when drawing with line-breaks
---@field measure_text fun(text: string, fontSize: integer): integer Measure string width for default font
---@field measure_text_ex fun(font: Font, text: string, fontSize: number, spacing: number): Vector2 Measure string size for Font
---@field measure_text_codepoints fun(font: Font, codepoints: integer[], length: integer, fontSize: number, spacing: number): Vector2 Measure codepoints string size for Font
---@field get_glyph_index fun(font: Font, codepoint: integer): integer Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
---@field get_glyph_info fun(font: Font, codepoint: integer): GlyphInfo Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
---@field get_glyph_atlas_rec fun(font: Font, codepoint: integer): Rectangle Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
---
--- Text: codepoints management functions
---
---@field load_utf8 fun(codepoints: integer[], length: integer): string Load UTF-8 text encoded from codepoints array
---@field unload_utf8 fun(text: string) Unload UTF-8 text encoded from codepoints array
---@field load_codepoints fun(text: string, count: integer[]): integer[] Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
---@field unload_codepoints fun(codepoints: integer[]) Unload codepoints data from memory
---@field get_codepoint_count fun(text: string): integer Get total number of codepoints in a UTF-8 encoded string
---@field get_codepoint fun(text: string, codepointSize: integer[]): integer Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
---@field get_codepoint_next fun(text: string, codepointSize: integer[]): integer Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
---@field get_codepoint_previous fun(text: string, codepointSize: integer[]): integer Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
---@field codepoint_to_utf8 fun(codepoint: integer, utf8Size: integer[]): string Encode one codepoint into UTF-8 byte array (array length returned as parameter)
---
--- Text: string functions
---
---@field text_copy fun(dst: string, src: string): integer Copy one string to another, returns bytes copied
---@field text_is_equal fun(text1: string, text2: string): boolean Check if two text string are equal
---@field text_length fun(text: string): integer Get text length, checks for '\0' ending
---@field text_format fun(text: string, ...: any): string Text formatting with variables (sprintf() style)
---@field text_subtext fun(text: string, position: integer, length: integer): string Get a piece of a text string
---@field text_replace fun(text: string, replace: string, by: string): string Replace text string (WARNING: memory must be freed!)
---@field text_insert fun(text: string, insert: string, position: integer): string Insert text in a position (WARNING: memory must be freed!)
---@field text_join fun(textList: string[], count: integer, delimiter: string): string Join text strings with delimiter
---@field text_split fun(text: string, delimiter: integer, count: integer[]): string[] Split text into multiple strings
---@field text_append fun(text: string, append: string, position: integer[]) Append text at specific position and move cursor!
---@field text_find_index fun(text: string, find: string): integer Find first text occurrence within a string
---@field text_to_upper fun(text: string): string Get upper case version of provided string
---@field text_to_lower fun(text: string): string Get lower case version of provided string
---@field text_to_pascal fun(text: string): string Get Pascal case notation version of provided string
---@field text_to_snake fun(text: string): string Get Snake case notation version of provided string
---@field text_to_camel fun(text: string): string Get Camel case notation version of provided string
---@field text_to_integer fun(text: string): integer Get integer value from text (negative values not supported)
---@field text_to_float fun(text: string): number Get float value from text (negative values not supported)
---@field load_text_lines fun(text: string, count: integer[]): string[] Load text lines from text string
---@field unload_text_lines fun(text: string[], lineCount: integer) Unload text lines
---@field text_remove_spaces fun(text: string): string Remove spaces from text string
---@field get_text_between fun(text: string, beginStr: string, endStr: string): string Get text between two delimiter strings
---@field text_replace_between fun(text: string, beginStr: string, endStr: string, replacement: string): string Replace text between two delimiter strings
---
--- Models: 3D basic drawing functions
---
---@field draw_line_3d fun(startPos: Vector3, endPos: Vector3, color: Color) Draw a line in 3D world space
---@field draw_point_3d fun(position: Vector3, color: Color) Draw a point in 3D space, actually a small line
---@field draw_circle_3d fun(center: Vector3, radius: number, rotationAxis: Vector3, rotationAngle: number, color: Color) Draw a circle in 3D world space
---@field draw_triangle_3d fun(v1: Vector3, v2: Vector3, v3: Vector3, color: Color) Draw a color-filled triangle (vertex in counter-clockwise order!)
---@field draw_triangle_strip_3d fun(points: Vector3[], pointCount: integer, color: Color) Draw a triangle strip defined by points
---@field draw_cube fun(position: Vector3, width: number, height: number, length: number, color: Color) Draw cube
---@field draw_cube_v fun(position: Vector3, size: Vector3, color: Color) Draw cube (Vector version)
---@field draw_cube_wires fun(position: Vector3, width: number, height: number, length: number, color: Color) Draw cube wires
---@field draw_cube_wires_v fun(position: Vector3, size: Vector3, color: Color) Draw cube wires (Vector version)
---@field draw_sphere fun(centerPos: Vector3, radius: number, color: Color) Draw sphere
---@field draw_sphere_ex fun(centerPos: Vector3, radius: number, rings: integer, slices: integer, color: Color) Draw sphere with extended parameters
---@field draw_sphere_wires fun(centerPos: Vector3, radius: number, rings: integer, slices: integer, color: Color) Draw sphere wires
---@field draw_cylinder fun(position: Vector3, radiusTop: number, radiusBottom: number, height: number, slices: integer, color: Color) Draw a cylinder/cone
---@field draw_cylinder_ex fun(startPos: Vector3, endPos: Vector3, startRadius: number, endRadius: number, sides: integer, color: Color) Draw a cylinder with base at startPos and top at endPos
---@field draw_cylinder_wires fun(position: Vector3, radiusTop: number, radiusBottom: number, height: number, slices: integer, color: Color) Draw a cylinder/cone wires
---@field draw_cylinder_wires_ex fun(startPos: Vector3, endPos: Vector3, startRadius: number, endRadius: number, sides: integer, color: Color) Draw a cylinder wires with base at startPos and top at endPos
---@field draw_capsule fun(startPos: Vector3, endPos: Vector3, radius: number, slices: integer, rings: integer, color: Color) Draw a capsule with the center of its sphere caps at startPos and endPos
---@field draw_capsule_wires fun(startPos: Vector3, endPos: Vector3, radius: number, slices: integer, rings: integer, color: Color) Draw capsule wireframe with the center of its sphere caps at startPos and endPos
---@field draw_plane fun(centerPos: Vector3, size: Vector2, color: Color) Draw a plane XZ
---@field draw_ray fun(ray: Ray, color: Color) Draw a ray line
---@field draw_grid fun(slices: integer, spacing: number) Draw a grid (centered at (0, 0, 0))
---
--- Models: loading functions
---
---@field load_model fun(fileName: string): Model Load model from files (meshes and materials)
---@field load_model_from_mesh fun(mesh: Mesh): Model Load model from generated mesh (default material)
---@field is_model_valid fun(model: Model): boolean Check if a model is valid (loaded in GPU, VAO/VBOs)
---@field unload_model fun(model: Model) Unload model (including meshes) from memory (RAM and/or VRAM)
---@field get_model_bounding_box fun(model: Model): BoundingBox Compute model bounding box limits (considers all meshes)
---
--- Models: drawing functions
---
---@field draw_model fun(model: Model, position: Vector3, scale: number, tint: Color) Draw a model (with texture if set)
---@field draw_model_ex fun(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: number, scale: Vector3, tint: Color) Draw a model with extended parameters
---@field draw_model_wires fun(model: Model, position: Vector3, scale: number, tint: Color) Draw a model wires (with texture if set)
---@field draw_model_wires_ex fun(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: number, scale: Vector3, tint: Color) Draw a model wires (with texture if set) with extended parameters
---@field draw_model_points fun(model: Model, position: Vector3, scale: number, tint: Color) Draw a model as points
---@field draw_model_points_ex fun(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: number, scale: Vector3, tint: Color) Draw a model as points with extended parameters
---@field draw_bounding_box fun(box: BoundingBox, color: Color) Draw bounding box (wires)
---@field draw_billboard fun(camera: Camera3D, texture: Texture2D, position: Vector3, scale: number, tint: Color) Draw a billboard texture
---@field draw_billboard_rec fun(camera: Camera3D, texture: Texture2D, source: Rectangle, position: Vector3, size: Vector2, tint: Color) Draw a billboard texture defined by source
---@field draw_billboard_pro fun(camera: Camera3D, texture: Texture2D, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: number, tint: Color) Draw a billboard texture defined by source and rotation
---
--- Models: mesh functions
---
---@field upload_mesh fun(mesh: Mesh, dynamic: boolean) Upload mesh vertex data in GPU and provide VAO/VBO ids
---@field update_mesh_buffer fun(mesh: Mesh, index: integer, data: lightuserdata, dataSize: integer, offset: integer) Update mesh vertex data in GPU for a specific buffer index
---@field unload_mesh fun(mesh: Mesh) Unload mesh data from CPU and GPU
---@field draw_mesh fun(mesh: Mesh, material: Material, transform: Matrix) Draw a 3d mesh with material and transform
---@field draw_mesh_instanced fun(mesh: Mesh, material: Material, transforms: Matrix[], instances: integer) Draw multiple mesh instances with material and different transforms
---@field get_mesh_bounding_box fun(mesh: Mesh): BoundingBox Compute mesh bounding box limits
---@field gen_mesh_tangents fun(mesh: Mesh) Compute mesh tangents
---@field export_mesh fun(mesh: Mesh, fileName: string): boolean Export mesh data to file, returns true on success
---@field export_mesh_as_code fun(mesh: Mesh, fileName: string): boolean Export mesh as code file (.h) defining multiple arrays of vertex attributes
---
--- Models: mesh generation functions
---
---@field gen_mesh_poly fun(sides: integer, radius: number): Mesh Generate polygonal mesh
---@field gen_mesh_plane fun(width: number, length: number, resX: integer, resZ: integer): Mesh Generate plane mesh (with subdivisions)
---@field gen_mesh_cube fun(width: number, height: number, length: number): Mesh Generate cuboid mesh
---@field gen_mesh_sphere fun(radius: number, rings: integer, slices: integer): Mesh Generate sphere mesh (standard sphere)
---@field gen_mesh_hemi_sphere fun(radius: number, rings: integer, slices: integer): Mesh Generate half-sphere mesh (no bottom cap)
---@field gen_mesh_cylinder fun(radius: number, height: number, slices: integer): Mesh Generate cylinder mesh
---@field gen_mesh_cone fun(radius: number, height: number, slices: integer): Mesh Generate cone/pyramid mesh
---@field gen_mesh_torus fun(radius: number, size: number, radSeg: integer, sides: integer): Mesh Generate torus mesh
---@field gen_mesh_knot fun(radius: number, size: number, radSeg: integer, sides: integer): Mesh Generate trefoil knot mesh
---@field gen_mesh_heightmap fun(heightmap: Image, size: Vector3): Mesh Generate heightmap mesh from image data
---@field gen_mesh_cubicmap fun(cubicmap: Image, cubeSize: Vector3): Mesh Generate cubes-based map mesh from image data
---
--- Models: material functions
---
---@field load_materials fun(fileName: string, materialCount: integer[]): Material[] Load materials from model file
---@field load_material_default fun(): Material Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
---@field is_material_valid fun(material: Material): boolean Check if a material is valid (shader assigned, map textures loaded in GPU)
---@field unload_material fun(material: Material) Unload material from GPU memory (VRAM)
---@field set_material_texture fun(material: Material, mapType: integer, texture: Texture2D) Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
---@field set_model_mesh_material fun(model: Model, meshId: integer, materialId: integer) Set material for a mesh
---
--- Models: animation functions
---
---@field load_model_animations fun(fileName: string, animCount: integer[]): ModelAnimation[] Load model animations from file
---@field update_model_animation fun(model: Model, anim: ModelAnimation, frame: number) Update model animation pose (vertex buffers and bone matrices)
---@field update_model_animation_ex fun(model: Model, animA: ModelAnimation, frameA: number, animB: ModelAnimation, frameB: number, blend: number) Update model animation pose with blending between two animations
---@field unload_model_animations fun(animations: ModelAnimation[], animCount: integer) Unload animation array data
---@field is_model_animation_valid fun(model: Model, anim: ModelAnimation): boolean Check model animation skeleton match
---
--- Models: collision functions
---
---@field check_collision_spheres fun(center1: Vector3, radius1: number, center2: Vector3, radius2: number): boolean Check collision between two spheres
---@field check_collision_boxes fun(box1: BoundingBox, box2: BoundingBox): boolean Check collision between two bounding boxes
---@field check_collision_box_sphere fun(box: BoundingBox, center: Vector3, radius: number): boolean Check collision between box and sphere
---@field get_ray_collision_sphere fun(ray: Ray, center: Vector3, radius: number): RayCollision Get collision info between ray and sphere
---@field get_ray_collision_box fun(ray: Ray, box: BoundingBox): RayCollision Get collision info between ray and box
---@field get_ray_collision_mesh fun(ray: Ray, mesh: Mesh, transform: Matrix): RayCollision Get collision info between ray and mesh
---@field get_ray_collision_triangle fun(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3): RayCollision Get collision info between ray and triangle
---@field get_ray_collision_quad fun(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3, p4: Vector3): RayCollision Get collision info between ray and quad
---
--- Audio: device management functions
---
---@field init_audio_device fun() Initialize audio device and context
---@field close_audio_device fun() Close the audio device and context
---@field is_audio_device_ready fun(): boolean Check if audio device has been initialized successfully
---@field set_master_volume fun(volume: number) Set master volume (listener)
---@field get_master_volume fun(): number Get master volume (listener)
---
--- Audio: wave/sound loading functions
---
---@field load_wave fun(fileName: string): Wave Load wave data from file
---@field load_wave_from_memory fun(fileType: string, fileData: lightuserdata, dataSize: integer): Wave Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
---@field is_wave_valid fun(wave: Wave): boolean Checks if wave data is valid (data loaded and parameters)
---@field load_sound fun(fileName: string): Sound Load sound from file
---@field load_sound_from_wave fun(wave: Wave): Sound Load sound from wave data
---@field load_sound_alias fun(source: Sound): Sound Create a new sound that shares the same sample data as the source sound, does not own the sound data
---@field is_sound_valid fun(sound: Sound): boolean Checks if a sound is valid (data loaded and buffers initialized)
---@field update_sound fun(sound: Sound, data: lightuserdata, sampleCount: integer) Update sound buffer with new data
---@field unload_wave fun(wave: Wave) Unload wave data
---@field unload_sound fun(sound: Sound) Unload sound
---@field unload_sound_alias fun(alias: Sound) Unload a sound alias (does not deallocate sample data)
---@field export_wave fun(wave: Wave, fileName: string): boolean Export wave data to file, returns true on success
---@field export_wave_as_code fun(wave: Wave, fileName: string): boolean Export wave sample data to code (.h), returns true on success
---
--- Audio: wave/sound management functions
---
---@field play_sound fun(sound: Sound) Play a sound
---@field stop_sound fun(sound: Sound) Stop playing a sound
---@field pause_sound fun(sound: Sound) Pause a sound
---@field resume_sound fun(sound: Sound) Resume a paused sound
---@field is_sound_playing fun(sound: Sound): boolean Check if a sound is currently playing
---@field set_sound_volume fun(sound: Sound, volume: number) Set volume for a sound (1.0 is max level)
---@field set_sound_pitch fun(sound: Sound, pitch: number) Set pitch for a sound (1.0 is base level)
---@field set_sound_pan fun(sound: Sound, pan: number) Set pan for a sound (0.5 is center)
---@field wave_copy fun(wave: Wave): Wave Copy a wave to a new wave
---@field wave_crop fun(wave: Wave, initFrame: integer, finalFrame: integer) Crop a wave to defined frames range
---@field wave_format fun(wave: Wave, sampleRate: integer, sampleSize: integer, channels: integer) Convert wave data to desired format
---@field load_wave_samples fun(wave: Wave): number[] Load samples data from wave as a 32bit float data array
---@field unload_wave_samples fun(samples: number[]) Unload samples data loaded with LoadWaveSamples()
---
--- Audio: music stream functions
---
---@field load_music_stream fun(fileName: string): Music Load music stream from file
---@field load_music_stream_from_memory fun(fileType: string, data: lightuserdata, dataSize: integer): Music Load music stream from data
---@field is_music_valid fun(music: Music): boolean Checks if a music stream is valid (context and buffers initialized)
---@field unload_music_stream fun(music: Music) Unload music stream
---@field play_music_stream fun(music: Music) Start music playing
---@field is_music_stream_playing fun(music: Music): boolean Check if music is playing
---@field update_music_stream fun(music: Music) Updates buffers for music streaming
---@field stop_music_stream fun(music: Music) Stop music playing
---@field pause_music_stream fun(music: Music) Pause music playing
---@field resume_music_stream fun(music: Music) Resume playing paused music
---@field seek_music_stream fun(music: Music, position: number) Seek music to a position (in seconds)
---@field set_music_volume fun(music: Music, volume: number) Set volume for music (1.0 is max level)
---@field set_music_pitch fun(music: Music, pitch: number) Set pitch for a music (1.0 is base level)
---@field set_music_pan fun(music: Music, pan: number) Set pan for a music (0.5 is center)
---@field get_music_time_length fun(music: Music): number Get music time length (in seconds)
---@field get_music_time_played fun(music: Music): number Get current music time played (in seconds)
---
--- Audio: stream functions
---
---@field load_audio_stream fun(sampleRate: integer, sampleSize: integer, channels: integer): AudioStream Load audio stream (to stream raw audio pcm data)
---@field is_audio_stream_valid fun(stream: AudioStream): boolean Checks if an audio stream is valid (buffers initialized)
---@field unload_audio_stream fun(stream: AudioStream) Unload audio stream and free memory
---@field update_audio_stream fun(stream: AudioStream, data: lightuserdata, frameCount: integer) Update audio stream buffers with data
---@field is_audio_stream_processed fun(stream: AudioStream): boolean Check if any audio stream buffers requires refill
---@field play_audio_stream fun(stream: AudioStream) Play audio stream
---@field pause_audio_stream fun(stream: AudioStream) Pause audio stream
---@field resume_audio_stream fun(stream: AudioStream) Resume audio stream
---@field is_audio_stream_playing fun(stream: AudioStream): boolean Check if audio stream is playing
---@field stop_audio_stream fun(stream: AudioStream) Stop audio stream
---@field set_audio_stream_volume fun(stream: AudioStream, volume: number) Set volume for audio stream (1.0 is max level)
---@field set_audio_stream_pitch fun(stream: AudioStream, pitch: number) Set pitch for audio stream (1.0 is base level)
---@field set_audio_stream_pan fun(stream: AudioStream, pan: number) Set pan for audio stream (0.5 is centered)
---@field set_audio_stream_buffer_size_default fun(size: integer) Default size for new audio streams
---@field set_audio_stream_callback fun(stream: AudioStream, callback: function) Audio thread callback to request new data
---@field attach_audio_stream_processor fun(stream: AudioStream, processor: function) Attach audio stream processor to stream, receives the samples as 'float'
---@field detach_audio_stream_processor fun(stream: AudioStream, processor: function) Detach audio stream processor from stream
---@field attach_audio_mixed_processor fun(processor: function) Attach audio stream processor to the entire audio pipeline, receives the samples as 'float'
---@field detach_audio_mixed_processor fun(processor: function) Detach audio stream processor from the entire audio pipeline
---
--- Color constants
---
---@field LIGHTGRAY Color Light gray (200, 200, 200, 255)
---@field GRAY Color Gray (130, 130, 130, 255)
---@field DARKGRAY Color Dark gray (80, 80, 80, 255)
---@field YELLOW Color Yellow (253, 249, 0, 255)
---@field GOLD Color Gold (255, 203, 0, 255)
---@field ORANGE Color Orange (255, 161, 0, 255)
---@field PINK Color Pink (255, 109, 194, 255)
---@field RED Color Red (230, 41, 55, 255)
---@field MAROON Color Maroon (190, 33, 55, 255)
---@field GREEN Color Green (0, 228, 48, 255)
---@field LIME Color Lime (0, 158, 47, 255)
---@field DARKGREEN Color Dark green (0, 117, 44, 255)
---@field SKYBLUE Color Sky blue (102, 191, 255, 255)
---@field BLUE Color Blue (0, 121, 241, 255)
---@field DARKBLUE Color Dark blue (0, 82, 172, 255)
---@field PURPLE Color Purple (200, 122, 255, 255)
---@field VIOLET Color Violet (135, 60, 190, 255)
---@field DARKPURPLE Color Dark purple (112, 31, 126, 255)
---@field BEIGE Color Beige (211, 176, 131, 255)
---@field BROWN Color Brown (127, 106, 79, 255)
---@field DARKBROWN Color Dark brown (76, 63, 47, 255)
---@field WHITE Color White (255, 255, 255, 255)
---@field BLACK Color Black (0, 0, 0, 255)
---@field BLANK Color Transparent (0, 0, 0, 0)
---@field MAGENTA Color Magenta (255, 0, 255, 255)
---@field RAYWHITE Color Ray white (245, 245, 245, 255)
---

---
--- FFI library handle
---
---@field lib any Raw FFI library handle for raylib
local rl = {}

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

-- Load raylib.h
local raylib_path = findHeader("raylib.h")
if not raylib_path then
	error("raylib.h not found. Please install raylib development headers.")
end

local raylib_h = preprocessHeader(raylib_path)
ffi.cdef(raylib_h)

---@type any
rl.lib = ffi.load("raylib")

-- ============================================================================
-- COLOR CONSTANTS
-- ============================================================================
rl.LIGHTGRAY = ffi.new("Color", 200, 200, 200, 255)
rl.GRAY = ffi.new("Color", 130, 130, 130, 255)
rl.DARKGRAY = ffi.new("Color", 80, 80, 80, 255)
rl.YELLOW = ffi.new("Color", 253, 249, 0, 255)
rl.GOLD = ffi.new("Color", 255, 203, 0, 255)
rl.ORANGE = ffi.new("Color", 255, 161, 0, 255)
rl.PINK = ffi.new("Color", 255, 109, 194, 255)
rl.RED = ffi.new("Color", 230, 41, 55, 255)
rl.MAROON = ffi.new("Color", 190, 33, 55, 255)
rl.GREEN = ffi.new("Color", 0, 228, 48, 255)
rl.LIME = ffi.new("Color", 0, 158, 47, 255)
rl.DARKGREEN = ffi.new("Color", 0, 117, 44, 255)
rl.SKYBLUE = ffi.new("Color", 102, 191, 255, 255)
rl.BLUE = ffi.new("Color", 0, 121, 241, 255)
rl.DARKBLUE = ffi.new("Color", 0, 82, 172, 255)
rl.PURPLE = ffi.new("Color", 200, 122, 255, 255)
rl.VIOLET = ffi.new("Color", 135, 60, 190, 255)
rl.DARKPURPLE = ffi.new("Color", 112, 31, 126, 255)
rl.BEIGE = ffi.new("Color", 211, 176, 131, 255)
rl.BROWN = ffi.new("Color", 127, 106, 79, 255)
rl.DARKBROWN = ffi.new("Color", 76, 63, 47, 255)
rl.WHITE = ffi.new("Color", 255, 255, 255, 255)
rl.BLACK = ffi.new("Color", 0, 0, 0, 255)
rl.BLANK = ffi.new("Color", 0, 0, 0, 0)
rl.MAGENTA = ffi.new("Color", 255, 0, 255, 255)
rl.RAYWHITE = ffi.new("Color", 245, 245, 245, 255)

-- ============================================================================
-- TYPE DEFINITIONS (for LSP)
-- ============================================================================

---@class Color
---@field r integer
---@field g integer
---@field b integer
---@field a integer

---@class Rectangle
---@field x number
---@field y number
---@field width number
---@field height number

---@class Image
---@field data lightuserdata Image raw data
---@field width integer Image base width
---@field height integer Image base height
---@field mipmaps integer Mipmap levels, 1 by default
---@field format integer Data format (PixelFormat type)

---@class Texture
---@field id integer
---@field width integer
---@field height integer
---@field mipmaps integer
---@field format integer

---@alias Texture2D Texture
---@alias TextureCubemap Texture

---@class RenderTexture
---@field id integer
---@field texture Texture
---@field depth Texture

---@alias RenderTexture2D RenderTexture

---@class NPatchInfo
---@field source Rectangle
---@field left integer
---@field top integer
---@field right integer
---@field bottom integer
---@field layout integer

---@class GlyphInfo
---@field value integer
---@field offsetX integer
---@field offsetY integer
---@field advanceX integer
---@field image Image

---@class Font
---@field baseSize integer Base size (default chars height)
---@field glyphCount integer Number of glyph characters
---@field glyphPadding integer Padding around the glyph characters
---@field texture Texture2D Texture atlas containing the glyphs
---@field recs Rectangle[] Rectangles in texture for the glyphs
---@field glyphs GlyphInfo[] Glyphs info data

---@class Camera3D
---@field position Vector3
---@field target Vector3
---@field up Vector3
---@field fovy number
---@field projection integer

---@alias Camera Camera3D

---@class Camera2D
---@field offset Vector2
---@field target Vector2
---@field rotation number
---@field zoom number

---@class Mesh
---@field vertexCount integer Number of vertices stored in arrays
---@field triangleCount integer Number of triangles stored (indexed or not)
---@field vertices number[] Vertices position (XYZ - 3 components per vertex) (shader-location = 0)
---@field texcoords number[] Vertices texture coordinates (UV - 2 components per vertex) (shader-location = 1)
---@field texcoords2 number[] Vertices texture second coordinates (UV - 2 components per vertex) (shader-location = 5)
---@field normals number[] Vertices normals (XYZ - 3 components per vertex) (shader-location = 2)
---@field tangents number[] Vertices tangents (XYZW - 4 components per vertex) (shader-location = 4)
---@field colors integer[] Vertices colors (RGBA - 4 components per vertex) (shader-location = 3)
---@field indices integer[] Vertices indices (in case vertex data comes indexed)
---@field animVertices number[] Animated vertex positions (after bones transformations)
---@field animNormals number[] Animated normals (after bones transformations)
---@field boneIds integer[] Vertex bone ids, max 255 bone ids, up to 4 per vertex
---@field boneWeights number[] Vertex bone weight, up to 4 per vertex
---@field boneMatrices Matrix[] Bones animated transformation matrices
---@field boneCount integer Number of bones
---@field vaoId integer OpenGL Vertex Array Object id
---@field vboId integer[] OpenGL Vertex Buffer Objects id (7 potential types)

---@class Shader
---@field id integer Shader program id
---@field locs integer[] Shader locations array (RL_MAX_SHADER_LOCATIONS)

---@class MaterialMap
---@field texture Texture2D
---@field color Color
---@field value number

---@class Material
---@field shader Shader
---@field maps MaterialMap[]
---@field params number[] | number Material generic parameters (if required)

---@class Transform
---@field translation Vector3
---@field rotation Vector4
---@field scale Vector3

---@class BoneInfo
---@field name string
---@field parent integer

---@class Model
---@field transform Matrix
---@field meshCount integer
---@field materialCount integer
---@field meshes Mesh[]
---@field materials Material[]
---@field meshMaterial integer[]
---@field boneCount integer
---@field bones BoneInfo[]
---@field bindPose Transform[]

---@class ModelAnimation
---@field boneCount integer
---@field frameCount integer
---@field bones BoneInfo[]
---@field framePoses Transform[][]
---@field name string

---@class Ray
---@field position Vector3
---@field direction Vector3

---@class RayCollision
---@field hit boolean
---@field distance number
---@field point Vector3
---@field normal Vector3

---@class BoundingBox
---@field min Vector3
---@field max Vector3

---@class Wave
---@field frameCount integer
---@field sampleRate integer
---@field sampleSize integer
---@field channels integer
---@field data lightuserdata

---@class AudioStream
---@field buffer lightuserdata
---@field processor lightuserdata
---@field sampleRate integer
---@field sampleSize integer
---@field channels integer

---@class Sound
---@field stream AudioStream
---@field frameCount integer

---@class Music
---@field stream AudioStream
---@field frameCount integer
---@field looping boolean
---@field ctxType integer
---@field ctxData lightuserdata

---@class VrDeviceInfo
---@field hResolution integer
---@field vResolution integer
---@field hScreenSize number
---@field vScreenSize number
---@field eyeToScreenDistance number
---@field lensSeparationDistance number
---@field interpupillaryDistance number
---@field lensDistortionValues number[]
---@field chromaAbCorrection number[]

---@class VrStereoConfig
---@field projection Matrix[]
---@field viewOffset Matrix[]
---@field leftLensCenter number[]
---@field rightLensCenter number[]
---@field leftScreenCenter number[]
---@field rightScreenCenter number[]
---@field scale number[]
---@field scaleIn number[]

---@class FilePathList
---@field capacity integer
---@field count integer
---@field paths string[]

---@class AutomationEvent
---@field frame integer
---@field type integer
---@param params integer[]

---@class AutomationEventList
---@field capacity integer
---@field count integer
---@param events AutomationEvent[]

-- ============================================================================
-- CONSTRUCTOR FUNCTIONS
-- ============================================================================

---Create a Color from RGBA values, hex string, or hex number
---@param r number|string Red value (0-255) or hex string like "#FF0000" or hex number
---@param g? number Green value (0-255)
---@param b? number Blue value (0-255)
---@param a? number Alpha value (0-255, default 255)
---@return Color
function rl.color(r, g, b, a)
	if type(r) == "string" then
		local hex = r:gsub("#", "")
		local num = tonumber(hex, 16)
		if #hex == 6 then
			return rl.lib.GetColor(num * 256 + (a or 255))
		elseif #hex == 8 then
			return rl.lib.GetColor(num)
		else
			error("Invalid hex color string: " .. r)
		end
	elseif type(r) == "number" and g == nil then
		-- r is a hex number
		return rl.lib.GetColor(r)
	else
		return ffi.new("Color", r or 0, g or 0, b or 0, a or 255)
	end
end

---Create a Rectangle
---@param x? number
---@param y? number
---@param width? number
---@param height? number
---@return Rectangle
function rl.rectangle(x, y, width, height)
	return ffi.new("Rectangle", x or 0, y or 0, width or 0, height or 0)
end

---Create a Camera3D
---@param position Vector3
---@param target Vector3
---@param up? Vector3
---@param fovy? number
---@param projection? integer
---@return Camera3D
function rl.camera_3d(position, target, up, fovy, projection)
	return ffi.new("Camera3D", position, target, up or ffi.new("Vector3", 0, 1, 0), fovy or 45, projection or 0)
end

---Create a Camera2D
---@param offset? Vector2
---@param target? Vector2
---@param rotation? number
---@param zoom? number
---@return Camera2D
function rl.camera_2d(offset, target, rotation, zoom)
	return ffi.new("Camera2D", offset or ffi.new("Vector2", 0, 0), target or ffi.new("Vector2", 0, 0), rotation or 0, zoom or 1)
end

---Create a Ray
---@param position Vector3
---@param direction Vector3
---@return Ray
function rl.ray(position, direction)
	return ffi.new("Ray", position, direction)
end

---Create a BoundingBox
---@param min Vector3
---@param max Vector3
---@return BoundingBox
function rl.bounding_box(min, max)
	return ffi.new("BoundingBox", min, max)
end

-- CamelCase aliases for constructors (matching FFI convention)
rl.Color = rl.color
rl.Rectangle = rl.rectangle
rl.Camera3D = rl.camera_3d
rl.Camera2D = rl.camera_2d
rl.Ray = rl.ray
rl.BoundingBox = rl.bounding_box

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

---Create a new FFI type (shortcut to ffi.new)
---@param ctype string
---@param ... any
---@return any
function rl.new(ctype, ...)
	return ffi.new(ctype, ...)
end

---Create a pointer reference to a value (for out parameters)
---@param ctype string
---@param value? any
---@return any
function rl.ref(ctype, value)
	if value then
		return ffi.new(ctype .. "[1]", value)
	else
		return ffi.new(ctype .. "[1]")
	end
end

---Check if a value is a valid FFI cdata
---@param value any
---@return boolean
function rl.istype(ctype, value)
	return ffi.istype(ctype, value)
end

---Get the size of a C type
---@param ctype string The C type name
---@return integer
function rl.sizeof(ctype)
	return ffi.sizeof(ctype)
end

-- ============================================================================
-- NOTE: Vector/Quaternion/Matrix metatypes with math operators are set up by
-- raymath.lua. If you need vector operator overloads (+, -, *, /, etc.),
-- require("raymath") before or after requiring raylib.

ffi.metatype("Color", {
	__eq = function(a, b) 
		if not a or not b then return false end
		return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a 
	end,
	__tostring = function(c) return string.format("Color(%d, %d, %d, %d)", c.r, c.g, c.b, c.a) end,
})

ffi.metatype("Rectangle", {
	__eq = function(a, b) return a.x == b.x and a.y == b.y and a.width == b.width and a.height == b.height end,
	__tostring = function(r) return string.format("Rectangle(%.1f, %.1f, %.1f, %.1f)", r.x, r.y, r.width, r.height) end,
})

-- ============================================================================
-- ENUMERATION TABLES
-- ============================================================================

rl.ConfigFlags = {
	FLAG_VSYNC_HINT = 64,
	FLAG_FULLSCREEN_MODE = 2,
	FLAG_WINDOW_RESIZABLE = 4,
	FLAG_WINDOW_UNDECORATED = 8,
	FLAG_WINDOW_HIDDEN = 128,
	FLAG_WINDOW_MINIMIZED = 512,
	FLAG_WINDOW_MAXIMIZED = 1024,
	FLAG_WINDOW_UNFOCUSED = 2048,
	FLAG_WINDOW_TOPMOST = 4096,
	FLAG_WINDOW_ALWAYS_RUN = 256,
	FLAG_WINDOW_TRANSPARENT = 16,
	FLAG_WINDOW_HIGHDPI = 8192,
	FLAG_WINDOW_MOUSE_PASSTHROUGH = 32768,
	FLAG_BORDERLESS_WINDOWED_MODE = 65536,
	FLAG_MSAA_4X_HINT = 32,
	FLAG_INTERLACED_HINT = 65536,
}

rl.TraceLogLevel = {
	LOG_ALL = 0,
	LOG_TRACE = 1,
	LOG_DEBUG = 2,
	LOG_INFO = 3,
	LOG_WARNING = 4,
	LOG_ERROR = 5,
	LOG_FATAL = 6,
	LOG_NONE = 7,
}

rl.KeyboardKey = {
	KEY_NULL = 0,
	KEY_APOSTROPHE = 39,
	KEY_COMMA = 44,
	KEY_MINUS = 45,
	KEY_PERIOD = 46,
	KEY_SLASH = 47,
	KEY_ZERO = 48,
	KEY_ONE = 49,
	KEY_TWO = 50,
	KEY_THREE = 51,
	KEY_FOUR = 52,
	KEY_FIVE = 53,
	KEY_SIX = 54,
	KEY_SEVEN = 55,
	KEY_EIGHT = 56,
	KEY_NINE = 57,
	KEY_SEMICOLON = 59,
	KEY_EQUAL = 61,
	KEY_A = 65,
	KEY_B = 66,
	KEY_C = 67,
	KEY_D = 68,
	KEY_E = 69,
	KEY_F = 70,
	KEY_G = 71,
	KEY_H = 72,
	KEY_I = 73,
	KEY_J = 74,
	KEY_K = 75,
	KEY_L = 76,
	KEY_M = 77,
	KEY_N = 78,
	KEY_O = 79,
	KEY_P = 80,
	KEY_Q = 81,
	KEY_R = 82,
	KEY_S = 83,
	KEY_T = 84,
	KEY_U = 85,
	KEY_V = 86,
	KEY_W = 87,
	KEY_X = 88,
	KEY_Y = 89,
	KEY_Z = 90,
	KEY_LEFT_BRACKET = 91,
	KEY_BACKSLASH = 92,
	KEY_RIGHT_BRACKET = 93,
	KEY_GRAVE = 96,
	KEY_SPACE = 32,
	KEY_ESCAPE = 256,
	KEY_ENTER = 257,
	KEY_TAB = 258,
	KEY_BACKSPACE = 259,
	KEY_INSERT = 260,
	KEY_DELETE = 261,
	KEY_RIGHT = 262,
	KEY_LEFT = 263,
	KEY_DOWN = 264,
	KEY_UP = 265,
	KEY_PAGE_UP = 266,
	KEY_PAGE_DOWN = 267,
	KEY_HOME = 268,
	KEY_END = 269,
	KEY_CAPS_LOCK = 280,
	KEY_SCROLL_LOCK = 281,
	KEY_NUM_LOCK = 282,
	KEY_PRINT_SCREEN = 283,
	KEY_PAUSE = 284,
	KEY_F1 = 290,
	KEY_F2 = 291,
	KEY_F3 = 292,
	KEY_F4 = 293,
	KEY_F5 = 294,
	KEY_F6 = 295,
	KEY_F7 = 296,
	KEY_F8 = 297,
	KEY_F9 = 298,
	KEY_F10 = 299,
	KEY_F11 = 300,
	KEY_F12 = 301,
	KEY_F13 = 302,
	KEY_F14 = 303,
	KEY_F15 = 304,
	KEY_F16 = 305,
	KEY_F17 = 306,
	KEY_F18 = 307,
	KEY_F19 = 308,
	KEY_F20 = 309,
	KEY_F21 = 310,
	KEY_F22 = 311,
	KEY_F23 = 312,
	KEY_F24 = 313,
	KEY_KP_0 = 320,
	KEY_KP_1 = 321,
	KEY_KP_2 = 322,
	KEY_KP_3 = 323,
	KEY_KP_4 = 324,
	KEY_KP_5 = 325,
	KEY_KP_6 = 326,
	KEY_KP_7 = 327,
	KEY_KP_8 = 328,
	KEY_KP_9 = 329,
	KEY_KP_DECIMAL = 330,
	KEY_KP_DIVIDE = 331,
	KEY_KP_MULTIPLY = 332,
	KEY_KP_SUBTRACT = 333,
	KEY_KP_ADD = 334,
	KEY_KP_ENTER = 335,
	KEY_KP_EQUAL = 336,
	KEY_LEFT_SHIFT = 340,
	KEY_LEFT_CONTROL = 341,
	KEY_LEFT_ALT = 342,
	KEY_LEFT_SUPER = 343,
	KEY_RIGHT_SHIFT = 344,
	KEY_RIGHT_CONTROL = 345,
	KEY_RIGHT_ALT = 346,
	KEY_RIGHT_SUPER = 347,
	KEY_KB_MENU = 348,
}

rl.MouseButton = {
	MOUSE_BUTTON_LEFT = 0,
	MOUSE_BUTTON_RIGHT = 1,
	MOUSE_BUTTON_MIDDLE = 2,
	MOUSE_BUTTON_SIDE = 3,
	MOUSE_BUTTON_EXTRA = 4,
	MOUSE_BUTTON_FORWARD = 5,
	MOUSE_BUTTON_BACK = 6,
}

rl.MouseCursor = {
	MOUSE_CURSOR_DEFAULT = 0,
	MOUSE_CURSOR_ARROW = 1,
	MOUSE_CURSOR_IBEAM = 2,
	MOUSE_CURSOR_CROSSHAIR = 3,
	MOUSE_CURSOR_POINTING_HAND = 4,
	MOUSE_CURSOR_RESIZE_EW = 5,
	MOUSE_CURSOR_RESIZE_NS = 6,
	MOUSE_CURSOR_RESIZE_NWSE = 7,
	MOUSE_CURSOR_RESIZE_NESW = 8,
	MOUSE_CURSOR_RESIZE_ALL = 9,
	MOUSE_CURSOR_NOT_ALLOWED = 10,
}

rl.GamepadButton = {
	GAMEPAD_BUTTON_UNKNOWN = 0,
	GAMEPAD_BUTTON_LEFT_FACE_UP = 1,
	GAMEPAD_BUTTON_LEFT_FACE_RIGHT = 2,
	GAMEPAD_BUTTON_LEFT_FACE_DOWN = 3,
	GAMEPAD_BUTTON_LEFT_FACE_LEFT = 4,
	GAMEPAD_BUTTON_RIGHT_FACE_UP = 5,
	GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = 6,
	GAMEPAD_BUTTON_RIGHT_FACE_DOWN = 7,
	GAMEPAD_BUTTON_RIGHT_FACE_LEFT = 8,
	GAMEPAD_BUTTON_LEFT_TRIGGER_1 = 9,
	GAMEPAD_BUTTON_LEFT_TRIGGER_2 = 10,
	GAMEPAD_BUTTON_RIGHT_TRIGGER_1 = 11,
	GAMEPAD_BUTTON_RIGHT_TRIGGER_2 = 12,
	GAMEPAD_BUTTON_MIDDLE_LEFT = 13,
	GAMEPAD_BUTTON_MIDDLE = 14,
	GAMEPAD_BUTTON_MIDDLE_RIGHT = 15,
	GAMEPAD_BUTTON_LEFT_THUMB = 16,
	GAMEPAD_BUTTON_RIGHT_THUMB = 17,
}

rl.GamepadAxis = {
	GAMEPAD_AXIS_LEFT_X = 0,
	GAMEPAD_AXIS_LEFT_Y = 1,
	GAMEPAD_AXIS_RIGHT_X = 2,
	GAMEPAD_AXIS_RIGHT_Y = 3,
	GAMEPAD_AXIS_LEFT_TRIGGER = 4,
	GAMEPAD_AXIS_RIGHT_TRIGGER = 5,
}

rl.MaterialMapIndex = {
	MATERIAL_MAP_ALBEDO = 0,
	MATERIAL_MAP_METALNESS = 1,
	MATERIAL_MAP_NORMAL = 2,
	MATERIAL_MAP_ROUGHNESS = 3,
	MATERIAL_MAP_OCCLUSION = 4,
	MATERIAL_MAP_EMISSION = 5,
	MATERIAL_MAP_HEIGHT = 6,
	MATERIAL_MAP_CUBEMAP = 7,
	MATERIAL_MAP_IRRADIANCE = 8,
	MATERIAL_MAP_PREFILTER = 9,
	MATERIAL_MAP_BRDF = 10,
}

rl.ShaderLocationIndex = {
	SHADER_LOC_VERTEX_POSITION = 0,
	SHADER_LOC_VERTEX_TEXCOORD01 = 1,
	SHADER_LOC_VERTEX_TEXCOORD02 = 2,
	SHADER_LOC_VERTEX_NORMAL = 3,
	SHADER_LOC_VERTEX_TANGENT = 4,
	SHADER_LOC_VERTEX_COLOR = 5,
	SHADER_LOC_MATRIX_MVP = 6,
	SHADER_LOC_MATRIX_VIEW = 7,
	SHADER_LOC_MATRIX_PROJECTION = 8,
	SHADER_LOC_MATRIX_MODEL = 9,
	SHADER_LOC_MATRIX_NORMAL = 10,
	SHADER_LOC_VECTOR_VIEW = 11,
	SHADER_LOC_COLOR_DIFFUSE = 12,
	SHADER_LOC_COLOR_SPECULAR = 13,
	SHADER_LOC_COLOR_AMBIENT = 14,
	SHADER_LOC_MAP_ALBEDO = 15,
	SHADER_LOC_MAP_METALNESS = 16,
	SHADER_LOC_MAP_NORMAL = 17,
	SHADER_LOC_MAP_ROUGHNESS = 18,
	SHADER_LOC_MAP_OCCLUSION = 19,
	SHADER_LOC_MAP_EMISSION = 20,
	SHADER_LOC_MAP_HEIGHT = 21,
	SHADER_LOC_MAP_CUBEMAP = 22,
	SHADER_LOC_MAP_IRRADIANCE = 23,
	SHADER_LOC_MAP_PREFILTER = 24,
	SHADER_LOC_MAP_BRDF = 25,
}

rl.ShaderUniformDataType = {
	SHADER_UNIFORM_FLOAT = 0,
	SHADER_UNIFORM_VEC2 = 1,
	SHADER_UNIFORM_VEC3 = 2,
	SHADER_UNIFORM_VEC4 = 3,
	SHADER_UNIFORM_INT = 4,
	SHADER_UNIFORM_IVEC2 = 5,
	SHADER_UNIFORM_IVEC3 = 6,
	SHADER_UNIFORM_IVEC4 = 7,
	SHADER_UNIFORM_SAMPLER2D = 8,
}

rl.ShaderAttributeDataType = {
	SHADER_ATTRIB_FLOAT = 0,
	SHADER_ATTRIB_VEC2 = 1,
	SHADER_ATTRIB_VEC3 = 2,
	SHADER_ATTRIB_VEC4 = 3,
}

rl.PixelFormat = {
	PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1,
	PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA = 2,
	PIXELFORMAT_UNCOMPRESSED_R5G6B5 = 3,
	PIXELFORMAT_UNCOMPRESSED_R8G8B8 = 4,
	PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 = 5,
	PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 = 6,
	PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 = 7,
	PIXELFORMAT_UNCOMPRESSED_R32 = 8,
	PIXELFORMAT_UNCOMPRESSED_R32G32B32 = 9,
	PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 = 10,
	PIXELFORMAT_UNCOMPRESSED_R16 = 11,
	PIXELFORMAT_UNCOMPRESSED_R16G16B16 = 12,
	PIXELFORMAT_UNCOMPRESSED_R16G16B16A16 = 13,
	PIXELFORMAT_COMPRESSED_DXT1_RGB = 14,
	PIXELFORMAT_COMPRESSED_DXT1_RGBA = 15,
	PIXELFORMAT_COMPRESSED_DXT3_RGBA = 16,
	PIXELFORMAT_COMPRESSED_DXT5_RGBA = 17,
	PIXELFORMAT_COMPRESSED_ETC1_RGB = 18,
	PIXELFORMAT_COMPRESSED_ETC2_RGB = 19,
	PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA = 20,
	PIXELFORMAT_COMPRESSED_PVRT_RGB = 21,
	PIXELFORMAT_COMPRESSED_PVRT_RGBA = 22,
	PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA = 23,
	PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA = 24,
}

rl.TextureFilter = {
	TEXTURE_FILTER_POINT = 0,
	TEXTURE_FILTER_BILINEAR = 1,
	TEXTURE_FILTER_TRILINEAR = 2,
	TEXTURE_FILTER_ANISOTROPIC_4X = 3,
	TEXTURE_FILTER_ANISOTROPIC_8X = 4,
	TEXTURE_FILTER_ANISOTROPIC_16X = 5,
}

rl.TextureWrap = {
	TEXTURE_WRAP_REPEAT = 0,
	TEXTURE_WRAP_CLAMP = 1,
	TEXTURE_WRAP_MIRROR_REPEAT = 2,
	TEXTURE_WRAP_MIRROR_CLAMP = 3,
}

rl.CubemapLayout = {
	CUBEMAP_LAYOUT_AUTO_DETECT = 0,
	CUBEMAP_LAYOUT_LINE_VERTICAL = 1,
	CUBEMAP_LAYOUT_LINE_HORIZONTAL = 2,
	CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR = 3,
	CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE = 4,
}

rl.FontType = {
	FONT_DEFAULT = 0,
	FONT_BITMAP = 1,
	FONT_SDF = 2,
}

rl.BlendMode = {
	BLEND_ALPHA = 0,
	BLEND_ADDITIVE = 1,
	BLEND_MULTIPLIED = 2,
	BLEND_ADD_COLORS = 3,
	BLEND_SUBTRACT_COLORS = 4,
	BLEND_ALPHA_PREMULTIPLY = 5,
	BLEND_CUSTOM = 6,
	BLEND_CUSTOM_SEPARATE = 7,
}

rl.Gesture = {
	GESTURE_NONE = 0,
	GESTURE_TAP = 1,
	GESTURE_DOUBLETAP = 2,
	GESTURE_HOLD = 4,
	GESTURE_DRAG = 8,
	GESTURE_SWIPE_RIGHT = 16,
	GESTURE_SWIPE_LEFT = 32,
	GESTURE_SWIPE_UP = 64,
	GESTURE_SWIPE_DOWN = 128,
	GESTURE_PINCH_IN = 256,
	GESTURE_PINCH_OUT = 512,
}

rl.CameraMode = {
	CAMERA_CUSTOM = 0,
	CAMERA_FREE = 1,
	CAMERA_ORBITAL = 2,
	CAMERA_FIRST_PERSON = 3,
	CAMERA_THIRD_PERSON = 4,
}

rl.CameraProjection = {
	CAMERA_PERSPECTIVE = 0,
	CAMERA_ORTHOGRAPHIC = 1,
}

rl.NPatchLayout = {
	NPATCH_NINE_PATCH = 0,
	NPATCH_THREE_PATCH_VERTICAL = 1,
	NPATCH_THREE_PATCH_HORIZONTAL = 2,
}

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

-- Forward all undefined function calls to rl.lib
setmetatable(rl, {
	__index = function(t, k)
		-- Try direct lookup first (for CamelCase, color constants, enums, etc.)
		local ok, v = pcall(function() return rl.lib[k] end)
		if ok and v then
			rawset(t, k, v)
			return v
		end
		-- Try converting snake_case to CamelCase
		local camel = snake_to_camel(k)
		if camel ~= k then
			ok, v = pcall(function() return rl.lib[camel] end)
			if ok and v then
				rawset(t, k, v)
				return v
			end
		end
		return nil
	end
})

return rl
