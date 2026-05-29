if vim.g.vscode then
return 
else
return {
    { 
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
        -- opts = {},
        config = function()
            require('render-markdown').setup({
                latex = {
                    enabled = true,
                    render_modes = true,
                    converter = { 'utftex', 'latex2text' },
                    highlight = 'RenderMarkdownMath',
                    position = 'center',
                    top_pad = 0,
                    bottom_pad = 0,
                },
            })
        end
    },
}
end
