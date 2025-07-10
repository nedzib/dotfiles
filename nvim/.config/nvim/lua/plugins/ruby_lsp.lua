-- lua/plugins/ruby_lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")

      -- Capacidades compartidas con codificación explícita
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-16" }

      opts.servers = {
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
          init_options = {
            formatter = "auto",
            linters = {},
          },
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern("sorbet/config"),
        },
        sorbet = {
          mason = false,
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern("sorbet/config"),
        },
      }
    end,
  },
}
