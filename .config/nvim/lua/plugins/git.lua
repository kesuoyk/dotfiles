return {
  { "tpope/vim-fugitive", keys = { { "<leader>g", "<cmd>Git<CR>" } } },
  { "tpope/vim-rhubarb", lazy = true },
  { "yaktak/sestry.vim" },
  {
    "ToruIwashita/git-switcher.vim",
    init = function()
      vim.g.gsw_save_session_confirm = "yes"
      vim.g.gsw_autoload_session = "confirm"
      vim.g.gsw_autodelete_sessions_if_branch_not_exists = "confirm"
    end,
  },
  { "github/copilot.vim" },
  { "CopilotC-Nvim/CopilotChat.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
}
