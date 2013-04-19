# PROMPT='%{$fg[yellow]%} ➜ %{$reset_color%}'
PROMPT='%{$fg[yellow]%}>> %{$reset_color%}'
RPROMPT='%{$fg[yellow]%}%0~%  %{$reset_color%}%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[magenta]%})"
