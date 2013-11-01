#!/usr/bin/env bash

# colored grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;33'

# colored ls
export LSCOLORS='Gxfxcxdxdxegedabagacad'

# Load the theme
if [[ $GOLDEN_BASH_THEME ]]; then
  source "$GOLDEN_BASH/themes/$GOLDEN_BASH_THEME/$GOLDEN_BASH_THEME.theme.bash"
fi
