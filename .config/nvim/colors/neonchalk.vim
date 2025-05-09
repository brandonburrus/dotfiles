if exists("syntax_on")
  syntax reset
endif

set background=dark
hi clear

hi Debug      guifg=#ff0000     guibg=#ff0000
hi Normal     guifg=#e8e8e8     guibg=#201d26
hi Menu       guifg=#555555     guibg=#201d26
hi White      guifg=#e8e8e8
hi Red        guifg=#e8212f
hi ErrorRed   guifg=#ff5050
hi Magenta    guifg=#da0caa
hi Purple     guifg=#7264ce
hi Violet     guifg=#364ded
hi Blue       guifg=#02a7ff
hi DarkBlue   guifg=#032756
hi SteelBLue  guifg=#8fbfdc
hi SelectBlue guibg=#003562
hi SearchBlue guifg=#4398c9
hi Cyan       guifg=#49c0b6
hi Green      guifg=#82cb4d
hi DarkGreen  guifg=#41b645
hi Orange     guifg=#ff8c00
hi Grey       guifg=#757575
hi DarkGrey   guifg=#3b3b40
hi LightGrey  guifg=#bababa
hi Delimiter  guifg=#dddddd

hi! Keyword       guifg=#da0caa cterm=italic gui=italic
hi! WinSeparator  guifg=#242529 guibg=#201d26
hi! VertSplit     guifg=#242529 guibg=#201d26
hi! StatusLineNC  guifg=#e8e8e8 guibg=#201d26
hi! StatusLine    guifg=#676767 guibg=#201d26
hi! LineNr        guifg=#3b3b40 guibg=#201d26
hi! VertSplit     guifg=#232a2f guibg=#201d26
hi! Title         guifg=#70b950
hi! CursorLine    guifg=NONE    guibg=#201d26
hi! CursorColumn  guifg=#1c1c1c guibg=#201d26

hi! DiffAdd         guifg=#82cb4d
hi! DiffChange      guifg=#005380
hi! DiffDelete      guifg=#730c13
hi! GitGutterAdd    guifg=#82cb4d
hi! GitGutterChange guifg=#005380
hi! GitGutterDelete guifg=#730c13

hi! link String Red
hi! link Function Blue
hi! link Variable Green
hi! link Identifier Green
hi! link Comment DarkGreen
hi! link Operator Delimiter
hi! link Type Cyan
hi! link Structure Cyan
hi! link Number Purple
hi! link Constant Purple
hi! link Regex Violet
hi! link Regexp Violet
hi! link Error ErrorRed
hi! link ErrorMsg ErrorRed
hi! link Visual SelectBlue
hi! link VisualNC SelectBlue
hi! link Search SelectBlue
hi! link IncSearch SelectBlue
hi! link CurSearch SelectBlue
hi! link Todo Orange
hi! link PreProc Grey
hi! link Special Cyan
hi! link Struct Cyan
hi! link Class Cyan
hi! link Directory Cyan

hi! link @variable Variable
hi! link @string.typescript String
hi! link @keyword.conditional.ternary.typescript Operator
hi! link @constant.builtin.typescript Keyword
hi! link @lsp.type.regexp Regex
hi! link @punctuation.special.vim Keyword
hi! link @constructor.lua Normal
hi! link @constructor.typescript Keyword
hi! link @punctuation.special.typescript Regex
hi! link @variable.builtin.typescript Keyword
hi! link @lsp.typemod.property.declaration.typescript Purple
hi! link @character.special.typescript Keyword
hi! link @boolean.typescript Keyword

hi! link DiagnosticError ErrorRed
hi! link DiagnosticWarn Orange
hi! link DiagnosticInfo SearchBlue
hi! link DiagnosticHint Grey
hi! link DiagnosticUnnecessary Grey
hi! link LspCodeLens SearchBlue

hi! link NvimTreeFolderName Blue
hi! link NvimTreeEmptyFolderName Blue
hi! link NvimTreeOpenedFolderName Blue
hi! link NvimTreeSymlinkFolderName Purple
hi! link NvimTreeOpenedFolderIcon Blue
hi! link NvimTreeClosedFolderIcon Blue

hi! link TroubleIconDirectory Blue
hi! link TroubleDirectory Grey
hi! link TroubleFsCount Grey
hi! link TroubleDiagnosticsCount Grey
hi! link TroubleDiagnosticsBasename Normal
hi! link TroubleDiagnosticsItemSource Grey
hi! link TroubleCode Grey
hi! link TroubleIndentWs Normal
hi! link TroubleNormal Normal
hi! link TroubleNormalNC Normal
hi! link TroubleText Normal

hi! link CmpItemAbbrDeprecated DarkGrey
hi! link CmpItemAbbrMatchFuzzy Green
hi! link CmpItemKindVariable Green
hi! link CmpItemKindInterface Cyan
hi! link CmpItemKindText Normal
hi! link CmpItemKindFunction Blue
hi! link CmpItemKindMethod Blue
hi! link CmpItemKindKeyword Magenta
hi! link CmpItemKindProperty Green
hi! link CmpItemKindUnit Cyan
hi! link CmpItemMenu Debug

hi! link Float Menu
hi! link NormalFloat Menu
hi! link FloatBorder Menu

hi! link TelescopeNormal Normal
hi! link TelescopeTitle Normal
hi! link TelescopeBorder Menu
