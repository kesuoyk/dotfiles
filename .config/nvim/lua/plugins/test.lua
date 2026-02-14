return {
  {
    "vim-test/vim-test",
    dependencies = { "tpope/vim-dispatch" },
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    keys = {
      { "<leader>tn", "<cmd>TestNearest<CR>" },
      { "<leader>tf", "<cmd>TestFile<CR>" },
      { "<leader>ts", "<cmd>TestSuite<CR>" },
      { "<leader>tl", "<cmd>TestLast<CR>" },
      { "<leader>tg", "<cmd>TestVisit<CR>" },
    },
    init = function()
      vim.g["test#strategy"] = "dispatch"
      vim.g["test#php#phpunit#executable"] = "./vendor/bin/phpunit"
    end,
  },
  { "tpope/vim-dispatch", cmd = { "Dispatch", "Make", "Focus", "Start" } },
}
