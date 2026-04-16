.DEFAULT_GOAL := test

.PHONY: test clean help install libclay vendor all

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
RAYLIB_INCLUDE_DIR ?= $(shell pkg-config --variable=includedir raylib 2>/dev/null || printf '%s\n' /usr/local/include)
RAYLIB_LIB_DIR ?= $(shell pkg-config --variable=libdir raylib 2>/dev/null || printf '%s\n' /usr/local/lib)
LUA_MODULE_DIR ?= $(shell luajit -e 'for p in string.gmatch(package.path, "[^;]+") do local d = p:match("^(.*)/%?%.lua$$") or p:match("^(.*)/%?/init%.lua$$"); if d and d:sub(1,1) == "/" then print(d); os.exit(0) end end' 2>/dev/null || printf '%s\n' /usr/local/share/lua/5.1)

# Default command: fetch deps, build local clay test library, and run all tests
all: test

test: $(LUAUNIT_FILE) $(CLAY_LIB)
	@echo "Running raylib tests..."
	@luajit test_raylib.lua
	@echo ""
	@echo "Running raymath tests..."
	@luajit test_raymath.lua
	@echo ""
	@echo "Running clay tests..."
	@LD_LIBRARY_PATH="$(CURDIR):$$LD_LIBRARY_PATH" luajit test_clay.lua
	@echo ""
	@echo "All tests passed!"

# Convenience aliases
vendor: $(LUAUNIT_FILE) $(CLAY_HEADER_FILE)
libclay: $(CLAY_LIB)

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

install: clay.lua $(CLAY_LIB) $(CLAY_HEADER_FILE)
	@echo "Installing clay.lua to $(DESTDIR)$(LUA_MODULE_DIR)..."
	@echo "Installing clay.h to $(DESTDIR)$(RAYLIB_INCLUDE_DIR)..."
	@echo "Installing $(CLAY_LIB) to $(DESTDIR)$(RAYLIB_LIB_DIR)..."
	@install -d "$(DESTDIR)$(LUA_MODULE_DIR)" "$(DESTDIR)$(RAYLIB_INCLUDE_DIR)" "$(DESTDIR)$(RAYLIB_LIB_DIR)"
	@install -m 644 clay.lua "$(DESTDIR)$(LUA_MODULE_DIR)/clay.lua"
	@install -m 644 $(CLAY_HEADER_FILE) "$(DESTDIR)$(RAYLIB_INCLUDE_DIR)/clay.h"
	@install -m 755 $(CLAY_LIB) "$(DESTDIR)$(RAYLIB_LIB_DIR)/$(CLAY_LIB)"
	@echo "Install complete. You may need sudo if these directories are system-owned."

# Clean up generated files
clean:
	@rm -f *.o *.so

# Help
help:
	@echo "Available commands:"
	@echo "  make          - Run all tests"
	@echo "  make test     - Run all tests"
	@echo "  make all      - Run all tests"
	@echo "  make vendor   - Download vendored dependencies"
	@echo "  make libclay  - Build libclay.so only"
	@echo "  make install  - Install clay.lua, clay.h, and libclay.so"
	@echo "                 Defaults to raylib's include/lib dirs via pkg-config"
	@echo "  make clean    - Clean up generated files"
	@echo "  make help     - Show this help"
