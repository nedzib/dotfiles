-- 1) Ajusta a tu Node real (no el shim de nodenv):
--   Apple Silicon (Homebrew): /opt/homebrew/bin/node
--   Intel (Homebrew):        /usr/local/bin/node
local NODE_BIN = "/opt/homebrew/bin/node"

-- 2) Forzar el node host usado por Neovim (para plugins que lo requieren)
vim.g.node_host_prog = NODE_BIN

-- 3) Priorizar el directorio de Node en el PATH interno de Neovim
local node_dir = NODE_BIN:match("(.+)/node$")
if node_dir and #node_dir > 0 then
  vim.env.PATH = node_dir .. ":" .. vim.env.PATH
end

-- 4) Si usas TypeScript LSP (typescript-language-server), anclarlo al Node global
pcall(function()
  local lspconfig = require("lspconfig")
  if lspconfig.tsserver then
    lspconfig.tsserver.setup({
      cmd = { NODE_BIN, "typescript-language-server", "--stdio" },
    })
  end
end)

-- 5) Comando para verificar desde Neovim
vim.api.nvim_create_user_command("NodeVersion", function()
  local v = vim.fn.system(NODE_BIN .. " -v")
  print("Neovim usando Node:", vim.fn.trim(v), "en", NODE_BIN)
end, {})
