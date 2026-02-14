return {
  {
    "vim-test/vim-test",
    dependencies = { "tpope/vim-dispatch" },
    init = function()
      vim.g["test#strategy"] = "dispatch"
      vim.g["test#php#phpunit#executable"] = "./vendor/bin/phpunit"
      vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<CR>")
      vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<CR>")
      vim.keymap.set("n", "<leader>ts", "<cmd>TestSuite<CR>")
      vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<CR>")
      vim.keymap.set("n", "<leader>tg", "<cmd>TestVisit<CR>")
    end,
  },
  { "tpope/vim-dispatch" },
}
