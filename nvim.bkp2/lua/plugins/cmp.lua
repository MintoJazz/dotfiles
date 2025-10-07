-- No seu arquivo de plugins (ex: lua/plugins/cmp.lua)
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Fonte para o autocompletar do LSP
    "hrsh7th/cmp-buffer",   -- Fonte para palavras do buffer atual
    "hrsh7th/cmp-path",     -- Fonte para caminhos de arquivos
    "L3MON4D3/LuaSnip",     -- Engine de Snippets
    "saadparwaiz1/cmp_luasnip", -- Integração Snippets + CMP
  },
}