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
