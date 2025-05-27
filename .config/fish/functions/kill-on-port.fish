function kill-on-port --description "Kill process listening on specified port"
    set -l port $argv[1]

    if test -z "$port"
        echo "Error: Port number is required"
        echo "Usage: kill-on-port PORT_NUMBER"
        return 1
    end

    # Check if port is a number
    if not string match -qr '^[0-9]+$' $port
        echo "Error: Port must be a number"
        return 1
    end

    set -l os (uname)
    set -l pid

    if test "$os" = "Darwin" # macOS
        set pid (lsof -i :$port -t 2>/dev/null)
    else if test "$os" = "Linux" # Linux
        set pid (ss -lptn "sport = :$port" 2>/dev/null | grep -oP '(?<=pid=)[0-9]+' | head -n1)

        # If ss command doesn't work, try with netstat as fallback
        if test -z "$pid"
            set pid (netstat -tlpn 2>/dev/null | grep ":$port " | grep -oP '(?<=\/)[0-9]+(?=\/)' | head -n1)
        end
    else
        echo "Unsupported operating system: $os"
        return 1
    end

    if test -z "$pid"
        echo "No process found listening on port $port"
        return 1
    end

    # Get process info before killing
    set -l process_info
    if test "$os" = "Darwin"
        set process_info (ps -p $pid -o comm= 2>/dev/null)
    else
        set process_info (ps -p $pid -o comm= 2>/dev/null)
    end

    # Kill the process
    kill -9 $pid

    if test $status -eq 0
        echo "Successfully killed process $pid ($process_info) listening on port $port"
    else
        echo "Failed to kill process $pid on port $port"
        return 1
    end
end

