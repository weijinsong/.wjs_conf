return {
    { 
        'nvim-treesitter/nvim-treesitter', 
        config = function()
            require('nvim-treesitter').install({
                'rust', 'python', 'perl', 'lua',
                'json', 'yaml', 'toml',
                'bash', 'zsh',
            })
        end
    },
}
