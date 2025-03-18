if status is-interactive
	set -gx EDITOR nvim
	#function fish_prompt
	#	echo [$(date +%T)] $USER::(prompt_pwd --dir-length 3 --full-length-dirs 1)
	#end
end


if test -d /home/linuxbrew/.linuxbrew # Linux
	set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
else if test -d /opt/homebrew # MacOS
	set -gx HOMEBREW_PREFIX "/opt/homebrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
end

function code
  set location "$PWD/$argv"
  open -n -b "com.microsoft.VSCode" --args $location
end

fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin";
! set -q MANPATH; and set MANPATH ''; set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH;
! set -q INFOPATH; and set INFOPATH ''; set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH;

zoxide init fish | source
fzf --fish | source
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
fish_add_path -gP /usr/local/texlive/2024/bin/universal-darwin

set fzf_fd_opts --hidden --max-depth 5

# Base16 Shell

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/sanufar/miniconda/bin/conda
    eval /Users/sanufar/miniconda/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/Users/sanufar/miniconda/etc/fish/conf.d/conda.fish"
        . "/Users/sanufar/miniconda/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/Users/sanufar/miniconda/bin" $PATH
    end
end
# <<< conda initialize <<<

