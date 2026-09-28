-- Options and core keymaps. Plugins and their config live in plugin/*.lua,
-- which Neovim sources automatically after this file.
-- Plugins are managed by the builtin vim.pack:
--   :lua vim.pack.update()           update all (review buffer, :w to apply)
--   :lua vim.pack.del({ 'name' })    remove one (after deleting it from plugin/)

vim.g.mapleader = " "

vim.opt.guicursor = ""
vim.opt.clipboard = "unnamedplus"

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.hlsearch = false
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.winborder = "rounded"

vim.g.python3_host_prog = "/usr/bin/python3"

-- transparent background, so the terminal's opacity shows through
local function clear_bg()
  for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer" }) do
    vim.api.nvim_set_hl(0, group, { fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_bg })
clear_bg()

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
