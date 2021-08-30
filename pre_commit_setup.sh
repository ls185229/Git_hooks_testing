#!/usr/bin/env bash

# This file will be used to set-up local pre-commit hooks
# A developer is required to run this script just after immediately cloning the repository


pip install pre-commit
echo "pre-commit package installed"
pre-commit --version
pre-commit install
# pre-commit autoupdate 
# if you execute the above command, .pre-commit-config.ymal file will be modified
# since that file is being tracked remotely, it is not recommended to run often
pre-commit install --install-hooks

echo "Local pre-commit set up is completed"
