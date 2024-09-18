# Aithena Common Template (v0.1.0)

## Configure

Rename `config.json.template` as `config.json`

Modify the fields in `config.json`

## Use

Two options:

- Only create the project:
`python build_script.py config.json`

- Create the project, cd into it and activate the environment:
`source setup_project.sh config.json`

## Test

type `${PROJECT_NAME}` and you should be greeted with "Hello, World!"