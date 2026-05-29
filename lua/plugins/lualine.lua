return {
    { 
        'nvim-lualine/lualine.nvim', 
        config = function()
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
        end
    },
}


