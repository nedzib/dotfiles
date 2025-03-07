local fmt = string.format

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      opts = {
        language = "Español",
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.7-sonnet",
              },
              max_tokens = {
                default = 65536,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
      prompt_library = {
        ["Generate a Commit Message"] = {
          strategy = "chat",
          description = "Generate a commit message",
          prompts = {
            {
              role = 'system',
              content = function()
                return fmt(
                [[
                Escribe un mensaje de commit en español para el cambio siguiendo la convención de Commitizen. Asegúrate de que el título tenga un máximo de 100 caracteres y el mensaje esté ajustado a 72 caracteres. Agrega feat: fix: refactor: segun el nombre de la rama, a menos que todos los archivos editados sean de test en cuyo caso inciaria con test:. Envuelve todo el mensaje en un bloque de código con el lenguaje gitcommit.
                ```diff
                %s
                ```
                branch name: %s
                ]],
                vim.fn.system("git diff --no-ext-diff --staged"),
                vim.fn.system("git branch --show-current")
                )
              end,
              opts = {
                contains_code = true,
                visible = false,
              },
            },
            {
              role = 'user',
              content = "Escribe el mensaje de commit aquí y usa @cmd_runner para ejecutar el comando `git commit -m \"tu mensaje\"`.",
              opts = {
                contains_code = false,
              },
            }
          },
        },
      }
    },
  },
  vim.keymap.set({ "n", "v" }, "<leader>ac", ":CodeCompanionActions<CR>", { noremap = true, silent = true }),
  vim.keymap.set({ "n", "v" }, "<leader>aa", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true }),
  vim.keymap.set("v", "<leader>ga", ":CodeCompanionChat Add<CR>", { noremap = true, silent = true }),
}
