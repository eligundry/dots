if status is-interactive
  # Starship for prompt
  starship init fish | source

  # Gotta have vi mode
  fish_vi_key_bindings

  # Add Homebrew vendor completions directory to the completions path
  if test -d /opt/homebrew/share/fish/vendor_completions.d
    set -p fish_complete_path /opt/homebrew/share/fish/vendor_completions.d
  end

  # Fun lil greeting when starting up the shell
  function fish_greeting
    # Get terminal height
    set -l term_height $LINES

    if test -z "$term_height"
      # Fallback if $LINES is not set
      set term_height (tput lines)
    end

    # Calculate max fortune length based on terminal height
    # Cowsay adds about 4 lines of overhead (cow drawing)
    # Leave 4 lines for prompt and command space
    set -l max_lines (math "$term_height - 8")

    if test $max_lines -lt 5
      # Terminal too small, skip greeting
      return
    else if test $max_lines -lt 10
      # Small terminal, use short fortunes
      fortune -s | cowsay
    else
      # Normal terminal, use regular fortune
      fortune | cowsay
    end
  end

  # Set terminal title
  function fish_title
    set -l cmd (status current-command 2>/dev/null; or echo "fish")
    set -l dir (prompt_pwd)

    if test "$cmd" = "fish"
      echo $dir
    else
      echo "$dir: $cmd"
    end
  end
end

