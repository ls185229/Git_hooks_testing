#!/usr/bin/env bash

# This file will be used to set-up local pre-commit hooks
# A developer is required to run this script just after immediately cloning the repository


pip install pre-commit
echo "pre-commit package installed"
pre-commit --version
pre-commit install
pre-commit autoupdate
pre-commit install --install-hooks

echo "Local pre-commit set up is completed"

