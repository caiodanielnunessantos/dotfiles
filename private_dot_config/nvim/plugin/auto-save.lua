vim.g.auto_save_enabled = true

local get = function(buf, name)
    return vim.api.nvim_get_option_value(name, { buf = buf })
end

local name = vim.api.nvim_buf_get_name

vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWinLeave', 'TextChanged', 'TextChangedI' }, {
    callback = function(event)
        if not vim.g.auto_save_enabled then return end
        local buf = event.buf
        if vim.b[buf].auto_save_disabled then return end
        if #get(buf, 'buftype') > 0 then return end
        if #name(buf) == 0 then return end
        if not get(buf, 'modifiable') then return end
        if not get(buf, 'modified') then return end
        vim.cmd 'silent! write'
    end
})

vim.keymap.set({ 'n' }, 'ças', function()
    vim.b.auto_save_disabled = not vim.b.auto_save_disabled
    print(vim.b.auto_save_disabled and 'Buffer-local auto save is OFF' or 'Buffer-local auto save is ON')
end)

vim.keymap.set({ 'n' }, 'çaS', function()
    vim.g.auto_save_enabled = not vim.g.auto_save_enabled
    print(vim.g.auto_save_enabled and 'Auto save is ON' or 'Auto save is OFF')
end)
