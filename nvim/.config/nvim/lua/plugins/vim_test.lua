return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  vim.keymap.set("n", "<leader>tt", ":TestNearest -p<CR>"),
  vim.keymap.set("n", "<leader>tT", ":TestFile -p<CR>"),
  vim.keymap.set("n", "<leader>tl", ":TestLast -p<CR>"),
  vim.keymap.set("n", "<leader>ta", ":TestSuite -p<CR>"),
  vim.keymap.set("n", "<leader>tg", ":TestVisit -p<CR>"),
  vim.cmd("let test#strategy = 'vimux'"),
}
