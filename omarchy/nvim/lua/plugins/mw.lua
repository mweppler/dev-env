-- dev-env: plugins from the old Janus setup that LazyVim doesn't already cover.
-- Linked into ~/.config/nvim/lua/plugins/ by install.sh; lazy.nvim loads every
-- file there.
--
-- Janus -> what replaces it here:
--   NERDTree         neo-tree (enabled in this LazyVim; F6 in mw/keymaps.lua)
--   NERDCommenter    Neovim's built-in gc (Ctrl-Space in mw/keymaps.lua)
--   ctrlp / ack      LazyVim's picker (,ff files, ,/ grep)
--   syntastic        LSP + linters (:LazyExtras to add languages)
--   airline          lualine
--   gitgutter        gitsigns
--   snipmate         LazyVim's completion and snippets
--   vim-polyglot     treesitter
--   gundo            undotree (below)
--   fugitive         fugitive (below)

return {
  { "tpope/vim-fugitive", cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite" } },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>zj", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
      { "<leader>zu", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
    },
  },

  -- Show dotfiles in the explorer (was NERDTreeShowHidden=1).
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = { filesystem = { filtered_items = { hide_dotfiles = false } } },
  },
}
