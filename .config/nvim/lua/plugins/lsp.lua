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

      local function mise_npm_package_paths(package_name)
        return vim.fn.glob(
          vim.fn.expand("~/.local/share/mise/installs/*/*/lib/node_modules/" .. package_name),
          true,
          true
        )
      end

      local function first_existing_path(candidates)
        for _, candidate in ipairs(candidates) do
          if path_exists(candidate) then
            return candidate
          end
        end
        return nil
      end

      local function find_upward(startpath, target)
        local start = startpath or vim.uv.cwd()
        local found = vim.fs.find(target, {
          upward = true,
          path = start,
        })[1]

        return found
      end

      local function project_root(root_dir)
        local package_json = find_upward(root_dir, "package.json")
        if package_json ~= nil then
          return vim.fs.dirname(package_json)
        end
      end

      local function prefix_paths(prefixes, suffixes)
        local paths = {}
        for _, prefix in ipairs(prefixes) do
          for _, suffix in ipairs(suffixes) do
            table.insert(paths, prefix .. suffix)
          end
        end
        return paths
      end

      local function resolve_workspace_path(env_name, root_dir, project_suffixes, global_suffixes, global_node_modules)
        local from_env = env_nonempty(env_name)
        if from_env ~= nil then
          return from_env
        end

        local root = project_root(root_dir)
        if root ~= nil then
          local project_path = first_existing_path(prefix_paths({ root }, project_suffixes))
          if project_path ~= nil then
            return project_path
          end
        end

        local candidates = prefix_paths({
          global_node_modules,
          "/opt/homebrew/lib/node_modules",
          "/usr/local/lib/node_modules",
        }, global_suffixes)

        for _, suffix in ipairs(global_suffixes) do
          local package_name = suffix:gsub("^/", "")
          vim.list_extend(candidates, mise_npm_package_paths(package_name))
        end

        return first_existing_path(candidates)
      end

      local global_node_modules = detect_global_node_modules()

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library',
                -- '${3rd}/busted/library',
              },
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })
      vim.lsp.enable('lua_ls')


      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        before_init = function(_, config)
          local vue_typescript_plugin = resolve_workspace_path(
            "NVIM_VUE_TYPESCRIPT_PLUGIN",
            config.root_dir,
            {
              "/node_modules/@vue/typescript-plugin",
              "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
            },
            {
              "/@vue/typescript-plugin",
              "/@vue/language-server/node_modules/@vue/typescript-plugin",
            },
            global_node_modules
          )
          config.init_options = config.init_options or {}
          config.init_options.plugins = nil

          if vue_typescript_plugin ~= nil then
            config.init_options.plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_typescript_plugin,
                languages = { "javascript", "typescript", "vue" },
              },
            }
          end
        end,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
        },
      })
      vim.lsp.enable("ts_ls")

      vim.lsp.config("vue_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        before_init = function(_, config)
          local tsdk = resolve_workspace_path(
            "NVIM_TYPESCRIPT_TSDK",
            config.root_dir,
            { "/node_modules/typescript/lib" },
            { "/typescript/lib" },
            global_node_modules
          )
          config.init_options = config.init_options or {}
          config.init_options.typescript = config.init_options.typescript or {}
          config.init_options.typescript.tsdk = tsdk or ""
        end,
      })
      vim.lsp.enable("vue_ls")

      vim.lsp.config("ruby_lsp", {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable("ruby_lsp")

      vim.lsp.config("tailwindcss", {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable("tailwindcss")
    end,
  },
}
