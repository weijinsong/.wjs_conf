--~/.config/nvim/init.lua

--
-- Common Config
--
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.signcolumn = 'number'
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.g.mapleader = '\\'
vim.cmd([[
set clipboard+=unnamedplus
]])
require('ime').setup()

---
--- neovide
---
if vim.g.neovide then
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_length = 0
vim.o.background = "dark"
vim.g.neovide_opacity = 1.0
end

--
-- lazy
--
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath, })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    { 'navarasu/onedark.nvim', lazy = false, },
    { 'HiPhish/rainbow-delimiters.nvim', main = 'ibl', },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true, },
    { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup({}) end},
    { 'lukas-reineke/virt-column.nvim', opts = {} },
    { 'godlygeek/tabular', },
    { 'BurntSushi/ripgrep', },
    { 'rcarriga/nvim-notify', },
    { 'stevearc/dressing.nvim', },
    require('plugins.nvim-treesitter'),
    require('plugins.nvim-window'),
    require('plugins.lualine'),
    require('plugins.nvim-tree'),
    require('plugins.lsp'),
    require('plugins.telescope'),
    require('plugins.markdown'),
    require('plugins.llm'),
    require('plugins.molten-nvim'),
    require('plugins.snacks'),
    require('plugins.toggleterm'),
    require('plugins.gdb'),
})

-- 
if vim.fn.has('termguicolors') then 
    vim.opt.termguicolors = true
end
local onedark_theme = require('onedark')
onedark_theme.setup({ style = 'warmer' })
onedark_theme.load()

require('virt-column').setup({
})

--
-- Common key config
--
local n_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true })
end
local i_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true })
end

n_keymap('<leader>sv', ':source $MYVIMRC <CR>')
n_keymap('<leader>ev', ':tabe $MYVIMRC <CR>')
n_keymap('<leader>ey', ':tabe ~/.config/yazi/yazi.toml <CR>')
n_keymap('<leader>ez', ':tabe ~/.zshrc <CR>')
n_keymap('<leader>et', ':tabe ~/.tmux.conf <CR>')

n_keymap('<left>', ':vertical resize -2<CR>')
n_keymap('<right>', ':vertical resize +2<CR>')
n_keymap('<up>', ':res -2<CR>')
n_keymap('<down>', ':res +2<CR>')

vim.api.nvim_set_keymap('c', '<C-H>', '<Up>', {})
vim.api.nvim_set_keymap('c', '<C-L>', '<C-Y>', {})
vim.api.nvim_set_keymap('c', '<C-K>', '<C-P>', {})
vim.api.nvim_set_keymap('c', '<C-J>', '<C-N>', {})

n_keymap('<F3>', ':-tabnext<CR>')
n_keymap('<F4>', ':+tabnext<CR>')

vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {})
if package.loaded['telescope'] then
    vim.api.nvim_create_user_command('Vt', 'ToggleTerm', {})
    vim.api.nvim_create_user_command('Ht', 'set splitright | vsplit| term', {})
    vim.api.nvim_create_user_command('Ft', 'set splitright | vsplit| term', {})
else
    vim.api.nvim_create_user_command('Vt', 'set splitbelow | split | res -20 | term', {})
    vim.api.nvim_create_user_command('Ht', 'set splitright | vsplit| term', {})
end


-- vim.api.nvim_set_keymap('v', 'tbb', ':Tabluarize /', {})
-- vim.api.nvim_set_keymap('v', 'tbl', ':Tabluarize //l0<left><left><left>', {})
-- vim.api.nvim_set_keymap('v', 'tbr', ':Tabluarize //r0<left><left><left>', {})



