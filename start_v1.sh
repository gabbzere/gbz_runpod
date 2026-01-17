#!/bin/bash

# Change to the /workspace directory to ensure all files are downloaded correctly.
cd /workspace

# 1. Install ComfyUI
echo "Installing ComfyUI and ComfyUI Manager..."
wget https://github.com/ltdrdata/ComfyUI-Manager/raw/main/scripts/install-comfyui-venv-linux.sh -O install-comfyui-venv-linux.sh
chmod +x install-comfyui-venv-linux.sh
./install-comfyui-venv-linux.sh

# -----------------------------
# PIN ComfyUI + Manager versions
# -----------------------------
echo "Pinning ComfyUI to v0.3.65..."
cd /workspace/ComfyUI
git fetch --tags
git checkout v0.3.65

echo "Pinning ComfyUI-Manager to v3.37..."
cd /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
git fetch --tags
git checkout v3.37

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
