CONFIG_FILE=$1

echo "Running build script with configuration file: $CONFIG_FILE"

# Run the build script
python build_script_final.py "$CONFIG_FILE"
echo "Build script completed"

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
    cd "$PROJECT_NAME" || exit
    echo "Changed directory to $PROJECT_NAME"
else
    echo "Directory $PROJECT_NAME does not exist"
    exit 1
fi

# Activate the virtual environment
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
    echo "Activated virtual environment"
else
    echo "Virtual environment activation script not found"
    exit 1
fi

# Run poetry install
if command -v poetry &> /dev/null; then
    poetry install
    echo "Ran poetry install"
else
    echo "Poetry is not installed. Please install poetry and try again."
    exit 1
fi