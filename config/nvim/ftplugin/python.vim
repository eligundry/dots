"===============================================================================
" File: python.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Python specific vim settings
"===============================================================================

"===============================================================================
" => Tabs
"===============================================================================

setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4

"===============================================================================
" => Formatting
"===============================================================================

setlocal textwidth=79

"===============================================================================
" => Omnifunctions
"===============================================================================

setlocal omnifunc=pythoncomplete#Complete

"===============================================================================
" => Virtualenv
"===============================================================================

if has('python')
py << EOF
import os.path
import sys
import neovim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif
