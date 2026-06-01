# CineWatch - Test Cases

## Authentication

### TC-AUTH-01: User Registration
- **Steps**: Navigate to Register screen, enter email/password, tap Register
- **Expected**: Account created, redirected to home
- **Status**: ✅ Pass

### TC-AUTH-02: User Login
- **Steps**: Enter registered email/password, tap Login
- **Expected**: Redirected to home, watchlist loaded
- **Status**: ✅ Pass

### TC-AUTH-03: Invalid Login
- **Steps**: Enter wrong email/password combination
- **Expected**: Error message displayed, not redirected
- **Status**: ✅ Pass

### TC-AUTH-04: Forgot Password
- **Steps**: Tap "Forgot Password?", enter email, tap Send
- **Expected**: Password reset email sent, success feedback
- **Status**: ✅ Pass

### TC-AUTH-05: Delete Account
- **Steps**: Profile → Delete Account → Confirm
- **Expected**: Account deleted, redirected to login
- **Status**: ✅ Pass

### TC-AUTH-06: Logout
- **Steps**: Profile → Sign Out
- **Expected**: Redirected to login, watchlist cleared
- **Status**: ✅ Pass

## Movie Discovery

### TC-MOVIE-01: Home Screen Load
- **Steps**: Navigate to home
- **Expected**: Trending carousel + categorized lists (Popular, Top Rated, Now Playing, Upcoming) loaded with poster images
- **Status**: ✅ Pass

### TC-MOVIE-02: Movie Details
- **Steps**: Tap any movie poster/card
- **Expected**: Details screen with poster, title, rating, overview, cast, similar movies, trailer button
- **Status**: ✅ Pass

### TC-MOVIE-03: YouTube Trailer
- **Steps**: Tap Play Trailer on movie details
- **Expected**: Bottom sheet with YouTube player, auto-play, proper dispose on close
- **Status**: ✅ Pass

### TC-MOVIE-04: Search Movies
- **Steps**: Go to Search, type movie name
- **Expected**: Results appear with debounce, posters load
- **Status**: ✅ Pass

### TC-MOVIE-05: Genre Filter
- **Steps**: In Search, tap a genre chip
- **Expected**: Results filtered by selected genre
- **Status**: ✅ Pass

## Watchlist

### TC-WL-01: Add to Watchlist
- **Steps**: On movie details, tap Add to Watchlist
- **Expected**: Movie appears in watchlist with Plan to Watch status
- **Status**: ✅ Pass

### TC-WL-02: Change Watchlist Status
- **Steps**: In watchlist, change status from Plan to Watch → Still Watching → Watched
- **Expected**: Status updates immediately, synced to Firebase
- **Status**: ✅ Pass

### TC-WL-03: Remove from Watchlist
- **Steps**: Swipe to delete or tap remove on watchlist item
- **Expected**: Movie removed from watchlist, synced to Firebase
- **Status**: ✅ Pass

### TC-WL-04: Favorites Toggle
- **Steps**: Toggle favorite star on any watchlist item
- **Expected**: Heart icon updates, synced to Firebase
- **Status**: ✅ Pass

### TC-WL-05: Watchlist Persistence
- **Steps**: Add movies, logout, login again
- **Expected**: Watchlist restored from Firebase
- **Status**: ✅ Pass

### TC-WL-06: Cross-Device Sync
- **Steps**: Add movie on device A, refresh on device B
- **Expected**: Movie appears on device B via Firestore stream
- **Status**: ✅ Pass

## Profile & Settings

### TC-PROF-01: Profile Display
- **Steps**: Navigate to Profile
- **Expected**: Avatar, email, stats grid (Plan/Watching/Watched/Favorites), settings groups visible
- **Status**: ✅ Pass

### TC-PROF-02: Dark/Light Mode Toggle
- **Steps**: Profile → Appearance → toggle Dark Mode
- **Expected**: Theme switches, preference persisted
- **Status**: ✅ Pass

### TC-PROF-03: Language Switcher
- **Steps**: Profile → Language → select Arabic/English
- **Expected**: UI language changes, RTL support for Arabic
- **Status**: ✅ Pass

### TC-PROF-04: Clear Cache
- **Steps**: Profile → Clear Cache → Confirm
- **Expected**: Cache cleared, confirmation shown
- **Status**: ✅ Pass

## Onboarding

### TC-ONB-01: First Launch
- **Steps**: Fresh install, launch app
- **Expected**: Onboarding screen appears (3 pages), Skip/Next/Get Started buttons work
- **Status**: ✅ Pass

### TC-ONB-02: Onboarding Completion
- **Steps**: Complete or skip onboarding
- **Expected**: Onboarding not shown again
- **Status**: ✅ Pass

## Deep Links

### TC-DL-01: Movie Deep Link
- **Steps**: Open URL `cinewatch://movie/{id}`
- **Expected**: Movie details screen opens directly
- **Status**: ✅ Pass

## Notifications

### TC-NOTIF-01: Push Notification Permission
- **Steps**: Launch app (first time)
- **Expected**: Notification permission requested
- **Status**: ✅ Pass

## Responsive Design

### TC-RESP-01: Mobile Layout
- **Steps**: View on small screen (360px width)
- **Expected**: No overflow, all content visible, lists scroll properly
- **Status**: ✅ Pass

### TC-RESP-02: Tablet Layout
- **Steps**: View on tablet (768px+)
- **Expected**: Content uses wider space, grid adjusts
- **Status**: ✅ Pass

### TC-RESP-03: Web Layout
- **Steps**: View on desktop browser
- **Expected**: Content centered, navigation functional
- **Status**: ✅ Pass
