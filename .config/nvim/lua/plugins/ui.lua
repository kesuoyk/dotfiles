return {
  {
    "f-person/auto-dark-mode.nvim",
    lazy=false,
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "ruby",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      },
      enable_indent = true,
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("NvimTreesitterStart", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          if opts.enable_indent then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },
  { "ntpeters/vim-better-whitespace", event = { "BufReadPost", "BufNewFile" } },
  {
    "junegunn/vim-easy-align",
    keys = {
      { "gA", "<Plug>(EasyAlign)", mode = { "n", "x" } },
    },
  },
  { "michaeljsmith/vim-indent-object", event = "VeryLazy" },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
    init = function()
      vim.g["surround_" .. vim.fn.char2nr("「")] = "「 \r 」"
      vim.g["surround_" .. vim.fn.char2nr("」")] = "「\r」"
      vim.g["surround_" .. vim.fn.char2nr("【")] = "【 \r 】"
      vim.g["surround_" .. vim.fn.char2nr("】")] = "【\r】"
      vim.g["surround_" .. vim.fn.char2nr("（")] = "（ \r ）"
      vim.g["surround_" .. vim.fn.char2nr("）")] = "（\r）"
      vim.g["surround_" .. vim.fn.char2nr("＜")] = "＜ \r ＞"
      vim.g["surround_" .. vim.fn.char2nr("＞")] = "＜\r＞"
      vim.g["surround_" .. vim.fn.char2nr("｛")] = "｛ \r ｝"
      vim.g["surround_" .. vim.fn.char2nr("｝")] = "｛\r｝"
    end,
  },
  { "tpope/vim-abolish", cmd = { "Subvert", "S", "Abolish" }, keys = { "cr", "co", "cn" } },
  {
    "glidenote/memolist.vim",
    cmd = { "MemoNew", "MemoList", "MemoGrep" },
    keys = {
      { "<leader>mn", "<cmd>vnew | wincmd L | vertical resize 50 | set winfixwidth | set nonumber | MemoNew<CR>" },
      { "<leader>ml", "<cmd>vnew | wincmd L | vertical resize 50 | set winfixwidth | set nonumber | MemoList<CR>" },
      { "<leader>mg", "<cmd>vnew | wincmd L | vertical resize 50 | set winfixwidth | set nonumber | MemoGrep<CR>" },
    },
    init = function()
      vim.g.memolist_memo_suffix = "md"
    end,
  },
  {
    "mattn/emmet-vim",
    ft = { "html", "vue", "tsx", "typescriptreact" },
    init = function()
      vim.g.user_emmet_mode = "a"
      vim.g.user_emmet_leader_key = "<C-Y>"
    end,
  },
  {
    "vim-jp/vimdoc-ja",
    ft = "help",
    init = function()
      vim.opt.helplang = "ja"
    end,
  },
  {
    "kibi2/tirenvi.nvim",
    ft = { "csv", "tsv" },
    config = function()
      require("tirenvi").setup()
      vim.keymap.set({ 'n', 'o', 'x' }, '<leader>tf', require('tirenvi').motion.f, { expr = true })
      vim.keymap.set({ 'n', 'o', 'x' }, '<leader>tF', require('tirenvi').motion.F, { expr = true })
      vim.keymap.set({ 'n', 'o', 'x' }, '<leader>tt', require('tirenvi').motion.t, { expr = true })
      vim.keymap.set({ 'n', 'o', 'x' }, '<leader>tT', require('tirenvi').motion.T, { expr = true })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_browser = vim.env.NVIM_MKDP_BROWSER or ''
    end
  },
}
