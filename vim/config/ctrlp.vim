"===============================================================================
" File: ctrlp.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for ctrl-p
"===============================================================================

let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll|png|jpg|psd|o|pyc|sqlite|7z|zip|tar|com|swo|gz|dmg)$'
}
