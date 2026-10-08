# fzf shell integration: ctrl-r history, ctrl-t files, alt-c cd
if [[ $- == *i* ]] && command -v fzf >/dev/null; then
    # fzf >= 0.48 prints its own bindings; older apt builds ship them as a file
    if fzf --bash >/dev/null 2>&1; then
        eval "$(fzf --bash)"
    elif [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.bash
    fi
fi
