#!/bin/bash
set -e

echo "Installing Gemini CLI..."
pip install --upgrade pip
pip install gemini-cli
echo "Gemini installed: $(gemini --version)"