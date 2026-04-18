-- Feed theme/palette.lua into tokyonight so nvim, starship, alacritty, and
-- tmux-nova all draw from the same source of truth. Resolves via the symlink
-- chain (init.lua → dotfiles/shared/nvim) so it works outside ~/dotfiles.
local function load_palette()
  local this = debug.getinfo(1, "S").source:sub(2)
  local real = (vim.uv or vim.loop).fs_realpath(this) or this
  local dotfiles_root = vim.fs.normalize(vim.fs.dirname(real) .. "/../../../..")
  local ok, palette = pcall(dofile, dotfiles_root .. "/theme/palette.lua")
  if ok then return palette end
end

return {
  "folke/tokyonight.nvim",
  opts = {
    on_colors = function(colors)
      local palette = load_palette()
      if not palette then return end
      for k, v in pairs(palette) do
        colors[k] = v
      end
    end,
  },
}
