#!/bin/zsh

# Function to print colored messages
print_colored() {
    local color=$1
    local message=$2
    case $color in
        "green") echo "\033[1;32m$message\033[0m" ;; # Success
        "red") echo "\033[1;31m$message\033[0m" ;;   # Error
        "yellow") echo "\033[1;33m$message\033[0m" ;; # Warning
        "blue") echo "\033[1;34m$message\033[0m" ;;   # Info
        *) echo "$message" ;;
    esac
}

clear
echo "\033[1;35m$ascii_art\033[0m"
print_colored "yellow" "⚠️  This will delete all generated files and folders. Proceed with caution."

# Confirm uninstallation
print_colored "yellow" "Do you really want to uninstall? (y/n)"
read -r confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    print_colored "red" "❌ Uninstallation aborted."
    exit 0
fi

# Deleting the virtual environment
if rm -rf vuln; then
    print_colored "green" "✅ Virtual environment deleted."
else
    print_colored "red" "❌ Failed to delete the virtual environment."
fi

# Deleting extra folders
if rm -rf cache reports logs; then
    print_colored "green" "✅ Extra folders deleted."
else
    print_colored "red" "❌ Failed to delete extra folders."
fi

# Deleting the run script
if rm -f run.sh; then
    print_colored "green" "✅ Run script deleted."
else
    print_colored "red" "❌ Failed to delete the run script."
fi

# Final cleanup message
print_colored "blue" "✨ Uninstallation complete. All files have been removed!"
