# Infinite Player - Plan Additions

These items should be added to the main build plan.

---

## Daily Counter Reset Logic (Freemium)

**Standard Implementation** (like most apps):

- **Reset Time**: Midnight UTC daily
- **DB Field**: `users.daily_count` (integer, default 0)
- **Reset Job**: Supabase Edge Function runs at 00:00 UTC
  ```sql
  UPDATE users SET daily_count = 0 WHERE premium = false;
  ```
- **Check Logic** (in `/api/generate`):
  ```typescript
  if (user.premium) {
    // Unlimited - no counter check
    return allowGeneration();
  }
  if (user.daily_count >= 15) {
    return showUpsellModal();
  }
  // Allow and increment
  await incrementDailyCount(user.id);
  return allowGeneration();
  ```
- **UI Display**: "12/15 generations left today" badge on home screen
- **Premium Users**: No counter shown, no limits whatsoever

---

## Queue Management (Best Practices)

### Pre-generation Strategy
- When queue has **< 3 songs** remaining → trigger background pre-generation
- Pre-gen uses user's `taste_vector` + random seed for variety
- Store pre-generated tracks in `generated_tracks` with `status = 'queued'`
- **Max queue size**: 10 songs (prevents storage bloat)

### Queue Data Structure (Zustand Store)
```typescript
interface QueueStore {
  currentTrack: Track | null;
  queue: Track[];           // upcoming songs
  history: Track[];         // recently played (last 50)
  isGenerating: boolean;    // show loading indicator
  
  // Actions
  addToQueue: (track: Track) => void;
  playNext: () => void;
  skipToTrack: (index: number) => void;
  shuffle: () => void;
  clear: () => void;
}
```

### Playback Flow
1. User plays song → set as `currentTrack`, add previous to `history`
2. Song ends → auto-play next from `queue`
3. If queue empty → auto-generate new song OR show "Generate more?" prompt
4. Skip → move current to history, play next

### Infinite Radio Mode
- Continuously pre-generates based on playlist/artist embeddings
- Always keeps **3 songs queued ahead**
- Shows "Generating next track..." indicator when queue < 2
- Never stops - infinite playback until user pauses

---

## Band Profile Generation (Best Practices)

### When to Auto-Create Bands

**Auto-create** (background): After every 3rd generation from same "style cluster"
- Cluster = similar `taste_vector` embeddings (cosine similarity > 0.85)
- Example: 3 songs with "dark synth-pop" vibe → auto-create "Midnight Pulse" band

**User-triggered**: "Save as new band" button on generation success modal

### Band Creation Flow
1. Generation completes → check if similar songs exist (pgvector query)
2. If 3+ similar songs without band → create band:
   - **Name**: OpenAI generates creative name (e.g., "Neon Shadows", "Velvet Static")
   - **Bio**: OpenAI generates 2-3 sentences describing the style
   - **Cover**: Placeholder gradient image (skip AI covers for MVP)
3. Assign all matching tracks to the band
4. Show toast: "New band created: Midnight Pulse" with link to profile

### Band Profile Schema
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "name": "Midnight Pulse",
  "bio": "Dark electronic beats meet dreamy synths. Born from late-night sessions and neon-lit inspiration.",
  "cover_url": "/placeholders/gradient-purple.jpg",
  "style_vector": [0.12, -0.34, ...],
  "track_count": 5,
  "follower_count": 0,
  "created_at": "2025-01-15T10:30:00Z"
}
```

### Follow System
- Follow button on band profile → adds to `user_follows` table
- When band gets new track → push notification to followers
- Future: Weekly email digest of new tracks from followed bands

---

## Additional Risk Mitigation

- **Queue starvation**: Pre-generate when queue < 3; fallback to curated tracks if RunPod is down
- **Band spam**: Max 1 auto-created band per day per user; manual creation unlimited

