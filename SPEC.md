# Movie Watchlist App - Specification Document

## 1. Project Overview

**Project Name:** CineWatch  
**Type:** Cross-platform Flutter Application (Android, iOS, Web)  
**Core Functionality:** A feature-rich movie discovery and watchlist management app that allows users to browse movies from TMDB API, save them to personalized watchlists with status tracking, search and filter content, and enjoy a premium dark-themed experience.

## 2. Technology Stack & Choices

### Framework & Language
- **Framework:** Flutter 3.41.4
- **Language:** Dart 3.11.1
- **Minimum SDK:** Android 21 / iOS 12 / Web (latest)

### Key Libraries/Dependencies
| Category | Package | Version | Purpose |
|----------|---------|---------|---------|
| State Management | flutter_riverpod | ^2.5.1 | Riverpod state management |
| HTTP Client | dio | ^5.4.0 | API requests to TMDB |
| Local Storage | hive_flutter | ^1.1.0 | Offline data persistence |
| Navigation | go_router | ^14.0.0 | Declarative routing |
| Image Caching | cached_network_image | ^3.3.1 | Efficient image loading |
| Animations | flutter_staggered_animations | ^1.1.1 | List animations |
| Shimmer | shimmer | ^3.0.0 | Loading skeleton effects |
| YouTube Player | youtube_player_flutter | ^9.0.3 | Trailer playback |
| URL Launcher | url_launcher | ^6.2.4 | External links |
| Connectivity | connectivity_plus | ^6.0.3 | Network status |
| Shared Preferences | shared_preferences | ^2.2.2 | Simple key-value storage |
| Intl | intl | ^0.19.0 | Date formatting |
| Equatable | equatable | ^2.0.5 | Value equality |
| Json Serialization | json_annotation + json_serializable | ^4.8.1 | JSON parsing |
| Build Runner | build_runner | ^2.4.8 | Code generation |

### State Management Approach
- **Riverpod** with AsyncNotifier for async operations
- Providers organized by feature modules
- StateNotifier for complex state mutations
- Family providers for parameterized data

### Architecture Pattern
- **Clean Architecture** with 3 layers:
  - **Data Layer:** API clients, repositories implementation, local data sources
  - **Domain Layer:** Entities, repository interfaces, use cases
  - **Presentation Layer:** Screens, widgets, Riverpod providers

## 3. Feature List

### Movie Discovery
- [x] Trending movies carousel on home screen
- [x] Popular movies horizontal list
- [x] Top Rated movies section
- [x] Now Playing movies for current time context
- [x] Upcoming movies preview
- [x] Movie details page with full information
- [x] Cast and crew information
- [x] Similar movie recommendations
- [x] Genre-based movie browsing

### Watchlist System
- [x] Add/remove movies from watchlist
- [x] Status management: Watching, Completed, Plan to Watch
- [x] Local persistence with Hive
- [x] Watchlist filtering by status
- [x] Watched date tracking
- [x] Personal rating system (1-10 stars)
- [x] Favorite marking

### Search & Discovery
- [x] Real-time movie search with debounce (500ms)
- [x] Search history (last 10 searches)
- [x] Filter by genre (multi-select)
- [x] Filter by rating range
- [x] Filter by release year range
- [x] Sort options (popularity, rating, date)

### User Experience
- [x] Infinite scroll pagination
- [x] Pull-to-refresh on lists
- [x] Skeleton loading states
- [x] Hero animations for posters
- [x] Smooth page transitions
- [x] Error state handling with retry
- [x] Offline mode with cached data

### Settings & Profile
- [x] Dark/Light theme toggle
- [x] Clear cache option
- [x] App version display
- [x] TMDB attribution
- [x] Default sort preference
- [x] Grid/List view toggle

### Advanced Features
- [x] YouTube trailer integration
- [x] Share movie details
- [x] Movie rating display
- [x] Release date information
- [x] Genre tags display

## 4. UI/UX Design Direction

### Overall Visual Style
- **Primary Theme:** Dark mode with Netflix/IMDb inspiration
- **Design System:** Material Design 3 with custom theming
- **Visual Elements:**
  - Rounded corners (16dp radius for cards)
  - Subtle elevation with colored shadows
  - Glassmorphism effects on overlays
  - Gradient overlays on movie posters

### Color Scheme
| Element | Dark Theme | Light Theme |
|---------|------------|-------------|
| Background | #0D0D0D | #F5F5F5 |
| Surface | #1A1A1A | #FFFFFF |
| Primary | #E50914 (Netflix Red) | #E50914 |
| Secondary | #FFD700 (IMDb Gold) | #FFD700 |
| Text Primary | #FFFFFF | #1A1A1A |
| Text Secondary | #B3B3B3 | #666666 |
| Accent | #00A8E1 | #00A8E1 |

### Layout Approach
- **Navigation:** Bottom navigation bar with 4 tabs
  - Home (Discovery)
  - Search
  - Watchlist
  - Settings
- **Responsive:** 
  - Mobile: Single column, bottom nav
  - Tablet: 2-3 columns, expanded nav
  - Web: Max width 1200px, side navigation option

### Screen Structure
1. **Splash Screen:** Animated logo, app initialization
2. **Home Screen:** 
   - Trending carousel (auto-scroll)
   - Section headers with "See All" actions
   - Horizontal scrollable movie lists
   - Vertical scroll composition
3. **Movie Details Screen:**
   - Hero backdrop with gradient
   - Poster, title, rating prominently displayed
   - Action buttons (Add to Watchlist, Watch Trailer, Share)
   - Tab sections: Overview, Cast, Similar
4. **Search Screen:**
   - Sticky search bar
   - Filter chips row
   - Results grid (2-3 columns)
   - Empty state illustrations
5. **Watchlist Screen:**
   - Segmented control for status
   - Grid/List view toggle
   - Swipe actions for quick status change
   - Drag-to-reorder support
6. **Settings Screen:**
   - Grouped settings list
   - Theme toggle switch
   - Cache management
   - About section

### Animation Specifications
- **Page Transitions:** 300ms fade + slide
- **Hero Animation:** Shared element transition for posters
- **List Loading:** Staggered fade-in (50ms delay per item)
- **Card Press:** Scale down to 0.98 with 100ms duration
- **Button Tap:** Ripple effect with primary color
- **Carousel:** Auto-scroll every 5 seconds with smooth interpolation

## 5. API Integration

### TMDB API Endpoints
- `GET /trending/movie/week` - Trending movies
- `GET /movie/popular` - Popular movies
- `GET /movie/top_rated` - Top rated movies
- `GET /movie/now_playing` - Now playing
- `GET /movie/upcoming` - Upcoming releases
- `GET /movie/{id}` - Movie details
- `GET /movie/{id}/credits` - Cast and crew
- `GET /movie/{id}/similar` - Similar movies
- `GET /search/movie` - Search movies
- `GET /genre/movie/list` - Genre list

### Image Base URLs
- Poster: `https://image.tmdb.org/t/p/w500`
- Backdrop: `https://image.tmdb.org/t/p/w1280`
- Profile: `https://image.tmdb.org/t/p/w185`

## 6. Data Models

### Movie Entity
```
- id: int
- title: String
- originalTitle: String
- overview: String
- posterPath: String?
- backdropPath: String?
- releaseDate: String
- voteAverage: double
- voteCount: int
- popularity: double
- genreIds: List<int>
- adult: bool
```

### Watchlist Item
```
- movieId: int
- movie: Movie
- status: WatchlistStatus (watching/completed/planToWatch)
- userRating: double?
- isFavorite: bool
- addedAt: DateTime
- updatedAt: DateTime
- watchedAt: DateTime?
```

### User Preferences
```
- themeMode: ThemeMode
- defaultSort: SortOption
- viewMode: ViewMode (grid/list)
- lastCacheClear: DateTime?
```

## 7. Local Storage Schema

### Hive Boxes
- `movies` - Cached movie data
- `watchlist` - User watchlist items
- `searchHistory` - Recent searches
- `preferences` - App settings

## 8. Error Handling

### Network Errors
- Show cached data when offline
- Display retry button with error message
- Automatic retry with exponential backoff

### API Errors
- Handle 401 (invalid API key) with setup prompt
- Handle 404 with "not found" state
- Handle 429 (rate limit) with cooldown message
- Generic errors show user-friendly message

## 9. Performance Considerations

- Lazy loading for images
- Pagination with 20 items per page
- Cache expiration: 24 hours for movie data
- Memory-efficient image caching
- Debounced search to reduce API calls
