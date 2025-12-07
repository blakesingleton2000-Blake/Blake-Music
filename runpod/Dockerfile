FROM runpod/pytorch:2.3.1-py3.10-cuda12.1.1-devel-ubuntu22.04

WORKDIR /app

# Install system dependencies (ffmpeg, sox for mastering)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    sox \
    libsox-dev \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    git+https://github.com/facebookresearch/audiocraft.git \
    torchaudio \
    numpy \
    pydub \
    librosa

# Copy handler script
COPY handler.py /app/handler.py

# Set working directory
WORKDIR /app

# RunPod serverless expects handler.py to be executable
# The handler function will be called by RunPod's runtime
CMD ["python", "/app/handler.py"]
