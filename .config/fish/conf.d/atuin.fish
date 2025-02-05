set -gx ATUIN_NOBIND "true"
atuin init fish | source

# Bind ctrl-r to atuin search
bind \cr _atuin_search

# Bind up arrow to search through history with current input
# bind -k up '_atuin_search_widget --shell-up-key-binding'

# Bind down arrow to search through history with current input
# bind -k down '_atuin_search_widget --shell-down-key-binding'
