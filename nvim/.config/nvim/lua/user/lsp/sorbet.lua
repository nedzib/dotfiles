require("lspconfig").sorbet.setup({
  root_dir = function(fname)
    return require("lspconfig").util.root_pattern("sorbet/config")(fname)
      or require("lspconfig").util.path.dirname(fname)
  end,
})
