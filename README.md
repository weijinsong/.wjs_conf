# wjs_conf

个人终端开发环境配置（dotfiles）：Neovim、tmux、yazi、kitty。

## 目录结构

```
config/
├── nvim/                 Neovim 配置
│   ├── init.lua          入口：基础选项、lazy.nvim 引导、插件列表、快捷键
│   └── lua/
│       ├── ime.lua       基于 macism 的输入法自动切换
│       └── plugins/      各插件独立配置
├── tmux.conf             tmux 配置
├── yazi/                 yazi 文件管理器配置
│   ├── yazi.toml         manager / preview / opener / tasks 设置
│   ├── keymap.toml       按键映射
│   ├── theme.toml
│   ├── package.toml      插件清单
│   ├── flavors/          配色主题
│   └── plugins/          插件
└── kitty/
    └── kitty.conf        kitty 终端配置
```

## 安装

`config/` 下的文件需软链接到各自的标准位置（以下假设仓库克隆到 `~/.wjs_conf`）。

```sh
git clone <repo-url> ~/.wjs_conf
cd ~/.wjs_conf

ln -s ~/.wjs_conf/config/nvim     ~/.config/nvim     # Neovim
ln -s ~/.wjs_conf/config/tmux.conf ~/.tmux.conf       # tmux
ln -s ~/.wjs_conf/config/yazi     ~/.config/yazi      # yazi
ln -s ~/.wjs_conf/config/kitty    ~/.config/kitty     # kitty
```

## 各组件说明

### Neovim（`config/nvim`）

使用 [lazy.nvim](https://github.com/folke/lazy.nvim)，首次启动自动从 GitHub 克隆引导。主题为 `onedark`（`warmer` 风格），Leader 键为 `\`。基础选项启用了相对行号、光标行/列高亮、4 空格缩进、系统剪贴板共享。

`init.lua` 直接声明的插件包括 onedark、rainbow-delimiters、nvim-autopairs、nvim-surround、virt-column、tabular、ripgrep、nvim-notify、dressing。模块化插件位于 `lua/plugins/`：

| 文件 | 用途 |
| --- | --- |
| `lsp.lua` | 语言服务器 |
| `telescope.lua` | 模糊查找 |
| `nvim-treesitter.lua` | 语法解析/高亮 |
| `nvim-tree.lua` | 文件树 |
| `nvim-window.lua` | 窗口选择 |
| `lualine.lua` | 状态栏 |
| `toggleterm.lua` | 集成终端 |
| `markdown.lua` | Markdown 渲染 |
| `molten-nvim.lua` | Jupyter / 交互式执行 |
| `llm.lua` | LLM 集成 |
| `gdb.lua` | 调试 |
| `snacks.lua` | 杂项增强 |

`ime.lua` 通过 `macism` 在进入/离开插入模式时自动切换输入法，未安装时静默禁用。

常用快捷键（Leader = `\`）：

| 按键 | 作用 |
| --- | --- |
| `<leader>sv` | 重新加载 `$MYVIMRC` |
| `<leader>ev` | 新标签页编辑 `init.lua` |
| `<leader>ey` / `ez` / `et` | 编辑 yazi / zshrc / tmux 配置 |
| `<方向键>` | 调整窗口分割大小 |
| `F3` / `F4` | 上一个 / 下一个标签页 |

集成终端命令：`:Vt`（toggleterm）、`:Ht`、`:Ft`（垂直分屏开终端）。

### tmux（`config/tmux.conf`）

面向 tmux 2.9+，开启真彩色与鼠标支持，前缀键为默认 `C-b`。

| 按键 | 作用 |
| --- | --- |
| `prefix + r` | 重新加载配置 |
| `prefix + v` | 左右分屏 |
| `prefix + h` | 上下分屏 |
| `prefix + y` | 最大化/恢复窗格（Zoom） |
| `prefix + C-方向键` | 调整窗格大小（每次 5 格） |
| `prefix + M-方向键` | 调整窗格大小（每次 1 格） |
| `prefix + { / }` | 向左/右交换窗格 |

状态栏左侧显示会话名，右侧显示时间与日期。

### yazi（`config/yazi`）

文件管理器配置，涵盖 manager 布局（面板比例 `1:3:4`、显示隐藏文件）、预览、跨平台 opener、任务 worker。自定义预览器包括 `rich-preview`（`.md`/`.csv`/`.json`/`.ipynb`）和 `ouch`（压缩包）。

- 配色主题（`flavors/`）：ayu-dark、catppuccin-mocha、kanagawa-dragon
- 插件（`plugins/`）：full-border、git、open-with-cmd、rich-preview、vcs-files、zoom

### kitty（`config/kitty`）

`font_size` 设为 `13.0`。

## 备注

