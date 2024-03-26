-- Override normal mode commands
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })

vim.keymap.set("v", "<Leader>s", ":sort<CR>", {
  remap = false,
  desc = "Sort selection",
})
vim.keymap.set("n", "<Leader>do", vim.lsp.buf.code_action, {
  silent = true,
  remap = false,
  desc = "Do code action",
})
vim.keymap.set("n", "<Leader>bw", ":bufdo bwipeout<CR>", {
  silent = true,
  remap = false,
  desc = "Close all buffers",
})

-- Remap Tabs
vim.keymap.set("n", "<Leader>t[", ":tabprevious<CR>", {
  silent = true,
  remap = false,
  desc = "Previous Tab",
})
vim.keymap.set("n", "<Leader>t]", ":tabnext<CR>", {
  silent = true,
  remap = false,
  desc = "Next Tab",
})
vim.keymap.set("n", "<Leader>td", ":tabclose<CR>", {
  silent = true,
  remap = false,
  desc = "Close Tab",
})
vim.keymap.set("n", "<Leader>tt", ":tabnew<CR>", {
  silent = true,
  remap = false,
  desc = "New Tab",
})
vim.keymap.set("n", "<Leader>tf", ":tabfirst<CR>", {
  silent = true,
  remap = false,
  desc = "First Tab",
})
vim.keymap.set("n", "<Leader>tl", ":tablast<CR>", {
  silent = true,
  remap = false,
  desc = "Last Tab",
})
