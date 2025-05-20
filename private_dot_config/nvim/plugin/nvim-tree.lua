local nvim_tree = require 'nvim-tree'
local api = require 'nvim-tree.api'

nvim_tree.setup {
    on_attach = function(bufnr)
        local k = function(k, m, d)
            vim.keymap.set(
                { 'n' },
                k,
                m,
                {
                    buffer = bufnr,
                    remap = false,
                    silent = true,
                    desc = 'NvimTree: ' .. (d or ''),
                }
            )
        end
        k('h', function()
            vim.cmd.tcd'..'
        end)
        k('l', api.node.open.edit)
        k('d', api.fs.trash)
        k('r', api.fs.rename_full)
        k('e', api.tree.expand_all)
        k('E', api.tree.collapse_all)
        k('v', api.node.open.vertical)
        k('s', api.node.open.horizontal)
        k('a', api.fs.create)
        k(' ', api.marks.toggle)
        k('H', api.tree.toggle_hidden_filter)
        k('.', function()
            local p = api.tree.get_node_under_cursor()
            if p then p = p.absolute_path else return end
            local c = vim.uv.cwd()
            if p and p ~= c then
                vim.cmd.tcd(p)
            end
        end)
    end,
    actions = {
        open_file = {
            window_picker = {
                enable = false,
            },
        },
    },
    hijack_cursor = true,
    diagnostics = { enable = true },
    disable_netrw = true,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    view = {
        preserve_window_proportions = false,
        debounce_delay = 100,
        centralize_selection = true,
        cursorline = true,
        signcolumn = 'no',
        width = {
            min = 1,
            max = -1,
            padding = 0,
        },
    },
    renderer = {
        group_empty = true,
        root_folder_label = false,
        highlight_opened_files = 'all',
        highlight_git = 'all',
        highlight_diagnostics = 'all',
        highlight_bookmarks = 'all',
        special_files = {},
        indent_markers = {
            enable = true,
        },
    },
}

local Event = api.events.Event
api.events.subscribe(Event.TreeOpen, function()
    vim.g.NT_is_open = true
end)

api.events.subscribe(Event.TreeClose, function()
    vim.g.NT_is_open = false
end)

vim.keymap.set({ 'n' }, '|', function()
    if not api.tree.is_visible() then
        api.tree.toggle { path = vim.uv.cwd(), focus = false }
        api.tree.find_file { buf = 0 }
    else
        if not api.tree.is_tree_buf() then
            api.tree.find_file { buf = 0, focus = true }
        end
    end
end)

vim.keymap.set({ 'n' }, '\\', function()
    if not api.tree.is_visible() then
        api.tree.toggle { path = vim.uv.cwd(), focus = false }
    else
        if not api.tree.is_tree_buf() then
            api.tree.open()
        else
            api.tree.close()
        end
    end
end, { desc = 'Toggle NvimTree' })

