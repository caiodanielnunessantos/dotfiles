local data = vim.fn.stdpath 'data'
local pkgs = data .. '/site/pack/packages/start'
local packages = {}
local waiting
local messaged

local log = function(...)
    local m = {...}
    vim.schedule(function()
        local msgs = vim.g.install_package_logs or {}
        table.insert(msgs, os.date() .. '  ' .. tostring(vim.uv.hrtime()) .. '  ' .. vim.fn.join(m, ' '))
        vim.g.install_package_logs = msgs
    end)
end

local finish = function()
    vim.schedule(function()
        if #waiting == 0 and not messaged then
            messaged = true
            log 'Finished'
            vim.schedule(function() vim.cmd.helptags 'ALL' end)
        end
    end)
end

local download_from_git = function(url, name)
    if not vim.uv.fs_stat(pkgs) then
        vim.system{ 'mkdir', '--parents', pkgs }:wait()
    end
    local pkg = pkgs .. '/' .. name
    if not vim.uv.fs_stat(pkg) then
        return vim.system({ 'git', 'clone', '--depth=1', url, pkg }, {}, function(out)
            if out.code ~= 0 then
                log('Could not download', name)
                log(out.stderr)
            else
                log('Downloaded', name)
            end
            waiting[name] = nil
            finish()
        end)
    else
        return vim.system({ 'git', 'pull' }, { cwd = pkg }, function(out)
            if out.code ~= 0 then
                log('Could not update', name)
                log(out.stderr)
            else
                log('Updated', name)
            end
            waiting[name] = nil
            finish()
        end)
    end
end

local _ = function(user)
    if #user > 0 then
        return function(repo)
            packages[repo] = { url = 'https://github.com/' .. user .. '/' .. repo .. '.git/' } 
        end
    else
        return function(url)
            return function(name)
                packages[name] = { url = url }
            end
        end
    end
end


local update = function()
    waiting = vim.deepcopy(packages)
    messaged = false
    for k, v in pairs(packages) do
        download_from_git(v.url, k)
    end
end

local purge = function()
    vim.system { 'rm', '-rf', pkgs }:wait()
end

local clean = function()
    local should_delete = {}
    for i, pkg in pairs(vim.fn.readdir(pkgs)) do
        should_delete[pkg] = true
    end
    for name, p in pairs(packages) do
        should_delete[name] = nil
    end
    for name, p in pairs(should_delete) do
        vim.system { 'rm', '-rf', pkgs .. '/' .. name }:wait()
        log('Deleted', name)
    end
end

vim.api.nvim_create_user_command('Packages', function(args)
    local args = args.args
    if args == 'purge' then
        purge()
    elseif args == 'clean' then
        clean()
    elseif args == 'update' then
        update()
    elseif args == 'sync' then
        clean()
        update()
    elseif args == 'reboot' then
        purge()
        update()
    elseif args == 'log' then
        vim.iter(vim.g.install_package_logs or {}):each(print)
    else
        print 'Error, no such operation'
    end
end, { nargs = 1 })

-- _ 'LuaLS' 'lua-language-server'
_ 'rebelot' 'heirline.nvim'
_ 'Zeioth' 'heirline-components.nvim'
_ 'nvimdev' 'lspsaga.nvim'
_ 'folke' 'noice.nvim'
_ 'MunifTanjim' 'nui.nvim'
_ 'neovim' 'nvim-lspconfig'
_ 'rcarriga' 'nvim-notify'
_ 'nvim-tree' 'nvim-tree.lua'
_ 'nvim-treesitter' 'nvim-treesitter'
_ 'nvim-tree' 'nvim-web-devicons'
_ 'rachartier' 'tiny-inline-diagnostic.nvim'
_ 'akinsho' 'toggleterm.nvim'
_ 'moll' 'vim-bbye'
_ 'folke' 'which-key.nvim'
_ '' 'https://git.sr.ht/~p00f/clangd_extensions.nvim' 'clangd_extensions.nvim'
-- _ '' 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' 'lsp_lines.nvim'
_ 'vadimcn' 'codelldb'
_ 'OXY2DEV' 'markview.nvim'
_ 'mrcjkb' 'rustaceanvim'
_ 'b0o' 'SchemaStore.nvim'
_ 'folke' 'trouble.nvim'
_ 'mrcjkb' 'rustaceanvim'
_ 'mfussenegger' 'nvim-dap'
_ 'theHamsta' 'nvim-dap-virtual-text'
_ 'rcarriga' 'nvim-dap-ui'
_ 'vadimcn' 'codelldb'
_ 'nvimdev' 'indentmini.nvim'
_ 'b0o' 'SchemaStore.nvim'
_ 'tummetott' 'reticle.nvim'
_ 'nvim-telescope' 'telescope.nvim'
_ 'nvim-lua' 'plenary.nvim'
_ '3rd' 'image.nvim'
