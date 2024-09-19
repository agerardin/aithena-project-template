# Function to terminate the script without killing the shell
terminate_script() {
    echo "$1"
    return 1
}

# Check if the configuration file is provided as a command-line argument
if [ "$#" -ne 1 ]; then
    terminate_script "Usage: $0 <config.json>"
fi

CONFIG_FILE=$1

# Run the build script
python build_script.py "$CONFIG_FILE"

# Check if jq is available
if command -v jq &> /dev/null; then
    echo "jq is available, using jq to extract project name"
    # Extract the project name from the config file using jq
    PROJECT_NAME=$(jq -r '.project_name' "$CONFIG_FILE")
else
    echo "jq is not available, using Python to extract project name"
    # Extract the project name from the config file using Python
    PROJECT_NAME=$(python -c "import json; import sys; print(json.load(open(sys.argv[1]))['project_name'])" "$CONFIG_FILE")
fi

echo "Extracted project name: $PROJECT_NAME"

# Change into the newly created project directory
if [ -d "$PROJECT_NAME" ]; then
    cd "$PROJECT_NAME" || terminate_script "Failed to change directory to $PROJECT_NAME"
    echo "Changed directory to $PROJECT_NAME"
else
    terminate_script "Directory $PROJECT_NAME does not exist"
fi

# Activate the virtual environment
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
    echo "Activated virtual environment"
else
    terminate_script "Virtual environment activation script not found"
fi

# Run poetry install
if command -v poetry &> /dev/null; then
    poetry install
    echo "Ran poetry install"
else
    terminate_script "Poetry is not installed. Please install poetry and try again."
fi