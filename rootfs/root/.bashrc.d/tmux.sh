alias tnew="tmux new-session -s"
alias tn="tmux new-session -s"
alias ta="tmux attach-session -t"
alias tkill="tmux kill-session -t"
alias tk="tmux kill-session -t"
alias tls="tmux list-sessions"
alias tl="tmux list-sessions"
alias td="tmux detach"
alias trename="tmux rename-session -t"
alias tcapture="tmux capture-pane -p -S - -t"

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
