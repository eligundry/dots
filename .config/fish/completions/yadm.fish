# Custom yadm completions - complete replacement to avoid slow $HOME scanning
# The vendor completions wrap git which scans $HOME for untracked files

# Erase any existing yadm completions first
complete -e -c yadm

function __yadm_needs_command
    set -l cmd (commandline -opc)
    set -e cmd[1]
    # Skip yadm global options
    while set -q cmd[1]
        switch $cmd[1]
            case '-Y' '--yadm-*'
                set -e cmd[1]
                set -e cmd[1]  # also remove the argument
            case '-*'
                set -e cmd[1]
            case '*'
                break
        end
    end
    test (count $cmd) -eq 0
end

function __yadm_using_command
    set -l cmd (commandline -opc)
    set -e cmd[1]
    while set -q cmd[1]
        switch $cmd[1]
            case '-*'
                set -e cmd[1]
            case '*'
                break
        end
    end
    test (count $cmd) -gt 0; and test "$cmd[1]" = "$argv[1]"
end

function __yadm_tracked_files
    yadm ls-files 2>/dev/null
end

function __yadm_modified_files
    yadm diff --name-only 2>/dev/null
    yadm diff --name-only --cached 2>/dev/null
end

function __yadm_branches
    yadm branch -a --format='%(refname:short)' 2>/dev/null
end

# Yadm-specific commands
complete -f -c yadm -n __yadm_needs_command -a clone -d 'Clone an existing yadm repository'
complete -f -c yadm -n __yadm_needs_command -a init -d 'Initialize a new yadm repository'
complete -f -c yadm -n __yadm_needs_command -a list -d 'List tracked files'
complete -f -c yadm -n __yadm_needs_command -a alt -d 'Create links for alternates'
complete -f -c yadm -n __yadm_needs_command -a bootstrap -d 'Run bootstrap script'
complete -f -c yadm -n __yadm_needs_command -a encrypt -d 'Encrypt files'
complete -f -c yadm -n __yadm_needs_command -a decrypt -d 'Decrypt files'
complete -f -c yadm -n __yadm_needs_command -a perms -d 'Fix permissions'
complete -f -c yadm -n __yadm_needs_command -a enter -d 'Enter yadm subshell'
complete -f -c yadm -n __yadm_needs_command -a git-crypt -d 'Run git-crypt'
complete -f -c yadm -n __yadm_needs_command -a config -d 'Configure yadm'
complete -f -c yadm -n __yadm_needs_command -a gitconfig -d 'Configure git for yadm'
complete -f -c yadm -n __yadm_needs_command -a upgrade -d 'Upgrade yadm repository'
complete -f -c yadm -n __yadm_needs_command -a introspect -d 'Report yadm data'
complete -f -c yadm -n __yadm_needs_command -a version -d 'Show version'
complete -f -c yadm -n __yadm_needs_command -a help -d 'Show help'

# Common git commands
complete -f -c yadm -n __yadm_needs_command -a add -d 'Add file contents to the index'
complete -f -c yadm -n __yadm_needs_command -a commit -d 'Record changes to the repository'
complete -f -c yadm -n __yadm_needs_command -a push -d 'Push to remote'
complete -f -c yadm -n __yadm_needs_command -a pull -d 'Pull from remote'
complete -f -c yadm -n __yadm_needs_command -a fetch -d 'Fetch from remote'
complete -f -c yadm -n __yadm_needs_command -a status -d 'Show working tree status'
complete -f -c yadm -n __yadm_needs_command -a diff -d 'Show changes'
complete -f -c yadm -n __yadm_needs_command -a log -d 'Show commit logs'
complete -f -c yadm -n __yadm_needs_command -a checkout -d 'Switch branches or restore files'
complete -f -c yadm -n __yadm_needs_command -a branch -d 'List or create branches'
complete -f -c yadm -n __yadm_needs_command -a merge -d 'Merge branches'
complete -f -c yadm -n __yadm_needs_command -a rebase -d 'Rebase commits'
complete -f -c yadm -n __yadm_needs_command -a reset -d 'Reset HEAD'
complete -f -c yadm -n __yadm_needs_command -a restore -d 'Restore files'
complete -f -c yadm -n __yadm_needs_command -a stash -d 'Stash changes'
complete -f -c yadm -n __yadm_needs_command -a rm -d 'Remove files'
complete -f -c yadm -n __yadm_needs_command -a mv -d 'Move/rename files'
complete -f -c yadm -n __yadm_needs_command -a remote -d 'Manage remotes'
complete -f -c yadm -n __yadm_needs_command -a show -d 'Show objects'

# File completions for specific commands
# No -f flag allows normal file/dir completion alongside tracked files
complete -c yadm -n '__yadm_using_command add' -a '(__yadm_tracked_files)'
complete -f -c yadm -n '__yadm_using_command checkout' -a '(__yadm_modified_files)'
complete -f -c yadm -n '__yadm_using_command diff' -a '(__yadm_tracked_files)'
complete -f -c yadm -n '__yadm_using_command restore' -a '(__yadm_modified_files)'
complete -f -c yadm -n '__yadm_using_command reset' -a '(__yadm_tracked_files)'
complete -f -c yadm -n '__yadm_using_command rm' -a '(__yadm_tracked_files)'
complete -f -c yadm -n '__yadm_using_command mv' -a '(__yadm_tracked_files)'
complete -f -c yadm -n '__yadm_using_command show' -a '(__yadm_tracked_files)'

# Branch completions
complete -f -c yadm -n '__yadm_using_command checkout' -a '(__yadm_branches)'
complete -f -c yadm -n '__yadm_using_command merge' -a '(__yadm_branches)'
complete -f -c yadm -n '__yadm_using_command rebase' -a '(__yadm_branches)'
complete -f -c yadm -n '__yadm_using_command branch' -a '(__yadm_branches)'

# Commit options
complete -f -c yadm -n '__yadm_using_command commit' -s m -l message -d 'Commit message'
complete -f -c yadm -n '__yadm_using_command commit' -s a -l all -d 'Stage all modified files'
complete -f -c yadm -n '__yadm_using_command commit' -l amend -d 'Amend previous commit'
complete -f -c yadm -n '__yadm_using_command commit' -s v -l verbose -d 'Show diff in editor'

# Add options
complete -f -c yadm -n '__yadm_using_command add' -s p -l patch -d 'Interactive staging'
complete -f -c yadm -n '__yadm_using_command add' -s u -l update -d 'Update tracked files'

# Global yadm options
complete -f -c yadm -s Y -l yadm-dir -d 'Override yadm directory'
complete -f -c yadm -l yadm-repo -d 'Override yadm repository'
complete -f -c yadm -l yadm-config -d 'Override yadm config'
complete -f -c yadm -l yadm-encrypt -d 'Override encrypt config'
complete -f -c yadm -l yadm-archive -d 'Override archive location'
complete -f -c yadm -l yadm-bootstrap -d 'Override bootstrap script'
