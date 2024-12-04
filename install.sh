#!/bin/zsh

# Function to display a progress bar
progress_bar() {
    local duration=$1
    for ((i=0; i<=100; i+=2)); do
        printf "\r[%-50s] %d%%" "$(printf '#%.0s' $(seq 1 $((i / 2))))" "$i"
        sleep $((duration / 50))
    done
    echo
}

echo "Setting up Python virtual environment..."

# Step 1: Create a virtual environment
if python3 -m venv vuln; then
    echo "✅ Virtual environment created successfully."
else
    echo "❌ Error: Failed to create a virtual environment." >&2
    exit 1
fi

# Step 2: Activate the virtual environment
source vuln/bin/activate
echo "✅ Virtual environment activated successfully."

# Step 3: Ensure pip is up to date
echo "⏳ Upgrading pip..."
if pip install --upgrade pip --quiet; then
    echo "✅ Pip upgraded successfully."
else
    echo "❌ Error: Failed to upgrade pip." >&2
    deactivate
    exit 1
fi

# Step 4: Display a progress bar during installation
echo "Installing dependencies..."
progress_bar 5

# Step 5: Install required packages
if pip install requests pyfiglet colorama rich --quiet; then
    echo "✅ Dependencies installed successfully."
else
    echo "❌ Error: Failed to install dependencies." >&2
    deactivate
    exit 1
fi

echo "🎉 Setup completed successfully!"
