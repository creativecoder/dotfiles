# Override EDITOR global variable set by nano rpm package
set -x EDITOR hx

# Activate homebrew if available and not already activated
if test -d /home/linuxbrew/.linuxbrew; and not command -q brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source

    if status is-interactive
        if test -d (brew --prefix)/share/fish/completions
            set -p fish_complete_path (brew --prefix)/share/fish/completions
        end
        if test -d (brew --prefix)/share/fish/vendor_completions.d
            set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
    end
end

# PATH
# - Change path directly (`--path`) so that outdated paths aren't left in `$fish_user_paths`
# - `--move` paths to front to ensure they override any system settings
if test -n "$GOPATH"
    fish_add_path --move --path "$GOPATH/bin"
end

# mise dependency manager: activate manually to override current PATH entries until this point
if command -q mise
    mise activate fish | source
end

# bazzite-cli bling
# https://github.com/ublue-os/bazzite/blob/main/system_files/overrides/usr/share/bazzite-cli/bling.fish
test -f /usr/share/bazzite-cli/bling.fish && source /usr/share/bazzite-cli/bling.fish

# Commands to run in interactive sessions can go here
if status is-interactive
    # Starship prompt
    if command -q starship
        starship init fish | source
    end

    # Abbrevations
    abbr --add cz chezmoi
    abbr --add czg chezmoi git
    abbr --add db distrobox
    abbr --add dokku ssh -t dokku
    abbr --add fm fzf-make
    abbr --add fr fzf-make repeat
    abbr --add fh fzf-make history
    abbr --add gcm git checkout '(git-primary-branch)'
    abbr --add gmm git merge '(git-primary-branch)'
    abbr --add gshno git show --name-only HEAD
    abbr --add hg huggingface-cli
    abbr --add jc journalctl
    abbr --add jcu journalctl --user
    abbr --add lg lazygit
    abbr --add pm podman
    abbr --add pme podman exec
    abbr --add sc sudo systemctl
    abbr --add scdr sudo systemctl daemon-reload
    abbr --add scu systemctl --user
    abbr --add scudr systemctl --user daemon-reload

    # Aliases (simple functions)
    alias calibre-update="wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=~/Applications bin_dir=~/.local/bin share_dir=~/.local/share"
    alias godot="flatpak run org.godotengine.Godot"
    alias ll='eza -la --icons=auto --group-directories-first' # add `-a` to show hidden files/folders
    alias wp="export (grep 'DB_NAME' .env) && ~/.local/bin/wp"

    # Key bindings
    bind ctrl-alt-b gcof execute # Checkout git branch with fzf
end
