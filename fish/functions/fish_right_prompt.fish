set fish_git_dirty_color purple
set fish_git_not_dirty_color green
set fish_title_color cyan

function parse_git_branch
  set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
  set -l git_diff (git diff)

  if test -n "$git_diff"
    echo (set_color $fish_git_dirty_color)$branch(set_color $fish_title_color)
  else
    echo (set_color $fish_git_not_dirty_color)$branch(set_color $fish_title_color)
  end
end

function fish_right_prompt
  set_color blue
  echo (prompt_pwd)

  if set -q VIRTUAL_ENV
      echo -n -s (set_color $fish_title_color) " venv(" (set_color purple) (basename "$VIRTUAL_ENV") (set_color $fish_title_color) ")"
  end

  if test -d .git
    set_color $fish_title_color
    echo " git:("(parse_git_branch)")"
    set_color normal
  end

end