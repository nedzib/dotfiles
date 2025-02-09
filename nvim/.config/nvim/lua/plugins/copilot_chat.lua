return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot  ",
        window = {
          width = 0.4,
        },
        prompts = {
          Explain = {
            prompt = "> /COPILOT_EXPLAIN\n\nEscribe una explicación para el código seleccionado en párrafos de texto. responde en español.",
          },
          Review = {
            prompt = "> /COPILOT_REVIEW\n\nRevisa el código seleccionado. responde en español.",
          },
          Fix = {
            prompt = "> /COPILOT_GENERATE\n\nHay un problema en este código. Reescribe el código para mostrarlo con el error corregido. responde en español.",
          },
          Optimize = {
            prompt = "> /COPILOT_GENERATE\n\nOptimiza el código seleccionado para mejorar el rendimiento y la legibilidad. responde en español.",
          },
          Docs = {
            prompt = "> /COPILOT_GENERATE\n\nPor favor, agrega comentarios de documentación al código seleccionado. responde en español.",
          },
          Tests = {
            prompt = "> /COPILOT_GENERATE\n\nPor favor, genera pruebas para mi código. responde en español.",
          },
          Commit = {
            prompt = "> #branch\n\n#git:staged\n\nEscribe un mensaje de commit en español para el cambio siguiendo la convención de Commitizen. Asegúrate de que el título tenga un máximo de 100 caracteres y el mensaje esté ajustado a 72 caracteres. Agrega feat: fix: refactor: segun el nombre de la rama, a menos que todos los archivos editados sean de test en cuyo caso inciaria con test:. Envuelve todo el mensaje en un bloque de código con el lenguaje gitcommit.",
          },
          Roast = {
            prompt = "Hazle un roast con actitud ironica y chistes crueles sobre el código seleccionado.",
          },
        },
        contexts = {
          branch = {
            description = "Requires `git`. Includes the current git branch name in chat context.",
            input = function(callback)
              callback(nil)
            end,
            resolve = function(input, source)
              local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
              if not handle then
                return {
                  {
                    content = "Error: Unable to retrieve the current branch name.",
                    filename = "branch_error",
                    filetype = "text",
                  },
                }
              end
              local branch_name = handle:read("*a"):gsub("%s+", "")
              handle:close()

              if not branch_name or branch_name == "" then
                return {
                  {
                    content = "Error: Unable to retrieve the current branch name.",
                    filename = "branch_error",
                    filetype = "text",
                  },
                }
              end
              return {
                {
                  content = "Current branch: " .. branch_name,
                  filename = "current_branch",
                  filetype = "text",
                },
              }
            end,
          },
        },
      }
    end,
  },
}
