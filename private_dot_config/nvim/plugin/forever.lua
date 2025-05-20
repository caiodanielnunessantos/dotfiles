local inst = (vim.uv.os_environ() or {}).NVIM_INSTANCE_LOCKFILE

if not inst then
    vim.keymap.set({ 'n' }, 'çqq', function()
        vim.cmd 'qa!'
    end, { desc = 'Just Quit' })
else
    vim.keymap.set({ 'n' }, 'çqc', function()
        vim.uv.fs_unlink(inst .. '/open_again')
        vim.cmd 'qa!'
    end, { desc = 'Quit, really quit' })

    vim.keymap.set({ 'n' }, 'çqr', function()
        require 'nvim-tree.api'.tree.close()
        vim.cmd('silent! mksession! ' .. inst .. '/Session.vim')
        vim.cmd 'qa!'
    end, { desc = 'Reload' })

    vim.keymap.set({ 'n' }, 'çqq', function()
        vim.cmd 'qa!'
    end, { desc = 'Quit discarding open windows' })

    if (vim.uv.fs_stat(inst .. '/Session.vim') or {}).type == 'file' then
        vim.schedule(function()
            vim.cmd('silent! source ' .. inst .. '/Session.vim')
            vim.schedule(function()
                vim.uv.fs_unlink(inst .. '/Session.vim')
            end)
        end)
    end
end
