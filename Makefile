.PHONY: test clean

# Default command: run all tests
test:
	@echo "Running raylib tests..."
	@luajit test_raylib.lua
	@echo ""
	@echo "Running raymath tests..."
	@luajit test_raymath.lua
	@echo ""
	@echo "All tests passed!"

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
