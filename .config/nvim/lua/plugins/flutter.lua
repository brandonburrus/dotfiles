return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
    'nvim-flutter/pubspec-assist.nvim'
  },
  config = function()
    require 'flutter-tools'.setup {
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "FlutterWidgetGuides",
        prefix = "",
        priority = 10,
        enabled = true,
      },
    }
  end
}
