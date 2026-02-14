return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(lhs, rhs)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
        end
        map("K", vim.lsp.buf.hover)
        map("gr", vim.lsp.buf.references)
      end

      local function path_exists(path)
        return path ~= nil and path ~= "" and vim.uv.fs_stat(path) ~= nil
      end

      local function env_nonempty(name)
        local value = vim.env[name]
        if value ~= nil and value ~= "" then
          return value
        end
        return nil
      end

      local function detect_global_node_modules()
        local from_env = env_nonempty("NVIM_NODE_MODULES_DIR")
        if from_env ~= nil then
          return from_env
        end

        local npm = vim.fn.exepath("npm")
        if npm ~= "" then
          local lines = vim.fn.systemlist({ npm, "root", "-g" })
          if vim.v.shell_error == 0 and lines[1] ~= nil and lines[1] ~= "" then
            return lines[1]
          end
        end

        for _, candidate in ipairs({
          "/usr/local/lib/node_modules",
          "/opt/homebrew/lib/node_modules",
        }) do
          if path_exists(candidate) then
            return candidate
          end
        end

        return "/usr/local/lib/node_modules"
      end

      local global_node_modules = detect_global_node_modules()
      local vue_typescript_plugin = env_nonempty("NVIM_VUE_TYPESCRIPT_PLUGIN")
        or (global_node_modules .. "/@vue/typescript-plugin")
      local typescript_tsdk = env_nonempty("NVIM_TYPESCRIPT_TSDK")
        or (global_node_modules .. "/typescript/lib")

      local ts_ls_init_options = {}
      if path_exists(vue_typescript_plugin) then
        ts_ls_init_options.plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_typescript_plugin,
            languages = { "javascript", "typescript", "vue" },
          },
        }
      end

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
        },
        init_options = ts_ls_init_options,
      })
      vim.lsp.enable("ts_ls")

      vim.lsp.config("vue_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          typescript = {
            tsdk = path_exists(typescript_tsdk) and typescript_tsdk or "",
          },
        },
      })
      vim.lsp.enable("vue_ls")

      vim.lsp.config("ruby_lsp", {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable("ruby_lsp")
    end,
  },
}
