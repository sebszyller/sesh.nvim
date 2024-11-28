# sesh.nvim

Minimalistic plugin for saving/loading neovim sessions.

`sesh.nvim` keeps track of the last set of open buffers **for a given directory** upon closing nvim.
This is **NOT** a session management plugin a'la workspaces.

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
    index_dir = vim.fn.stdpath("data") .. "/sesh.nvim", -- where to save the session files
    max_files = 1000, -- show warning when there are more than max_files session files
    useless = { "gitcommit", "gitrebase" }, -- do not save these buffers
    verbose = false, -- print INFO messages
}
```

## Usage

`sesh.nvim` exposes three functions:

```lua
require("sesh").save_sesh(path)
require("sesh").load_sesh(path)
require("sesh").file_name(path) -- if you want to build around sesh
```

*I* like to trigger `save_sesh` on `VimLeavePre`, and have a map for `load_sesh`.
The recommended way of using `sesh.nvim` is by passing `path = vim.fn.getcwd()`.

### Under the hood

`sesh.nvim` uses the [djb2](https://theartincode.stanis.me/008-djb2/) hash function to name the saved session files.
Given long paths, and varied dir names, you *should never* run into hash collisions but they *might* happen.

Under the hood, `sesh.nvim` uses regular vim sessions.
It saves only listed buffers with defined buffer/file types.
