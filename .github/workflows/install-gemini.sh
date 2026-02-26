#!/bin/bash
set -e

echo "Installing Gemini CLI..."
python3 -m pip install --upgrade pip
python3 -m pip install --user gemini-cli

# Add pip user bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Verify installation
gemini --version