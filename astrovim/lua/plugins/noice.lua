-- Quiet down ltex, etc.
local null_ls_token = nil
local ltex_token = nil
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local value = result.value
  if not value.kind then
    return
  end

  local client_id = ctx.client_id
  local name = vim.lsp.get_client_by_id(client_id).name

  if name == "null-ls" then
    if result.token == null_ls_token then
      return
    end
    if value.title == "formatting" then
      null_ls_token = result.token
      return
    end
    if value.title == "diagnostics" then
      null_ls_token = result.token
      return
    end
  end
  if name == "info" then
    return
  end

  if name == "ltex" then
    if result.token == ltex_token then
      return
    end
    if value.title == "Checking document" then
      ltex_token = result.token
      return
    end
  end

  vim.notify(value.message, "info", {
    title = value.title,
  })
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    throttle = 1000 / 1,
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      {
        progress = {
          enabled = false,
        },
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
    cmdline = { view = "cmdline" },
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
  },
}
