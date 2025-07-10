return {
  {
    "luisiacc/gruvbox-baby",
    opts = {
      transparent_mode = true, -- Activa el modo transparente
    },
    config = function()
      vim.g.gruvbox_baby_transparent_mode = 1 -- Alternativamente, puedes activarlo aquí
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-baby",
    },
  },
}
