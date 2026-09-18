local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add({
  extension = {
    mdx = 'markdown.mdx',
    astro = 'astro',
  },
})

autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

autocmd('TermOpen', {
  pattern = 'term://*',
  callback = function()
    set_terminal_keymaps()
  end,
})

autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.cmd [[
      highlight Normal guibg=none
      highlight NormalNC guibg=none
      highlight NonText guibg=none
      highlight EndOfBuffer guibg=none
    ]]
  end,
})
