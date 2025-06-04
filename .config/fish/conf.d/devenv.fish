function tail-devenv-log
    set -l processes (devenv info | awk '/^# processes:?$/{flag=1; next} /^#/{flag=0} flag' | cut -d':' -f1 | string trim | sed 's/^- //')

    if test "$argv[1]" = "--help"
        echo "tail-devenv-log: Stream logs for a specific devenv process"
        echo ""
        echo "Usage: tail-devenv-log <process-name>"
        echo ""
        echo "You will need to launch devenv with `devenv up --detach`"
        echo ""
        echo "Available processes:"
        printf '%s\n' $processes
        echo ""
        echo "Examples:"
        echo "  tail-devenv-log analytics"
        echo "  tail-devenv-log mysql"
        return 0
    end

    if not contains -- "$argv[1]" $processes
        echo "Available processes:"
        printf '%s\n' $processes
        return 1
    end

    tail -f .devenv/processes.log | rg --line-buffered "\[$argv[1]" | sed -E 's/^\['$argv[1]'[[:space:]]*\] //'
end

function __tail_devenv_log_completions
    devenv info | awk '/^# processes:?$/{flag=1; next} /^#/{flag=0} flag' | cut -d':' -f1 | string trim | sed 's/^- //'
end

function __fish_help_tail-devenv-log
    echo "tail-devenv-log: Stream logs for a specific devenv process"
    echo ""
    echo "Usage: tail-devenv-log <process-name>"
    echo ""
    echo "Available processes:"
    devenv info | awk '/^# processes:?$/{flag=1; next} /^#/{flag=0} flag' | cut -d':' -f1 | string trim | sed 's/^- //'
    echo ""
    echo "Examples:"
    echo "  tail-devenv-log analytics"
    echo "  tail-devenv-log mysql"
end

complete -c tail-devenv-log -d "Stream logs for a specific devenv process"
complete -c tail-devenv-log -f -a "(__tail_devenv_log_completions)"
complete -c tail-devenv-log -s h -l help -d "Show help"
