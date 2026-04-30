return {
    'Kurama622/llm.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    cmd = { 'LLMSessionToggle', 'LLMSelectedTextHandler', 'LLMAppHandler' },
    keys = {
        { '<leader>cc', mode = 'n', '<cmd>LLMSessionToggle<cr>' },
        { '<leader>ce', mode = 'v', ':LLMSelectedTextHandler ' },
        { '<leader>ca', mode = { 'n', 'v' }, ':LLMAppHandler ' },
    },
    config = function()
        local url_str = vim.env.ARK_API_KEY
        local id_str = vim.env.ARK_EPID
        require("llm").setup({
            models = {
                {
                    name = "Kimi-K2.5",
                    url = vim.env.ARK_URL,
                    model = vim.env.KIMI_EPID,
                    api_type = "openai",
                },
                {
                    name = "Doubao-Seed-2.0-pro",
                    url = vim.env.ARK_URL,
                    model = vim.env.DOUBAO_EPID,
                    api_type = "openai",
                },
                {
                    name = "GLM",
                    url = vim.env.ARK_URL,
                    model = vim.env.GLM_EPID,
                    api_type = "openai",
                },
                {
                    name = "gpt-5.4-pro",
                    url = vim.env.GPT_URL,
                    model = vim.env.GPT_EPID,
                    api_type = "openai",
                },
                {
                    name = "deepseek-v4-flash",
                    url = "https://api.deepseek.com/chat/completions",
                    model = "deepseek-v4-flash",
                    api_type = "openai",
                },
            },
            keys = {
                ["Input:Submit"] = { mode = { "n", "i" }, key = "<C-CR>" },
                ["Input:Cancel"] = { mode = { "n", "i" }, key = "<C-c>" },
                ["Input:Resend"] = { mode = { "n", "i" }, key = "<C-r>" },
            },
            display = {
                diff = {
                    layout = "vertical",
                    opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
                    provider = "mini_diff",
                    disable_diagnostic = true,
                },
            },
            app_handler = {
                -- 翻译光标下单词
                WordTranslate = {
                    handler = "flexi_handler",
                    prompt = [[You are a translation expert. Your task is to translate all the text provided by the user into Chinese.

NOTE:
- All the text input by the user is part of the content to be translated, and you should ONLY FOCUS ON TRANSLATING THE TEXT without performing any other tasks.
- RETURN ONLY THE TRANSLATED RESULT.]],
                    opts = {
                        exit_on_move = true,
                        enter_flexible_window = false,
                        enable_cword_context = true,
                    },
                },
                -- 解释选中代码
                CodeExplain = {
                    handler = "flexi_handler",
                    prompt = "Explain the following code, please only return the explanation, and answer in Chinese",
                    opts = {
                        enter_flexible_window = true,
                    },
                },
                -- AI 生成 git commit message
                CommitMsg = {
                    handler = "flexi_handler",
                    prompt = function()
                        return string.format(
                            [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
1. First line: conventional commit format (type: concise description)
2. Optional bullet points if more context helps:
   - Keep the second line blank
   - Keep them short and direct
   - Focus on what changed
   - Always be terse
   - Don't overly explain
   - Drop any fluffy or formal language

Return ONLY the commit message - no introduction, no explanation, no quotes around it.
Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:

```diff
%s
```
]],
                            vim.fn.system("git diff --no-ext-diff --staged")
                        )
                    end,
                    opts = {
                        enter_flexible_window = true,
                        apply_visual_selection = false,
                        win_opts = {
                            relative = "editor",
                            position = "50%",
                        },
                    },
                },
                -- 交互式翻译 Q&A
                Translate = {
                    handler = "qa_handler",
                    opts = {
                        component_width = "60%",
                        component_height = "50%",
                        query = {
                            title = " 󰊿 Trans ",
                            hl = { link = "Define" },
                        },
                        input_box_opts = {
                            size = "15%",
                            win_options = { winhighlight = "Normal:Normal,FloatBorder:FloatBorder" },
                        },
                        preview_box_opts = {
                            size = "85%",
                            win_options = { winhighlight = "Normal:Normal,FloatBorder:FloatBorder" },
                        },
                    },
                },
                -- 一次性内联提问 (带 diff)
                Ask = {
                    handler = "disposable_ask_handler",
                    opts = {
                        position = { row = 2, col = 0 },
                        title = " Ask ",
                        inline_assistant = true,
                        enable_buffer_context = true,
                        language = "Chinese",
                        diagnostic = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
                        display = { mapping = { mode = "n", keys = { "d" } }, action = nil },
                        accept = { mapping = { mode = "n", keys = { "Y", "y" } }, action = nil },
                        reject = { mapping = { mode = "n", keys = { "N", "n" } }, action = nil },
                        close = { mapping = { mode = "n", keys = { "<esc>" } }, action = nil },
                    },
                },
                -- 将选中代码附加到聊天上下文
                AttachToChat = {
                    handler = "attach_to_chat_handler",
                    opts = {
                        is_codeblock = true,
                        inline_assistant = true,
                        diagnostic = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
                        language = "Chinese",
                        display = { mapping = { mode = "n", keys = { "d" } }, action = nil },
                        accept = { mapping = { mode = "n", keys = { "Y", "y" } }, action = nil },
                        reject = { mapping = { mode = "n", keys = { "N", "n" } }, action = nil },
                        close = { mapping = { mode = "n", keys = { "<esc>" } }, action = nil },
                    },
                },
                -- 左右对比优化代码
                OptimizeCode = {
                    handler = "side_by_side_handler",
                    opts = {
                        left = { focusable = false },
                        diagnostic = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
                    },
                },
                -- 优化代码并以 diff 形式展示
                OptimCompare = {
                    handler = "action_handler",
                    opts = {
                        language = "Chinese",
                        diagnostic = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
                    },
                },
                -- 生成测试用例
                TestCode = {
                    handler = "side_by_side_handler",
                    prompt = [[ Write some test cases for the following code, only return the test cases.
Give the code content directly, do not use code blocks or other tags to wrap it. ]],
                    opts = {
                        right = {
                            border = {
                                style = "rounded",
                                text = { top = " Test Cases ", top_align = "center" },
                            },
                        },
                    },
                },
                -- 生成文档注释
                DocString = {
                    handler = "action_handler",
                    prompt = [[ You are an AI programming assistant. You need to write a really good docstring that follows a best practice for the given language.

Your core tasks include:
- parameter and return types (if applicable).
- any errors that might be raised or returned, depending on the language.

You must:
- Place the generated docstring before the start of the code.
- Follow the format of examples carefully if the examples are provided.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.]],
                    opts = {
                        only_display_diff = true,
                        templates = {
                            lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".
]],
                            python = [[- For Python, use Google style docstrings.]],
                        },
                    },
                },
            },
        })
    end,
}
