// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String years(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String months(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String weeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String minutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get add => 'add';

  @override
  String get added => 'added';

  @override
  String get analyzingText => 'analyzing text...';

  @override
  String get and => ' and ';

  @override
  String get applyingDesign => 'applying design...';

  @override
  String get back => 'back';

  @override
  String get bold => 'bold';

  @override
  String get camera => 'camera';

  @override
  String get cancel => 'cancel';

  @override
  String get checkingSystem => 'checking system...';

  @override
  String get clearLocalData => 'clear local data as well (full reset)';

  @override
  String get close => 'close';

  @override
  String get complete => 'complete';

  @override
  String get continueChooseTemplate => 'continue: choose template';

  @override
  String get continueToReview => 'continue: review data';

  @override
  String get creatingPages => 'creating pages...';

  @override
  String get download => 'download';

  @override
  String get downloadPDF => 'download pdf';

  @override
  String get downloadPDFDescription =>
      'this pdf is stored in the cloud. would you like to download it now?';

  @override
  String get downloadComplete => 'download complete';

  @override
  String downloadFailed(String error) {
    return 'download failed: $error';
  }

  @override
  String get downloading => 'downloading...';

  @override
  String get finalStatus => 'final';

  @override
  String get untitled => 'untitled';

  @override
  String get openPDF => 'open pdf';

  @override
  String get delete => 'delete';

  @override
  String get exitWithoutSaving => 'Discard';

  @override
  String get failed => 'failed';

  @override
  String get male => 'male';

  @override
  String get female => 'female';

  @override
  String get gender => 'gender';

  @override
  String get viewAll => 'view all';

  @override
  String get finalizing => 'finalizing...';

  @override
  String get finalizingPdf => 'finalizing pdf...';

  @override
  String get gallery => 'gallery';

  @override
  String get generatingPdfBadge => 'generating pdf';

  @override
  String get goHome => 'go home';

  @override
  String get identifyingVacancy => 'identifying vacancy...';

  @override
  String get improving => 'improving...';

  @override
  String get italic => 'italic';

  @override
  String get keepLocalData => 'keep my local data (master profile)';

  @override
  String get loadingPreview => 'loading preview...';

  @override
  String get next => 'next';

  @override
  String get or => 'or';

  @override
  String get organizingData => 'organizing data...';

  @override
  String get other => 'other';

  @override
  String get pdfFile => 'pdf file';

  @override
  String get polishing => 'polishing...';

  @override
  String get preparingGallery => 'preparing gallery...';

  @override
  String get preparingProfile => 'preparing profile...';

  @override
  String get present => 'present';

  @override
  String get previewCV => 'preview cv';

  @override
  String get processingData => 'processing data...';

  @override
  String get ready => 'ready!';

  @override
  String get rephrasing => 'rephrasing...';

  @override
  String get requiredField => 'required';

  @override
  String get requiredFieldFriendly => 'this is required!';

  @override
  String get retry => 'retry';

  @override
  String get save => 'save';

  @override
  String get saveAllCaps => 'save';

  @override
  String get selectDate => 'select date';

  @override
  String get skipIntro => 'skip';

  @override
  String get startNow => 'start now';

  @override
  String get stayHere => 'Cancel';

  @override
  String get syncAnywhere => 'access from any device, auto-sync';

  @override
  String get syncData => 'sync data';

  @override
  String get typeHere => 'type here...';

  @override
  String get unknownError => 'unknown error';

  @override
  String get unknownErrorDesc =>
      'something went wrong, but we aren\'t sure what.';

  @override
  String get update => 'update';

  @override
  String get untilNow => 'until now';

  @override
  String get uploadInstruction => 'tap to upload your professional photo';

  @override
  String get uploadingPhoto => 'uploading photo...';

  @override
  String get validatingData => 'validating data...';

  @override
  String get validatingLink => 'validating link...';

  @override
  String get writeSomething => 'please write something';

  @override
  String get year => 'year';

  @override
  String get uploadPhoto => 'upload photo';

  @override
  String get cleverYes => 'yes';

  @override
  String get cleverNo => 'no';

  @override
  String get total => 'total';

  @override
  String get searchResult => 'search results';

  @override
  String get alreadyHaveAccount => 'already have an account?';

  @override
  String get authWallBuyCredits => 'sign in to get pass';

  @override
  String get authWallBuyCreditsDesc =>
      'an account is required to activate a job hunter pass';

  @override
  String get authWallCreateCV => 'sign in to create your cv';

  @override
  String get authWallCreateCVDesc =>
      'an account is required to create and save your cv';

  @override
  String get authWallSelectTemplate => 'sign in to select a template';

  @override
  String get authWallSelectTemplateDesc =>
      'an account is required to choose a template';

  @override
  String get cantOpenEmail => 'could not open email app.';

  @override
  String get checkSpamFolder =>
      'can\'t find it? please check your spam or junk folder.';

  @override
  String get continueWithGoogle => 'continue with google';

  @override
  String get createAccount => 'create account';

  @override
  String get dontHaveAccount => 'don\'t have an account?';

  @override
  String get email => 'email';

  @override
  String get emailNotVerifiedYet =>
      'email not verified yet. please check your inbox.';

  @override
  String get emailVerifiedSuccess => 'email verified successfully!';

  @override
  String get forgotPassword => 'forgot password';

  @override
  String get forgotPasswordResetMessage =>
      'enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get iHaveVerified => 'i have verified';

  @override
  String get logIn => 'log in';

  @override
  String get login => 'login';

  @override
  String get loginToSave => 'login to access all features';

  @override
  String get password => 'password';

  @override
  String get passwordMinLength => 'password must be at least 6 characters';

  @override
  String get pleaseEnterEmail => 'please enter your email';

  @override
  String get resendEmail => 'resend verification email';

  @override
  String get sendResetLink => 'send reset link';

  @override
  String get signUp => 'sign up';

  @override
  String get unlockFeatures => 'activate job hunter pass';

  @override
  String get userNotLoggedIn => 'user not logged in';

  @override
  String get verificationEmailSent => 'verification email sent!';

  @override
  String verificationSentTo(String email) {
    return 'a verification link has been sent to $email. please check your inbox and spam folder.';
  }

  @override
  String get verifyYourEmail => 'verify your email';

  @override
  String get cleverGetStartedTitle => 'Nice to meet you!';

  @override
  String get cleverGetStartedSubtitle1 =>
      'feel more confident with tailored cvs.';

  @override
  String get cleverGetStartedSubtitle2 => 'without the manual editing anymore.';

  @override
  String get cleverSignInGreeting => 'welcome back!';

  @override
  String get cleverGoogleSignUp => 'Sign up with Google';

  @override
  String get cleverGoogleSignIn => 'Sign in with Google';

  @override
  String get cleverEmailInvalid => 'enter a valid email';

  @override
  String get cleverConsentLine => 'I have read the Privacy Policy & Terms';

  @override
  String get addCertification => 'add certification';

  @override
  String get addEducation => 'add education';

  @override
  String get addExperience => 'add experience';

  @override
  String get addSubject => 'add subject';

  @override
  String get addSkill => 'add skill';

  @override
  String get birthDate => 'birth date';

  @override
  String get certificationName => 'certification name';

  @override
  String get certificationTitle => 'certifications & licenses';

  @override
  String get certifications => 'certifications';

  @override
  String get certificationsLicenses => 'certifications & licenses';

  @override
  String get company => 'company';

  @override
  String get companyHint => 'company name (optional)';

  @override
  String get contactHint => 'so we can get back to you...';

  @override
  String get contactOptional => 'email / whatsapp (optional)';

  @override
  String get degree => 'degree / major';

  @override
  String get descriptionHint =>
      'explain your main responsibilities and achievements...';

  @override
  String get educationHistory => 'education history';

  @override
  String get educationTitle => 'education history';

  @override
  String get endDate => 'end date';

  @override
  String get experience => 'experience';

  @override
  String get experienceTitle => 'work experience';

  @override
  String get fullName => 'full name';

  @override
  String get header => 'header';

  @override
  String get issuer => 'issuer';

  @override
  String get jobTitle => 'job title';

  @override
  String get locationHint => 'ex: jakarta -> dki jakarta, south jakarta';

  @override
  String get locationLabel => 'location (search city/regency)';

  @override
  String get noCertifications => 'no certifications yet.';

  @override
  String get noEducation => 'no education history yet.';

  @override
  String get noExperience => 'no work experience yet.';

  @override
  String get noSkills => 'no skills yet.';

  @override
  String get personalInfo => 'contact information';

  @override
  String get phoneNumber => 'phone number';

  @override
  String get positionHint => 'position (ex: ui designer)';

  @override
  String get professionalSummary => 'professional summary';

  @override
  String get scanKHSTitle => 'Scan Study Result Card (KHS)';

  @override
  String get scanKHSMessage => 'Select a source to extract GPA and subjects';

  @override
  String get academicSubjects => 'academic subjects';

  @override
  String get subjectName => 'subject name';

  @override
  String get gradeOptional => 'grade (optional)';

  @override
  String get whatDidYouLearn => 'what did you learn? (optional)';

  @override
  String get gpaLabel => 'GPA / IPK';

  @override
  String get educationDescriptionLabel => 'description / honors';

  @override
  String get educationDescriptionHint =>
      'e.g. Summa Cum Laude, Major in Computer Science';

  @override
  String get schoolHint => 'ex: university of indonesia';

  @override
  String get schoolLabel => 'school / university';

  @override
  String get schoolName => 'school name';

  @override
  String get shortDescription => 'short description';

  @override
  String get skills => 'skills';

  @override
  String get skillsSubtitle =>
      'list all your skills. ai will highlight the ones that best match the position you are aiming for.';

  @override
  String get skillsTitle => 'what are your skills?';

  @override
  String get startDate => 'start date';

  @override
  String get summaryEmpty => 'summary cannot be empty';

  @override
  String get summaryHint => 'write a brief professional summary...';

  @override
  String get targetPosition => 'target position';

  @override
  String get whatJobApply => 'what job are you applying for?';

  @override
  String get workExperience => 'work experience';

  @override
  String get mascotWelcome => 'here we go';

  @override
  String get mascotWelcomeSub =>
      'your journey to a happier, healthier life starts now.';

  @override
  String get mascotEncourage => 'keep it fresh';

  @override
  String get mascotEncourageSub =>
      'don\'t forget to update your master profile every time you get new experience!';

  @override
  String get mascotExciting => 'wih, amazing!';

  @override
  String get mascotExcitingSub =>
      'you just created your first cv! let\'s keep the momentum going.';

  @override
  String get cleverWelcomePersonaTitle => 'which team are you on?';

  @override
  String get cleverPersonaStudent => 'student';

  @override
  String get cleverPersonaJobSeeker => 'active job seeker';

  @override
  String get cleverPersonaCareerSwitcher => 'switching careers';

  @override
  String get cleverWelcomeBudgetTitle =>
      'how much have you spent on a single CV service?';

  @override
  String get cleverWelcomeSingleCvTitle =>
      'do you use just 1 CV for every application?';

  @override
  String get cleverWelcomeAppsTitle =>
      'how many jobs do you apply to in a day?';

  @override
  String get cleverWelcomeReasonTitle =>
      'what makes you put off making tailored CVs?';

  @override
  String get cleverReasonCompanyResearch => 'company research';

  @override
  String get cleverReasonRepromptAi => 're-prompting chatGPT';

  @override
  String get cleverReasonManualTemplate => 'editing templates manually';

  @override
  String get cleverReasonRepeatedForms => 'filling in the same forms again';

  @override
  String get cleverWelcomeThanksTitle => 'thank you for trusting us.';

  @override
  String get cleverWelcomePrivacyNote =>
      'your privacy and personal security are our top priority.';

  @override
  String get cleverReadMore => 'read more';

  @override
  String get cleverLegalPendingBody =>
      'This document is being prepared and will be available here soon.';

  @override
  String get cleverWelcomeSocialProofTitle =>
      'applying to 100 openings becomes effective with tailored CVs!';

  @override
  String get cleverIntroTagline => 'Your experience, always within reach.';

  @override
  String get cleverIntroSupport =>
      'build a professional track record you can use every time an opportunity comes.';

  @override
  String get cleverIntroCta => 'start now';

  @override
  String get cleverPanelHeaderTitle => 'header';

  @override
  String get cleverPanelHeaderSubtitle =>
      'this information appears in your CV header as contact details.';

  @override
  String get cleverPhoneField => 'phone number';

  @override
  String get cleverTooltipBirthDate =>
      'some job offers list age requirements — the AI tailoring uses this to match you.';

  @override
  String get cleverTooltipGender =>
      'some job offers target a specific gender — the AI tailoring uses this to match you.';

  @override
  String cleverYearsOld(Object age) {
    return '$age y.o.';
  }

  @override
  String get cleverGenderMale => 'male';

  @override
  String get cleverGenderFemale => 'female';

  @override
  String get cleverGenderNone => 'rather not say';

  @override
  String get cleverConfirmTitle => 'save your changes?';

  @override
  String get cleverConfirmMessage =>
      'you have unsaved progress on your profile.';

  @override
  String get cleverConfirmSave => 'save draft';

  @override
  String get cleverConfirmDiscard => 'discard';

  @override
  String get cleverMethodTitle => 'choose your method';

  @override
  String get cleverMethodSubtitle =>
      'pick whatever is most comfortable for filling in your career bank.';

  @override
  String get cleverMethodScan => 'scan';

  @override
  String get cleverMethodScanDesc =>
      'import your professional history from an old cv draft.';

  @override
  String get cleverMethodCerita => 'story';

  @override
  String get cleverMethodCeritaDesc =>
      'no cv yet? just tell us your whole professional history';

  @override
  String get cleverScanSheetSubtitle =>
      'your professional history gets extracted automatically by AI.';

  @override
  String get cleverUploadPhoto => 'upload photo';

  @override
  String get cleverUploadPhotoHint =>
      'use the camera or pick from your gallery.';

  @override
  String get cleverUploadFile => 'upload file';

  @override
  String get cleverUploadFileHint => 'pick a document from this device.';

  @override
  String get cleverExperienceSubtitle => 'add every work experience you have.';

  @override
  String get cleverListLabel => 'list';

  @override
  String get cleverEmptyTitle => 'nothing here yet';

  @override
  String get cleverEmptyExperiencePrompt =>
      'start adding your work experience!';

  @override
  String get cleverSkip => 'skip';

  @override
  String get cleverDeleteExperienceTitle => 'delete this experience?';

  @override
  String get cleverConfirmDelete => 'delete';

  @override
  String get cleverToggleType => 'type';

  @override
  String get cleverToggleDictate => 'dictate';

  @override
  String get cleverEducationSubtitle =>
      'add every education you have completed.';

  @override
  String get cleverEmptyEducationPrompt => 'start adding your education!';

  @override
  String get cleverDeleteEducationTitle => 'delete this education?';

  @override
  String get cleverCertificationSubtitle =>
      'add every certification and license you hold.';

  @override
  String get cleverEmptyCertificationPrompt =>
      'start adding your certifications!';

  @override
  String get cleverDeleteCertificationTitle => 'delete this certification?';

  @override
  String get cleverEmptySkillsPrompt => 'start adding your skills!';

  @override
  String get cleverCompleteTitle => 'all set!';

  @override
  String get cleverCompleteSubtitle =>
      'your profile is complete.\nnow all that\'s left is making your first CV.';

  @override
  String get cleverCompleteSummary => 'profile summary';

  @override
  String cleverCompleteProgress(int completed) {
    return '$completed of 5';
  }

  @override
  String cleverCompleteCount(int count) {
    return '$count entries';
  }

  @override
  String get cleverCompleteRowHeader => 'header — name, contact, birth date';

  @override
  String get cleverCompleteFootnote =>
      'you can edit everything anytime in your profile.';

  @override
  String get cleverImportingTitle => 'importing';

  @override
  String get aiAnalyzingProfile => 'ai is analyzing your profile...';

  @override
  String get aiExtractingInsights => 'extracting insights...';

  @override
  String get cvDataExists => 'cv data already exists in your profile.';

  @override
  String get cvImportedSuccess =>
      'cv imported successfully! let\'s complete your profile.';

  @override
  String get importCV => 'import cv';

  @override
  String get importCVMessage => 'choose how to import your cv:';

  @override
  String get importCVTitle => 'import cv';

  @override
  String get importFailedMessage => 'failed to import cv. please try again!';

  @override
  String get importFromCV => 'import from cv';

  @override
  String importSuccessMessage(
    Object eduCount,
    Object expCount,
    Object skillsCount,
  ) {
    return 'cv imported successfully!\nadded: $expCount experience, $eduCount education, $skillsCount skills';
  }

  @override
  String get importSuccessTitle => 'import successful!';

  @override
  String get importSuccessSubtitle => 'here\'s what we found in your cv:';

  @override
  String get importSuccessPersonalInfo => 'personal info detected';

  @override
  String importSuccessExperience(int count) {
    return '$count experience(s)';
  }

  @override
  String importSuccessEducation(int count) {
    return '$count education(s)';
  }

  @override
  String importSuccessSkills(int count) {
    return '$count skill(s)';
  }

  @override
  String importSuccessCertifications(int count) {
    return '$count certification(s)';
  }

  @override
  String get importSuccessContinue => 'continue';

  @override
  String get importSuccessNoNewData =>
      'all data already exists in your profile.';

  @override
  String get jobExtractionFailed => 'failed to extract job posting';

  @override
  String get jobExtractionSuccess => 'job posting extracted successfully!';

  @override
  String get noTextFound => 'no text found in image';

  @override
  String get noTextFoundInCV => 'no text found in cv';

  @override
  String get ocrScanning => 'ocr scanning';

  @override
  String get scanJobPosting => 'scan job posting';

  @override
  String get searchJob => 'search for jobs...';

  @override
  String get cv => 'cv';

  @override
  String get aiAnalysisTitle => 'ai analysis';

  @override
  String get aiTailoringOptions => 'ai tailoring options';

  @override
  String get aiHelpCreateCV =>
      'ai will help create a cv perfectly tailored for this goal.';

  @override
  String get aiTestingConstraints => 'testing against ats constraints...';

  @override
  String get maxSkills => 'max skills';

  @override
  String get honestAiFeedback => 'honest ai feedback';

  @override
  String get honestAiFeedbackDesc => 'get strict & critical advice';

  @override
  String get conciseFormat => 'concise format';

  @override
  String get conciseFormatDesc => 'focus on brevity & impact';

  @override
  String get cvOutputLanguage => 'cv output language';

  @override
  String get cvOutputLanguageDesc =>
      'ai will write your cv content in this language';

  @override
  String get cvOutputLanguageAuto => 'auto';

  @override
  String get atsStandard => 'ats standard';

  @override
  String get autoFillFromMaster => 'data auto-filled from your master profile';

  @override
  String get createCV => 'create cv';

  @override
  String get creativeDesign => 'creative design';

  @override
  String get cvGeneratedSuccess => 'cv generated successfully';

  @override
  String cvReadyMessage(Object jobTitle) {
    return 'your cv for $jobTitle is ready!';
  }

  @override
  String get generateCVFirst => 'generate your first cv to see it here';

  @override
  String get cvs => 'cvs';

  @override
  String get drafts => 'drafts';

  @override
  String get exportPdf => 'export pdf';

  @override
  String get fetchingTemplates => 'fetching templates...';

  @override
  String get folderEmpty => 'folder is empty';

  @override
  String get includeProfilePhoto => 'include profile photo';

  @override
  String get jobListScannerHint =>
      'found a job here? take a screenshot and use our smart scanner to instantly auto-fill your cv!';

  @override
  String get locked => 'locked';

  @override
  String get loadingTemplatesBadge => 'loading templates';

  @override
  String get myCVs => 'my cvs';

  @override
  String get myDrafts => 'my drafts';

  @override
  String get noDrafts => 'no drafts yet.';

  @override
  String get noMatchingPdfs => 'no pdfs match your search.';

  @override
  String get searchGeneratedCvs => 'search generated cvs...';

  @override
  String get premium => 'premium';

  @override
  String get previewTemplate => 'preview template';

  @override
  String get requirementsCheckLabel => 'requirements check:';

  @override
  String get reviewData => 'review data';

  @override
  String get reviewedByAI => 'data & summary tailored by ai';

  @override
  String get selectTemplate => 'select template';

  @override
  String get tailoredDataMessage =>
      'this data has been tailored by ai to be relevant to your target position. please review!';

  @override
  String templateLoadError(Object error) {
    return 'error loading templates: $error';
  }

  @override
  String get usingMasterPhoto => 'using master profile photo';

  @override
  String get viewDrafts => 'view drafts';

  @override
  String get generateCvFree => 'generate';

  @override
  String get cvExport => 'cv export';

  @override
  String freeExportsLeft(Object count) {
    return '$count free exports left';
  }

  @override
  String get exports => 'exports';

  @override
  String get templateRequiresPhoto => 'this template needs a photo';

  @override
  String get templateRequiresPhotoDesc =>
      'you selected a style with a profile photo, but no photo has been uploaded yet.';

  @override
  String get useStyleWithoutPhoto => 'use style without photo';

  @override
  String accountDeleteError(Object error) {
    return 'failed to delete account: $error';
  }

  @override
  String get accountDeletedGoodbye => 'account successfully deleted. goodbye!';

  @override
  String get quickActions => 'quick actions';

  @override
  String get cleverUser => 'clever user';

  @override
  String get bugReport => 'bug report';

  @override
  String get completeProfileFirst => 'complete profile first for best results';

  @override
  String get confirmDelete => 'confirm deletion';

  @override
  String get contactSupport => 'contact support';

  @override
  String get noCompletedCVs => 'no generated cvs yet';

  @override
  String get deleteAccount => 'delete account';

  @override
  String get deleteAccountQuestion => 'delete account?';

  @override
  String get deleteAccountWarning =>
      'this action is irreversible. all your data, including generated cvs and active subscriptions, will be permanently deleted.';

  @override
  String get deleteConfirmation => 'are you sure you want to delete this item?';

  @override
  String get editExperienceTitle => 'edit experience';

  @override
  String get faqDataAnswer =>
      'your data is stored locally (master profile). data sent to ai is processed briefly and not stored.';

  @override
  String get faqDataQuestion => 'is my data safe?';

  @override
  String get faqEditAnswer =>
      'go to the profile menu, edit the section you want, and hit save.';

  @override
  String get faqEditQuestion => 'how to edit profile?';

  @override
  String get faqFreeAnswer =>
      'yes, basic features are free. we might add premium features in the future.';

  @override
  String get faqFreeQuestion => 'is cv master free?';

  @override
  String get faqPdfAnswer =>
      'sure! after creating your cv, you can download/print pdf in the preview.';

  @override
  String get faqPdfQuestion => 'can i export to pdf?';

  @override
  String get featureRequest => 'feature request';

  @override
  String get feedback => 'feedback';

  @override
  String get feedbackSubtitle => 'share your experience or report an issue.';

  @override
  String get message => 'message';

  @override
  String get recentTransactions => 'recent transactions';

  @override
  String get feedbackThanksMessage =>
      'your feedback is valuable for cv master development.';

  @override
  String get frequentQuestions => 'common questions';

  @override
  String get helpSupport => 'help & support';

  @override
  String get home => 'home';

  @override
  String get howCanWeHelp => 'how can we help you?';

  @override
  String get logOut => 'log out';

  @override
  String get masterProfileUpdated => 'master profile updated successfully';

  @override
  String get noMatchingJobs => 'no matching jobs found.';

  @override
  String get noNotifications => 'no notifications yet';

  @override
  String get notificationChannelCVDesc =>
      'notifications for cv generation updates';

  @override
  String get notificationChannelCVTitle => 'cv generation';

  @override
  String get notificationChannelGeneralDesc => 'general app notifications';

  @override
  String get notificationChannelGeneralTitle => 'general alerts';

  @override
  String get notificationNew => 'new notification';

  @override
  String get notifications => 'notifications';

  @override
  String get photoSettings => 'photo settings';

  @override
  String photoUpdateError(String error) {
    return 'error uploading photo: $error';
  }

  @override
  String get photoUpdateSuccess => 'profile photo updated successfully!';

  @override
  String get profilePhotoExportTooltip =>
      'this photo will be used for every pdf export that includes a photo.';

  @override
  String get privacyPolicy => 'privacy policy';

  @override
  String get profile => 'profile';

  @override
  String get profileSavedSuccess =>
      'profile saved! will be used for your next cv.';

  @override
  String get saveChangesMessage =>
      'You have unsaved changes. Would you like to save them before leaving?';

  @override
  String get saveChangesTitle => 'Unsaved Changes';

  @override
  String get saveProfile => 'save profile';

  @override
  String get sendFeedback => 'send feedback';

  @override
  String get suggestionsBugs => 'suggestions & bugs';

  @override
  String get termsOfService => 'terms of service';

  @override
  String get wallet => 'wallet';

  @override
  String get noTransactionsYet => 'no transactions yet';

  @override
  String get failedToLoadTransactions => 'failed to load transactions';

  @override
  String get transactionHistory => 'transaction history';

  @override
  String get reviewPromptTitle => 'Loving your new CV?';

  @override
  String get reviewPromptContent =>
      'Your support keeps CleVer running. If you\'re happy, a quick review means the world to us!';

  @override
  String get reviewPromptPositive => 'I love it!';

  @override
  String get reviewPromptNegative => 'Needs improvement';

  @override
  String get tutorialJobOcrTitle => 'Scan Job Postings';

  @override
  String get tutorialJobOcrDesc =>
      'Did you know you can screenshot a job posting? We\'ll extract the details for you instantly!';

  @override
  String get tutorialDraftsTitle => 'Your Drafts';

  @override
  String get tutorialDraftsDesc =>
      'You can edit your drafts here and export them with different designs anytime.';

  @override
  String get tutorialProfileTitle => 'Master Profile';

  @override
  String get tutorialProfileDesc =>
      'Manage your Master Profile here to keep your base CV data up to date.';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialFinish => 'Got it!';

  @override
  String get active => 'active';

  @override
  String get activePass => 'active pass';

  @override
  String get free => 'free';

  @override
  String get membershipStatus => 'membership status';

  @override
  String get subscriptionWarning =>
      'you have an active job hunter pass. deleting your account will terminate your access immediately and cannot be refunded.';

  @override
  String get jobHunterPass => 'job hunter pass';

  @override
  String get getJobHunterPassNow => 'subscribe';

  @override
  String get paywallHeadline => 'Land Your Dream Job';

  @override
  String get bestValue => 'Best Value';

  @override
  String get downsellHeadline => 'Just Need It Today?';

  @override
  String get downsellCta => 'Try It for 24 Hours';

  @override
  String get downsellTrust => 'No auto-renew · One-time pass';

  @override
  String get noThanks => 'No thanks';

  @override
  String get paywallSimpleBenefit =>
      'access all features and templates unlimited. no ads';

  @override
  String get product24hTitle => '24 Hour Pass';

  @override
  String get product24hDesc => 'Full access for 24 hours';

  @override
  String get product3dTitle => '3 Day Pass';

  @override
  String get product3dDesc => 'Full access for 3 days';

  @override
  String get productWeeklyTitle => 'Weekly';

  @override
  String productWeeklyDesc(String price) {
    return '≈ $price/day';
  }

  @override
  String get productMonthlyTitle => 'Monthly';

  @override
  String productMonthlyDesc(String price) {
    return '≈ $price/day';
  }

  @override
  String get productYearlyTitle => 'Yearly';

  @override
  String productYearlyDesc(String price) {
    return '≈ $price/day';
  }

  @override
  String get productLifetimeTitle => 'Lifetime Access';

  @override
  String get productLifetimeDesc => 'One-time payment · Forever';

  @override
  String get passLifetime => 'lifetime';

  @override
  String get activate => 'activate';

  @override
  String subscriptionExpiryCount(String time) {
    return 'expires in $time';
  }

  @override
  String get upgradeNow => 'upgrade now';

  @override
  String get weekly => 'weekly';

  @override
  String get yearly => 'yearly';

  @override
  String get deviceLimitReached =>
      'Device limit reached. Free exports are limited to 2 per device.';

  @override
  String get lifetimeAccessActive => 'You have Lifetime Access!';

  @override
  String get lifetimeAccessActiveDesc =>
      'Enjoy unlimited CV generation and premium templates forever. No further actions needed.';

  @override
  String get upgradeToLifetime => 'Upgrade to Lifetime';

  @override
  String get upgradeToLifetimeDesc =>
      'Get unlimited access forever and stop recurring billing.';

  @override
  String get cancelRecurringWarning =>
      'You currently have an active subscription. Confirm now to instantly upgrade to Lifetime!';

  @override
  String get almostThere => 'almost there...';

  @override
  String analyzeProfileError(Object error) {
    return 'failed to analyze profile: $error';
  }

  @override
  String get category => 'category';

  @override
  String get continuingToForm => 'continuing to form...';

  @override
  String get created => 'created';

  @override
  String get dateLabel => 'date:';

  @override
  String get errorDetailsCopied => 'error details copied to clipboard';

  @override
  String get fillDescriptionFirst =>
      'please fill in the description first to use ai rewrite!';

  @override
  String get fillJobTitle => 'fill job title first!';

  @override
  String get fillNameError => 'please fill in your full name first.';

  @override
  String get generated => 'generated';

  @override
  String get getStarted => 'get started';

  @override
  String get jobDetailHint =>
      'paste job description, requirements, or qualifications here...';

  @override
  String get jobDetailLabel => 'detail / qualification (optional)';

  @override
  String get messageDetail => 'message / detail';

  @override
  String get allFilter => 'all';

  @override
  String get question => 'question';

  @override
  String get rewrite => 'rewrite';

  @override
  String get rewriteAI => 'rewrite ai';

  @override
  String rewriteFailed(String error) {
    return 'rewrite failed: $error';
  }

  @override
  String get sending => 'sending...';

  @override
  String get skillHint => 'ex: flutter, leadership';

  @override
  String get technicalDetails => 'technical details';

  @override
  String get thankYou => 'thank you!';

  @override
  String get voiceListening => 'listening...';

  @override
  String get voiceProcessing => 'processing...';

  @override
  String get voiceParseError =>
      'couldn\'t process your voice input. please try again.';

  @override
  String get voiceUseSuara => 'Use voice';

  @override
  String get voiceAnalyzing => 'analyzing...';

  @override
  String get voiceAlmostDone => 'almost done...';

  @override
  String get voiceSpeechUnavailable => 'Speech recognition unavailable';

  @override
  String get voiceTapMicHint => 'Tap mic & speak naturally';
}
