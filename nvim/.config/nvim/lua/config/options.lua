-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options before

-- Molten and other python plugins
vim.g.python3_host_prog = "/Users/navenprasad/miniforge3/envs/torch/bin/python"

-- Add conda env to PATH for plugins that call binaries (like jupytext)
vim.env.PATH = "/Users/navenprasad/miniforge3/envs/torch/bin:" .. vim.env.PATH
