-- Visually display open buffers at the top of the editor
return {
  'akinsho/bufferline.nvim',
  config = function()
    local bg = '#201D26'
    local defaultObj = {
        fg = 'white',
        bg = bg
    }
    require('bufferline').setup({
      highlights = {
        fill = {
          fg = 'white',
          bg = '#1b1820'
        },
        background = {
          fg = 'white',
          bg = bg
        },
        buffer_visible = {
          fg = 'white',
          bg = bg,
          italic = false
        },
        buffer_selected = {
          fg = 'white',
          bg = bg,
          italic = false
        },
        tab = defaultObj,
        numbers = {
          fg = '#424457',
          bg = bg
        },
        numbers_visible = {
          fg = '#424457',
          bg = bg
        },
        numbers_selected = {
          fg = '#424457',
          bg = bg
        },
        diagnostic = defaultObj,
        diagnostic_visible = defaultObj,
        diagnostic_selected = defaultObj,
        hint = defaultObj,
        hint_visible = defaultObj,
        hint_selected = defaultObj,
        hint_diagnostic = defaultObj,
        hint_diagnostic_visible = defaultObj,
        hint_diagnostic_selected = defaultObj,
        info = defaultObj,
        info_visible = defaultObj,
        info_selected = defaultObj,
        info_diagnostic = defaultObj,
        info_diagnostic_visible = defaultObj,
        info_diagnostic_selected = defaultObj,
        warning = defaultObj,
        warning_visible = defaultObj,
        warning_selected = defaultObj,
        warning_diagnostic = defaultObj,
        warning_diagnostic_visible = defaultObj,
        warning_diagnostic_selected = defaultObj,
        error = defaultObj,
        error_visible = defaultObj,
        error_selected = defaultObj,
        error_diagnostic = defaultObj,
        error_diagnostic_visible = defaultObj,
        error_diagnostic_selected = defaultObj,
        modified = defaultObj,
        modified_visible = defaultObj,
        modified_selected = defaultObj,
        duplicate_selected = defaultObj,
        duplicate_visible = defaultObj,
        duplicate = defaultObj,
        separator_selected = {
          fg = bg,
          bg = bg
        },
        separator_visible = {
          fg = bg,
          bg = bg
        },
        separator = {
          fg = bg,
          bg = bg
        },
        indicator_selected = {
          fg = '#02a7ff',
          bg = bg
        },
        indicator_visible = {
          fg = bg,
          bg = bg
        },
        pick_selected = {
          fg = bg,
          bg = bg,
          italic = false
        },
        pick_visible = {
          fg = bg,
          bg = bg,
          italic = false
        },
        pick = {
          fg = bg,
          bg = bg,
          italic = false
        },
        offset_separator = defaultObj,
        trunc_marker = {
          fg = '#424457',
          bg = bg
        }
      },
      options = {
        buffer_close_icon = '',
        close_icon = '',
        diagnostics = "nvim_lsp",
        diagnostics = 'nvim_lsp',
        diagnostics_update_on_event = true,
        numbers = "ordinal",
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        sort_by = 'insert_at_end',
        custom_filter = function(buf_number)
          local filetype = vim.api.nvim_buf_get_option(buf_number, 'filetype')
          local filename = vim.api.nvim_buf_get_name(buf_number)
          local excluded_filetypes = {'help', 'quickfix', 'terminal'}
          local excluded_filenames = {'dashboard', 'NvimTree_1', '__FLUTTER_DEV_LOG__'}
          if vim.tbl_contains(excluded_filetypes, filetype) then
            return false
          end
          if vim.tbl_contains(excluded_filenames, filename) then
            return false
          end
          return true
        end,
      }
    })
  end
}
