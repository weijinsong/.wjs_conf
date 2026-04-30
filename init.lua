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

--
-- Common key config
--
local n_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true })
end

n_keymap('<leader>sv', ':source $MYVIMRC <CR>')
n_keymap('<leader>ev', ':tabe $MYVIMRC <CR>')
n_keymap('<leader>ey', ':tabe ~/.config/yazi/yazi.toml <CR>')
n_keymap('<leader>ez', ':tabe ~/.zshrc <CR>')

n_keymap('<left>', ':vertical resize -2<CR>')
n_keymap('<right>', ':vertical resize +2<CR>')
n_keymap('<up>', ':res -2<CR>')
n_keymap('<down>', ':res +2<CR>')

vim.api.nvim_set_keymap('c', '<C-H>', '<Up>', {})
vim.api.nvim_set_keymap('c', '<C-L>', '<C-Y>', {})
vim.api.nvim_set_keymap('c', '<C-K>', '<C-P>', {})
vim.api.nvim_set_keymap('c', '<C-J>', '<C-N>', {})

vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {})
vim.api.nvim_create_user_command('Vterm', 'set splitbelow | split | res -20 | term', {})
vim.api.nvim_create_user_command('Hterm', 'set splitright | vsplit| term', {})

n_keymap('<F3>', ':-tabnext<CR>')
n_keymap('<F4>', ':+tabnext<CR>')

--
-- lazy
--
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath, })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    { 'nvim-treesitter/nvim-treesitter', },
    { 'navarasu/onedark.nvim', lazy = false, },
    { 'nvimdev/dashboard-nvim', event='VimEnter', dependencies={ {'nvim-tree/nvim-web-devicons'} } },
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', },
    { 'HiPhish/rainbow-delimiters.nvim', main = 'ibl', },
    { 'nvim-lualine/lualine.nvim', },
    { 'neovim/nvim-lspconfig', },
    { 'hrsh7th/cmp-nvim-lsp', },
    { 'hrsh7th/cmp-buffer', },
    { 'hrsh7th/cmp-path', },
    { 'hrsh7th/cmp-cmdline', },
    { 'hrsh7th/nvim-cmp', },
    { 'nvimdev/lspsaga.nvim', },
    { 'numToStr/Comment.nvim', lazy = false, },
    -- { 'simrat39/symbols-outline.nvim', },
    { 'hedyhli/outline.nvim', },
    { 'nvim-tree/nvim-tree.lua', },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true, },
    { 'kylechui/nvim-surround', event = 'VeryLazy', },
    { 'lukas-reineke/virt-column.nvim', opts = {} },
    { 'akinsho/toggleterm.nvim', version = '*', config = false }, 
    { 'godlygeek/tabular', },
    { 'BurntSushi/ripgrep', },
    { 'nvim-telescope/telescope.nvim', },
    { 'yorickpeterse/nvim-window', },
    { 'kiyoon/jupynium.nvim', build = "pip install .", },
    { 'rcarriga/nvim-notify', },
    { 'stevearc/dressing.nvim', },
    { 
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
        opts = {},
    },
    require('plugins.llm'),
})

if vim.fn.has('termguicolors') then 
    vim.opt.termguicolors = true
end
local onedark_theme = require('onedark')
onedark_theme.setup({ style = 'warmer' })
onedark_theme.load()

local start_screen = require('dashboard')
start_screen.setup( {
    theme = 'hyper',
    disable_move = false,
    shortcut_type = 'letter',
    suffle_letter = true,
    change_to_vcs_root = false,
    config = {
        header = {},
        week_header = { enable = false, },
        shortcut = {},
    },
})

local ibl = require('ibl')
local ibl_conf = require('ibl.config')
ibl.setup()

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainBowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = '#E06C75' })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = '#E5C07B' })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = '#61AFEF' })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = '#D19A66' })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = '#98C379' })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = '#C678DD' })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = '#56B6C2' })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require('ibl').setup( {scope = {highlight = highlight}} )
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

require('lualine').setup({
    options = {
        theme = 'material',
        disable_filetypes = { 'Outline', 'NvimTree' },
    },
    tabline = {
        lualine_a = { { 'buffers', show_filename_only = false, show_modified_status = false, mode = 2}, },
        lualine_z = { 'tabs' },
    },
})

local lspconfig = vim.lsp.config
vim.lsp.enable('pylsp')
lspconfig('pylsp', {
    settings = {
        pylsp = {
            plugins = {
                ignore = {'W391', 'W291', 'E251', 'E126', 'E225', 'E502', 'E127',
                            'E203', 'E124', 'E201', 'E121'},
                maxLineLength = 100,
            }
        }
    }
})
vim.lsp.enable('clangd')

local cmp=require('cmp')
cmp.setup({
    snippet = {},
    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        },
        {
            { name = 'buffer' },
            { name = 'path' },
            { name = "llm" , group_index = 1, priority = 100, }
        }
    ),
    formatting = {},
    mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<CR>']  = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
        }),
    },
})

require('lspsaga').setup({})
vim.api.nvim_set_keymap('n', '<C-j>', ':Lspsaga diagnostic_jump_next <CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', ':Lspsaga diagnostic_jump_prev <CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'fd', ':Lspsaga finder def <CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'fr', ':Lspsaga finder ref <CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'fc', ':Lspsaga code_action <CR>', {noremap = true, silent = true})

-- require('symbols-outline').setup({
--     flold_markers = { '>', '-'},
-- })

require("outline").setup({
})
vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>Outline<CR>', {noremap = true, silent = true})

require('Comment').setup({
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
        line = '<leader>c ',
        block = '<leader>cb',
    },
    opleader = {
        line = '<leader>c ',
        block = '<leader>cb',
    },
})
local comment_ft = require('Comment.ft')
comment_ft.set('ned', '//%s').set('dosini', '#%s')

local function my_on_attach(bufnr)
    local api = require 'nvim-tree.api'
    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true}
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set('n', '<C-h>', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', '<C-l>', api.tree.change_root_to_node, opts('Down'))
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close'))
    vim.keymap.set('n', 's', api.node.open.vertical, opts('vertical Split'))
    vim.keymap.set('n', 'S', api.node.open.horizontal, opts('horizontal Split'))
    vim.keymap.set('n', 't', api.node.open.tab, opts('Tabe'))
    vim.keymap.set('n', 'R', api.tree.reload, opts('reload'))
end


require('nvim-tree').setup({
    renderer = {
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
        },
    },
    on_attach = my_on_attach,
})
vim.api.nvim_set_keymap('n', '<F2>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})


require('nvim-surround').setup({
})


require('virt-column').setup({
})

vim.api.nvim_set_keymap('v', 'tbb', ':Tabluarize /', {})
vim.api.nvim_set_keymap('v', 'tbl', ':Tabluarize //l0<left><left><left>', {})
vim.api.nvim_set_keymap('v', 'tbr', ':Tabluarize //r0<left><left><left>', {})

if not vim.fn.executable('rg') then
    print('miss ripgrep!')
end

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Telescope help tags' })
require('telescope').setup({
    defaults = {
        mapings = {
            i = {
                ['<esc>'] = require('telescope.actions').close,
                ['<C-j>'] = require('telescope.actions').move_selection_next,
                ['<C-k>'] = require('telescope.actions').move_selection_previous,
                ['<up>' ] = require('telescope.actions').preview_scrolling_up,
                ['<down>']= require('telescope.actions').preview_scrolling_down,
                ['<C-v>'] = require('telescope.actions').select_vertical,
                ['<C-h>'] = require('telescope.actions').select_horizontal,
                ['<C-t>'] = require('telescope.actions').select_tab,
                ['<C-e>'] = require('telescope.actions').file_edit,
            }
        }
    }
})

require('nvim-window').setup({
    chars = {
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
        'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
    },
    normal_hl = 'Normal',
    hint_hl = 'Bold',
    border = 'single',
    render = 'float',
})

n_keymap('<leader>w', ':lua require(\'nvim-window\').pick() <CR>')

