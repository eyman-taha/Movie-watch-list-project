# CineWatch - Wireframes (Low-Fidelity)

## Navigation Structure

```
┌─────────────────────────────────────────┐
│            Bottom Navigation              │
├──────────┬──────────┬──────────┬────────┤
│   Home   │  Search  │ Watchlist│Profile │
│    🏠    │    🔍    │    📚    │   👤   │
└──────────┴──────────┴──────────┴────────┘
```

---

## Screen 1: Splash Screen

```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│                                         │
│              ┌─────────┐                │
│              │ 🎬 🎬   │   ← App Icon   │
│              │  MOVIE  │                │
│              │  FILTER │                │
│              └─────────┘                │
│                                         │
│               CineWatch                  │
│                                         │
│         Discover • Watch • Track        │
│                                         │
│                                         │
│                                         │
│              ████████░░░░░              │
│               Loading...                │
│                                         │
└─────────────────────────────────────────┘
```

**Elements:**
- Animated gradient background
- Centered logo with glow effect
- App name below logo
- Tagline text
- Progress indicator

---

## Screen 2: Login Screen

```
┌─────────────────────────────────────────┐
│                                         │
│              ┌─────────┐                │
│              │ 🎬 🎬   │                │
│              └─────────┘                │
│               CineWatch                  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │      Welcome Back!                 │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  📧  Email address          │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  🔒  Password           👁  │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │       Forgot Password?            │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │         SIGN IN             │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │  ─────────── OR ───────────      │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │     🔵  Continue with Google│  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │  Don't have an account? Sign up   │  │
│  └───────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

**Elements:**
- App logo centered at top
- Email input field with icon
- Password field with show/hide toggle
- "Forgot Password" link
- Primary sign-in button
- Divider with "OR"
- Google sign-in button
- Link to registration

---

## Screen 3: Home Screen

```
┌─────────────────────────────────────────┐
│ ≡        CineWatch              🔔      │ ← AppBar
├─────────────────────────────────────────┤
│                                         │
│  ◀ TRENDING NOW ──────────────── ▶    │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐ │
│  │     │  │     │  │     │  │     │ │
│  │ 🎬  │  │ 🎬  │  │ 🎬  │  │ 🎬  │ │
│  │     │  │     │  │     │  │     │ │
│  ├─────┤  ├─────┤  ├─────┤  ├─────┤ │
│  │⭐8.5│  │⭐7.2│  │⭐9.1│  │⭐6.8│ │
│  └─────┘  └─────┘  └─────┘  └─────┘ │
│                                         │
│  POPULAR ──────────────────────────▶   │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐ │
│  │     │  │     │  │     │  │     │ │
│  │ 🎬  │  │ 🎬  │  │ 🎬  │  │ 🎬  │ │
│  │     │  │     │  │     │  │     │ │
│  ├─────┤  ├─────┤  ├─────┤  ├─────┤ │
│  │⭐8.5│  │⭐7.2│  │⭐9.1│  │⭐6.8│ │
│  └─────┘  └─────┘  └─────┘  └─────┘ │
│                                         │
│  TOP RATED ───────────────────────▶    │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐ │
│  │     │  │     │  │     │  │     │ │
│  │ 🎬  │  │ 🎬  │  │ 🎬  │  │ 🎬  │ │
│  │     │  │     │  │     │  │     │ │
│  ├─────┤  ├─────┤  ├─────┤  ├─────┤ │
│  │⭐8.5│  │⭐7.2│  │⭐9.1│  │⭐6.8│ │
│  └─────┘  └─────┘  └─────┘  └─────┘ │
│                                         │
├─────────────────────────────────────────┤
│   🏠      🔍      📚      👤          │
└─────────────────────────────────────────┘
```

**Elements:**
- Hamburger menu + App title in AppBar
- Horizontal scrolling carousels
- Movie cards with poster, rating badge
- Category headers with "See All" arrows
- Bottom navigation bar

---

## Screen 4: Movie Details Screen

```
┌─────────────────────────────────────────┐
│ ←                                   ❤️ ♫  │ ← Back button, Favorite, Share
├─────────────────────────────────────────┤
│                                         │
│    ┌─────────────┐  ┌────────────────┐ │
│    │             │  │ Movie Title    │ │
│    │   BACKDROP  │  │ Long Name      │ │
│    │    IMAGE    │  ├────────────────┤ │
│    │             │  │ "Tagline here" │ │
│    │             │  ├────────────────┤ │
│    │             │  │ ⭐ 8.5 (12.5K) │ │
│    │             │  │ 📅 2024        │ │
│    │             │  │ ⏱ 2h 15m      │ │
│    └─────────────┘  └────────────────┘ │
│                                         │
│  ┌────────┐ ┌────────┐ ┌────────┐     │
│  │Action  │ │Adventure│ │ Sci-Fi │ ... │ ← Genre chips
│  └────────┘ └────────┘ └────────┘     │
│                                         │
│  ┌─────────────────────────────┐       │
│  │  [+ Add to Watchlist    ▶] │       │ ← Add to Watchlist button
│  └─────────────────────────────┘       │
│  ┌─────────────────────────────┐       │
│  │  [▶ Play Trailer         ] │       │ ← Trailer button
│  └─────────────────────────────┘       │
│                                         │
│  ─────────── OVERVIEW ───────────      │
│                                         │
│  Lorem ipsum dolor sit amet,            │
│  consectetur adipiscing elit.          │
│  Sed do eiusmod tempor incididunt...   │
│                                         │
│  ─────────── CAST ───────────          │
│                                         │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │ 👤 │ │ 👤 │ │ 👤 │ │ 👤 │          │
│  │Name│ │Name│ │Name│ │Name│          │
│  │Role│ │Role│ │Role│ │Role│          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
│  ───────── SIMILAR MOVIES ──────────  │
│                                         │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │🎬  │ │🎬  │ │🎬  │ │🎬  │          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
└─────────────────────────────────────────┘
```

**Elements:**
- Backdrop image with gradient overlay
- Poster thumbnail
- Movie title, tagline, rating, release date, runtime
- Genre chips
- Watchlist button with dropdown
- Trailer button
- Overview text
- Cast horizontal list
- Similar movies horizontal list

---

## Screen 5: Search Screen

```
┌─────────────────────────────────────────┐
│        Search Movies...             ✕    │ ← Search bar
├─────────────────────────────────────────┤
│                                         │
│  ┌────────┐ ┌────────┐ ┌────────┐     │
│  │  All   │ │ Action │ │Comedy  │ ... │ ← Genre filter chips
│  └────────┘ └────────┘ └────────┘     │
│                                         │
│  Recent Searches:                        │
│  ┌───────────────────────────────────┐  │
│  │ 🕐  Avengers            ✕        │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │ 🕐  Spider-Man          ✕        │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │ 🕐  Batman               ✕        │  │
│  └───────────────────────────────────┘  │
│                                         │
│           [ Clear All ]                  │
│                                         │
└─────────────────────────────────────────┘

RESULTS VIEW:
┌─────────────────────────────────────────┐
│        Search Movies...             ✕    │
├─────────────────────────────────────────┤
│  Found 25 results for "Avengers"        │
│                                         │
│  ┌────────┐ ┌────────┐ ┌────────┐     │
│  │        │ │        │ │        │     │
│  │  🎬    │ │  🎬    │ │  🎬    │     │
│  │        │ │        │ │        │     │
│  ├────────┤ ├────────┤ ├────────┤     │
│  │⭐ 8.5  │ │⭐ 7.8  │ │⭐ 8.0  │     │
│  │Title   │ │Title   │ │Title   │     │
│  │2024    │ │2023    │ │2022    │     │
│  └────────┘ └────────┘ └────────┘     │
│                                         │
│  ┌────────┐ ┌────────┐ ┌────────┐     │
│  │        │ │        │ │        │     │
│  │  🎬    │ │  🎬    │ │  🎬    │     │
│  │        │ │        │ │        │     │
│  ├────────┤ ├────────┤ ├────────┤     │
│  │⭐ 8.5  │ │⭐ 7.8  │ │⭐ 8.0  │     │
│  │Title   │ │Title   │ │Title   │     │
│  │2024    │ │2023    │ │2022    │     │
│  └────────┘ └────────┘ └────────┘     │
│                                         │
├─────────────────────────────────────────┤
│   🏠      🔍      📚      👤          │
└─────────────────────────────────────────┘
```

**Elements:**
- Search input with clear button
- Genre filter chips (horizontal scroll)
- Search history list (when empty)
- Results grid (when searching)
- Result count header

---

## Screen 6: Watchlist Screen

```
┌─────────────────────────────────────────┐
│            My Watchlist                  │
├─────────────────────────────────────────┤
│                                         │
│  [All] [Plan to Watch] [Watching] [✓]  │ ← Filter tabs
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ 🎬 │ Title of the Movie           │  │
│  │    │ 📺 Plan to Watch  ❤️          │  │
│  │    │ ⭐ 8.5                       │  │
│  │    │                        ⋮     │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ 🎬 │ Title of the Movie           │  │
│  │    │ ▶️ Still Watching    💜       │  │
│  │    │ ⭐ 7.8                       │  │
│  │    │                        ⋮     │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ 🎬 │ Title of the Movie           │  │
│  │    │ ✅ Watched           💜       │  │
│  │    │ ⭐ 9.1                       │  │
│  │    │                        ⋮     │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ← Swipe to delete                     │
│                                         │
├─────────────────────────────────────────┤
│   🏠      🔍      📚      👤          │
└─────────────────────────────────────────┘
```

**Elements:**
- Filter tabs (All, Plan to Watch, Watching, Watched)
- Movie list items with:
  - Poster thumbnail
  - Title
  - Status chip with icon
  - Favorite heart icon
  - Rating
  - Menu button (⋮)
- Swipe to delete indicator

---

## Screen 7: Profile Screen

```
┌─────────────────────────────────────────┐
│                                     ⚙️   │ ← Settings button
├─────────────────────────────────────────┤
│                                         │
│                 ┌─────┐                 │
│                 │  👤  │   ← Avatar   │
│                 │      │               │
│                 └─────┘                 │
│                                         │
│               John Doe                  │
│           john.doe@email.com            │
│                                         │
│  ┌────────┐ ┌────────┐ ┌────────┐      │
│  │   12   │ │   5    │ │   28   │      │
│  │ Plan   │ │Watch  │ │Watched │      │
│  └────────┘ └────────┘ └────────┘      │
│              ┌────────┐                │
│              │   8    │                │
│              │Favorits│                │
│              └────────┘                │
│                                         │
│  ─────────── ACCOUNT ───────────       │
│  ┌───────────────────────────────────┐  │
│  │ 👤  Edit Profile              ›  │  │
│  ├───────────────────────────────────┤  │
│  │ 🔒  Change Password          ›  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ─────── PREFERENCES ──────────        │
│  ┌───────────────────────────────────┐  │
│  │ 🔔  Notifications            [ON]│  │
│  ├───────────────────────────────────┤  │
│  │ 🌐  Language: English        ›  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ─────────── SUPPORT ───────────       │
│  ┌───────────────────────────────────┐  │
│  │ ❓  Help & FAQ                 ›  │  │
│  ├───────────────────────────────────┤  │
│  │ ℹ️  About                      ›  │  │
│  └───────────────────────────────────┘  │
│                                         │
│         ┌───────────────────┐           │
│         │   🚪  Sign Out     │           │
│         └───────────────────┘           │
│                                         │
├─────────────────────────────────────────┤
│   🏠      🔍      📚      👤          │
└─────────────────────────────────────────┘
```

**Elements:**
- Settings gear icon (top right)
- Avatar with edit overlay
- User name and email
- Statistics cards (Plan, Watching, Watched, Favorites)
- Account section (Edit Profile, Change Password)
- Preferences section (Notifications toggle, Language)
- Support section (Help, About)
- Sign out button (red)
- Bottom navigation

---

## Screen 8: Add to Watchlist Modal

```
┌─────────────────────────────────────────┐
│                                         │
│         Add to Watchlist                │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  📋  Plan to Watch                │  │
│  │      Movies you want to see        │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  ▶️  Still Watching               │  │
│  │      Currently watching             │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  ✅  Watched                       │  │
│  │      Movies you've completed       │  │
│  └───────────────────────────────────┘  │
│                                         │
│              [ Cancel ]                 │
│                                         │
└─────────────────────────────────────────┘
```

---

## Responsive Design Breakpoints

```
Mobile (< 600px)     : 2 columns in grid
Tablet (600-900px)    : 3-4 columns in grid
Desktop (> 900px)    : 4-6 columns in grid
```

---

## Spacing System (8px Grid)

```
xs  : 4px   - Tight spacing
sm  : 8px   - Compact elements
md  : 16px  - Default spacing
lg  : 24px  - Section spacing
xl  : 32px  - Large gaps
xxl : 48px  - Screen margins
```

---

*Wireframes created: March 2026*
