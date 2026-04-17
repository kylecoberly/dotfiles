-- Avante.nvim: Cursor-style AI assistant.
-- Routed through the Claude Code ACP bridge so it uses the `claude` CLI's auth
-- (OAuth/Max subscription) instead of a standalone ANTHROPIC_API_KEY.
--
-- Requirements:
--   - `claude` CLI installed and logged in (`claude /login`)
--   - `npm i -g @zed-industries/claude-code-acp` under the active mise Node.
--     Global npm installs are scoped per-Node-version in mise, so if you
--     upgrade Node you'll need to reinstall the ACP bridge.
--
-- If you ever want to bypass ACP and go straight to the API, set
--   provider = "claude"
-- and uncomment the providers.claude block below, then export ANTHROPIC_API_KEY.

---@type LazySpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "claude-code",
    mode = "agentic",
    -- We invoke node directly with the ACP script because nvim-spawned
    -- subprocesses don't have mise's PATH, so `#!/usr/bin/env node` in the
    -- claude-code-acp binary would fail to find the node interpreter.
    acp_providers = {
      ["claude-code"] = {
        command = vim.fn.expand("~/.local/share/mise/installs/node/24.15.0/bin/node"),
        args = {
          vim.fn.expand("~/.local/share/mise/installs/node/24.15.0/lib/node_modules/@zed-industries/claude-code-acp/dist/index.js"),
        },
        env = {
          NODE_NO_WARNINGS = "1",
        },
      },
    },
    -- providers = {
    --   claude = {
    --     endpoint = "https://api.anthropic.com",
    --     model = "claude-sonnet-4-6",
    --     timeout = 30000,
    --     extra_request_body = { temperature = 0, max_tokens = 8192 },
    --   },
    -- },
    behaviour = {
      auto_suggestions = false,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      minimize_diff = true,
      auto_add_current_file = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/snacks.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
}
