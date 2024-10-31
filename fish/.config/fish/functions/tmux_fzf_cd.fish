function tmux_fzf_cd
  # Get the current working directory of the focused pane
  set pane_pwd (tmux display -p -F "#{pane_current_path}")

  # Check if there are any directories in the current path
  if test (count (find $pane_pwd -maxdepth 1 -type d -not -path $pane_pwd)) -eq 0
    echo "No directories found in $pane_pwd"
    return
  end

  # Run tmux popup with fzf and capture selection directly
  set selected_dir (tmux popup -E -h 50% -w 50% "find $pane_pwd -maxdepth 1 -type d -not -path $pane_pwd | fzf --prompt='Select directory: '")

  # Check if a selection was made
  if test -n "$selected_dir"
    # Send the cd command to the tmux pane with the selected directory
    tmux send-keys "cd $selected_dir" C-m
  end
end

