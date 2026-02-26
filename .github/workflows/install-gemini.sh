#!/bin/bash
set -e

echo "Installing Gemini CLI..."

# Upgrade pip
python3 -m pip install --upgrade pip

# Install gemini CLI for user
python3 -m pip install --user gemini-cli

# Add pip user bin to PATH for this run
export PATH="$HOME/.local/bin:$PATH"

# Persist PATH for subsequent GitHub Actions steps
echo "$HOME/.local/bin" >> $GITHUB_PATH

# Verify installation
gemini --version