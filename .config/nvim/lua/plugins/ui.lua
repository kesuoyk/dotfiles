return {
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
      ts.setup({})

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
  { "numToStr/Comment.nvim", opts = {} },
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
  { "ntpeters/vim-better-whitespace" },
  { "junegunn/vim-easy-align" },
  { "michaeljsmith/vim-indent-object" },
  {
    "tpope/vim-surround",
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
  { "tpope/vim-abolish" },
  {
    "glidenote/memolist.vim",
    init = function()
      vim.g.memolist_memo_suffix = "md"
    end,
  },
  {
    "mattn/emmet-vim",
    ft = { "php", "blade", "html", "vue", "tsx", "typescriptreact", "smarty" },
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
}
