import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'CineWatch'**
  String get appName;

  /// Tagline shown on splash screen
  ///
  /// In en, this message translates to:
  /// **'Discover • Watch • Track'**
  String get appTagline;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Validation message when email is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmailValidation;

  /// Validation message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmailValidation;

  /// Validation message when password is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPasswordValidation;

  /// Validation message for short password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get minPasswordValidation;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Divider text between sign in options
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Text before sign up link
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Subtitle on login screen
  ///
  /// In en, this message translates to:
  /// **'Your Personal Movie Journal'**
  String get yourPersonalMovieJournal;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Validation when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Text before sign in link on register screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Search tab label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Watchlist tab label
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlist;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Trending movies section header
  ///
  /// In en, this message translates to:
  /// **'Trending This Week'**
  String get trendingThisWeek;

  /// Popular movies section header
  ///
  /// In en, this message translates to:
  /// **'Popular Movies'**
  String get popularMovies;

  /// Top rated movies section header
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// Now playing movies section header
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// Upcoming movies section header
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// See all button text
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Empty state for movie lists
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get noMoviesFound;

  /// Error state for movie loading
  ///
  /// In en, this message translates to:
  /// **'Failed to load movies'**
  String get failedToLoadMovies;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Watchlist screen title
  ///
  /// In en, this message translates to:
  /// **'My Watchlist'**
  String get myWatchlist;

  /// Filter option for all items
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Watchlist status label
  ///
  /// In en, this message translates to:
  /// **'Plan to Watch'**
  String get planToWatch;

  /// Watchlist status label for in-progress
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get stillWatching;

  /// Watchlist status label for completed
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get watched;

  /// Stats section header on profile
  ///
  /// In en, this message translates to:
  /// **'Your Stats'**
  String get yourStats;

  /// Short stat label for plan to watch
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// Short stat label for currently watching
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get watching;

  /// Favorites stat label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Quick action button
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// Edit profile option
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Edit profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your name and photo'**
  String get updateProfile;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Toggle enabled state
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Toggle disabled state
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// Save button for profile edit
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Success message after profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated!'**
  String get profileUpdated;

  /// Error message for profile update failure
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// Sign out confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureSignOut;

  /// Delete account button
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account confirmation warning
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all watchlist data. This action cannot be undone.'**
  String get deleteAccountWarning;

  /// Delete confirmation button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Default display name
  ///
  /// In en, this message translates to:
  /// **'Movie Lover'**
  String get movieLover;

  /// Welcome message on profile
  ///
  /// In en, this message translates to:
  /// **'Welcome to CineWatch'**
  String get welcomeToCineWatch;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Appearance section header in settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Notifications section header
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Push notifications toggle label
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Push notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive updates about new movies'**
  String get receiveMovieUpdates;

  /// Email notifications option
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// Email notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Weekly digest and recommendations'**
  String get weeklyDigest;

  /// Feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Content section header
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Language option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language label
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// Content rating option
  ///
  /// In en, this message translates to:
  /// **'Content Rating'**
  String get contentRating;

  /// Content rating option value
  ///
  /// In en, this message translates to:
  /// **'All ages'**
  String get allAges;

  /// Storage section header
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// Clear cache option
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// Clear cache subtitle
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get freeUpStorage;

  /// Clear cache dialog message
  ///
  /// In en, this message translates to:
  /// **'This will clear all cached data including movie images and search history. Your watchlist will not be affected.'**
  String get clearCacheConfirmation;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Success message after cache clear
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// About app option
  ///
  /// In en, this message translates to:
  /// **'About CineWatch'**
  String get aboutCineWatch;

  /// Privacy policy option
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'Learn how we handle your data'**
  String get learnHowWeHandleData;

  /// Terms of service option
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service subtitle
  ///
  /// In en, this message translates to:
  /// **'Read our terms'**
  String get readOurTerms;

  /// Open source licenses option
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// Open source licenses subtitle
  ///
  /// In en, this message translates to:
  /// **'Third-party libraries'**
  String get thirdPartyLibraries;

  /// Support section header
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Help option
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpAndFaq;

  /// Help subtitle
  ///
  /// In en, this message translates to:
  /// **'Get answers to common questions'**
  String get getAnswers;

  /// Feedback option
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// Feedback subtitle
  ///
  /// In en, this message translates to:
  /// **'Help us improve the app'**
  String get helpUsImprove;

  /// Auth error message
  ///
  /// In en, this message translates to:
  /// **'No user found with this email'**
  String get noUserFound;

  /// Auth error message
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// Auth error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// Auth error message
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get accountDisabled;

  /// Auth error message
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get emailAlreadyRegistered;

  /// Auth error message
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 6 characters'**
  String get weakPassword;

  /// Generic auth error
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// Prompt to enter email before forgot password
  ///
  /// In en, this message translates to:
  /// **'Enter your email first'**
  String get enterEmailFirst;

  /// Success message for password reset
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetSent;

  /// Error message for password reset
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email'**
  String get failedToSendReset;

  /// Reset password screen title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Reset password instruction
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get enterEmailForReset;

  /// After email sent message
  ///
  /// In en, this message translates to:
  /// **'Check your inbox for the reset link'**
  String get checkInboxForReset;

  /// Send reset link button
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// Success header after sending email
  ///
  /// In en, this message translates to:
  /// **'Email Sent!'**
  String get emailSent;

  /// Instructions after sending reset email
  ///
  /// In en, this message translates to:
  /// **'Check your email and follow the instructions to reset your password.'**
  String get checkEmailInstructions;

  /// Back to sign in button
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// Skip onboarding button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Onboarding page 1 title
  ///
  /// In en, this message translates to:
  /// **'Discover Movies'**
  String get discoverMovies;

  /// Onboarding page 1 description
  ///
  /// In en, this message translates to:
  /// **'Browse trending, popular, and top-rated movies. Find your next favorite film.'**
  String get discoverMoviesDesc;

  /// Onboarding page 2 title
  ///
  /// In en, this message translates to:
  /// **'Build Your Watchlist'**
  String get buildYourWatchlist;

  /// Onboarding page 2 description
  ///
  /// In en, this message translates to:
  /// **'Save movies to your watchlist, track your progress, and never lose track.'**
  String get buildYourWatchlistDesc;

  /// Onboarding page 3 title
  ///
  /// In en, this message translates to:
  /// **'Stay Updated'**
  String get stayUpdated;

  /// Onboarding page 3 description
  ///
  /// In en, this message translates to:
  /// **'Get notified about new releases and never miss a movie again.'**
  String get stayUpdatedDesc;

  /// Search hint text
  ///
  /// In en, this message translates to:
  /// **'Search movies...'**
  String get searchMovies;

  /// Recent searches header
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// Clear search history button
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// Empty search history
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get noRecentSearches;

  /// Browse genres header
  ///
  /// In en, this message translates to:
  /// **'Browse Genres'**
  String get browseGenres;

  /// Empty search results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// Empty search results suggestion
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentQuery;

  /// Add to watchlist button
  ///
  /// In en, this message translates to:
  /// **'Add to Watchlist'**
  String get addToWatchlist;

  /// Already in watchlist indicator
  ///
  /// In en, this message translates to:
  /// **'In Watchlist'**
  String get inWatchlist;

  /// Movie overview section
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Cast section
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// Similar movies section
  ///
  /// In en, this message translates to:
  /// **'Similar Movies'**
  String get similarMovies;

  /// Watch trailer button
  ///
  /// In en, this message translates to:
  /// **'Watch Trailer'**
  String get watchTrailer;

  /// No trailer message
  ///
  /// In en, this message translates to:
  /// **'No trailer available'**
  String get noTrailerAvailable;

  /// Trailer error message
  ///
  /// In en, this message translates to:
  /// **'Could not open trailer'**
  String get couldNotOpenTrailer;

  /// Error message for movie details
  ///
  /// In en, this message translates to:
  /// **'Failed to load movie details'**
  String get failedToLoadMovieDetails;

  /// Display name field label in edit profile
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// Sort button label
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get dateAdded;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Sort direction
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// Sort direction
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// Sort direction
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highest;

  /// Sort direction
  ///
  /// In en, this message translates to:
  /// **'A-Z'**
  String get aToZ;

  /// Empty watchlist message
  ///
  /// In en, this message translates to:
  /// **'No movies in your watchlist yet'**
  String get noItemsInWatchlist;

  /// Empty watchlist suggestion
  ///
  /// In en, this message translates to:
  /// **'Start exploring and add movies!'**
  String get startExploring;

  /// Remove button tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove from Watchlist'**
  String get removeFromWatchlist;

  /// Remove confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this movie?'**
  String get confirmRemove;

  /// Remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Mark as watched action
  ///
  /// In en, this message translates to:
  /// **'Mark as Watched'**
  String get markAsWatched;

  /// Edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Movie details link text
  ///
  /// In en, this message translates to:
  /// **'Movie Details'**
  String get movieDetails;

  /// Rating section
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// Rating hint
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get tapToRate;

  /// Add note button
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// Note input hint
  ///
  /// In en, this message translates to:
  /// **'Write your thoughts...'**
  String get noteHint;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Note save confirmation
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get noteSaved;

  /// Re-authentication required message
  ///
  /// In en, this message translates to:
  /// **'Please sign out and sign back in before deleting your account'**
  String get requiresRecentLogin;

  /// Account deletion error
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get failedToDeleteAccount;

  /// No user error
  ///
  /// In en, this message translates to:
  /// **'No user logged in'**
  String get noUserLoggedIn;

  /// Footer text
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get allRightsReserved;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// Language setting title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// Notification toggle label
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled'**
  String get notificationsEnabled;

  /// Notification toggle label
  ///
  /// In en, this message translates to:
  /// **'Notifications Disabled'**
  String get notificationsDisabled;

  /// Notification permission denied message
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. You can enable it in your device settings.'**
  String get notificationPermissionDenied;

  /// Register prompt text
  ///
  /// In en, this message translates to:
  /// **'No account?'**
  String get noAccount;

  /// Sign in prompt text
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAccount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
