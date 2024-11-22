# sesh.nvim

Minimalistic plugin for saving/loading neovim sessions.

## Installation

Use in `lazy`:

```lua
{
	"sebszyller/sesh.nvim",
    opts = {
        -- your configuration
    }
}
```

## Configuration

Customise the default `opts`:

```lua
opts = {
    index_dir = vim.fn.stdpath("data") .. "/sesh_index", -- where to save the session files
    max_files = 1000, -- show warning when there are more than max_files session files
}
```

### Usage

`sesh.nvim` exposes three functions:

```lua
require("sesh").save_sesh(path)
require("sesh").load_sesh(path)
require("sesh").file_name(path) -- if you want to build around sesh
```

*I* like to trigger `save_sesh` on `VimLeavePre`, and have a map for `load_sesh`.

`sesh.nvim` uses the [djb2](https://theartincode.stanis.me/008-djb2/) hash function to name the saved session files.
The recommended way of using `sesh.nvim` is by passing the `path = vim.fn.getcwd()`.
Given long paths, and varied dir names, you *should never* run into hash collisions but they *might* happen.

