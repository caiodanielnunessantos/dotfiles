vim.loader.enable()
prequire = function(x)
    local ok, err = pcall(require, x)
    if ok then return err end
end

vim.cmd.colorscheme 'wildcharm'
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = -1
vim.o.expandtab = true
vim.opt.sessionoptions = {
    -- 'buffers',
    'curdir',
    'folds',
    'help',
    'resize',
    'tabpages',
    'terminal',
    'winpos',
    'winsize',
}
vim.o.shortmess = 'aotTOsWAIcCFSq'
vim.o.laststatus = 3
vim.o.colorcolumn = '80'
vim.o.mouse = ''
vim.o.report = 999999
vim.o.updatecount = 0
vim.o.swapfile = false
vim.o.undolevels = 999999
vim.o.undoreload = 999999
vim.o.undofile = true
vim.o.timeout = false
vim.o.showcmdloc = 'statusline'
vim.o.showmode = false
vim.o.wrapscan = false

vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = true
vim.g.loaded_matchparen = 1

