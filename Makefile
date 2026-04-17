.DEFAULT_GOAL := test

.PHONY: test clean help install libclay vendor all setup

# LuaUnit repository and file location
LUAUNIT_REPO := https://github.com/bluebird75/luaunit.git
LUAUNIT_FILE := vendor/luaunit.lua

# Clay repository and pinned header version
# Pinned to the current upstream main commit that matches these bindings.
CLAY_REPO := https://github.com/nicbarker/clay.git
CLAY_VERSION := main
CLAY_COMMIT := 938967ac9a62d3115bc25f8e4827cd46567f4bca
CLAY_HEADER_FILE := vendor/clay.h
CLAY_HEADER_URL := https://raw.githubusercontent.com/nicbarker/clay/$(CLAY_COMMIT)/clay.h

# Clay shared library build settings
CC ?= cc
CLAY_CFLAGS ?= -O2 -std=c99 -fPIC
CLAY_LDFLAGS ?= -shared
CLAY_LIB := libclay.so

# Install locations
DESTDIR ?=
SUDO ?= $(shell if [ "$$(id -u)" -eq 0 ]; then printf ''; else printf 'sudo'; fi)
RAYLIB_INCLUDE_DIR ?= $(shell pkg-config --variable=includedir raylib 2>/dev/null || printf '%s\n' /usr/local/include)
RAYLIB_LIB_DIR ?= $(shell pkg-config --variable=libdir raylib 2>/dev/null || printf '%s\n' /usr/local/lib)
LUA_MODULE_DIR ?= $(shell luajit -e 'for p in string.gmatch(package.path, "[^;]+") do local d = p:match("^(.*)/%?%.lua$$") or p:match("^(.*)/%?/init%.lua$$"); if d and d:sub(1,1) == "/" then print(d); os.exit(0) end end' 2>/dev/null || printf '%s\n' /usr/local/share/lua/5.1)
LUA_MODULES := raylib.lua raymath.lua clay.lua hot_reload.lua

# Default command: fetch test deps and run all tests
all: test

test: $(LUAUNIT_FILE)
	@echo "Running raylib tests..."
	@luajit test_raylib.lua
	@echo ""
	@echo "Running raymath tests..."
	@luajit test_raymath.lua
	@echo ""
	@echo "Running clay tests..."
	@luajit test_clay.lua
	@echo ""
	@echo "Running hot_reload tests..."
	@luajit test_hot_reload.lua
	@echo ""
	@echo "All tests passed!"

# Convenience aliases
vendor: $(LUAUNIT_FILE) $(CLAY_HEADER_FILE)
libclay: $(CLAY_LIB)
setup: vendor
	@echo "Setup complete. Vendored dependencies are present."

vendor/:
	@mkdir -p vendor

$(LUAUNIT_FILE): | vendor/
	@echo "Fetching luaunit.lua from $(LUAUNIT_REPO)..."
	@LATEST_TAG=$$(git ls-remote --tags $(LUAUNIT_REPO) | grep -v '\^{}' | grep 'refs/tags/LUAUNIT_V' | sed 's/.*refs\/tags\///' | sort -t '_' -k2 -n | tail -1); \
	echo "Using latest release: $$LATEST_TAG"; \
	curl -sfL "https://raw.githubusercontent.com/bluebird75/luaunit/$$LATEST_TAG/luaunit.lua" -o $(LUAUNIT_FILE) || curl -sfL "https://raw.githubusercontent.com/bluebird75/luaunit/master/luaunit.lua" -o $(LUAUNIT_FILE); \
	echo "Downloaded luaunit.lua to $(LUAUNIT_FILE)"

$(CLAY_HEADER_FILE): | vendor/
	@echo "Fetching clay.h $(CLAY_VERSION) from $(CLAY_REPO)..."
	@curl -sfL "$(CLAY_HEADER_URL)" -o $(CLAY_HEADER_FILE)
	@echo "Downloaded clay.h $(CLAY_VERSION) ($(CLAY_COMMIT)) to $(CLAY_HEADER_FILE)"

$(CLAY_LIB): clay_impl.c $(CLAY_HEADER_FILE)
	@echo "Building $(CLAY_LIB)..."
	@$(CC) $(CLAY_CFLAGS) $(CLAY_LDFLAGS) -o $(CLAY_LIB) clay_impl.c

install: $(CLAY_LIB) $(LUA_MODULES) $(CLAY_HEADER_FILE)
	@echo "Installing Lua modules to $(DESTDIR)$(LUA_MODULE_DIR)..."
	@echo "Installing $(CLAY_LIB) to $(DESTDIR)$(RAYLIB_LIB_DIR)..."
	@echo "Installing clay.h to $(DESTDIR)$(RAYLIB_INCLUDE_DIR)..."
	@set -e; \
	if [ -n "$(DESTDIR)" ] || [ "$$(id -u)" -eq 0 ]; then \
		install -d "$(DESTDIR)$(LUA_MODULE_DIR)" "$(DESTDIR)$(RAYLIB_LIB_DIR)" "$(DESTDIR)$(RAYLIB_INCLUDE_DIR)"; \
		install -m 644 $(LUA_MODULES) "$(DESTDIR)$(LUA_MODULE_DIR)/"; \
		install -m 755 $(CLAY_LIB) "$(DESTDIR)$(RAYLIB_LIB_DIR)/$(CLAY_LIB)"; \
		install -m 644 $(CLAY_HEADER_FILE) "$(DESTDIR)$(RAYLIB_INCLUDE_DIR)/clay.h"; \
	else \
		$(SUDO) install -d "$(LUA_MODULE_DIR)" "$(RAYLIB_LIB_DIR)" "$(RAYLIB_INCLUDE_DIR)"; \
		$(SUDO) install -m 644 $(LUA_MODULES) "$(LUA_MODULE_DIR)/"; \
		$(SUDO) install -m 755 $(CLAY_LIB) "$(RAYLIB_LIB_DIR)/$(CLAY_LIB)"; \
		$(SUDO) install -m 644 $(CLAY_HEADER_FILE) "$(RAYLIB_INCLUDE_DIR)/clay.h"; \
	fi
	@echo "Install complete."

# Clean up generated files
clean:
	@rm -f *.o *.so

# Help
help:
	@echo "Available commands:"
	@echo "  make          - Run all tests (raylib, raymath, clay, hot_reload)"
	@echo "  make test     - Run all tests"
	@echo "  make all      - Run all tests"
	@echo "  make vendor   - Download vendored dependencies (luaunit, clay.h)"
	@echo "  make libclay  - Build libclay.so only"
	@echo "  make setup    - Download vendored dependencies"
	@echo "  make install  - Build/install libclay.so, then install Lua modules and clay.h"
	@echo "                 Defaults to raylib's include/lib dirs via pkg-config"
	@echo "  make clean    - Clean up generated files"
	@echo "  make help     - Show this help"
