local autocmd = vim.api.nvim_create_autocmd

-- FileType fires before nvim-tree applies its winopts (which suppresses events),
-- so we hook BufWinEnter to set statusline after the window is fully configured.
autocmd('BufWinEnter', {
  callback = function(args)
    if vim.bo[args.buf].filetype == 'NvimTree' then
      vim.opt_local.statusline = ' '
    end
  end,
})

-- Autoformat on save
-- autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("lsp", { clear = true }),
--   callback = function(args)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = args.buf,
--       callback = function()
--         if vim.g.disable_autoformat then
--           return
--         end
--         vim.lsp.buf.format {
--           async = false,
--           -- id = args.data.client_id,
--         }
--       end,
--     })
--   end
-- })
