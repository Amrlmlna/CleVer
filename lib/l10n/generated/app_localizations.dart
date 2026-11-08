import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('id'),
  ];

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year} other{{count} years}}'**
  String years(int count);

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String months(int count);

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week} other{{count} weeks}}'**
  String weeks(int count);

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String days(int count);

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String hours(int count);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String minutes(int count);

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get add;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get added;

  /// No description provided for @analyzingText.
  ///
  /// In en, this message translates to:
  /// **'analyzing text...'**
  String get analyzingText;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @applyingDesign.
  ///
  /// In en, this message translates to:
  /// **'applying design...'**
  String get applyingDesign;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'bold'**
  String get bold;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @checkingSystem.
  ///
  /// In en, this message translates to:
  /// **'checking system...'**
  String get checkingSystem;

  /// No description provided for @clearLocalData.
  ///
  /// In en, this message translates to:
  /// **'clear local data as well (full reset)'**
  String get clearLocalData;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get close;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get complete;

  /// No description provided for @continueChooseTemplate.
  ///
  /// In en, this message translates to:
  /// **'continue: choose template'**
  String get continueChooseTemplate;

  /// No description provided for @continueToReview.
  ///
  /// In en, this message translates to:
  /// **'continue: review data'**
  String get continueToReview;

  /// No description provided for @creatingPages.
  ///
  /// In en, this message translates to:
  /// **'creating pages...'**
  String get creatingPages;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'download'**
  String get download;

  /// No description provided for @downloadPDF.
  ///
  /// In en, this message translates to:
  /// **'download pdf'**
  String get downloadPDF;

  /// No description provided for @downloadPDFDescription.
  ///
  /// In en, this message translates to:
  /// **'this pdf is stored in the cloud. would you like to download it now?'**
  String get downloadPDFDescription;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'download complete'**
  String get downloadComplete;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'download failed: {error}'**
  String downloadFailed(String error);

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'downloading...'**
  String get downloading;

  /// No description provided for @finalStatus.
  ///
  /// In en, this message translates to:
  /// **'final'**
  String get finalStatus;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'untitled'**
  String get untitled;

  /// No description provided for @openPDF.
  ///
  /// In en, this message translates to:
  /// **'open pdf'**
  String get openPDF;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @exitWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get exitWithoutSaving;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get failed;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'female'**
  String get female;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'gender'**
  String get gender;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'view all'**
  String get viewAll;

  /// No description provided for @finalizing.
  ///
  /// In en, this message translates to:
  /// **'finalizing...'**
  String get finalizing;

  /// No description provided for @finalizingPdf.
  ///
  /// In en, this message translates to:
  /// **'finalizing pdf...'**
  String get finalizingPdf;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'gallery'**
  String get gallery;

  /// No description provided for @generatingPdfBadge.
  ///
  /// In en, this message translates to:
  /// **'generating pdf'**
  String get generatingPdfBadge;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'go home'**
  String get goHome;

  /// No description provided for @identifyingVacancy.
  ///
  /// In en, this message translates to:
  /// **'identifying vacancy...'**
  String get identifyingVacancy;

  /// No description provided for @improving.
  ///
  /// In en, this message translates to:
  /// **'improving...'**
  String get improving;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'italic'**
  String get italic;

  /// No description provided for @keepLocalData.
  ///
  /// In en, this message translates to:
  /// **'keep my local data (master profile)'**
  String get keepLocalData;

  /// No description provided for @loadingPreview.
  ///
  /// In en, this message translates to:
  /// **'loading preview...'**
  String get loadingPreview;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @organizingData.
  ///
  /// In en, this message translates to:
  /// **'organizing data...'**
  String get organizingData;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'other'**
  String get other;

  /// No description provided for @pdfFile.
  ///
  /// In en, this message translates to:
  /// **'pdf file'**
  String get pdfFile;

  /// No description provided for @polishing.
  ///
  /// In en, this message translates to:
  /// **'polishing...'**
  String get polishing;

  /// No description provided for @preparingGallery.
  ///
  /// In en, this message translates to:
  /// **'preparing gallery...'**
  String get preparingGallery;

  /// No description provided for @preparingProfile.
  ///
  /// In en, this message translates to:
  /// **'preparing profile...'**
  String get preparingProfile;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'present'**
  String get present;

  /// No description provided for @previewCV.
  ///
  /// In en, this message translates to:
  /// **'preview cv'**
  String get previewCV;

  /// No description provided for @processingData.
  ///
  /// In en, this message translates to:
  /// **'processing data...'**
  String get processingData;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'ready!'**
  String get ready;

  /// No description provided for @rephrasing.
  ///
  /// In en, this message translates to:
  /// **'rephrasing...'**
  String get rephrasing;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'required'**
  String get requiredField;

  /// No description provided for @requiredFieldFriendly.
  ///
  /// In en, this message translates to:
  /// **'this is required!'**
  String get requiredFieldFriendly;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'retry'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @saveAllCaps.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get saveAllCaps;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'select date'**
  String get selectDate;

  /// No description provided for @skipIntro.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get skipIntro;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'start now'**
  String get startNow;

  /// No description provided for @stayHere.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get stayHere;

  /// No description provided for @syncAnywhere.
  ///
  /// In en, this message translates to:
  /// **'access from any device, auto-sync'**
  String get syncAnywhere;

  /// No description provided for @syncData.
  ///
  /// In en, this message translates to:
  /// **'sync data'**
  String get syncData;

  /// No description provided for @typeHere.
  ///
  /// In en, this message translates to:
  /// **'type here...'**
  String get typeHere;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'unknown error'**
  String get unknownError;

  /// No description provided for @unknownErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'something went wrong, but we aren\'t sure what.'**
  String get unknownErrorDesc;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'update'**
  String get update;

  /// No description provided for @untilNow.
  ///
  /// In en, this message translates to:
  /// **'until now'**
  String get untilNow;

  /// No description provided for @uploadInstruction.
  ///
  /// In en, this message translates to:
  /// **'tap to upload your professional photo'**
  String get uploadInstruction;

  /// No description provided for @uploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'uploading photo...'**
  String get uploadingPhoto;

  /// No description provided for @validatingData.
  ///
  /// In en, this message translates to:
  /// **'validating data...'**
  String get validatingData;

  /// No description provided for @validatingLink.
  ///
  /// In en, this message translates to:
  /// **'validating link...'**
  String get validatingLink;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'please write something'**
  String get writeSomething;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'upload photo'**
  String get uploadPhoto;

  /// No description provided for @cleverYes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get cleverYes;

  /// No description provided for @cleverNo.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get cleverNo;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// No description provided for @searchResult.
  ///
  /// In en, this message translates to:
  /// **'search results'**
  String get searchResult;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @authWallBuyCredits.
  ///
  /// In en, this message translates to:
  /// **'sign in to get pass'**
  String get authWallBuyCredits;

  /// No description provided for @authWallBuyCreditsDesc.
  ///
  /// In en, this message translates to:
  /// **'an account is required to activate a job hunter pass'**
  String get authWallBuyCreditsDesc;

  /// No description provided for @authWallCreateCV.
  ///
  /// In en, this message translates to:
  /// **'sign in to create your cv'**
  String get authWallCreateCV;

  /// No description provided for @authWallCreateCVDesc.
  ///
  /// In en, this message translates to:
  /// **'an account is required to create and save your cv'**
  String get authWallCreateCVDesc;

  /// No description provided for @authWallSelectTemplate.
  ///
  /// In en, this message translates to:
  /// **'sign in to select a template'**
  String get authWallSelectTemplate;

  /// No description provided for @authWallSelectTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'an account is required to choose a template'**
  String get authWallSelectTemplateDesc;

  /// No description provided for @cantOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'could not open email app.'**
  String get cantOpenEmail;

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'can\'t find it? please check your spam or junk folder.'**
  String get checkSpamFolder;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'continue with google'**
  String get continueWithGoogle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'create account'**
  String get createAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get email;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'email not verified yet. please check your inbox.'**
  String get emailNotVerifiedYet;

  /// No description provided for @emailVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'email verified successfully!'**
  String get emailVerifiedSuccess;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'forgot password'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordResetMessage.
  ///
  /// In en, this message translates to:
  /// **'enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordResetMessage;

  /// No description provided for @iHaveVerified.
  ///
  /// In en, this message translates to:
  /// **'i have verified'**
  String get iHaveVerified;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'log in'**
  String get logIn;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get login;

  /// No description provided for @loginToSave.
  ///
  /// In en, this message translates to:
  /// **'login to access all features'**
  String get loginToSave;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'resend verification email'**
  String get resendEmail;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'send reset link'**
  String get sendResetLink;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'sign up'**
  String get signUp;

  /// No description provided for @unlockFeatures.
  ///
  /// In en, this message translates to:
  /// **'activate job hunter pass'**
  String get unlockFeatures;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'user not logged in'**
  String get userNotLoggedIn;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'verification email sent!'**
  String get verificationEmailSent;

  /// No description provided for @verificationSentTo.
  ///
  /// In en, this message translates to:
  /// **'a verification link has been sent to {email}. please check your inbox and spam folder.'**
  String verificationSentTo(String email);

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'verify your email'**
  String get verifyYourEmail;

  /// No description provided for @cleverGetStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice to meet you!'**
  String get cleverGetStartedTitle;

  /// No description provided for @cleverGetStartedSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'feel more confident with tailored cvs.'**
  String get cleverGetStartedSubtitle1;

  /// No description provided for @cleverGetStartedSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'without the manual editing anymore.'**
  String get cleverGetStartedSubtitle2;

  /// No description provided for @cleverSignInGreeting.
  ///
  /// In en, this message translates to:
  /// **'welcome back!'**
  String get cleverSignInGreeting;

  /// No description provided for @cleverGoogleSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get cleverGoogleSignUp;

  /// No description provided for @cleverGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get cleverGoogleSignIn;

  /// No description provided for @cleverEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'enter a valid email'**
  String get cleverEmailInvalid;

  /// No description provided for @cleverConsentLine.
  ///
  /// In en, this message translates to:
  /// **'I have read the Privacy Policy & Terms'**
  String get cleverConsentLine;

  /// No description provided for @addCertification.
  ///
  /// In en, this message translates to:
  /// **'add certification'**
  String get addCertification;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'add education'**
  String get addEducation;

  /// No description provided for @addExperience.
  ///
  /// In en, this message translates to:
  /// **'add experience'**
  String get addExperience;

  /// No description provided for @addSubject.
  ///
  /// In en, this message translates to:
  /// **'add subject'**
  String get addSubject;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'add skill'**
  String get addSkill;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'birth date'**
  String get birthDate;

  /// No description provided for @certificationName.
  ///
  /// In en, this message translates to:
  /// **'certification name'**
  String get certificationName;

  /// No description provided for @certificationTitle.
  ///
  /// In en, this message translates to:
  /// **'certifications & licenses'**
  String get certificationTitle;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'certifications'**
  String get certifications;

  /// No description provided for @certificationsLicenses.
  ///
  /// In en, this message translates to:
  /// **'certifications & licenses'**
  String get certificationsLicenses;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'company'**
  String get company;

  /// No description provided for @companyHint.
  ///
  /// In en, this message translates to:
  /// **'company name (optional)'**
  String get companyHint;

  /// No description provided for @contactHint.
  ///
  /// In en, this message translates to:
  /// **'so we can get back to you...'**
  String get contactHint;

  /// No description provided for @contactOptional.
  ///
  /// In en, this message translates to:
  /// **'email / whatsapp (optional)'**
  String get contactOptional;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'degree / major'**
  String get degree;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'explain your main responsibilities and achievements...'**
  String get descriptionHint;

  /// No description provided for @educationHistory.
  ///
  /// In en, this message translates to:
  /// **'education history'**
  String get educationHistory;

  /// No description provided for @educationTitle.
  ///
  /// In en, this message translates to:
  /// **'education history'**
  String get educationTitle;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'end date'**
  String get endDate;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'experience'**
  String get experience;

  /// No description provided for @experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'work experience'**
  String get experienceTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'full name'**
  String get fullName;

  /// No description provided for @header.
  ///
  /// In en, this message translates to:
  /// **'header'**
  String get header;

  /// No description provided for @issuer.
  ///
  /// In en, this message translates to:
  /// **'issuer'**
  String get issuer;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'job title'**
  String get jobTitle;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'ex: jakarta -> dki jakarta, south jakarta'**
  String get locationHint;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'location (search city/regency)'**
  String get locationLabel;

  /// No description provided for @noCertifications.
  ///
  /// In en, this message translates to:
  /// **'no certifications yet.'**
  String get noCertifications;

  /// No description provided for @noEducation.
  ///
  /// In en, this message translates to:
  /// **'no education history yet.'**
  String get noEducation;

  /// No description provided for @noExperience.
  ///
  /// In en, this message translates to:
  /// **'no work experience yet.'**
  String get noExperience;

  /// No description provided for @noSkills.
  ///
  /// In en, this message translates to:
  /// **'no skills yet.'**
  String get noSkills;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'contact information'**
  String get personalInfo;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'phone number'**
  String get phoneNumber;

  /// No description provided for @positionHint.
  ///
  /// In en, this message translates to:
  /// **'position (ex: ui designer)'**
  String get positionHint;

  /// No description provided for @professionalSummary.
  ///
  /// In en, this message translates to:
  /// **'professional summary'**
  String get professionalSummary;

  /// No description provided for @scanKHSTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Study Result Card (KHS)'**
  String get scanKHSTitle;

  /// No description provided for @scanKHSMessage.
  ///
  /// In en, this message translates to:
  /// **'Select a source to extract GPA and subjects'**
  String get scanKHSMessage;

  /// No description provided for @academicSubjects.
  ///
  /// In en, this message translates to:
  /// **'academic subjects'**
  String get academicSubjects;

  /// No description provided for @subjectName.
  ///
  /// In en, this message translates to:
  /// **'subject name'**
  String get subjectName;

  /// No description provided for @gradeOptional.
  ///
  /// In en, this message translates to:
  /// **'grade (optional)'**
  String get gradeOptional;

  /// No description provided for @whatDidYouLearn.
  ///
  /// In en, this message translates to:
  /// **'what did you learn? (optional)'**
  String get whatDidYouLearn;

  /// No description provided for @gpaLabel.
  ///
  /// In en, this message translates to:
  /// **'GPA / IPK'**
  String get gpaLabel;

  /// No description provided for @educationDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'description / honors'**
  String get educationDescriptionLabel;

  /// No description provided for @educationDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Summa Cum Laude, Major in Computer Science'**
  String get educationDescriptionHint;

  /// No description provided for @schoolHint.
  ///
  /// In en, this message translates to:
  /// **'ex: university of indonesia'**
  String get schoolHint;

  /// No description provided for @schoolLabel.
  ///
  /// In en, this message translates to:
  /// **'school / university'**
  String get schoolLabel;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'school name'**
  String get schoolName;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'short description'**
  String get shortDescription;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'skills'**
  String get skills;

  /// No description provided for @skillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'list all your skills. ai will highlight the ones that best match the position you are aiming for.'**
  String get skillsSubtitle;

  /// No description provided for @skillsTitle.
  ///
  /// In en, this message translates to:
  /// **'what are your skills?'**
  String get skillsTitle;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'start date'**
  String get startDate;

  /// No description provided for @summaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'summary cannot be empty'**
  String get summaryEmpty;

  /// No description provided for @summaryHint.
  ///
  /// In en, this message translates to:
  /// **'write a brief professional summary...'**
  String get summaryHint;

  /// No description provided for @targetPosition.
  ///
  /// In en, this message translates to:
  /// **'target position'**
  String get targetPosition;

  /// No description provided for @whatJobApply.
  ///
  /// In en, this message translates to:
  /// **'what job are you applying for?'**
  String get whatJobApply;

  /// No description provided for @workExperience.
  ///
  /// In en, this message translates to:
  /// **'work experience'**
  String get workExperience;

  /// No description provided for @mascotWelcome.
  ///
  /// In en, this message translates to:
  /// **'here we go'**
  String get mascotWelcome;

  /// No description provided for @mascotWelcomeSub.
  ///
  /// In en, this message translates to:
  /// **'your journey to a happier, healthier life starts now.'**
  String get mascotWelcomeSub;

  /// No description provided for @mascotEncourage.
  ///
  /// In en, this message translates to:
  /// **'keep it fresh'**
  String get mascotEncourage;

  /// No description provided for @mascotEncourageSub.
  ///
  /// In en, this message translates to:
  /// **'don\'t forget to update your master profile every time you get new experience!'**
  String get mascotEncourageSub;

  /// No description provided for @mascotExciting.
  ///
  /// In en, this message translates to:
  /// **'wih, amazing!'**
  String get mascotExciting;

  /// No description provided for @mascotExcitingSub.
  ///
  /// In en, this message translates to:
  /// **'you just created your first cv! let\'s keep the momentum going.'**
  String get mascotExcitingSub;

  /// No description provided for @cleverWelcomePersonaTitle.
  ///
  /// In en, this message translates to:
  /// **'which team are you on?'**
  String get cleverWelcomePersonaTitle;

  /// No description provided for @cleverPersonaStudent.
  ///
  /// In en, this message translates to:
  /// **'student'**
  String get cleverPersonaStudent;

  /// No description provided for @cleverPersonaJobSeeker.
  ///
  /// In en, this message translates to:
  /// **'active job seeker'**
  String get cleverPersonaJobSeeker;

  /// No description provided for @cleverPersonaCareerSwitcher.
  ///
  /// In en, this message translates to:
  /// **'switching careers'**
  String get cleverPersonaCareerSwitcher;

  /// No description provided for @cleverWelcomeBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'how much have you spent on a single CV service?'**
  String get cleverWelcomeBudgetTitle;

  /// No description provided for @cleverWelcomeSingleCvTitle.
  ///
  /// In en, this message translates to:
  /// **'do you use just 1 CV for every application?'**
  String get cleverWelcomeSingleCvTitle;

  /// No description provided for @cleverWelcomeAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'how many jobs do you apply to in a day?'**
  String get cleverWelcomeAppsTitle;

  /// No description provided for @cleverWelcomeReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'what makes you put off making tailored CVs?'**
  String get cleverWelcomeReasonTitle;

  /// No description provided for @cleverReasonCompanyResearch.
  ///
  /// In en, this message translates to:
  /// **'company research'**
  String get cleverReasonCompanyResearch;

  /// No description provided for @cleverReasonRepromptAi.
  ///
  /// In en, this message translates to:
  /// **'re-prompting chatGPT'**
  String get cleverReasonRepromptAi;

  /// No description provided for @cleverReasonManualTemplate.
  ///
  /// In en, this message translates to:
  /// **'editing templates manually'**
  String get cleverReasonManualTemplate;

  /// No description provided for @cleverReasonRepeatedForms.
  ///
  /// In en, this message translates to:
  /// **'filling in the same forms again'**
  String get cleverReasonRepeatedForms;

  /// No description provided for @cleverWelcomeThanksTitle.
  ///
  /// In en, this message translates to:
  /// **'thank you for trusting us.'**
  String get cleverWelcomeThanksTitle;

  /// No description provided for @cleverWelcomePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'your privacy and personal security are our top priority.'**
  String get cleverWelcomePrivacyNote;

  /// No description provided for @cleverReadMore.
  ///
  /// In en, this message translates to:
  /// **'read more'**
  String get cleverReadMore;

  /// No description provided for @cleverLegalPendingBody.
  ///
  /// In en, this message translates to:
  /// **'This document is being prepared and will be available here soon.'**
  String get cleverLegalPendingBody;

  /// No description provided for @cleverWelcomeSocialProofTitle.
  ///
  /// In en, this message translates to:
  /// **'applying to 100 openings becomes effective with tailored CVs!'**
  String get cleverWelcomeSocialProofTitle;

  /// No description provided for @cleverIntroTagline.
  ///
  /// In en, this message translates to:
  /// **'Your experience, always within reach.'**
  String get cleverIntroTagline;

  /// No description provided for @cleverIntroSupport.
  ///
  /// In en, this message translates to:
  /// **'build a professional track record you can use every time an opportunity comes.'**
  String get cleverIntroSupport;

  /// No description provided for @cleverIntroCta.
  ///
  /// In en, this message translates to:
  /// **'start now'**
  String get cleverIntroCta;

  /// No description provided for @cleverPanelHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'header'**
  String get cleverPanelHeaderTitle;

  /// No description provided for @cleverPanelHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'this information appears in your CV header as contact details.'**
  String get cleverPanelHeaderSubtitle;

  /// No description provided for @cleverPhoneField.
  ///
  /// In en, this message translates to:
  /// **'phone number'**
  String get cleverPhoneField;

  /// No description provided for @cleverTooltipBirthDate.
  ///
  /// In en, this message translates to:
  /// **'some job offers list age requirements — the AI tailoring uses this to match you.'**
  String get cleverTooltipBirthDate;

  /// No description provided for @cleverTooltipGender.
  ///
  /// In en, this message translates to:
  /// **'some job offers target a specific gender — the AI tailoring uses this to match you.'**
  String get cleverTooltipGender;

  /// No description provided for @cleverYearsOld.
  ///
  /// In en, this message translates to:
  /// **'{age} y.o.'**
  String cleverYearsOld(Object age);

  /// No description provided for @cleverGenderMale.
  ///
  /// In en, this message translates to:
  /// **'male'**
  String get cleverGenderMale;

  /// No description provided for @cleverGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'female'**
  String get cleverGenderFemale;

  /// No description provided for @cleverGenderNone.
  ///
  /// In en, this message translates to:
  /// **'rather not say'**
  String get cleverGenderNone;

  /// No description provided for @cleverConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'save your changes?'**
  String get cleverConfirmTitle;

  /// No description provided for @cleverConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'you have unsaved progress on your profile.'**
  String get cleverConfirmMessage;

  /// No description provided for @cleverConfirmSave.
  ///
  /// In en, this message translates to:
  /// **'save draft'**
  String get cleverConfirmSave;

  /// No description provided for @cleverConfirmDiscard.
  ///
  /// In en, this message translates to:
  /// **'discard'**
  String get cleverConfirmDiscard;

  /// No description provided for @cleverMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'choose your method'**
  String get cleverMethodTitle;

  /// No description provided for @cleverMethodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'pick whatever is most comfortable for filling in your career bank.'**
  String get cleverMethodSubtitle;

  /// No description provided for @cleverMethodScan.
  ///
  /// In en, this message translates to:
  /// **'scan'**
  String get cleverMethodScan;

  /// No description provided for @cleverMethodScanDesc.
  ///
  /// In en, this message translates to:
  /// **'import your professional history from an old cv draft.'**
  String get cleverMethodScanDesc;

  /// No description provided for @cleverMethodCerita.
  ///
  /// In en, this message translates to:
  /// **'story'**
  String get cleverMethodCerita;

  /// No description provided for @cleverMethodCeritaDesc.
  ///
  /// In en, this message translates to:
  /// **'no cv yet? just tell us your whole professional history'**
  String get cleverMethodCeritaDesc;

  /// No description provided for @cleverScanSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'your professional history gets extracted automatically by AI.'**
  String get cleverScanSheetSubtitle;

  /// No description provided for @cleverUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'upload photo'**
  String get cleverUploadPhoto;

  /// No description provided for @cleverUploadPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'use the camera or pick from your gallery.'**
  String get cleverUploadPhotoHint;

  /// No description provided for @cleverUploadFile.
  ///
  /// In en, this message translates to:
  /// **'upload file'**
  String get cleverUploadFile;

  /// No description provided for @cleverUploadFileHint.
  ///
  /// In en, this message translates to:
  /// **'pick a document from this device.'**
  String get cleverUploadFileHint;

  /// No description provided for @cleverExperienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'add every work experience you have.'**
  String get cleverExperienceSubtitle;

  /// No description provided for @cleverListLabel.
  ///
  /// In en, this message translates to:
  /// **'list'**
  String get cleverListLabel;

  /// No description provided for @cleverEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'nothing here yet'**
  String get cleverEmptyTitle;

  /// No description provided for @cleverEmptyExperiencePrompt.
  ///
  /// In en, this message translates to:
  /// **'start adding your work experience!'**
  String get cleverEmptyExperiencePrompt;

  /// No description provided for @cleverSkip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get cleverSkip;

  /// No description provided for @cleverDeleteExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'delete this experience?'**
  String get cleverDeleteExperienceTitle;

  /// No description provided for @cleverConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get cleverConfirmDelete;

  /// No description provided for @cleverToggleType.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get cleverToggleType;

  /// No description provided for @cleverToggleDictate.
  ///
  /// In en, this message translates to:
  /// **'dictate'**
  String get cleverToggleDictate;

  /// No description provided for @cleverEducationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'add every education you have completed.'**
  String get cleverEducationSubtitle;

  /// No description provided for @cleverEmptyEducationPrompt.
  ///
  /// In en, this message translates to:
  /// **'start adding your education!'**
  String get cleverEmptyEducationPrompt;

  /// No description provided for @cleverDeleteEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'delete this education?'**
  String get cleverDeleteEducationTitle;

  /// No description provided for @cleverCertificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'add every certification and license you hold.'**
  String get cleverCertificationSubtitle;

  /// No description provided for @cleverEmptyCertificationPrompt.
  ///
  /// In en, this message translates to:
  /// **'start adding your certifications!'**
  String get cleverEmptyCertificationPrompt;

  /// No description provided for @cleverDeleteCertificationTitle.
  ///
  /// In en, this message translates to:
  /// **'delete this certification?'**
  String get cleverDeleteCertificationTitle;

  /// No description provided for @cleverEmptySkillsPrompt.
  ///
  /// In en, this message translates to:
  /// **'start adding your skills!'**
  String get cleverEmptySkillsPrompt;

  /// No description provided for @cleverCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'all set!'**
  String get cleverCompleteTitle;

  /// No description provided for @cleverCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'your profile is complete.\nnow all that\'s left is making your first CV.'**
  String get cleverCompleteSubtitle;

  /// No description provided for @cleverCompleteSummary.
  ///
  /// In en, this message translates to:
  /// **'profile summary'**
  String get cleverCompleteSummary;

  /// No description provided for @cleverCompleteProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of 5'**
  String cleverCompleteProgress(int completed);

  /// No description provided for @cleverCompleteCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String cleverCompleteCount(int count);

  /// No description provided for @cleverCompleteRowHeader.
  ///
  /// In en, this message translates to:
  /// **'header — name, contact, birth date'**
  String get cleverCompleteRowHeader;

  /// No description provided for @cleverCompleteFootnote.
  ///
  /// In en, this message translates to:
  /// **'you can edit everything anytime in your profile.'**
  String get cleverCompleteFootnote;

  /// Import loading screen title per staging
  ///
  /// In en, this message translates to:
  /// **'importing'**
  String get cleverImportingTitle;

  /// No description provided for @aiAnalyzingProfile.
  ///
  /// In en, this message translates to:
  /// **'ai is analyzing your profile...'**
  String get aiAnalyzingProfile;

  /// No description provided for @aiExtractingInsights.
  ///
  /// In en, this message translates to:
  /// **'extracting insights...'**
  String get aiExtractingInsights;

  /// No description provided for @cvDataExists.
  ///
  /// In en, this message translates to:
  /// **'cv data already exists in your profile.'**
  String get cvDataExists;

  /// No description provided for @cvImportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'cv imported successfully! let\'s complete your profile.'**
  String get cvImportedSuccess;

  /// No description provided for @importCV.
  ///
  /// In en, this message translates to:
  /// **'import cv'**
  String get importCV;

  /// No description provided for @importCVMessage.
  ///
  /// In en, this message translates to:
  /// **'choose how to import your cv:'**
  String get importCVMessage;

  /// No description provided for @importCVTitle.
  ///
  /// In en, this message translates to:
  /// **'import cv'**
  String get importCVTitle;

  /// No description provided for @importFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'failed to import cv. please try again!'**
  String get importFailedMessage;

  /// No description provided for @importFromCV.
  ///
  /// In en, this message translates to:
  /// **'import from cv'**
  String get importFromCV;

  /// No description provided for @importSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'cv imported successfully!\nadded: {expCount} experience, {eduCount} education, {skillsCount} skills'**
  String importSuccessMessage(
    Object eduCount,
    Object expCount,
    Object skillsCount,
  );

  /// No description provided for @importSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'import successful!'**
  String get importSuccessTitle;

  /// No description provided for @importSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'here\'s what we found in your cv:'**
  String get importSuccessSubtitle;

  /// No description provided for @importSuccessPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'personal info detected'**
  String get importSuccessPersonalInfo;

  /// No description provided for @importSuccessExperience.
  ///
  /// In en, this message translates to:
  /// **'{count} experience(s)'**
  String importSuccessExperience(int count);

  /// No description provided for @importSuccessEducation.
  ///
  /// In en, this message translates to:
  /// **'{count} education(s)'**
  String importSuccessEducation(int count);

  /// No description provided for @importSuccessSkills.
  ///
  /// In en, this message translates to:
  /// **'{count} skill(s)'**
  String importSuccessSkills(int count);

  /// No description provided for @importSuccessCertifications.
  ///
  /// In en, this message translates to:
  /// **'{count} certification(s)'**
  String importSuccessCertifications(int count);

  /// No description provided for @importSuccessContinue.
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get importSuccessContinue;

  /// No description provided for @importSuccessNoNewData.
  ///
  /// In en, this message translates to:
  /// **'all data already exists in your profile.'**
  String get importSuccessNoNewData;

  /// No description provided for @jobExtractionFailed.
  ///
  /// In en, this message translates to:
  /// **'failed to extract job posting'**
  String get jobExtractionFailed;

  /// No description provided for @jobExtractionSuccess.
  ///
  /// In en, this message translates to:
  /// **'job posting extracted successfully!'**
  String get jobExtractionSuccess;

  /// No description provided for @noTextFound.
  ///
  /// In en, this message translates to:
  /// **'no text found in image'**
  String get noTextFound;

  /// No description provided for @noTextFoundInCV.
  ///
  /// In en, this message translates to:
  /// **'no text found in cv'**
  String get noTextFoundInCV;

  /// No description provided for @ocrScanning.
  ///
  /// In en, this message translates to:
  /// **'ocr scanning'**
  String get ocrScanning;

  /// No description provided for @scanJobPosting.
  ///
  /// In en, this message translates to:
  /// **'scan job posting'**
  String get scanJobPosting;

  /// No description provided for @searchJob.
  ///
  /// In en, this message translates to:
  /// **'search for jobs...'**
  String get searchJob;

  /// No description provided for @cv.
  ///
  /// In en, this message translates to:
  /// **'cv'**
  String get cv;

  /// No description provided for @aiAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'ai analysis'**
  String get aiAnalysisTitle;

  /// No description provided for @aiTailoringOptions.
  ///
  /// In en, this message translates to:
  /// **'ai tailoring options'**
  String get aiTailoringOptions;

  /// No description provided for @aiHelpCreateCV.
  ///
  /// In en, this message translates to:
  /// **'ai will help create a cv perfectly tailored for this goal.'**
  String get aiHelpCreateCV;

  /// No description provided for @aiTestingConstraints.
  ///
  /// In en, this message translates to:
  /// **'testing against ats constraints...'**
  String get aiTestingConstraints;

  /// No description provided for @maxSkills.
  ///
  /// In en, this message translates to:
  /// **'max skills'**
  String get maxSkills;

  /// No description provided for @honestAiFeedback.
  ///
  /// In en, this message translates to:
  /// **'honest ai feedback'**
  String get honestAiFeedback;

  /// No description provided for @honestAiFeedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'get strict & critical advice'**
  String get honestAiFeedbackDesc;

  /// No description provided for @conciseFormat.
  ///
  /// In en, this message translates to:
  /// **'concise format'**
  String get conciseFormat;

  /// No description provided for @conciseFormatDesc.
  ///
  /// In en, this message translates to:
  /// **'focus on brevity & impact'**
  String get conciseFormatDesc;

  /// No description provided for @cvOutputLanguage.
  ///
  /// In en, this message translates to:
  /// **'cv output language'**
  String get cvOutputLanguage;

  /// No description provided for @cvOutputLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'ai will write your cv content in this language'**
  String get cvOutputLanguageDesc;

  /// No description provided for @cvOutputLanguageAuto.
  ///
  /// In en, this message translates to:
  /// **'auto'**
  String get cvOutputLanguageAuto;

  /// No description provided for @atsStandard.
  ///
  /// In en, this message translates to:
  /// **'ats standard'**
  String get atsStandard;

  /// No description provided for @autoFillFromMaster.
  ///
  /// In en, this message translates to:
  /// **'data auto-filled from your master profile'**
  String get autoFillFromMaster;

  /// No description provided for @createCV.
  ///
  /// In en, this message translates to:
  /// **'create cv'**
  String get createCV;

  /// No description provided for @creativeDesign.
  ///
  /// In en, this message translates to:
  /// **'creative design'**
  String get creativeDesign;

  /// No description provided for @cvGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'cv generated successfully'**
  String get cvGeneratedSuccess;

  /// No description provided for @cvReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'your cv for {jobTitle} is ready!'**
  String cvReadyMessage(Object jobTitle);

  /// No description provided for @generateCVFirst.
  ///
  /// In en, this message translates to:
  /// **'generate your first cv to see it here'**
  String get generateCVFirst;

  /// No description provided for @cvs.
  ///
  /// In en, this message translates to:
  /// **'cvs'**
  String get cvs;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'drafts'**
  String get drafts;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'export pdf'**
  String get exportPdf;

  /// No description provided for @fetchingTemplates.
  ///
  /// In en, this message translates to:
  /// **'fetching templates...'**
  String get fetchingTemplates;

  /// No description provided for @folderEmpty.
  ///
  /// In en, this message translates to:
  /// **'folder is empty'**
  String get folderEmpty;

  /// No description provided for @includeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'include profile photo'**
  String get includeProfilePhoto;

  /// No description provided for @jobListScannerHint.
  ///
  /// In en, this message translates to:
  /// **'found a job here? take a screenshot and use our smart scanner to instantly auto-fill your cv!'**
  String get jobListScannerHint;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get locked;

  /// No description provided for @loadingTemplatesBadge.
  ///
  /// In en, this message translates to:
  /// **'loading templates'**
  String get loadingTemplatesBadge;

  /// No description provided for @myCVs.
  ///
  /// In en, this message translates to:
  /// **'my cvs'**
  String get myCVs;

  /// No description provided for @myDrafts.
  ///
  /// In en, this message translates to:
  /// **'my drafts'**
  String get myDrafts;

  /// No description provided for @noDrafts.
  ///
  /// In en, this message translates to:
  /// **'no drafts yet.'**
  String get noDrafts;

  /// No description provided for @noMatchingPdfs.
  ///
  /// In en, this message translates to:
  /// **'no pdfs match your search.'**
  String get noMatchingPdfs;

  /// No description provided for @searchGeneratedCvs.
  ///
  /// In en, this message translates to:
  /// **'search generated cvs...'**
  String get searchGeneratedCvs;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'premium'**
  String get premium;

  /// No description provided for @previewTemplate.
  ///
  /// In en, this message translates to:
  /// **'preview template'**
  String get previewTemplate;

  /// No description provided for @requirementsCheckLabel.
  ///
  /// In en, this message translates to:
  /// **'requirements check:'**
  String get requirementsCheckLabel;

  /// No description provided for @reviewData.
  ///
  /// In en, this message translates to:
  /// **'review data'**
  String get reviewData;

  /// No description provided for @reviewedByAI.
  ///
  /// In en, this message translates to:
  /// **'data & summary tailored by ai'**
  String get reviewedByAI;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'select template'**
  String get selectTemplate;

  /// No description provided for @tailoredDataMessage.
  ///
  /// In en, this message translates to:
  /// **'this data has been tailored by ai to be relevant to your target position. please review!'**
  String get tailoredDataMessage;

  /// No description provided for @templateLoadError.
  ///
  /// In en, this message translates to:
  /// **'error loading templates: {error}'**
  String templateLoadError(Object error);

  /// No description provided for @usingMasterPhoto.
  ///
  /// In en, this message translates to:
  /// **'using master profile photo'**
  String get usingMasterPhoto;

  /// No description provided for @viewDrafts.
  ///
  /// In en, this message translates to:
  /// **'view drafts'**
  String get viewDrafts;

  /// No description provided for @generateCvFree.
  ///
  /// In en, this message translates to:
  /// **'generate'**
  String get generateCvFree;

  /// No description provided for @cvExport.
  ///
  /// In en, this message translates to:
  /// **'cv export'**
  String get cvExport;

  /// No description provided for @freeExportsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} free exports left'**
  String freeExportsLeft(Object count);

  /// No description provided for @exports.
  ///
  /// In en, this message translates to:
  /// **'exports'**
  String get exports;

  /// No description provided for @templateRequiresPhoto.
  ///
  /// In en, this message translates to:
  /// **'this template needs a photo'**
  String get templateRequiresPhoto;

  /// No description provided for @templateRequiresPhotoDesc.
  ///
  /// In en, this message translates to:
  /// **'you selected a style with a profile photo, but no photo has been uploaded yet.'**
  String get templateRequiresPhotoDesc;

  /// No description provided for @useStyleWithoutPhoto.
  ///
  /// In en, this message translates to:
  /// **'use style without photo'**
  String get useStyleWithoutPhoto;

  /// No description provided for @accountDeleteError.
  ///
  /// In en, this message translates to:
  /// **'failed to delete account: {error}'**
  String accountDeleteError(Object error);

  /// No description provided for @accountDeletedGoodbye.
  ///
  /// In en, this message translates to:
  /// **'account successfully deleted. goodbye!'**
  String get accountDeletedGoodbye;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'quick actions'**
  String get quickActions;

  /// No description provided for @cleverUser.
  ///
  /// In en, this message translates to:
  /// **'clever user'**
  String get cleverUser;

  /// No description provided for @bugReport.
  ///
  /// In en, this message translates to:
  /// **'bug report'**
  String get bugReport;

  /// No description provided for @completeProfileFirst.
  ///
  /// In en, this message translates to:
  /// **'complete profile first for best results'**
  String get completeProfileFirst;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'confirm deletion'**
  String get confirmDelete;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'contact support'**
  String get contactSupport;

  /// No description provided for @noCompletedCVs.
  ///
  /// In en, this message translates to:
  /// **'no generated cvs yet'**
  String get noCompletedCVs;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'delete account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'this action is irreversible. all your data, including generated cvs and active subscriptions, will be permanently deleted.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// No description provided for @editExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'edit experience'**
  String get editExperienceTitle;

  /// No description provided for @faqDataAnswer.
  ///
  /// In en, this message translates to:
  /// **'your data is stored locally (master profile). data sent to ai is processed briefly and not stored.'**
  String get faqDataAnswer;

  /// No description provided for @faqDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'is my data safe?'**
  String get faqDataQuestion;

  /// No description provided for @faqEditAnswer.
  ///
  /// In en, this message translates to:
  /// **'go to the profile menu, edit the section you want, and hit save.'**
  String get faqEditAnswer;

  /// No description provided for @faqEditQuestion.
  ///
  /// In en, this message translates to:
  /// **'how to edit profile?'**
  String get faqEditQuestion;

  /// No description provided for @faqFreeAnswer.
  ///
  /// In en, this message translates to:
  /// **'yes, basic features are free. we might add premium features in the future.'**
  String get faqFreeAnswer;

  /// No description provided for @faqFreeQuestion.
  ///
  /// In en, this message translates to:
  /// **'is cv master free?'**
  String get faqFreeQuestion;

  /// No description provided for @faqPdfAnswer.
  ///
  /// In en, this message translates to:
  /// **'sure! after creating your cv, you can download/print pdf in the preview.'**
  String get faqPdfAnswer;

  /// No description provided for @faqPdfQuestion.
  ///
  /// In en, this message translates to:
  /// **'can i export to pdf?'**
  String get faqPdfQuestion;

  /// No description provided for @featureRequest.
  ///
  /// In en, this message translates to:
  /// **'feature request'**
  String get featureRequest;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'feedback'**
  String get feedback;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'share your experience or report an issue.'**
  String get feedbackSubtitle;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'message'**
  String get message;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'recent transactions'**
  String get recentTransactions;

  /// No description provided for @feedbackThanksMessage.
  ///
  /// In en, this message translates to:
  /// **'your feedback is valuable for cv master development.'**
  String get feedbackThanksMessage;

  /// No description provided for @frequentQuestions.
  ///
  /// In en, this message translates to:
  /// **'common questions'**
  String get frequentQuestions;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'help & support'**
  String get helpSupport;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get home;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'how can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'log out'**
  String get logOut;

  /// No description provided for @masterProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'master profile updated successfully'**
  String get masterProfileUpdated;

  /// No description provided for @noMatchingJobs.
  ///
  /// In en, this message translates to:
  /// **'no matching jobs found.'**
  String get noMatchingJobs;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'no notifications yet'**
  String get noNotifications;

  /// No description provided for @notificationChannelCVDesc.
  ///
  /// In en, this message translates to:
  /// **'notifications for cv generation updates'**
  String get notificationChannelCVDesc;

  /// No description provided for @notificationChannelCVTitle.
  ///
  /// In en, this message translates to:
  /// **'cv generation'**
  String get notificationChannelCVTitle;

  /// No description provided for @notificationChannelGeneralDesc.
  ///
  /// In en, this message translates to:
  /// **'general app notifications'**
  String get notificationChannelGeneralDesc;

  /// No description provided for @notificationChannelGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'general alerts'**
  String get notificationChannelGeneralTitle;

  /// No description provided for @notificationNew.
  ///
  /// In en, this message translates to:
  /// **'new notification'**
  String get notificationNew;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'notifications'**
  String get notifications;

  /// No description provided for @photoSettings.
  ///
  /// In en, this message translates to:
  /// **'photo settings'**
  String get photoSettings;

  /// No description provided for @photoUpdateError.
  ///
  /// In en, this message translates to:
  /// **'error uploading photo: {error}'**
  String photoUpdateError(String error);

  /// No description provided for @photoUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'profile photo updated successfully!'**
  String get photoUpdateSuccess;

  /// No description provided for @profilePhotoExportTooltip.
  ///
  /// In en, this message translates to:
  /// **'this photo will be used for every pdf export that includes a photo.'**
  String get profilePhotoExportTooltip;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get privacyPolicy;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get profile;

  /// No description provided for @profileSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'profile saved! will be used for your next cv.'**
  String get profileSavedSuccess;

  /// No description provided for @saveChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Would you like to save them before leaving?'**
  String get saveChangesMessage;

  /// No description provided for @saveChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get saveChangesTitle;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'save profile'**
  String get saveProfile;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'send feedback'**
  String get sendFeedback;

  /// No description provided for @suggestionsBugs.
  ///
  /// In en, this message translates to:
  /// **'suggestions & bugs'**
  String get suggestionsBugs;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'terms of service'**
  String get termsOfService;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'wallet'**
  String get wallet;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'no transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @failedToLoadTransactions.
  ///
  /// In en, this message translates to:
  /// **'failed to load transactions'**
  String get failedToLoadTransactions;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'transaction history'**
  String get transactionHistory;

  /// No description provided for @reviewPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Loving your new CV?'**
  String get reviewPromptTitle;

  /// No description provided for @reviewPromptContent.
  ///
  /// In en, this message translates to:
  /// **'Your support keeps CleVer running. If you\'re happy, a quick review means the world to us!'**
  String get reviewPromptContent;

  /// No description provided for @reviewPromptPositive.
  ///
  /// In en, this message translates to:
  /// **'I love it!'**
  String get reviewPromptPositive;

  /// No description provided for @reviewPromptNegative.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get reviewPromptNegative;

  /// No description provided for @tutorialJobOcrTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Job Postings'**
  String get tutorialJobOcrTitle;

  /// No description provided for @tutorialJobOcrDesc.
  ///
  /// In en, this message translates to:
  /// **'Did you know you can screenshot a job posting? We\'ll extract the details for you instantly!'**
  String get tutorialJobOcrDesc;

  /// No description provided for @tutorialDraftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Drafts'**
  String get tutorialDraftsTitle;

  /// No description provided for @tutorialDraftsDesc.
  ///
  /// In en, this message translates to:
  /// **'You can edit your drafts here and export them with different designs anytime.'**
  String get tutorialDraftsDesc;

  /// No description provided for @tutorialProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Profile'**
  String get tutorialProfileTitle;

  /// No description provided for @tutorialProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your Master Profile here to keep your base CV data up to date.'**
  String get tutorialProfileDesc;

  /// No description provided for @tutorialNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNext;

  /// No description provided for @tutorialFinish.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get tutorialFinish;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get active;

  /// No description provided for @activePass.
  ///
  /// In en, this message translates to:
  /// **'active pass'**
  String get activePass;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get free;

  /// No description provided for @membershipStatus.
  ///
  /// In en, this message translates to:
  /// **'membership status'**
  String get membershipStatus;

  /// No description provided for @subscriptionWarning.
  ///
  /// In en, this message translates to:
  /// **'you have an active job hunter pass. deleting your account will terminate your access immediately and cannot be refunded.'**
  String get subscriptionWarning;

  /// No description provided for @jobHunterPass.
  ///
  /// In en, this message translates to:
  /// **'job hunter pass'**
  String get jobHunterPass;

  /// No description provided for @getJobHunterPassNow.
  ///
  /// In en, this message translates to:
  /// **'subscribe'**
  String get getJobHunterPassNow;

  /// No description provided for @paywallHeadline.
  ///
  /// In en, this message translates to:
  /// **'Land Your Dream Job'**
  String get paywallHeadline;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get bestValue;

  /// No description provided for @downsellHeadline.
  ///
  /// In en, this message translates to:
  /// **'Just Need It Today?'**
  String get downsellHeadline;

  /// No description provided for @downsellCta.
  ///
  /// In en, this message translates to:
  /// **'Try It for 24 Hours'**
  String get downsellCta;

  /// No description provided for @downsellTrust.
  ///
  /// In en, this message translates to:
  /// **'No auto-renew · One-time pass'**
  String get downsellTrust;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get noThanks;

  /// No description provided for @paywallSimpleBenefit.
  ///
  /// In en, this message translates to:
  /// **'access all features and templates unlimited. no ads'**
  String get paywallSimpleBenefit;

  /// No description provided for @product24hTitle.
  ///
  /// In en, this message translates to:
  /// **'24 Hour Pass'**
  String get product24hTitle;

  /// No description provided for @product24hDesc.
  ///
  /// In en, this message translates to:
  /// **'Full access for 24 hours'**
  String get product24hDesc;

  /// No description provided for @product3dTitle.
  ///
  /// In en, this message translates to:
  /// **'3 Day Pass'**
  String get product3dTitle;

  /// No description provided for @product3dDesc.
  ///
  /// In en, this message translates to:
  /// **'Full access for 3 days'**
  String get product3dDesc;

  /// No description provided for @productWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get productWeeklyTitle;

  /// No description provided for @productWeeklyDesc.
  ///
  /// In en, this message translates to:
  /// **'≈ {price}/day'**
  String productWeeklyDesc(String price);

  /// No description provided for @productMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get productMonthlyTitle;

  /// No description provided for @productMonthlyDesc.
  ///
  /// In en, this message translates to:
  /// **'≈ {price}/day'**
  String productMonthlyDesc(String price);

  /// No description provided for @productYearlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get productYearlyTitle;

  /// No description provided for @productYearlyDesc.
  ///
  /// In en, this message translates to:
  /// **'≈ {price}/day'**
  String productYearlyDesc(String price);

  /// No description provided for @productLifetimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Access'**
  String get productLifetimeTitle;

  /// No description provided for @productLifetimeDesc.
  ///
  /// In en, this message translates to:
  /// **'One-time payment · Forever'**
  String get productLifetimeDesc;

  /// No description provided for @passLifetime.
  ///
  /// In en, this message translates to:
  /// **'lifetime'**
  String get passLifetime;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'activate'**
  String get activate;

  /// No description provided for @subscriptionExpiryCount.
  ///
  /// In en, this message translates to:
  /// **'expires in {time}'**
  String subscriptionExpiryCount(String time);

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'upgrade now'**
  String get upgradeNow;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get weekly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'yearly'**
  String get yearly;

  /// No description provided for @deviceLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Device limit reached. Free exports are limited to 2 per device.'**
  String get deviceLimitReached;

  /// No description provided for @lifetimeAccessActive.
  ///
  /// In en, this message translates to:
  /// **'You have Lifetime Access!'**
  String get lifetimeAccessActive;

  /// No description provided for @lifetimeAccessActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Enjoy unlimited CV generation and premium templates forever. No further actions needed.'**
  String get lifetimeAccessActiveDesc;

  /// No description provided for @upgradeToLifetime.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Lifetime'**
  String get upgradeToLifetime;

  /// No description provided for @upgradeToLifetimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Get unlimited access forever and stop recurring billing.'**
  String get upgradeToLifetimeDesc;

  /// No description provided for @cancelRecurringWarning.
  ///
  /// In en, this message translates to:
  /// **'You currently have an active subscription. Confirm now to instantly upgrade to Lifetime!'**
  String get cancelRecurringWarning;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'almost there...'**
  String get almostThere;

  /// No description provided for @analyzeProfileError.
  ///
  /// In en, this message translates to:
  /// **'failed to analyze profile: {error}'**
  String analyzeProfileError(Object error);

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get category;

  /// No description provided for @continuingToForm.
  ///
  /// In en, this message translates to:
  /// **'continuing to form...'**
  String get continuingToForm;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get created;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'date:'**
  String get dateLabel;

  /// No description provided for @errorDetailsCopied.
  ///
  /// In en, this message translates to:
  /// **'error details copied to clipboard'**
  String get errorDetailsCopied;

  /// No description provided for @fillDescriptionFirst.
  ///
  /// In en, this message translates to:
  /// **'please fill in the description first to use ai rewrite!'**
  String get fillDescriptionFirst;

  /// No description provided for @fillJobTitle.
  ///
  /// In en, this message translates to:
  /// **'fill job title first!'**
  String get fillJobTitle;

  /// No description provided for @fillNameError.
  ///
  /// In en, this message translates to:
  /// **'please fill in your full name first.'**
  String get fillNameError;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'generated'**
  String get generated;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'get started'**
  String get getStarted;

  /// No description provided for @jobDetailHint.
  ///
  /// In en, this message translates to:
  /// **'paste job description, requirements, or qualifications here...'**
  String get jobDetailHint;

  /// No description provided for @jobDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'detail / qualification (optional)'**
  String get jobDetailLabel;

  /// No description provided for @messageDetail.
  ///
  /// In en, this message translates to:
  /// **'message / detail'**
  String get messageDetail;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get allFilter;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'question'**
  String get question;

  /// No description provided for @rewrite.
  ///
  /// In en, this message translates to:
  /// **'rewrite'**
  String get rewrite;

  /// No description provided for @rewriteAI.
  ///
  /// In en, this message translates to:
  /// **'rewrite ai'**
  String get rewriteAI;

  /// No description provided for @rewriteFailed.
  ///
  /// In en, this message translates to:
  /// **'rewrite failed: {error}'**
  String rewriteFailed(String error);

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'sending...'**
  String get sending;

  /// No description provided for @skillHint.
  ///
  /// In en, this message translates to:
  /// **'ex: flutter, leadership'**
  String get skillHint;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'technical details'**
  String get technicalDetails;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'thank you!'**
  String get thankYou;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'listening...'**
  String get voiceListening;

  /// No description provided for @voiceProcessing.
  ///
  /// In en, this message translates to:
  /// **'processing...'**
  String get voiceProcessing;

  /// No description provided for @voiceParseError.
  ///
  /// In en, this message translates to:
  /// **'couldn\'t process your voice input. please try again.'**
  String get voiceParseError;

  /// No description provided for @voiceUseSuara.
  ///
  /// In en, this message translates to:
  /// **'Use voice'**
  String get voiceUseSuara;

  /// No description provided for @voiceAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'analyzing...'**
  String get voiceAnalyzing;

  /// No description provided for @voiceAlmostDone.
  ///
  /// In en, this message translates to:
  /// **'almost done...'**
  String get voiceAlmostDone;

  /// No description provided for @voiceSpeechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition unavailable'**
  String get voiceSpeechUnavailable;

  /// No description provided for @voiceTapMicHint.
  ///
  /// In en, this message translates to:
  /// **'Tap mic & speak naturally'**
  String get voiceTapMicHint;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
