vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'Lua 5.4' },
            semantic = { keyword = true },
            format = { enable = true },
            workspace = {
                checkThirdParty = false,
                preloadFileSize = 50000,
            },
            completion = {
                autoRequire = true,
                callSnippet = 'Both',
                displayContext = 50,
                keywordSnippet = 'Disable',
                showWord = 'Disable',
                workspaceWord = false,
            },
            diagnostics = {workspaceRate = 100, libraryFiles = 'Disable', workspaceDelay = 500, },
            hint = { enable = true, paramName = 'All', setTime = true, },
            hover = { enable = true, enumsLimit = 50, },
        },
    },
    on_init = function(client)
        vim.api.nvim_create_autocmd({ 'LspProgress' }, {
            callback = function(event)
                local msg = vim.tbl_get(event, 'data', 'params', 'value', 'message')
                local kind = vim.tbl_get(event, 'data', 'params', 'value', 'kind')
                local title = vim.tbl_get(event, 'data', 'params', 'value', 'title')
                if kind == 'report' and title == 'Loading workspace' then
                    local lua_workspace_messages = vim.g.lua_workspace_messages or {}
                    table.insert(lua_workspace_messages, msg)
                    vim.g.lua_workspace_messages = lua_workspace_messages
                elseif kind == 'report' and title == 'Diagnosing workspace' then
                    local lua_diagnosing_messages = vim.g.lua_diagnosing_messages or {}
                    table.insert(lua_diagnosing_messages, msg)
                    vim.g.lua_diagnosing_messages = lua_diagnosing_messages
                elseif kind == 'begin' and title == 'Diagnosing' then
                    local lua_diagnosed_files = vim.g.lua_diagnosed_files or {}
                    table.insert(lua_diagnosed_files, msg)
                    vim.g.lua_diagnosed_files = lua_diagnosed_files
                end
            end,
        })
        if vim.fn.getcwd() == vim.fn.stdpath 'config' then
            client:_add_workspace_folder(vim.fn.getcwd())
            client.config.settings.Lua = vim.tbl_deep_extend('force',
                client.config.settings.Lua, {
                    workspace = {
                        library = {
                        vim.fn.stdpath 'config',
                        vim.fn.stdpath 'data',
                        vim.env.VIMRUNTIME,
                        '${3rd}/luv/library',
                    },
                    runtime = { version = 'LuaJIT' },
                }
            })
        end
    end,
})
vim.lsp.enable 'lua_ls'
local o = vim.opt_local
o.number = true

