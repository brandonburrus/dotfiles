-- Pretty icons
return {
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
          name = "TsconfigJson",
          icon = "",
          color = "#007ACC",
        }
      }
    }
  end,
  'stevearc/dressing.nvim',
}