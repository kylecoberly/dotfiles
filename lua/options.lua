--
-- GENERAL
--
-- Add title to bar
vim.o.title = true
-- Disable dings
vim.o.errorbells = false
-- Enable visual dings
vim.o.visualbell = false
-- Disable wrapping
vim.o.wrap = false
-- Enable mouse mode
vim.o.mouse = "a"
-- Enable break indent
vim.o.breakindent = true
-- Allow terminals to run in background
vim.o.hidden = true
-- Better colors
vim.o.termguicolors = true
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"
-- Save undo history
vim.o.undofile = true

--
-- PERFORMANCE
--
-- Don't redraw during macros
vim.o.lazyredraw = true
-- Don't create these files
vim.o.backup = false
vim.o.swapfile = false
-- Decrease update time
vim.o.updatetime = 150
vim.o.timeout = true
vim.o.timeoutlen = 300

--
-- SEARCH
--
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Highlight matches on search
vim.o.hlsearch = false

-- Add highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
