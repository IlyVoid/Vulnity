#!/bin/zsh

# Function to display a spinner
spinner() {
    local pid=$!
    local spin=('|' '/' '-' '\\')
    while kill -0 $pid 2>/dev/null; do
        for s in "${spin[@]}"; do
            printf "\r[%s] %s" "$s" "$1"
            sleep 0.1
        done
    done
    printf "\r\033[K" # Clear spinner line
}

# Function to display a progress bar
progress_bar() {
    local duration=$1
    for ((i=0; i<=100; i+=2)); do
        printf "\r\033[1;34m[%-50s]\033[1;33m %d%%\033[0m" "$(printf '#%.0s' $(seq 1 $((i / 2))))" "$i"
        sleep $((duration / 50))
    done
    echo
}

clear
echo "\033[1;35m✨ Welcome to the Vulnity Setup ✨\033[0m"

# Step 1: Create a virtual environment
echo "\033[1;34m🔧 Creating Python virtual environment...\033[0m"
python3 -m venv vuln & spinner "Creating virtual environment"
if [[ $? -eq 0 ]]; then
    echo "\033[1;32m✅ Virtual environment created successfully.\033[0m"
else
    echo "\033[1;31m❌ Error: Failed to create a virtual environment.\033[0m" >&2
    exit 1
fi

# Step 2: Activate the virtual environment
echo "\033[1;34m🔗 Activating the virtual environment...\033[0m"
source vuln/bin/activate
if [[ $? -eq 0 ]]; then
    echo "\033[1;32m✅ Virtual environment activated successfully.\033[0m"
else
    echo "\033[1;31m❌ Error: Failed to activate the virtual environment.\033[0m"
    exit 1
fi

# Step 3: Ensure pip is up to date
echo "\033[1;34m⏳ Upgrading pip...\033[0m"
pip install --upgrade pip --quiet & spinner "Upgrading pip"
if [[ $? -eq 0 ]]; then
    echo "\033[1;32m✅ Pip upgraded successfully.\033[0m"
else
    echo "\033[1;31m❌ Error: Failed to upgrade pip.\033[0m"
    deactivate
    exit 1
fi

# Step 4: Display a progress bar during installation
echo "\033[1;34m📦 Installing dependencies...\033[0m"
progress_bar 5

# Step 5: Install required packages
pip install requests pyfiglet colorama rich --quiet & spinner "Installing dependencies"
if [[ $? -eq 0 ]]; then
    echo "\033[1;32m✅ Dependencies installed successfully.\033[0m"
else
    echo "\033[1;31m❌ Error: Failed to install dependencies.\033[0m"
    deactivate
    exit 1
fi

# Step 6: Add run script with virtual environment activation
echo "\033[1;34m📝 Adding run script...\033[0m"
cat << 'EOF' > run.sh
#!/bin/zsh

# Activate the virtual environment
source vuln/bin/activate

# Check if the virtual environment was activated
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "Virtual environment activated."
else
    echo "Failed to activate virtual environment. Exiting..."
    exit 1
fi

# Run the main script
python3 main.py
EOF

chmod +x run.sh
echo "\033[1;32m✅ Run script added: Do ./run.sh\033[0m"

# Wrap up
echo "\033[1;35m🎉 Setup completed successfully! Enjoy using Vulnity!\033[0m"
