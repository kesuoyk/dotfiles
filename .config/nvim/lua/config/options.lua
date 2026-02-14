vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "-" }
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 16
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.wildignore:append({ "**/node_modules/**", "**/.git/**", "**/vendor/**" })

local two_space = {
  "css",
  "html",
  "javascript",
  "json",
  "markdown",
  "pug",
  "ruby",
  "sass",
  "scss",
  "smarty",
  "toml",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = two_space,
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

local function apply_vue_highlights()
  vim.api.nvim_set_hl(0, "@tag.vue", { fg = "#8ec07c", bold = true })
  vim.api.nvim_set_hl(0, "@tag.attribute.vue", { fg = "#d79921" })
  vim.api.nvim_set_hl(0, "@string.vue", { fg = "#b8bb26" })
  vim.api.nvim_set_hl(0, "@keyword.vue", { fg = "#fb4934" })
end

vim.api.nvim_create_augroup("VueHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "VueHighlights",
  callback = apply_vue_highlights,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "VueHighlights",
  pattern = "vue",
  callback = apply_vue_highlights,
})

apply_vue_highlights()

require("config.ui").setup()
