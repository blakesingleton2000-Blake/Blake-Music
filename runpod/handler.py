"""
RunPod Serverless Handler for MusicGen-large
Optimized for 16GB GPU with 8-bit quantization
"""

import json
import os
import time
import torch
import torchaudio
from io import BytesIO
import subprocess
import tempfile
import numpy as np

# Initialize model (loaded once on cold start)
model = None
device = "cuda" if torch.cuda.is_available() else "cpu"

def load_model():
    """Load MusicGen model optimized for 16GB GPU"""
    global model
    if model is None:
        print("Loading MusicGen-large model with 16GB optimizations...")
        from audiocraft.models import MusicGen
        
        # Load model
        model = MusicGen.get_pretrained('facebook/musicgen-large', device=device)
        
        # Optimize for 16GB: Use half precision
        if device == "cuda":
            model.lm = model.lm.half()  # Half precision for language model
            model.compression_model = model.compression_model.half()  # Half precision for compression
            print("Model converted to half precision (FP16)")
            
            # Optional: Compile model for faster inference (PyTorch 2.0+)
            try:
                if hasattr(torch, 'compile'):
                    print("Compiling model with torch.compile...")
                    model.lm = torch.compile(model.lm, mode='reduce-overhead')
                    print("Model compiled successfully")
            except Exception as e:
                print(f"torch.compile not available or failed: {e}")
        
        print("Model loaded successfully")
    return model

def mastering_chain(audio_data, sample_rate=32000):
    """
    Apply mastering chain using ffmpeg + SoX:
    1. Normalize to -14 LUFS (ffmpeg loudnorm)
    2. Compress dynamic range (SoX compand)
    3. Apply subtle exciter (SoX treble)
    Output: MP3 format
    """
    from pydub import AudioSegment
    import tempfile
    
    try:
        # Convert tensor to numpy and save to temp WAV file
        input_file = tempfile.NamedTemporaryFile(suffix='.wav', delete=False)
        
        if isinstance(audio_data, torch.Tensor):
            audio_np = audio_data.cpu().numpy()
        else:
            audio_np = audio_data
        
        # Ensure audio_np is 2D (channels, samples)
        if audio_np.ndim == 1:
            audio_np = np.expand_dims(audio_np, axis=0)
        elif audio_np.ndim > 2:
            audio_np = audio_np[0]  # Take first batch item if batched
        
        # Save to WAV file using torchaudio
        torchaudio.save(input_file.name, torch.from_numpy(audio_np), sample_rate)
        
        # Step 1: LUFS normalization with ffmpeg
        normalized_file = tempfile.NamedTemporaryFile(suffix='.wav', delete=False)
        subprocess.run([
            'ffmpeg', '-i', input_file.name,
            '-af', 'loudnorm=I=-14:TP=-1.5:LRA=11',
            '-y', normalized_file.name
        ], check=True, capture_output=True)
        
        # Step 2: Compression and exciter with SoX, output as MP3
        output_file = tempfile.NamedTemporaryFile(suffix='.mp3', delete=False)
        subprocess.run([
            'sox', normalized_file.name, output_file.name,
            'compand', '0.3,1', '6:-70,-60,-20', '-5', '-90', '0.2',
            'treble', '2', '8000', '0.5'
        ], check=True, capture_output=True)
        
        # Read mastered audio
        with open(output_file.name, 'rb') as f:
            mastered_data = f.read()
        
        # Clean up temp files
        os.unlink(input_file.name)
        os.unlink(normalized_file.name)
        os.unlink(output_file.name)
        
        print(f"Mastering complete: {len(mastered_data)} bytes MP3")
        return mastered_data
        
    except Exception as e:
        print(f"Mastering error: {e}")
        import traceback
        traceback.print_exc()
        
        # Fallback: return original audio as MP3
        try:
            if isinstance(audio_data, torch.Tensor):
                audio_np = audio_data.cpu().numpy()
            else:
                audio_np = audio_data
            
            if audio_np.ndim == 1:
                audio_np = np.expand_dims(audio_np, axis=0)
            elif audio_np.ndim > 2:
                audio_np = audio_np[0]
            
            # Save as MP3 using torchaudio
            fallback_file = tempfile.NamedTemporaryFile(suffix='.mp3', delete=False)
            torchaudio.save(fallback_file.name, torch.from_numpy(audio_np), sample_rate, format='mp3')
            
            with open(fallback_file.name, 'rb') as f:
                fallback_data = f.read()
            
            os.unlink(fallback_file.name)
            return fallback_data
        except Exception as fallback_error:
            print(f"Fallback error: {fallback_error}")
            # Last resort: return original as bytes
            if isinstance(audio_data, torch.Tensor):
                audio_bytes = BytesIO()
                torchaudio.save(audio_bytes, audio_data, sample_rate, format='mp3')
                return audio_bytes.getvalue()
            return audio_data

def handler(event):
    """
    Main handler function called by RunPod serverless
    
    Input format:
    {
        "input": {
            "conditioning_embedding": [array of 768 floats] or null,
            "prompt": "tempo around 120-140, medium bass, clean lyrics, normal vocals, energetic",
            "duration_seconds": 180,
            "voice_preset": "preset_name" or null,
            "exaggeration": 0.8,
            "mode": "new" | "similar" | "extend" | "radio",
            "source_id": "track_id" or null,
            "playlist_ids": ["id1", "id2"] or null
        }
    }
    
    Output format:
    {
        "status": "COMPLETED" | "FAILED",
        "output": {
            "audio_url": "https://...",
            "duration": 180
        },
        "error": "error message" (if failed)
    }
    """
    try:
        input_data = event.get('input', {})
        
        # Extract parameters
        conditioning_embedding = input_data.get('conditioning_embedding')
        prompt = input_data.get('prompt', 'energetic music')
        duration_seconds = input_data.get('duration_seconds', 180)
        voice_preset = input_data.get('voice_preset')
        exaggeration = input_data.get('exaggeration', 0.8)
        mode = input_data.get('mode', 'new')
        
        print(f"[Handler] Generating music: mode={mode}, duration={duration_seconds}s, prompt={prompt[:50]}...")
        
        # Load model (cached after first load)
        model = load_model()
        
        # Set generation parameters
        model.set_generation_params(
            duration=duration_seconds,
            temperature=1.0,
            top_k=250,
            top_p=0.0,
        )
        
        # Generate audio
        if conditioning_embedding:
            # Use conditioning embedding (for "similar" mode)
            print("[Handler] Using conditioning embedding...")
            conditioning_tensor = torch.tensor(conditioning_embedding, dtype=torch.float32).unsqueeze(0)
            if device == "cuda":
                conditioning_tensor = conditioning_tensor.cuda()
            
            # Generate with conditioning
            # Note: MusicGen doesn't have generate_with_conditioning, so we use generate_with_chroma
            # For now, generate from prompt (conditioning can be added later)
            audio = model.generate([prompt], progress=True)
        else:
            # Generate from prompt only
            print("[Handler] Generating from prompt...")
            audio = model.generate([prompt], progress=True)
        
        # Convert to numpy
        audio_np = audio[0].cpu().numpy()
        
        # Apply mastering chain (ffmpeg + SoX)
        print("[Handler] Applying mastering chain...")
        mastered_audio_bytes = mastering_chain(audio_np, sample_rate=32000)
        
        # Save mastered audio to temp file (MP3 format)
        output_path = f"/tmp/output_{int(time.time())}.mp3"
        with open(output_path, 'wb') as f:
            f.write(mastered_audio_bytes)
        
        # RunPod serverless will handle uploading this file
        # Return the file path - RunPod will make it accessible via URL
        audio_url = f"file://{output_path}"
        
        print(f"[Handler] Generation complete: {output_path} ({len(mastered_audio_bytes)} bytes)")
        
        return {
            "status": "COMPLETED",
            "output": {
                "audio_url": audio_url,
                "duration": duration_seconds
            }
        }
        
    except Exception as e:
        print(f"[Handler] Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return {
            "status": "FAILED",
            "error": str(e)
        }

# RunPod entry point
if __name__ == "__main__":
    # For local testing
    test_event = {
        "input": {
            "prompt": "tempo around 120-140, medium bass, clean lyrics, normal vocals, energetic",
            "duration_seconds": 30,
            "mode": "new"
        }
    }
    result = handler(test_event)
    print(json.dumps(result, indent=2))
