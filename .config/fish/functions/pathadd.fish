function pathadd --description "Add a directory to PATH if it exists and isn't already included"
    # Check if argument is provided and is a directory
    if test -d "$argv[1]"
        # Convert PATH to a list of directories
        set -l parts (string split : $PATH)

        # Check if the directory is already in PATH
        if not contains "$argv[1]" $parts
            # Add the new path to the end
            set -gx PATH $PATH "$argv[1]"
        end
    end
end

