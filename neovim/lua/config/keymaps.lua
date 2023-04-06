-- Override normal mode commands
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })

-- Add blank lines in normal mode
vim.keymap.set("n", "<C-o>", "O<Esc>", { silent = true })
vim.keymap.set("n", "<CR>", "o<Esc>", { silent = true })

vim.keymap.set("v", "<Leader>s", ":sort<CR>", {
  remap = false,
  desc = "Sort selection",
})
vim.keymap.set("n", "<Leader>r", ":set relativenumber!<CR>", {
  remap = false,
  desc = "Toggle relative numbers",
})
vim.keymap.set("n", "<Leader>d", ":bd<CR>", {
  silent = true,
  remap = false,
  desc = "Close buffer",
})
vim.keymap.set("n", "<Tab>", ":b#<CR>", {
  silent = true,
  remap = false,
  desc = "Switch buffer",
})
vim.keymap.set("n", "<Leader>bw", ":bufdo bwipeout<CR>", {
  silent = true,
  remap = false,
  desc = "Close all buffers",
})
