# ~/.tmux/scripts/auto-dark-mode-tmux-gruvbox.sh
#!/usr/bin/env bash
set -euo pipefail

detect_dark_mode() {
  if osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode' | grep -qi true; then
    echo "dark"
  else
    echo "light"
  fi
}

apply_theme() {
  local mode="$1"
  # Elegimos 'dark' o 'light'. Si prefieres 256-colors, usa 'dark256'/'light256'.
  local theme="$mode"
  tmux set -g @tmux-gruvbox "$theme"
  # Re-sourcing del plugin para aplicar cambios de inmediato
  tmux run-shell "$HOME/.tmux/plugins/tmux-gruvbox/gruvbox-tpm.tmux" 2>/dev/null || true
  tmux run-shell "$HOME/.tmux/plugins/tmux-gruvbox/tmux-gruvbox.tmux" 2>/dev/null || true
}

main() {
  tmux has-session 2>/dev/null || exit 0

  local current=""
  while true; do
    local mode
    mode="$(detect_dark_mode)"
    if [ "$mode" != "$current" ]; then
      apply_theme "$mode"
      current="$mode"
    fi
    sleep 2
  done
}

main &
