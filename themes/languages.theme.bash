#!/usr/bin/env bash

#### Ruby ####

RVM_THEME_PROMPT_PREFIX=' |'
RVM_THEME_PROMPT_SUFFIX='|'

RBENV_THEME_PROMPT_PREFIX=' |'
RBENV_THEME_PROMPT_SUFFIX='|'

RBFU_THEME_PROMPT_PREFIX=' |'
RBFU_THEME_PROMPT_SUFFIX='|'

function rvm_version_prompt {
  if which rvm &> /dev/null; then
    rvm=$(rvm tools identifier) || return
    echo -e "${RVM_THEME_PROMPT_PREFIX}${rvm}${RVM_THEME_PROMPT_SUFFIX}"
  fi
}

function rbenv_version_prompt {
  if which rbenv &> /dev/null; then
    rbenv=$(rbenv version-name) || return
    echo -e "${RBENV_THEME_PROMPT_PREFIX}${rbenv}${RBENV_THEME_PROMPT_SUFFIX}"
  fi
}

function rbfu_version_prompt {
  if [[ ${RBFU_RUBY_VERSION} ]]; then
    echo -e "${RBFU_THEME_PROMPT_PREFIX}${RBFU_RUBY_VERSION}${RBFU_THEME_PROMPT_SUFFIX}"
  fi
}

function ruby_version_prompt {
  echo -e "$(rbfu_version_prompt)$(rbenv_version_prompt)$(rvm_version_prompt)"
}


#### Python ####

VIRTUALENV_THEME_PROMPT_PREFIX=' |'
VIRTUALENV_THEME_PROMPT_SUFFIX='|'

function virtualenv_prompt {
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    virtualenv=`basename "${VIRTUAL_ENV}"`
    echo -e "${VIRTUALENV_THEME_PROMPT_PREFIX}${virtualenv}${VIRTUALENV_THEME_PROMPT_SUFFIX}"
  fi
}
