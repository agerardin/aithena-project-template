import os
import toml

def update_toml_script(project_name, script_name, script_entry):
    # Define the directory and file paths
    pyproject_file_path = os.path.join(project_name, "pyproject.toml")

    # Read and parse the pyproject.toml file
    with open(pyproject_file_path, "r") as pyproject_file:
        pyproject_data = toml.load(pyproject_file)

    # Ensure the [tool.poetry.scripts] section exists
    if "tool" not in pyproject_data:
        pyproject_data["tool"] = {}
    if "poetry" not in pyproject_data["tool"]:
        pyproject_data["tool"]["poetry"] = {}
    if "scripts" not in pyproject_data["tool"]["poetry"]:
        pyproject_data["tool"]["poetry"]["scripts"] = {}

    pyproject_data["tool"]["poetry"]["scripts"][script_name] = script_entry

    # Write the updated content back to the pyproject.toml file
    with open(pyproject_file_path, "w") as pyproject_file:
        toml.dump(pyproject_data, pyproject_file)

    print(f"Updated {pyproject_file_path} to include the script entry point {script_name} with script {script_entry}.")