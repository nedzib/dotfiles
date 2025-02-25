return {
  {
    "hrsh7th/nvim-cmp", -- complemento principal
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- fuente para LSP
      "hrsh7th/cmp-buffer", -- fuente para búfer
      "hrsh7th/cmp-path", -- fuente para rutas de archivos
      "saadparwaiz1/cmp_luasnip", -- integración con luasnip
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
      })
    end,
  },
}
