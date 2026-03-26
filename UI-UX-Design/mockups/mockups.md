# CineWatch - High-Fidelity Mockups & Design Specs

## Design System Overview

---

## 1. Color Palette

### Primary Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Netflix Red** | `#E50914` | 229, 9, 20 | Primary buttons, CTAs, highlights |
| **Deep Red** | `#B20710` | 178, 7, 16 | Pressed states, accents |

### Secondary Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Gold Star** | `#FFD700` | 255, 215, 0 | Ratings, favorites |
| **Accent Blue** | `#00A8E1` | 0, 168, 225 | Links, secondary actions |

### Neutral Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Dark Background** | `#0D0D0D` | 13, 13, 13 | Main background |
| **Dark Surface** | `#1A1A1A` | 26, 26, 26 | Cards, containers |
| **Dark Card** | `#252525` | 37, 37, 37 | Elevated surfaces |
| **Dark Border** | `#333333` | 51, 51, 51 | Dividers, borders |

### Semantic Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Success Green** | `#4CAF50` | 76, 175, 80 | Watched status, success |
| **Warning Orange** | `#FF9800` | 255, 152, 0 | Plan to Watch, warnings |
| **Info Blue** | `#2196F3` | 33, 150, 243 | Still Watching, info |
| **Error Red** | `#F44336` | 244, 67, 54 | Errors, delete actions |
| **Favorite Pink** | `#E91E63` | 233, 30, 99 | Favorite icon filled |

---

## 2. Typography

### Font Family
- **Primary Font**: System Default (San Francisco on iOS, Roboto on Android)
- **Fallback**: `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`

### Type Scale

| Style | Size | Weight | Line Height | Letter Spacing | Usage |
|-------|------|--------|-------------|----------------|-------|
| `displayLarge` | 32px | Bold (700) | 1.2 | 0 | Hero titles |
| `displayMedium` | 28px | Bold (700) | 1.2 | 0 | Screen titles |
| `displaySmall` | 24px | Bold (700) | 1.3 | 0 | Section headers |
| `headlineMedium` | 20px | SemiBold (600) | 1.4 | 0 | Card titles |
| `titleLarge` | 18px | SemiBold (600) | 1.4 | 0 | List item titles |
| `titleMedium` | 16px | Medium (500) | 1.4 | 0 | Subtitles |
| `bodyLarge` | 16px | Regular (400) | 1.5 | 0.5 | Body text |
| `bodyMedium` | 14px | Regular (400) | 1.5 | 0.25 | Secondary text |
| `bodySmall` | 12px | Regular (400) | 1.4 | 0.4 | Captions |
| `labelLarge` | 14px | Medium (500) | 1.4 | 0.1 | Buttons |

### Color Mapping

| Style | Light Mode | Dark Mode |
|-------|------------|-----------|
| Primary Text | `#000000` | `#FFFFFF` |
| Secondary Text | `#666666` | `#B3B3B3` |
| Tertiary Text | `#999999` | `#808080` |
| Disabled | `#CCCCCC` | `#666666` |

---

## 3. Spacing System

### 8-Point Grid System

```
Base Unit: 8px

xs  : 4px   (0.5 units)  - Tight spacing, icon gaps
sm  : 8px   (1 unit)      - Compact elements
md  : 16px  (2 units)     - Default padding
lg  : 24px  (3 units)     - Section spacing
xl  : 32px  (4 units)     - Large gaps
xxl : 48px  (6 units)     - Screen margins
```

### Component Spacing

| Component | Padding | Margin |
|-----------|--------|--------|
| Screen Container | 16px | - |
| Card | 16px | 8px |
| List Item | 16px horizontal, 12px vertical | 8px |
| Button | 16px horizontal, 12px vertical | 8px |
| Input Field | 16px | 8px |
| Section Gap | - | 24px |

---

## 4. Border Radius

### Standard Radii

| Name | Value | Usage |
|------|-------|-------|
| `none` | 0px | Flat elements |
| `sm` | 4px | Small chips |
| `md` | 8px | Buttons, inputs |
| `lg` | 12px | Cards |
| `xl` | 16px | Large cards |
| `xxl` | 24px | Modals |
| `full` | 9999px | Circular elements |

### Component Mapping

| Component | Border Radius |
|-----------|--------------|
| Buttons | 12px (`lg`) |
| Input Fields | 12px (`lg`) |
| Cards | 16px (`xl`) |
| Movie Posters | 16px (`xl`) |
| Chips/Tags | 20px (`full`) |
| Avatars | 50% (`full`) |
| Bottom Sheet | 20px top (`xxl`) |

---

## 5. Shadows & Elevation

### Dark Mode Shadows

| Level | Shadow | Usage |
|-------|--------|-------|
| 0 | none | Flat surfaces |
| 1 | `0 2px 4px rgba(0,0,0,0.3)` | Cards at rest |
| 2 | `0 4px 8px rgba(0,0,0,0.4)` | Floating cards |
| 3 | `0 8px 16px rgba(0,0,0,0.5)` | Modals, dialogs |

---

## 6. Component Specifications

### Movie Card

```
┌─────────────────────┐
│  ┌───────────────┐  │
│  │               │  │
│  │   POSTER     │  │  ← Rounded corners (16px)
│  │   IMAGE       │  │
│  │   (2:3)      │  │
│  │               │  │
│  └───────────────┘  │
│                     │
│  ┌─────────────┐    │  ← Rating badge (top-left)
│  │ ⭐ 8.5      │    │    Absolute positioned
│  └─────────────┘    │
│                     │
│  Movie Title...     │  ← Max 2 lines, ellipsis
│  2024               │  ← Release year
│                     │
└─────────────────────┘

Dimensions:
- Width: 140px (mobile), 160px (tablet)
- Height: 280px (mobile), 320px (tablet)
- Poster Aspect Ratio: 2:3
- Shadow: Level 1
```

### Status Chip

```
┌─────────────────┐
│  ⏱ Plan to Watch  │  ← Icon + Text
└─────────────────┘

Variants:
- Plan to Watch: Orange (#FF9800), clock icon
- Still Watching: Blue (#2196F3), play icon
- Watched: Green (#4CAF50), check icon

Styling:
- Background: color.withOpacity(0.2)
- Text: color (solid)
- Border Radius: 20px (pill)
- Padding: 8px horizontal, 4px vertical
```

### Bottom Navigation Bar

```
┌─────────────────────────────────────────┐
│   🏠        🔍        📚        👤     │
│  Home     Search   Watchlist   Profile  │
│   ──        ○         ○         ○      │  ← Selected indicator
└─────────────────────────────────────────┘

Styling:
- Height: 80px (includes safe area)
- Background: Dark Surface (#1A1A1A)
- Icon Size: 24px
- Label Size: 12px
- Selected: Primary Red (#E50914)
- Unselected: Grey (#808080)
```

### App Bar

```
┌─────────────────────────────────────────┐
│  ←    CineWatch              🔔  ⋮    │
└─────────────────────────────────────────┘

Styling:
- Height: 56px
- Background: Dark Background (#0D0D0D)
- Title: White, Bold, 24px
- Icons: 24px, White/Grey
```

---

## 7. Animation Specifications

### Duration Scale

| Speed | Duration | Usage |
|-------|----------|-------|
| `instant` | 0ms | Immediate feedback |
| `fast` | 150ms | Micro-interactions |
| `normal` | 300ms | Standard transitions |
| `slow` | 500ms | Large movements |
| `splash` | 1500ms | Splash screen animations |

### Easing Curves

| Name | Curve | Usage |
|------|-------|-------|
| `easeInOut` | `Curves.easeInOut` | Standard transitions |
| `easeOut` | `Curves.easeOut` | Enter animations |
| `easeIn` | `Curves.easeIn` | Exit animations |
| `elasticOut` | `Curves.elasticOut` | Bounce effects |

### Specific Animations

| Animation | Duration | Curve | Trigger |
|-----------|----------|-------|---------|
| Page Transition | 300ms | easeInOut | Navigation |
| Hero Animation | 300ms | easeOut | Movie tap |
| Button Press | 150ms | easeIn | Tap down |
| Like Toggle | 300ms | elasticOut | Heart tap |
| Tab Switch | 200ms | easeInOut | Tab tap |
| Card Appear | 375ms | easeOut | List scroll |

---

## 8. Responsive Breakpoints

### Screen Width

| Breakpoint | Width | Columns | Card Width |
|------------|-------|---------|------------|
| Mobile S | < 360px | 2 | 130px |
| Mobile L | 360-599px | 2 | 140px |
| Tablet | 600-899px | 3 | 160px |
| Desktop S | 900-1199px | 4 | 180px |
| Desktop L | 1200px+ | 5-6 | 200px |

### Grid Layout

```
Mobile (<600px):
┌────┬────┐
│ 1  │ 2  │
├────┴────┤

Tablet (600-900px):
┌────┬────┬────┐
│ 1  │ 2  │ 3  │
├────┴────┴────┤

Desktop (>900px):
┌────┬────┬────┬────┐
│ 1  │ 2  │ 3  │ 4  │
├────┴────┴────┴────┤
```

---

## 9. Screen Mockups (Design Descriptions)

### 9.1 Splash Screen

```
┌─────────────────────────────────────────┐
│                                         │
│   Gradient Background                    │
│   (Primary Red → Dark Background)       │
│                                         │
│              ┌───────────┐              │
│              │           │              │
│              │  🎬  🎬   │  ← Glow     │
│              │   Movie    │    Effect    │
│              │   Filter  │              │
│              │           │              │
│              └───────────┘              │
│                                         │
│                CineWatch                │
│           (White, Bold, 36px)           │
│                                         │
│      Discover • Watch • Track           │
│         (Grey, Regular, 14px)           │
│                                         │
│              ████████░░░░░              │
│               Loading...                 │
│                                         │
└─────────────────────────────────────────┘

Animation:
1. Logo fades in (0-500ms)
2. Logo scales up with bounce (0-800ms)
3. Title fades in (400-800ms)
4. Progress bar animates (0-2000ms)
```

### 9.2 Home Screen

```
┌─────────────────────────────────────────┐
│ ☰        CineWatch              🔔      │  ← AppBar
├─────────────────────────────────────────┤
│                                         │
│  TRENDING NOW              [See All]    │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐     │
│  │     │ │     │ │     │ │     │     │
│  │ 🎬  │ │ 🎬  │ │ 🎬  │ │ 🎬  │     │  ← Horizontal
│  │     │ │     │ │     │ │     │     │    Scroll
│  ├─────┤ ├─────┤ ├─────┤ ├─────┤     │
│  │⭐8.5│ │⭐7.2│ │⭐9.1│ │⭐6.8│     │
│  └─────┘ └─────┘ └─────┘ └─────┘     │
│                                         │
│  POPULAR                   [See All]    │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐     │
│  │     │ │     │ │     │ │     │     │
│  │ 🎬  │ │ 🎬  │ │ 🎬  │ │ 🎬  │     │
│  │     │ │     │ │     │ │     │     │
│  ├─────┤ ├─────┤ ├─────┤ ├─────┤     │
│  │⭐8.5│ │⭐7.2│ │⭐9.1│ │⭐6.8│     │
│  └─────┘ └─────┘ └─────┘ └─────┘     │
│                                         │
│  TOP RATED                 [See All]    │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐     │
│  │     │ │     │ │     │ │     │     │
│  │ 🎬  │ │ 🎬  │ │ 🎬  │ │ 🎬  │     │
│  │     │ │     │ │     │ │     │     │
│  ├─────┤ ├─────┤ ├─────┤ ├─────┤     │
│  │⭐8.5│ │⭐7.2│ │⭐9.1│ │⭐6.8│     │
│  └─────┘ └─────┘ └─────┘ └─────┘     │
│                                         │
├─────────────────────────────────────────┤
│    🏠       🔍       📚       👤       │
└─────────────────────────────────────────┘
```

### 9.3 Movie Details Screen

```
┌─────────────────────────────────────────┐
│ ←                              ❤️   ⋮   │
├─────────────────────────────────────────┤
│ ┌─────────────────────────────────────┐ │
│ │                                     │ │
│ │                                     │ │
│ │          BACKDROP IMAGE             │ │  ← Collapsing
│ │          (with gradient)             │ │    AppBar
│ │                                     │ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│  ┌──────┐  Movie Title                 │
│  │      │  Long Name Here              │
│  │POSTER│  "Your tagline goes here"   │
│  │ 2:3  │                              │
│  │      │  ⭐ 8.5    12,500 votes     │
│  └──────┘  📅 2024    ⏱ 2h 15m       │
│                                         │
│  [Action] [Adventure] [Sci-Fi] ...     │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [+ Add to Watchlist]    ▼      │   │  ← Dropdown
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │    [▶ Play Trailer]             │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────────── OVERVIEW ──────────────    │
│                                         │
│  Lorem ipsum dolor sit amet,             │
│  consectetur adipiscing elit...          │
│                                         │
│  ─────────── CAST ──────────────────    │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │ 👤 │ │ 👤 │ │ 👤 │ │ 👤 │          │
│  │Name│ │Name│ │Name│ │Name│          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
│  ─────── SIMILAR MOVIES ────────────    │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │ 🎬 │ │ 🎬 │ │ 🎬 │ │ 🎬 │          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
└─────────────────────────────────────────┘
```

### 9.4 Watchlist Screen

```
┌─────────────────────────────────────────┐
│              My Watchlist                │
├─────────────────────────────────────────┤
│                                         │
│  [All] [Plan to Watch] [Watching] [✓]  │  ← Tab pills
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🎬 │ Title of the Movie         │   │
│  │    │                            │   │
│  │ 2:3 │ 📺 Plan to Watch  ❤️     │   │  ← Status + Heart
│  │    │ ⭐ 8.5                    │   │
│  │    │                       ⋮   │   │  ← Menu
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🎬 │ Title of the Movie         │   │
│  │    │                            │   │
│  │ 2:3 │ ▶️ Still Watching  💜    │   │
│  │    │ ⭐ 7.8                    │   │
│  │    │                       ⋮   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ← Swipe left to delete                 │
│                                         │
├─────────────────────────────────────────┤
│    🏠       🔍       📚       👤       │
└─────────────────────────────────────────┘

Menu Options (⋮):
┌─────────────────┐
│ 📋 Plan to Watch│  ← Current: highlighted
├─────────────────┤
│ ▶️ Still Watching│
├─────────────────┤
│ ✅ Watched       │
├─────────────────┤
│ ❤️ Favorite      │
├─────────────────┤
│ 🗑️ Remove       │
└─────────────────┘
```

### 9.5 Profile Screen

```
┌─────────────────────────────────────────┐
│                                     ⚙️  │
├─────────────────────────────────────────┤
│                                         │
│              ┌─────────┐               │
│              │         │               │
│              │    👤    │  ← Editable │
│              │         │               │
│              └─────────┘               │
│                                         │
│              John Doe                   │
│          john.doe@email.com             │
│                                         │
│  ┌───────┐ ┌───────┐ ┌───────┐ ┌───┐ │
│  │  12   │ │   5   │ │  28   │ │ 8 │ │
│  │ Plan  │ │Watch  │ │Watched│ │Fav│ │
│  │orange │ │ blue  │ │ green │ │red│ │
│  └───────┘ └───────┘ └───────┘ └───┘ │
│                                         │
│  ─────────── ACCOUNT ──────────────     │
│  ┌─────────────────────────────────┐   │
│  │ 👤  Edit Profile                │   │
│  ├─────────────────────────────────┤   │
│  │ 🔒  Change Password             │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ───────── PREFERENCES ────────────     │
│  ┌─────────────────────────────────┐   │
│  │ 🔔  Notifications     [SWITCH]  │   │
│  ├─────────────────────────────────┤   │
│  │ 🌐  Language: English           │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │         🚪  Sign Out            │   │  ← Red
│  └─────────────────────────────────┘   │
│                                         │
├─────────────────────────────────────────┤
│    🏠       🔍       📚       👤       │
└─────────────────────────────────────────┘
```

---

## 10. Iconography

### Icon Library
- **Primary**: Material Icons (Outlined style)
- **Size Standard**: 24px
- **Navigation Icons**: 24px
- **Action Icons**: 24px
- **Status Icons**: 16-20px

### Icon Colors
| State | Color |
|-------|-------|
| Default | `#808080` |
| Active/Selected | `#E50914` (Primary) |
| Disabled | `#666666` |
| On Primary | `#FFFFFF` |

### Key Icons

| Purpose | Icon | Style |
|---------|------|-------|
| Home | `home` | Outlined/Filled |
| Search | `search` | Outlined/Filled |
| Watchlist | `bookmark` | Outlined/Filled |
| Profile | `person` | Outlined/Filled |
| Back | `arrow_back` | Filled |
| Menu | `menu` | Filled |
| More | `more_vert` | Filled |
| Favorite | `favorite/favorite_border` | Filled/Outlined |
| Rating | `star/star_border` | Filled/Outlined |
| Play | `play_circle` | Filled |
| Settings | `settings` | Outlined |
| Notifications | `notifications` | Outlined |

---

## 11. Error States

### Empty States

| Screen | Icon | Title | Subtitle |
|--------|------|-------|----------|
| Watchlist | `bookmark_outline` | "Your watchlist is empty" | "Add movies to track what you want to watch" |
| Search (No Results) | `search_off` | "No results found" | "Try searching with different keywords" |
| Favorites | `favorite_outline` | "No favorites yet" | "Tap the heart icon to add favorites" |

### Error States

| State | Icon | Color | Action |
|-------|------|-------|--------|
| Network Error | `wifi_off` | Orange | "Retry" button |
| Server Error | `error_outline` | Red | "Try again" button |
| API Error | `cloud_off` | Grey | "Refresh" button |

---

*Mockups and Design Specs created: March 2026*
