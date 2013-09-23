set fish_git_dirty_color purple
set fish_git_not_dirty_color green
set fish_git_normal_color cyan

function parse_git_branch
  set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
  set -l git_diff (git diff)

  if test -n "$git_diff"
    echo (set_color $fish_git_dirty_color)$branch(set_color $fish_git_normal_color)
  else
    echo (set_color $fish_git_not_dirty_color)$branch(set_color $fish_git_normal_color)
  end
end

function fish_right_prompt
  set_color blue
  echo (prompt_pwd)

  set_color $fish_git_normal_color

  if test -d .git
    echo " git:("(parse_git_branch)")"
  end
  set_color normal

end
