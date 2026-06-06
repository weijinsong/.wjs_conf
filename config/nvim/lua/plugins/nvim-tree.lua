return {
    { 'nvim-tree/nvim-web-devicons', },
    { 
        'nvim-tree/nvim-tree.lua', 
        config = function() 
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
                vim.keymap.set('n', 'i', api.node.open.horizontal, opts('horizontal Split'))
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
        end
    },
}
