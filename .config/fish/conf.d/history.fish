# Sync shell history to the cloud with atuin
# NOTE: don't rewrite `-k`/named-key syntax here — atuin already emits the right
# form per fish version. On fish 3, `bind -k up` -> `bind up` binds the literal
# sequence "up", which makes pressing `u` trigger the history search.
atuin init fish | source
