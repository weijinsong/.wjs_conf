return {
    { 
        'yorickpeterse/nvim-window', 
        config = function()
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
            vim.api.nvim_set_keymap('n', '<leader>w', ':lua require(\'nvim-window\').pick() <CR>', {noremap = true, silent = true })
        end
    },
}
