function aws:sso:login
    set -l profile $argv[1]
    set -l config_file "$HOME/.aws/config"

    if test -z "$profile"
        echo "Profile name is required as an argument."
        return 1
    end

    # Check if the profile exists in ~/.aws/config
    if grep -q "\[profile $profile\]" "$config_file"
        # Extract the profile block and check for 'sso_start_url' within that block
        if awk "/\[profile $profile\]/,/^\$/" "$config_file" | grep -q "sso_start_url"
            echo "Logging in with AWS SSO for profile: $profile"
            aws sso login --profile "$profile"
            and eval (aws configure export-credentials --profile "$profile" --format env)
        else
            echo "Profile '$profile' does not have SSO configured."
            return 1
        end
    else
        echo "Profile '$profile' not found in ~/.aws/config."
        return 1
    end
end

# Tab completion for aws:sso:login function
function __aws_sso_login_complete
    set -l config_file "$HOME/.aws/config"

    # Check if config file exists
    if test -f "$config_file"
        # Extract profile names from config file
        grep -E '^\[profile (.+)\]' "$config_file" | sed -E 's/^\[profile (.+)\]/\1/' | sort
    end
end

# Register completion for aws:sso:login
complete -f -c aws:sso:login -a "(__aws_sso_login_complete)"

export OPENROUTER_API_KEY="$(pass CodeClimate/openrouter.ai/api-key)"
export TEST_ENV="true"
