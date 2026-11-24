-- dev-env: mappings ported from the Janus vimrc.before.
-- Required from ~/.config/nvim/lua/config/keymaps.lua (added by install.sh).
-- <leader> is "," (set in mw/options.lua).

local map = vim.keymap.set

-- Space opens the command line.
map("n", "<space>", ":", { desc = "Command line" })

-- Visual block mode, since Ctrl-V pastes (below).
map("n", "<leader>v", "<C-v>", { desc = "Visual block mode" })

-- System clipboard: Ctrl-C yanks a selection, Ctrl-V pastes.
map("v", "<C-c>", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+gP', { desc = "Paste from system clipboard" })

-- Leave insert mode with ,e
map("i", "<leader>e", "<esc>", { desc = "Escape" })

-- Window moves (LazyVim also proxies <leader>w to <C-w>, so these are explicit
-- versions of what already works).
map("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })

-- Splits: these leave the command line open for a file name, as before.
map("n", "<leader>bv", ":bel vsp ", { desc = "Vertical split (bottom right)" })
map("n", "<leader>nrt", ":vsp n", { desc = "Vertical split: notes" })

-- Diff the current buffer.
map("n", "<leader>dt", "<cmd>diffthis<cr>", { desc = "Diff this buffer" })
map("n", "<leader>do", "<cmd>diffthis<cr>", { desc = "Diff this buffer" })

-- Pretty-print the whole buffer as JSON.
map("n", "<leader>js", "<cmd>%!python3 -m json.tool<cr>", { desc = "Format JSON" })

-- File explorer on F6 (was NERDTree; this setup uses neo-tree).
map("n", "<F6>", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

-- Toggle comments with Ctrl-Space (was NERDCommenter; Neovim has gc built in).
-- Terminals send Ctrl-Space as Ctrl-@, so map both. This replaces LazyVim's
-- Ctrl-Space treesitter selection.
for _, key in ipairs({ "<C-Space>", "<C-@>" }) do
  map("n", key, "gcc", { remap = true, desc = "Toggle comment" })
  map("x", key, "gc", { remap = true, desc = "Toggle comment" })
end

-- Typo fix.
vim.cmd.iabbrev("bindign", "binding")

-- Not ported:
--   ,sv  reload vimrc   LazyVim doesn't support re-sourcing its config; restart instead
--   ,d   Dash.app       macOS only
--   ,h   HexHighlight   no equivalent plugin installed
--   ,ac ,aa ,ax ,an     the AI chat plugin pointed at LM Studio on the Mac
-- ,zj / ,zu (undo tree) are in plugins/mw.lua with the plugin they need.
