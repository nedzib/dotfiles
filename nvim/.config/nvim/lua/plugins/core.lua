-- ~/.config/nvim/lua/plugins/auto-dark-gruvbox-material.lua
-- Sincroniza el tema gruvbox-material con el modo del sistema (macOS)
return {
  "f-person/auto-dark-mode.nvim",
  lazy = false, -- cargar al inicio
  priority = 1000, -- antes que otros plugins de UI/tema
  dependencies = {
    "sainnhe/gruvbox-material",
  },
  opts = {
    update_interval = 1000, -- ms: verifica el modo del sistema cada segundo
    set_dark_mode = function()
      -- Opciones recomendadas por gruvbox-material (ajústalas a tu gusto)
      vim.g.gruvbox_material_palette = "material" -- "material" | "mix" | "original"
      vim.g.gruvbox_material_background = "medium" -- "soft" | "medium" | "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox-material")
    end,
    set_light_mode = function()
      -- Para la versión clara, el mismo esquema respeta vim.o.background = "light"
      vim.g.gruvbox_material_palette = "material" -- puedes usar "mix" u "original" si prefieres
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.o.background = "light"
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  config = function(_, opts)
    local ok, adm = pcall(require, "auto-dark-mode")
    if not ok then
      return
    end
    adm.setup(opts)
    adm.init()
  end,
}
