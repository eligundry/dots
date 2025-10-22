# Sync shell history to the cloud with atuin
# Filter out deprecated -k syntax for Fish 4.0 compatibility
atuin init fish | string replace -ra -- ' -k (\w+)' ' $1' | source
