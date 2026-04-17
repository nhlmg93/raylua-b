-- hot_reload.lua - Generic Lua module hot-reloading

-- Load LuaJIT table.clear extension (requires 5.2 compat build)
local _ = require("table.clear")

local lfs_ok, lfs = pcall(require, "lfs")

---@class HotReloadEntry
---@field path string
---@field mtime number
---@field module table?

---@class HotReload
---@field watched table<string, HotReloadEntry>
---@field reload_module fun(self: HotReload, name: string, old_mod?: table): table?, string?
---@field watch fun(self: HotReload, name: string): table?
---@field check fun(self: HotReload): table?, boolean, string?
---@field get fun(self: HotReload, name: string): table?
---@field unwatch fun(self: HotReload, name: string)
---@field list fun(self: HotReload): string[]

---@class HotReloadModule: HotReload
---@field new fun(): HotReload

local M = {}

---@return HotReload
function M.new()
	local self = setmetatable({}, { __index = M })
	---@cast self HotReload
	self.watched = {}
	return self
end

---@param name string
---@return string
local function default_path(name)
	return "./" .. name:gsub("%.", "/") .. ".lua"
end

---@param dst table
---@param src table
local function replace_table(dst, src)
	if dst == src then
		return
	end
	table.clear(dst)
	for k, v in pairs(src) do
		dst[k] = v
	end
end

---@param new_mod table?
---@param old_mod table?
local function preserve_state(new_mod, old_mod)
	local new_state = new_mod and new_mod.state
	local old_state = old_mod and old_mod.state
	if new_state and old_state then
		replace_table(new_state, old_state)
	end
end

---@param new_mod table
---@param old_mod table?
---@return table
local function merge_modules(new_mod, old_mod)
	if old_mod then
		preserve_state(new_mod, old_mod)
		replace_table(old_mod, new_mod)
		setmetatable(old_mod, getmetatable(new_mod))
		return old_mod
	end

	return new_mod
end

---@param path string
---@return number?
local function get_mtime(path)
	if lfs_ok then
		local attr = lfs.attributes(path)
		return attr and attr.modification or nil
	end

	local escaped = path:gsub("'", "'\"'\"'")
	local cmd = string.format("stat -c %%Y '%s' 2>/dev/null", escaped)

	local pipe = io.popen(cmd, "r")
	if not pipe then
		return nil
	end

	local line = pipe:read("*l")
	pipe:close()
	return line and tonumber(line:match("%d+")) or nil
end

---@param name string
---@return string
local function module_path(name)
	return (package.searchpath and package.searchpath(name, package.path)) or default_path(name)
end

---@param self HotReload
---@param name string
---@param old_mod table?
---@return table?, string?
function M:reload_module(name, old_mod)
	package.loaded[name] = nil
	local ok, mod = pcall(require, name)
	if not ok then
		package.loaded[name] = old_mod
		return nil, mod
	end

	mod = merge_modules(mod, old_mod)
	package.loaded[name] = mod
	return mod
end

---@param self HotReload
---@param name string
---@return table?
function M:watch(name)
	local path = module_path(name) or default_path(name)
	local ok, mod = pcall(require, name)
	if not ok then
		print(("[hot_reload] Warning: could not load module '%s': %s"):format(name, tostring(mod)))
		mod = nil
	end

	self.watched[name] = {
		path = path,
		mtime = get_mtime(path) or 0,
		module = mod,
	}

	return mod
end

---@param self HotReload
---@return table?, boolean, string?
function M:check()
	for name, info in pairs(self.watched) do
		local mtime = get_mtime(info.path)
		if mtime and mtime ~= info.mtime then
			local mod, err = self:reload_module(name, info.module)
			if mod then
				info.module = mod
				info.mtime = mtime
				print(("[hot_reload] Reloaded '%s'"):format(name))
				return mod, true, name
			end

			print(("[hot_reload] ERROR reloading '%s': %s"):format(name, tostring(err)))
			return info.module, false, name
		end
	end

	return nil, false, nil
end

---@param self HotReload
---@param name string
---@return table?
function M:get(name)
	local info = self.watched[name]
	return info and info.module or nil
end

---@param self HotReload
---@param name string
function M:unwatch(name)
	self.watched[name] = nil
end

---@param self HotReload
---@return string[]
function M:list()
	local names = {}
	for name in pairs(self.watched) do
		names[#names + 1] = name
	end
	return names
end

---@cast M HotReloadModule
return M
