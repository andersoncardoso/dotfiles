#!/bin/bash
# virtualenv-auto-activate.sh
#
# Installation:
#   Add this line to your .bashrc or .bash-profile:
#
#       source /path/to/virtualenv-auto-activate.sh
#

function _virtualenv_auto_activate() {
    if [ -e ".python-env" ]; then
        # Check for file containing name of virtualenv
        if [ -f ".python-env" -a $VENV_WRAPPER = "true" ]; then
          _VENV_PATH=$WORKON_HOME/$(cat .python-env)
          _VENV_WRAPPER_ACTIVATE=true
        else
          return
        fi

        # Check to see if already activated to avoid redundant activating
        if [ "$VIRTUAL_ENV" != $_VENV_PATH ]; then
            if $_VENV_WRAPPER_ACTIVATE; then
              _VENV_NAME=$(basename $_VENV_PATH)
              workon $_VENV_NAME
            fi
            # echo Activated virtualenv \"$_VENV_NAME\".
        fi
    fi
}

export PROMPT_COMMAND=_virtualenv_auto_activate
if [ -n "$ZSH_VERSION" ]; then
  function chpwd() {
    _virtualenv_auto_activate
  }
fi
