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

  /// No description provided for @activityOverview.
  ///
  /// In en, this message translates to:
  /// **'activity overview'**
  String get activityOverview;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get add;

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

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'add skill'**
  String get addSkill;

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

  /// No description provided for @aiHelpCreateCV.
  ///
  /// In en, this message translates to:
  /// **'ai will help create a cv perfectly tailored for this goal.'**
  String get aiHelpCreateCV;

  /// No description provided for @aiPowered.
  ///
  /// In en, this message translates to:
  /// **'ai powered'**
  String get aiPowered;

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

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'almost there...'**
  String get almostThere;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @alreadyHaveCV.
  ///
  /// In en, this message translates to:
  /// **'already have a cv?'**
  String get alreadyHaveCV;

  /// No description provided for @alreadyHaveCVSubtitle.
  ///
  /// In en, this message translates to:
  /// **'speed things up! import your existing cv and we\'ll fill everything in for you.'**
  String get alreadyHaveCVSubtitle;

  /// No description provided for @analyzeProfileError.
  ///
  /// In en, this message translates to:
  /// **'failed to analyze profile: {error}'**
  String analyzeProfileError(Object error);

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

  /// No description provided for @atsStandard.
  ///
  /// In en, this message translates to:
  /// **'ats standard'**
  String get atsStandard;

  /// No description provided for @authWallBuyCredits.
  ///
  /// In en, this message translates to:
  /// **'sign in to buy credits'**
  String get authWallBuyCredits;

  /// No description provided for @authWallBuyCreditsDesc.
  ///
  /// In en, this message translates to:
  /// **'an account is required to purchase credits'**
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

  /// No description provided for @autoFillFromMaster.
  ///
  /// In en, this message translates to:
  /// **'data auto-filled from your master profile'**
  String get autoFillFromMaster;

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

  /// No description provided for @bugReport.
  ///
  /// In en, this message translates to:
  /// **'bug report'**
  String get bugReport;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'birth date'**
  String get birthDate;

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

  /// No description provided for @cantOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'could not open email app.'**
  String get cantOpenEmail;

  /// No description provided for @careerAnalytics.
  ///
  /// In en, this message translates to:
  /// **'career analytics'**
  String get careerAnalytics;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get category;

  /// No description provided for @certificationName.
  ///
  /// In en, this message translates to:
  /// **'certification name'**
  String get certificationName;

  /// No description provided for @certificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'enter relevant certifications, licenses, or awards. this can be a huge plus.'**
  String get certificationSubtitle;

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

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'can\'t find it? please check your spam or junk folder.'**
  String get checkSpamFolder;

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

  /// No description provided for @companyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'ex: google'**
  String get companyPlaceholder;

  /// No description provided for @compilingProfile.
  ///
  /// In en, this message translates to:
  /// **'compiling profile...'**
  String get compilingProfile;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get complete;

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

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'contact support'**
  String get contactSupport;

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

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'continue with google'**
  String get continueWithGoogle;

  /// No description provided for @continuingToForm.
  ///
  /// In en, this message translates to:
  /// **'continuing to form...'**
  String get continuingToForm;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'create account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'start your journey to a better career'**
  String get createAccountSubtitle;

  /// No description provided for @createCV.
  ///
  /// In en, this message translates to:
  /// **'create cv'**
  String get createCV;

  /// No description provided for @createFirstCV.
  ///
  /// In en, this message translates to:
  /// **'create your\nfirst cv.'**
  String get createFirstCV;

  /// No description provided for @createProfessionalCV.
  ///
  /// In en, this message translates to:
  /// **'create a\nprofessional cv.'**
  String get createProfessionalCV;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get created;

  /// No description provided for @creatingPages.
  ///
  /// In en, this message translates to:
  /// **'creating pages...'**
  String get creatingPages;

  /// No description provided for @creativeDesign.
  ///
  /// In en, this message translates to:
  /// **'creative design'**
  String get creativeDesign;

  /// No description provided for @creditBalance.
  ///
  /// In en, this message translates to:
  /// **'credit balance'**
  String get creditBalance;

  /// No description provided for @creditWarning.
  ///
  /// In en, this message translates to:
  /// **'warning: you have {count} credits remaining. these are non-refundable.'**
  String creditWarning(int count);

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'credits'**
  String get credits;

  /// No description provided for @currentLevel.
  ///
  /// In en, this message translates to:
  /// **'current level'**
  String get currentLevel;

  /// No description provided for @cvDataExists.
  ///
  /// In en, this message translates to:
  /// **'cv data already exists in your profile.'**
  String get cvDataExists;

  /// No description provided for @cvGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'cv generated successfully'**
  String get cvGeneratedSuccess;

  /// No description provided for @cvImportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'cv imported successfully! let\'s complete your profile.'**
  String get cvImportedSuccess;

  /// No description provided for @cvLanguage.
  ///
  /// In en, this message translates to:
  /// **'cv language'**
  String get cvLanguage;

  /// No description provided for @cvReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'your cv for {jobTitle} is ready!'**
  String cvReadyMessage(Object jobTitle);

  /// No description provided for @cvs.
  ///
  /// In en, this message translates to:
  /// **'cvs'**
  String get cvs;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'date:'**
  String get dateLabel;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'degree / major'**
  String get degree;

  /// No description provided for @degreeHint.
  ///
  /// In en, this message translates to:
  /// **'bachelor of computer science'**
  String get degreeHint;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

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
  /// **'this action is irreversible. all your data, including generated cvs and credits, will be permanently deleted.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'explain your main responsibilities and achievements...'**
  String get descriptionHint;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'drafts'**
  String get drafts;

  /// No description provided for @dropYourDetails.
  ///
  /// In en, this message translates to:
  /// **'drop your details.'**
  String get dropYourDetails;

  /// No description provided for @editCertification.
  ///
  /// In en, this message translates to:
  /// **'edit certification'**
  String get editCertification;

  /// No description provided for @editEducation.
  ///
  /// In en, this message translates to:
  /// **'edit education'**
  String get editEducation;

  /// No description provided for @editExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'edit experience'**
  String get editExperienceTitle;

  /// No description provided for @educationHistory.
  ///
  /// In en, this message translates to:
  /// **'education history'**
  String get educationHistory;

  /// No description provided for @educationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'fill in all your education history. ai will choose the most relevant level to put on your cv.'**
  String get educationSubtitle;

  /// No description provided for @educationTitle.
  ///
  /// In en, this message translates to:
  /// **'education history'**
  String get educationTitle;

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

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'end date'**
  String get endDate;

  /// No description provided for @errorDetailsCopied.
  ///
  /// In en, this message translates to:
  /// **'error details copied to clipboard'**
  String get errorDetailsCopied;

  /// No description provided for @exitWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'exit without saving'**
  String get exitWithoutSaving;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'experience'**
  String get experience;

  /// No description provided for @experienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'tell us your experience (work, internship, organization). ai will choose the most relevant ones for your goals.'**
  String get experienceSubtitle;

  /// No description provided for @experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'work experience'**
  String get experienceTitle;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'export pdf'**
  String get exportPdf;

  /// No description provided for @extractingData.
  ///
  /// In en, this message translates to:
  /// **'extracting data...'**
  String get extractingData;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get failed;

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

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'secure'**
  String get secure;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'gender'**
  String get gender;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'member'**
  String get member;

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

  /// No description provided for @fetchingTemplates.
  ///
  /// In en, this message translates to:
  /// **'fetching templates...'**
  String get fetchingTemplates;

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

  /// No description provided for @folderEmpty.
  ///
  /// In en, this message translates to:
  /// **'folder is empty'**
  String get folderEmpty;

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

  /// No description provided for @frequentQuestions.
  ///
  /// In en, this message translates to:
  /// **'common questions'**
  String get frequentQuestions;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'fri'**
  String get fri;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'full name'**
  String get fullName;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'gallery'**
  String get gallery;

  /// No description provided for @generateCVFirst.
  ///
  /// In en, this message translates to:
  /// **'generate your first cv to see it here'**
  String get generateCVFirst;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'generated'**
  String get generated;

  /// No description provided for @generatingPdfBadge.
  ///
  /// In en, this message translates to:
  /// **'generating pdf'**
  String get generatingPdfBadge;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'get started'**
  String get getStarted;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'go home'**
  String get goHome;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'google sign-in failed: {error}'**
  String googleSignInError(Object error);

  /// No description provided for @googleSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'signed in with google!'**
  String get googleSignInSuccess;

  /// No description provided for @header.
  ///
  /// In en, this message translates to:
  /// **'header'**
  String get header;

  /// No description provided for @helloName.
  ///
  /// In en, this message translates to:
  /// **'hello, {name}'**
  String helloName(Object name);

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

  /// No description provided for @iHaveVerified.
  ///
  /// In en, this message translates to:
  /// **'i have verified'**
  String get iHaveVerified;

  /// No description provided for @identifyingVacancy.
  ///
  /// In en, this message translates to:
  /// **'identifying vacancy...'**
  String get identifyingVacancy;

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

  /// No description provided for @importExistingCV.
  ///
  /// In en, this message translates to:
  /// **'import my cv'**
  String get importExistingCV;

  /// No description provided for @importExistingCVDesc.
  ///
  /// In en, this message translates to:
  /// **'upload a pdf or take a photo — ai fills in the rest.'**
  String get importExistingCVDesc;

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

  /// No description provided for @importCVHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'instantly organize your profile by importing your existing cv.'**
  String get importCVHeroSubtitle;

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

  /// No description provided for @importingCVBadge.
  ///
  /// In en, this message translates to:
  /// **'importing cv'**
  String get importingCVBadge;

  /// No description provided for @improving.
  ///
  /// In en, this message translates to:
  /// **'improving...'**
  String get improving;

  /// No description provided for @includeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'include profile photo'**
  String get includeProfilePhoto;

  /// No description provided for @issuer.
  ///
  /// In en, this message translates to:
  /// **'issuer'**
  String get issuer;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'italic'**
  String get italic;

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

  /// No description provided for @jobListTitle.
  ///
  /// In en, this message translates to:
  /// **'find jobs'**
  String get jobListTitle;

  /// No description provided for @jobListSocialTab.
  ///
  /// In en, this message translates to:
  /// **'social (top picks)'**
  String get jobListSocialTab;

  /// No description provided for @jobListApiTab.
  ///
  /// In en, this message translates to:
  /// **'job boards (api)'**
  String get jobListApiTab;

  /// No description provided for @jobListScannerHint.
  ///
  /// In en, this message translates to:
  /// **'found a job here? take a screenshot and use our smart scanner to instantly auto-fill your cv!'**
  String get jobListScannerHint;

  /// No description provided for @jobListNoAccountsFound.
  ///
  /// In en, this message translates to:
  /// **'no accounts found'**
  String get jobListNoAccountsFound;

  /// No description provided for @jobListNoAccountsFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'could not find any accounts matching \"{query}\". want us to add a specific account?'**
  String jobListNoAccountsFoundDesc(String query);

  /// No description provided for @jobListGiveFeedback.
  ///
  /// In en, this message translates to:
  /// **'give feedback'**
  String get jobListGiveFeedback;

  /// No description provided for @jobListSearchTagsHint.
  ///
  /// In en, this message translates to:
  /// **'search tags (e.g. design, tech, remote)'**
  String get jobListSearchTagsHint;

  /// No description provided for @jobListNoApiJobs.
  ///
  /// In en, this message translates to:
  /// **'no api jobs available yet'**
  String get jobListNoApiJobs;

  /// No description provided for @jobListNoApiJobsSub.
  ///
  /// In en, this message translates to:
  /// **'check out the social tab for the best curated jobs!'**
  String get jobListNoApiJobsSub;

  /// No description provided for @jobListCreateCvForJob.
  ///
  /// In en, this message translates to:
  /// **'create cv for this job'**
  String get jobListCreateCvForJob;

  /// No description provided for @jobListViewOriginal.
  ///
  /// In en, this message translates to:
  /// **'view original'**
  String get jobListViewOriginal;

  /// No description provided for @jobDescription.
  ///
  /// In en, this message translates to:
  /// **'job description'**
  String get jobDescription;

  /// No description provided for @jobRequirements.
  ///
  /// In en, this message translates to:
  /// **'requirements'**
  String get jobRequirements;

  /// No description provided for @jobCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'could not open link'**
  String get jobCouldNotOpen;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'job title'**
  String get jobTitle;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'jobs'**
  String get jobs;

  /// No description provided for @keepBuilding.
  ///
  /// In en, this message translates to:
  /// **'keep building your profile to reach the next level!'**
  String get keepBuilding;

  /// No description provided for @keepLocalData.
  ///
  /// In en, this message translates to:
  /// **'keep my local data (master profile)'**
  String get keepLocalData;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'key metrics'**
  String get keyMetrics;

  /// No description provided for @loadingPreview.
  ///
  /// In en, this message translates to:
  /// **'loading preview...'**
  String get loadingPreview;

  /// No description provided for @loadingTemplatesBadge.
  ///
  /// In en, this message translates to:
  /// **'loading templates'**
  String get loadingTemplatesBadge;

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

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'log in'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'log out'**
  String get logOut;

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

  /// No description provided for @masterProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'master profile updated successfully'**
  String get masterProfileUpdated;

  /// No description provided for @messageDetail.
  ///
  /// In en, this message translates to:
  /// **'message / detail'**
  String get messageDetail;

  /// No description provided for @modernProfessional.
  ///
  /// In en, this message translates to:
  /// **'modern professional'**
  String get modernProfessional;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'mon'**
  String get mon;

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

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'next step'**
  String get nextStep;

  /// No description provided for @noCertifications.
  ///
  /// In en, this message translates to:
  /// **'no certifications yet.'**
  String get noCertifications;

  /// No description provided for @noCompletedCVs.
  ///
  /// In en, this message translates to:
  /// **'no generated cvs yet'**
  String get noCompletedCVs;

  /// No description provided for @noDrafts.
  ///
  /// In en, this message translates to:
  /// **'no drafts yet.'**
  String get noDrafts;

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

  /// No description provided for @noSkills.
  ///
  /// In en, this message translates to:
  /// **'no skills yet.'**
  String get noSkills;

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

  /// No description provided for @ocrScanning.
  ///
  /// In en, this message translates to:
  /// **'ocr scanning'**
  String get ocrScanning;

  /// No description provided for @onboardingFinalMessage.
  ///
  /// In en, this message translates to:
  /// **'master profile safe. now just quickly create your cv.'**
  String get onboardingFinalMessage;

  /// No description provided for @onboardingFeedbackCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Amazing work, {name}!'**
  String onboardingFeedbackCompleteTitle(String name);

  /// No description provided for @onboardingFeedbackCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Your profile is 90% ready. You\'re now in the top tier to get noticed by recruiters!'**
  String get onboardingFeedbackCompleteMessage;

  /// No description provided for @onboardingFeedbackPartialTitle.
  ///
  /// In en, this message translates to:
  /// **'Great start!'**
  String get onboardingFeedbackPartialTitle;

  /// No description provided for @onboardingFeedbackPartialMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve lined up some initial recommendations for you. Don\'t forget to fill in the rest later to unlock even better matches.'**
  String get onboardingFeedbackPartialMessage;

  /// No description provided for @onboardingFeedbackEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No worries!'**
  String get onboardingFeedbackEmptyTitle;

  /// No description provided for @onboardingFeedbackEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You can explore first. Spruce up your profile anytime in the \'Master Profile\' tab so we can work our magic for you.'**
  String get onboardingFeedbackEmptyMessage;

  /// No description provided for @onboardingFeedbackGetSmarterHint.
  ///
  /// In en, this message translates to:
  /// **'The app gets smarter as you add more info.'**
  String get onboardingFeedbackGetSmarterHint;

  /// No description provided for @onboardingFeedbackCompleteFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Tier Profile'**
  String get onboardingFeedbackCompleteFeatureTitle;

  /// No description provided for @onboardingFeedbackCompleteFeatureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re among the most prepared candidates.'**
  String get onboardingFeedbackCompleteFeatureSubtitle;

  /// No description provided for @onboardingHeadline1.
  ///
  /// In en, this message translates to:
  /// **'still editing your cv at 1am?'**
  String get onboardingHeadline1;

  /// No description provided for @onboardingHeadline2.
  ///
  /// In en, this message translates to:
  /// **'qualified, but still getting rejected?'**
  String get onboardingHeadline2;

  /// No description provided for @onboardingHeadline3.
  ///
  /// In en, this message translates to:
  /// **'don\'t start from zero.'**
  String get onboardingHeadline3;

  /// No description provided for @onboardingHeadline4.
  ///
  /// In en, this message translates to:
  /// **'dump everything here.'**
  String get onboardingHeadline4;

  /// No description provided for @onboardingHeadline6.
  ///
  /// In en, this message translates to:
  /// **'one profile. unlimited tailored cvs.'**
  String get onboardingHeadline6;

  /// No description provided for @onboardingHeadline7.
  ///
  /// In en, this message translates to:
  /// **'we want you to try clever for free.'**
  String get onboardingHeadline7;

  /// No description provided for @onboardingSubtext1.
  ///
  /// In en, this message translates to:
  /// **'stop manual editing. tailor your cv for every job in seconds, not hours.'**
  String get onboardingSubtext1;

  /// No description provided for @onboardingSubtext2.
  ///
  /// In en, this message translates to:
  /// **'your cv might be failing the ats. we ensure your keywords match what recruiters want.'**
  String get onboardingSubtext2;

  /// No description provided for @onboardingSubtext3.
  ///
  /// In en, this message translates to:
  /// **'upload your old pdf. we’ll extract and organize your entire history instantly.'**
  String get onboardingSubtext3;

  /// No description provided for @onboardingSubtext4.
  ///
  /// In en, this message translates to:
  /// **'every role matters. from side jobs to tech lead—we’ll pick what’s relevant.'**
  String get onboardingSubtext4;

  /// No description provided for @onboardingSubtext6.
  ///
  /// In en, this message translates to:
  /// **'swap between pro-templates instantly. no expensive designers needed.'**
  String get onboardingSubtext6;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'fill in data once, generate thousands of cvs without retyping. save time, focus on \"grinding\".'**
  String get onboardingSubtitle;

  /// No description provided for @openPDF.
  ///
  /// In en, this message translates to:
  /// **'open pdf'**
  String get openPDF;

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

  /// No description provided for @pdfFile.
  ///
  /// In en, this message translates to:
  /// **'pdf file'**
  String get pdfFile;

  /// No description provided for @pdfGenerateError.
  ///
  /// In en, this message translates to:
  /// **'failed to generate pdf: {error}'**
  String pdfGenerateError(Object error);

  /// No description provided for @pdfOpenError.
  ///
  /// In en, this message translates to:
  /// **'failed to open pdf: {error}'**
  String pdfOpenError(Object error);

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

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @polishing.
  ///
  /// In en, this message translates to:
  /// **'polishing...'**
  String get polishing;

  /// No description provided for @positionHint.
  ///
  /// In en, this message translates to:
  /// **'position (ex: ui designer)'**
  String get positionHint;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'premium'**
  String get premium;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'get credits'**
  String get premiumBadge;

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

  /// No description provided for @previewTemplate.
  ///
  /// In en, this message translates to:
  /// **'preview template'**
  String get previewTemplate;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get privacyPolicy;

  /// No description provided for @processingData.
  ///
  /// In en, this message translates to:
  /// **'processing data...'**
  String get processingData;

  /// No description provided for @professionalSummary.
  ///
  /// In en, this message translates to:
  /// **'professional summary'**
  String get professionalSummary;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get profile;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'failed to save profile: {error}'**
  String profileSaveError(Object error);

  /// No description provided for @profileSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'profile saved! will be used for your next cv.'**
  String get profileSavedSuccess;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'question'**
  String get question;

  /// No description provided for @readingCV.
  ///
  /// In en, this message translates to:
  /// **'reading cv...'**
  String get readingCV;

  /// No description provided for @readingPDF.
  ///
  /// In en, this message translates to:
  /// **'reading pdf...'**
  String get readingPDF;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'ready!'**
  String get ready;

  /// No description provided for @readyToAchieve.
  ///
  /// In en, this message translates to:
  /// **'ready to achieve your career goals?'**
  String get readyToAchieve;

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

  /// No description provided for @requirementsCheckLabel.
  ///
  /// In en, this message translates to:
  /// **'requirements check:'**
  String get requirementsCheckLabel;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'resend verification email'**
  String get resendEmail;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'retry'**
  String get retry;

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

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'sat'**
  String get sat;

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

  /// No description provided for @saveChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'you have unsaved changes. are you sure you want to leave?'**
  String get saveChangesMessage;

  /// No description provided for @saveChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'save changes?'**
  String get saveChangesTitle;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'save profile'**
  String get saveProfile;

  /// No description provided for @savingProfile.
  ///
  /// In en, this message translates to:
  /// **'saving profile...'**
  String get savingProfile;

  /// No description provided for @scanJobPosting.
  ///
  /// In en, this message translates to:
  /// **'scan job posting'**
  String get scanJobPosting;

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

  /// No description provided for @searchJob.
  ///
  /// In en, this message translates to:
  /// **'search for jobs...'**
  String get searchJob;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'select date'**
  String get selectDate;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'select template'**
  String get selectTemplate;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'send feedback'**
  String get sendFeedback;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'send reset link'**
  String get sendResetLink;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'sending...'**
  String get sending;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'short description'**
  String get shortDescription;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'sign in to sync your cvs across devices'**
  String get signInSubtitle;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'sign up'**
  String get signUp;

  /// No description provided for @skillHint.
  ///
  /// In en, this message translates to:
  /// **'ex: flutter, leadership'**
  String get skillHint;

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

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'skip for now'**
  String get skipForNow;

  /// No description provided for @skipIntro.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get skipIntro;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'start date'**
  String get startDate;

  /// No description provided for @startFromScratch.
  ///
  /// In en, this message translates to:
  /// **'start from scratch'**
  String get startFromScratch;

  /// No description provided for @startFromScratchDesc.
  ///
  /// In en, this message translates to:
  /// **'fill in each section manually, step by step.'**
  String get startFromScratchDesc;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'start now'**
  String get startNow;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'statistics'**
  String get statistics;

  /// No description provided for @stayHere.
  ///
  /// In en, this message translates to:
  /// **'stay here'**
  String get stayHere;

  /// No description provided for @stepCertifications.
  ///
  /// In en, this message translates to:
  /// **'certifications'**
  String get stepCertifications;

  /// No description provided for @stepEducation.
  ///
  /// In en, this message translates to:
  /// **'education'**
  String get stepEducation;

  /// No description provided for @stepExperience.
  ///
  /// In en, this message translates to:
  /// **'experience'**
  String get stepExperience;

  /// No description provided for @stepFinish.
  ///
  /// In en, this message translates to:
  /// **'finish'**
  String get stepFinish;

  /// No description provided for @stepImportCV.
  ///
  /// In en, this message translates to:
  /// **'quick setup'**
  String get stepImportCV;

  /// No description provided for @stepPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'contact info'**
  String get stepPersonalInfo;

  /// No description provided for @stepSkills.
  ///
  /// In en, this message translates to:
  /// **'skills'**
  String get stepSkills;

  /// No description provided for @suggestionsBugs.
  ///
  /// In en, this message translates to:
  /// **'suggestions & bugs'**
  String get suggestionsBugs;

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

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'sun'**
  String get sun;

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

  /// No description provided for @tailoredDataMessage.
  ///
  /// In en, this message translates to:
  /// **'this data has been tailored by ai to be relevant to your target position. please review!'**
  String get tailoredDataMessage;

  /// No description provided for @takesLessThan3Min.
  ///
  /// In en, this message translates to:
  /// **'takes less than 3 minutes.'**
  String get takesLessThan3Min;

  /// No description provided for @targetPosition.
  ///
  /// In en, this message translates to:
  /// **'target position'**
  String get targetPosition;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'technical details'**
  String get technicalDetails;

  /// No description provided for @templateLoadError.
  ///
  /// In en, this message translates to:
  /// **'error loading templates: {error}'**
  String templateLoadError(Object error);

  /// No description provided for @termsAgreePrefix.
  ///
  /// In en, this message translates to:
  /// **'by continuing, you agree to our'**
  String get termsAgreePrefix;

  /// No description provided for @termsAgreeSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get termsAgreeSuffix;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'terms of service'**
  String get termsOfService;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'thank you!'**
  String get thankYou;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'thu'**
  String get thu;

  /// No description provided for @totalCVs.
  ///
  /// In en, this message translates to:
  /// **'total cvs'**
  String get totalCVs;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'tue'**
  String get tue;

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

  /// No description provided for @unlockFeatures.
  ///
  /// In en, this message translates to:
  /// **'refill generation credits'**
  String get unlockFeatures;

  /// No description provided for @untilNow.
  ///
  /// In en, this message translates to:
  /// **'until now'**
  String get untilNow;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'untitled'**
  String get untitled;

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

  /// No description provided for @usageHistoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'usage history coming soon'**
  String get usageHistoryComingSoon;

  /// No description provided for @userLevelExpert.
  ///
  /// In en, this message translates to:
  /// **'expert career builder'**
  String get userLevelExpert;

  /// No description provided for @userLevelMid.
  ///
  /// In en, this message translates to:
  /// **'mid-level professional'**
  String get userLevelMid;

  /// No description provided for @userLevelRookie.
  ///
  /// In en, this message translates to:
  /// **'rookie job seeker'**
  String get userLevelRookie;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'user not logged in'**
  String get userNotLoggedIn;

  /// No description provided for @usingMasterPhoto.
  ///
  /// In en, this message translates to:
  /// **'using master profile photo'**
  String get usingMasterPhoto;

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

  /// No description provided for @viewDrafts.
  ///
  /// In en, this message translates to:
  /// **'view drafts'**
  String get viewDrafts;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'wallet'**
  String get wallet;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'wed'**
  String get wed;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeBackSuccess.
  ///
  /// In en, this message translates to:
  /// **'welcome back!'**
  String get welcomeBackSuccess;

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

  /// No description provided for @youreAllSet.
  ///
  /// In en, this message translates to:
  /// **'you\'re all set!'**
  String get youreAllSet;

  /// text for the generate cv button
  ///
  /// In en, this message translates to:
  /// **'generate'**
  String generateCvCost(int cost);

  /// No description provided for @generateCvFree.
  ///
  /// In en, this message translates to:
  /// **'generate'**
  String get generateCvFree;

  /// No description provided for @onboardingStartFree.
  ///
  /// In en, this message translates to:
  /// **'get started, it\'s free'**
  String get onboardingStartFree;

  /// No description provided for @onboardingFreeLabel.
  ///
  /// In en, this message translates to:
  /// **'2 free cvs, no credit card.'**
  String get onboardingFreeLabel;

  /// No description provided for @getCredits.
  ///
  /// In en, this message translates to:
  /// **'get credits'**
  String get getCredits;

  /// No description provided for @benefitRegularTitle.
  ///
  /// In en, this message translates to:
  /// **'2 credits for regular templates'**
  String get benefitRegularTitle;

  /// No description provided for @benefitRegularDesc.
  ///
  /// In en, this message translates to:
  /// **'access clean, professional layouts for everyday use'**
  String get benefitRegularDesc;

  /// No description provided for @benefitPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'4 credits for premium templates'**
  String get benefitPremiumTitle;

  /// No description provided for @benefitPremiumDesc.
  ///
  /// In en, this message translates to:
  /// **'unlock exclusive designs that stand out to recruiters'**
  String get benefitPremiumDesc;

  /// No description provided for @benefitSkipAdsTitle.
  ///
  /// In en, this message translates to:
  /// **'skip ads'**
  String get benefitSkipAdsTitle;

  /// No description provided for @benefitSkipAdsDesc.
  ///
  /// In en, this message translates to:
  /// **'enjoy a seamless experience without interruptions'**
  String get benefitSkipAdsDesc;

  /// No description provided for @creditsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} credits'**
  String creditsCount(int count);

  /// No description provided for @popularBadge.
  ///
  /// In en, this message translates to:
  /// **'popular'**
  String get popularBadge;

  /// No description provided for @securePayment.
  ///
  /// In en, this message translates to:
  /// **'secure payment via google play'**
  String get securePayment;

  /// No description provided for @perCredit.
  ///
  /// In en, this message translates to:
  /// **'/credit'**
  String get perCredit;

  /// No description provided for @savePercent.
  ///
  /// In en, this message translates to:
  /// **'save ~{percent}%'**
  String savePercent(int percent);

  /// No description provided for @packageSmall.
  ///
  /// In en, this message translates to:
  /// **'small'**
  String get packageSmall;

  /// No description provided for @packageMedium.
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get packageMedium;

  /// No description provided for @packagePro.
  ///
  /// In en, this message translates to:
  /// **'pro'**
  String get packagePro;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'no transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @topUp.
  ///
  /// In en, this message translates to:
  /// **'top up'**
  String get topUp;

  /// No description provided for @cvExport.
  ///
  /// In en, this message translates to:
  /// **'cv export'**
  String get cvExport;

  /// No description provided for @failedToLoadTransactions.
  ///
  /// In en, this message translates to:
  /// **'failed to load transactions'**
  String get failedToLoadTransactions;

  /// No description provided for @freeExportsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} free exports left'**
  String freeExportsLeft(Object count);

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'transaction history'**
  String get transactionHistory;

  /// No description provided for @exports.
  ///
  /// In en, this message translates to:
  /// **'exports'**
  String get exports;

  /// No description provided for @topUps.
  ///
  /// In en, this message translates to:
  /// **'top ups'**
  String get topUps;

  /// No description provided for @onboardingTweetHandle1.
  ///
  /// In en, this message translates to:
  /// **'@career_warrior'**
  String get onboardingTweetHandle1;

  /// No description provided for @onboardingTweetContent1.
  ///
  /// In en, this message translates to:
  /// **'Spent 5 hours editing my CV layout, only for it to fall apart when saving as PDF. I\'m so done... 😭 #CVRelatable'**
  String get onboardingTweetContent1;

  /// No description provided for @onboardingTweetHandle2.
  ///
  /// In en, this message translates to:
  /// **'@intern_life'**
  String get onboardingTweetHandle2;

  /// No description provided for @onboardingTweetContent2.
  ///
  /// In en, this message translates to:
  /// **'Why is \'Updating CV\' the worst part of job hunting? It\'s just tiny changes but I have to copy-paste everything from scratch.'**
  String get onboardingTweetContent2;

  /// No description provided for @onboardingTweetHandle3.
  ///
  /// In en, this message translates to:
  /// **'@stressed_grad'**
  String get onboardingTweetHandle3;

  /// No description provided for @onboardingTweetContent3.
  ///
  /// In en, this message translates to:
  /// **'Found a great job post, but looking at my messy CV format gave me a headache. Ended up not applying because I was too tired. Ugh.'**
  String get onboardingTweetContent3;

  /// No description provided for @onboardingBurnoutTitle.
  ///
  /// In en, this message translates to:
  /// **'What part makes you burnout most when making a CV?'**
  String get onboardingBurnoutTitle;

  /// No description provided for @onboardingBurnout1.
  ///
  /// In en, this message translates to:
  /// **'Copy paste from scratch'**
  String get onboardingBurnout1;

  /// No description provided for @onboardingBurnout2.
  ///
  /// In en, this message translates to:
  /// **'Manual keyword analysis'**
  String get onboardingBurnout2;

  /// No description provided for @onboardingBurnout3.
  ///
  /// In en, this message translates to:
  /// **'Fixing layout in Canva'**
  String get onboardingBurnout3;

  /// No description provided for @onboardingTimeSpentTitle.
  ///
  /// In en, this message translates to:
  /// **'How much time on average do you need to make a CV?'**
  String get onboardingTimeSpentTitle;

  /// No description provided for @onboardingTime1.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get onboardingTime1;

  /// No description provided for @onboardingTime2.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get onboardingTime2;

  /// No description provided for @onboardingTime3.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get onboardingTime3;

  /// No description provided for @onboardingTime4.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get onboardingTime4;

  /// No description provided for @onboardingProcrastinationTitle.
  ///
  /// In en, this message translates to:
  /// **'How often do you postpone making a CV because the process is exhausting?'**
  String get onboardingProcrastinationTitle;

  /// No description provided for @onboardingProcrastination1.
  ///
  /// In en, this message translates to:
  /// **'Always, it\'s so stressful'**
  String get onboardingProcrastination1;

  /// No description provided for @onboardingProcrastination2.
  ///
  /// In en, this message translates to:
  /// **'Quite often, whenever I apply'**
  String get onboardingProcrastination2;

  /// No description provided for @onboardingProcrastination3.
  ///
  /// In en, this message translates to:
  /// **'Rarely, but I hate starting it'**
  String get onboardingProcrastination3;

  /// No description provided for @onboardingDiagnosisTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis: You\'re Trapped in Routine'**
  String get onboardingDiagnosisTitle;

  /// No description provided for @onboardingDiagnosisSub.
  ///
  /// In en, this message translates to:
  /// **'Spending {time} purely on {burnout} is draining your potential. Clever automates this in seconds, so you can focus on winning.'**
  String onboardingDiagnosisSub(String time, String burnout);

  /// No description provided for @onboardingSocialProof.
  ///
  /// In en, this message translates to:
  /// **'1,240+ people are optimizing their CVs right now.'**
  String get onboardingSocialProof;

  /// No description provided for @onboardingSolutionHeadline.
  ///
  /// In en, this message translates to:
  /// **'Leave it to CleVer.\nIn seconds.'**
  String get onboardingSolutionHeadline;

  /// No description provided for @onboardingStepWallTitle.
  ///
  /// In en, this message translates to:
  /// **'You are not alone.'**
  String get onboardingStepWallTitle;

  /// No description provided for @onboardingStepWallSub.
  ///
  /// In en, this message translates to:
  /// **'Millions feel the same exhaustion.'**
  String get onboardingStepWallSub;

  /// No description provided for @onboardingComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Achieve 2X more focus and clarity with CleVer'**
  String get onboardingComparisonTitle;

  /// No description provided for @onboardingComparisonLabelLeft.
  ///
  /// In en, this message translates to:
  /// **'Without CleVer'**
  String get onboardingComparisonLabelLeft;

  /// No description provided for @onboardingComparisonLabelRight.
  ///
  /// In en, this message translates to:
  /// **'With CleVer'**
  String get onboardingComparisonLabelRight;

  /// No description provided for @onboardingComparisonValueLeft.
  ///
  /// In en, this message translates to:
  /// **'20%'**
  String get onboardingComparisonValueLeft;

  /// No description provided for @onboardingComparisonValueRight.
  ///
  /// In en, this message translates to:
  /// **'2X'**
  String get onboardingComparisonValueRight;

  /// No description provided for @onboardingComparisonFooter.
  ///
  /// In en, this message translates to:
  /// **'CleVer makes it easy and holds you accountable.'**
  String get onboardingComparisonFooter;

  /// No description provided for @onboardingViewSolution.
  ///
  /// In en, this message translates to:
  /// **'View Solution'**
  String get onboardingViewSolution;

  /// No description provided for @showMeTheWay.
  ///
  /// In en, this message translates to:
  /// **'Show Me The Way'**
  String get showMeTheWay;

  /// No description provided for @reviewPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying the results?'**
  String get reviewPromptTitle;

  /// No description provided for @reviewPromptContent.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us make CleVer even better for everyone.'**
  String get reviewPromptContent;

  /// No description provided for @reviewPromptPositive.
  ///
  /// In en, this message translates to:
  /// **'Yes, I love it!'**
  String get reviewPromptPositive;

  /// No description provided for @reviewPromptNegative.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get reviewPromptNegative;
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
