# Hush AI Model for Doce Lar

## Installation

### 1. Install System Dependencies
```bash
sudo apt-get update
sudo apt-get install -y ffmpeg python3-pip python3-venv
```

### 2. Install Python Packages
```bash
# Option A: Using pip (recommended)
pip install --user torch torchaudio numpy soundfile scipy DeepFilterLib

# Option B: Using apt
sudo apt-get install python3-torch python3-torchaudio python3-pip
```

### 3. Download Model
The model is already downloaded to `deployment/models/model_best.ckpt`

If you need to download again:
```bash
curl -L -o deployment/models/model_best.ckpt "https://huggingface.co/weya-ai/hush/resolve/main/model_best.ckpt"
```

## Usage

The model is automatically used by `AudioEnhancementService` when:
1. A video is uploaded with "Melhorar áudio" checked
2. FFmpeg is available
3. Python/PyTorch is available

If PyTorch isn't available, the service falls back to FFmpeg-only voice isolation (300Hz-3400Hz bandpass).

## Troubleshooting

### Check availability
```bash
# FFmpeg
ffmpeg -version

# PyTorch
python3 -c "import torch; print(torch.__version__)"
```

### Model not found
If you see "Model not found", ensure `deployment/models/model_best.ckpt` exists and contains `data.pkl`.

## Model Details

- **Size**: ~8 MB
- **Architecture**: DeepFilterNet3
- **Sample Rate**: 16 kHz (input is auto-resampled)
- **Processing**: ~1ms per 10ms audio on CPU
- **Latency**: ~20ms algorithmic