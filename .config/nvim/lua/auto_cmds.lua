local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        if vim.g.disable_autoformat then
          return
        end
        vim.lsp.buf.format {
          async = false,
          -- id = args.data.client_id,
        }
      end,
    })
  end
})
