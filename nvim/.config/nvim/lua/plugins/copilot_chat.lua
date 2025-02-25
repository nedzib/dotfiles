return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function()
      return {
        auto_insert_mode = true,
        question_header = "  Ned ",
        answer_header = "  Copilot  ",
        window = {
          width = 0.3,
          border = "double",
        },
        prompts = {
          Explain = {
            prompt = "> /COPILOT_EXPLAIN\n\nEscribe una explicación para el código seleccionado en párrafos de texto.",
          },
          Review = {
            prompt = "> /COPILOT_REVIEW\n\nRevisa el código seleccionado.",
          },
          Fix = {
            prompt = "> /COPILOT_GENERATE\n\nHay un problema en este código. Reescribe el código para mostrarlo con el error corregido.",
          },
          Optimize = {
            prompt = "> /COPILOT_GENERATE\n\nOptimiza el código seleccionado para mejorar el rendimiento y la legibilidad.",
          },
          Docs = {
            prompt = "> /COPILOT_GENERATE\n\nPor favor, agrega comentarios de documentación al código seleccionado.",
          },
          Tests = {
            prompt = "> /COPILOT_GENERATE\n\nPor favor, genera pruebas para mi código.",
          },
          Commit = {
            prompt = "> #branch\n\n#git:staged\n\nEscribe un mensaje de commit en español para el cambio siguiendo la convención de Commitizen. Asegúrate de que el título tenga un máximo de 100 caracteres y el mensaje esté ajustado a 72 caracteres. Agrega feat: fix: refactor: segun el nombre de la rama, a menos que todos los archivos editados sean de test en cuyo caso inciaria con test:. Envuelve todo el mensaje en un bloque de código con el lenguaje gitcommit.",
          },
          YARD = {
            prompt = "Documenta con YARD el metodo seleccionado asegurate de dejar una linea de comentario vacio '#' al principio y al final de la documentacion.",
          },
        },
        system_prompt = "soy Ned, Software Engineer de Ruby on Rails, me gusta seguir las convenciones y crear codigo limpio que siga los principios SOLID, Documentar con YARD. quiero que la inteligencia artificial responda en español a menos que se le indique lo contrario, que hable con mi estilo: profesional pero cercano, usando expresiones relajadas, sin signos de exclamación al inicio ni mayúsculas en la primera letra. que explique conceptos técnicos con ejemplos prácticos, estructurando la respuesta cuando sea necesario. Y cuando pongas codigo de respuesta, no agregues las lineas de codigo a las que pertenecen",
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
