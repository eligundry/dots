################################################################################
# => History Substring Search
################################################################################

# bind UP and DOWN arrow keys
for keycode in '[' '0'; do
	bindkey "^[${keycode}A" history-substring-search-up
	bindkey "^[${keycode}B" history-substring-search-down
done
unset keycode

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
