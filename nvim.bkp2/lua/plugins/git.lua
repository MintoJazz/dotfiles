-- lua/plugins/git.lua
return {
  "lewis6991/gitsigns.nvim", -- Adiciona, modifica, remove sinais no gutter
  {
    "kdheepak/lazygit.nvim", -- Opcional: para abrir o TUI do lazygit
    config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
    end,
  },
}