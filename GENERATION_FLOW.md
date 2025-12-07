# Music Generation Flow - Complete Implementation

## Overview

This document describes the exact music generation flow implemented, matching the PRD specifications exactly.

## Flow Diagram

```
User taps "Generate" (any mode)
        ↓
POST /api/generate (Next.js API Route)
        ↓
1. Load user taste_vector + preferences_profile from Supabase
        ↓
2. Resolve source embedding (if "similar" or "extend")
   - extend: Exact source embedding
   - similar: 70% source + 30% user vector
   - radio: Average playlist embeddings
   - new: User taste_vector
        ↓
3. Build conditioning embedding + prompt
   - Prompt: "tempo around X, Y bass, explicit/clean lyrics, Z vocals, mood"
        ↓
4. Call RunPod serverless endpoint (MusicGen-large on A100)
   - Payload: { conditioning_embedding, prompt, duration_seconds, voice_preset, exaggeration }
        ↓
5. Poll until complete (timeout 120s)
        ↓
6. Receive raw audio URL
        ↓
7. Apply mastering chain (normalize -14 LUFS, compress, exciter)
   - For MVP: Mastering happens on RunPod side
   - Production: Download, master, upload to Supabase Storage
        ↓
8. Generate LLM explanation ("Because you love X...")
        ↓
9. Save track metadata + explanation to database
        ↓
10. Return signed URL + explanation to frontend
```

## Implementation Files

### 1. `/app/api/generate/route.ts`
- Main generation endpoint
- Follows exact PRD flow
- Handles all 4 modes: new, similar, extend, radio

### 2. `/app/lib/runpod.ts`
- RunPod API client
- Exact payload format from PRD
- Status polling with timeout

### 3. `/app/lib/embedding-resolver.ts`
- Resolves embeddings from various sources
- Fallback chain: embeddings table → LLM → taste_vector
- Mixes embeddings for "similar" mode (70/30)

### 4. `/app/lib/llm-explanations.ts`
- Generates explanations using OpenAI GPT-4
- "Because you love X..." format
- Mode-specific explanations

### 5. `/app/lib/mastering.ts`
- Mastering chain placeholder
- For MVP: Returns URL as-is
- Production: Would download, master, upload

## Key Features

### Conditioning Embedding Resolution

**Extend Mode**:
```typescript
conditioning = await resolveEmbedding({ sourceId: source_id })
// Falls back to taste_vector if not found
```

**Similar Mode**:
```typescript
const sourceEmb = await resolveEmbedding({ sourceId: source_id })
if (sourceEmb && tasteVector) {
  // Mix: 0.7 * source + 0.3 * user
  conditioning = sourceEmb.map((val, i) => 0.7 * val + 0.3 * tasteVector[i])
}
```

**Radio Mode**:
```typescript
conditioning = await getPlaylistEmbeddings(playlist_ids)
// Averages all playlist track embeddings
```

**New Mode**:
```typescript
conditioning = tasteVector
// Uses user's taste vector directly
```

### Prompt Building

Exact format from PRD:
```typescript
const promptParts = [
  `tempo around ${preferences.tempo_range || '120-140'}`,
  `${preferences.bass_level || 'medium'} bass`,
  preferences.explicit_lyrics ? 'explicit lyrics' : 'clean lyrics',
  preferences.vocal_style || 'normal vocals',
  preferences.mood || 'energetic',
]
const prompt = promptParts.join(', ')
```

### RunPod Payload

Exact format from PRD:
```typescript
{
  input: {
    conditioning_embedding: conditioning,
    prompt: prompt,
    duration_seconds: duration,
    voice_preset: voicePreset,
    exaggeration: preferences.exaggeration || 0.8,
    mode: mode,
    source_id: source_id,
    playlist_ids: playlist_ids,
  }
}
```

## Cost & Performance

- **3-min song**: 15-20s on A100 spot → $0.008-$0.012
- **30-min extension**: 90-120s → $0.048-$0.060
- **10k DAU (100k gens/day)**: ~$1,200/mo

## Testing

Test the endpoint:

```bash
curl -X POST http://localhost:3000/api/generate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "mode": "new",
    "duration": 180
  }'
```

## Next Steps

1. **Deploy RunPod Serverless Template** (see `RUNPOD_SETUP.md`)
2. **Configure Environment Variables**:
   - `RUNPOD_API_KEY`
   - `RUNPOD_ENDPOINT_ID`
   - `OPENAI_API_KEY` (for explanations)
3. **Set up Supabase Storage** (for mastered audio uploads)
4. **Implement mastering chain** (SoX + pydub)

## Status

✅ **Complete**: Generation flow matches PRD exactly
✅ **Complete**: All 4 modes implemented
✅ **Complete**: Conditioning embedding resolution
✅ **Complete**: LLM explanations
🔄 **Pending**: Mastering chain (placeholder)
🔄 **Pending**: Supabase Storage upload

