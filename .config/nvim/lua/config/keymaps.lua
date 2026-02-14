local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

map("i", "<C-b>", "<C-o>h")
map("i", "<C-f>", "<C-o>l")

map("c", "<C-p>", "<Up>")
map("c", "<C-n>", "<Down>")
map("c", "<C-b>", "<Left>")
map("c", "<C-f>", "<Right>")
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<C-d>", "<Del>")

map("n", "k", "gk")
map("n", "gk", "k")
map("n", "j", "gj")
map("n", "gj", "j")

map("n", "<C-p>", "<C-w>W")
map("n", "<C-n>", "<C-w><C-w>")
map("t", "<C-\\>", "<C-\\><C-n>")
map("t", "<C-¥>", "<C-\\><C-n>")

map("n", "]q", "<cmd>cnext<CR>")
map("n", "[q", "<cmd>cprevious<CR>")

map("n", "K", vim.lsp.buf.hover)
map("n", "gn", vim.lsp.buf.rename)
map("n", "ga", vim.lsp.buf.code_action)
map("n", "gr", vim.lsp.buf.references)
map("n", "gd", vim.diagnostic.open_float)
map("n", "]d", vim.lsp.buf.definition)

map("n", "<leader>,<space>", "<cmd>tabnew $MYVIMRC<CR>", { silent = true })
map("n", "<leader>,r", "<cmd>source $MYVIMRC<CR>", { silent = true })

map("n", "<leader>q ", "<cmd>q<CR>", { silent = true })
map("n", "<leader>qa ", "<cmd>qa<CR>", { silent = true })
map("n", "<leader>w ", "<cmd>w<CR>", { silent = true })
map("n", "<leader>wq ", "<cmd>wq<CR>", { silent = true })
map("n", "<leader>wqa ", "<cmd>wqa<CR>", { silent = true })

map("n", "<leader>rp", '"0p', { silent = true })
map("n", "<leader>o", "o<Esc>")
map("n", "<leader>O", "O<Esc>")
map("n", "<leader>p", function()
  vim.o.paste = not vim.o.paste
  print(vim.o.paste and "Paste mode on" or "Paste mode off")
end, { silent = true })
map("n", "<leader>wt", function()
  vim.wo.wrap = not vim.wo.wrap
  print(vim.wo.wrap and "wrap on" or "wrap off")
end, { silent = true })

map("n", "<leader>bd", "<cmd>bd<CR>", { silent = true })

for i = 1, 9 do
  map("n", "<leader>" .. i, i .. "<C-w><C-w>")
  map("n", "<leader> " .. i, i .. "gt")
end

map("n", "<leader>l", "<cmd>vertical resize +16<CR>", { silent = true })
map("n", "<leader>h", "<cmd>vertical resize -16<CR>", { silent = true })
map("n", "<leader>k", "<cmd>resize +8<CR>", { silent = true })
map("n", "<leader>j", "<cmd>resize -8<CR>", { silent = true })

map("n", "<leader>e ", "<cmd>Oil<CR>", { silent = true })
map("n", "<leader>e.", function()
  require("oil").open(vim.fn.expand("%:p:h"))
end, { silent = true })

map("n", "<leader>sb", "<cmd>Telescope buffers<CR>", { silent = true })
map("n", "<leader>sc", "<cmd>Telescope commands<CR>", { silent = true })
map("n", "<leader>sh", "<cmd>Telescope command_history<CR>", { silent = true })
map("n", "<leader>sd", "<cmd>Telescope find_files cwd=.<CR>", { silent = true })
map("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", { silent = true })
map("n", "<leader>sf", "<cmd>Telescope find_files<CR>", { silent = true })
map("n", "<leader>sl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { silent = true })
map("n", "<leader>sm", "<cmd>Telescope marks<CR>", { silent = true })
