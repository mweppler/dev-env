-- dev-env: options ported from the Janus vimrc.before / vimrc.after.
-- Required from ~/.config/nvim/lua/config/options.lua (added by install.sh),
-- which LazyVim loads before plugins, so the leader set here applies to every
-- LazyVim mapping: its whole Space menu moves to ",".

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local o = vim.opt

-- Indentation: 2-wide hard tabs by default, as in vimrc.after ("set expandtab"
-- was commented out there). Per-language overrides are in mw/autocmds.lua.
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = false
o.autoindent = true
o.smartindent = true

-- Wrapping: soft-wrap long lines, never hard-wrap.
o.wrap = true
o.textwidth = 0
o.wrapmargin = 0

o.splitright = true
o.list = true
o.errorbells = false
o.visualbell = false

-- Not ported (no Neovim equivalent or not needed):
--   guifont / linespace / gvimrc / GUI bell  MacVim GUI only; the terminal sets the font
--   t_Co / t_vb                              ignored by Neovim (it uses termguicolors)
--   clipboard=unnamed                        LazyVim already uses the system clipboard
--   rtp+=/usr/local/opt/fzf                  LazyVim's picker replaces fzf.vim
--   color zenburn / yin                      Omarchy's theme switcher drives the colorscheme
--   EditorConfig_exec_path                   EditorConfig is built into Neovim
