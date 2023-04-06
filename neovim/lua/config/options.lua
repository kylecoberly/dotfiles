-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--
--INDENTATION
--
-- Tabs count as 4 spaces
vim.opt.tabstop = 4
-- Tabs insead of spaces
vim.opt.expandtab = false
-- Automatic indent size
vim.opt.shiftwidth = 4
-- Keep indentation level with word wrap
vim.opt.breakindent = true

--
-- PERFORMANCE
--
-- Allow terminals to run in background
vim.opt.hidden = true
-- Don't create these files
vim.opt.backup = false
vim.opt.swapfile = false
-- Decrease update time
vim.opt.updatetime = 150
vim.opt.timeout = true
vim.opt.timeoutlen = 300

--
-- SEARCH
--
-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Highlight matches on search
vim.opt.hlsearch = false

--
-- NOTIFICATIONS
--
-- Turn off dings
vim.opt.errorbells = false
-- Enable visual dings
vim.opt.visualbell = false
