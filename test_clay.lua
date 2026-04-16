-- ==========================================================================
-- Test suite for clay.lua FFI bindings
-- Uses LuaUnit (https://github.com/bluebird75/luaunit)
-- Run with: luajit test_clay.lua
-- ==========================================================================

local lu = require("vendor.luaunit")
local ffi = require("ffi")
local clay = require("clay")

local EPS = 0.001

local function approx(a, b)
    return math.abs(a - b) < EPS
end

local function destroy_context(ctx)
    if ctx == nil then
        return
    end
    if clay.get_current_context() == ctx._context then
        clay.set_current_context(nil)
    end
    ctx:destroy()
end

-- ============================================================================
-- 1. Module structure and enumerations
-- ============================================================================
test_module_structure = {}

function test_module_structure:test_clay_is_table()
    lu.assertIsTable(clay)
end

function test_module_structure:test_ffi_and_lib_exist()
    lu.assertEquals(clay.ffi, ffi)
    lu.assertNotNil(clay.lib)
    local t = type(clay.lib)
    lu.assertTrue(t == "cdata" or t == "userdata", "clay.lib should be cdata or userdata, got: " .. t)
end

function test_module_structure:test_constructor_functions_exist()
    local constructors = {
        "string",
        "string_slice",
        "dimensions",
        "vector2",
        "color",
        "bounding_box",
        "corner_radius",
        "padding",
        "child_alignment",
        "floating_attach_points",
        "border_width",
        "sizing_fit",
        "sizing_grow",
        "sizing_fixed",
        "sizing_percent",
        "sizing",
        "layout_config",
        "element_declaration",
        "text_config",
        "aspect_ratio_config",
        "image_config",
        "floating_config",
        "custom_config",
        "clip_config",
        "border_config",
        "transition_data",
        "transition_enter_config",
        "transition_exit_config",
        "transition_config",
        "error_handler",
        "new_context",
        "new",
    }

    for _, name in ipairs(constructors) do
        lu.assertNotNil(clay[name], "Constructor missing: " .. name)
        lu.assertIsFunction(clay[name], "Constructor not a function: " .. name)
    end
end

function test_module_structure:test_enumeration_tables_exist()
    local enums = {
        "layout_direction",
        "align_x",
        "align_y",
        "sizing_type",
        "text_wrap",
        "text_align",
        "floating_attach_point",
        "pointer_capture_mode",
        "floating_attach_to",
        "floating_clip_to",
        "transition_state",
        "transition_property",
        "transition_enter_trigger",
        "transition_exit_trigger",
        "transition_interaction_handling",
        "exit_transition_sibling_ordering",
        "render_command_type",
        "pointer_data_interaction_state",
        "error_type",
    }

    for _, name in ipairs(enums) do
        lu.assertNotNil(clay[name], "Enum table missing: " .. name)
        lu.assertIsTable(clay[name], "Enum not a table: " .. name)
    end
end

function test_module_structure:test_enum_aliases_share_same_tables()
    lu.assertEquals(clay.LayoutDirection, clay.layout_direction)
    lu.assertEquals(clay.AlignX, clay.align_x)
    lu.assertEquals(clay.AlignY, clay.align_y)
    lu.assertEquals(clay.SizingType, clay.sizing_type)
    lu.assertEquals(clay.TextWrap, clay.text_wrap)
    lu.assertEquals(clay.TextAlign, clay.text_align)
    lu.assertEquals(clay.RenderCommandType, clay.render_command_type)
    lu.assertEquals(clay.PointerDataInteractionState, clay.pointer_data_interaction_state)
    lu.assertEquals(clay.ErrorType, clay.error_type)
end

function test_module_structure:test_selected_enum_values()
    lu.assertEquals(clay.layout_direction.LEFT_TO_RIGHT, 0)
    lu.assertEquals(clay.layout_direction.TOP_TO_BOTTOM, 1)
    lu.assertEquals(clay.sizing_type.FIXED, 3)
    lu.assertEquals(clay.render_command_type.RECTANGLE, 1)
    lu.assertEquals(clay.render_command_type.TEXT, 3)
    lu.assertEquals(clay.error_type.DUPLICATE_ID, 4)
end

-- ============================================================================
-- 2. Constructors and metatypes
-- ============================================================================
test_constructors = {}

function test_constructors:test_string_constructor_and_tostring()
    local value = clay.string("hello", true)
    lu.assertEquals(value.length, 5)
    lu.assertTrue(value.isStaticallyAllocated)
    lu.assertEquals(tostring(value), "hello")
end

function test_constructors:test_string_slice_constructor_and_tostring()
    local value = clay.string_slice("world")
    lu.assertEquals(value.length, 5)
    lu.assertEquals(tostring(value), "world")
    lu.assertNotNil(value.baseChars)
end

function test_constructors:test_dimensions_constructor_and_tostring()
    local value = clay.dimensions(10.5, 20.25)
    lu.assertTrue(approx(value.width, 10.5))
    lu.assertTrue(approx(value.height, 20.25))
    lu.assertEquals(tostring(value), "Clay_Dimensions(10.50, 20.25)")
end

function test_constructors:test_vector2_constructor_and_tostring()
    local value = clay.vector2(1.5, 2.25)
    lu.assertTrue(approx(value.x, 1.5))
    lu.assertTrue(approx(value.y, 2.25))
    lu.assertEquals(tostring(value), "Clay_Vector2(1.50, 2.25)")
end

function test_constructors:test_color_constructor_defaults_alpha()
    local value = clay.color(10, 20, 30)
    lu.assertEquals(value.r, 10)
    lu.assertEquals(value.g, 20)
    lu.assertEquals(value.b, 30)
    lu.assertEquals(value.a, 255)
    lu.assertEquals(tostring(value), "Clay_Color(10, 20, 30, 255)")
end

function test_constructors:test_bounding_box_constructor_and_tostring()
    local value = clay.bounding_box(1, 2, 3, 4)
    lu.assertTrue(approx(value.x, 1))
    lu.assertTrue(approx(value.y, 2))
    lu.assertTrue(approx(value.width, 3))
    lu.assertTrue(approx(value.height, 4))
    lu.assertEquals(tostring(value), "Clay_BoundingBox(1.00, 2.00, 3.00, 4.00)")
end

function test_constructors:test_corner_radius_cascades_defaults()
    local value = clay.corner_radius(5, 6)
    lu.assertEquals(value.topLeft, 5)
    lu.assertEquals(value.topRight, 6)
    lu.assertEquals(value.bottomLeft, 5)
    lu.assertEquals(value.bottomRight, 6)
end

function test_constructors:test_padding_cascades_defaults()
    local value = clay.padding(8, 10)
    lu.assertEquals(value.left, 8)
    lu.assertEquals(value.right, 10)
    lu.assertEquals(value.top, 8)
    lu.assertEquals(value.bottom, 8)
end

function test_constructors:test_border_width_cascades_defaults()
    local value = clay.border_width(2, 4, 6)
    lu.assertEquals(value.left, 2)
    lu.assertEquals(value.right, 4)
    lu.assertEquals(value.top, 6)
    lu.assertEquals(value.bottom, 6)
    lu.assertEquals(value.betweenChildren, 0)
end

function test_constructors:test_child_alignment_defaults()
    local value = clay.child_alignment()
    lu.assertEquals(value.x, clay.align_x.LEFT)
    lu.assertEquals(value.y, clay.align_y.TOP)
end

function test_constructors:test_floating_attach_points_defaults()
    local value = clay.floating_attach_points()
    lu.assertEquals(value.element, clay.floating_attach_point.LEFT_TOP)
    lu.assertEquals(value.parent, clay.floating_attach_point.LEFT_TOP)
end

function test_constructors:test_sizing_helpers()
    local fit = clay.sizing_fit(10, 20)
    lu.assertEquals(fit.type, clay.sizing_type.FIT)
    lu.assertTrue(approx(fit.size.minMax.min, 10))
    lu.assertTrue(approx(fit.size.minMax.max, 20))

    local grow = clay.sizing_grow(5, 15)
    lu.assertEquals(grow.type, clay.sizing_type.GROW)
    lu.assertTrue(approx(grow.size.minMax.min, 5))
    lu.assertTrue(approx(grow.size.minMax.max, 15))

    local fixed = clay.sizing_fixed(42)
    lu.assertEquals(fixed.type, clay.sizing_type.FIXED)
    lu.assertTrue(approx(fixed.size.minMax.min, 42))
    lu.assertTrue(approx(fixed.size.minMax.max, 42))

    local percent = clay.sizing_percent(0.5)
    lu.assertEquals(percent.type, clay.sizing_type.PERCENT)
    lu.assertTrue(approx(percent.size.percent, 0.5))
end

function test_constructors:test_sizing_uses_given_axes()
    local width = clay.sizing_fixed(80)
    local height = clay.sizing_percent(0.25)
    local value = clay.sizing(width, height)
    lu.assertEquals(value.width.type, clay.sizing_type.FIXED)
    lu.assertEquals(value.height.type, clay.sizing_type.PERCENT)
    lu.assertTrue(approx(value.width.size.minMax.min, 80))
    lu.assertTrue(approx(value.height.size.percent, 0.25))
end

function test_constructors:test_image_and_custom_config_store_user_pointers()
    local ptr = ffi.cast("void *", 0x1234)
    local image = clay.image_config(ptr)
    local custom = clay.custom_config(ptr)
    lu.assertEquals(image.imageData, ptr)
    lu.assertEquals(custom.customData, ptr)
end

function test_constructors:test_clip_and_border_config_store_values()
    local clip = clay.clip_config(true, false, clay.vector2(3, 4))
    lu.assertTrue(clip.horizontal)
    lu.assertFalse(clip.vertical)
    lu.assertTrue(approx(clip.childOffset.x, 3))
    lu.assertTrue(approx(clip.childOffset.y, 4))

    local border = clay.border_config(clay.color(1, 2, 3, 4), clay.border_width(5, 6, 7, 8, 9))
    lu.assertEquals(border.color.r, 1)
    lu.assertEquals(border.color.a, 4)
    lu.assertEquals(border.width.left, 5)
    lu.assertEquals(border.width.betweenChildren, 9)
end

function test_constructors:test_zero_initialized_config_helpers()
    local layout = clay.layout_config()
    local element = clay.element_declaration()
    local text = clay.text_config()
    local floating = clay.floating_config()
    local transition = clay.transition_config()
    local error_handler = clay.error_handler()

    lu.assertEquals(layout.childGap, 0)
    lu.assertEquals(element.backgroundColor.a, 0)
    lu.assertEquals(text.fontSize, 0)
    lu.assertEquals(floating.zIndex, 0)
    lu.assertTrue(approx(transition.duration, 0))
    lu.assertNil(error_handler.errorHandlerFunction)
end

-- ============================================================================
-- 3. Hashing and element IDs
-- ============================================================================
test_ids = {}

function test_ids:test_hash_string_is_stable()
    local a = clay.hash_string("box")
    local b = clay.hash_string("box")
    local c = clay.hash_string("other")

    lu.assertEquals(a.id, b.id)
    lu.assertNotEquals(a.id, c.id)
    lu.assertEquals(tostring(a.stringId), "box")
end

function test_ids:test_hash_string_with_offset_tracks_base_id()
    local base = clay.hash_string("box")
    local with_offset = clay.hash_string_with_offset("box", 7)

    lu.assertEquals(with_offset.offset, 7)
    lu.assertEquals(with_offset.baseId, base.id)
    lu.assertEquals(tostring(with_offset.stringId), "box")
end

function test_ids:test_get_element_id_accepts_string_and_clay_string()
    local a = clay.get_element_id("hello")
    local b = clay.get_element_id(clay.string("hello", true))

    lu.assertEquals(a.id, b.id)
    lu.assertEquals(a.baseId, b.baseId)
    lu.assertEquals(tostring(a.stringId), "hello")
end

function test_ids:test_get_element_id_with_index_uses_index_as_offset()
    local indexed = clay.get_element_id_with_index("item", 2)
    local base = clay.get_element_id("item")

    lu.assertEquals(indexed.offset, 2)
    lu.assertEquals(indexed.baseId, base.id)
    lu.assertEquals(tostring(indexed.stringId), "item")
    lu.assertStrContains(tostring(indexed), "stringId=item")
end

-- ============================================================================
-- 4. Context and global state helpers
-- ============================================================================
test_context = {}

function test_context:test_min_memory_size_is_positive()
    lu.assertTrue(clay.min_memory_size() > 0)
end

function test_context:test_new_context_sets_current_context()
    local ctx = clay.new_context(320, 240)
    lu.assertEquals(clay.get_current_context(), ctx._context)
    destroy_context(ctx)
end

function test_context:test_set_current_switches_between_contexts()
    local first = clay.new(100, 100)
    local second = clay.new(200, 200)

    lu.assertEquals(clay.get_current_context(), second._context)
    first:set_current()
    lu.assertEquals(clay.get_current_context(), first._context)
    second:set_current()
    lu.assertEquals(clay.get_current_context(), second._context)

    destroy_context(first)
    destroy_context(second)
end

function test_context:test_pointer_state_transitions()
    local ctx = clay.new(100, 100)
    ctx:set_current()

    -- Normalize any global pointer state left behind by previous tests.
    clay.set_pointer_state(clay.vector2(0, 0), false)
    clay.set_pointer_state(clay.vector2(0, 0), false)
    lu.assertEquals(clay.get_pointer_state().state, clay.pointer_data_interaction_state.RELEASED)

    clay.set_pointer_state(clay.vector2(10, 20), true)
    local pressed_this_frame = clay.get_pointer_state()
    lu.assertTrue(approx(pressed_this_frame.position.x, 10))
    lu.assertTrue(approx(pressed_this_frame.position.y, 20))
    lu.assertEquals(pressed_this_frame.state, clay.pointer_data_interaction_state.PRESSED_THIS_FRAME)

    clay.set_pointer_state(clay.vector2(10, 20), true)
    lu.assertEquals(clay.get_pointer_state().state, clay.pointer_data_interaction_state.PRESSED)

    clay.set_pointer_state(clay.vector2(30, 40), false)
    local released_this_frame = clay.get_pointer_state()
    lu.assertTrue(approx(released_this_frame.position.x, 30))
    lu.assertTrue(approx(released_this_frame.position.y, 40))
    lu.assertEquals(released_this_frame.state, clay.pointer_data_interaction_state.RELEASED_THIS_FRAME)

    clay.set_pointer_state(clay.vector2(30, 40), false)
    lu.assertEquals(clay.get_pointer_state().state, clay.pointer_data_interaction_state.RELEASED)

    destroy_context(ctx)
end

function test_context:test_debug_mode_and_limits_round_trip()
    local ctx = clay.new(100, 100)
    ctx:set_current()

    clay.set_debug_mode_enabled(true)
    lu.assertTrue(clay.is_debug_mode_enabled())
    clay.set_debug_mode_enabled(false)
    lu.assertFalse(clay.is_debug_mode_enabled())

    local old_max = clay.get_max_element_count()
    clay.set_max_element_count(1234)
    lu.assertEquals(clay.get_max_element_count(), 1234)
    clay.set_max_element_count(old_max)
    lu.assertEquals(clay.get_max_element_count(), old_max)

    local old_cache = clay.get_max_measure_text_cache_word_count()
    clay.set_max_measure_text_cache_word_count(321)
    lu.assertEquals(clay.get_max_measure_text_cache_word_count(), 321)
    clay.set_max_measure_text_cache_word_count(old_cache)
    lu.assertEquals(clay.get_max_measure_text_cache_word_count(), old_cache)

    clay.set_culling_enabled(true)
    clay.set_culling_enabled(false)
    clay.reset_measure_text_cache()

    lu.assertTrue(clay.debug_view_width() > 0)
    local color = clay.debug_view_highlight_color()
    lu.assertTrue(color.a > 0)

    destroy_context(ctx)
end

function test_context:test_scroll_offset_defaults_to_zero()
    local ctx = clay.new(100, 100)
    ctx:set_current()

    local offset = clay.get_scroll_offset()
    lu.assertTrue(approx(offset.x, 0))
    lu.assertTrue(approx(offset.y, 0))

    clay.update_scroll_containers(false, clay.vector2(0, 0), 0.016)
    local updated = clay.get_scroll_offset()
    lu.assertTrue(approx(updated.x, 0))
    lu.assertTrue(approx(updated.y, 0))

    destroy_context(ctx)
end

-- ============================================================================
-- 5. Layout integration
-- ============================================================================
test_layout = {}

function test_layout:test_empty_layout_returns_no_commands()
    local ctx = clay.new(200, 100)
    ctx:begin_layout()
    local commands = ctx:end_layout(0)
    lu.assertEquals(commands.length, 0)
    destroy_context(ctx)
end

function test_layout:test_rectangle_element_produces_render_command()
    local ctx = clay.new(200, 100)
    local id = clay.get_element_id("box")

    ctx:begin_layout()
    clay.open_element_with_id(id)

    local decl = clay.element_declaration()
    decl.backgroundColor = clay.color(255, 0, 0, 255)
    decl.layout.sizing = clay.sizing(clay.sizing_fixed(50), clay.sizing_fixed(20))
    clay.configure_open_element(decl)

    clay.close_element()
    local commands = ctx:end_layout(0)
    local command = clay.render_command_array_get(commands, 0)

    lu.assertEquals(commands.length, 1)
    lu.assertEquals(command.commandType, clay.render_command_type.RECTANGLE)
    lu.assertTrue(approx(command.boundingBox.x, 0))
    lu.assertTrue(approx(command.boundingBox.y, 0))
    lu.assertTrue(approx(command.boundingBox.width, 50))
    lu.assertTrue(approx(command.boundingBox.height, 20))
    lu.assertEquals(command.renderData.rectangle.backgroundColor.r, 255)
    lu.assertEquals(command.renderData.rectangle.backgroundColor.a, 255)

    local data = clay.get_element_data(id)
    lu.assertTrue(data.found)
    lu.assertTrue(approx(data.boundingBox.width, 50))
    lu.assertTrue(approx(data.boundingBox.height, 20))

    destroy_context(ctx)
end

function test_layout:test_configure_open_element_ptr_matches_struct_version()
    local ctx = clay.new(200, 100)

    ctx:begin_layout()
    clay.open_element()

    local decl = clay.element_declaration()
    decl.backgroundColor = clay.color(1, 2, 3, 4)
    decl.layout.sizing = clay.sizing(clay.sizing_fixed(12), clay.sizing_fixed(34))
    clay.configure_open_element_ptr(decl)

    clay.close_element()
    local commands = ctx:end_layout(0)
    local command = clay.render_command_array_get(commands, 0)

    lu.assertEquals(command.commandType, clay.render_command_type.RECTANGLE)
    lu.assertTrue(approx(command.boundingBox.width, 12))
    lu.assertTrue(approx(command.boundingBox.height, 34))
    lu.assertEquals(command.renderData.rectangle.backgroundColor.r, 1)
    lu.assertEquals(command.renderData.rectangle.backgroundColor.a, 4)

    destroy_context(ctx)
end

function test_layout:test_open_text_element_produces_text_command()
    local ctx = clay.new(200, 100)

    ctx:begin_layout()
    clay.open_text_element("Hello", clay.text_config())
    local commands = ctx:end_layout(0)
    local command = clay.render_command_array_get(commands, 0)

    lu.assertEquals(commands.length, 1)
    lu.assertEquals(command.commandType, clay.render_command_type.TEXT)
    lu.assertEquals(tostring(command.renderData.text.stringContents), "Hello")

    destroy_context(ctx)
end

function test_layout:test_percent_sizing_tracks_layout_dimensions()
    local ctx = clay.new(200, 100)
    local id = clay.get_element_id("percent-box")
    local decl = clay.element_declaration()
    decl.layout.sizing = clay.sizing(clay.sizing_percent(0.5), clay.sizing_percent(1.0))

    ctx:begin_layout()
    clay.open_element_with_id(id)
    clay.configure_open_element(decl)
    clay.close_element()
    ctx:end_layout(0)

    local first = clay.get_element_data(id)
    lu.assertTrue(first.found)
    lu.assertTrue(approx(first.boundingBox.width, 100))
    lu.assertTrue(approx(first.boundingBox.height, 100))

    ctx:set_layout_dimensions(300, 150)
    ctx:begin_layout()
    clay.open_element_with_id(id)
    clay.configure_open_element(decl)
    clay.close_element()
    ctx:end_layout(0)

    local second = clay.get_element_data(id)
    lu.assertTrue(second.found)
    lu.assertTrue(approx(second.boundingBox.width, 150))
    lu.assertTrue(approx(second.boundingBox.height, 150))

    destroy_context(ctx)
end

function test_layout:test_missing_scroll_container_returns_not_found()
    local ctx = clay.new(100, 100)
    ctx:begin_layout()
    ctx:end_layout(0)

    local data = clay.get_scroll_container_data(clay.get_element_id("missing"))
    lu.assertFalse(data.found)
    lu.assertTrue(approx(data.scrollContainerDimensions.width, 0))
    lu.assertTrue(approx(data.contentDimensions.height, 0))

    destroy_context(ctx)
end

-- ============================================================================
-- Run
-- ============================================================================
os.exit(lu.LuaUnit.run())
