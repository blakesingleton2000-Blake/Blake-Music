# Remaining Features to Build

## ✅ What's Complete

- Database schema (10 tables)
- Authentication (email + Google OAuth)
- Onboarding flow (3 steps)
- Home screen with categories
- Search screen with autosuggest
- Library screen with filters
- Generate page with modes
- Full Player component
- Mini Player component
- RunPod integration (API ready)
- OAuth connections (Spotify + Apple)
- Settings page
- All core API routes

---

## 🔨 Critical Features Missing

### 1. **Playlist Creation & Editing** ⚠️ HIGH PRIORITY
- **Missing**: `/playlist/new` page
- **Missing**: `/playlist/[id]/edit` page
- **Missing**: Drag-and-drop reordering
- **Missing**: Add/remove tracks UI
- **Status**: Library shows playlists but can't create/edit them

### 2. **Actual Audio Playback** ⚠️ HIGH PRIORITY
- **Missing**: Real audio element integration
- **Missing**: Audio loading states
- **Missing**: Error handling for failed audio
- **Status**: Player UI exists but doesn't actually play audio

### 3. **Like/Unlike Functionality** ⚠️ MEDIUM PRIORITY
- **Missing**: Like button on tracks
- **Missing**: Heart icon in player
- **Missing**: Visual feedback when liking
- **Status**: API exists (`/api/like/[id]`) but no UI

### 4. **Add to Playlist Functionality** ⚠️ MEDIUM PRIORITY
- **Missing**: "Add to Playlist" dropdown/modal
- **Missing**: Create playlist from track
- **Status**: API exists but no UI

### 5. **Extend Track Functionality** ⚠️ MEDIUM PRIORITY
- **Missing**: "Extend This" button in player
- **Missing**: Duration selector for extension
- **Status**: Generate API supports extend mode but no UI

---

## 🎯 Important Features from PRDs

### 6. **Band Profiles Page**
- **Missing**: `/band/[id]` page
- **Missing**: Band bio display
- **Missing**: Band tracks grid
- **Missing**: Follow button
- **Missing**: "Play All" functionality
- **Missing**: "Generate More" button
- **Status**: Database table exists, no UI

### 7. **Band Auto-Creation Logic**
- **Missing**: Auto-create bands after 3 similar tracks
- **Missing**: OpenAI integration for band names/bios
- **Missing**: pgvector similarity check
- **Status**: Database ready, logic not implemented

### 8. **Recommendations Engine** ⚠️ HIGH PRIORITY
- **Missing**: Actual pgvector queries for similarity
- **Missing**: Taste vector computation from user history
- **Missing**: "Because you like X" explanations
- **Status**: `/api/categories` returns placeholder data

### 9. **Taste Vector Computation**
- **Missing**: Compute taste_vector from user_history
- **Missing**: Weighted average of embeddings
- **Missing**: Update on like/dislike
- **Status**: Database field exists, no computation logic

### 10. **Infinite Radio Mode**
- **Missing**: Continuous pre-generation
- **Missing**: Auto-queue next 3 tracks
- **Missing**: "Generating next..." indicator
- **Status**: Generate API supports radio mode, but no continuous logic

---

## 🔧 Infrastructure & Polish

### 11. **Screenshot OCR Import**
- **Missing**: `/api/ingest_screenshot` endpoint
- **Missing**: File upload UI
- **Missing**: OpenAI Vision API integration
- **Missing**: Parse songs from screenshot
- **Status**: Mentioned in PRDs, not built

### 12. **Stripe Payments Integration**
- **Missing**: Stripe checkout flow
- **Missing**: Premium upgrade UI
- **Missing**: Webhook handler
- **Missing**: Subscription management
- **Status**: Database field exists, no payment flow

### 13. **Daily Counter Reset Edge Function**
- **Missing**: Deploy `reset-daily-count` function
- **Missing**: Set up cron job
- **Status**: Function code exists, not deployed

### 14. **Pre-Generation Queue Logic**
- **Missing**: Background generation when queue < 3
- **Missing**: Queue management API
- **Status**: Store exists, no background logic

---

## 🎨 UI/UX Improvements

### 15. **Error Boundaries**
- **Missing**: React error boundaries on all pages
- **Missing**: Error fallback UI
- **Status**: No error handling

### 16. **Loading States**
- **Missing**: Skeleton loaders
- **Missing**: Shimmer effects
- **Missing**: Better loading indicators
- **Status**: Basic loading states exist

### 17. **Empty States**
- **Missing**: Better empty state designs
- **Missing**: Call-to-action buttons
- **Status**: Basic empty states exist

### 18. **Mobile Responsiveness**
- **Missing**: Test and fix mobile layouts
- **Missing**: Touch gestures
- **Status**: Desktop-first, needs mobile testing

### 19. **Accessibility**
- **Missing**: ARIA labels
- **Missing**: Keyboard navigation
- **Missing**: Screen reader support
- **Status**: Not implemented

---

## 📊 Analytics & Monitoring

### 20. **PostHog Integration**
- **Missing**: PostHog SDK setup
- **Missing**: Event tracking
- **Missing**: Retention dashboards
- **Status**: Mentioned in PRDs, not implemented

### 21. **Error Tracking**
- **Missing**: Sentry or error tracking
- **Missing**: Error logging
- **Status**: Console.log only

---

## 🚀 Nice-to-Have Features

### 22. **Explore Feed** (Reels-style)
- **Missing**: `/explore` page
- **Missing**: Vertical scroll feed
- **Missing**: 15-30s clips
- **Status**: Mentioned in PRDs, not in MVP scope

### 23. **Share Functionality**
- **Missing**: Share buttons
- **Missing**: Share links
- **Status**: UI placeholder exists

### 24. **Search Filters**
- **Missing**: Filter by genre, artist, etc.
- **Status**: Basic search exists

---

## 📋 Priority Order

### **Phase 1: Critical (Must Have)**
1. ✅ Actual audio playback
2. ✅ Playlist creation/editing
3. ✅ Like/Unlike UI
4. ✅ Recommendations engine (real pgvector)
5. ✅ Taste vector computation

### **Phase 2: Important (Should Have)**
6. ✅ Band profiles page
7. ✅ Add to playlist UI
8. ✅ Extend track UI
9. ✅ Infinite Radio continuous mode
10. ✅ Band auto-creation logic

### **Phase 3: Polish (Nice to Have)**
11. ✅ Screenshot OCR import
12. ✅ Stripe payments
13. ✅ Error boundaries
14. ✅ Better loading/empty states
15. ✅ Daily counter reset deployment

---

## 🎯 Next Steps Recommendation

**Start with Phase 1** - These are critical for MVP:
1. Audio playback (makes player actually work)
2. Playlist creation (core feature)
3. Like functionality (user engagement)
4. Real recommendations (core value prop)
5. Taste vector computation (powers recommendations)

**Then Phase 2** - Important features that enhance UX

**Finally Phase 3** - Polish and nice-to-haves

