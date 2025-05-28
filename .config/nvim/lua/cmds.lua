local cmd = vim.api.nvim_create_user_command

cmd('Fmt', 'lua vim.lsp.buf.format({ async = false })', {})
cmd('DartFmt', '!dart format %', {})
cmd('Trim', [[%s/\s\+$//e]], {})
cmd('Write', 'noautocmd w', {})
cmd('Blame', 'GitBlameToggle', {})

cmd('FmtOff', function() vim.g.disable_autoformat = true end, {})
cmd('FmtOn', function() vim.g.disable_autoformat = false end, {})
