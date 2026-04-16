# raylua-b

Lua FFI bindings for raylib with full LSP support.

## Requirements

- [LuaJIT](https://luajit.org/) (FFI support required)
- [raylib](https://www.raylib.com/) installed on your system

## Usage

```lua
local rl = require("raylib")

rl.init_window(800, 600, "Hello")
rl.set_target_fps(60)

while not rl.window_should_close() do
    rl.begin_drawing()
    rl.clear_background(rl.BLACK)
    rl.draw_text("Hello World", 350, 280, 20, rl.RAYWHITE)
    rl.end_drawing()
end

rl.close_window()
```

## Files

- `raylib.lua` - Main FFI bindings for raylib
- `raymath.lua` - Math utilities
- `clay.lua` - FFI bindings for Clay UI
- `test_*.lua` - Test suites

## Testing

```bash
make test           # Run all tests
luajit test_clay.lua  # Run clay tests only
```

## License

Modified Public Domain - see LICENSE
