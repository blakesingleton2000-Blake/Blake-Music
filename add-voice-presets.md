# Add Voice Preset WAV Files

## Overview

Voice presets are reference audio files used by Chatterbox TTS to generate vocals with specific characteristics. We need 12 preset files.

## Preset Types Needed

1. **Male Voice - Deep** (bass, baritone)
2. **Male Voice - Mid** (tenor, standard)
3. **Male Voice - High** (countertenor, falsetto)
4. **Female Voice - Deep** (alto, contralto)
5. **Female Voice - Mid** (mezzo-soprano)
6. **Female Voice - High** (soprano)
7. **Androgynous Voice - Low**
8. **Androgynous Voice - Mid**
9. **Androgynous Voice - High**
10. **Rap/Hip-Hop Style**
11. **Rock/Metal Style**
12. **Pop/Electronic Style**

## File Requirements

- **Format**: WAV, 16-bit, 44.1kHz or 48kHz
- **Duration**: 5-10 seconds each
- **Content**: Clean speech or singing sample
- **Naming**: `preset-{name}.wav` (e.g., `preset-male-deep.wav`)

## Options for Getting Presets

### Option 1: Generate Using TTS
- Use ElevenLabs, PlayHT, or similar
- Generate 5-10 second samples
- Export as WAV

### Option 2: Use Public Domain Samples
- Find royalty-free voice samples
- Convert to WAV format
- Normalize audio levels

### Option 3: Record Samples
- Record 12 different voice types
- Process and normalize
- Export as WAV

## Upload to Supabase Storage

After creating files:

1. Go to Supabase Dashboard → Storage
2. Open `audio` bucket
3. Create folder: `voice-presets`
4. Upload all 12 WAV files

## Update Code

Update `app/lib/runpod.ts` or generation endpoint to reference presets:

```typescript
const voicePresets = {
  'male-deep': 'https://...supabase.co/storage/v1/object/public/audio/voice-presets/preset-male-deep.wav',
  'male-mid': 'https://...supabase.co/storage/v1/object/public/audio/voice-presets/preset-male-mid.wav',
  // ... etc
}
```

## For MVP

**Temporary**: Can skip voice presets and use default MusicGen vocals. Voice presets are enhancement, not blocker.

---

**Status**: Not started - Can be done later or use defaults

