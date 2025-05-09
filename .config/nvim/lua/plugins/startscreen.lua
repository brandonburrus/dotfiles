-- Initial load screen when opening nvim
return {
  'mhinz/vim-startify',
  init = function()
    vim.g.startify_change_to_dir = 1
    vim.g.startify_change_to_vcs_root = 1
    vim.g.startify_files_number = 10
    vim.g.startify_session_autoload = 1
    vim.g.startify_session_persistence = 1
    vim.g.startify_session_sort = 1
    vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
    
    vim.g.startify_lists = {
        { type = 'sessions',  header = { '   Projects' } },
        { type = 'files',     header = { '   Recently opened' } },
        { type = 'bookmarks', header = { '   Bookmarks' } },
        { type = 'commands',  header = { '   Commands' } },
    }
    
    vim.g.startify_skiplist = { 'COMMIT_EDITMSG' }
  end
}