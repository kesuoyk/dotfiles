return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread", "Gblame" },
    keys = {
      { "<leader>g", "<cmd>Git<CR>" },
      { "<leader>gq", "<cmd>Git<CR>" },
    },
  },
  { "tpope/vim-rhubarb", lazy = true },
  { "yaktak/sestry.vim", event = "VeryLazy" },
  {
    "ToruIwashita/git-switcher.vim",
    lazy = false,
    init = function()
      vim.g.gsw_save_session_confirm = "yes"
      vim.g.gsw_autoload_session = "confirm"
      vim.g.gsw_autodelete_sessions_if_branch_not_exists = "confirm"
    end,
  },
  { "github/copilot.vim", event = "InsertEnter" },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
    },
    opts = {},
  },
}
