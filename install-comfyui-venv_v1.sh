# Clone and setup ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI
git checkout v0.3.75

# Setup Custom Nodes
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
cd comfyui-manager
# Ensure the commit hash is valid before checking out
git checkout 3f030a2121d1ad42fcabac67946f2a67afe4cc31
cd ../..

# Setup Virtual Environment
python3 -m venv venv
source venv/bin/activate

# Install Dependencies
# Note: Ensure cu121 matches your NVIDIA driver version
python3 -m pip install --upgrade pip
python3 -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121
python3 -m pip install -r requirements.txt
python3 -m pip install -r custom_nodes/comfyui-manager/requirements.txt

# Create Launchers in the parent directory
cd ..
echo "#!/bin/bash
cd ComfyUI
source venv/bin/activate
python3 main.py --preview-method auto" > run_gpu.sh

echo "#!/bin/bash
cd ComfyUI
source venv/bin/activate
python3 main.py --preview-method auto --cpu" > run_cpu.sh

chmod +x run_gpu.sh run_cpu.sh
echo "Setup complete. Use ./run_gpu.sh to start."
