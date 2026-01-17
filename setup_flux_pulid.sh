#!/bin/bash

# --- CONFIGURATION ---
# Paste your Hugging Face Token (Read access) here:
HF_TOKEN="${HF_TOKEN:-your_default_token_here}"

COMFYUI_DIR="/workspace/ComfyUI"
VENV_PATH="$COMFYUI_DIR/venv/bin/activate"

# Model Paths
DIFF_DIR="$COMFYUI_DIR/models/diffusion_models"
VAE_DIR="$COMFYUI_DIR/models/vae"
CLIP_DIR="$COMFYUI_DIR/models/text_encoders"
PULID_DIR="$COMFYUI_DIR/models/pulid"
INSIGHT_DIR="$COMFYUI_DIR/models/insightface/models/antelopev2"

echo "🚀 Starting Step 2: Flux & PuLID (Authenticated)"

# 1. Install Aria2
if ! command -v aria2c &> /dev/null; then
    apt-get update && apt-get install -y aria2 unzip
fi

# 2. Setup Dependencies in Venv
if [ -f "$VENV_PATH" ]; then
    source "$VENV_PATH"
    pip install insightface==0.7.3 onnxruntime-gpu timm facexlib
else
    echo "❌ ERROR: Venv not found. Run Step 1 first!"
    exit 1
fi

# 3. Authenticated Download Function
download_auth() {
    local url=$1
    local path=$2
    local filename=$(basename "$path")
    local dir=$(dirname "$path")

    if [ ! -f "$path" ]; then
        echo "📥 Downloading $filename (Authenticated)..."
        mkdir -p "$dir"
        aria2c -x 16 -s 16 -k 1M --continue=true \
            --header="Authorization: Bearer $HF_TOKEN" \
            -d "$dir" -o "$filename" "$url"
    else
        echo "✅ $filename already exists, skipping."
    fi
}

# 4. DOWNLOAD MODELS
echo "Checking models on persistent storage..."

# Flux  
download_auth "https://huggingface.co/lllyasviel/flux1_dev/resolve/main/flux1-dev-fp8.safetensors" "$DIFF_DIR/flux1-dev-fp8.safetensors"

#  VAE 
download_auth "https://huggingface.co/realung/flux1-dev.safetensors/resolve/main/ae.safetensors" "$VAE_DIR/ae.safetensors"

#  Encoders
download_auth "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" "$CLIP_DIR/clip_l.safetensors"
download_auth "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn_scaled.safetensors" "$CLIP_DIR/t5xxl_fp8_e4m3fn_scaled.safetensors"

# PuLID
download_auth "https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors" "$PULID_DIR/pulid_flux_v0.9.1.safetensors"

# 5. ANTELOPE V2
if [ ! -d "$INSIGHT_DIR" ]; then
    echo "📥 Downloading AntelopeV2..."
    mkdir -p "$INSIGHT_DIR"
    cd "$INSIGHT_DIR"
    wget -q --show-progress https://github.com/deepinsight/insightface/releases/download/v0.7/antelopev2.zip
    unzip -j antelopev2.zip && rm antelopev2.zip
else
    echo "✅ AntelopeV2 already exist."
fi

echo "🎉 All Done! Everything is saved to your persistent network volume."
