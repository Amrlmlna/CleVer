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

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your CVs across devices'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey to a better career'**
  String get createAccountSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @welcomeBackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBackSuccess;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google!'**
  String get googleSignInSuccess;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed: {error}'**
  String googleSignInError(Object error);

  /// No description provided for @errorDetailsCopied.
  ///
  /// In en, this message translates to:
  /// **'Error details copied to clipboard'**
  String get errorDetailsCopied;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'TECHNICAL DETAILS'**
  String get technicalDetails;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @rewrite.
  ///
  /// In en, this message translates to:
  /// **'Rewrite'**
  String get rewrite;

  /// No description provided for @typeHere.
  ///
  /// In en, this message translates to:
  /// **'Type here...'**
  String get typeHere;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// No description provided for @header.
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get header;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location (Search City/Regency)'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Jakarta -> DKI Jakarta, South Jakarta'**
  String get locationHint;

  /// No description provided for @schoolLabel.
  ///
  /// In en, this message translates to:
  /// **'School / University'**
  String get schoolLabel;

  /// No description provided for @schoolHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: University of Indonesia'**
  String get schoolHint;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @syncData.
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get syncData;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @completeProfileFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete profile first for best results'**
  String get completeProfileFirst;

  /// No description provided for @validatingData.
  ///
  /// In en, this message translates to:
  /// **'Validating data...'**
  String get validatingData;

  /// No description provided for @preparingProfile.
  ///
  /// In en, this message translates to:
  /// **'Preparing profile...'**
  String get preparingProfile;

  /// No description provided for @continuingToForm.
  ///
  /// In en, this message translates to:
  /// **'Continuing to form...'**
  String get continuingToForm;

  /// No description provided for @analyzeProfileError.
  ///
  /// In en, this message translates to:
  /// **'Failed to analyze profile: {error}'**
  String analyzeProfileError(Object error);

  /// No description provided for @fillJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill job title first!'**
  String get fillJobTitle;

  /// No description provided for @scanJobPosting.
  ///
  /// In en, this message translates to:
  /// **'Scan Job Posting'**
  String get scanJobPosting;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @ocrScanning.
  ///
  /// In en, this message translates to:
  /// **'OCR SCANNING'**
  String get ocrScanning;

  /// No description provided for @analyzingText.
  ///
  /// In en, this message translates to:
  /// **'Analyzing text...'**
  String get analyzingText;

  /// No description provided for @identifyingVacancy.
  ///
  /// In en, this message translates to:
  /// **'Identifying vacancy...'**
  String get identifyingVacancy;

  /// No description provided for @organizingData.
  ///
  /// In en, this message translates to:
  /// **'Organizing data...'**
  String get organizingData;

  /// No description provided for @finalizing.
  ///
  /// In en, this message translates to:
  /// **'Finalizing...'**
  String get finalizing;

  /// No description provided for @jobExtractionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Job posting extracted successfully!'**
  String get jobExtractionSuccess;

  /// No description provided for @noTextFound.
  ///
  /// In en, this message translates to:
  /// **'No text found in image'**
  String get noTextFound;

  /// No description provided for @jobExtractionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to extract job posting'**
  String get jobExtractionFailed;

  /// No description provided for @targetPosition.
  ///
  /// In en, this message translates to:
  /// **'Target Position'**
  String get targetPosition;

  /// No description provided for @continueToReview.
  ///
  /// In en, this message translates to:
  /// **'Continue: Review Data'**
  String get continueToReview;

  /// No description provided for @whatJobApply.
  ///
  /// In en, this message translates to:
  /// **'What job are you applying for?'**
  String get whatJobApply;

  /// No description provided for @aiHelpCreateCV.
  ///
  /// In en, this message translates to:
  /// **'AI will help create a CV perfectly tailored for this goal.'**
  String get aiHelpCreateCV;

  /// No description provided for @positionHint.
  ///
  /// In en, this message translates to:
  /// **'Position (Ex: UI Designer)'**
  String get positionHint;

  /// No description provided for @companyHint.
  ///
  /// In en, this message translates to:
  /// **'Company Name (Optional)'**
  String get companyHint;

  /// No description provided for @requiredFieldFriendly.
  ///
  /// In en, this message translates to:
  /// **'This is required!'**
  String get requiredFieldFriendly;

  /// No description provided for @jobDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Detail / Qualification (Optional)'**
  String get jobDetailLabel;

  /// No description provided for @jobDetailHint.
  ///
  /// In en, this message translates to:
  /// **'Paste job description, requirements, or qualifications here...'**
  String get jobDetailHint;

  /// No description provided for @reviewedByAI.
  ///
  /// In en, this message translates to:
  /// **'Data & Summary tailored by AI'**
  String get reviewedByAI;

  /// No description provided for @autoFillFromMaster.
  ///
  /// In en, this message translates to:
  /// **'Data auto-filled from your Master Profile'**
  String get autoFillFromMaster;

  /// No description provided for @jobInputMissing.
  ///
  /// In en, this message translates to:
  /// **'Error: Job Input missing'**
  String get jobInputMissing;

  /// No description provided for @generateSummaryFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate summary: {error}'**
  String generateSummaryFailed(Object error);

  /// No description provided for @masterProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Master Profile updated successfully'**
  String get masterProfileUpdated;

  /// No description provided for @reviewData.
  ///
  /// In en, this message translates to:
  /// **'Review Data'**
  String get reviewData;

  /// No description provided for @continueChooseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Continue: Choose Template'**
  String get continueChooseTemplate;

  /// No description provided for @tailoredDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This data has been tailored by AI to be relevant to your target position. Please review!'**
  String get tailoredDataMessage;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @professionalSummary.
  ///
  /// In en, this message translates to:
  /// **'Professional Summary'**
  String get professionalSummary;

  /// No description provided for @workExperience.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get workExperience;

  /// No description provided for @educationHistory.
  ///
  /// In en, this message translates to:
  /// **'Education History'**
  String get educationHistory;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @summaryHint.
  ///
  /// In en, this message translates to:
  /// **'Write a brief professional summary...'**
  String get summaryHint;

  /// No description provided for @summaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Summary cannot be empty'**
  String get summaryEmpty;

  /// No description provided for @generateWithAI.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get generateWithAI;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noExperience.
  ///
  /// In en, this message translates to:
  /// **'No work experience yet.'**
  String get noExperience;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'School Name'**
  String get schoolName;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'Degree / Major'**
  String get degree;

  /// No description provided for @degreeHint.
  ///
  /// In en, this message translates to:
  /// **'Bachelor of Computer Science'**
  String get degreeHint;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'ADD EDUCATION'**
  String get addEducation;

  /// No description provided for @editEducation.
  ///
  /// In en, this message translates to:
  /// **'EDIT EDUCATION'**
  String get editEducation;

  /// No description provided for @cancelAllCaps.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelAllCaps;

  /// No description provided for @saveAllCaps.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get saveAllCaps;

  /// No description provided for @noEducation.
  ///
  /// In en, this message translates to:
  /// **'No education history yet.'**
  String get noEducation;

  /// No description provided for @certificationsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Certifications & Licenses'**
  String get certificationsLicenses;

  /// No description provided for @noCertifications.
  ///
  /// In en, this message translates to:
  /// **'No certifications yet.'**
  String get noCertifications;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'Add Skill'**
  String get addSkill;

  /// No description provided for @skillHint.
  ///
  /// In en, this message translates to:
  /// **'ex: Flutter, Leadership'**
  String get skillHint;

  /// No description provided for @noSkills.
  ///
  /// In en, this message translates to:
  /// **'No skills yet.'**
  String get noSkills;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// No description provided for @writing.
  ///
  /// In en, this message translates to:
  /// **'Writing...'**
  String get writing;

  /// No description provided for @fillDescriptionFirst.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the description first to use AI rewrite!'**
  String get fillDescriptionFirst;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @companyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ex: Google'**
  String get companyPlaceholder;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @untilNow.
  ///
  /// In en, this message translates to:
  /// **'Until Now'**
  String get untilNow;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get shortDescription;

  /// No description provided for @improving.
  ///
  /// In en, this message translates to:
  /// **'Improving...'**
  String get improving;

  /// No description provided for @polishing.
  ///
  /// In en, this message translates to:
  /// **'Polishing...'**
  String get polishing;

  /// No description provided for @rephrasing.
  ///
  /// In en, this message translates to:
  /// **'Rephrasing...'**
  String get rephrasing;

  /// No description provided for @rewriteAI.
  ///
  /// In en, this message translates to:
  /// **'Rewrite AI'**
  String get rewriteAI;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Explain your main responsibilities and achievements...'**
  String get descriptionHint;

  /// No description provided for @addExperience.
  ///
  /// In en, this message translates to:
  /// **'ADD EXPERIENCE'**
  String get addExperience;

  /// No description provided for @editExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'EDIT EXPERIENCE'**
  String get editExperienceTitle;

  /// No description provided for @addCertification.
  ///
  /// In en, this message translates to:
  /// **'Add Certification'**
  String get addCertification;

  /// No description provided for @editCertification.
  ///
  /// In en, this message translates to:
  /// **'Edit Certification'**
  String get editCertification;

  /// No description provided for @certificationName.
  ///
  /// In en, this message translates to:
  /// **'Certification Name'**
  String get certificationName;

  /// No description provided for @issuer.
  ///
  /// In en, this message translates to:
  /// **'Issuer'**
  String get issuer;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dateLabel;

  /// No description provided for @myDrafts.
  ///
  /// In en, this message translates to:
  /// **'My Drafts'**
  String get myDrafts;

  /// No description provided for @searchJob.
  ///
  /// In en, this message translates to:
  /// **'Search for jobs...'**
  String get searchJob;

  /// No description provided for @noDrafts.
  ///
  /// In en, this message translates to:
  /// **'No drafts yet.'**
  String get noDrafts;

  /// No description provided for @noMatchingJobs.
  ///
  /// In en, this message translates to:
  /// **'No matching jobs found.'**
  String get noMatchingJobs;

  /// No description provided for @folderEmpty.
  ///
  /// In en, this message translates to:
  /// **'Folder is empty'**
  String get folderEmpty;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @atsStandard.
  ///
  /// In en, this message translates to:
  /// **'ATS Standard'**
  String get atsStandard;

  /// No description provided for @modernProfessional.
  ///
  /// In en, this message translates to:
  /// **'Modern Professional'**
  String get modernProfessional;

  /// No description provided for @creativeDesign.
  ///
  /// In en, this message translates to:
  /// **'Creative Design'**
  String get creativeDesign;

  /// No description provided for @aiPowered.
  ///
  /// In en, this message translates to:
  /// **'AI POWERED'**
  String get aiPowered;

  /// No description provided for @createProfessionalCV.
  ///
  /// In en, this message translates to:
  /// **'Create a\nProfessional CV.'**
  String get createProfessionalCV;

  /// No description provided for @createFirstCV.
  ///
  /// In en, this message translates to:
  /// **'Create Your\nFirst CV.'**
  String get createFirstCV;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'START NOW'**
  String get startNow;

  /// No description provided for @importCV.
  ///
  /// In en, this message translates to:
  /// **'Import CV'**
  String get importCV;

  /// No description provided for @viewDrafts.
  ///
  /// In en, this message translates to:
  /// **'View Drafts'**
  String get viewDrafts;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @createCV.
  ///
  /// In en, this message translates to:
  /// **'Create CV'**
  String get createCV;

  /// No description provided for @cvImportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV imported successfully! Let\'s complete your profile.'**
  String get cvImportedSuccess;

  /// No description provided for @cvDataExists.
  ///
  /// In en, this message translates to:
  /// **'CV data already exists in your profile.'**
  String get cvDataExists;

  /// No description provided for @loginToSave.
  ///
  /// In en, this message translates to:
  /// **'Login to save your data'**
  String get loginToSave;

  /// No description provided for @syncAnywhere.
  ///
  /// In en, this message translates to:
  /// **'Access from any device, auto-sync'**
  String get syncAnywhere;

  /// No description provided for @importFromCV.
  ///
  /// In en, this message translates to:
  /// **'IMPORT FROM CV'**
  String get importFromCV;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'GET CREDITS'**
  String get premiumBadge;

  /// No description provided for @unlockFeatures.
  ///
  /// In en, this message translates to:
  /// **'Refill generation credits'**
  String get unlockFeatures;

  /// No description provided for @premiumFeaturesDesc.
  ///
  /// In en, this message translates to:
  /// **'• ATS-optimized templates\n• Unlimited CV exports\n• Cloud sync across devices\n• Priority support'**
  String get premiumFeaturesDesc;

  /// No description provided for @premiumComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Premium - Coming soon!'**
  String get premiumComingSoon;

  /// No description provided for @viewPremiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'View Premium Features'**
  String get viewPremiumFeatures;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @cvs.
  ///
  /// In en, this message translates to:
  /// **'CVs'**
  String get cvs;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @cvImportSuccessWithCount.
  ///
  /// In en, this message translates to:
  /// **'CV imported successfully!\nAdded: {expCount} experience, {eduCount} education'**
  String cvImportSuccessWithCount(Object eduCount, Object expCount);

  /// No description provided for @helloName.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloName(Object name);

  /// No description provided for @userLevelRookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie Job Seeker'**
  String get userLevelRookie;

  /// No description provided for @userLevelMid.
  ///
  /// In en, this message translates to:
  /// **'Mid-Level Professional'**
  String get userLevelMid;

  /// No description provided for @userLevelExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert Career Builder'**
  String get userLevelExpert;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Start creating your first professional CV now.'**
  String get welcomeMessage;

  /// No description provided for @cvTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'CV Tips'**
  String get cvTipsTitle;

  /// No description provided for @cvTipsMessage.
  ///
  /// In en, this message translates to:
  /// **'Include numbers in your achievements to make them more attractive to recruiters.'**
  String get cvTipsMessage;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(Object hours);

  /// No description provided for @fillNameError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in your full name first.'**
  String get fillNameError;

  /// No description provided for @termsAgreePrefix.
  ///
  /// In en, this message translates to:
  /// **'By tapping \"START NOW\", you agree to our '**
  String get termsAgreePrefix;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAgreeSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get termsAgreeSuffix;

  /// No description provided for @savingProfile.
  ///
  /// In en, this message translates to:
  /// **'Saving Profile...'**
  String get savingProfile;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get ready;

  /// No description provided for @checkingSystem.
  ///
  /// In en, this message translates to:
  /// **'Checking system...'**
  String get checkingSystem;

  /// No description provided for @validatingLink.
  ///
  /// In en, this message translates to:
  /// **'Validating link...'**
  String get validatingLink;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there...'**
  String get almostThere;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'NEXT STEP'**
  String get nextStep;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @youreAllSet.
  ///
  /// In en, this message translates to:
  /// **'YOU\'RE ALL SET!'**
  String get youreAllSet;

  /// No description provided for @dropYourDetails.
  ///
  /// In en, this message translates to:
  /// **'DROP YOUR DETAILS.'**
  String get dropYourDetails;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in data once, generate thousands of CVs without retyping. Save time, focus on \"grinding\".'**
  String get onboardingSubtitle;

  /// No description provided for @experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get experienceTitle;

  /// No description provided for @experienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us your experience (work, internship, organization). AI will choose the most relevant ones for your goals.'**
  String get experienceSubtitle;

  /// No description provided for @educationTitle.
  ///
  /// In en, this message translates to:
  /// **'Education History'**
  String get educationTitle;

  /// No description provided for @educationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in all your education history. AI will choose the most relevant level to put on your CV.'**
  String get educationSubtitle;

  /// No description provided for @certificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Certifications & Licenses'**
  String get certificationTitle;

  /// No description provided for @certificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter relevant certifications, licenses, or awards. This can be a huge plus.'**
  String get certificationSubtitle;

  /// No description provided for @skillsTitle.
  ///
  /// In en, this message translates to:
  /// **'What are your skills?'**
  String get skillsTitle;

  /// No description provided for @skillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List all your skills. AI will highlight the ones that best match the position you are aiming for.'**
  String get skillsSubtitle;

  /// No description provided for @careerAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Career Analytics'**
  String get careerAnalytics;

  /// No description provided for @activityOverview.
  ///
  /// In en, this message translates to:
  /// **'Activity Overview'**
  String get activityOverview;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// No description provided for @currentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get currentLevel;

  /// No description provided for @keepBuilding.
  ///
  /// In en, this message translates to:
  /// **'Keep building your profile to reach the next level!'**
  String get keepBuilding;

  /// No description provided for @onboardingFinalMessage.
  ///
  /// In en, this message translates to:
  /// **'Master Profile safe. Now just quickly create your CV.'**
  String get onboardingFinalMessage;

  /// No description provided for @saveChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Changes?'**
  String get saveChangesTitle;

  /// No description provided for @saveChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get saveChangesMessage;

  /// No description provided for @exitWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Exit Without Saving'**
  String get exitWithoutSaving;

  /// No description provided for @stayHere.
  ///
  /// In en, this message translates to:
  /// **'Stay Here'**
  String get stayHere;

  /// No description provided for @importSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'CV imported successfully!\nAdded: {expCount} experience, {eduCount} education, {skillsCount} skills'**
  String importSuccessMessage(
    Object eduCount,
    Object expCount,
    Object skillsCount,
  );

  /// No description provided for @profileSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile Saved! Will be used for your next CV.'**
  String get profileSavedSuccess;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile: {error}'**
  String profileSaveError(Object error);

  /// No description provided for @importCVTitle.
  ///
  /// In en, this message translates to:
  /// **'Import CV'**
  String get importCVTitle;

  /// No description provided for @importCVMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose how to import your CV:'**
  String get importCVMessage;

  /// No description provided for @pdfFile.
  ///
  /// In en, this message translates to:
  /// **'PDF File'**
  String get pdfFile;

  /// No description provided for @importingCVBadge.
  ///
  /// In en, this message translates to:
  /// **'IMPORTING CV'**
  String get importingCVBadge;

  /// No description provided for @readingCV.
  ///
  /// In en, this message translates to:
  /// **'Reading CV...'**
  String get readingCV;

  /// No description provided for @extractingData.
  ///
  /// In en, this message translates to:
  /// **'Extracting data...'**
  String get extractingData;

  /// No description provided for @compilingProfile.
  ///
  /// In en, this message translates to:
  /// **'Compiling profile...'**
  String get compilingProfile;

  /// No description provided for @readingPDF.
  ///
  /// In en, this message translates to:
  /// **'Reading PDF...'**
  String get readingPDF;

  /// No description provided for @noTextFoundInCV.
  ///
  /// In en, this message translates to:
  /// **'No text found in CV'**
  String get noTextFoundInCV;

  /// No description provided for @importFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to import CV. Please try again!'**
  String get importFailedMessage;

  /// No description provided for @totalCVs.
  ///
  /// In en, this message translates to:
  /// **'Total CVs'**
  String get totalCVs;

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

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience or report an issue.'**
  String get feedbackSubtitle;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @bugReport.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get bugReport;

  /// No description provided for @featureRequest.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get featureRequest;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @messageDetail.
  ///
  /// In en, this message translates to:
  /// **'Message / Detail'**
  String get messageDetail;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'Please write something'**
  String get writeSomething;

  /// No description provided for @contactOptional.
  ///
  /// In en, this message translates to:
  /// **'Email / WhatsApp (Optional)'**
  String get contactOptional;

  /// No description provided for @contactHint.
  ///
  /// In en, this message translates to:
  /// **'So we can get back to you...'**
  String get contactHint;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get thankYou;

  /// No description provided for @feedbackThanksMessage.
  ///
  /// In en, this message translates to:
  /// **'Your feedback is valuable for CV Master development.'**
  String get feedbackThanksMessage;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @suggestionsBugs.
  ///
  /// In en, this message translates to:
  /// **'Suggestions & Bugs'**
  String get suggestionsBugs;

  /// No description provided for @frequentQuestions.
  ///
  /// In en, this message translates to:
  /// **'Common Questions'**
  String get frequentQuestions;

  /// No description provided for @faqFreeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is CV Master free?'**
  String get faqFreeQuestion;

  /// No description provided for @faqFreeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes, basic features are free. We might add premium features in the future.'**
  String get faqFreeAnswer;

  /// No description provided for @faqEditQuestion.
  ///
  /// In en, this message translates to:
  /// **'How to edit profile?'**
  String get faqEditQuestion;

  /// No description provided for @faqEditAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to the Profile menu, edit the section you want, and hit save.'**
  String get faqEditAnswer;

  /// No description provided for @faqDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is my data safe?'**
  String get faqDataQuestion;

  /// No description provided for @faqDataAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored locally (Master Profile). Data sent to AI is processed briefly and not stored.'**
  String get faqDataAnswer;

  /// No description provided for @faqPdfQuestion.
  ///
  /// In en, this message translates to:
  /// **'Can I export to PDF?'**
  String get faqPdfQuestion;

  /// No description provided for @faqPdfAnswer.
  ///
  /// In en, this message translates to:
  /// **'Sure! After creating your CV, you can Download/Print PDF in the preview.'**
  String get faqPdfAnswer;

  /// No description provided for @cantOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app.'**
  String get cantOpenEmail;

  /// No description provided for @incompleteData.
  ///
  /// In en, this message translates to:
  /// **'Incomplete data. Returned to previous form.'**
  String get incompleteData;

  /// No description provided for @pdfOpenError.
  ///
  /// In en, this message translates to:
  /// **'Failed to open PDF: {error}'**
  String pdfOpenError(Object error);

  /// No description provided for @pdfGenerateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF: {error}'**
  String pdfGenerateError(Object error);

  /// No description provided for @templateLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading templates: {error}'**
  String templateLoadError(Object error);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @generatingPdfBadge.
  ///
  /// In en, this message translates to:
  /// **'GENERATING PDF'**
  String get generatingPdfBadge;

  /// No description provided for @processingData.
  ///
  /// In en, this message translates to:
  /// **'Processing Data...'**
  String get processingData;

  /// No description provided for @applyingDesign.
  ///
  /// In en, this message translates to:
  /// **'Applying Design...'**
  String get applyingDesign;

  /// No description provided for @creatingPages.
  ///
  /// In en, this message translates to:
  /// **'Creating Pages...'**
  String get creatingPages;

  /// No description provided for @finalizingPdf.
  ///
  /// In en, this message translates to:
  /// **'Finalizing PDF...'**
  String get finalizingPdf;

  /// No description provided for @loadingTemplatesBadge.
  ///
  /// In en, this message translates to:
  /// **'LOADING TEMPLATES'**
  String get loadingTemplatesBadge;

  /// No description provided for @fetchingTemplates.
  ///
  /// In en, this message translates to:
  /// **'Fetching Templates...'**
  String get fetchingTemplates;

  /// No description provided for @preparingGallery.
  ///
  /// In en, this message translates to:
  /// **'Preparing Gallery...'**
  String get preparingGallery;

  /// No description provided for @loadingPreview.
  ///
  /// In en, this message translates to:
  /// **'Loading Preview...'**
  String get loadingPreview;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'SELECT TEMPLATE'**
  String get selectTemplate;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premium;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'EXPORT PDF'**
  String get exportPdf;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// No description provided for @unknownErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, but we aren\'t sure what.'**
  String get unknownErrorDesc;

  /// No description provided for @readyToAchieve.
  ///
  /// In en, this message translates to:
  /// **'Ready to achieve your career goals?'**
  String get readyToAchieve;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteMyData.
  ///
  /// In en, this message translates to:
  /// **'Delete My Data'**
  String get deleteMyData;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. All your data, including generated CVs and credits, will be permanently deleted.'**
  String get deleteAccountWarning;

  /// No description provided for @accountDeletedGoodbye.
  ///
  /// In en, this message translates to:
  /// **'Account successfully deleted. Goodbye!'**
  String get accountDeletedGoodbye;

  /// No description provided for @accountDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String accountDeleteError(Object error);

  /// No description provided for @keepLocalData.
  ///
  /// In en, this message translates to:
  /// **'Keep my local data (Master Profile)'**
  String get keepLocalData;

  /// No description provided for @clearLocalData.
  ///
  /// In en, this message translates to:
  /// **'Clear local data as well (Full Reset)'**
  String get clearLocalData;

  /// No description provided for @creditWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: You have {count} credits remaining. These are non-refundable.'**
  String creditWarning(int count);

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @verificationSentTo.
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to {email}. Please check your inbox and spam folder.'**
  String verificationSentTo(String email);

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find it? Please check your Spam or Junk folder.'**
  String get checkSpamFolder;

  /// No description provided for @iHaveVerified.
  ///
  /// In en, this message translates to:
  /// **'I HAVE VERIFIED'**
  String get iHaveVerified;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendEmail;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent!'**
  String get verificationEmailSent;

  /// No description provided for @emailVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully!'**
  String get emailVerifiedSuccess;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Email not verified yet. Please check your inbox.'**
  String get emailNotVerifiedYet;

  /// No description provided for @alreadyHaveCV.
  ///
  /// In en, this message translates to:
  /// **'Already have a CV?'**
  String get alreadyHaveCV;

  /// No description provided for @alreadyHaveCVSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Speed things up! Import your existing CV and we\'ll fill everything in for you.'**
  String get alreadyHaveCVSubtitle;

  /// No description provided for @importExistingCV.
  ///
  /// In en, this message translates to:
  /// **'Import My CV'**
  String get importExistingCV;

  /// No description provided for @importExistingCVDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload a PDF or take a photo — AI fills in the rest.'**
  String get importExistingCVDesc;

  /// No description provided for @startFromScratch.
  ///
  /// In en, this message translates to:
  /// **'Start From Scratch'**
  String get startFromScratch;

  /// No description provided for @startFromScratchDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill in each section manually, step by step.'**
  String get startFromScratchDesc;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @stepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total} — {label}'**
  String stepLabel(Object current, Object label, Object total);

  /// No description provided for @stepPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get stepPersonalInfo;

  /// No description provided for @stepImportCV.
  ///
  /// In en, this message translates to:
  /// **'Quick Setup'**
  String get stepImportCV;

  /// No description provided for @stepExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get stepExperience;

  /// No description provided for @stepEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get stepEducation;

  /// No description provided for @stepCertifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get stepCertifications;

  /// No description provided for @stepSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get stepSkills;

  /// No description provided for @stepFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get stepFinish;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @creditBalance.
  ///
  /// In en, this message translates to:
  /// **'Credit Balance'**
  String get creditBalance;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'credits'**
  String get credits;

  /// No description provided for @usageHistoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Usage history coming soon'**
  String get usageHistoryComingSoon;

  /// No description provided for @myCVs.
  ///
  /// In en, this message translates to:
  /// **'My CVs'**
  String get myCVs;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get drafts;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generated;

  /// No description provided for @noCompletedCVs.
  ///
  /// In en, this message translates to:
  /// **'No generated CVs yet'**
  String get noCompletedCVs;

  /// No description provided for @generateCVFirst.
  ///
  /// In en, this message translates to:
  /// **'Generate your first CV to see it here'**
  String get generateCVFirst;

  /// No description provided for @openPDF.
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get openPDF;

  /// No description provided for @newNotification.
  ///
  /// In en, this message translates to:
  /// **'New Notification'**
  String get newNotification;

  /// No description provided for @cvGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV Generated Successfully'**
  String get cvGeneratedSuccess;

  /// No description provided for @cvReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your CV for {jobTitle} is ready!'**
  String cvReadyMessage(Object jobTitle);

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordResetMessage;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @notificationNew.
  ///
  /// In en, this message translates to:
  /// **'New Notification'**
  String get notificationNew;

  /// No description provided for @notificationChannelCVTitle.
  ///
  /// In en, this message translates to:
  /// **'CV Generation'**
  String get notificationChannelCVTitle;

  /// No description provided for @notificationChannelCVDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications for CV generation updates'**
  String get notificationChannelCVDesc;

  /// No description provided for @notificationChannelGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'General Alerts'**
  String get notificationChannelGeneralTitle;

  /// No description provided for @notificationChannelGeneralDesc.
  ///
  /// In en, this message translates to:
  /// **'General app notifications'**
  String get notificationChannelGeneralDesc;
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
