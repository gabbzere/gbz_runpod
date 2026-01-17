#!/bin/bash

# Change to the /workspace directory to ensure all files are downloaded correctly.
cd /workspace

# 1. Install ComfyUI
echo "Installing ComfyUI and ComfyUI Manager..."
wget https://github.com/gabbzere/gbz_runpod/raw/main/install-comfyui-venv_v1.sh -O install-comfyui-venv-linux.sh
chmod +x install-comfyui-venv-linux.sh
./install-comfyui-venv-linux.sh


# Configure network access (--listen)

echo "Configuring ComfyUI for network access..."
grep -q -- "--listen" /workspace/run_gpu.sh || sed -i '$ s/$/ --listen/' /workspace/run_gpu.sh
chmod +x /workspace/run_gpu.sh

# Clean up scripts.
echo "Cleaning up."
rm install_script.sh run_cpu.sh install-comfyui-venv-linux.sh


# Start the main Runpod service and the ComfyUI service in the background.
echo "Starting ComfyUI and Runpod services..."
(/start.sh & /workspace/run_gpu.sh)
