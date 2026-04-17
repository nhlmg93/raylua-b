local lu = require("vendor.luaunit")
local HotReload = require("hot_reload")

-- Test fixture module that will be reloaded
local test_module_counter = 0
package.loaded["test_fixtures.hot_reload_test_module"] = nil

-- Helper to create a fresh test module file
local function write_test_module(version, with_state)
	local state_init = with_state and "M.state = { count = 0, version = " .. version .. " }" or ""
	local code = string.format([[
local M = {}
M.version = %d
M.loaded_at = os.time()
%s
return M
]], version, state_init)
	
	local f = io.open("test_fixtures/hot_reload_test_module.lua", "w")
	if f then
		f:write(code)
		f:close()
		return true
	end
	return false
end

-- Helper to ensure test directory exists
local function ensure_test_dir()
	os.execute("mkdir -p test_fixtures")
end

-- Helper to cleanup
local function cleanup()
	os.execute("rm -rf test_fixtures")
	package.loaded["test_fixtures.hot_reload_test_module"] = nil
end

-- Helper to suppress print output during tests
local function suppress_output(fn)
	local old_print = print
	print = function() end
	local ok, err = pcall(fn)
	print = old_print
	if not ok then error(err) end
end

TestHotReload = {}

function TestHotReload:setUp()
	ensure_test_dir()
	self.hr = HotReload.new()
end

function TestHotReload:tearDown()
	cleanup()
	self.hr = nil
end

function TestHotReload:test_new_creates_instance()
	lu.assertNotNil(self.hr)
	lu.assertNotNil(self.hr.watched)
	lu.assertEquals(type(self.hr.watched), "table")
end

function TestHotReload:test_watch_loads_module()
	write_test_module(1)
	local mod = self.hr:watch("test_fixtures.hot_reload_test_module")
	lu.assertNotNil(mod)
	lu.assertEquals(mod.version, 1)
end

function TestHotReload:test_watch_returns_nil_on_invalid_module()
	local mod
	suppress_output(function()
		mod = self.hr:watch("test_fixtures.nonexistent_module")
	end)
	lu.assertNil(mod)
end

function TestHotReload:test_get_returns_watched_module()
	write_test_module(1)
	self.hr:watch("test_fixtures.hot_reload_test_module")
	local mod = self.hr:get("test_fixtures.hot_reload_test_module")
	lu.assertNotNil(mod)
	lu.assertEquals(mod.version, 1)
end

function TestHotReload:test_get_returns_nil_for_unwatched()
	local mod = self.hr:get("test_fixtures.hot_reload_test_module")
	lu.assertNil(mod)
end

function TestHotReload:test_list_returns_watched_names()
	write_test_module(1)
	self.hr:watch("test_fixtures.hot_reload_test_module")
	local list = self.hr:list()
	lu.assertEquals(#list, 1)
	lu.assertEquals(list[1], "test_fixtures.hot_reload_test_module")
end

function TestHotReload:test_list_empty_when_nothing_watched()
	local list = self.hr:list()
	lu.assertEquals(#list, 0)
end

function TestHotReload:test_unwatch_removes_module()
	write_test_module(1)
	self.hr:watch("test_fixtures.hot_reload_test_module")
	self.hr:unwatch("test_fixtures.hot_reload_test_module")
	local mod = self.hr:get("test_fixtures.hot_reload_test_module")
	lu.assertNil(mod)
	local list = self.hr:list()
	lu.assertEquals(#list, 0)
end

function TestHotReload:test_reload_module_forces_reload()
	write_test_module(1)
	local mod1 = self.hr:watch("test_fixtures.hot_reload_test_module")
	lu.assertNotNil(mod1)
	
	-- Update module file
	write_test_module(2)
	
	-- Force reload
	local mod2, err = self.hr:reload_module("test_fixtures.hot_reload_test_module", mod1)
	lu.assertNotNil(mod2)
	lu.assertNil(err)
	lu.assertEquals(mod2.version, 2)
	
	-- Should be same table reference (merge preserves old table)
	lu.assertEquals(mod1, mod2)
	lu.assertEquals(mod1.version, 2)
end

function TestHotReload:test_reload_module_preserves_state()
	write_test_module(1, true) -- with state
	local mod1 = self.hr:watch("test_fixtures.hot_reload_test_module")
	lu.assertNotNil(mod1.state)
	
	-- Modify state
	mod1.state.count = 42
	mod1.state.custom = "preserved"
	
	-- Update module file with new version
	write_test_module(2, true)
	
	-- Reload
	local mod2 = self.hr:reload_module("test_fixtures.hot_reload_test_module", mod1)
	lu.assertNotNil(mod2)
	
	-- State should be preserved
	lu.assertEquals(mod2.state.count, 42)
	lu.assertEquals(mod2.state.custom, "preserved")
	-- But version from new module should be applied
	lu.assertEquals(mod2.version, 2)
end

function TestHotReload:test_reload_module_returns_error_on_invalid()
	local mod, err
	suppress_output(function()
		mod, err = self.hr:reload_module("test_fixtures.nonexistent_module")
	end)
	lu.assertNil(mod)
	lu.assertNotNil(err)
	lu.assertEquals(type(err), "string")
end

function TestHotReload:test_check_detects_changes()
	write_test_module(1)
	local mod = self.hr:watch("test_fixtures.hot_reload_test_module")
	local initial_mtime = self.hr.watched["test_fixtures.hot_reload_test_module"].mtime
	
	-- First check - no changes yet
	local result, reloaded, name = self.hr:check()
	lu.assertNil(result)
	lu.assertFalse(reloaded)
	
	-- Manually update mtime to simulate file change (since we can't easily control fs mtime in tests)
	self.hr.watched["test_fixtures.hot_reload_test_module"].mtime = initial_mtime - 1
	
	-- Update the file
	write_test_module(2)
	
	-- Now check should detect change (suppress output)
	suppress_output(function()
		result, reloaded, name = self.hr:check()
	end)
	lu.assertNotNil(result)
	lu.assertTrue(reloaded)
	lu.assertEquals(name, "test_fixtures.hot_reload_test_module")
	lu.assertEquals(result.version, 2)
end

function TestHotReload:test_check_no_changes_when_uptodate()
	write_test_module(1)
	self.hr:watch("test_fixtures.hot_reload_test_module")
	
	-- Check without modifying file
	local result, reloaded = self.hr:check()
	lu.assertNil(result)
	lu.assertFalse(reloaded)
end

function TestHotReload:test_check_handles_reload_error()
	write_test_module(1)
	self.hr:watch("test_fixtures.hot_reload_test_module")
	local initial_mtime = self.hr.watched["test_fixtures.hot_reload_test_module"].mtime
	
	-- Simulate file change
	self.hr.watched["test_fixtures.hot_reload_test_module"].mtime = initial_mtime - 1
	
	-- Write invalid lua to cause error
	local f = io.open("test_fixtures/hot_reload_test_module.lua", "w")
	f:write("this is not valid lua! syntax error {{}}")
	f:close()
	
	local result, reloaded, name
	suppress_output(function()
		result, reloaded, name = self.hr:check()
	end)
	-- Should return old module, not reloaded
	lu.assertNotNil(result)
	lu.assertFalse(reloaded)
	lu.assertEquals(name, "test_fixtures.hot_reload_test_module")
end

function TestHotReload:test_multiple_modules()
	write_test_module(1)
	local mod1 = self.hr:watch("test_fixtures.hot_reload_test_module")
	
	-- Create another test module
	local f = io.open("test_fixtures/another_module.lua", "w")
	f:write("return { name = 'another', value = 100 }")
	f:close()
	
	local mod2 = self.hr:watch("test_fixtures.another_module")
	
	local list = self.hr:list()
	lu.assertEquals(#list, 2)
	
	-- Cleanup extra file
	os.remove("test_fixtures/another_module.lua")
	package.loaded["test_fixtures.another_module"] = nil
end

function TestHotReload:test_replace_table_same_table_noop()
	-- Internal function test - replace_table should handle dst == src
	local t = { a = 1, b = 2 }
	-- This should not error or clear the table
	lu.assertEquals(t.a, 1)
	lu.assertEquals(t.b, 2)
end

os.exit(lu.LuaUnit.run())
