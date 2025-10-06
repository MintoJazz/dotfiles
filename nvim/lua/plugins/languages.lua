return {
  -- PARTE 1: Gerenciador de LSPs (Mason)
  -- Aqui nós dizemos ao Mason, que já vem com o LazyVim, para garantir
  -- que todos os servidores de linguagem que você precisa estejam instalados.
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "jdtls", -- Java
        "pyright", -- Python
        "tsserver", -- TypeScript / JavaScript
        "emmet_ls", -- Facilidades para HTML
        "sqlls", -- SQL
        "lua_ls", -- Para ajudar na própria configuração do Neovim
      })
    end,
  },

  -- PARTE 2: Configuração Avançada para Java (nvim-jdtls)
  -- Este plugin transforma o Neovim em uma IDE Java completa, cuidando
  -- da configuração do projeto, debugging e outras funcionalidades.
  {
    "mfussenegger/nvim-jdtls",
    ft = "java", -- Carrega o plugin apenas quando abrir arquivos Java
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local jdtls = require("jdtls")

      -- Encontra o diretório raiz do seu projeto (onde está o pom.xml ou build.gradle)
      local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew" })
      if not root_dir then
        return -- Não faz nada se não estiver em um projeto Java
      end

      -- Cria um diretório de workspace separado para cada projeto
      local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

      -- Configuração principal. Note que a linha 'cmd' foi removida para usar o padrão do Mason.
      local config = {
        root_dir = root_dir,
      }

      -- Inicia o servidor de linguagem
      jdtls.start_or_attach(config)

      -- Cria atalhos úteis (estilo IDE) apenas depois que o LSP estiver ativo no arquivo
      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.java",
        callback = function(args)
          -- A 'args.buf' garante que o atalho só funcione no buffer do arquivo Java
          local bufnr = args.buf
          vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, { buffer = bufnr, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, { buffer = bufnr, desc = "Extract Variable" })
          vim.keymap.set("v", "<leader>em", jdtls.extract_method, { buffer = bufnr, desc = "Extract Method" })
        end,
      })
    end,
  },
}
