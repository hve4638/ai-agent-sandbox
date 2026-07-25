alias tnew="tmux new-session -s"
alias tn="tmux new-session -s"
alias ta="tmux attach-session -t"
alias tkill="tmux kill-session -t"
alias tk="tmux kill-session -t"
alias tls="tmux list-sessions"
alias tl="tmux list-sessions"
alias td="tmux detach"
alias trename="tmux rename-session -t"
alias tr="tmux rename-session -t"
alias tcapture="tmux capture-pane -p -S - -t"

alias claude="claude --dangerously-skip-permissions"
alias copilot="copilot --allow-all-tools"
alias codex="codex --yolo"
alias gemini="gemini --yolo"

alias pg='cd /playground'

if [ -n "$SSH_TTY" ] && [ -z "$TMUX" ]; then
    if tmux list-sessions 2>/dev/null >/dev/null; then
        echo -e "TMUX Sessions"
        tmux list-sessions -F "* #{session_name}" 2>/dev/null
        echo ""
    else
        echo "No tmux session"
    fi
    echo "tmux usage: tn [session_name] | ta [session_name] | tk [session_name] | tl"
fi

export LC_ALL=ko_KR.UTF-8
export LANG=ko_KR.UTF-8
export IS_SANDBOX=1

tarzip() {
  if [ "$#" -ne 1 ]; then
    echo "usage: tarzip <directory>"
    return 1
  fi

  local input="$1"
  local path="$input"

  # trailing slash 제거 (/ 하나만 남는 경우는 제외)
  while [ "$path" != "/" ] && [ "${path%/}" != "$path" ]; do
    path="${path%/}"
  done

  # 루트 디렉토리 금지
  if [ "$path" = "/" ]; then
    echo "error: root directory '/' is not allowed"
    return 1
  fi

  # 디렉토리만 허용
  if [ ! -d "$path" ]; then
    echo "error: '$input' is not a directory"
    return 1
  fi

  local base parent out
  base="$(basename "$path")"
  parent="$(dirname "$path")"
  out="${base}.tar.gz"

  # 출력 파일이 이미 있으면 실패
  if [ -e "$out" ]; then
    echo "error: output file '$out' already exists"
    return 1
  fi

  tar -czvf "$out" -C "$parent" "$base"
}
