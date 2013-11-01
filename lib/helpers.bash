# Helper function loading various enable-able files

function _load_golden_bash_files() {
  subdirectory="$1"
  if [ ! -d "${GOLDEN_BASH}/${subdirectory}/enabled" ]
  then
    continue
  fi
  FILES="${GOLDEN_BASH}/${subdirectory}/enabled/*.bash"
  for config_file in $FILES
  do
    if [ -e "${config_file}" ]; then
      source $config_file
    fi
  done
}

function reload_aliases() {
  _load_golden_bash_files "aliases"
}

function reload_completion() {
  _load_golden_bash_files "completions"
}

function reload_plugins() {
  _load_golden_bash_files "plugins"
}


golden-bash() {
  about 'golden-bash help and maintenance'
  param '1: verb [one of: help | show | enable | disable ]'
  param '2: component type [one of: plugin(s) | alias(es) | completion(s) ]'
  param '3: specific component [optional]'
  example '$ golden-bash show plugins'
  example '$ golden-bash help aliases'
  example '$ golden-bash enable plugin git'
  example '$ golden-bash disable alias hg'

  typeset verb=${1:-}
  shift
  typeset component=${1:-}
  shift
  typeset func
  case $verb in
    show)
      func=_golden-bash-$component;;
    enable)
      func=_enable-$component;;
    disable)
      func=_disable-$component;;
    help)
      func=_help-$component;;
    *)
      reference golden-bash
      return;;
  esac

  # pluralize component if necessary
  if ! _is_function $func; then
    if _is_function ${func}s; then
      func=${func}s
    else
      if _is_function ${func}es; then
        func=${func}es
      else
        echo "oops! $component is not a valid option!"
        reference golden-bash
        return
      fi
    fi
  fi
  $func $*
}

function _is_function() {
  _about 'sets $? to true if parameter is the name of a function'
  _param '1: name of alleged function'
  _group 'lib'
  [ -n "$(type -a $1 2>/dev/null | grep 'is a function')" ]
}


_golden-bash-plugins() {
  _about 'summarizes available golden-bash plugins'
  _group 'lib'
  _golden_bash_describe "plugins" "a" "plugin" "Plugin"
}

_golden-bash-aliases() {
  _about 'summarizes available golden-bash aliases'
  _group 'lib'
  _golden_bash_describe "aliases" "an" "alias" "Alias"
}

_golden-bash-completions() {
  _about 'summarizes available golden-bash completions'
  _group 'lib'
  _golden_bash_describe "completions" "a" "completion" "Completion"
}

function _golden_bash_describe() {
  _about 'summarizes available golden-bash components'
  _param '1: subdirectory'
  _param '2: preposition'
  _param '3: file_type'
  _param '4: column_header'
  _example '$ _golden_bash_describe "plugins" "a" "plugin" "Plugin"'

  subdirectory="$1"
  preposition="$2"
  file_type="$3"
  column_header="$4"

  typeset f
  typeset enabled
  printf "%-20s%-10s%s\n" "$column_header" 'Enabled?' 'Description'
  for f in $GOLDEN_BASH/$subdirectory/available/*.bash
  do
    if [ -e $GOLDEN_BASH/$subdirectory/enabled/$(basename $f) ]; then
      enabled='x'
    else
      enabled=' '
    fi
    printf "%-20s%-10s%s\n" "$(basename $f | cut -d'.' -f1)" "  [$enabled]" "$(cat $f | metafor about-$file_type)"
  done
  printf '\n%s\n' "to enable $preposition $file_type, do:"
  printf '%s\n' "$ golden-bash enable $file_type <$file_type name> -or- $ golden-bash enable $file_type all"
  printf '\n%s\n' "to disable $preposition $file_type, do:"
  printf '%s\n' "$ golden-bash disable $file_type <$file_type name> -or- $ golden-bash disable $file_type all"
}


_disable-plugin() {
  _about 'disables golden-bash plugin'
  _param '1: plugin name'
  _example '$ disable-plugin rvm'
  _group 'lib'
  _disable_thing "plugins" "plugin" $1
}

_disable-alias() {
  _about 'disables golden-bash alias'
  _param '1: alias name'
  _example '$ disable-alias git'
  _group 'lib'
  _disable_thing "aliases" "alias" $1
}

_disable-completion() {
  _about 'disables golden-bash completion'
  _param '1: completion name'
  _example '$ disable-completion git'
  _group 'lib'
  _disable_thing "completions" "completion" $1
}

function _disable_thing() {
  _about 'disables a golden-bash component'
  _param '1: subdirectory'
  _param '2: file_type'
  _param '3: file_entity'
  _example '$ _disable_thing "plugins" "plugin" "ssh"'

  subdirectory="$1"
  file_type="$2"
  file_entity="$3"

  if [ -z "$file_entity" ]; then
    reference "disable-$file_type"
    return
  fi

  if [ "$file_entity" = "all" ]; then
    typeset f $file_type
    for f in $GOLDEN_BASH/$subdirectory/available/*.bash
    do
      plugin=$(basename $f)
      if [ -e $GOLDEN_BASH/$subdirectory/enabled/$plugin ]; then
        rm $GOLDEN_BASH/$subdirectory/enabled/$(basename $plugin)
      fi
    done
  else
    typeset plugin=$(command ls $GOLDEN_BASH/$subdirectory/enabled/$file_entity.*bash 2>/dev/null | head -1)
    if [ -z "$plugin" ]; then
      printf '%s\n' "sorry, that does not appear to be an enabled $file_type."
      return
    fi
    rm $GOLDEN_BASH/$subdirectory/enabled/$(basename $plugin)
  fi

  printf '%s\n' "$file_entity disabled."
}


_enable-plugin() {
  _about 'enables golden-bash plugin'
  _param '1: plugin name'
  _example '$ enable-plugin rvm'
  _group 'lib'
  _enable_thing "plugins" "plugin" $1
}

_enable-alias() {
  _about 'enables golden-bash alias'
  _param '1: alias name'
  _example '$ enable-alias git'
  _group 'lib'
  _enable_thing "aliases" "alias" $1
}

_enable-completion() {
  _about 'enables golden-bash completion'
  _param '1: completion name'
  _example '$ enable-completion git'
  _group 'lib'
  _enable_thing "completions" "completion" $1
}

function _enable_thing() {
  cite _about _param _example
  _about 'enables a golden-bash component'
  _param '1: subdirectory'
  _param '2: file_type'
  _param '3: file_entity'
  _example '$ _enable_thing "plugins" "plugin" "ssh"'

  subdirectory="$1"
  file_type="$2"
  file_entity="$3"

  if [ -z "$file_entity" ]; then
    reference "enable-$file_type"
    return
  fi

  if [ "$file_entity" = "all" ]; then
    typeset f $file_type
    for f in $GOLDEN_BASH/$subdirectory/available/*.bash
    do
      plugin=$(basename $f)
      if [ ! -h $GOLDEN_BASH/$subdirectory/enabled/$plugin ]; then
        ln -s $GOLDEN_BASH/$subdirectory/available/$plugin $GOLDEN_BASH/$subdirectory/enabled/$plugin
      fi
    done
  else
    typeset plugin=$(command ls $GOLDEN_BASH/$subdirectory/available/$file_entity.*bash 2>/dev/null | head -1)
    if [ -z "$plugin" ]; then
      printf '%s\n' "sorry, that does not appear to be an available $file_type."
      return
    fi

    plugin=$(basename $plugin)
    if [ -e $GOLDEN_BASH/$subdirectory/enabled/$plugin ]; then
      printf '%s\n' "$file_entity is already enabled."
      return
    fi

    mkdir -p $GOLDEN_BASH/$subdirectory/enabled

    ln -s $GOLDEN_BASH/$subdirectory/available/$plugin $GOLDEN_BASH/$subdirectory/enabled/$plugin
  fi

  printf '%s\n' "$file_entity enabled."
}


_help-plugins() {
  _about 'summarize all functions defined by enabled golden-bash plugins'
  _group 'lib'

  # display a brief progress message...
  printf '%s' 'please wait, building help...'
  typeset grouplist=$(mktemp /tmp/grouplist.XXXX)
  typeset func
  for func in $(typeset_functions)
  do
    typeset group="$(typeset -f $func | metafor group)"
    if [ -z "$group" ]; then
      group='misc'
    fi
    typeset about="$(typeset -f $func | metafor about)"
    letterpress "$about" $func >> $grouplist.$group
    echo $grouplist.$group >> $grouplist
  done
  # clear progress message
  printf '\r%s\n' '                              '
  typeset group
  typeset gfile
  for gfile in $(cat $grouplist | sort | uniq)
  do
    printf '%s\n' "${gfile##*.}:"
    cat $gfile
    printf '\n'
    rm $gfile 2> /dev/null
  done | less
  rm $grouplist 2> /dev/null
}

_help-aliases() {
  _about 'shows help for all aliases, or a specific alias group'
  _param '1: optional alias group'
  _example '$ alias-help'
  _example '$ alias-help git'

  if [ -n "$1" ]; then
    cat $GOLDEN_BASH/aliases/available/$1.aliases.bash | metafor alias | sed "s/$/'/"
  else
    typeset f
    for f in $GOLDEN_BASH/aliases/enabled/*
    do
      typeset file=$(basename $f)
      printf '\n\n%s:\n' "${file%%.*}"
      # metafor() strips trailing quotes, restore them with sed..
      cat $f | metafor alias | sed "s/$/'/"
    done
  fi
}

all_groups() {
  about 'displays all unique metadata groups'
  group 'lib'

  typeset func
  typeset file=$(mktemp /tmp/composure.XXXX)
  for func in $(typeset_functions)
  do
    typeset -f $func | metafor group >> $file
  done
  cat $file | sort | uniq
  rm $file
}
