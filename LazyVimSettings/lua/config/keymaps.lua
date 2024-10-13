-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Insert mode to Normal mode with 'jj'
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })
