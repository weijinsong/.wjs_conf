if vim.g.vscode then
return 
else 
return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
        end,
        config = function()
            vim.g.molten_auto_open_output = false
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_wrap_output = true
            vim.g.molten_limit_output_chars = 5000000
            vim.g.molten_output_show_more = true
            vim.g.molten_output_win_hide_on_leave = true
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_max_lines = 999
            
            vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
                { silent = true, desc = "Initialize the plugin" })
            vim.keymap.set("n", "<localleader>mx", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser", silent = true })
        end,
    },
    {
        -- see the image.nvim readme for more information about configuring this plugin
        "3rd/image.nvim",
        opts = {
            backend = "kitty", -- whatever backend you would like to use
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
    },
    { 'kiyoon/jupynium.nvim', build = "pip install .", },
    { 
        'GCBallesteros/jupytext.nvim', 
        -- config = true,
        config = function()
            require("jupytext").setup({
                style = "hydrogen",
                output_extension = "auto",
                force_ft = nil, 
                custom_language_formatting = {
                    python = {
                        extension = "qmd",
                        style = "quarto",
                        force_ft = "md",
                    }
                },
            })
        end, 
    },
    { 
        'quarto-dev/quarto-nvim', 
        dependencies = {
            'jmbuhr/otter.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function() 
            require('quarto').setup({
                debug = false,
                closePreviewOnExit = true,
                lspFeatures = {
                    enabled = true,
                    chunks = "curly",
                    languages = { "r", "python", "julia", "bash", "html" },
                    diagnostics = {
                        enabled = true,
                        triggers = { "BufWritePost" },
                    },
                    completion = {
                        enabled = true,
                    },
                },
                codeRunner = {
                    enabled = true,
                    default_method = "molten", -- "molten", "slime", "iron" or <function>
                    ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
                    -- Takes precedence over `default_method`
                    never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
                },
            })
            local runner = require("quarto.runner")
            vim.keymap.set("n", "<localleader>rc", runner.run_cell,  { desc = "run cell", silent = true })
            vim.keymap.set("n", "<localleader>ra", runner.run_all,   { desc = "run all cells", silent = true })
            vim.keymap.set("n", "<localleader>rl", runner.run_line,  { desc = "run line", silent = true })
            vim.keymap.set("v", "<localleader>rv",  runner.run_range, { desc = "run visual range", silent = true })
            -- vim.keymap.set("n", "<localleader>RA", function()
            --   runner.run_all(true)
            -- end, { desc = "run all cells of all languages", silent = true })
        end,
    },
}
end

