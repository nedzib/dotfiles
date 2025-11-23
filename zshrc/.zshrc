export ZSH="$HOME/.oh-my-zsh"
# source $HOME/.zshrc_env
# personal configs
ZSH_THEME="robbyrussell"
plugins=(git rails bundler aliases colorize tmux)

# zsh conf
source $ZSH/oh-my-zsh.sh
export EDITOR='nvim'

# rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# other paths
eval "$(zoxide init zsh)"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/home/$USER/.cargo/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH=$PATH:/usr/bin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# nodenv setup
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

        # okteto setup
        export PATH="/usr/local/bin:$PATH"

# aliases
alias lzd='lazydocker'
alias spt='spotify_player'
alias buk='tmuxifier load-session buk-webapp'
alias lines='tmuxifier load-session lines'
alias rbcm='bin/rubocop -A $(git ls-files --modified | grep ".rb$")'
alias srbt='clear; echo -e && bin/spoom srb tc'
alias cls='clear; echo -e'
alias nvim='NODENV_VERSION=system nvim'

function meetings() {
    local total_minutes=0
    local start_time end_time
    
    # Obtener solo las líneas con las horas de los eventos
    icalBuddy -n -iep "datetime" eventsToday | grep -E '[0-9]{1,2}:[0-9]{2} [AP]M - [0-9]{1,2}:[0-9]{2} [AP]M' | while read -r line; do
        # Extraer la hora de inicio y fin
        start_time=$(echo "$line" | sed -E 's/([0-9]{1,2}:[0-9]{2} [AP]M) - ([0-9]{1,2}:[0-9]{2} [AP]M).*/\1/')
        end_time=$(echo "$line" | sed -E 's/([0-9]{1,2}:[0-9]{2} [AP]M) - ([0-9]{1,2}:[0-9]{2} [AP]M).*/\2/')
        
        # Convertir a formato de 24 horas y calcular minutos
        local start_hour end_hour start_min end_min
        
        # Inicio
        local sh_am_pm=$(echo "$start_time" | awk '{print $2}')
        local sh_parts=$(echo "$start_time" | awk '{print $1}')
        start_hour=$(echo "$sh_parts" | cut -d':' -f1)
        start_min=$(echo "$sh_parts" | cut -d':' -f2)
        if [[ "$sh_am_pm" == "PM" && "$start_hour" -ne 12 ]]; then
            start_hour=$((start_hour + 12))
        elif [[ "$sh_am_pm" == "AM" && "$start_hour" -eq 12 ]]; then
            start_hour=0
        fi
        
        # Fin
        local eh_am_pm=$(echo "$end_time" | awk '{print $2}')
        local eh_parts=$(echo "$end_time" | awk '{print $1}')
        end_hour=$(echo "$eh_parts" | cut -d':' -f1)
        end_min=$(echo "$eh_parts" | cut -d':' -f2)
        if [[ "$eh_am_pm" == "PM" && "$end_hour" -ne 12 ]]; then
            end_hour=$((end_hour + 12))
        elif [[ "$eh_am_pm" == "AM" && "$end_hour" -eq 12 ]]; then
            end_hour=0
        fi

        local start_in_minutes=$((start_hour * 60 + start_min))
        local end_in_minutes=$((end_hour * 60 + end_min))
        
        total_minutes=$((total_minutes + (end_in_minutes - start_in_minutes)))
    done

    # Convertir el total de minutos a horas con dos decimales
    local hours_in_meetings
    hours_in_meetings=$(awk "BEGIN {printf \"%.2f\", $total_minutes / 60}")
    
    if (( $(echo "$hours_in_meetings > 0" | bc -l) )); then
        echo "🗓️ Hoy tienes un total de ${hours_in_meetings} horas en reuniones."
    else
        echo "🎉 ¡Sin reuniones hoy! ¡Disfruta tu día! 🎉"
    fi
}

function gh_pr_stats() {
  local reviewed merged
  reviewed=$(gh pr list --search "reviewed-by:@me updated:>=$(date +%Y-%m-01) -author:@me -author:github-actions[bot] -author:dependabot[bot] -author:bermuditas -author:bot-capacitaciones is:merged" --json number | jq 'length' 2>/dev/null || echo "N/A")
  merged=$(gh pr list --author "@me" --state merged --search "merged:>=$(date +%Y-%m-01)" --json number | jq 'length' 2>/dev/null || echo "N/A")
  commented=$(gh pr list --search "commenter:@me updated:>=$(date +%Y-%m-01) is:merged" --json number | jq 'length' 2>/dev/null || echo "N/A")


  echo "💬 ${commented} | 🔍 ${reviewed} | ✅ ${merged}"
}

# Inicia el entorno de desarrollo: actualiza branch, instala gems si falta,
# corre migraciones pendientes y levanta Rails.
function devenv() {
  # Asegúrate de estar en un proyecto Rails
  if [[ ! -x bin/rails && ! -f config/application.rb ]]; then
    echo "❌ No parece un proyecto Rails (no encuentro bin/rails ni config/application.rb)."
    return 1
  fi

  # Detectar base: main o master
  if git show-ref --verify --quiet refs/remotes/origin/main; then
    base_branch="origin/main"
  else
    base_branch="origin/master"
  fi

  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  echo "🌿 Rama actual: $current_branch | Base: $base_branch"

  echo "🔄 git fetch..."
  git fetch origin

  # Rebase solo si hace falta; usa --autostash por si hay cambios locales
  if ! git merge-base --is-ancestor "$base_branch" "$current_branch"; then
    echo "🔁 Rebase (con autostash) sobre $base_branch..."
    git rebase --autostash "$base_branch" || {
      echo "❌ Rebase fallido. Resuelve conflictos y vuelve a intentar."
      return 1
    }
  else
    echo "✅ Rama ya está al día con $base_branch."
  fi

  # Gems: instala solo si faltan
  echo "📦 Revisando gems..."
  if ! bundle check >/dev/null 2>&1; then
    bundle install || { echo "❌ bundle install falló"; return 1; }
  else
    echo "✅ Gems OK."
  fi

  # Migraciones: solo si hay pendientes
  echo "🗃️ Revisando migraciones..."
  if bundle exec rails db:abort_if_pending_migrations >/dev/null 2>&1; then
    echo "✅ Sin migraciones pendientes."
  else
    echo "📚 Ejecutando rails db:migrate..."
    bundle exec rails db:migrate || { echo "❌ db:migrate falló"; return 1; }
  fi

  # Levantar servidor
  echo "🚀 Iniciando rails server..."
  rails server
}

# Prepara el entorno para iniciar un nuevo desarrollo:
# stashea cambios, actualiza con main/master, instala gems y migraciones si es necesario,
# limpia el working dir, crea una branch nueva y aplica el stash de vuelta.
function devkick() {
  # Detectar cambios y hacer stash si es necesario
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "💾 Cambios detectados. Guardando stash..."
    git stash push -u -m "auto-stash before devkick"
    had_stash=true
  else
    had_stash=false
  fi

  # Detectar rama base
  if git show-ref --verify --quiet refs/remotes/origin/main; then
    base_branch="main"
  else
    base_branch="master"
  fi

  # Actualizar rama base
  echo "📥 Actualizando $base_branch..."
  git checkout "$base_branch" && git pull origin "$base_branch"

  # Instalar gems si es necesario
  echo "📦 Revisando gems..."
  if ! bundle check >/dev/null 2>&1; then
    bundle install || { echo "❌ bundle install falló"; return 1; }
  else
    echo "✅ Gems OK."
  fi

  # Correr migraciones si hay pendientes
  echo "🗃️ Revisando migraciones..."
  if bundle exec rails db:abort_if_pending_migrations >/dev/null 2>&1; then
    echo "✅ Sin migraciones pendientes."
  else
    echo "📚 Ejecutando rails db:migrate..."
    bundle exec rails db:migrate || { echo "❌ db:migrate falló"; return 1; }
  fi

  # Limpiar working directory
  echo "🧹 Limpiando working dir..."
  git reset --hard

  # Crear nueva branch
  read "branch_name?🌱 Ingresa el nombre de la nueva branch: "
  git checkout -b "$branch_name"

  # Aplicar stash si había
  if [[ "$had_stash" = true ]]; then
    echo "♻️ Aplicando cambios desde stash..."
    git stash pop || echo "⚠️ Conflictos al aplicar stash. Revísalos manualmente."
  else
    echo "✅ No había stash previo."
  fi

  echo "🚀 Listo para desarrollar en '$branch_name'"
}

# Added by Windsurf
export PATH="/Users/nedzibsastoque/.codeium/windsurf/bin:$PATH"

# Added by Antigravity
export PATH="/Users/nedzibsastoque/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH=/Users/nedzibsastoque/.opencode/bin:$PATH
