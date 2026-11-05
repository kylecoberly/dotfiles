-- Jupyter notebooks in Neovim: jupytext.nvim converts .ipynb <-> plain python
-- (hydrogen `# %%` cells) on open/save, molten.nvim runs cells in a real kernel.
--
-- One-time setup per project: register the project venv as a kernel so MoltenInit
-- can see it:  uv run python -m ipykernel install --user --name <project>

-- molten is a remote plugin, so its python host needs pynvim + jupyter_client.
-- Those live in a dedicated venv (uv venv ~/.local/share/nvim/venv).
vim.g.python3_host_prog = vim.fn.expand "~/.local/share/nvim/venv/bin/python"

local CELL_MARKER = "^# %%%%"

-- Returns 1-indexed [first, last] line of the `# %%` cell containing the cursor.
local function cell_range()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local first = 1
  for i = cur, 1, -1 do
    if lines[i]:match(CELL_MARKER) then
      first = i + 1
      break
    end
  end
  local last = #lines
  for i = cur + 1, #lines do
    if lines[i]:match(CELL_MARKER) then
      last = i - 1
      break
    end
  end
  return first, last
end

local function run_cell()
  local first, last = cell_range()
  vim.fn.MoltenEvaluateRange(first, last)
end

local function goto_next_cell()
  local _, last = cell_range()
  local line_count = vim.api.nvim_buf_line_count(0)
  if last < line_count then vim.api.nvim_win_set_cursor(0, { math.min(last + 2, line_count), 0 }) end
end

local function goto_prev_cell()
  local first = cell_range()
  if first <= 2 then return end
  vim.api.nvim_win_set_cursor(0, { first - 1, 0 })
  local prev_first = cell_range()
  vim.api.nvim_win_set_cursor(0, { prev_first, 0 })
end

---@type LazySpec
return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = { style = "hydrogen" },
  },
  {
    -- Renders images via the kitty graphics protocol (ghostty supports it)
    "3rd/image.nvim",
    build = false, -- magick_cli shells out to imagemagick; no rock to build
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {},
      max_width = 100,
      max_height = 12,
      -- molten sizes its output window to the image, so window-percentage caps break it
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      tmux_show_only_in_active_window = true,
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    lazy = false,
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_text_max_lines = 20
      vim.g.molten_output_win_max_height = 30
      vim.g.molten_wrap_output = true
      vim.g.molten_use_border_highlights = true
      -- molten writes kernel connection files here and fails if it doesn't exist;
      -- normally jupyter itself creates it on first run
      vim.fn.mkdir(vim.fn.expand "~/Library/Jupyter/runtime", "p")
    end,
    dependencies = {
      "3rd/image.nvim",
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<LocalLeader>m"] = { desc = "Molten kernel" },
              ["<LocalLeader>mi"] = { "<cmd>MoltenInit<cr>", desc = "Init kernel" },
              ["<LocalLeader>mr"] = { "<cmd>MoltenRestart!<cr>", desc = "Restart kernel (clear outputs)" },
              ["<LocalLeader>mx"] = { "<cmd>MoltenInterrupt<cr>", desc = "Interrupt kernel" },
              ["<LocalLeader>mI"] = { "<cmd>MoltenImportOutput<cr>", desc = "Import outputs from .ipynb" },
              ["<LocalLeader>mE"] = { "<cmd>MoltenExportOutput!<cr>", desc = "Export outputs to .ipynb" },
              ["<LocalLeader>m?"] = { "<cmd>MoltenInfo<cr>", desc = "Molten info" },

              ["<LocalLeader>r"] = { desc = "Run" },
              ["<LocalLeader>rc"] = { run_cell, desc = "Run cell" },
              ["<LocalLeader>rn"] = {
                function()
                  run_cell()
                  goto_next_cell()
                end,
                desc = "Run cell and go to next",
              },
              ["<LocalLeader>rl"] = { "<cmd>MoltenEvaluateLine<cr>", desc = "Run line" },
              ["<LocalLeader>rr"] = { "<cmd>MoltenReevaluateCell<cr>", desc = "Re-run cell" },
              ["<LocalLeader>e"] = { "<cmd>MoltenEvaluateOperator<cr>", desc = "Run motion" },

              ["<LocalLeader>o"] = { desc = "Output" },
              ["<LocalLeader>os"] = { "<cmd>MoltenShowOutput<cr>", desc = "Show output" },
              ["<LocalLeader>oh"] = { "<cmd>MoltenHideOutput<cr>", desc = "Hide output" },
              ["<LocalLeader>oe"] = { "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Enter output window" },
              ["<LocalLeader>od"] = { "<cmd>MoltenDelete<cr>", desc = "Delete cell output" },

              ["<LocalLeader>j"] = { goto_next_cell, desc = "Next cell" },
              ["<LocalLeader>k"] = { goto_prev_cell, desc = "Previous cell" },
            },
            v = {
              ["<LocalLeader>r"] = { ":<C-u>MoltenEvaluateVisual<cr>gv", desc = "Run selection" },
            },
          },
      },
      },
    },
  },
}
