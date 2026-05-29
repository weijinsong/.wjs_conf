local M = {}

-- 检测 macism 是否可用
local macism_path = vim.fn.executable("macism") == 1 and "macism" or "/Users/bytedance/Setup/macism/macism"

function M.setup()
    if not (macism_path and vim.fn.filereadable(macism_path) == 1) then
        vim.notify("macism not found, IME switching disabled", vim.log.levels.WARN)
        return
    end

    local function get_current_im()
        return vim.fn.system(macism_path):gsub("%s+", "")
    end

    local function switch_im(im_name)
        if im_name and im_name ~= "" then
            vim.fn.system(macism_path .. " " .. im_name)
        end
    end

    local current_im = ""

    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            current_im = get_current_im()
            switch_im("com.apple.keylayout.ABC")
        end,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
            if current_im and current_im ~= "com.apple.keylayout.ABC" then
                switch_im(current_im)
            end
        end,
    })
end

return M
