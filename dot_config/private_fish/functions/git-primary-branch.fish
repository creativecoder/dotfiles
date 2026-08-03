function git-primary-branch
    git symbolic-ref refs/remotes/origin/HEAD | rev | cut -d / -f 1 | rev
end
