return {
{
    'sakhnik/nvim-gdb',
    build = './install.sh', -- 安装脚本，用于配置外部依赖
    config = function()
        vim.g.nvimgdb_config_override = {}
    end,
}
}
