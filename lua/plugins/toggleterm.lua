return {{ 
    'akinsho/toggleterm.nvim', 
    version = '*', 
    config = function()
        require('toggleterm').setup({
            -- open_mapping = [[<C-t>]],
            insert_mappings = false,
            terminal_mappings = false,
            persist_size = false,
            persist_mode = true,
            start_in_insert = true,
        })

        local function get_win_size()
            local width = vim.api.nvim_win_get_width(0)
            local height = vim.api.nvim_win_get_height(0)
            return width, height
        end
        local function get_vertical_width()
            local width, _ = get_win_size()
            return math.max(30, math.floor(width * 0.4))
        end

        local function get_float_width()
            local width, _ = get_win_size()
            return math.max(40, math.floor(width * 0.7))
        end
        local function get_float_height()
            local _, height = get_win_size()
            return math.max(10, math.floor(height * 0.3))
        end

        local Terminal = require('toggleterm.terminal').Terminal
        local tab_term = Terminal:new({
            direction = "tab",
        })
        local horizontal_term = Terminal:new({
            direction = "horizontal",
        })
        local vertical_term = Terminal:new({
            direction = "vertical",
            size = get_vertical_width
        })
        local float_term = Terminal:new({
            direction = "float", 
            float_opts = {
                border = "single",
                width = get_float_width,
                height = get_float_height,
            }
        })

        -- open terminal in tabe
        vim.keymap.set("n", "<leader>tt", function() 
            tab_term:toggle()        
        end, { noremap = true, silent = true, desc = "Toggle tabe terminal" })

        vim.keymap.set("n", "<leader>th", function() 
            horizontal_term:toggle() 
        end, { noremap = true, silent = true, desc = "Toggle horizontal terminal" })

        vim.keymap.set("n", "<leader>tv", function() 
            vertical_term:toggle()   
            vertical_term:resize(get_vertical_width())
        end, { noremap = true, silent = true, desc = "Toggle vertical terminal" })

        vim.keymap.set("n", "<leader>tf", function() 
            float_term:toggle()      
        end, { noremap = true, silent = true, desc = "Toggle floating terminal" })

        -- open terminal in norml mode with key binding : <Ctrl+t>
        vim.keymap.set("n", "<C-t>", function()
            horizontal_term:toggle()
        end, { noremap = true, silent = true, desc = "Toggle horizontal terminal" })

        -- open terminal in insert mode with key binding : <Ctrl+t>
        vim.keymap.set('i', '<C-t>', function()
            horizontal_term:toggle()
        end, {noremap = true, silent = true, desc = "Toggle horizontal termianl (insert)"})

        -- close terminal in terminal mode with key binding : <Ctrl+t>
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*toggleterm#*",
            callback = function()
            vim.keymap.set('t', '<C-t>', '<Cmd>lua require("toggleterm").toggle()<CR>', { buffer = true })
            end,
        })

        local function get_visual_selection()
            local start_pos = vim.fn.getpos("'<")
            local end_pos = vim.fn.getpos("'>")
            local lines = vim.api.nvim_buf_get_lines(0, start_pos[2]-1, end_pos[2], false)
            if #lines == 0 then
                return ""
            end
            lines[1] = string.sub(lines[1], start_pos[3], -1)
            lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
            return table.concat(lines, "\n")
        end

        local function send_to_terminal(term_obj, go_back)
            -- local visual_text = get_visual_selection()
            visual_text = vim.fn.getreg('v')
            if visual_text == "" then
                vim.notify("No text selected!", vim.log.levels.WARN)
                return
            end
            local function send_text()
                term_obj:send(visual_text, go_back)
            end
            if not term_obj:is_open() then
                term_obj:open()
                vim.defer_fn(send_text, 100)
            else 
                send_text()
            end
        end

        local go_back = true
        vim.keymap.set("x", '<leader>tt', function()
            vim.cmd('normal! "vy')
            send_to_terminal(tab_term, go_back)
        end, { noremap = true, silent = true, desc = "Send selection to tabe terminal" })

        vim.keymap.set("x", '<leader>th', function()
            vim.cmd('normal! "vy')
            send_to_terminal(horizontal_term, go_back)
        end, { noremap = true, silent = true, desc = "Send selection to horizontal terminal" })

        vim.keymap.set("x", '<leader>tf', function()
            vim.cmd('normal! "vy')
            send_to_terminal(float_term, false)
        end, { noremap = true, silent = true, desc = "Send selection to floating terminal" })

        vim.keymap.set("x", "<leader>tv", function()
            vim.cmd('normal! "vy')
            send_to_terminal(vertical_term, go_back)
            vertical_term:resize(get_vertical_width())
        end, { noremap = true, silent = true, desc = "Send selection to vertical terminal" })

    end
}}

