local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

map('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle file tree' })
map('n', '<leader>fe', ':Neotree focus<CR>', { desc = 'Focus file tree' })
map('n', '<leader>ff', ':Neotree reveal<CR>', { desc = 'Reveal current file in tree' })

map('n', '<leader>t', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end
  vim.cmd 'terminal'
end, { desc = 'Go to or open terminal' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

map('n', '<leader>co', ':CopilotChatOpen<CR>', { desc = 'Open CopilotChat' })
map('n', '<leader>cc', ':CopilotChatClose<CR>', { desc = 'Close CopilotChat' })
map('n', '<leader>ct', ':CopilotChatToggle<CR>', { desc = 'Toggle CopilotChat' })
