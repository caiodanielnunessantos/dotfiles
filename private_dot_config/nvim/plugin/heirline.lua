local heirline = require 'heirline'
local utils = require 'heirline.utils'
local conditions = require 'heirline.conditions'

local do_redraw = vim.schedule_wrap(function()
    vim.cmd.redrawstatus()
end)

local path_short = function(p)
    local cf = vim.fn.stdpath 'config'
    local dt = vim.fn.stdpath 'data'
    local pk = dt .. '/site/pack/packages/start'
    local cc = vim.fn.stdpath 'cache'
    local st = vim.fn.stdpath 'state'
    local hm = vim.env.HOME
    return p
        :gsub(cf, '(config)')
        :gsub(pk, '(plugin)')
        :gsub(dt, '(data)')
        :gsub(cc, '(cache)')
        :gsub(hm, '~')
end

local Cwd = {
    provider = function()
        return path_short(vim.uv.cwd())
    end,
    update = { 'DirChanged' },
}

local Separator = { provider = '%=', hl = utils.get_highlight 'NvimSpacing' }

local Mode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    provider = function(self)
        self.mode = vim.api.nvim_get_mode().mode
        return self.mode
    end,
    update = {
        'ModeChanged',
        pattern = '*:*',
        callback = do_redraw,
    },
}

local Lsp = {
    static = {
        w = vim.g.lua_workspace_messages,
        d = vim.g.lua_diagnosing_messages,
        f = vim.g.lua_diagnosed_files,
        cf = (vim.fn.stdpath 'config'):gsub('/', '', 1),
        dt = (vim.fn.stdpath 'data'):gsub('/', '', 1),
        pk = (vim.fn.stdpath 'data'):gsub('/', '', 1) .. '/site/pack/packages/start',
        cc = (vim.fn.stdpath 'cache'):gsub('/', '', 1),
        st = (vim.fn.stdpath 'state'):gsub('/', '', 1),
        hm = vim.env.HOME,

    },
    provider = function(self)
        if #vim.lsp.get_clients() == 0 then return '' end
        return string.format(
            '[W: %s][D: %s][F: %s]',
            self.w and self.w[#self.w] or '',
            self.d and self.d[#self.d] or '',
            (self.f and self.f[#self.f] or '')
                :gsub(self.pk, '(P)')
                :gsub(self.cf, '(C)')
                :gsub(self.dt, '(S)')
                :gsub(self.cc, '(c)')
                :gsub(self.st, '(s)')
        )
    end,
    update = {
        'LspProgress',
        pattern = '*',
        callback = do_redraw,
    },
}

local FileName = {
    provider = '%f',
}

local FileType = {
    provider = function()
        return '[' .. vim.api.nvim_get_option_value('filetype', { buf = 0 }) .. ']'
    end,
    update = { 'FileType' },
}

local FileModified = {
    provider = function(self)
        if #vim.api.nvim_get_option_value('buftype', { buf = 0 }) > 0 then return '' end
        self.modified = vim.api.nvim_get_option_value('modified', { buf = 0 })
        return self.modified and '[dirty]' or '[clean]'
    end,
    update = { 'BufModifiedSet' },
}

local spaces = function(n, s)
    s = s or ' '
    local r = ''
    while n > 0 do
        r = r .. s
        n = n - 1
    end
    return { provider = r }
end

local Ruler = { provider = '%l/%L(%c)', }

local Cmd = { provider = '%S' }

local Search = {
    condition = function()
        return vim.v.hlsearch > 0
    end,
    provider = function()
        local results = vim.fn.searchcount { recompute = true, maxcount = 999999 }
        return string.format('<%6d/%6d>', results.current, results.total)
    end,
    update = { 'CmdlineChanged', 'CursorMoved' },
}

heirline.setup {
    statusline = {Mode, Cwd, Cmd, Separator, Search, Lsp },
    winbar = { FileName, spaces(2), FileModified, Separator, FileType, spaces(1), Ruler }, opts = {
        disable_winbar_cb = function(args)
            return conditions.buffer_matches({
                buftype = { 'nofile', 'prompt', 'quickfix', 'terminal' },
                bufname = { '^$' },
            }, args.buf)
        end,
    },
}
