-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>a", "ggVGy+", { desc = "Yank entire file to clipboard" })
map("i", "aa", "<Esc>", { silent = true, desc = "jj to escape" })

map("n", "<leader>rr", "<cmd>luafile $MYVIMRC<cr>", { desc = "Reload Neovim config" })
map("n", "jk", ":", { desc = "Command-line mode" })
