#!/bin/bash

# Exit on error
set -e

# Function to clean up and exit
cleanup() {
    echo "Terminating JupyterLab and exiting..."
    # Find and kill all running JupyterLab processes
    pkill -f "jupyter-lab" 2>/dev/null || true
    # Deactivate conda environment
    conda deactivate 2>/dev/null || true
    exit 0
}

# Trap Ctrl+C (SIGINT) and call cleanup
trap cleanup SIGINT

# Activate conda environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate py-env

# Start JupyterLab without opening a browser
jupyter lab --no-browser &

# Store the JupyterLab process ID
JUPYTER_PID=$!

# Wait a moment to ensure JupyterLab starts
sleep 5

# Get the JupyterLab URL from the output
JUPYTER_URL=$(jupyter lab list | grep -o 'http://localhost:8888/lab?token=[^ ]*' | head -1)

# Open Brave Browser in incognito mode with the JupyterLab URL
brave-browser --incognito "$JUPYTER_URL" &

# Keep the script running to prevent JupyterLab from closing
wait $JUPYTER_PID
