return {
  { "morhetz/gruvbox", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("gruvbox") end },
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sf", "<cmd>Telescope find_files<CR>" },
      { "<leader>sg", "<cmd>Telescope live_grep<CR>" },
      { "<leader>sb", "<cmd>Telescope buffers<CR>" },
      { "<leader>sh", "<cmd>Telescope command_history<CR>" },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {
      keymaps = {
        ["H"] = "actions.parent",
        ["L"] = "actions.select",
        ["-"] = false,
        ["<CR>"] = "actions.select",
        ["<C-l>"] = "actions.refresh",
      },
    },
    keys = {
      { "<leader>e ", function() require("oil").open(vim.fn.getcwd()) end },
      { "<leader>e.", function() require("oil").open(vim.fn.expand("%:p:h")) end },
    },
  },
}
