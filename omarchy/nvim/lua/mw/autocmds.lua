-- dev-env: per-language indentation ported from vimrc.after.
-- Required from ~/.config/nvim/lua/config/autocmds.lua (added by install.sh).
--
-- The Vim version ran ":retab" on every file it opened, which silently
-- rewrote tabs to spaces in the buffer. That is dropped here: these only set
-- how new indentation is typed and leave existing whitespace alone.

local group = vim.api.nvim_create_augroup("mw_indent", { clear = true })

local function indent(filetypes, width)
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = filetypes,
    callback = function()
      vim.opt_local.tabstop = width
      vim.opt_local.shiftwidth = width
      vim.opt_local.softtabstop = width
      vim.opt_local.expandtab = true
    end,
  })
end

indent({ "c", "go", "java", "python", "swift" }, 4)
indent({ "javascript", "ruby" }, 2)

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.list = true
    vim.opt_local.textwidth = 0
  end,
})
