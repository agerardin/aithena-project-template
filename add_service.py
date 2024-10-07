import os
import json
import shutil
import subprocess
import sys
import utils

# Check if the configuration file is provided as a command-line argument
if len(sys.argv) < 2 or len(sys.argv) > 2:
    print("Usage: python build_script_final.py <config.json>")
    sys.exit(1)

config_file = sys.argv[1]

# Load configuration from JSON file
with open(config_file, "r") as f:
    config = json.load(f)

project_name = config.get("project_name", "my-python-project")
packages = config.get("packages", ["src"])

for package in packages:
    package_path = package.replace("-", "_").replace(".", "/")
    package_parts = package_path.split("/")
    last_package = package_parts[-1]
    # Create the api subpackage
    api_package = f"{project_name}/src/{package_path}/api"
    os.makedirs(api_package, exist_ok=True)
    # Create the __init__.py file for the api package
    api_init_path = os.path.join(api_package, "__init__.py")

# Define the FastAPI endpoint
api_content = """\
from fastapi import FastAPI
from ..__main__ import main

app = FastAPI()

@app.get("/")
def hello_world():
    return {"message": main()}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
"""

# Write the FastAPI endpoint to api/main.py
with open(api_init_path, "w") as f:
    f.write(api_content)

for package in packages:
    utils.update_toml_script(project_name, f"{project_name}-api",  f"bash -c 'uvicorn {package}.api:app --host 0.0.0.0 --port 8000'")

subprocess.run(["poetry", "add", "fastapi"], cwd=project_name)
subprocess.run(["poetry", "add", "uvicorn"], cwd=project_name)
subprocess.run(["poetry", "install"], cwd=project_name)


print(f"Created FastAPI endpoint in {api_init_path}")

