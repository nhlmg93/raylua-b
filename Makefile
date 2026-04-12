.PHONY: test clean vendor

# LuaUnit repository and file location
LUAUNIT_REPO := https://github.com/bluebird75/luaunit.git
LUAUNIT_FILE := vendor/luaunit.lua

# Default command: run all tests (must be first target)
test: vendor
	@echo "Running raylib tests..."
	@luajit test_raylib.lua
	@echo ""
	@echo "Running raymath tests..."
	@luajit test_raymath.lua
	@echo ""
	@echo "All tests passed!"

# Ensure vendor directory exists with luaunit.lua
vendor:
	@if [ ! -d "vendor" ]; then \
		echo "Creating vendor directory..."; \
		mkdir -p vendor; \
	fi
	@if [ ! -f "$(LUAUNIT_FILE)" ]; then \
		echo "Fetching luaunit.lua from $(LUAUNIT_REPO)..."; \
		LATEST_TAG=$$(git ls-remote --tags $(LUAUNIT_REPO) | grep -v '\^{}' | grep 'refs/tags/LUAUNIT_V' | sed 's/.*refs\/tags\///' | sort -t '_' -k2 -n | tail -1); \
		echo "Using latest release: $$LATEST_TAG"; \
		curl -sfL "https://raw.githubusercontent.com/bluebird75/luaunit/$$LATEST_TAG/luaunit.lua" -o $(LUAUNIT_FILE) || curl -sfL "https://raw.githubusercontent.com/bluebird75/luaunit/master/luaunit.lua" -o $(LUAUNIT_FILE); \
		echo "Downloaded luaunit.lua to $(LUAUNIT_FILE)"; \
	fi

# Clean up any generated files
clean:
	@rm -f *.o *.so

# Help
help:
	@echo "Available commands:"
	@echo "  make        - Run all tests (default)"
	@echo "  make test   - Run all tests"
	@echo "  make clean  - Clean up generated files"
	@echo "  make help   - Show this help"
