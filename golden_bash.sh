#!/usr/bin/env bash

# Initialize Golden Bash

# Reload Library
alias reload='source ~/.bash_profile'

# Only set $GOLDEN_BASH if it's not already set
if [ -z "${GOLDEN_BASH}" ];
then
  echo 'export $GOLDEN_BASH first!'
  exit
fi

# Load composure first, so we support function metadata
source "${GOLDEN_BASH}/lib/composure.sh"

# support 'plumbing' metadata
cite _about _param _example _group _author _version

# Load colors first so they can be use in other theme
source "${GOLDEN_BASH}/themes/colors.theme.bash"
source "${GOLDEN_BASH}/themes/scm.theme.bash"
source "${GOLDEN_BASH}/themes/languages.theme.bash"

# libraries
LIB="${GOLDEN_BASH}/lib/*.bash"
for config_file in $LIB
do
  if [ -e "${config_file}" ]; then
    source $config_file
  fi
done

# Load enabled plugins, aliases, completions
for file_type in 'plugins' 'aliases' 'completions'
do
  _load_golden_bash_files $file_type
done

unset config_file
if [[ $PROMPT ]]; then
  export PS1=$PROMPT
fi
