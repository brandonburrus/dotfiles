-- Pretty icons
return {
  'stevearc/dressing.nvim',
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require 'nvim-web-devicons'.setup {
        default = true,
        strict = true,
        variant = "dark",
        override_by_extension = {
          ["rs"] = {
            name = "Rust",
            icon = "",
            color = "#ce412b"
          },
          ["md"] = {
            name = "Markdown",
            icon = "",
            color = "#f1f1f1"
          }
        },
        override_by_filename = {
          ["Cargo.toml"] = {
            name = "CargoToml",
            icon = "",
            color = "#a43322"
          },
          ["Cargo.lock"] = {
            name = "CargoLock",
            icon = "",
            color = "#535353"
          },
          ["README.md"] = {
            name = "ReadmeMd",
            icon = "",
            color = "#41b645"
          },
          ["package.json"] = {
            name = "PackageJson",
            icon = "",
            color = "#339933"
          },
          ["nodemon.json"] = {
            name = "PackageJson",
            icon = "",
            color = "#339933"
          },
          ["tsconfig.json"] = {
            name = "DevIconTSConfig",
            icon = "",
            color = "#007ACC",
          },
          ["Brewfile"] = {
            name = "DevIconBrewfileOverride",
            icon = "",
            color = "#41b645"
          }
        }
      }
    end,
  }
}
