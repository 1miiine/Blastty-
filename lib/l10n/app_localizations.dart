import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('en'),
    Locale('fr'),
    Locale('ar')
  ];

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @shareThisApp.
  ///
  /// In en, this message translates to:
  /// **'Share this app'**
  String get shareThisApp;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications yet.'**
  String get notificationsEmpty;

  /// No description provided for @aboutScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutScreenTitle;

  /// No description provided for @aboutScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a barbershop booking app designed to simplify appointments.'**
  String get aboutScreenDescription;

  /// No description provided for @helpDescription.
  ///
  /// In en, this message translates to:
  /// **'Need assistance? Contact our support team for help anytime.'**
  String get helpDescription;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'appointments'**
  String get appointments;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @barbers.
  ///
  /// In en, this message translates to:
  /// **'Barbers'**
  String get barbers;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get noFavoritesYet;

  /// No description provided for @exploreAndAddToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Explore barbers and services, then add them to your favorites for quick access.'**
  String get exploreAndAddToFavorites;

  /// No description provided for @favoritesRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Favorites list refreshed!'**
  String get favoritesRefreshed;

  /// No description provided for @navigateTo.
  ///
  /// In en, this message translates to:
  /// **'Navigate to'**
  String get navigateTo;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites!'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites!'**
  String get removedFromFavorites;

  /// No description provided for @notificationsRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Notifications refreshed!'**
  String get notificationsRefreshed;

  /// No description provided for @notificationDismissed.
  ///
  /// In en, this message translates to:
  /// **'Notification dismissed'**
  String get notificationDismissed;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @opened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get opened;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @alreadyHaveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccountLogin;

  /// No description provided for @searchBarbers.
  ///
  /// In en, this message translates to:
  /// **'Search barbers near you'**
  String get searchBarbers;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'You have no appointments yet.'**
  String get noAppointments;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @bookLater.
  ///
  /// In en, this message translates to:
  /// **'Book Later'**
  String get bookLater;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @hairStyling.
  ///
  /// In en, this message translates to:
  /// **'Hair & Styling'**
  String get hairStyling;

  /// No description provided for @hairColoring.
  ///
  /// In en, this message translates to:
  /// **'Hair Coloring'**
  String get hairColoring;

  /// No description provided for @bridalStyling.
  ///
  /// In en, this message translates to:
  /// **'Bridal Styling'**
  String get bridalStyling;

  /// No description provided for @nails.
  ///
  /// In en, this message translates to:
  /// **'Nails'**
  String get nails;

  /// No description provided for @eyebrowsLashes.
  ///
  /// In en, this message translates to:
  /// **'Eyebrows & Lashes'**
  String get eyebrowsLashes;

  /// No description provided for @barbering.
  ///
  /// In en, this message translates to:
  /// **'Barbering'**
  String get barbering;

  /// No description provided for @hairRemoval.
  ///
  /// In en, this message translates to:
  /// **'Hair Removal'**
  String get hairRemoval;

  /// No description provided for @facialsSkincare.
  ///
  /// In en, this message translates to:
  /// **'Facials & Skincare'**
  String get facialsSkincare;

  /// No description provided for @injectables.
  ///
  /// In en, this message translates to:
  /// **'Injectables'**
  String get injectables;

  /// No description provided for @bodyTreatments.
  ///
  /// In en, this message translates to:
  /// **'Body Treatments'**
  String get bodyTreatments;

  /// No description provided for @hennaArt.
  ///
  /// In en, this message translates to:
  /// **'Henna Art'**
  String get hennaArt;

  /// No description provided for @traditionalHammam.
  ///
  /// In en, this message translates to:
  /// **'Traditional    Hammam'**
  String get traditionalHammam;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Book your next haircut easily and quickly.'**
  String get welcomeDescription;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get enterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get enterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? Register'**
  String get noAccountRegister;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @defaultLocation.
  ///
  /// In en, this message translates to:
  /// **'Casablanca'**
  String get defaultLocation;

  /// No description provided for @topBarbers.
  ///
  /// In en, this message translates to:
  /// **'Top Barbers'**
  String get topBarbers;

  /// No description provided for @recommendedNearby.
  ///
  /// In en, this message translates to:
  /// **'Recommended Nearby'**
  String get recommendedNearby;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @haircut.
  ///
  /// In en, this message translates to:
  /// **'Haircut'**
  String get haircut;

  /// No description provided for @beard.
  ///
  /// In en, this message translates to:
  /// **'Beard'**
  String get beard;

  /// No description provided for @shave.
  ///
  /// In en, this message translates to:
  /// **'Shave'**
  String get shave;

  /// No description provided for @coloring.
  ///
  /// In en, this message translates to:
  /// **'Coloring'**
  String get coloring;

  /// No description provided for @massage.
  ///
  /// In en, this message translates to:
  /// **'Massage'**
  String get massage;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get noServicesFound;

  /// No description provided for @recommendedBarbers.
  ///
  /// In en, this message translates to:
  /// **'Recommended Barbers'**
  String get recommendedBarbers;

  /// No description provided for @noBarbersFound.
  ///
  /// In en, this message translates to:
  /// **'No barbers found'**
  String get noBarbersFound;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @darkLight.
  ///
  /// In en, this message translates to:
  /// **'Dark / Light'**
  String get darkLight;

  /// No description provided for @modeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark / Light 🌙'**
  String get modeSubtitle;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get bookingConfirmed;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get confirmBooking;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noPastBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No past bookings yet'**
  String get noPastBookingsYet;

  /// No description provided for @bookingFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking feature coming soon!'**
  String get bookingFeatureComingSoon;

  /// No description provided for @nowInProgress.
  ///
  /// In en, this message translates to:
  /// **'Now in Progress'**
  String get nowInProgress;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @estCompletion.
  ///
  /// In en, this message translates to:
  /// **'Est. Completion'**
  String get estCompletion;

  /// No description provided for @errorOpeningBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Error opening booking details'**
  String get errorOpeningBookingDetails;

  /// No description provided for @manageBooking.
  ///
  /// In en, this message translates to:
  /// **'Manage booking'**
  String get manageBooking;

  /// No description provided for @cancelBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking ? the professional will be notified.'**
  String get cancelBookingMessage;

  /// No description provided for @postponeBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to postpone this booking?'**
  String get postponeBookingMessage;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @enterYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your message...'**
  String get enterYourMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @pleaseEnterAMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a message.'**
  String get pleaseEnterAMessage;

  /// No description provided for @messageSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent'**
  String get messageSent;

  /// No description provided for @completeBooking.
  ///
  /// In en, this message translates to:
  /// **'Complete Booking'**
  String get completeBooking;

  /// No description provided for @completeBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this booking as complete?'**
  String get completeBookingMessage;

  /// No description provided for @bookingMarkedAsComplete.
  ///
  /// In en, this message translates to:
  /// **'Booking marked as complete!'**
  String get bookingMarkedAsComplete;

  /// No description provided for @added15MinutesToBooking.
  ///
  /// In en, this message translates to:
  /// **'Added 15 minutes to booking!'**
  String get added15MinutesToBooking;

  /// No description provided for @barber1.
  ///
  /// In en, this message translates to:
  /// **'Barber'**
  String get barber1;

  /// No description provided for @barber2.
  ///
  /// In en, this message translates to:
  /// **'Barber'**
  String get barber2;

  /// No description provided for @barber3.
  ///
  /// In en, this message translates to:
  /// **'Barber'**
  String get barber3;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noPastBookings.
  ///
  /// In en, this message translates to:
  /// **'No past bookings yet'**
  String get noPastBookings;

  /// No description provided for @noOngoingBookings.
  ///
  /// In en, this message translates to:
  /// **'No ongoing bookings'**
  String get noOngoingBookings;

  /// No description provided for @noUpcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings'**
  String get noUpcomingBookings;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @postponeBooking.
  ///
  /// In en, this message translates to:
  /// **'Postpone booking'**
  String get postponeBooking;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTime;

  /// No description provided for @bookingCanceled.
  ///
  /// In en, this message translates to:
  /// **'Booking Canceled'**
  String get bookingCanceled;

  /// No description provided for @bookingPostponed.
  ///
  /// In en, this message translates to:
  /// **'Booking postponed'**
  String get bookingPostponed;

  /// No description provided for @bookingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Booking Completed!'**
  String get bookingCompleted;

  /// No description provided for @timeAdded.
  ///
  /// In en, this message translates to:
  /// **'Added 15 minutes to booking!'**
  String get timeAdded;

  /// No description provided for @messagingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Messaging functionality coming soon!'**
  String get messagingComingSoon;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String areYouSure(Object action);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @barber.
  ///
  /// In en, this message translates to:
  /// **'Barber'**
  String get barber;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @accessTime.
  ///
  /// In en, this message translates to:
  /// **'Access Time'**
  String get accessTime;

  /// No description provided for @availableBarbers.
  ///
  /// In en, this message translates to:
  /// **'Available Barbers'**
  String get availableBarbers;

  /// No description provided for @bookingRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Your booking request was sent. You will receive a confirmation soon.'**
  String get bookingRequestSent;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live;

  /// No description provided for @clientCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Client Checked In'**
  String get clientCheckedIn;

  /// No description provided for @scheduleView.
  ///
  /// In en, this message translates to:
  /// **'Schedule View'**
  String get scheduleView;

  /// No description provided for @closingSoon.
  ///
  /// In en, this message translates to:
  /// **'Closing soon'**
  String get closingSoon;

  /// No description provided for @barberSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Barber Specialty'**
  String get barberSpecialty;

  /// No description provided for @chooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose a service:'**
  String get chooseService;

  /// No description provided for @writeYourReview.
  ///
  /// In en, this message translates to:
  /// **'Write your review here...'**
  String get writeYourReview;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get pleaseFillAllFields;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.'**
  String get invalidCredentials;

  /// No description provided for @allNotificationsMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read.'**
  String get allNotificationsMarkedAsRead;

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String couldNotLaunchUrl(Object url);

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'How do I book an appointment?'**
  String get faq1Question;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'You can book an appointment by selecting a barber, choosing a service and time slot, and confirming your booking.'**
  String get faq1Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'How can I cancel my appointment?'**
  String get faq2Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'You can cancel your appointment up to 2 hours before the scheduled time through the \"My Appointments\" section.'**
  String get faq2Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are accepted?'**
  String get faq3Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'We currently accept cash payments at the barbershop. Card payments are coming soon!'**
  String get faq3Answer;

  /// No description provided for @faq4Question.
  ///
  /// In en, this message translates to:
  /// **'How do I contact customer support?'**
  String get faq4Question;

  /// No description provided for @faq4Answer.
  ///
  /// In en, this message translates to:
  /// **'You can reach us via email at support@barberapp.ma or call us at +212 6 12 34 56 78.'**
  String get faq4Answer;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Frensh'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @pleaseFillAllFieldsCorrectly.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields correctly.'**
  String get pleaseFillAllFieldsCorrectly;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @away.
  ///
  /// In en, this message translates to:
  /// **'Away'**
  String get away;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'description'**
  String get description;

  /// No description provided for @bookingConfirmedFor.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed for '**
  String get bookingConfirmedFor;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated ! '**
  String get profileUpdated;

  /// No description provided for @servicesOffered.
  ///
  /// In en, this message translates to:
  /// **'Services Offered'**
  String get servicesOffered;

  /// No description provided for @additionalImages.
  ///
  /// In en, this message translates to:
  /// **'Additional Images'**
  String get additionalImages;

  /// No description provided for @reviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Review label'**
  String get reviewLabel;

  /// No description provided for @addFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add favorites'**
  String get addFavorites;

  /// No description provided for @yourFavoriteBarbersAndServices.
  ///
  /// In en, this message translates to:
  /// **'Your Favorite Barbers And Services'**
  String get yourFavoriteBarbersAndServices;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get noFavorites;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications.'**
  String get noNotifications;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'All Read'**
  String get markAllAsRead;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Blasti'**
  String get appName;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'tools'**
  String get tools;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Easily discover trusted barbers and stylists around you, explore a variety of services, and book appointments in just a few taps. For professionals, showcase your work, manage bookings, track clients, and grow your business with powerful tools—all in one app.'**
  String get aboutAppDescription;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed By'**
  String get developedBy;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillRequiredFields;

  /// No description provided for @languageSelectorComingSoon.
  ///
  /// In en, this message translates to:
  /// **'language Selector Coming Soon'**
  String get languageSelectorComingSoon;

  /// No description provided for @googleSignInComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In coming soon!'**
  String get googleSignInComingSoon;

  /// No description provided for @appleSignInComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In coming soon!'**
  String get appleSignInComingSoon;

  /// No description provided for @facebookSignInComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Facebook Sign-In coming soon!'**
  String get facebookSignInComingSoon;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signUpToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Invalid age'**
  String get invalidAge;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @changePicture.
  ///
  /// In en, this message translates to:
  /// **'Change picture'**
  String get changePicture;

  /// No description provided for @viewPicture.
  ///
  /// In en, this message translates to:
  /// **'View picture'**
  String get viewPicture;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get iAgreeToThe;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully!'**
  String get logoutSuccess;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed. Please try again.'**
  String get logoutFailed;

  /// No description provided for @loginLogout.
  ///
  /// In en, this message translates to:
  /// **'Login/Logout'**
  String get loginLogout;

  /// No description provided for @loginLogoutPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'You can implement login or logout here.'**
  String get loginLogoutPlaceholder;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editProfileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit profile feature coming soon!'**
  String get editProfileComingSoon;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @bookingUnknownStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'The booking status is unknown.'**
  String get bookingUnknownStatusDescription;

  /// No description provided for @bookingOngoingDescription.
  ///
  /// In en, this message translates to:
  /// **'Your booking is currently ongoing.'**
  String get bookingOngoingDescription;

  /// No description provided for @bookingCanceledDescription.
  ///
  /// In en, this message translates to:
  /// **'This booking has been canceled.'**
  String get bookingCanceledDescription;

  /// No description provided for @bookingPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Your booking is pending confirmation.'**
  String get bookingPendingDescription;

  /// No description provided for @bookingConfirmedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been confirmed.'**
  String get bookingConfirmedDescription;

  /// No description provided for @bookingCompletedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been completed.'**
  String get bookingCompletedDescription;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get unknownDate;

  /// No description provided for @bookingWith.
  ///
  /// In en, this message translates to:
  /// **'Booking with'**
  String get bookingWith;

  /// No description provided for @hasBeenCanceled.
  ///
  /// In en, this message translates to:
  /// **'has been canceled'**
  String get hasBeenCanceled;

  /// No description provided for @hasBeenPostponedBy.
  ///
  /// In en, this message translates to:
  /// **'has been postponed by'**
  String get hasBeenPostponedBy;

  /// No description provided for @hasBeenConfirmed.
  ///
  /// In en, this message translates to:
  /// **'has been confirmed'**
  String get hasBeenConfirmed;

  /// No description provided for @cancelBookingWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingWarning;

  /// No description provided for @postpone.
  ///
  /// In en, this message translates to:
  /// **'Postpone'**
  String get postpone;

  /// No description provided for @selectPostponeDuration.
  ///
  /// In en, this message translates to:
  /// **'Select a postpone duration'**
  String get selectPostponeDuration;

  /// No description provided for @yesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, confirm'**
  String get yesConfirm;

  /// No description provided for @earnLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Earn loyalty points'**
  String get earnLoyaltyPoints;

  /// No description provided for @loyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get loyaltyPoints;

  /// No description provided for @validUntilNov302025.
  ///
  /// In en, this message translates to:
  /// **'Valid until Nov 30, 2025'**
  String get validUntilNov302025;

  /// No description provided for @bookAnotherAppointmentDiscount.
  ///
  /// In en, this message translates to:
  /// **'Book another appointment and get a discount'**
  String get bookAnotherAppointmentDiscount;

  /// No description provided for @fifteenPercentOffNextVisit.
  ///
  /// In en, this message translates to:
  /// **'15% off your next visit'**
  String get fifteenPercentOffNextVisit;

  /// No description provided for @specialOffers.
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get specialOffers;

  /// No description provided for @serviceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Service Completed'**
  String get serviceCompleted;

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get unknownStatus;

  /// No description provided for @canceledOn.
  ///
  /// In en, this message translates to:
  /// **'Canceled on'**
  String get canceledOn;

  /// No description provided for @bookingHasBeenCanceled.
  ///
  /// In en, this message translates to:
  /// **'Booking has been canceled'**
  String get bookingHasBeenCanceled;

  /// No description provided for @completedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on'**
  String get completedOn;

  /// No description provided for @withText.
  ///
  /// In en, this message translates to:
  /// **'with'**
  String get withText;

  /// No description provided for @appointmentPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Your appointment is pending confirmation.'**
  String get appointmentPendingDescription;

  /// No description provided for @appointmentCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Completed'**
  String get appointmentCompletedTitle;

  /// No description provided for @appointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Appointment date'**
  String get appointmentDate;

  /// No description provided for @confirmedBy.
  ///
  /// In en, this message translates to:
  /// **'Confirmed by'**
  String get confirmedBy;

  /// No description provided for @untilYourAppointmentWith.
  ///
  /// In en, this message translates to:
  /// **'Until your appointment with'**
  String get untilYourAppointmentWith;

  /// No description provided for @arriveTenMinutesEarlyTip.
  ///
  /// In en, this message translates to:
  /// **'Arrive 10 minutes early for your appointment'**
  String get arriveTenMinutesEarlyTip;

  /// No description provided for @bookingStatusInformation.
  ///
  /// In en, this message translates to:
  /// **'Booking status information'**
  String get bookingStatusInformation;

  /// No description provided for @appointmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Appointment status'**
  String get appointmentStatus;

  /// No description provided for @appointmentCanceledDescription.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been canceled.'**
  String get appointmentCanceledDescription;

  /// No description provided for @appointmentCanceledTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment canceled'**
  String get appointmentCanceledTitle;

  /// No description provided for @appointmentCompletedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been successfully completed.'**
  String get appointmentCompletedDescription;

  /// No description provided for @serviceInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Service in progress'**
  String get serviceInProgressTitle;

  /// No description provided for @serviceInProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'Your service is currently in progress.'**
  String get serviceInProgressDescription;

  /// No description provided for @appointmentConfirmedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been confirmed.'**
  String get appointmentConfirmedDescription;

  /// No description provided for @appointmentPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment pending'**
  String get appointmentPendingTitle;

  /// No description provided for @mainBranchDowntown.
  ///
  /// In en, this message translates to:
  /// **'Main branch downtown'**
  String get mainBranchDowntown;

  /// No description provided for @unknownId.
  ///
  /// In en, this message translates to:
  /// **'Unknown ID'**
  String get unknownId;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @unknownService.
  ///
  /// In en, this message translates to:
  /// **'Unknown service'**
  String get unknownService;

  /// No description provided for @unknownTime.
  ///
  /// In en, this message translates to:
  /// **'Unknown time'**
  String get unknownTime;

  /// No description provided for @barberInformation.
  ///
  /// In en, this message translates to:
  /// **'Barber information'**
  String get barberInformation;

  /// No description provided for @unknownBarber.
  ///
  /// In en, this message translates to:
  /// **'Unknown barber'**
  String get unknownBarber;

  /// No description provided for @serviceInProgress.
  ///
  /// In en, this message translates to:
  /// **'Service in Progress'**
  String get serviceInProgress;

  /// No description provided for @barberConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Barber confirmed'**
  String get barberConfirmed;

  /// No description provided for @bookingCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking created'**
  String get bookingCreated;

  /// No description provided for @appointmentTimeline.
  ///
  /// In en, this message translates to:
  /// **'Appointment Timeline'**
  String get appointmentTimeline;

  /// No description provided for @bookingStatus.
  ///
  /// In en, this message translates to:
  /// **'Booking Status'**
  String get bookingStatus;

  /// No description provided for @flagUsa.
  ///
  /// In en, this message translates to:
  /// **'flag_usa.png'**
  String get flagUsa;

  /// No description provided for @flagFrance.
  ///
  /// In en, this message translates to:
  /// **'flag_france.png'**
  String get flagFrance;

  /// No description provided for @changeLanguageViaAppBar.
  ///
  /// In en, this message translates to:
  /// **'change Language Via AppBar'**
  String get changeLanguageViaAppBar;

  /// No description provided for @flagMorocco.
  ///
  /// In en, this message translates to:
  /// **'flag_morocco.png'**
  String get flagMorocco;

  /// No description provided for @shareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out this cool barber app!'**
  String get shareAppMessage;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful !'**
  String get registrationSuccess;

  /// No description provided for @pleaseAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms and Conditions.'**
  String get pleaseAgreeToTerms;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @pleaseEnterFirstAndLast.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least first and last name'**
  String get pleaseEnterFirstAndLast;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @enterEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you a link to reset your password.'**
  String get enterEmailForReset;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @emailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Sent!'**
  String get emailSentTitle;

  /// No description provided for @emailSentInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please check your email'**
  String get emailSentInstructions;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @confirmBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBookingTitle;

  /// No description provided for @failedToSendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email. Please try again.'**
  String get failedToSendResetEmail;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @barberHaven1.
  ///
  /// In en, this message translates to:
  /// **'Barber Haven 1'**
  String get barberHaven1;

  /// No description provided for @barberHaven2.
  ///
  /// In en, this message translates to:
  /// **'Barber Haven 2'**
  String get barberHaven2;

  /// No description provided for @barberHaven3.
  ///
  /// In en, this message translates to:
  /// **'Barber Haven 3'**
  String get barberHaven3;

  /// No description provided for @barberHaven4.
  ///
  /// In en, this message translates to:
  /// **'Barber Haven 4'**
  String get barberHaven4;

  /// No description provided for @barberHaven5.
  ///
  /// In en, this message translates to:
  /// **'Barber Haven 5'**
  String get barberHaven5;

  /// No description provided for @specialtyPremiumBeardCare.
  ///
  /// In en, this message translates to:
  /// **'Premium Beard Care'**
  String get specialtyPremiumBeardCare;

  /// No description provided for @specialtySignatureHaircut.
  ///
  /// In en, this message translates to:
  /// **'Signature Haircut'**
  String get specialtySignatureHaircut;

  /// No description provided for @descBarberHaven1.
  ///
  /// In en, this message translates to:
  /// **'A renowned barbershop offering exceptional grooming experiences.'**
  String get descBarberHaven1;

  /// No description provided for @descBarberHaven2.
  ///
  /// In en, this message translates to:
  /// **'Expert barbers providing stylish cuts and beard trims.'**
  String get descBarberHaven2;

  /// No description provided for @descBarberHaven3.
  ///
  /// In en, this message translates to:
  /// **'Comfortable environment with skilled professionals.'**
  String get descBarberHaven3;

  /// No description provided for @descBarberHaven4.
  ///
  /// In en, this message translates to:
  /// **'Top-rated services and personalized care.'**
  String get descBarberHaven4;

  /// No description provided for @descBarberHaven5.
  ///
  /// In en, this message translates to:
  /// **'Modern techniques with a classic touch.'**
  String get descBarberHaven5;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @appointmentReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Reminder'**
  String get appointmentReminderTitle;

  /// No description provided for @appointmentReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Your appointment with Barber Ali is in 30 minutes.'**
  String get appointmentReminderMessage;

  /// No description provided for @newPromotionTitle.
  ///
  /// In en, this message translates to:
  /// **'New Promotion'**
  String get newPromotionTitle;

  /// No description provided for @newPromotionMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out our new beard care package! 20% off this week.'**
  String get newPromotionMessage;

  /// No description provided for @appointmentConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Confirmed'**
  String get appointmentConfirmedTitle;

  /// No description provided for @appointmentConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking for tomorrow at 3 PM is confirmed.'**
  String get appointmentConfirmedMessage;

  /// No description provided for @systemUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'System Update'**
  String get systemUpdateTitle;

  /// No description provided for @systemUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'The app has been updated to version 2.1. Enjoy new features!'**
  String get systemUpdateMessage;

  /// No description provided for @specialOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get specialOfferTitle;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get forYou;

  /// No description provided for @postComment.
  ///
  /// In en, this message translates to:
  /// **'Post Comment'**
  String get postComment;

  /// No description provided for @commentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Comment cannot be empty'**
  String get commentEmpty;

  /// No description provided for @traditionalCuts.
  ///
  /// In en, this message translates to:
  /// **'Traditional Cuts'**
  String get traditionalCuts;

  /// No description provided for @omarClassic.
  ///
  /// In en, this message translates to:
  /// **'Omar Classic'**
  String get omarClassic;

  /// No description provided for @masterStyling.
  ///
  /// In en, this message translates to:
  /// **'Master Styling'**
  String get masterStyling;

  /// No description provided for @khalidElite.
  ///
  /// In en, this message translates to:
  /// **'Khalid Elite'**
  String get khalidElite;

  /// No description provided for @luxuryGrooming.
  ///
  /// In en, this message translates to:
  /// **'Luxury Grooming'**
  String get luxuryGrooming;

  /// No description provided for @moradPremium.
  ///
  /// In en, this message translates to:
  /// **'Morad Premium'**
  String get moradPremium;

  /// No description provided for @southMall.
  ///
  /// In en, this message translates to:
  /// **'South Mall'**
  String get southMall;

  /// No description provided for @urbanCuts.
  ///
  /// In en, this message translates to:
  /// **'Urban Cuts'**
  String get urbanCuts;

  /// No description provided for @eastDistrict.
  ///
  /// In en, this message translates to:
  /// **'East District'**
  String get eastDistrict;

  /// No description provided for @royalBarber.
  ///
  /// In en, this message translates to:
  /// **'Royal Barber'**
  String get royalBarber;

  /// No description provided for @microblading.
  ///
  /// In en, this message translates to:
  /// **'Microblading'**
  String get microblading;

  /// No description provided for @excellentReputation.
  ///
  /// In en, this message translates to:
  /// **'Excellent reputation'**
  String get excellentReputation;

  /// No description provided for @highlyRecommended.
  ///
  /// In en, this message translates to:
  /// **'Highly recommended'**
  String get highlyRecommended;

  /// No description provided for @trusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get trusted;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @notificationTimeKey.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get notificationTimeKey;

  /// No description provided for @preparingBusinessInsights.
  ///
  /// In en, this message translates to:
  /// **'Preparing your business insights...'**
  String get preparingBusinessInsights;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get goodEvening;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @businessOverview.
  ///
  /// In en, this message translates to:
  /// **'BUSINESS OVERVIEW'**
  String get businessOverview;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @topPerformingServices.
  ///
  /// In en, this message translates to:
  /// **'TOP PERFORMING SERVICES'**
  String get topPerformingServices;

  /// No description provided for @noPopularServices.
  ///
  /// In en, this message translates to:
  /// **'No popular services yet'**
  String get noPopularServices;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @averagePerBooking.
  ///
  /// In en, this message translates to:
  /// **'Average per Booking'**
  String get averagePerBooking;

  /// No description provided for @growthRate.
  ///
  /// In en, this message translates to:
  /// **'Growth Rate'**
  String get growthRate;

  /// No description provided for @viewFullAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View Full Analytics'**
  String get viewFullAnalytics;

  /// No description provided for @performanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'PERFORMANCE METRICS'**
  String get performanceMetrics;

  /// No description provided for @todaysBookings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Bookings'**
  String get todaysBookings;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelled;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @nextBooking.
  ///
  /// In en, this message translates to:
  /// **'Next booking'**
  String get nextBooking;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get todaySummary;

  /// No description provided for @customerSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Customer Satisfaction'**
  String get customerSatisfaction;

  /// No description provided for @revenueTrend.
  ///
  /// In en, this message translates to:
  /// **'REVENUE TREND'**
  String get revenueTrend;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @peakRevenueDay.
  ///
  /// In en, this message translates to:
  /// **'Peak Revenue Day'**
  String get peakRevenueDay;

  /// No description provided for @averageDailyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Revenue'**
  String get averageDailyRevenue;

  /// No description provided for @consistentPerformance.
  ///
  /// In en, this message translates to:
  /// **'Consistent performance'**
  String get consistentPerformance;

  /// No description provided for @serviceAnalytics.
  ///
  /// In en, this message translates to:
  /// **'SERVICE ANALYTICS'**
  String get serviceAnalytics;

  /// No description provided for @totalServices.
  ///
  /// In en, this message translates to:
  /// **'Total Services'**
  String get totalServices;

  /// No description provided for @popularServices.
  ///
  /// In en, this message translates to:
  /// **'Popular Services'**
  String get popularServices;

  /// No description provided for @avgServicePrice.
  ///
  /// In en, this message translates to:
  /// **'Avg. Service Price'**
  String get avgServicePrice;

  /// No description provided for @topServices.
  ///
  /// In en, this message translates to:
  /// **'TOP SERVICES'**
  String get topServices;

  /// No description provided for @noServices.
  ///
  /// In en, this message translates to:
  /// **'No services yet'**
  String get noServices;

  /// No description provided for @productivityBoosters.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTIVITY BOOSTERS'**
  String get productivityBoosters;

  /// No description provided for @reviewPendingBookings.
  ///
  /// In en, this message translates to:
  /// **'Review Pending Bookings'**
  String get reviewPendingBookings;

  /// No description provided for @pendingBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Booking Requests'**
  String get pendingBookingRequests;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'All Clear!'**
  String get allClear;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @growthRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Growth Recommendations'**
  String get growthRecommendations;

  /// No description provided for @strategicInsights.
  ///
  /// In en, this message translates to:
  /// **'Strategic Insights'**
  String get strategicInsights;

  /// No description provided for @predictedRevenue.
  ///
  /// In en, this message translates to:
  /// **'Predicted Revenue'**
  String get predictedRevenue;

  /// No description provided for @predictedBookings.
  ///
  /// In en, this message translates to:
  /// **'Predicted Bookings'**
  String get predictedBookings;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get pleaseSelectGender;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @failedToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location.'**
  String get failedToGetLocation;

  /// No description provided for @pleaseFillSeatDetails.
  ///
  /// In en, this message translates to:
  /// **'Please fill in seat details.'**
  String get pleaseFillSeatDetails;

  /// No description provided for @totalSeatsMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Total seats must be positive.'**
  String get totalSeatsMustBePositive;

  /// No description provided for @occupiedSeatsCannotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'Occupied seats cannot be negative.'**
  String get occupiedSeatsCannotBeNegative;

  /// No description provided for @occupiedSeatsCannotExceedTotal.
  ///
  /// In en, this message translates to:
  /// **'Occupied seats cannot exceed total seats.'**
  String get occupiedSeatsCannotExceedTotal;

  /// No description provided for @salonType.
  ///
  /// In en, this message translates to:
  /// **'Salon Type'**
  String get salonType;

  /// No description provided for @professionalType.
  ///
  /// In en, this message translates to:
  /// **'Professional Type'**
  String get professionalType;

  /// No description provided for @pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get pleaseSelect;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNow;

  /// No description provided for @kidsFriendly.
  ///
  /// In en, this message translates to:
  /// **'Kids Friendly'**
  String get kidsFriendly;

  /// No description provided for @acceptsCard.
  ///
  /// In en, this message translates to:
  /// **'Accepts Card'**
  String get acceptsCard;

  /// No description provided for @imageAdded.
  ///
  /// In en, this message translates to:
  /// **'Image added'**
  String get imageAdded;

  /// No description provided for @failedToAddImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to add image'**
  String get failedToAddImage;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @deleteImagesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected images?'**
  String get deleteImagesConfirmation;

  /// No description provided for @imagesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Images deleted'**
  String get imagesDeleted;

  /// No description provided for @failedToDeleteImages.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete images'**
  String get failedToDeleteImages;

  /// No description provided for @selectOneImageToSetAsMain.
  ///
  /// In en, this message translates to:
  /// **'Select one image to set as main'**
  String get selectOneImageToSetAsMain;

  /// No description provided for @profileImageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated'**
  String get profileImageUpdated;

  /// No description provided for @failedToUpdateProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile image'**
  String get failedToUpdateProfileImage;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @closeLate.
  ///
  /// In en, this message translates to:
  /// **'Close late'**
  String get closeLate;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @showFavorites.
  ///
  /// In en, this message translates to:
  /// **'Show favorites'**
  String get showFavorites;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @useAsMainImage.
  ///
  /// In en, this message translates to:
  /// **'Use as main image'**
  String get useAsMainImage;

  /// No description provided for @vip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get vip;

  /// No description provided for @showAllImages.
  ///
  /// In en, this message translates to:
  /// **'Show all images'**
  String get showAllImages;

  /// No description provided for @noFavoriteImages.
  ///
  /// In en, this message translates to:
  /// **'No favorite images'**
  String get noFavoriteImages;

  /// No description provided for @noImagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get noImagesAvailable;

  /// No description provided for @tapHeartToFavorite.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart to favorite'**
  String get tapHeartToFavorite;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @viewGallery.
  ///
  /// In en, this message translates to:
  /// **'View Gallery'**
  String get viewGallery;

  /// No description provided for @men.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get men;

  /// No description provided for @professionalRegistrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Professional registration successful.'**
  String get professionalRegistrationSuccessful;

  /// No description provided for @locationPluginError.
  ///
  /// In en, this message translates to:
  /// **'Location plugin error occurred.'**
  String get locationPluginError;

  /// No description provided for @women.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get women;

  /// No description provided for @saloonName.
  ///
  /// In en, this message translates to:
  /// **'Salon Name'**
  String get saloonName;

  /// No description provided for @personalContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Contact Information'**
  String get personalContactInfo;

  /// No description provided for @saloonInformation.
  ///
  /// In en, this message translates to:
  /// **'Salon Information'**
  String get saloonInformation;

  /// No description provided for @saloonRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register your salon to reach more clients and grow your business'**
  String get saloonRegisterSubtitle;

  /// No description provided for @saloonRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Salon Registration'**
  String get saloonRegisterTitle;

  /// No description provided for @saloonCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get saloonCreateAccount;

  /// No description provided for @pleaseEnterSalonName.
  ///
  /// In en, this message translates to:
  /// **'Please enter salon name'**
  String get pleaseEnterSalonName;

  /// No description provided for @saloonRegistrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Salon registration successful.'**
  String get saloonRegistrationSuccessful;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @businessInformation.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get businessInformation;

  /// No description provided for @soloProfessional.
  ///
  /// In en, this message translates to:
  /// **'Solo Professional'**
  String get soloProfessional;

  /// No description provided for @professionalRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to connect with clients and grow your business'**
  String get professionalRegisterSubtitle;

  /// No description provided for @professionalCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get professionalCreateAccount;

  /// No description provided for @professionalRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Registration'**
  String get professionalRegisterTitle;

  /// No description provided for @soloBarber.
  ///
  /// In en, this message translates to:
  /// **'Solo Barber'**
  String get soloBarber;

  /// No description provided for @salonOwner.
  ///
  /// In en, this message translates to:
  /// **'Salon Owner'**
  String get salonOwner;

  /// No description provided for @seatInformation.
  ///
  /// In en, this message translates to:
  /// **'Seat Information'**
  String get seatInformation;

  /// No description provided for @barberDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a barber account?'**
  String get barberDontHaveAccount;

  /// No description provided for @barberSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your salon.'**
  String get barberSignInToContinue;

  /// No description provided for @barberWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back, Barber!'**
  String get barberWelcomeBack;

  /// No description provided for @barberLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Barber Login'**
  String get barberLoginTitle;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed.'**
  String get registrationFailed;

  /// No description provided for @pleaseAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions.'**
  String get pleaseAcceptTerms;

  /// No description provided for @barberRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Barber Register'**
  String get barberRegisterTitle;

  /// No description provided for @barberCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Barber Account'**
  String get barberCreateAccount;

  /// No description provided for @barberRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to manage your services.'**
  String get barberRegisterSubtitle;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms and Conditions'**
  String get acceptTerms;

  /// No description provided for @barberAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have a barber account?'**
  String get barberAlreadyHaveAccount;

  /// No description provided for @passwordResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent!'**
  String get passwordResetLinkSent;

  /// No description provided for @barberForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you a link to reset your password.'**
  String get barberForgotPasswordSubtitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed'**
  String get passwordResetFailed;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get pleaseEnterName;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @barberDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your salon, services, and bookings.'**
  String get barberDescription;

  /// No description provided for @clientDescription.
  ///
  /// In en, this message translates to:
  /// **'Find the best barbers and book appointments.'**
  String get clientDescription;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset Link Sent'**
  String get resetLinkSent;

  /// No description provided for @pleaseEnterBarbershopName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your barbershop name'**
  String get pleaseEnterBarbershopName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your e-mail'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @pleaseEnterLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your barbershop location'**
  String get pleaseEnterLocation;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @shopInformation.
  ///
  /// In en, this message translates to:
  /// **'Shop Information'**
  String get shopInformation;

  /// No description provided for @barbershopName.
  ///
  /// In en, this message translates to:
  /// **'Barbershop Name'**
  String get barbershopName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Barber located at'**
  String get location;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @imAClient.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Client'**
  String get imAClient;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Please select your role.'**
  String get welcomeMessage;

  /// No description provided for @imABarber.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Barber/Salon Owner'**
  String get imABarber;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @manageYourAvailability.
  ///
  /// In en, this message translates to:
  /// **'Manage your availability'**
  String get manageYourAvailability;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// Greeting message for the user
  ///
  /// In en, this message translates to:
  /// **'Hello {userName}!'**
  String hello(String userName);

  /// Represents the percentage of booked slots vs available slots.
  ///
  /// In en, this message translates to:
  /// **'Utilization Rate'**
  String get utilizationRate;

  /// Represents the total number of available slots.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// Button text to view a more detailed report.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Report'**
  String get viewDetailedReport;

  /// Section header for reports and analytics.
  ///
  /// In en, this message translates to:
  /// **'Report & Analysis'**
  String get reportAndAnalysis;

  /// Metric showing how many customers keep returning.
  ///
  /// In en, this message translates to:
  /// **'Customer Retention'**
  String get customerRetention;

  /// Section showing AI-generated insights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @noPendingBookings.
  ///
  /// In en, this message translates to:
  /// **'No pending bookings at the moment'**
  String get noPendingBookings;

  /// No description provided for @optimizeSchedule.
  ///
  /// In en, this message translates to:
  /// **'Optimize Schedule'**
  String get optimizeSchedule;

  /// No description provided for @reviewTodays.
  ///
  /// In en, this message translates to:
  /// **'Review today\'s'**
  String get reviewTodays;

  /// No description provided for @updateServices.
  ///
  /// In en, this message translates to:
  /// **'Update Services'**
  String get updateServices;

  /// No description provided for @keepServicePortfolioFresh.
  ///
  /// In en, this message translates to:
  /// **'Keep your service portfolio fresh'**
  String get keepServicePortfolioFresh;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACCESS'**
  String get quickAccess;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editService;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @serviceInsights.
  ///
  /// In en, this message translates to:
  /// **'Service insights'**
  String get serviceInsights;

  /// No description provided for @noLocation.
  ///
  /// In en, this message translates to:
  /// **'No Location'**
  String get noLocation;

  /// No description provided for @weeklyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Weekly Revenue'**
  String get weeklyRevenue;

  /// No description provided for @popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity;

  /// No description provided for @newDateTimeMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'The new date and time must be different from the current one.'**
  String get newDateTimeMustBeDifferent;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @switchToUserMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to User Mode'**
  String get switchToUserMode;

  /// No description provided for @noEmailProvided.
  ///
  /// In en, this message translates to:
  /// **'No email provided'**
  String get noEmailProvided;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @switchToBarber.
  ///
  /// In en, this message translates to:
  /// **'Switch to barber'**
  String get switchToBarber;

  /// No description provided for @confirmSwitchToUser.
  ///
  /// In en, this message translates to:
  /// **'Confirm switch to user'**
  String get confirmSwitchToUser;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @reviewThemNow.
  ///
  /// In en, this message translates to:
  /// **'Review them now'**
  String get reviewThemNow;

  /// No description provided for @lookup.
  ///
  /// In en, this message translates to:
  /// **'Look Up'**
  String get lookup;

  /// No description provided for @byMinutes.
  ///
  /// In en, this message translates to:
  /// **'by {minutes} minutes'**
  String byMinutes(Object minutes);

  /// No description provided for @invalidTimeInput.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive number of minutes.'**
  String get invalidTimeInput;

  /// No description provided for @enterMinutes.
  ///
  /// In en, this message translates to:
  /// **'Enter minutes'**
  String get enterMinutes;

  /// No description provided for @fortyFiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'45 Minutes'**
  String get fortyFiveMinutes;

  /// No description provided for @selectPostponeTime.
  ///
  /// In en, this message translates to:
  /// **'Select Postpone Time'**
  String get selectPostponeTime;

  /// No description provided for @chooseIncrement.
  ///
  /// In en, this message translates to:
  /// **'Choose an increment:'**
  String get chooseIncrement;

  /// No description provided for @orEnterCustomTime.
  ///
  /// In en, this message translates to:
  /// **'Or enter custom time:'**
  String get orEnterCustomTime;

  /// No description provided for @experienced.
  ///
  /// In en, this message translates to:
  /// **'Experienced'**
  String get experienced;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @quickService.
  ///
  /// In en, this message translates to:
  /// **'Quick Service'**
  String get quickService;

  /// No description provided for @friendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get friendly;

  /// No description provided for @specialOffer.
  ///
  /// In en, this message translates to:
  /// **'Special Offer!'**
  String get specialOffer;

  /// No description provided for @hammam.
  ///
  /// In en, this message translates to:
  /// **'Hammam'**
  String get hammam;

  /// No description provided for @laserHairRemoval.
  ///
  /// In en, this message translates to:
  /// **'Laser Hair Removal'**
  String get laserHairRemoval;

  /// No description provided for @northPlaza.
  ///
  /// In en, this message translates to:
  /// **'North Plaza'**
  String get northPlaza;

  /// No description provided for @modernStyles.
  ///
  /// In en, this message translates to:
  /// **'Modern Styles'**
  String get modernStyles;

  /// No description provided for @westSide.
  ///
  /// In en, this message translates to:
  /// **'West Side'**
  String get westSide;

  /// No description provided for @classicGrooming.
  ///
  /// In en, this message translates to:
  /// **'Classic Grooming'**
  String get classicGrooming;

  /// No description provided for @premiumCuts.
  ///
  /// In en, this message translates to:
  /// **'Premium Cuts'**
  String get premiumCuts;

  /// No description provided for @cityCenter.
  ///
  /// In en, this message translates to:
  /// **'City Center'**
  String get cityCenter;

  /// No description provided for @eliteBarbershop.
  ///
  /// In en, this message translates to:
  /// **'Elite Barbershop'**
  String get eliteBarbershop;

  /// No description provided for @commentAdded.
  ///
  /// In en, this message translates to:
  /// **'Comment added'**
  String get commentAdded;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get writeComment;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add Comment'**
  String get addComment;

  /// No description provided for @postSharedMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out {barberName}\'s post on bokini! Specialty: {specialty}'**
  String postSharedMessage(Object barberName, Object specialty);

  /// No description provided for @barbersNews.
  ///
  /// In en, this message translates to:
  /// **'News for Hairdressers'**
  String get barbersNews;

  /// No description provided for @forHim.
  ///
  /// In en, this message translates to:
  /// **'For Men'**
  String get forHim;

  /// No description provided for @washingHair.
  ///
  /// In en, this message translates to:
  /// **'Washing Hair'**
  String get washingHair;

  /// No description provided for @hairTreatment.
  ///
  /// In en, this message translates to:
  /// **'Hair Treatment'**
  String get hairTreatment;

  /// No description provided for @facialTreatment.
  ///
  /// In en, this message translates to:
  /// **'Facial Treatment'**
  String get facialTreatment;

  /// No description provided for @lineUp.
  ///
  /// In en, this message translates to:
  /// **'Line Up'**
  String get lineUp;

  /// No description provided for @dreadlocks.
  ///
  /// In en, this message translates to:
  /// **'Dreadlocks'**
  String get dreadlocks;

  /// No description provided for @bodyWaxing.
  ///
  /// In en, this message translates to:
  /// **'Body Waxing'**
  String get bodyWaxing;

  /// No description provided for @manicure.
  ///
  /// In en, this message translates to:
  /// **'Manicure'**
  String get manicure;

  /// No description provided for @pedicure.
  ///
  /// In en, this message translates to:
  /// **'Pedicure'**
  String get pedicure;

  /// No description provided for @braiding.
  ///
  /// In en, this message translates to:
  /// **'Braiding'**
  String get braiding;

  /// No description provided for @makeUp.
  ///
  /// In en, this message translates to:
  /// **'Make Up'**
  String get makeUp;

  /// No description provided for @tanning.
  ///
  /// In en, this message translates to:
  /// **'Tanning'**
  String get tanning;

  /// No description provided for @mensHaircut.
  ///
  /// In en, this message translates to:
  /// **'Men\'s Haircut'**
  String get mensHaircut;

  /// No description provided for @womensHaircut.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Haircut'**
  String get womensHaircut;

  /// No description provided for @classicShave.
  ///
  /// In en, this message translates to:
  /// **'Classic Shave'**
  String get classicShave;

  /// No description provided for @hotTowelShave.
  ///
  /// In en, this message translates to:
  /// **'Hot Towel Shave'**
  String get hotTowelShave;

  /// No description provided for @basicBeardTrim.
  ///
  /// In en, this message translates to:
  /// **'Basic Beard Trim'**
  String get basicBeardTrim;

  /// No description provided for @beardShaping.
  ///
  /// In en, this message translates to:
  /// **'Beard Shaping'**
  String get beardShaping;

  /// No description provided for @highlighting.
  ///
  /// In en, this message translates to:
  /// **'Highlighting'**
  String get highlighting;

  /// No description provided for @mensSpa.
  ///
  /// In en, this message translates to:
  /// **'Men\'s SPA'**
  String get mensSpa;

  /// No description provided for @womensSpa.
  ///
  /// In en, this message translates to:
  /// **'Women\'s SPA'**
  String get womensSpa;

  /// No description provided for @couplesSpa.
  ///
  /// In en, this message translates to:
  /// **'Couple\'s SPA'**
  String get couplesSpa;

  /// No description provided for @bikiniWax.
  ///
  /// In en, this message translates to:
  /// **'Bikini Wax'**
  String get bikiniWax;

  /// No description provided for @updo.
  ///
  /// In en, this message translates to:
  /// **'Updo'**
  String get updo;

  /// No description provided for @basicWash.
  ///
  /// In en, this message translates to:
  /// **'Basic Wash'**
  String get basicWash;

  /// No description provided for @deepConditioning.
  ///
  /// In en, this message translates to:
  /// **'Deep Conditioning'**
  String get deepConditioning;

  /// No description provided for @postShared.
  ///
  /// In en, this message translates to:
  /// **'Post Shared'**
  String get postShared;

  /// No description provided for @womensServicesShort.
  ///
  /// In en, this message translates to:
  /// **'Women\'s'**
  String get womensServicesShort;

  /// No description provided for @mensServicesShort.
  ///
  /// In en, this message translates to:
  /// **'Men\'s'**
  String get mensServicesShort;

  /// No description provided for @styling.
  ///
  /// In en, this message translates to:
  /// **'Styling'**
  String get styling;

  /// No description provided for @makeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup'**
  String get makeup;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additionalInfo;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @forHer.
  ///
  /// In en, this message translates to:
  /// **'For Women'**
  String get forHer;

  /// No description provided for @forHimServices.
  ///
  /// In en, this message translates to:
  /// **'Services for Men'**
  String get forHimServices;

  /// No description provided for @forMenServices.
  ///
  /// In en, this message translates to:
  /// **'Services for Men'**
  String get forMenServices;

  /// No description provided for @forWomenServices.
  ///
  /// In en, this message translates to:
  /// **'Services for Women'**
  String get forWomenServices;

  /// No description provided for @forYouFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'For You Feed'**
  String get forYouFeedTitle;

  /// No description provided for @writeYourReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get writeYourReviewHint;

  /// No description provided for @forMen.
  ///
  /// In en, this message translates to:
  /// **'For Men'**
  String get forMen;

  /// No description provided for @forWomen.
  ///
  /// In en, this message translates to:
  /// **'For Women'**
  String get forWomen;

  /// No description provided for @forHerServices.
  ///
  /// In en, this message translates to:
  /// **'Services for Women'**
  String get forHerServices;

  /// No description provided for @barbersForService.
  ///
  /// In en, this message translates to:
  /// **'Barbers for {serviceName}'**
  String barbersForService(Object serviceName);

  /// No description provided for @noBarbersForService.
  ///
  /// In en, this message translates to:
  /// **'No barbers found for {serviceName}.'**
  String noBarbersForService(Object serviceName);

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @twoMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'2 minutes ago'**
  String get twoMinutesAgo;

  /// No description provided for @oneHourAgo.
  ///
  /// In en, this message translates to:
  /// **'1 hour ago'**
  String get oneHourAgo;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @twoDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get twoDaysAgo;

  /// No description provided for @threeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get threeDaysAgo;

  /// No description provided for @specialOfferMessage.
  ///
  /// In en, this message translates to:
  /// **'Refer a friend and get 50 MAD off your next service. Limited time!'**
  String get specialOfferMessage;

  /// No description provided for @appointmentCategory.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointmentCategory;

  /// No description provided for @promotionCategory.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotionCategory;

  /// No description provided for @systemCategory.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemCategory;

  /// No description provided for @termsIntroText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our Blasti App. By accessing or using our services, you agree to be bound by these Terms and Conditions. Please read them carefully.'**
  String get termsIntroText;

  /// No description provided for @eligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get eligibility;

  /// No description provided for @eligibilityText.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old to use this app. By using the app, you represent and warrant that you meet this eligibility requirement.'**
  String get eligibilityText;

  /// No description provided for @useOfServices.
  ///
  /// In en, this message translates to:
  /// **'Use of Services'**
  String get useOfServices;

  /// No description provided for @useOfServicesText.
  ///
  /// In en, this message translates to:
  /// **'You agree to use the app only for lawful purposes and in accordance with these Terms. You shall not:'**
  String get useOfServicesText;

  /// No description provided for @useOfServicesPoint1.
  ///
  /// In en, this message translates to:
  /// **'Violate any laws or regulations.'**
  String get useOfServicesPoint1;

  /// No description provided for @useOfServicesPoint2.
  ///
  /// In en, this message translates to:
  /// **'Interfere with or disrupt the app or servers.'**
  String get useOfServicesPoint2;

  /// No description provided for @useOfServicesPoint3.
  ///
  /// In en, this message translates to:
  /// **'Use the app for any fraudulent or malicious activity.'**
  String get useOfServicesPoint3;

  /// No description provided for @bookingsText.
  ///
  /// In en, this message translates to:
  /// **'Appointment bookings are subject to availability. We reserve the right to cancel or reschedule appointments. Payment is required at the time of booking unless otherwise stated.'**
  String get bookingsText;

  /// No description provided for @userAccounts.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get userAccounts;

  /// No description provided for @userAccountsText.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account and password. You agree to notify us immediately of any unauthorized use of your account.'**
  String get userAccountsText;

  /// No description provided for @intellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get intellectualProperty;

  /// No description provided for @intellectualPropertyText.
  ///
  /// In en, this message translates to:
  /// **'All content included in the app, such as text, graphics, logos, and software, is the property of [Your Company Name] or its licensors and protected by copyright and other intellectual property laws.'**
  String get intellectualPropertyText;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'The app is provided \"as is\" and \"as available\" without warranties of any kind, either express or implied. We do not warrant that the app will be uninterrupted or error-free.'**
  String get disclaimerText;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @limitationOfLiabilityText.
  ///
  /// In en, this message translates to:
  /// **'In no event shall [Your Company Name] be liable for any indirect, incidental, special, consequential or punitive damages arising out of or related to your use of the app.'**
  String get limitationOfLiabilityText;

  /// No description provided for @governingLaw.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get governingLaw;

  /// No description provided for @governingLawText.
  ///
  /// In en, this message translates to:
  /// **'These Terms shall be governed and construed in accordance with the laws of [Your Country], without regard to its conflict of law provisions.'**
  String get governingLawText;

  /// No description provided for @changesToTerms.
  ///
  /// In en, this message translates to:
  /// **'Changes to Terms'**
  String get changesToTerms;

  /// No description provided for @changesToTermsText.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. What constitutes a material change will be determined at our sole discretion.'**
  String get changesToTermsText;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @contactUsText.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms, please contact us at info@yourbarbershop.com.'**
  String get contactUsText;

  /// No description provided for @termsAndConditionsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditionsDialogTitle;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your review has been submitted.'**
  String get reviewSubmitted;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @messagingFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Messaging functionality coming soon!'**
  String get messagingFeatureComingSoon;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @currentlyInProgress.
  ///
  /// In en, this message translates to:
  /// **'Currently in Progress'**
  String get currentlyInProgress;

  /// No description provided for @timeAM.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get timeAM;

  /// No description provided for @timePM.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get timePM;

  /// No description provided for @statusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get statusCanceled;

  /// No description provided for @statusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get statusOngoing;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @fiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'5 Minutes'**
  String get fiveMinutes;

  /// No description provided for @tenMinutes.
  ///
  /// In en, this message translates to:
  /// **'10 Minutes'**
  String get tenMinutes;

  /// No description provided for @fifteenMinutes.
  ///
  /// In en, this message translates to:
  /// **'15 Minutes'**
  String get fifteenMinutes;

  /// No description provided for @thirtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'30 Minutes'**
  String get thirtyMinutes;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get oneHour;

  /// No description provided for @addedTimeToBooking.
  ///
  /// In en, this message translates to:
  /// **'Added time to booking'**
  String get addedTimeToBooking;

  /// No description provided for @checkInStatus.
  ///
  /// In en, this message translates to:
  /// **'Check-in Status'**
  String get checkInStatus;

  /// No description provided for @reviewCount.
  ///
  /// In en, this message translates to:
  /// **'Review Count'**
  String get reviewCount;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get clientName;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Shown when the user has selected a time slot and booked.
  ///
  /// In en, this message translates to:
  /// **'Booked at {time}'**
  String bookedAt(Object time);

  /// Message shown to confirm booking now with barber name
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm this booking ?'**
  String confirmBookingMessage(Object barberName);

  /// No description provided for @bookingConfirmedNow.
  ///
  /// In en, this message translates to:
  /// **'Your booking request was sent. You will receive a confirmation soon.'**
  String get bookingConfirmedNow;

  /// Message shown after a booking is confirmed
  ///
  /// In en, this message translates to:
  /// **'You have booked a {service}.'**
  String youHaveBooked(Object service);

  /// Filter showing barbers currently available
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get availableNow;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// Barber closing time
  ///
  /// In en, this message translates to:
  /// **'Open until {time}'**
  String openUntil(Object time);

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @barberStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get barberStatus;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @rescheduleBooking.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Booking'**
  String get rescheduleBooking;

  /// No description provided for @barberUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Barber currently unavailable'**
  String get barberUnavailable;

  /// No description provided for @selectBarber.
  ///
  /// In en, this message translates to:
  /// **'Select Barber'**
  String get selectBarber;

  /// No description provided for @noTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'No available time slots'**
  String get noTimeSlots;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed. Please try again.'**
  String get bookingFailed;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @confirmBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBookingButton;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @scheduleContentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'This is where the scheduling UI will be.'**
  String get scheduleContentPlaceholder;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select Day'**
  String get selectDay;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get bookingSuccess;

  /// Confirmation message after booking is done
  ///
  /// In en, this message translates to:
  /// **'You have booked a {service} on {date} at {time}.'**
  String bookingSuccessMessage(Object service, Object date, Object time);

  /// No description provided for @noTimeSelected.
  ///
  /// In en, this message translates to:
  /// **'Please select a time slot to proceed.'**
  String get noTimeSelected;

  /// No description provided for @bookNowButton.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNowButton;

  /// No description provided for @barbersListComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Barbers list coming soon...'**
  String get barbersListComingSoon;

  /// No description provided for @hairColor.
  ///
  /// In en, this message translates to:
  /// **'Hair Color'**
  String get hairColor;

  /// No description provided for @beardTrim.
  ///
  /// In en, this message translates to:
  /// **'Beard Trim'**
  String get beardTrim;

  /// No description provided for @recommendedBarbershops.
  ///
  /// In en, this message translates to:
  /// **'Recommended Barbershops'**
  String get recommendedBarbershops;

  /// Filter for barbers near the user
  ///
  /// In en, this message translates to:
  /// **'Near Me'**
  String get nearMe;

  /// Filter for top rated barbers
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// Filter for VIP barbers
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get vipBarbers;

  /// Filter for barbers accepting card payments
  ///
  /// In en, this message translates to:
  /// **'Accept Card'**
  String get acceptCard;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write review'**
  String get writeReview;

  /// No description provided for @nearYou.
  ///
  /// In en, this message translates to:
  /// **'near you'**
  String get nearYou;

  /// Filter for barbers open early
  ///
  /// In en, this message translates to:
  /// **'Open Early'**
  String get openEarly;

  /// Filter for barbers specializing in kids haircut
  ///
  /// In en, this message translates to:
  /// **'Kids Haircut'**
  String get kidsHaircut;

  /// Filter for barbers open late
  ///
  /// In en, this message translates to:
  /// **'Open Late'**
  String get openLate;

  /// Filter for affordable barbers
  ///
  /// In en, this message translates to:
  /// **'Affordable'**
  String get affordable;

  /// No description provided for @cityCasablanca.
  ///
  /// In en, this message translates to:
  /// **'Casablanca'**
  String get cityCasablanca;

  /// No description provided for @cityRabat.
  ///
  /// In en, this message translates to:
  /// **'Rabat'**
  String get cityRabat;

  /// No description provided for @cityMarrakech.
  ///
  /// In en, this message translates to:
  /// **'Marrakech'**
  String get cityMarrakech;

  /// No description provided for @findBarbers.
  ///
  /// In en, this message translates to:
  /// **'Find Barbers'**
  String get findBarbers;

  /// No description provided for @searchBarPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search barbers or services'**
  String get searchBarPlaceholder;

  /// No description provided for @where.
  ///
  /// In en, this message translates to:
  /// **'Where ?'**
  String get where;

  /// No description provided for @when.
  ///
  /// In en, this message translates to:
  /// **'When ?'**
  String get when;

  /// No description provided for @selectServicesForOneBarberOnly.
  ///
  /// In en, this message translates to:
  /// **'Please select services for one barber only'**
  String get selectServicesForOneBarberOnly;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @barberDetails.
  ///
  /// In en, this message translates to:
  /// **'Barber Details'**
  String get barberDetails;

  /// No description provided for @aboutBarber.
  ///
  /// In en, this message translates to:
  /// **'About Barber'**
  String get aboutBarber;

  /// No description provided for @servicesTab.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTab;

  /// No description provided for @infoTab.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoTab;

  /// No description provided for @reviewsTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTab;

  /// No description provided for @bookYourAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Your Appointment'**
  String get bookYourAppointment;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Duration of service in minutes
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String minutes(Object minutes);

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @selectService.
  ///
  /// In en, this message translates to:
  /// **'Select Service'**
  String get selectService;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// Displays barber's name
  ///
  /// In en, this message translates to:
  /// **'Barber: {name}'**
  String barberName(Object name);

  /// No description provided for @bookingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Booking in progress...'**
  String get bookingInProgress;

  /// No description provided for @selectServiceToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please select a service to continue.'**
  String get selectServiceToContinue;

  /// No description provided for @liveServiceInProgress.
  ///
  /// In en, this message translates to:
  /// **'Live service in progress'**
  String get liveServiceInProgress;

  /// No description provided for @completedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Completed successfully'**
  String get completedSuccessfully;

  /// No description provided for @confirmedByBarber.
  ///
  /// In en, this message translates to:
  /// **'Confirmed by barber'**
  String get confirmedByBarber;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @appointmentStartingNow.
  ///
  /// In en, this message translates to:
  /// **'Your appointment is starting now'**
  String get appointmentStartingNow;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get hoursShort;

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysShort;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @filterVipTooltip.
  ///
  /// In en, this message translates to:
  /// **'Only show VIP barbers'**
  String get filterVipTooltip;

  /// No description provided for @filterCardTooltip.
  ///
  /// In en, this message translates to:
  /// **'Barbers who accept card payments'**
  String get filterCardTooltip;

  /// No description provided for @filterKidsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Barbers specializing in kids’ haircuts'**
  String get filterKidsTooltip;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'Km'**
  String get km;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @mad.
  ///
  /// In en, this message translates to:
  /// **'MAD'**
  String get mad;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mins;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @reviewsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Reviews section coming soon...'**
  String get reviewsComingSoon;

  /// No description provided for @casablanca.
  ///
  /// In en, this message translates to:
  /// **'Casablanca'**
  String get casablanca;

  /// Displays the name of a city dynamically
  ///
  /// In en, this message translates to:
  /// **'{city}'**
  String cityName(Object city);

  /// No description provided for @barbershop.
  ///
  /// In en, this message translates to:
  /// **'Blasti'**
  String get barbershop;

  /// No description provided for @barberShops.
  ///
  /// In en, this message translates to:
  /// **'Barber Shops'**
  String get barberShops;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @downtownBranch.
  ///
  /// In en, this message translates to:
  /// **'Downtown Branch'**
  String get downtownBranch;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @bookingSent.
  ///
  /// In en, this message translates to:
  /// **'Your booking request was sent. You will receive a confirmation soon.'**
  String get bookingSent;

  /// Hint text for the search bar
  ///
  /// In en, this message translates to:
  /// **'Search for barbers, services...'**
  String get searchBarHint;

  /// Label for the spa service
  ///
  /// In en, this message translates to:
  /// **'Spa'**
  String get spaService;

  /// Label for the facial service
  ///
  /// In en, this message translates to:
  /// **'Facial'**
  String get facialService;

  /// Confirmation prompt asking user if they are sure to book
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to book this appointment with '**
  String get areYouSureBooking;

  /// City name: Fes
  ///
  /// In en, this message translates to:
  /// **'Fes'**
  String get cityFes;

  /// No description provided for @rabat.
  ///
  /// In en, this message translates to:
  /// **'Rabat'**
  String get rabat;

  /// No description provided for @fes.
  ///
  /// In en, this message translates to:
  /// **'Fès'**
  String get fes;

  /// No description provided for @marrakech.
  ///
  /// In en, this message translates to:
  /// **'Marrakech'**
  String get marrakech;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateTime;

  /// Name of the person who left a review
  ///
  /// In en, this message translates to:
  /// **'Review by {name}'**
  String reviewBy(Object name);

  /// No description provided for @bookingConfirmedOn.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed on'**
  String get bookingConfirmedOn;

  /// No description provided for @selectAtLeastOneService.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one service.'**
  String get selectAtLeastOneService;

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// No description provided for @bookingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Your booking request was sent. You will receive a confirmation soon.'**
  String get bookingConfirmation;

  /// No description provided for @confirmBookingNow.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBookingNow;

  /// No description provided for @areYouSureBookNow.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to book now?'**
  String get areYouSureBookNow;

  /// Used after a review to indicate the date it was written
  ///
  /// In en, this message translates to:
  /// **'on {date}'**
  String onDate(Object date);

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications Enabled'**
  String get pushNotificationsEnabled;

  /// No description provided for @pushNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications Disabled'**
  String get pushNotificationsDisabled;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @receiveEmailAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive Email Alerts'**
  String get receiveEmailAlerts;

  /// No description provided for @emailNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications Enabled'**
  String get emailNotificationsEnabled;

  /// No description provided for @emailNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications Disabled'**
  String get emailNotificationsDisabled;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @receiveSmsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive SMS Alerts'**
  String get receiveSmsAlerts;

  /// No description provided for @smsNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications Enabled'**
  String get smsNotificationsEnabled;

  /// No description provided for @smsNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications Disabled'**
  String get smsNotificationsDisabled;

  /// No description provided for @bookingReminders.
  ///
  /// In en, this message translates to:
  /// **'Booking Reminders'**
  String get bookingReminders;

  /// No description provided for @remindBeforeAppointments.
  ///
  /// In en, this message translates to:
  /// **'Remind Before Appointments'**
  String get remindBeforeAppointments;

  /// No description provided for @bookingConfirmations.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmations'**
  String get bookingConfirmations;

  /// No description provided for @notifyOnBooking.
  ///
  /// In en, this message translates to:
  /// **'Notify on Booking'**
  String get notifyOnBooking;

  /// No description provided for @cancellations.
  ///
  /// In en, this message translates to:
  /// **'Cancellations'**
  String get cancellations;

  /// No description provided for @notifyOnCancellation.
  ///
  /// In en, this message translates to:
  /// **'Notify on Cancellation'**
  String get notifyOnCancellation;

  /// No description provided for @promotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotions;

  /// No description provided for @offersAndDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Offers and Discounts'**
  String get offersAndDiscounts;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage Notifications'**
  String get manageNotifications;

  /// No description provided for @customizeNotificationAlerts.
  ///
  /// In en, this message translates to:
  /// **'Customize Notification Alerts'**
  String get customizeNotificationAlerts;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @settingsOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Settings Overview Description'**
  String get settingsOverviewDescription;

  /// No description provided for @editProfileFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Feature Coming Soon'**
  String get editProfileFeatureComingSoon;

  /// No description provided for @changePasswordFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Change Password Feature Coming Soon'**
  String get changePasswordFeatureComingSoon;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @notificationPreferencesFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences Feature Coming Soon'**
  String get notificationPreferencesFeatureComingSoon;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @languageFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language Feature Coming Soon'**
  String get languageFeatureComingSoon;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Feature Coming Soon'**
  String get deleteAccountFeatureComingSoon;

  /// No description provided for @manageYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Account'**
  String get manageYourAccount;

  /// No description provided for @updateAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Update Account Details'**
  String get updateAccountDetails;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update Personal Info'**
  String get updatePersonalInfo;

  /// No description provided for @secureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Account'**
  String get secureYourAccount;

  /// No description provided for @updateEmail.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get updateEmail;

  /// No description provided for @changeEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Change Email Address'**
  String get changeEmailAddress;

  /// No description provided for @updateEmailFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Update Email Feature Coming Soon'**
  String get updateEmailFeatureComingSoon;

  /// No description provided for @updatePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Update Phone Number'**
  String get updatePhoneNumber;

  /// No description provided for @barberRegistrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Barber registration successful'**
  String get barberRegistrationSuccessful;

  /// No description provided for @forClient.
  ///
  /// In en, this message translates to:
  /// **'For client'**
  String get forClient;

  /// No description provided for @acceptTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Accept terms and conditions'**
  String get acceptTermsAndConditions;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumber;

  /// No description provided for @updatePhoneFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Update Phone Feature Coming Soon'**
  String get updatePhoneFeatureComingSoon;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get timeRemaining;

  /// No description provided for @minutes45.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get minutes45;

  /// No description provided for @serviceDuration.
  ///
  /// In en, this message translates to:
  /// **'Service duration'**
  String get serviceDuration;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @rebookNow.
  ///
  /// In en, this message translates to:
  /// **'Re-book Now'**
  String get rebookNow;

  /// No description provided for @selectedDate.
  ///
  /// In en, this message translates to:
  /// **'Selected Date'**
  String get selectedDate;

  /// No description provided for @selectedTime.
  ///
  /// In en, this message translates to:
  /// **'Selected Time'**
  String get selectedTime;

  /// No description provided for @rebookLater.
  ///
  /// In en, this message translates to:
  /// **'Re-book Later'**
  String get rebookLater;

  /// No description provided for @rebook.
  ///
  /// In en, this message translates to:
  /// **'Re-book'**
  String get rebook;

  /// No description provided for @noServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'No Services Description'**
  String get noServicesDescription;

  /// No description provided for @noServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Services Title'**
  String get noServicesTitle;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @areYouSureDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete ?'**
  String get areYouSureDelete;

  /// No description provided for @addVacationOrDayOffExceptions.
  ///
  /// In en, this message translates to:
  /// **'Add Vacation Or Day Off Exceptions'**
  String get addVacationOrDayOffExceptions;

  /// No description provided for @addANoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a Note (Optional)'**
  String get addANoteOptional;

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit Schedule'**
  String get editSchedule;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @manageServices.
  ///
  /// In en, this message translates to:
  /// **'Manage Services'**
  String get manageServices;

  /// No description provided for @manageSchedule.
  ///
  /// In en, this message translates to:
  /// **'Manage Schedule'**
  String get manageSchedule;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @todaysRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get todaysRevenue;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// No description provided for @pleaseEnterClientName.
  ///
  /// In en, this message translates to:
  /// **'Please enter client name'**
  String get pleaseEnterClientName;

  /// No description provided for @pleaseSelectService.
  ///
  /// In en, this message translates to:
  /// **'Please select service'**
  String get pleaseSelectService;

  /// No description provided for @pleaseSelectBarber.
  ///
  /// In en, this message translates to:
  /// **'Please select barber'**
  String get pleaseSelectBarber;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes optional'**
  String get notesOptional;

  /// No description provided for @bookingAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Booking added successfully'**
  String get bookingAddedSuccessfully;

  /// No description provided for @addBooking.
  ///
  /// In en, this message translates to:
  /// **'Add booking'**
  String get addBooking;

  /// No description provided for @revenueBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Revenue breakdown'**
  String get revenueBreakdown;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch ?'**
  String get switchAccount;

  /// No description provided for @accountLinking.
  ///
  /// In en, this message translates to:
  /// **'Account linking'**
  String get accountLinking;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your account password.'**
  String get changePasswordDescription;

  /// No description provided for @editProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your profile information.'**
  String get editProfileDescription;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActions;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile information.'**
  String get failedToLoadProfile;

  /// No description provided for @unlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlink;

  /// No description provided for @accountUnlinked.
  ///
  /// In en, this message translates to:
  /// **'User account unlinked successfully.'**
  String get accountUnlinked;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @monthlyBookingTrends.
  ///
  /// In en, this message translates to:
  /// **'Monthly Booking Trends'**
  String get monthlyBookingTrends;

  /// No description provided for @averageMonthlyBookings.
  ///
  /// In en, this message translates to:
  /// **'Average Monthly Bookings'**
  String get averageMonthlyBookings;

  /// No description provided for @busiestHours.
  ///
  /// In en, this message translates to:
  /// **'Busiest Hours'**
  String get busiestHours;

  /// No description provided for @offPeakHour.
  ///
  /// In en, this message translates to:
  /// **'Off-Peak Hour'**
  String get offPeakHour;

  /// No description provided for @peakHour.
  ///
  /// In en, this message translates to:
  /// **'Peak Hour'**
  String get peakHour;

  /// No description provided for @averageWaitTime.
  ///
  /// In en, this message translates to:
  /// **'Average Wait Time'**
  String get averageWaitTime;

  /// No description provided for @keyBusinessMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Business Metrics'**
  String get keyBusinessMetrics;

  /// No description provided for @newCustomers.
  ///
  /// In en, this message translates to:
  /// **'New Customers'**
  String get newCustomers;

  /// No description provided for @completedBookings.
  ///
  /// In en, this message translates to:
  /// **'Completed Bookings'**
  String get completedBookings;

  /// No description provided for @canceledBookings.
  ///
  /// In en, this message translates to:
  /// **'Canceled Bookings'**
  String get canceledBookings;

  /// No description provided for @noShowRate.
  ///
  /// In en, this message translates to:
  /// **'No-Show Rate'**
  String get noShowRate;

  /// No description provided for @bookingsByHour.
  ///
  /// In en, this message translates to:
  /// **'Bookings by hour'**
  String get bookingsByHour;

  /// No description provided for @bookingsLast6Months.
  ///
  /// In en, this message translates to:
  /// **'Bookings last 6 months'**
  String get bookingsLast6Months;

  /// No description provided for @revenueLast6Months.
  ///
  /// In en, this message translates to:
  /// **'Revenue last 6 months'**
  String get revenueLast6Months;

  /// No description provided for @thisDayIsMarkedAsClosed.
  ///
  /// In en, this message translates to:
  /// **'This day is marked as closed.'**
  String get thisDayIsMarkedAsClosed;

  /// No description provided for @scheduleCommandCenter.
  ///
  /// In en, this message translates to:
  /// **'Schedule Management'**
  String get scheduleCommandCenter;

  /// No description provided for @monthlyBookings.
  ///
  /// In en, this message translates to:
  /// **'Monthly bookings'**
  String get monthlyBookings;

  /// No description provided for @editWeeklyTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit Weekly Template'**
  String get editWeeklyTemplate;

  /// No description provided for @dayOff.
  ///
  /// In en, this message translates to:
  /// **'Day Off'**
  String get dayOff;

  /// No description provided for @defaultHours.
  ///
  /// In en, this message translates to:
  /// **'Default Hours'**
  String get defaultHours;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @removeBreak.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeBreak;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @setBreakTime.
  ///
  /// In en, this message translates to:
  /// **'Set break time'**
  String get setBreakTime;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @theseSlotsWillBeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'These slots will be unavailable'**
  String get theseSlotsWillBeUnavailable;

  /// No description provided for @takeABreak.
  ///
  /// In en, this message translates to:
  /// **'Break ?'**
  String get takeABreak;

  /// No description provided for @selectBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Select break duration'**
  String get selectBreakDuration;

  /// No description provided for @endBreakEarly.
  ///
  /// In en, this message translates to:
  /// **'End break early'**
  String get endBreakEarly;

  /// No description provided for @onBreak.
  ///
  /// In en, this message translates to:
  /// **'On break'**
  String get onBreak;

  /// No description provided for @noAbsencesScheduled.
  ///
  /// In en, this message translates to:
  /// **'No absences scheduled'**
  String get noAbsencesScheduled;

  /// No description provided for @addAbsence.
  ///
  /// In en, this message translates to:
  /// **'Add absence'**
  String get addAbsence;

  /// No description provided for @blockDateRangesForHolidays.
  ///
  /// In en, this message translates to:
  /// **'Block date ranges for holidays'**
  String get blockDateRangesForHolidays;

  /// No description provided for @manageAbsences.
  ///
  /// In en, this message translates to:
  /// **'Manage absences'**
  String get manageAbsences;

  /// No description provided for @setBreak.
  ///
  /// In en, this message translates to:
  /// **'Set break'**
  String get setBreak;

  /// No description provided for @customBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Custom break duration'**
  String get customBreakDuration;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @quickTools.
  ///
  /// In en, this message translates to:
  /// **'Quick tools'**
  String get quickTools;

  /// No description provided for @addNewBooking.
  ///
  /// In en, this message translates to:
  /// **' Booking'**
  String get addNewBooking;

  /// No description provided for @addNewService.
  ///
  /// In en, this message translates to:
  /// **'Add new service'**
  String get addNewService;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @yourFocusForToday.
  ///
  /// In en, this message translates to:
  /// **'Your Focus for Today'**
  String get yourFocusForToday;

  /// No description provided for @newClients.
  ///
  /// In en, this message translates to:
  /// **'New clients'**
  String get newClients;

  /// No description provided for @scheduleGaps.
  ///
  /// In en, this message translates to:
  /// **'Schedule Gaps'**
  String get scheduleGaps;

  /// No description provided for @upcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bookings'**
  String get upcomingBookings;

  /// No description provided for @noBookingsInSection.
  ///
  /// In en, this message translates to:
  /// **'No bookings in this section'**
  String get noBookingsInSection;

  /// No description provided for @startedAt.
  ///
  /// In en, this message translates to:
  /// **'Started at'**
  String get startedAt;

  /// No description provided for @estimatedCompletion.
  ///
  /// In en, this message translates to:
  /// **'Est. Completion'**
  String get estimatedCompletion;

  /// No description provided for @selectTimeToPostpone.
  ///
  /// In en, this message translates to:
  /// **'Select a time to postpone by, or enter a custom amount in minutes.'**
  String get selectTimeToPostpone;

  /// No description provided for @surePostponeBy.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to postpone by'**
  String get surePostponeBy;

  /// No description provided for @rescheduledBy.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled by'**
  String get rescheduledBy;

  /// No description provided for @customMinutes.
  ///
  /// In en, this message translates to:
  /// **'Custom Minutes'**
  String get customMinutes;

  /// No description provided for @seeAllAction.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAllAction;

  /// No description provided for @forMenAction.
  ///
  /// In en, this message translates to:
  /// **'For Men'**
  String get forMenAction;

  /// No description provided for @forWomenAction.
  ///
  /// In en, this message translates to:
  /// **'For Women'**
  String get forWomenAction;

  /// No description provided for @professionals.
  ///
  /// In en, this message translates to:
  /// **'Professionals'**
  String get professionals;

  /// No description provided for @haircutAction.
  ///
  /// In en, this message translates to:
  /// **'Haircut'**
  String get haircutAction;

  /// No description provided for @professionalsList.
  ///
  /// In en, this message translates to:
  /// **'Professionals List'**
  String get professionalsList;

  /// No description provided for @hire.
  ///
  /// In en, this message translates to:
  /// **'Hire'**
  String get hire;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @myProfessionals.
  ///
  /// In en, this message translates to:
  /// **'My Professionals'**
  String get myProfessionals;

  /// No description provided for @filteredProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Filtered Professionals'**
  String get filteredProfessionals;

  /// No description provided for @managementTip.
  ///
  /// In en, this message translates to:
  /// **'Management Tip'**
  String get managementTip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @hired.
  ///
  /// In en, this message translates to:
  /// **'Hired'**
  String get hired;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any additional notes here'**
  String get additionalNotesHint;

  /// No description provided for @customAgreement.
  ///
  /// In en, this message translates to:
  /// **'Custom Agreement'**
  String get customAgreement;

  /// No description provided for @longTerm.
  ///
  /// In en, this message translates to:
  /// **'Long Term'**
  String get longTerm;

  /// No description provided for @shortTerm.
  ///
  /// In en, this message translates to:
  /// **'Short Term'**
  String get shortTerm;

  /// No description provided for @trialPeriod.
  ///
  /// In en, this message translates to:
  /// **'Trial Period'**
  String get trialPeriod;

  /// No description provided for @noProfessionalsMatchCriteria.
  ///
  /// In en, this message translates to:
  /// **'No professionals match criteria'**
  String get noProfessionalsMatchCriteria;

  /// No description provided for @professionalsFound.
  ///
  /// In en, this message translates to:
  /// **'Professionals found'**
  String get professionalsFound;

  /// No description provided for @findAvailableProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Find available professionals'**
  String get findAvailableProfessionals;

  /// No description provided for @availableCandidates.
  ///
  /// In en, this message translates to:
  /// **'Available Candidates'**
  String get availableCandidates;

  /// No description provided for @hiredProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Hired Professionals'**
  String get hiredProfessionals;

  /// No description provided for @availableSeats.
  ///
  /// In en, this message translates to:
  /// **'Available Seats'**
  String get availableSeats;

  /// No description provided for @totalSeats.
  ///
  /// In en, this message translates to:
  /// **'Total Seats'**
  String get totalSeats;

  /// No description provided for @completeProfilePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile'**
  String get completeProfilePrompt;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @completeProfileForDetails.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to view details'**
  String get completeProfileForDetails;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @incompleteProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Your profile is incomplete. Please update it to continue.'**
  String get incompleteProfileMessage;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerName;

  /// No description provided for @viewContract.
  ///
  /// In en, this message translates to:
  /// **'View Contract'**
  String get viewContract;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get editDetails;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @filteredCandidates.
  ///
  /// In en, this message translates to:
  /// **'Filtered Candidates'**
  String get filteredCandidates;

  /// No description provided for @hiringTip.
  ///
  /// In en, this message translates to:
  /// **'Hiring Tip'**
  String get hiringTip;

  /// No description provided for @removeFromStaff.
  ///
  /// In en, this message translates to:
  /// **'Remove from Staff'**
  String get removeFromStaff;

  /// No description provided for @hireNewProfessional.
  ///
  /// In en, this message translates to:
  /// **'Hire New Professional'**
  String get hireNewProfessional;

  /// No description provided for @selectHiringDetails.
  ///
  /// In en, this message translates to:
  /// **'Select hiring details'**
  String get selectHiringDetails;

  /// No description provided for @confirmHire.
  ///
  /// In en, this message translates to:
  /// **'Confirm hire'**
  String get confirmHire;

  /// No description provided for @navigateToHireProfessionalsScreen.
  ///
  /// In en, this message translates to:
  /// **'Navigating to professionals hiring screen...'**
  String get navigateToHireProfessionalsScreen;

  /// No description provided for @barbershopDetails.
  ///
  /// In en, this message translates to:
  /// **'Barbershop Details'**
  String get barbershopDetails;

  /// No description provided for @hireConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Hire confirmation message'**
  String get hireConfirmationMessage;

  /// No description provided for @offerSentTo.
  ///
  /// In en, this message translates to:
  /// **'Offer sent to'**
  String get offerSentTo;

  /// No description provided for @emailing.
  ///
  /// In en, this message translates to:
  /// **'Emailing'**
  String get emailing;

  /// No description provided for @calling.
  ///
  /// In en, this message translates to:
  /// **'Calling'**
  String get calling;

  /// No description provided for @avgTeamRating.
  ///
  /// In en, this message translates to:
  /// **'Avg team rating'**
  String get avgTeamRating;

  /// No description provided for @totalServicesOffered.
  ///
  /// In en, this message translates to:
  /// **'Total services offered'**
  String get totalServicesOffered;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @fromYourStaff.
  ///
  /// In en, this message translates to:
  /// **'From your staff'**
  String get fromYourStaff;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @removeConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this professional?'**
  String get removeConfirmationMessage;

  /// No description provided for @confirmRemoval.
  ///
  /// In en, this message translates to:
  /// **'Confirm Removal'**
  String get confirmRemoval;

  /// No description provided for @removedFromStaff.
  ///
  /// In en, this message translates to:
  /// **'Removed from Staff'**
  String get removedFromStaff;

  /// No description provided for @contractType.
  ///
  /// In en, this message translates to:
  /// **'Contract Type'**
  String get contractType;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @candidates.
  ///
  /// In en, this message translates to:
  /// **'Candidates'**
  String get candidates;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @avgTeamExperience.
  ///
  /// In en, this message translates to:
  /// **'Avg. Team Experience'**
  String get avgTeamExperience;

  /// No description provided for @hiresThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Hires This Month'**
  String get hiresThisMonth;

  /// No description provided for @noProfessionalsFound.
  ///
  /// In en, this message translates to:
  /// **'No Professionals Found'**
  String get noProfessionalsFound;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @hireProfessional.
  ///
  /// In en, this message translates to:
  /// **'Hire Professional'**
  String get hireProfessional;

  /// No description provided for @occupiedSeats.
  ///
  /// In en, this message translates to:
  /// **'Occupied Seats'**
  String get occupiedSeats;

  /// No description provided for @seatsOverview.
  ///
  /// In en, this message translates to:
  /// **'Seats Overview'**
  String get seatsOverview;

  /// No description provided for @searchProfessionalsHint.
  ///
  /// In en, this message translates to:
  /// **'Search professionals…'**
  String get searchProfessionalsHint;

  /// No description provided for @bookingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been scheduled successfully.'**
  String get bookingScheduled;

  /// No description provided for @selectDateTimeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a date and time first.'**
  String get selectDateTimeFirst;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @andText.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get andText;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get more;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @selectServices.
  ///
  /// In en, this message translates to:
  /// **'select services'**
  String get selectServices;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @saloonsBarbersServices.
  ///
  /// In en, this message translates to:
  /// **'Salons & Barbers & Services ...'**
  String get saloonsBarbersServices;

  /// No description provided for @bookLaterConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to confirm this booking for later?'**
  String get bookLaterConfirmation;

  /// No description provided for @selectedDateTime.
  ///
  /// In en, this message translates to:
  /// **'Selected Date & Time'**
  String get selectedDateTime;

  /// No description provided for @bookingScheduledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your booking was scheduled successfully.'**
  String get bookingScheduledSuccessfully;

  /// No description provided for @checkOutPost.
  ///
  /// In en, this message translates to:
  /// **'Check Out Post'**
  String get checkOutPost;

  /// No description provided for @professionalsPosts.
  ///
  /// In en, this message translates to:
  /// **'Professionals\' Posts'**
  String get professionalsPosts;

  /// No description provided for @shaveAction.
  ///
  /// In en, this message translates to:
  /// **'Shave'**
  String get shaveAction;

  /// No description provided for @addCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addCommentHint;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @translateFilter.
  ///
  /// In en, this message translates to:
  /// **'Translate Filter'**
  String get translateFilter;

  /// No description provided for @beardTrimAction.
  ///
  /// In en, this message translates to:
  /// **'Beard Trim'**
  String get beardTrimAction;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts available'**
  String get noPosts;

  /// No description provided for @coloringAction.
  ///
  /// In en, this message translates to:
  /// **'Coloring'**
  String get coloringAction;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @treatmentAction.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatmentAction;

  /// No description provided for @addTimeToBooking.
  ///
  /// In en, this message translates to:
  /// **'Add Time to Booking'**
  String get addTimeToBooking;

  /// No description provided for @selectTimeToAdd.
  ///
  /// In en, this message translates to:
  /// **'Select a time to add, or enter a custom amount in minutes.'**
  String get selectTimeToAdd;

  /// No description provided for @sureAddMinutes.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to add'**
  String get sureAddMinutes;

  /// No description provided for @toThisBooking.
  ///
  /// In en, this message translates to:
  /// **'to this booking'**
  String get toThisBooking;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @errorSubmittingBooking.
  ///
  /// In en, this message translates to:
  /// **'Error Submitting Booking'**
  String get errorSubmittingBooking;

  /// No description provided for @forService.
  ///
  /// In en, this message translates to:
  /// **'For Service'**
  String get forService;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @scheduleBooking.
  ///
  /// In en, this message translates to:
  /// **'Schedule Booking'**
  String get scheduleBooking;

  /// No description provided for @selectedServices.
  ///
  /// In en, this message translates to:
  /// **'Selected Services'**
  String get selectedServices;

  /// No description provided for @bookingConfirmedNowMultipleServices.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed now for multiple services.'**
  String get bookingConfirmedNowMultipleServices;

  /// No description provided for @barberHasNoServicesDefined.
  ///
  /// In en, this message translates to:
  /// **'This barber has no services defined.'**
  String get barberHasNoServicesDefined;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @areYouSureBookingForService.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to book this service?'**
  String get areYouSureBookingForService;

  /// No description provided for @bookingConfirmedNowForService.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed now for {service}.'**
  String bookingConfirmedNowForService(Object service);

  /// No description provided for @searchClients.
  ///
  /// In en, this message translates to:
  /// **'Search Clients'**
  String get searchClients;

  /// No description provided for @errorSubmittingReview.
  ///
  /// In en, this message translates to:
  /// **'Error submitting review.'**
  String get errorSubmittingReview;

  /// No description provided for @reviewSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully.'**
  String get reviewSubmittedSuccessfully;

  /// No description provided for @youCanOnlyReviewBarbersYouHaveBookedWithCompletedBooking.
  ///
  /// In en, this message translates to:
  /// **'You can only review barbers you have booked with completed booking.'**
  String get youCanOnlyReviewBarbersYouHaveBookedWithCompletedBooking;

  /// No description provided for @errorCheckingBookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Error checking booking history.'**
  String get errorCheckingBookingHistory;

  /// No description provided for @youNeedToBeLoggedInToReview.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to review.'**
  String get youNeedToBeLoggedInToReview;

  /// No description provided for @pleaseEnterYourReview.
  ///
  /// In en, this message translates to:
  /// **'Please enter your review.'**
  String get pleaseEnterYourReview;

  /// No description provided for @clientOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Client Opportunities'**
  String get clientOpportunities;

  /// No description provided for @bookAgain.
  ///
  /// In en, this message translates to:
  /// **'Book Again'**
  String get bookAgain;

  /// No description provided for @highValue.
  ///
  /// In en, this message translates to:
  /// **'High Value'**
  String get highValue;

  /// No description provided for @quickFilters.
  ///
  /// In en, this message translates to:
  /// **'Quick Filters'**
  String get quickFilters;

  /// No description provided for @allClients.
  ///
  /// In en, this message translates to:
  /// **'All Clients'**
  String get allClients;

  /// No description provided for @regulars.
  ///
  /// In en, this message translates to:
  /// **'Regulars'**
  String get regulars;

  /// No description provided for @noClientsMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No clients match the selected filter.'**
  String get noClientsMatchFilter;

  /// No description provided for @noClientsFound.
  ///
  /// In en, this message translates to:
  /// **'No Clients Found'**
  String get noClientsFound;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSince;

  /// No description provided for @lastVisit.
  ///
  /// In en, this message translates to:
  /// **'Last Visit'**
  String get lastVisit;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @sendReminder.
  ///
  /// In en, this message translates to:
  /// **'Send Reminder'**
  String get sendReminder;

  /// No description provided for @confirmReminder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reminder'**
  String get confirmReminder;

  /// No description provided for @sendReminderTo.
  ///
  /// In en, this message translates to:
  /// **'Send a booking reminder to'**
  String get sendReminderTo;

  /// No description provided for @forTheirAppointmentOn.
  ///
  /// In en, this message translates to:
  /// **'for their appointment on'**
  String get forTheirAppointmentOn;

  /// No description provided for @yourServices.
  ///
  /// In en, this message translates to:
  /// **'Your Services'**
  String get yourServices;

  /// No description provided for @serviceIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Service Intelligence'**
  String get serviceIntelligence;

  /// No description provided for @mostBooked.
  ///
  /// In en, this message translates to:
  /// **'Most Booked'**
  String get mostBooked;

  /// No description provided for @topEarners.
  ///
  /// In en, this message translates to:
  /// **'Top Earners'**
  String get topEarners;

  /// No description provided for @revenueReport.
  ///
  /// In en, this message translates to:
  /// **'Revenue Report'**
  String get revenueReport;

  /// No description provided for @trackYourEarningsOverTime.
  ///
  /// In en, this message translates to:
  /// **'Track Your Earnings Over Time'**
  String get trackYourEarningsOverTime;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @yearlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Yearly Revenue'**
  String get yearlyRevenue;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// No description provided for @averageRevenue.
  ///
  /// In en, this message translates to:
  /// **'Average Revenue'**
  String get averageRevenue;

  /// No description provided for @bestPeriod.
  ///
  /// In en, this message translates to:
  /// **'Best Period'**
  String get bestPeriod;

  /// No description provided for @lowestPeriod.
  ///
  /// In en, this message translates to:
  /// **'Lowest Period'**
  String get lowestPeriod;

  /// No description provided for @keyInsights.
  ///
  /// In en, this message translates to:
  /// **'Key Insights'**
  String get keyInsights;

  /// No description provided for @maximizePeakPerformance.
  ///
  /// In en, this message translates to:
  /// **'Maximize Peak Performance'**
  String get maximizePeakPerformance;

  /// No description provided for @yourMostProfitablePeriod.
  ///
  /// In en, this message translates to:
  /// **'Your most profitable period is'**
  String get yourMostProfitablePeriod;

  /// No description provided for @considerRunningPromotions.
  ///
  /// In en, this message translates to:
  /// **'Consider running promotions or extending hours during this time to further boost earnings.'**
  String get considerRunningPromotions;

  /// No description provided for @boostQuieterTimes.
  ///
  /// In en, this message translates to:
  /// **'Boost Quieter Times'**
  String get boostQuieterTimes;

  /// No description provided for @engageClientsDuringSlowerPeriods.
  ///
  /// In en, this message translates to:
  /// **'Engage clients during slower periods like'**
  String get engageClientsDuringSlowerPeriods;

  /// No description provided for @withSpecialOffers.
  ///
  /// In en, this message translates to:
  /// **'with special offers, such as a \'Mid-Week Discount\' or loyalty rewards.'**
  String get withSpecialOffers;

  /// No description provided for @weeklyAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weeklyAbbreviation;

  /// No description provided for @monthlyAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get monthlyAbbreviation;

  /// No description provided for @yearlyAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get yearlyAbbreviation;

  /// No description provided for @unlinkUserAccount.
  ///
  /// In en, this message translates to:
  /// **'Unlink user account'**
  String get unlinkUserAccount;

  /// No description provided for @linkUserAccount.
  ///
  /// In en, this message translates to:
  /// **'Link user account'**
  String get linkUserAccount;

  /// No description provided for @unlinkUserAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlink user account description'**
  String get unlinkUserAccountDescription;

  /// No description provided for @linkUserAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Link user account description'**
  String get linkUserAccountDescription;

  /// No description provided for @unlinkUserAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlink this account?'**
  String get unlinkUserAccountConfirmation;

  /// No description provided for @linkUserAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to link this account?'**
  String get linkUserAccountConfirmation;

  /// No description provided for @accountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account linked.'**
  String get accountLinked;

  /// No description provided for @failedToLinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to link/unlink account. Please try again.'**
  String get failedToLinkAccount;

  /// No description provided for @servicePremiumHaircut.
  ///
  /// In en, this message translates to:
  /// **'Premium Haircut'**
  String get servicePremiumHaircut;

  /// No description provided for @serviceClassicShave.
  ///
  /// In en, this message translates to:
  /// **'Classic Shave'**
  String get serviceClassicShave;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile'**
  String get couldNotLoadProfile;

  /// No description provided for @noBioAvailable.
  ///
  /// In en, this message translates to:
  /// **'No bio available'**
  String get noBioAvailable;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @pendingBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Bookings'**
  String get pendingBookingsTitle;

  /// No description provided for @tabNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get tabNew;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @noRequestsHere.
  ///
  /// In en, this message translates to:
  /// **'No requests here'**
  String get noRequestsHere;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'MAD'**
  String get currency;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @minutesLong.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutesLong;

  /// No description provided for @buttonReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get buttonReschedule;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get buttonConfirm;

  /// No description provided for @buttonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get buttonClose;

  /// No description provided for @detailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get detailStatus;

  /// No description provided for @tagExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get tagExpert;

  /// No description provided for @tagSpecialOffer.
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get tagSpecialOffer;

  /// No description provided for @tagPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get tagPopular;

  /// No description provided for @tagTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get tagTrending;

  /// No description provided for @tagRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get tagRecommended;

  /// No description provided for @tagVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get tagVip;

  /// No description provided for @totalVisits.
  ///
  /// In en, this message translates to:
  /// **'Total Visits'**
  String get totalVisits;

  /// No description provided for @needsFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Needs Follow-Up'**
  String get needsFollowUp;

  /// No description provided for @studentDiscount.
  ///
  /// In en, this message translates to:
  /// **'Student Discount'**
  String get studentDiscount;

  /// No description provided for @newClient.
  ///
  /// In en, this message translates to:
  /// **'New Client'**
  String get newClient;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @classicCut.
  ///
  /// In en, this message translates to:
  /// **'Classic Cut'**
  String get classicCut;

  /// No description provided for @servicePremiumBeardTrim.
  ///
  /// In en, this message translates to:
  /// **'Premium Beard Trim'**
  String get servicePremiumBeardTrim;

  /// No description provided for @servicePremiumBeardTrimDesc.
  ///
  /// In en, this message translates to:
  /// **'A precise beard trim with premium care oils.'**
  String get servicePremiumBeardTrimDesc;

  /// No description provided for @serviceClassicHaircut.
  ///
  /// In en, this message translates to:
  /// **'Classic Haircut'**
  String get serviceClassicHaircut;

  /// No description provided for @serviceClassicHaircutDesc.
  ///
  /// In en, this message translates to:
  /// **'A timeless haircut tailored to your style.'**
  String get serviceClassicHaircutDesc;

  /// No description provided for @serviceWeekendManicure.
  ///
  /// In en, this message translates to:
  /// **'Weekend Manicure'**
  String get serviceWeekendManicure;

  /// No description provided for @serviceWeekendManicureDesc.
  ///
  /// In en, this message translates to:
  /// **'Relaxing manicure service for the weekend.'**
  String get serviceWeekendManicureDesc;

  /// No description provided for @needsExtraTime.
  ///
  /// In en, this message translates to:
  /// **'Needs extra time'**
  String get needsExtraTime;

  /// No description provided for @allergicToProducts.
  ///
  /// In en, this message translates to:
  /// **'Allergic to products'**
  String get allergicToProducts;

  /// No description provided for @prefersSpecificBrand.
  ///
  /// In en, this message translates to:
  /// **'Prefers specific brand'**
  String get prefersSpecificBrand;

  /// No description provided for @premiumBeardTrim.
  ///
  /// In en, this message translates to:
  /// **'Premium beard trim'**
  String get premiumBeardTrim;

  /// No description provided for @serviceHotTowelShave.
  ///
  /// In en, this message translates to:
  /// **'Hot Towel Shave'**
  String get serviceHotTowelShave;

  /// No description provided for @serviceHotTowelShaveDesc.
  ///
  /// In en, this message translates to:
  /// **'Traditional shave with hot towel treatment.'**
  String get serviceHotTowelShaveDesc;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get october;

  /// No description provided for @forText.
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get forText;

  /// No description provided for @toBookingFor.
  ///
  /// In en, this message translates to:
  /// **'to Booking For'**
  String get toBookingFor;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get december;

  /// No description provided for @serviceFullBodyWaxing.
  ///
  /// In en, this message translates to:
  /// **'Full Body Waxing'**
  String get serviceFullBodyWaxing;

  /// No description provided for @serviceFullBodyWaxingDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete body waxing for smooth skin.'**
  String get serviceFullBodyWaxingDesc;

  /// No description provided for @serviceWomanHairColoring.
  ///
  /// In en, this message translates to:
  /// **'Hair Coloring (Women)'**
  String get serviceWomanHairColoring;

  /// No description provided for @serviceWomanHairColoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Professional hair coloring with vibrant shades.'**
  String get serviceWomanHairColoringDesc;

  /// No description provided for @fadeHaircut.
  ///
  /// In en, this message translates to:
  /// **'Fade Haircut'**
  String get fadeHaircut;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get january;

  /// No description provided for @editClient.
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editClient;

  /// No description provided for @editing.
  ///
  /// In en, this message translates to:
  /// **'Editing...'**
  String get editing;

  /// No description provided for @clientUpdated.
  ///
  /// In en, this message translates to:
  /// **'Client information updated successfully.'**
  String get clientUpdated;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get june;

  /// No description provided for @noShopName.
  ///
  /// In en, this message translates to:
  /// **'No Shop Name'**
  String get noShopName;

  /// No description provided for @assignTagsOptional.
  ///
  /// In en, this message translates to:
  /// **'Assign tags (optional)'**
  String get assignTagsOptional;

  /// No description provided for @uploadServiceImage.
  ///
  /// In en, this message translates to:
  /// **'Upload service image'**
  String get uploadServiceImage;

  /// No description provided for @updateServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Update Service'**
  String get updateServiceButton;

  /// No description provided for @addServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addServiceButton;

  /// No description provided for @formLabelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get formLabelDescription;

  /// No description provided for @formSuffixMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get formSuffixMinutes;

  /// No description provided for @formValidationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get formValidationRequired;

  /// No description provided for @formLabelDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get formLabelDuration;

  /// No description provided for @formLabelPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get formLabelPrice;

  /// No description provided for @formValidationEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get formValidationEnterName;

  /// No description provided for @formLabelServiceName.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get formLabelServiceName;

  /// No description provided for @editServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editServiceTitle;

  /// No description provided for @createServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Service'**
  String get createServiceTitle;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @detailService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get detailService;

  /// No description provided for @detailTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get detailTime;

  /// No description provided for @detailPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get detailPrice;

  /// No description provided for @detailDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get detailDuration;

  /// No description provided for @bookingConfirmedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmedSnackbar;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBookingTitle;

  /// No description provided for @bookingCanceledSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Booking Canceled'**
  String get bookingCanceledSnackbar;

  /// No description provided for @rescheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Booking'**
  String get rescheduleTitle;

  /// No description provided for @rescheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'Select a time to postpone by, or enter a custom amount in minutes.'**
  String get rescheduleMessage;

  /// No description provided for @rescheduleConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to postpone '**
  String get rescheduleConfirmMessage;

  /// No description provided for @rescheduledSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled '**
  String get rescheduledSnackbar;

  /// No description provided for @customMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Minutes'**
  String get customMinutesLabel;

  /// No description provided for @dialogNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get dialogNo;

  /// No description provided for @dialogYesImSure.
  ///
  /// In en, this message translates to:
  /// **'Yes, I\'m Sure'**
  String get dialogYesImSure;

  /// No description provided for @statYearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get statYearsOfExperience;

  /// No description provided for @statCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get statCompletionRate;

  /// No description provided for @statAverageRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get statAverageRating;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete account description'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Warning'**
  String get deleteAccountWarning;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted.'**
  String get accountDeleted;

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get failedToDeleteAccount;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to'**
  String get languageChangedTo;

  /// No description provided for @themeChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Theme changed to'**
  String get themeChangedTo;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// No description provided for @pleaseEnterValidYears.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid years'**
  String get pleaseEnterValidYears;

  /// No description provided for @instagramHandle.
  ///
  /// In en, this message translates to:
  /// **'Instagram Handle'**
  String get instagramHandle;

  /// No description provided for @socialAndWebsite.
  ///
  /// In en, this message translates to:
  /// **'Social & Website'**
  String get socialAndWebsite;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @quickest.
  ///
  /// In en, this message translates to:
  /// **'Quickest'**
  String get quickest;

  /// No description provided for @noServicesMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No services match the selected filter.'**
  String get noServicesMatchFilter;

  /// No description provided for @deleteService.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get deleteService;

  /// No description provided for @sureDeleteService.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get sureDeleteService;

  /// No description provided for @serviceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Service Deleted'**
  String get serviceDeleted;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yesDelete;

  /// No description provided for @noDescriptionProvided.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvided;

  /// No description provided for @reminderSent.
  ///
  /// In en, this message translates to:
  /// **'Reminder Sent!'**
  String get reminderSent;

  /// No description provided for @yesSendReminder.
  ///
  /// In en, this message translates to:
  /// **'Yes, Send Reminder'**
  String get yesSendReminder;

  /// No description provided for @addNewClient.
  ///
  /// In en, this message translates to:
  /// **'Add New Client'**
  String get addNewClient;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @setUpcomingBooking.
  ///
  /// In en, this message translates to:
  /// **'Set Upcoming Booking (Optional)'**
  String get setUpcomingBooking;

  /// No description provided for @favoriteService.
  ///
  /// In en, this message translates to:
  /// **'Favorite Service'**
  String get favoriteService;

  /// No description provided for @assignTags.
  ///
  /// In en, this message translates to:
  /// **'Assign Tags (Optional)'**
  String get assignTags;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Notes (e.g., hair type, preferences)'**
  String get notesPlaceholder;

  /// No description provided for @clientAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Client Added Successfully!'**
  String get clientAddedSuccessfully;

  /// No description provided for @saveClient.
  ///
  /// In en, this message translates to:
  /// **'Save Client'**
  String get saveClient;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get on;

  /// No description provided for @sureCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking? The client will be notified.'**
  String get sureCancelBooking;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @sureMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this booking as complete?'**
  String get sureMarkComplete;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @yesImSure.
  ///
  /// In en, this message translates to:
  /// **'Yes, I\'m Sure'**
  String get yesImSure;

  /// No description provided for @remind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remind;

  /// No description provided for @forTheirAppointmentAt.
  ///
  /// In en, this message translates to:
  /// **'for their appointment at'**
  String get forTheirAppointmentAt;

  /// No description provided for @reminderSentTo.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent to'**
  String get reminderSentTo;

  /// No description provided for @yesRemind.
  ///
  /// In en, this message translates to:
  /// **'Yes, Remind'**
  String get yesRemind;

  /// No description provided for @clientSince.
  ///
  /// In en, this message translates to:
  /// **'Client since'**
  String get clientSince;

  /// No description provided for @breakTime.
  ///
  /// In en, this message translates to:
  /// **'Break time'**
  String get breakTime;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @newBookings.
  ///
  /// In en, this message translates to:
  /// **'New Bookings'**
  String get newBookings;

  /// No description provided for @dayStatus.
  ///
  /// In en, this message translates to:
  /// **'Day Status'**
  String get dayStatus;

  /// No description provided for @thisIsAdayOff.
  ///
  /// In en, this message translates to:
  /// **'This is a day off'**
  String get thisIsAdayOff;

  /// No description provided for @thisScheduleWillApplyToAllWeeks.
  ///
  /// In en, this message translates to:
  /// **'This schedule will apply to all weeks'**
  String get thisScheduleWillApplyToAllWeeks;

  /// No description provided for @scheduleSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved successfully'**
  String get scheduleSavedSuccessfully;

  /// No description provided for @saveTemplate.
  ///
  /// In en, this message translates to:
  /// **'Save template'**
  String get saveTemplate;

  /// No description provided for @growthRateAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Growth Rate Analysis'**
  String get growthRateAnalysis;

  /// No description provided for @monthlyGrowthRate.
  ///
  /// In en, this message translates to:
  /// **'Monthly Growth Rate'**
  String get monthlyGrowthRate;

  /// No description provided for @yearlyGrowthRate.
  ///
  /// In en, this message translates to:
  /// **'Yearly Growth Rate'**
  String get yearlyGrowthRate;

  /// No description provided for @totalReviews.
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get totalReviews;

  /// No description provided for @performanceDetails.
  ///
  /// In en, this message translates to:
  /// **'Performance Details'**
  String get performanceDetails;

  /// No description provided for @detailedPerformanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Detailed Performance Metrics'**
  String get detailedPerformanceMetrics;

  /// No description provided for @onTimeArrival.
  ///
  /// In en, this message translates to:
  /// **'On-Time Arrival'**
  String get onTimeArrival;

  /// No description provided for @averageServiceTime.
  ///
  /// In en, this message translates to:
  /// **'Average Service Time'**
  String get averageServiceTime;

  /// No description provided for @rebookingRate.
  ///
  /// In en, this message translates to:
  /// **'Rebooking Rate'**
  String get rebookingRate;

  /// No description provided for @efficiencyInsights.
  ///
  /// In en, this message translates to:
  /// **'Efficiency Insights'**
  String get efficiencyInsights;

  /// No description provided for @improveServiceSpeed.
  ///
  /// In en, this message translates to:
  /// **'Improve Service Speed'**
  String get improveServiceSpeed;

  /// No description provided for @boostCustomerRetention.
  ///
  /// In en, this message translates to:
  /// **'Boost Customer Retention'**
  String get boostCustomerRetention;

  /// No description provided for @notificationSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage how you receive notifications for bookings, reminders, and promotions.'**
  String get notificationSettingsDescription;

  /// No description provided for @settingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your settings have been updated successfully.'**
  String get settingsUpdated;

  /// No description provided for @bookingRequestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified when you receive new booking requests.'**
  String get bookingRequestsDescription;

  /// No description provided for @appointmentReminders.
  ///
  /// In en, this message translates to:
  /// **'Appointment Reminders'**
  String get appointmentReminders;

  /// No description provided for @appointmentRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders before your appointments.'**
  String get appointmentRemindersDescription;

  /// No description provided for @messagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay updated when you receive new messages.'**
  String get messagesDescription;

  /// No description provided for @promotionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Be the first to know about special offers and promotions.'**
  String get promotionsDescription;

  /// No description provided for @notificationDelivery.
  ///
  /// In en, this message translates to:
  /// **'Notification Delivery'**
  String get notificationDelivery;

  /// No description provided for @appOpenOnly.
  ///
  /// In en, this message translates to:
  /// **'App Open Only'**
  String get appOpenOnly;

  /// No description provided for @appOpenOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'You will only receive notifications when the app is open.'**
  String get appOpenOnlyDescription;

  /// No description provided for @newPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'New password changed.'**
  String get newPasswordChanged;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon.'**
  String get featureComingSoon;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeAppLanguage;

  /// No description provided for @deleteAccountWarningShort.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountWarningShort;

  /// No description provided for @dailyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Daily breakdown'**
  String get dailyBreakdown;

  /// No description provided for @ratingBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Rating breakdown'**
  String get ratingBreakdown;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @switchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get switchToLightMode;

  /// No description provided for @switchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get switchToDarkMode;

  /// No description provided for @darkModeToggle.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode Toggle'**
  String get darkModeToggle;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Generic Error'**
  String get genericError;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Please enter service name'**
  String get pleaseEnterServiceName;

  /// No description provided for @pleaseEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid price'**
  String get pleaseEnterValidPrice;

  /// No description provided for @pleaseEnterDuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter duration'**
  String get pleaseEnterDuration;

  /// No description provided for @pleaseEnterValidDuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid duration'**
  String get pleaseEnterValidDuration;

  /// No description provided for @popularServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Popular service description'**
  String get popularServiceDescription;

  /// No description provided for @markAsPopular.
  ///
  /// In en, this message translates to:
  /// **'Mark as popular'**
  String get markAsPopular;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @newBookingRequest.
  ///
  /// In en, this message translates to:
  /// **'New Booking Request'**
  String get newBookingRequest;

  /// No description provided for @editYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Profile'**
  String get editYourProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @pleaseEnterSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Please enter specialty'**
  String get pleaseEnterSpecialty;

  /// No description provided for @dashboardRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Dashboard refreshed'**
  String get dashboardRefreshed;

  /// No description provided for @totalClients.
  ///
  /// In en, this message translates to:
  /// **'Total Clients'**
  String get totalClients;

  /// No description provided for @newThisMonth.
  ///
  /// In en, this message translates to:
  /// **'New This Month'**
  String get newThisMonth;

  /// No description provided for @noBookingHistory.
  ///
  /// In en, this message translates to:
  /// **'No booking history'**
  String get noBookingHistory;

  /// No description provided for @noCancelledBookings.
  ///
  /// In en, this message translates to:
  /// **'No cancelled bookings'**
  String get noCancelledBookings;

  /// No description provided for @markAsComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as complete'**
  String get markAsComplete;

  /// No description provided for @noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhoneNumber;

  /// No description provided for @detailedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Detailed Analytics'**
  String get detailedAnalytics;

  /// No description provided for @updateService.
  ///
  /// In en, this message translates to:
  /// **'Update service'**
  String get updateService;

  /// No description provided for @weeklySchedule.
  ///
  /// In en, this message translates to:
  /// **'Weekly schedule'**
  String get weeklySchedule;

  /// No description provided for @noBlockedDates.
  ///
  /// In en, this message translates to:
  /// **'No blocked dates'**
  String get noBlockedDates;

  /// No description provided for @addBlockedDate.
  ///
  /// In en, this message translates to:
  /// **'Add blocked date'**
  String get addBlockedDate;

  /// No description provided for @analyticsRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Analytics refreshed'**
  String get analyticsRefreshed;

  /// No description provided for @getFromKey.
  ///
  /// In en, this message translates to:
  /// **'Get from Key'**
  String get getFromKey;

  /// No description provided for @newBookingsRequest.
  ///
  /// In en, this message translates to:
  /// **'New Bookings Request'**
  String get newBookingsRequest;

  /// No description provided for @upcomingAppointmentReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointment Reminder Title'**
  String get upcomingAppointmentReminderTitle;

  /// No description provided for @bookingConfirmedByClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed by Client Title'**
  String get bookingConfirmedByClientTitle;

  /// No description provided for @serviceUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Updated Title'**
  String get serviceUpdatedTitle;

  /// No description provided for @newReviewReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'New Review Received Title'**
  String get newReviewReceivedTitle;

  /// No description provided for @newBookingRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'New Booking Request Message'**
  String get newBookingRequestMessage;

  /// No description provided for @upcomingAppointmentReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointment Reminder Message'**
  String get upcomingAppointmentReminderMessage;

  /// No description provided for @bookingConfirmedByClientMessage.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed by Client Message'**
  String get bookingConfirmedByClientMessage;

  /// No description provided for @serviceUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Service Updated Message'**
  String get serviceUpdatedMessage;

  /// No description provided for @newReviewReceivedMessage.
  ///
  /// In en, this message translates to:
  /// **'New Review Received Message'**
  String get newReviewReceivedMessage;

  /// No description provided for @bookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Booking Requests'**
  String get bookingRequests;

  /// No description provided for @systemUpdates.
  ///
  /// In en, this message translates to:
  /// **'System Updates'**
  String get systemUpdates;

  /// No description provided for @overallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall rating'**
  String get overallRating;

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOn;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **' Login successful'**
  String get loginSuccessful;

  /// No description provided for @switchToUser.
  ///
  /// In en, this message translates to:
  /// **'Switch to user'**
  String get switchToUser;

  /// No description provided for @ratingDistribution.
  ///
  /// In en, this message translates to:
  /// **'Rating distribution'**
  String get ratingDistribution;

  /// No description provided for @recentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent reviews'**
  String get recentReviews;

  /// No description provided for @greatServiceWillComeBack.
  ///
  /// In en, this message translates to:
  /// **'Great service will come back'**
  String get greatServiceWillComeBack;

  /// No description provided for @goodHaircutButWaited.
  ///
  /// In en, this message translates to:
  /// **'Good haircut, but waited'**
  String get goodHaircutButWaited;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @mondayAbbr.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayAbbr;

  /// No description provided for @tuesdayAbbr.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayAbbr;

  /// No description provided for @wednesdayAbbr.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayAbbr;

  /// No description provided for @thursdayAbbr.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayAbbr;

  /// No description provided for @fridayAbbr.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayAbbr;

  /// No description provided for @saturdayAbbr.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayAbbr;

  /// No description provided for @sundayAbbr.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayAbbr;

  /// No description provided for @weeklyPerformanceDetails.
  ///
  /// In en, this message translates to:
  /// **'Weekly performance details'**
  String get weeklyPerformanceDetails;

  /// No description provided for @dailyBreakdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily breakdown'**
  String get dailyBreakdownLabel;

  /// No description provided for @busy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get busy;

  /// No description provided for @veryBusy.
  ///
  /// In en, this message translates to:
  /// **'Very busy'**
  String get veryBusy;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @additionalMetrics.
  ///
  /// In en, this message translates to:
  /// **'Additional metrics'**
  String get additionalMetrics;

  /// No description provided for @cancellationRate.
  ///
  /// In en, this message translates to:
  /// **'Cancellation rate'**
  String get cancellationRate;

  /// No description provided for @repeatClients.
  ///
  /// In en, this message translates to:
  /// **'Repeat clients'**
  String get repeatClients;

  /// No description provided for @busiestTime.
  ///
  /// In en, this message translates to:
  /// **'Busiest time'**
  String get busiestTime;

  /// No description provided for @noUpcomingBookingsForToday.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings for today'**
  String get noUpcomingBookingsForToday;

  /// No description provided for @newRequests.
  ///
  /// In en, this message translates to:
  /// **'New requests'**
  String get newRequests;

  /// No description provided for @weeklyPerformance.
  ///
  /// In en, this message translates to:
  /// **'Weekly Performance'**
  String get weeklyPerformance;

  /// No description provided for @todaysAgenda.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Agenda'**
  String get todaysAgenda;

  /// No description provided for @notificationChannels.
  ///
  /// In en, this message translates to:
  /// **'Notification Channels'**
  String get notificationChannels;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'this action cannot be undone'**
  String get thisActionCannotBeUndone;

  /// No description provided for @areYouSureYouWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete ?'**
  String get areYouSureYouWantToDelete;

  /// No description provided for @addVacationOrDayOff.
  ///
  /// In en, this message translates to:
  /// **'Add Vacation Or Day Off'**
  String get addVacationOrDayOff;

  /// No description provided for @exceptions.
  ///
  /// In en, this message translates to:
  /// **'Exceptions'**
  String get exceptions;

  /// No description provided for @noCompletedBookings.
  ///
  /// In en, this message translates to:
  /// **'No completed bookings'**
  String get noCompletedBookings;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @atAGlance.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get atAGlance;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add Note (Optional)'**
  String get addNoteOptional;

  /// No description provided for @noClientsYet.
  ///
  /// In en, this message translates to:
  /// **'No Clients Yet'**
  String get noClientsYet;

  /// No description provided for @morningPeak.
  ///
  /// In en, this message translates to:
  /// **'Morning Peak'**
  String get morningPeak;

  /// No description provided for @quietestPeriod.
  ///
  /// In en, this message translates to:
  /// **'Quietest Period'**
  String get quietestPeriod;

  /// No description provided for @areYouSureYouWantToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm this booking with'**
  String get areYouSureYouWantToConfirm;

  /// No description provided for @yourBio.
  ///
  /// In en, this message translates to:
  /// **'Your Bio'**
  String get yourBio;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @publicInformation.
  ///
  /// In en, this message translates to:
  /// **'Public Information'**
  String get publicInformation;

  /// No description provided for @myGallery.
  ///
  /// In en, this message translates to:
  /// **'My Gallery'**
  String get myGallery;

  /// No description provided for @replyToMessage.
  ///
  /// In en, this message translates to:
  /// **'Reply To Message'**
  String get replyToMessage;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get noNotificationsYet;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @areYouSureToConfirmFor.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to confirm for'**
  String get areYouSureToConfirmFor;

  /// No description provided for @revenueManagement.
  ///
  /// In en, this message translates to:
  /// **'Revenue Management'**
  String get revenueManagement;

  /// No description provided for @noBookingsToday.
  ///
  /// In en, this message translates to:
  /// **'No Bookings Today'**
  String get noBookingsToday;

  /// No description provided for @todaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaySchedule;

  /// No description provided for @yourDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Dashboard Subtitle'**
  String get yourDashboardSubtitle;

  /// No description provided for @tryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try Different Keywords'**
  String get tryDifferentKeywords;

  /// No description provided for @clientsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Clients Appear Here'**
  String get clientsAppearHere;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All Caught Up'**
  String get allCaughtUp;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @confirmClient.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm this booking with'**
  String get confirmClient;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @bookingsOverTime.
  ///
  /// In en, this message translates to:
  /// **'Bookings Over Time'**
  String get bookingsOverTime;

  /// No description provided for @serviceRanking.
  ///
  /// In en, this message translates to:
  /// **'Service Ranking'**
  String get serviceRanking;

  /// No description provided for @notificationsFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications feature coming soon'**
  String get notificationsFeatureComingSoon;

  /// No description provided for @todayBookings.
  ///
  /// In en, this message translates to:
  /// **'Today bookings'**
  String get todayBookings;

  /// No description provided for @weeklyEarnings.
  ///
  /// In en, this message translates to:
  /// **'Weekly earnings'**
  String get weeklyEarnings;

  /// No description provided for @manageAppointments.
  ///
  /// In en, this message translates to:
  /// **'Manage appointments, manage offerings, set availability, update info'**
  String get manageAppointments;

  /// No description provided for @updateInfo.
  ///
  /// In en, this message translates to:
  /// **'Update info'**
  String get updateInfo;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @setAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set Availability'**
  String get setAvailability;

  /// No description provided for @manageOfferings.
  ///
  /// In en, this message translates to:
  /// **'Manage Offerings'**
  String get manageOfferings;

  /// No description provided for @selectedItem.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedItem;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @confirmBookingDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBookingDialogTitle;

  /// No description provided for @confirmBookingDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm the booking for {clientName}?'**
  String confirmBookingDialogContent(Object clientName);

  /// No description provided for @cancelBookingDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBookingDialogTitle;

  /// No description provided for @cancelBookingDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the booking for {clientName}?'**
  String cancelBookingDialogContent(Object clientName);

  /// No description provided for @genericConfirmStatusChangeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Status Change'**
  String get genericConfirmStatusChangeDialogTitle;

  /// No description provided for @genericConfirmStatusChangeDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change the status of the booking for {clientName} to {newStatus}?'**
  String genericConfirmStatusChangeDialogContent(
      Object clientName, Object newStatus);

  /// No description provided for @deleteServiceConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete Service Confirmation Message'**
  String get deleteServiceConfirmationMessage;

  /// No description provided for @workInProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'Work in progress message'**
  String get workInProgressMessage;

  /// No description provided for @servicesFeatureInProgress.
  ///
  /// In en, this message translates to:
  /// **'Services feature in progress'**
  String get servicesFeatureInProgress;

  /// No description provided for @servicesOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Services overview description'**
  String get servicesOverviewDescription;

  /// No description provided for @manageYourServices.
  ///
  /// In en, this message translates to:
  /// **'Manage your services'**
  String get manageYourServices;

  /// No description provided for @addServiceFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add Service feature coming soon'**
  String get addServiceFeatureComingSoon;

  /// No description provided for @serviceAdded.
  ///
  /// In en, this message translates to:
  /// **'Service added'**
  String get serviceAdded;

  /// No description provided for @serviceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Service updated'**
  String get serviceUpdated;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @describeTheService.
  ///
  /// In en, this message translates to:
  /// **'Describe the service'**
  String get describeTheService;

  /// No description provided for @enterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Enter service name'**
  String get enterServiceName;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceName;

  /// No description provided for @updateServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Update service details'**
  String get updateServiceDetails;

  /// No description provided for @addServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Add service details'**
  String get addServiceDetails;

  /// No description provided for @editYourService.
  ///
  /// In en, this message translates to:
  /// **'Edit your service'**
  String get editYourService;

  /// No description provided for @createNewService.
  ///
  /// In en, this message translates to:
  /// **'Create new service'**
  String get createNewService;

  /// No description provided for @deleteServiceFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Delete service feature coming soon'**
  String get deleteServiceFeatureComingSoon;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @tapToAddImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to add image'**
  String get tapToAddImage;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get removeImage;

  /// No description provided for @serviceImage.
  ///
  /// In en, this message translates to:
  /// **'Service image'**
  String get serviceImage;

  /// No description provided for @selectDayToAddSlot.
  ///
  /// In en, this message translates to:
  /// **'Select day to add slot'**
  String get selectDayToAddSlot;

  /// No description provided for @blockTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Block time slot'**
  String get blockTimeSlot;

  /// No description provided for @blockTimeSlotConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Block time slot confirmation message'**
  String get blockTimeSlotConfirmationMessage;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @addTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Add Time Slot'**
  String get addTimeSlot;

  /// No description provided for @editTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Edit Time Slot'**
  String get editTimeSlot;

  /// No description provided for @addNewTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Add New Time Slot'**
  String get addNewTimeSlot;

  /// No description provided for @editExistingTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Edit Existing Time Slot'**
  String get editExistingTimeSlot;

  /// No description provided for @timeSlotDetails.
  ///
  /// In en, this message translates to:
  /// **'Time Slot Details'**
  String get timeSlotDetails;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @startTimeSetTo.
  ///
  /// In en, this message translates to:
  /// **'Start Time Set To'**
  String get startTimeSetTo;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @endTimeSetTo.
  ///
  /// In en, this message translates to:
  /// **'End Time Set To'**
  String get endTimeSetTo;

  /// No description provided for @slotSetToAvailable.
  ///
  /// In en, this message translates to:
  /// **'Slot Set To Available'**
  String get slotSetToAvailable;

  /// No description provided for @timeSlotAdded.
  ///
  /// In en, this message translates to:
  /// **'Time Slot Added'**
  String get timeSlotAdded;

  /// No description provided for @timeSlotUpdated.
  ///
  /// In en, this message translates to:
  /// **'Time Slot Updated'**
  String get timeSlotUpdated;

  /// No description provided for @editHoursFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit Hours Feature Coming Soon'**
  String get editHoursFeatureComingSoon;

  /// No description provided for @yourWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Your Working Hours'**
  String get yourWorkingHours;

  /// No description provided for @setYourWorkingHoursAndAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set your working hours and availability'**
  String get setYourWorkingHoursAndAvailability;

  /// No description provided for @manageYourSchedule.
  ///
  /// In en, this message translates to:
  /// **'Manage your schedule'**
  String get manageYourSchedule;

  /// No description provided for @editScheduleFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule feature coming soon'**
  String get editScheduleFeatureComingSoon;

  /// No description provided for @editWorkingHoursFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit working hours feature coming soon'**
  String get editWorkingHoursFeatureComingSoon;

  /// No description provided for @setYourAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set your availability'**
  String get setYourAvailability;

  /// No description provided for @locationAndContacts.
  ///
  /// In en, this message translates to:
  /// **'Location and contacts'**
  String get locationAndContacts;

  /// No description provided for @editLocationContactFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit location contact feature coming soon'**
  String get editLocationContactFeatureComingSoon;

  /// No description provided for @findUsHere.
  ///
  /// In en, this message translates to:
  /// **'Find us here'**
  String get findUsHere;

  /// No description provided for @mapViewByPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Map view by placeholder'**
  String get mapViewByPlaceholder;

  /// No description provided for @failToOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Fail to open map'**
  String get failToOpenMap;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in maps'**
  String get openInMaps;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get contactInformation;

  /// No description provided for @failToMakeCall.
  ///
  /// In en, this message translates to:
  /// **'Fail to make call'**
  String get failToMakeCall;

  /// No description provided for @mailAddress.
  ///
  /// In en, this message translates to:
  /// **'Mail address'**
  String get mailAddress;

  /// No description provided for @failToSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Fail to send email'**
  String get failToSendEmail;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @failToOpenWebsite.
  ///
  /// In en, this message translates to:
  /// **'Fail to open website'**
  String get failToOpenWebsite;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @enterShopLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter shop location'**
  String get enterShopLocation;

  /// No description provided for @enterYourShopName.
  ///
  /// In en, this message translates to:
  /// **'Enter your shop name'**
  String get enterYourShopName;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get shopName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @updatePersonalAndShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Update your personal and shop details'**
  String get updatePersonalAndShopDetails;

  /// No description provided for @editProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit your profile info'**
  String get editProfileInfo;

  /// No description provided for @changeAvatarFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Change avatar feature coming soon'**
  String get changeAvatarFeatureComingSoon;

  /// No description provided for @profileStats.
  ///
  /// In en, this message translates to:
  /// **'Profile stats'**
  String get profileStats;

  /// No description provided for @yearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of experience'**
  String get yearsOfExperience;

  /// No description provided for @chooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get chooseFromLibrary;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get changeProfilePhoto;

  /// No description provided for @markAllAsReadFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read feature coming soon'**
  String get markAllAsReadFeatureComingSoon;

  /// No description provided for @yourNotifications.
  ///
  /// In en, this message translates to:
  /// **'Your notifications'**
  String get yourNotifications;

  /// No description provided for @notificationsOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications overview description'**
  String get notificationsOverviewDescription;

  /// No description provided for @recentNotifications.
  ///
  /// In en, this message translates to:
  /// **'Recent notifications'**
  String get recentNotifications;

  /// No description provided for @notificationsFeatureInProgress.
  ///
  /// In en, this message translates to:
  /// **'Notifications feature in progress'**
  String get notificationsFeatureInProgress;

  /// No description provided for @notificationDetails.
  ///
  /// In en, this message translates to:
  /// **'Notification details'**
  String get notificationDetails;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @navigateToBooking.
  ///
  /// In en, this message translates to:
  /// **'Navigate to booking'**
  String get navigateToBooking;

  /// No description provided for @viewBooking.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get viewBooking;

  /// No description provided for @dismissed.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get dismissed;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @logoutFunctionalityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Logout functionality coming soon'**
  String get logoutFunctionalityComingSoon;

  /// No description provided for @bookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking history'**
  String get bookingHistory;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average rating'**
  String get averageRating;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get totalSpent;

  /// No description provided for @clientStates.
  ///
  /// In en, this message translates to:
  /// **'Client states'**
  String get clientStates;

  /// No description provided for @clientActionsFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Client actions feature coming soon'**
  String get clientActionsFeatureComingSoon;

  /// No description provided for @bookingsShort.
  ///
  /// In en, this message translates to:
  /// **'Bookings short'**
  String get bookingsShort;

  /// No description provided for @totalSpendShort.
  ///
  /// In en, this message translates to:
  /// **'Total Spend'**
  String get totalSpendShort;

  /// No description provided for @manageYourAppointments.
  ///
  /// In en, this message translates to:
  /// **'Manage your appointments'**
  String get manageYourAppointments;

  /// No description provided for @bookingsOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Bookings overview description'**
  String get bookingsOverviewDescription;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointments'**
  String get upcomingAppointments;

  /// No description provided for @clientInformation.
  ///
  /// In en, this message translates to:
  /// **'Client information'**
  String get clientInformation;

  /// No description provided for @rescheduleFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Reschedule feature coming soon'**
  String get rescheduleFeatureComingSoon;

  /// No description provided for @cancelFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Cancel feature coming soon'**
  String get cancelFeatureComingSoon;

  /// No description provided for @filterBookings.
  ///
  /// In en, this message translates to:
  /// **'Filter bookings'**
  String get filterBookings;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldestFirst;

  /// No description provided for @nameAToZ.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get nameAToZ;

  /// No description provided for @nameZToA.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get nameZToA;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @dateRangePickerDialog.
  ///
  /// In en, this message translates to:
  /// **'Date Range Picker Dialog'**
  String get dateRangePickerDialog;

  /// No description provided for @averagePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average Per Day'**
  String get averagePerDay;

  /// No description provided for @bestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get bestDay;

  /// No description provided for @lowestDay.
  ///
  /// In en, this message translates to:
  /// **'Lowest Day'**
  String get lowestDay;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'Days Ago'**
  String get daysAgo;

  /// No description provided for @trendUp5PercentThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Trend Up 5% This Week'**
  String get trendUp5PercentThisWeek;

  /// No description provided for @lastFridayToSunday.
  ///
  /// In en, this message translates to:
  /// **'Last Friday to Sunday'**
  String get lastFridayToSunday;

  /// No description provided for @hairColorTrend.
  ///
  /// In en, this message translates to:
  /// **'Hair color trend'**
  String get hairColorTrend;

  /// No description provided for @growingService.
  ///
  /// In en, this message translates to:
  /// **'Growing service'**
  String get growingService;

  /// No description provided for @secondMostPopular.
  ///
  /// In en, this message translates to:
  /// **'Second most popular'**
  String get secondMostPopular;

  /// No description provided for @beardTrimWithCount.
  ///
  /// In en, this message translates to:
  /// **'Beard trim with count'**
  String get beardTrimWithCount;

  /// No description provided for @topService.
  ///
  /// In en, this message translates to:
  /// **'Top service'**
  String get topService;

  /// No description provided for @haircutWithCount.
  ///
  /// In en, this message translates to:
  /// **'Haircut with count'**
  String get haircutWithCount;

  /// No description provided for @serviceDistribution.
  ///
  /// In en, this message translates to:
  /// **'Service distribution'**
  String get serviceDistribution;

  /// No description provided for @discoverYourTopOfferings.
  ///
  /// In en, this message translates to:
  /// **'Discover your top offerings'**
  String get discoverYourTopOfferings;

  /// No description provided for @popularServicesReports.
  ///
  /// In en, this message translates to:
  /// **'Popular services reports'**
  String get popularServicesReports;

  /// No description provided for @peakHoursReport.
  ///
  /// In en, this message translates to:
  /// **'Peak hours report'**
  String get peakHoursReport;

  /// No description provided for @identifyYourBusiestTimes.
  ///
  /// In en, this message translates to:
  /// **'Identify your busiest times'**
  String get identifyYourBusiestTimes;

  /// No description provided for @weeklyPeakHours.
  ///
  /// In en, this message translates to:
  /// **'Weekly peak hours'**
  String get weeklyPeakHours;

  /// No description provided for @morningRush.
  ///
  /// In en, this message translates to:
  /// **'Morning rush'**
  String get morningRush;

  /// No description provided for @between9And11AM.
  ///
  /// In en, this message translates to:
  /// **'Between 9 and 11 am'**
  String get between9And11AM;

  /// No description provided for @eveningPeak.
  ///
  /// In en, this message translates to:
  /// **'Evening peak'**
  String get eveningPeak;

  /// No description provided for @between5And7PM.
  ///
  /// In en, this message translates to:
  /// **'Between 5 and 7 pm'**
  String get between5And7PM;

  /// No description provided for @quietPeriods.
  ///
  /// In en, this message translates to:
  /// **'Quiet periods'**
  String get quietPeriods;

  /// No description provided for @middayLunchBreak.
  ///
  /// In en, this message translates to:
  /// **'Midday lunch break'**
  String get middayLunchBreak;

  /// No description provided for @bookingTrendsReport.
  ///
  /// In en, this message translates to:
  /// **'Booking Trends Report'**
  String get bookingTrendsReport;

  /// No description provided for @weeklyBookingTrend.
  ///
  /// In en, this message translates to:
  /// **'Weekly Booking Trend'**
  String get weeklyBookingTrend;

  /// No description provided for @analyzeBookingPatterns.
  ///
  /// In en, this message translates to:
  /// **'Analyze Booking Patterns'**
  String get analyzeBookingPatterns;

  /// No description provided for @busiestDay.
  ///
  /// In en, this message translates to:
  /// **'Busiest Day'**
  String get busiestDay;

  /// No description provided for @slowestDay.
  ///
  /// In en, this message translates to:
  /// **'Slowest Day'**
  String get slowestDay;

  /// No description provided for @weekendVsWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekend vs Weekday'**
  String get weekendVsWeekday;

  /// No description provided for @higherOnWeekends.
  ///
  /// In en, this message translates to:
  /// **'Higher on Weekends'**
  String get higherOnWeekends;

  /// No description provided for @analyticsFeatureInProgress.
  ///
  /// In en, this message translates to:
  /// **'Analytics Feature In Progress'**
  String get analyticsFeatureInProgress;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @serviceHaircut.
  ///
  /// In en, this message translates to:
  /// **'Haircut'**
  String get serviceHaircut;

  /// No description provided for @serviceBeardTrim.
  ///
  /// In en, this message translates to:
  /// **'Beard Trim'**
  String get serviceBeardTrim;

  /// No description provided for @receivePushAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive Push Alerts'**
  String get receivePushAlerts;

  /// No description provided for @notificationCategories.
  ///
  /// In en, this message translates to:
  /// **'Notification Categories'**
  String get notificationCategories;

  /// No description provided for @notificationsSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications Settings'**
  String get notificationsSettings;

  /// No description provided for @serviceInformation.
  ///
  /// In en, this message translates to:
  /// **'Service Information'**
  String get serviceInformation;

  /// No description provided for @slotSetToUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Slot Set to Unavailable'**
  String get slotSetToUnavailable;

  /// No description provided for @forDay.
  ///
  /// In en, this message translates to:
  /// **'For Day'**
  String get forDay;

  /// No description provided for @failedToOpenWebsite.
  ///
  /// In en, this message translates to:
  /// **'Failed to Open Website'**
  String get failedToOpenWebsite;

  /// No description provided for @failedToSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Failed to Send Email'**
  String get failedToSendEmail;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @failedToMakeCall.
  ///
  /// In en, this message translates to:
  /// **'Failed to Make Call'**
  String get failedToMakeCall;

  /// No description provided for @failedToOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Failed to Open Map'**
  String get failedToOpenMap;

  /// No description provided for @mapViewPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Map View Placeholder'**
  String get mapViewPlaceholder;

  /// No description provided for @locationAndContact.
  ///
  /// In en, this message translates to:
  /// **'Location and Contact'**
  String get locationAndContact;

  /// No description provided for @editYourProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Profile Info'**
  String get editYourProfileInfo;

  /// No description provided for @updateYourPersonalAndShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Update Your Personal and Shop Details'**
  String get updateYourPersonalAndShopDetails;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterYourPhoneNumber;

  /// No description provided for @markedAsRead.
  ///
  /// In en, this message translates to:
  /// **'Marked as Read'**
  String get markedAsRead;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @clientStats.
  ///
  /// In en, this message translates to:
  /// **'Client Stats'**
  String get clientStats;

  /// No description provided for @totalSpentShort.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpentShort;

  /// No description provided for @bookingsFeatureInProgress.
  ///
  /// In en, this message translates to:
  /// **'Bookings Feature In Progress'**
  String get bookingsFeatureInProgress;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes cancel'**
  String get yesCancel;

  /// No description provided for @rescheduleBookingFor.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Booking For'**
  String get rescheduleBookingFor;

  /// No description provided for @currentBooking.
  ///
  /// In en, this message translates to:
  /// **'Current Booking'**
  String get currentBooking;

  /// No description provided for @selectNewDate.
  ///
  /// In en, this message translates to:
  /// **'Select New Date'**
  String get selectNewDate;

  /// No description provided for @pleaseSelectFutureDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a future date and time'**
  String get pleaseSelectFutureDateTime;

  /// No description provided for @bookingRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Booking Rescheduled'**
  String get bookingRescheduled;

  /// No description provided for @noGoBack.
  ///
  /// In en, this message translates to:
  /// **'No go back'**
  String get noGoBack;

  /// No description provided for @selectNewTime.
  ///
  /// In en, this message translates to:
  /// **'Select new time'**
  String get selectNewTime;

  /// No description provided for @noAvailableSlotsForThisDate.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this date'**
  String get noAvailableSlotsForThisDate;

  /// No description provided for @availableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Available time slots'**
  String get availableTimeSlots;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @cancelBookingConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingConfirmationMessage;

  /// No description provided for @analyticsOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Track your performance, revenue, and customer trends'**
  String get analyticsOverviewDescription;

  /// No description provided for @businessAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Business Analytics'**
  String get businessAnalytics;

  /// No description provided for @yourReports.
  ///
  /// In en, this message translates to:
  /// **'Your Reports'**
  String get yourReports;

  /// No description provided for @selectATimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Select a time slot'**
  String get selectATimeSlot;

  /// No description provided for @popularServicesReport.
  ///
  /// In en, this message translates to:
  /// **'Popular Services Report'**
  String get popularServicesReport;

  /// No description provided for @trend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get trend;

  /// No description provided for @up5PercentThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Up 5% This Week'**
  String get up5PercentThisWeek;

  /// No description provided for @updateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Update Schedule'**
  String get updateSchedule;

  /// No description provided for @areYouSureYouWantToCancel.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the booking with'**
  String get areYouSureYouWantToCancel;

  /// No description provided for @areYouSureYouWantToPostpone.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to postpone the booking with'**
  String get areYouSureYouWantToPostpone;

  /// No description provided for @manageYourClients.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Clients'**
  String get manageYourClients;

  /// No description provided for @clientsOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Clients Overview Description'**
  String get clientsOverviewDescription;

  /// No description provided for @yourClients.
  ///
  /// In en, this message translates to:
  /// **'Your Clients'**
  String get yourClients;

  /// No description provided for @replaceAll.
  ///
  /// In en, this message translates to:
  /// **'Replace All'**
  String get replaceAll;

  /// No description provided for @clientsFeatureInProgress.
  ///
  /// In en, this message translates to:
  /// **'Clients Feature In Progress'**
  String get clientsFeatureInProgress;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

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
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
