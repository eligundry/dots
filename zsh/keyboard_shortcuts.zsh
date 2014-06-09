################################################################################
# => History Substring Search
################################################################################

# bind UP and DOWN arrow keys
for keycode in '[' '0'; do
	bindkey "^[${keycode}A" history-substring-search-up
	bindkey "^[${keycode}B" history-substring-search-down
done
unset keycode
