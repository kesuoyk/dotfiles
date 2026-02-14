local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  defaults = { lazy = true },
  spec = {
    { import = "plugins.core" },
    { import = "plugins.lsp" },
    { import = "plugins.coding" },
    { import = "plugins.ui" },
    { import = "plugins.git" },
    { import = "plugins.test" },
  },
  change_detection = { notify = false },
})
