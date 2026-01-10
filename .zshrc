#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#
# -----------------------------------------------------
# ML4W zshrc loader
# -----------------------------------------------------

# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/zshrc
# or by creating a folder ~/.config/zshrc/custom
# with copies of files from ~/.config/zshrc
# -----------------------------------------------------

# -----------------------------------------------------
# Load modular configuration
# -----------------------------------------------------

for f in ~/.config/zshrc/*; do
    if [ ! -d $f ]; then
        c=`echo $f | sed -e "s=.config/zshrc=.config/zshrc/custom="`
        [[ -f $c ]] && source $c || source $f
    fi
done

# -----------------------------------------------------
# Load single customization file (if exists)
# -----------------------------------------------------

if [ -f ~/.zshrc_custom ]; then
    source ~/.zshrc_custom
fi

### Conda lazy loading
# --- fast conda: lazy-load on first use ---
# export PATH="/opt/anaconda/bin:$PATH"
# export CONDA_CHANGEPS1=false   # optional: avoid prompt fiddling unless you want it

# conda() {
#   # remove this wrapper after first call
#   unset -f conda

#   # load conda shell integration (needed for `conda activate`)
#   if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
#     source "/opt/anaconda/etc/profile.d/conda.sh"
#   else
#     echo "conda.sh not found: /opt/anaconda/etc/profile.d/conda.sh" >&2
#     return 1
#   fi

#   # now re-run the original command with real conda functions available
#   conda "$@"
# }
# -----------------------------------------



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/opt/anaconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
#        . "/opt/anaconda/etc/profile.d/conda.sh"
#    else
#        export PATH="/opt/anaconda/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

