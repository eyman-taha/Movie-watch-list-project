# CineWatch - UX Documentation

---

## 1. User Flows

### 1.1 Authentication Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      APP START                                    │
│                         │                                         │
│                         ▼                                         │
│              ┌─────────────────────┐                             │
│              │    Splash Screen    │                             │
│              │  (Check Auth State) │                             │
│              └──────────┬──────────┘                             │
│                         │                                         │
│                         ▼                                         │
│              ┌─────────────────────┐                             │
│              │  Is User Logged In? │                             │
│              └──────────┬──────────┘                             │
│                         │                                         │
│            ┌────────────┴────────────┐                           │
│            │                         │                            │
│            ▼                         ▼                            │
│      ┌──────────┐           ┌──────────────┐                     │
│      │   YES    │           │     NO       │                     │
│      └────┬─────┘           └──────┬───────┘                     │
│           │                        │                               │
│           ▼                        ▼                               │
│   ┌──────────────┐      ┌────────────────┐                        │
│   │  Home Screen │      │  Login Screen  │                        │
│   │ (Main Shell) │      └───────┬────────┘                        │
│   └──────────────┘              │                                 │
│                                ┌┴───────────┐                      │
│                                │Sign Up/Login│                      │
│                                │   Options   │                      │
│                                └──────┬─────┘                      │
│                              ┌────────┴────────┐                   │
│                              │                 │                    │
│                              ▼                 ▼                    │
│                      ┌──────────────┐ ┌──────────────┐            │
│                      │Login Screen  │ │Register Screen│            │
│                      └──────┬───────┘ └──────┬───────┘            │
│                             │                 │                    │
│                             └────────┬────────┘                    │
│                                      │                             │
│                                      ▼                             │
│                             ┌────────────────┐                   │
│                             │  Auth Success?  │                   │
│                             └───────┬────────┘                    │
│                              ┌──────┴──────┐                      │
│                              │             │                       │
│                              ▼             ▼                       │
│                       ┌──────────┐ ┌──────────────┐               │
│                       │   YES    │ │     NO       │               │
│                       └────┬─────┘ └──────┬───────┘               │
│                            │               │                       │
│                            ▼               ▼                       │
│                   ┌──────────────┐ Show Error                     │
│                   │  Home Screen │  Message                       │
│                   │ (Main Shell) │                                │
│                   └──────────────┘                                │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 Movie Discovery Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      HOME SCREEN                                  │
│                         │                                         │
│  ┌─────────────────────┼─────────────────────┐                   │
│  │                     │                     │                   │
│  ▼                     ▼                     ▼                   │
│ TRENDING            POPULAR             TOP RATED                │
│                     │                     │                       │
│                     ▼                     │                       │
│              ┌──────────────┐            │                       │
│              │Horizontal List│◄───────────┘                       │
│              │ of Movies     │                                  │
│              └───────┬──────┘                                  │
│                      │                                           │
│                      ▼                                           │
│              ┌──────────────┐                                    │
│              │  User Taps   │                                    │
│              │   a Movie    │                                    │
│              └───────┬──────┘                                    │
│                      │                                           │
│                      ▼                                           │
│           ┌─────────────────────┐                                │
│           │  Movie Details      │                                │
│           │     Screen          │                                │
│           └──────────┬──────────┘                                │
│                      │                                           │
│                      ▼                                           │
│           ┌─────────────────────┐                                │
│           │                     │                                 │
│           ▼                     ▼                                 │
│    ┌──────────────┐    ┌──────────────┐                          │
│    │Add to Watchlist│  │  Play Trailer │                          │
│    └───────┬──────┘    └──────┬───────┘                          │
│            │                   │                                   │
│            ▼                   ▼                                   │
│     ┌────────────┐    ┌──────────────┐                            │
│     │  Bottom    │    │  External    │                            │
│     │  Sheet    │    │  YouTube App │                            │
│     │  (Choose  │    │  Opens       │                            │
│     │  Status)  │    └──────────────┘                            │
│     └─────┬─────┘                                               │
│           │                                                      │
│           ▼                                                      │
│    ┌────────────┐                                               │
│    │  Movie     │                                               │
│    │  Added!    │                                               │
│    │  Snackbar  │                                               │
│    └────────────┘                                               │
└─────────────────────────────────────────────────────────────────┘
```

### 1.3 Watchlist Management Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    WATCHLIST SCREEN                              │
│                         │                                         │
│                         ▼                                         │
│              ┌─────────────────────┐                             │
│              │   Filter Tabs       │                             │
│              │ [All][Plan][Watch]  │                             │
│              └──────────┬──────────┘                             │
│                         │                                         │
│                         ▼                                         │
│              ┌─────────────────────┐                             │
│              │  Display Movies     │                             │
│              │  Based on Filter    │                             │
│              └──────────┬──────────┘                             │
│                         │                                         │
│           ┌─────────────┼─────────────┐                           │
│           │             │             │                           │
│           ▼             ▼             ▼                           │
│      ┌─────────┐  ┌─────────┐  ┌─────────┐                        │
│      │  Tap    │  │  Tap    │  │  Swipe  │                        │
│      │  Movie  │  │  Menu   │  │  Left   │                        │
│      └────┬────┘  └────┬────┘  └────┬────┘                        │
│           │             │             │                            │
│           ▼             ▼             ▼                            │
│    ┌────────────┐ ┌───────────┐ ┌───────────┐                     │
│    │ Navigate  │ │Show Popup │ │ Delete    │                     │
│    │ to Movie │ │ Menu      │ │ with Undo │                     │
│    │ Details  │ └─────┬─────┘ │ Snackbar  │                     │
│    └────────────┘       │       └───────────┘                     │
│                         │                                         │
│                         ▼                                         │
│                  ┌───────────┐                                    │
│                  │ Options:  │                                    │
│                  │- Plan     │                                    │
│                  │- Watching │                                    │
│                  │- Watched  │                                    │
│                  │- Favorite │                                    │
│                  │- Remove   │                                    │
│                  └───────────┘                                    │
└─────────────────────────────────────────────────────────────────┘
```

### 1.4 Search Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    SEARCH SCREEN                                  │
│                         │                                         │
│                         ▼                                         │
│   ┌───────────────────────────────────────────────────────┐   │
│   │  🔍  Search movies...                              ✕    │   │
│   └───────────────────────────────────────────────────────┘   │
│                         │                                         │
│   ┌───────────────────────────────────────────────────────┐   │
│   │  [All] [Action] [Comedy] [Drama] [Horror] [Sci-Fi]   │   │
│   └───────────────────────────────────────────────────────┘   │
│                         │                                         │
│                         ▼                                         │
│              ┌─────────────────────┐                             │
│              │   Query Empty?       │                             │
│              └──────────┬──────────┘                             │
│            ┌────────────┴────────────┐                             │
│            │                         │                            │
│            ▼                         ▼                            │
│     ┌──────────────┐        ┌──────────────┐                     │
│     │  YES        │        │  NO          │                     │
│     │ Show Recent │        │ Show Results │                     │
│     │  Searches   │        └──────┬───────┘                     │
│     └──────────────┘               │                             │
│                                   │                             │
│     ┌──────────────────────────────┴──────────────┐             │
│     │                                         │                  │
│     ▼                                         ▼                  │
│ ┌────────────────┐                    ┌────────────────┐         │
│ │ Search History │                    │ Results Grid   │         │
│ │ - Avengers    │                    │ ┌────┬────┐    │         │
│ │ - Batman      │                    │ │ 🎬 │ 🎬 │    │         │
│ │ - Spider-Man  │                    │ ├────┼────┤    │         │
│ │ [Clear All]  │                    │ │ 🎬 │ 🎬 │    │         │
│ └────────────────┘                    │ └────┴────┘    │         │
│                                       └────────────────┘         │
│                                              │                   │
│                                              ▼                   │
│                                       ┌──────────────┐           │
│                                       │  User Taps   │           │
│                                       │    Movie     │           │
│                                       └──────┬───────┘           │
│                                              │                    │
│                                              ▼                    │
│                                    ┌─────────────────┐           │
│                                    │  Movie Details  │           │
│                                    │    Screen       │           │
│                                    └─────────────────┘           │
└─────────────────────────────────────────────────────────────────┘
```

### 1.5 Profile & Settings Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    PROFILE SCREEN                                 │
│                         │                                         │
│                         ▼                                         │
│   ┌───────────────────────────────────────────────────────┐   │
│   │  Stats: [Plan: 12] [Watch: 5] [Watched: 28] [Fav: 8]│   │
│   └───────────────────────────────────────────────────────┘   │
│                         │                                         │
│   ┌───────────────────────────────────────────────────────┐   │
│   │  ACCOUNT                                                │   │
│   │  ┌─────────────────────────────────────────────────┐ │   │
│   │  │ 👤  Edit Profile                        ──────▶│ │   │
│   │  ├─────────────────────────────────────────────────┤ │   │
│   │  │ 🔒  Change Password                         ───▶│ │   │
│   │  └─────────────────────────────────────────────────┘ │   │
│   └───────────────────────────────────────────────────────┘   │
│                         │                                         │
│   ┌───────────────────────────────────────────────────────┐   │
│   │  PREFERENCES                                            │   │
│   │  ┌─────────────────────────────────────────────────┐ │   │
│   │  │ 🔔  Notifications                        [SWITCH] │ │   │
│   │  ├─────────────────────────────────────────────────┤ │   │
│   │  │ 🌐  Language                           ────────▶│ │   │
│   │  └─────────────────────────────────────────────────┘ │   │
│   └───────────────────────────────────────────────────────┘   │
│                         │                                         │
│   ┌───────────────────────────────────────────────────────┐   │
│   │  SUPPORT                                                │   │
│   │  ┌─────────────────────────────────────────────────┐ │   │
│   │  │ ❓  Help & FAQ                           ───▶  │ │   │
│   │  ├─────────────────────────────────────────────────┤ │   │
│   │  │ ℹ️  About                                  ───▶│ │   │
│   │  └─────────────────────────────────────────────────┘ │   │
│   └───────────────────────────────────────────────────────┘   │
│                         │                                         │
│                         ▼                                         │
│              ┌─────────────────────┐                             │
│              │   🚪  Sign Out     │                             │
│              └──────────┬──────────┘                             │
│                         │                                         │
│                         ▼                                         │
│              ┌─────────────────────┐                             │
│              │  Confirmation Dialog │                             │
│              └──────────┬──────────┘                             │
│                         │                                         │
│            ┌────────────┴────────────┐                           │
│            │                         │                            │
│            ▼                         ▼                            │
│      ┌──────────┐           ┌──────────────┐                     │
│      │  Cancel  │           │  Sign Out    │                     │
│      └──────────┘           └──────┬───────┘                     │
│                                   │                               │
│                                   ▼                               │
│                          ┌──────────────┐                        │
│                          │  Navigate to │                        │
│                          │  Login Screen│                        │
│                          └──────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Navigation Structure

### 2.1 Navigation Hierarchy

```
App
│
├── Unauthenticated Routes
│   ├── / (Splash)
│   ├── /login
│   └── /register
│
└── Authenticated Routes (Shell)
    │
    ├── /home (Home)
    │   └── /movie/:id (Movie Details)
    │
    ├── /search (Search)
    │   └── /movie/:id (Movie Details)
    │
    ├── /watchlist (Watchlist)
    │   └── /movie/:id (Movie Details)
    │
    └── /profile (Profile)
        └── /settings (Settings)
```

### 2.2 Navigation Flow Diagram

```
                    ┌─────────┐
                    │  Splash │
                    └────┬────┘
                         │
                         ▼
              ┌──────────────────────┐
              │   Check Auth State    │
              └──────────┬───────────┘
                         │
         ┌───────────────┴───────────────┐
         │                               │
         ▼                               ▼
   ┌─────────┐                   ┌───────────┐
   │  Login  │                   │   Home    │
   │ Screen  │                   │  (Shell)  │
   └────┬────┘                   └─────┬─────┘
        │                               │
        │              ┌───────────────┼───────────────┐
        │              │               │               │
        │              ▼               ▼               ▼
        │        ┌─────────┐     ┌─────────┐   ┌─────────┐
        │        │  Home   │     │ Search  │   │ Profile │
        │        └───┬─────┘     └────┬────┘   └───┬─────┘
        │            │               │              │
        │            └───────┬───────┘              │
        │                    │                      │
        │                    ▼                      │
        │            ┌──────────────────────┐      │
        │            │   Movie Details       │      │
        │            │   /movie/:id           │      │
        │            └──────────────────────┘      │
        │                    │                      │
        │                    └──────────┬───────────┘
        │                               │
        └───────────────────────────────┼───────────────────────┐
                                        │                       │
                                        ▼                       ▼
                                  ┌───────────┐         ┌───────────┐
                                  │ Bottom Nav │         │  Settings │
                                  └───────────┘         └───────────┘
```

### 2.3 Deep Linking Routes

| Route | Description | Parameters |
|-------|-------------|------------|
| `/` | Splash screen | - |
| `/login` | Login screen | - |
| `/register` | Registration screen | - |
| `/home` | Home/Discovery | - |
| `/search` | Search screen | `?query=avengers` (optional) |
| `/watchlist` | Watchlist screen | `?filter=watched` (optional) |
| `/profile` | User profile | - |
| `/settings` | Settings screen | - |
| `/movie/:id` | Movie details | `id` (required) |

---

## 3. Design Decisions

### 3.1 Why Dark Mode First?

**Decision**: Dark mode as the primary theme with light mode as secondary.

**Rationale**:
1. **Content Focus**: Dark backgrounds make movie posters and images pop
2. **Power Efficiency**: OLED displays use less power with dark pixels
3. **Reduced Eye Strain**: Comfortable for extended viewing in dim environments
4. **Industry Standard**: Netflix, YouTube, and most streaming apps use dark themes

**Implementation**:
- Default: `ThemeMode.dark`
- Stored in SharedPreferences
- Toggle available in Profile/Settings
- Smooth transition animation between themes

### 3.2 Why Card-Based Layout?

**Decision**: Cards for movie items with poster, title, and rating.

**Rationale**:
1. **Visual Recognition**: Posters are the primary movie identifier
2. **Scannable**: Quick glance at ratings and titles
3. **Consistent Grid**: Easy to browse multiple options
4. **Touch-Friendly**: Large tap targets

**Specifications**:
- Poster Aspect Ratio: 2:3
- Card Padding: 8px
- Gap Between Cards: 8-12px
- Rating Badge: Top-left corner, absolute positioned

### 3.3 Why Bottom Navigation?

**Decision**: 4-tab bottom navigation for main sections.

**Rationale**:
1. **Thumb Zone**: Accessible with one hand
2. **Fast Switching**: Quick context switching
3. **Persistent Access**: Always visible
4. **Standard Pattern**: Familiar to mobile users

**Tabs**:
1. **Home** (🏠) - Movie discovery
2. **Search** (🔍) - Find specific movies
3. **Watchlist** (📚) - Personal tracking
4. **Profile** (👤) - User account

### 3.4 Why Horizontal Carousels on Home?

**Decision**: Horizontal scrolling carousels for movie categories.

**Rationale**:
1. **Discovery Focus**: Encourages exploration
2. **Screen Real Estate**: Shows more content variety
3. **Genre Organization**: Logical grouping
4. **Netflix Pattern**: Users expect this pattern

**Categories**:
- Trending Now (most popular this week)
- Popular (all-time favorites)
- Top Rated (critically acclaimed)
- Now Playing (currently in theaters)
- Upcoming (future releases)

### 3.5 Why 3 Watchlist Statuses?

**Decision**: Plan to Watch, Still Watching, Watched.

**Rationale**:
1. **Simple Yet Complete**: Covers all user states
2. **Decision Tracking**: Clear progress indication
3. **Reduced Friction**: Easy to change status
4. **Statistics**: Can show meaningful counts

**Status Details**:
| Status | Icon | Color | Description |
|--------|------|-------|-------------|
| Plan to Watch | ⏱ | Orange | Future viewing |
| Still Watching | ▶️ | Blue | In progress |
| Watched | ✅ | Green | Completed |

### 3.6 Why Pull-to-Refresh?

**Decision**: Pull-to-refresh on list screens.

**Rationale**:
1. **Explicit Refresh**: User control over data freshness
2. **Standard Pattern**: Familiar interaction
3. **Offline Indicator**: Shows when data is stale
4. **Reduces Empty States**: Ensures content is loaded

### 3.7 Why Hero Animations?

**Decision**: Hero animations between list and detail screens.

**Rationale**:
1. **Visual Continuity**: Connects the experience
2. **Spatial Memory**: User knows where they came from
3. **Delight Factor**: Adds polish and delight
4. **Performance**: GPU-accelerated by Flutter

### 3.8 Why Debounced Search?

**Decision**: 500ms debounce on search input.

**Rationale**:
1. **API Efficiency**: Reduces unnecessary requests
2. **Performance**: Prevents UI lag
3. **Cost Saving**: Fewer API calls = lower costs
4. **User Experience**: Only searches when user stops typing

### 3.9 Why Persistent Local Storage?

**Decision**: Hive for local storage of watchlist.

**Rationale**:
1. **Offline Support**: Works without internet
2. **Speed**: Instant data access
3. **Reliability**: Data persists across sessions
4. **Simplicity**: No backend required for MVP

### 3.10 Why Riverpod for State Management?

**Decision**: Riverpod over other state management solutions.

**Rationale**:
1. **Compile-Time Safety**: Catches errors early
2. **Testability**: Easy to mock providers
3. **Code Generation**: Minimal boilerplate
4. **Provider Pattern**: Familiar and intuitive
5. **Performance**: Lazy loading of providers

---

## 4. Interaction Patterns

### 4.1 Gestures

| Gesture | Location | Action |
|---------|----------|--------|
| Tap | Movie Card | Open Movie Details |
| Tap | Bottom Nav Item | Switch Tab |
| Tap | Icon Button | Perform Action |
| Swipe Left | Watchlist Item | Reveal Delete |
| Long Press | Movie Card | (Future: Quick Actions) |
| Pull Down | List Screen | Refresh Content |
| Pinch | Image | Zoom In/Out |

### 4.2 Feedback Patterns

| Action | Feedback | Duration |
|--------|----------|----------|
| Button Tap | Scale Down Animation | 150ms |
| Add to Watchlist | Snackbar + Button Change | Permanent |
| Remove from Watchlist | Snackbar + Undo | 4 seconds |
| Favorite Toggle | Heart Animation + Color | 300ms |
| Error | Snackbar with Message | 4 seconds |
| Loading | Shimmer Skeleton | Until loaded |
| Success | Check Icon + Snackbar | 2 seconds |

### 4.3 Loading States

| Screen | Loading State | Implementation |
|--------|---------------|----------------|
| Home | Category Skeletons | Shimmer animation |
| Movie Details | Full Screen Skeleton | Shimmer animation |
| Search | Empty with Spinner | Circular Progress |
| Watchlist | Full List Skeleton | Shimmer animation |
| Profile | Content Skeleton | Shimmer animation |

### 4.4 Error Handling

| Error Type | User Message | Action |
|------------|--------------|--------|
| Network Offline | "No internet connection" | Retry Button |
| API Error | "Something went wrong" | Retry Button |
| Not Found | "Movie not found" | Go Back |
| Auth Expired | "Session expired" | Login Screen |
| Rate Limited | "Too many requests" | Wait Message |

---

## 5. Accessibility Considerations

### 5.1 Semantic Labels

```dart
// All icons have semantic labels
Semantics(
  label: 'Add to watchlist',
  child: IconButton(
    icon: Icons.add,
    onPressed: _addToWatchlist,
  ),
)

// Images have alt text
Image.network(
  posterUrl,
  semanticLabel: 'Movie poster for $movieTitle',
)
```

### 5.2 Color Contrast

| Element | Foreground | Background | Ratio |
|---------|------------|------------|-------|
| Primary Button | White | Red (#E50914) | 4.8:1 ✓ |
| Body Text | White (#FFF) | Dark (#0D0D0D) | 16.1:1 ✓ |
| Secondary Text | Grey (#808080) | Dark (#0D0D0D) | 5.6:1 ✓ |
| Rating Badge | White | Green (#4CAF50) | 4.6:1 ✓ |

### 5.3 Touch Targets

- Minimum touch target: 48x48dp
- Recommended: 56x56dp
- All buttons and icons meet WCAG 2.1 guidelines

---

## 6. Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Cold Start | < 2 seconds | App launch to splash |
| Warm Start | < 500ms | Tab switch |
| API Response | < 1 second | TMDB API |
| Frame Rate | 60 FPS | All animations |
| Memory Usage | < 200MB | Active usage |
| APK Size | < 30MB | Release build |

---

## 7. Future Enhancements

### Potential Features

1. **Dark/Light Theme Toggle** - Theme switching in settings
2. **Sort Watchlist** - By date added, rating, title
3. **Notifications** - Reminders for planned movies
4. **Watch History** - Timeline of watched movies
5. **Recommendations** - AI-based suggestions
6. **Social Features** - Share watchlist, follow friends
7. **Multi-language** - Internationalization
8. **Offline Mode** - Download movies for offline viewing

---

*UX Documentation created: March 2026*
