#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ls aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'

alias tw='typst watch --open=zathura'

#cd aliases
alias ~='cd ~'
alias c..='cd ..'

#mpv shuffle alias
alias mpvs='mpv --shuffle ./*'

#tex template copier
newtex() {
    # Copy template files
    cp -a ~/doc/textemplate/. ./

    # Check if in ~/doc subdirectory
    if [[ "$PWD" == "$HOME/doc"* ]]; then
        # Extract path parts relative to ~/doc
        rel_path="${PWD#$HOME/doc/}"
        IFS='/' read -ra parts <<< "$rel_path"

        # Only rename if we have at least course + assignment directories
        if [[ ${#parts[@]} -ge 2 ]]; then
            course="${parts[0]}"
            assignment="${parts[1]}"
            new_name="${course}-${assignment}.tex"
            
            # Safely rename main.tex if it exists
            if [[ -f "main.tex" ]]; then
                mv -- "main.tex" "$new_name"
            fi
        fi
    fi
}

# yazi wrapper
function yazi() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
#default to grep with color
alias grep='grep --color=auto'

#backup documents alias
function backdoc {
  cd ~/doc
  git add ./
  git commit -m $(date '+%Y-%m-%d')
  git push
}

eval "$(starship init bash)"
# . "$HOME/.cargo/env"

#source bash-completion
# source /etc/bash_completion.d

#add spicetify to path
export PATH=$PATH:/home/tbuckets/.spicetify
#ruby to path
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

#Make sure nvim is default for text files
export EDITOR=nvim
export VISUAL=nvim

# Environment for proton
export VKD3D_CONFIG=dxr11
export VKD3D_FEATURE_LEVEL=12_1
export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
export RADV_PERFTEST=rt

# VI MODE IN SHELL THIS IS LIT
set -o vi

# POKEMON UP TO GEN5 cause GEN6+ IS ASS
random_pokeget() {
    local pokemon_id=$((RANDOM % 647 + 1))
    local shiny_flag=""
    
    if (( RANDOM % 2048 == 0 )); then
        shiny_flag="--shiny"
    fi
    
    pokeget --hide-name "$pokemon_id" $shiny_flag
}
random_pokeget
. "/home/tbuckets/.local/share/bob/env/env.sh"
