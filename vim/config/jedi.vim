"===============================================================================
" File: jedi.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for jedi
"===============================================================================

if has('python')
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
