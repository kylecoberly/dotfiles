-- Feed theme/palette.lua into tokyonight so nvim, starship, alacritty, and
-- tmux-nova all draw from the same source of truth. The chezmoi source repo
-- lives at ~/dotfiles by convention; without it, tokyonight defaults apply.
local function load_palette()
  local ok, palette = pcall(dofile, vim.fs.normalize("~/dotfiles/theme/palette.lua"))
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
