return {
    { 
        'neovim/nvim-lspconfig', 
        config = function() 
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
        end
    },
    { 'hrsh7th/cmp-nvim-lsp', },
    { 'hrsh7th/cmp-buffer', },
    { 'hrsh7th/cmp-path', },
    { 'hrsh7th/cmp-cmdline', },
    { 
        'hrsh7th/nvim-cmp', 
        config = function()
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
        end
    },
    { 
        'nvimdev/lspsaga.nvim', 
        config = function()
            require('lspsaga').setup({})
            vim.api.nvim_set_keymap('n', '<C-j>', ':Lspsaga diagnostic_jump_next <CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<C-k>', ':Lspsaga diagnostic_jump_prev <CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', 'fd', ':Lspsaga finder def <CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', 'fr', ':Lspsaga finder ref <CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', 'fc', ':Lspsaga code_action <CR>', {noremap = true, silent = true})
        end
    },
    { 
        'hedyhli/outline.nvim', 
        config = function()
            require("outline").setup({})
            vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>Outline<CR>', {noremap = true, silent = true})
        end
    },
    { 
        'numToStr/Comment.nvim', 
        lazy = false, 
        config = function()
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
        end
    },
}
