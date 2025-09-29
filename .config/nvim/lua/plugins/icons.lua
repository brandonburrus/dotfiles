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
            icon = "",
            color = "#a0a0a0"
          },
          ["css"] = {
            name = "CSS",
            icon = "",
            color = "#2965f1"
          },
          ["scss"] = {
            name = "Scss",
            icon = "",
            color = "#c6538c"
          },
          ["sass"] = {
            name = "Sass",
            icon = "",
            color = "#c6538c"
          },
          ["lock"] = {
            name = "Lock",
            icon = "",
            color = "#515151"
          },
          ["toml"] = {
            name = "Toml",
            icon = "",
            color = "#9c4221"
          },
          ["yml"] = {
            name = "Yaml",
            icon = "",
            color = "#cb171e"
          },
          ["yaml"] = {
            name = "Yaml",
            icon = "",
            color = "#cb171e"
          },
          ["json"] = {
            name = "Json",
            icon = "",
            color = "#f5af02"
          },
          ["dart"] = {
            name = "Dart",
            icon = "",
            color = "#0175c2"
          },
          ["test.ts"] = {
            name = "TestTs",
            icon = "",
            color = "#358ef1",
          },
          ["e2e.ts"] = {
            name = "TestE2ETs",
            icon = "",
            color = "#358ef1",
          },
          ["test.tsx"] = {
            name = "TestTsx",
            icon = "",
            color = "#358ef1",
          },
          ["tsx"] = {
            name = "Tsx",
            icon = "ﰆ",
            color = "#358ef1",
          },
          ["d.ts"] = {
            name = "DTs",
            icon = "",
            color = "#a0a0a0",
          },
          ["ts"] = {
            name = "Ts",
            icon = "",
            color = "#358ef1",
          },
          ["js"] = {
            name = "Js",
            icon = "",
            color = "#f0db4f",
          },
          ["pem"] = {
            name = "Pem",
            icon = "",
            color = "#519aba"
          },
          ["vue"] = {
            name = "Vue",
            icon = "﵂",
            color = "#41b883"
          },
          ["Dockerfile"] = {
            name = "Dockerfile",
            icon = "",
            color = "#2496ed"
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
            name = "DevIconReadmeMd",
            icon = "",
            color = "#7ab800",
          },
          ["README"] = {
            name = "DevIconReadmeMd",
            icon = "",
            color = "#7ab800",
          },
          ["package.json"] = {
            name = "PackageJson",
            icon = "",
            color = "#339933"
          },
          ["package-lock.json"] = {
            name = "PackageLockJson",
            icon = "",
            color = "#339933"
          },
          ["nodemon.json"] = {
            name = "PackageJson",
            icon = "",
            color = "#339933"
          },
          ["tsconfig.json"] = {
            name = "DevIconTSConfig",
            icon = "ﬥ",
            color = "#358ef1",
          },
          ["vite.config.ts"] = {
            name = "DevIconViteTSConfig",
            icon = "",
            color = "#358ef1",
          },
          ["vitest.config.ts"] = {
            name = "DevIconVitestTSConfig",
            icon = "",
            color = "#358ef1",
          },
          ["cypress.config.ts"] = {
            name = "DevIconCypressTSConfig",
            icon = "",
            color = "#358ef1",
          },
          ["Brewfile"] = {
            name = "DevIconBrewfileOverride",
            icon = "",
            color = "#a26eea"
          },
          ["biome.json"] = {
            name = "DevIconBiome",
            icon = "",
            color = "#0cb9c1"
          },
          ["cdk.json"] = {
            name = "deviconcdk",
            icon = "",
            color = "#ff9900"
          },
          ["cdk.context.json"] = {
            name = "deviconcdk",
            icon = "",
            color = "#ff9900"
          },
          ["gulpfile.js"] = {
            name = "DevIconGulpfile",
            icon = "",
            color = "#cf4647"
          },
          ["Dockerfile"] = {
            name = "DevIconDockerfile",
            icon = "",
            color = "#2496ed"
          },
          ["LICENSE"] = {
            name = "License",
            icon = "",
            color = "#a0a0a0"
          },
          [".env"] = {
            name = "Env",
            icon = "",
            color = "#519aba"
          },
          [".env.example"] = {
            name = "EnvExample",
            icon = "",
            color = "#519aba"
          },
        }
      }
    end,
  }
}
