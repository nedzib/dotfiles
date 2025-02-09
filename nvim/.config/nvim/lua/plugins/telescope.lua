return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>gc", false },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "%.irb$", "sorbet/*" },
      },
    })
  end,
}
