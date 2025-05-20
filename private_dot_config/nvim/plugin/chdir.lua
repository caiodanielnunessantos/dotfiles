local _ = function(key, path)
    vim.keymap.set({ 'n' }, key, function()
        vim.cmd.tcd(path)
    end)
end

_( 'çcn', vim.fn.stdpath 'config')
_( 'çcp', vim.fn.stdpath 'data')
_( 'çck', '~/.config/kitty')
