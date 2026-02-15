return {
  { "morhetz/gruvbox", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("gruvbox") end },
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules/",
          "%.git/",
          "dist/",
          "build/",
          "%.next/",
          "coverage/",
          "vendor/bundle/",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--glob=!**/node_modules/**",
          "--glob=!**/.git/**",
          "--glob=!**/dist/**",
          "--glob=!**/build/**",
          "--glob=!**/.next/**",
          "--glob=!**/coverage/**",
          "--glob=!**/vendor/bundle/**",
        },
      },
    },
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
