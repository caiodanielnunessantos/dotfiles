local tid = require 'tiny-inline-diagnostic'

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
    callback = function(event)
        local bufnr = event.buf
        vim.wo.signcolumn = 'yes:1'
        vim.diagnostic.config {
            virtual_lines = false,
            virtual_text = false,
        }
        vim.keymap.set({ 'n' }, 'çd', tid.toggle)
        vim.keymap.set({ 'n' }, 'çfo', function()
            vim.lsp.buf.format {

            }
        end)
        vim.lsp.inlay_hint.enable()
        vim.keymap.set({ 'n' }, 'çi', function()
            if vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } then
                vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            else
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
        end, { buffer = bufnr })
    end,
})

tid.setup {
    preset = 'modern',
    options = {
        show_source = {
            enabled = true,
        },
        add_messages = true,
        multilines = {
            enabled = true,
            always_show = false,
        },
        show_all_diags_on_cursorline = true,

    }
}

