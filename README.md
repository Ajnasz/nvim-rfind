# NVIM Rsearch

Script which helps to populate the search command within the selected visual
range. See [search-range](https://neovim.io/doc/user/pattern.html#search-range)


https://github.com/Ajnasz/nvim-rfind/assets/38329/22a19eea-76de-4475-b41f-f6ae91ef0526


## Setting a keymap

It turned out the plugin is not needed to search in visual select, just just the [`\%V` atom] in the search expression

```lua
(vim.keymap.set "x" "/" "<Esc>/\\%V")
```
***

```lua
local vfind = require("rfind")
vim.keymap.set("x", "/", vfind.visual)
vim.keymap.set("n", "<F7>", vfind.visual)
```

Then press `/` in visual mode or `F7` in normal mode to search in the last
selected section.

## Custom command

```lua
local rfind = require("rfind")
vim.api.nvim_create_user_command(
    "RangeFind",
    function(opts)
        return rfind.range(opts.fargs[1], opts.fargs[2])
    end,
    {nargs = "*"}
)
```

Then typing `RangeFind 10 50` will start the search between lines 10 and 50 (inclusive).
