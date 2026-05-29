return {
    { 
        'nvim-telescope/telescope.nvim', 
        config = function()
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
        end
    },
}
