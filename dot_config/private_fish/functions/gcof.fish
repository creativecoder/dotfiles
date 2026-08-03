function gcof --description 'git checkout branch with fzf (sorted by committerdate)'
    # Are we in a git repo?
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    or begin
        echo "not a git repository" >&2
        return 128
    end

    # Current git branch
    set -l current (command git symbolic-ref --quiet --short HEAD 2>/dev/null)

    # Pick a branch via fzf (most recently committed-to first)
    set -l branch (command git branch --sort=-committerdate \
        # Exclude current branch
        | string match -v -- "*$current" \
        | command fzf --print0 --prompt='branch> ' \
        | string trim
    )

    test -n "$branch"
    or return 0

    command git checkout "$branch"
end
