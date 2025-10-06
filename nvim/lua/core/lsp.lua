-- ~/.config/nvim/lua/core/lsp.lua

-- Define os ícones para os diagnósticos (opcional, mas melhora a aparência)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- 1. Inicializa o Mason
    mason.setup()

    -- 2. Define quais servidores de linguagem (LSPs) o Mason deve instalar
    --    Esses são os LSPs relevantes para o seu perfil:
    mason_lspconfig.setup({
      ensure_installed = {
        "jdtls", -- Para Java
        "pyright", -- Para Python
        "tsserver", -- Para JavaScript e TypeScript (essencial para web)
        "html", -- Para HTML
        "cssls", -- Para CSS
        "emmet_ls", -- Para autocompletar tags HTML/CSS (estilo VSCode)
        "lua_ls", -- Para te ajudar a configurar o próprio Neovim
      },
    })

    -- 3. Configuração Padrão para cada LSP
    --    Esta é a parte mágica. Para cada servidor que o Mason instala,
    --    nós dizemos ao lspconfig como iniciá-lo.
    local on_attach = function(client, bufnr)
      -- Habilita o autocompletar com <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- Mapeia atalhos úteis do LSP
      local opts = { buffer = bufnr, noremap = true, silent = true }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Mostra documentação ao passar o mouse
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Ir para a definição
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Mostrar referências
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Ações de código (refatorar, etc.)
    end

    -- Pega as "capacidades" do nvim-cmp para que o autocompletar funcione
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    mason_lspconfig.setup_handlers({
      -- A função padrão que será executada para cada servidor
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = on_attach, -- Executa nossa função de atalhos
          capabilities = capabilities, -- Informa ao LSP sobre as capacidades do nvim-cmp
        })
      end,

      -- Configuração especial para o Lua (para ajudar com seu Neovim)
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                -- Tira o aviso de que "vim" é uma variável global indefinida
                globals = { "vim" },
              },
            },
          },
        })
      end,
    })
  end,
}
