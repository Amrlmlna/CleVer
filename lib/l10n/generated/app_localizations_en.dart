// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String accountDeleteError(Object error) {
    return 'failed to delete account: $error';
  }

  @override
  String get accountDeletedGoodbye => 'account successfully deleted. goodbye!';

  @override
  String get activityOverview => 'activity overview';

  @override
  String get add => 'add';

  @override
  String get addCertification => 'add certification';

  @override
  String get addEducation => 'add education';

  @override
  String get addExperience => 'add experience';

  @override
  String get addSubject => 'add subject';

  @override
  String get addSubjectManually => 'add subject manually';

  @override
  String get addSkill => 'add skill';

  @override
  String get aiAnalysisTitle => 'ai analysis';

  @override
  String get aiTailoringOptions => 'ai tailoring options';

  @override
  String get aiAnalyzingProfile => 'ai is analyzing your profile...';

  @override
  String get aiExtractingInsights => 'extracting insights...';

  @override
  String get aiHelpCreateCV =>
      'ai will help create a cv perfectly tailored for this goal.';

  @override
  String get aiPowered => 'ai powered';

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
  String get almostThere => 'almost there...';

  @override
  String get alreadyHaveAccount => 'already have an account?';

  @override
  String get alreadyHaveCV => 'already have a cv?';

  @override
  String get alreadyHaveCVSubtitle =>
      'speed things up! import your existing cv and we\'ll fill everything in for you.';

  @override
  String analyzeProfileError(Object error) {
    return 'failed to analyze profile: $error';
  }

  @override
  String get analyzingText => 'analyzing text...';

  @override
  String get and => ' and ';

  @override
  String get applyingDesign => 'applying design...';

  @override
  String get atsStandard => 'ats standard';

  @override
  String get authWallBuyCredits => 'sign in to buy credits';

  @override
  String get authWallBuyCreditsDesc =>
      'an account is required to purchase credits';

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
  String get autoFillFromMaster => 'data auto-filled from your master profile';

  @override
  String get back => 'back';

  @override
  String get bold => 'bold';

  @override
  String get bugReport => 'bug report';

  @override
  String get birthDate => 'birth date';

  @override
  String get camera => 'camera';

  @override
  String get cancel => 'cancel';

  @override
  String get cantOpenEmail => 'could not open email app.';

  @override
  String get careerAnalytics => 'career analytics';

  @override
  String get category => 'category';

  @override
  String get certificationName => 'certification name';

  @override
  String get certificationSubtitle =>
      'enter relevant certifications, licenses, or awards. this can be a huge plus.';

  @override
  String get certificationTitle => 'certifications & licenses';

  @override
  String get certifications => 'certifications';

  @override
  String get certificationsLicenses => 'certifications & licenses';

  @override
  String get checkSpamFolder =>
      'can\'t find it? please check your spam or junk folder.';

  @override
  String get checkingSystem => 'checking system...';

  @override
  String get clearLocalData => 'clear local data as well (full reset)';

  @override
  String get close => 'close';

  @override
  String get company => 'company';

  @override
  String get companyHint => 'company name (optional)';

  @override
  String get companyPlaceholder => 'ex: google';

  @override
  String get compilingProfile => 'compiling profile...';

  @override
  String get complete => 'complete';

  @override
  String get completeProfileFirst => 'complete profile first for best results';

  @override
  String get confirmDelete => 'confirm deletion';

  @override
  String get contactHint => 'so we can get back to you...';

  @override
  String get contactOptional => 'email / whatsapp (optional)';

  @override
  String get contactSupport => 'contact support';

  @override
  String get continueChooseTemplate => 'continue: choose template';

  @override
  String get continueToReview => 'continue: review data';

  @override
  String get continueWithGoogle => 'continue with google';

  @override
  String get continuingToForm => 'continuing to form...';

  @override
  String get createAccount => 'create account';

  @override
  String get createAccountSubtitle => 'start your journey to a better career';

  @override
  String get createCV => 'create cv';

  @override
  String get createFirstCV => 'create your\nfirst cv.';

  @override
  String get createProfessionalCV => 'create a\nprofessional cv.';

  @override
  String get created => 'created';

  @override
  String get creatingPages => 'creating pages...';

  @override
  String get creativeDesign => 'creative design';

  @override
  String get creditBalance => 'credit balance';

  @override
  String creditWarning(int count) {
    return 'warning: you have $count credits remaining. these are non-refundable.';
  }

  @override
  String get credits => 'credits';

  @override
  String get currentLevel => 'current level';

  @override
  String get cvDataExists => 'cv data already exists in your profile.';

  @override
  String get cvGeneratedSuccess => 'cv generated successfully';

  @override
  String get cvImportedSuccess =>
      'cv imported successfully! let\'s complete your profile.';

  @override
  String get cvLanguage => 'cv language';

  @override
  String cvReadyMessage(Object jobTitle) {
    return 'your cv for $jobTitle is ready!';
  }

  @override
  String get download => 'download';

  @override
  String get downloadPDF => 'download pdf';

  @override
  String get downloadPDFDescription =>
      'this pdf is stored in the cloud. would you like to download it now?';

  @override
  String get cvs => 'cvs';

  @override
  String get dateLabel => 'date:';

  @override
  String get degree => 'degree / major';

  @override
  String get degreeHint => 'bachelor of computer science';

  @override
  String get delete => 'delete';

  @override
  String get deleteAccount => 'delete account';

  @override
  String get deleteAccountQuestion => 'delete account?';

  @override
  String get deleteAccountWarning =>
      'this action is irreversible. all your data, including generated cvs and credits, will be permanently deleted.';

  @override
  String get deleteConfirmation => 'are you sure you want to delete this item?';

  @override
  String get descriptionHint =>
      'explain your main responsibilities and achievements...';

  @override
  String get dontHaveAccount => 'don\'t have an account?';

  @override
  String get drafts => 'drafts';

  @override
  String get dropYourDetails => 'drop your details.';

  @override
  String get editCertification => 'edit certification';

  @override
  String get editEducation => 'edit education';

  @override
  String get editExperienceTitle => 'edit experience';

  @override
  String get educationHistory => 'education history';

  @override
  String get educationSubtitle =>
      'fill in all your education history. ai will choose the most relevant level to put on your cv.';

  @override
  String get educationTitle => 'education history';

  @override
  String get email => 'email';

  @override
  String get emailNotVerifiedYet =>
      'email not verified yet. please check your inbox.';

  @override
  String get emailVerifiedSuccess => 'email verified successfully!';

  @override
  String get endDate => 'end date';

  @override
  String get errorDetailsCopied => 'error details copied to clipboard';

  @override
  String get exitWithoutSaving => 'exit without saving';

  @override
  String get experience => 'experience';

  @override
  String get experienceSubtitle =>
      'tell us your experience (work, internship, organization). ai will choose the most relevant ones for your goals.';

  @override
  String get experienceTitle => 'work experience';

  @override
  String get exportPdf => 'export pdf';

  @override
  String get extractingData => 'extracting data...';

  @override
  String get failed => 'failed';

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
  String get male => 'male';

  @override
  String get female => 'female';

  @override
  String get secure => 'secure';

  @override
  String get gender => 'gender';

  @override
  String get viewAll => 'view all';

  @override
  String get member => 'member';

  @override
  String get recentTransactions => 'recent transactions';

  @override
  String get feedbackThanksMessage =>
      'your feedback is valuable for cv master development.';

  @override
  String get fetchingTemplates => 'fetching templates...';

  @override
  String get fillDescriptionFirst =>
      'please fill in the description first to use ai rewrite!';

  @override
  String get fillJobTitle => 'fill job title first!';

  @override
  String get fillNameError => 'please fill in your full name first.';

  @override
  String get finalizing => 'finalizing...';

  @override
  String get finalizingPdf => 'finalizing pdf...';

  @override
  String get folderEmpty => 'folder is empty';

  @override
  String get forgotPassword => 'forgot password';

  @override
  String get free => 'free';

  @override
  String get forgotPasswordResetMessage =>
      'enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get frequentQuestions => 'common questions';

  @override
  String get fri => 'fri';

  @override
  String get fullName => 'full name';

  @override
  String get gallery => 'gallery';

  @override
  String get generateCVFirst => 'generate your first cv to see it here';

  @override
  String get generated => 'generated';

  @override
  String get generatingPdfBadge => 'generating pdf';

  @override
  String get getStarted => 'get started';

  @override
  String get goHome => 'go home';

  @override
  String googleSignInError(Object error) {
    return 'google sign-in failed: $error';
  }

  @override
  String get googleSignInSuccess => 'signed in with google!';

  @override
  String get header => 'header';

  @override
  String helloName(Object name) {
    return 'hello, $name';
  }

  @override
  String get helpSupport => 'help & support';

  @override
  String get home => 'home';

  @override
  String get howCanWeHelp => 'how can we help you?';

  @override
  String get iHaveVerified => 'i have verified';

  @override
  String get identifyingVacancy => 'identifying vacancy...';

  @override
  String get importCV => 'import cv';

  @override
  String get importCVMessage => 'choose how to import your cv:';

  @override
  String get importCVTitle => 'import cv';

  @override
  String get importExistingCV => 'import my cv';

  @override
  String get importExistingCVDesc =>
      'upload a pdf or take a photo — ai fills in the rest.';

  @override
  String get importFailedMessage => 'failed to import cv. please try again!';

  @override
  String get importFromCV => 'import from cv';

  @override
  String get importCVHeroSubtitle =>
      'instantly organize your profile by importing your existing cv.';

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
  String get importingCVBadge => 'importing cv';

  @override
  String get improving => 'improving...';

  @override
  String get includeProfilePhoto => 'include profile photo';

  @override
  String get issuer => 'issuer';

  @override
  String get italic => 'italic';

  @override
  String get jobDetailHint =>
      'paste job description, requirements, or qualifications here...';

  @override
  String get jobDetailLabel => 'detail / qualification (optional)';

  @override
  String get jobExtractionFailed => 'failed to extract job posting';

  @override
  String get jobExtractionSuccess => 'job posting extracted successfully!';

  @override
  String get jobListTitle => 'find jobs';

  @override
  String get jobListSocialTab => 'social (top picks)';

  @override
  String get jobListApiTab => 'job boards (api)';

  @override
  String get jobListScannerHint =>
      'found a job here? take a screenshot and use our smart scanner to instantly auto-fill your cv!';

  @override
  String get jobListNoAccountsFound => 'no accounts found';

  @override
  String jobListNoAccountsFoundDesc(String query) {
    return 'could not find any accounts matching \"$query\". want us to add a specific account?';
  }

  @override
  String get jobListGiveFeedback => 'give feedback';

  @override
  String get jobListSearchTagsHint => 'search tags (e.g. design, tech, remote)';

  @override
  String get jobListNoApiJobs => 'no api jobs available yet';

  @override
  String get jobListNoApiJobsSub =>
      'check out the social tab for the best curated jobs!';

  @override
  String get jobListCreateCvForJob => 'create cv for this job';

  @override
  String get jobListViewOriginal => 'view original';

  @override
  String get jobDescription => 'job description';

  @override
  String get jobRequirements => 'requirements';

  @override
  String get jobCouldNotOpen => 'could not open link';

  @override
  String get jobTitle => 'job title';

  @override
  String get jobs => 'jobs';

  @override
  String get keepBuilding =>
      'keep building your profile to reach the next level!';

  @override
  String get keepLocalData => 'keep my local data (master profile)';

  @override
  String get keyMetrics => 'key metrics';

  @override
  String get locked => 'locked';

  @override
  String get loadingPreview => 'loading preview...';

  @override
  String get loadingTemplatesBadge => 'loading templates';

  @override
  String get locationHint => 'ex: jakarta -> dki jakarta, south jakarta';

  @override
  String get locationLabel => 'location (search city/regency)';

  @override
  String get logIn => 'log in';

  @override
  String get logOut => 'log out';

  @override
  String get login => 'login';

  @override
  String get loginToSave => 'login to access all features';

  @override
  String get masterProfileUpdated => 'master profile updated successfully';

  @override
  String get messageDetail => 'message / detail';

  @override
  String get modernProfessional => 'modern professional';

  @override
  String get mon => 'mon';

  @override
  String get myCVs => 'my cvs';

  @override
  String get myDrafts => 'my drafts';

  @override
  String get next => 'next';

  @override
  String get nextStep => 'next step';

  @override
  String get noCertifications => 'no certifications yet.';

  @override
  String get noCompletedCVs => 'no generated cvs yet';

  @override
  String get noDrafts => 'no drafts yet.';

  @override
  String get noEducation => 'no education history yet.';

  @override
  String get noExperience => 'no work experience yet.';

  @override
  String get noMatchingJobs => 'no matching jobs found.';

  @override
  String get noNotifications => 'no notifications yet';

  @override
  String get noSkills => 'no skills yet.';

  @override
  String get noTextFound => 'no text found in image';

  @override
  String get noTextFoundInCV => 'no text found in cv';

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
  String get ocrScanning => 'ocr scanning';

  @override
  String get onboardingFinalMessage =>
      'master profile safe. now just quickly create your cv.';

  @override
  String onboardingFeedbackCompleteTitle(String name) {
    return 'Amazing work, $name!';
  }

  @override
  String get onboardingFeedbackCompleteMessage =>
      'Your profile is 90% ready. You\'re now in the top tier to get noticed by recruiters!';

  @override
  String get onboardingFeedbackPartialTitle => 'Great start!';

  @override
  String get onboardingFeedbackPartialMessage =>
      'We\'ve lined up some initial recommendations for you. Don\'t forget to fill in the rest later to unlock even better matches.';

  @override
  String get onboardingFeedbackEmptyTitle => 'No worries!';

  @override
  String get onboardingFeedbackEmptyMessage =>
      'You can explore first. Spruce up your profile anytime in the \'Master Profile\' tab so we can work our magic for you.';

  @override
  String get onboardingFeedbackGetSmarterHint =>
      'The app gets smarter as you add more info.';

  @override
  String get onboardingFeedbackCompleteFeatureTitle => 'Top Tier Profile';

  @override
  String get onboardingFeedbackCompleteFeatureSubtitle =>
      'You\'re among the most prepared candidates.';

  @override
  String get onboardingHeadline1 => 'still editing your cv at 1am?';

  @override
  String get onboardingHeadline2 => 'qualified, but still getting rejected?';

  @override
  String get onboardingHeadline3 => 'don\'t start from zero.';

  @override
  String get onboardingHeadline4 => 'dump everything here.';

  @override
  String get onboardingHeadline6 => 'one profile. unlimited tailored cvs.';

  @override
  String get onboardingHeadline7 => 'we want you to try clever for free.';

  @override
  String get onboardingSubtext1 =>
      'stop manual editing. tailor your cv for every job in seconds, not hours.';

  @override
  String get onboardingSubtext2 =>
      'your cv might be failing the ats. we ensure your keywords match what recruiters want.';

  @override
  String get onboardingSubtext3 =>
      'upload your old pdf. we’ll extract and organize your entire history instantly.';

  @override
  String get onboardingSubtext4 =>
      'every role matters. from side jobs to tech lead—we’ll pick what’s relevant.';

  @override
  String get onboardingSubtext6 =>
      'swap between pro-templates instantly. no expensive designers needed.';

  @override
  String get onboardingSubtitle =>
      'fill in data once, generate thousands of cvs without retyping. save time, focus on \"grinding\".';

  @override
  String get openPDF => 'open pdf';

  @override
  String get or => 'or';

  @override
  String get organizingData => 'organizing data...';

  @override
  String get other => 'other';

  @override
  String get password => 'password';

  @override
  String get passwordMinLength => 'password must be at least 6 characters';

  @override
  String get pdfFile => 'pdf file';

  @override
  String pdfGenerateError(Object error) {
    return 'failed to generate pdf: $error';
  }

  @override
  String pdfOpenError(Object error) {
    return 'failed to open pdf: $error';
  }

  @override
  String get personalInfo => 'contact information';

  @override
  String get phoneNumber => 'phone number';

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
  String get pleaseEnterEmail => 'please enter your email';

  @override
  String get pleaseEnterName => 'please enter your name';

  @override
  String get pleaseEnterPassword => 'please enter your password';

  @override
  String get polishing => 'polishing...';

  @override
  String get positionHint => 'position (ex: ui designer)';

  @override
  String get premium => 'premium';

  @override
  String get premiumBadge => 'get credits';

  @override
  String get preparingGallery => 'preparing gallery...';

  @override
  String get preparingProfile => 'preparing profile...';

  @override
  String get present => 'present';

  @override
  String get previewCV => 'preview cv';

  @override
  String get previewTemplate => 'preview template';

  @override
  String get privacyPolicy => 'privacy policy';

  @override
  String get processingData => 'processing data...';

  @override
  String get professionalSummary => 'professional summary';

  @override
  String get profile => 'profile';

  @override
  String profileSaveError(Object error) {
    return 'failed to save profile: $error';
  }

  @override
  String get profileSavedSuccess =>
      'profile saved! will be used for your next cv.';

  @override
  String get question => 'question';

  @override
  String get readingCV => 'reading cv...';

  @override
  String get readingPDF => 'reading pdf...';

  @override
  String get ready => 'ready!';

  @override
  String get readyToAchieve => 'ready to achieve your career goals?';

  @override
  String get rephrasing => 'rephrasing...';

  @override
  String get requiredField => 'required';

  @override
  String get requiredFieldFriendly => 'this is required!';

  @override
  String get requirementsCheckLabel => 'requirements check:';

  @override
  String get resendEmail => 'resend verification email';

  @override
  String get retry => 'retry';

  @override
  String get reviewData => 'review data';

  @override
  String get reviewedByAI => 'data & summary tailored by ai';

  @override
  String get rewrite => 'rewrite';

  @override
  String get rewriteAI => 'rewrite ai';

  @override
  String get sat => 'sat';

  @override
  String get save => 'save';

  @override
  String get saveAllCaps => 'save';

  @override
  String get saveChangesMessage =>
      'you have unsaved changes. are you sure you want to leave?';

  @override
  String get saveChangesTitle => 'save changes?';

  @override
  String get saveProfile => 'save profile';

  @override
  String get savingProfile => 'saving profile...';

  @override
  String get scanJobPosting => 'scan job posting';

  @override
  String get scanKHS => 'Scan KHS';

  @override
  String get scanKHSTitle => 'Scan Study Result Card (KHS)';

  @override
  String get scanKHSMessage => 'Select a source to extract GPA and subjects';

  @override
  String get scanningKHSBadge => 'scanning khs';

  @override
  String get readingKHS => 'reading khs...';

  @override
  String get extractingGPA => 'extracting gpa & subjects...';

  @override
  String get academicSubjects => 'academic subjects';

  @override
  String get subjectName => 'subject name';

  @override
  String get gradeOptional => 'grade (optional)';

  @override
  String get whatDidYouLearn => 'what did you learn? (optional)';

  @override
  String get noSubjectsAdded => 'no subjects added yet.';

  @override
  String get editSubject => 'edit subject';

  @override
  String get gpaLabel => 'GPA / IPK';

  @override
  String get gpaHint => 'e.g. 3.85';

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
  String get searchJob => 'search for jobs...';

  @override
  String get selectDate => 'select date';

  @override
  String get selectTemplate => 'select template';

  @override
  String get sendFeedback => 'send feedback';

  @override
  String get sendResetLink => 'send reset link';

  @override
  String get sending => 'sending...';

  @override
  String get shortDescription => 'short description';

  @override
  String get signInSubtitle => 'sign in to sync your cvs across devices';

  @override
  String get signUp => 'sign up';

  @override
  String get skillHint => 'ex: flutter, leadership';

  @override
  String get skills => 'skills';

  @override
  String get skillsSubtitle =>
      'list all your skills. ai will highlight the ones that best match the position you are aiming for.';

  @override
  String get skillsTitle => 'what are your skills?';

  @override
  String get skipForNow => 'skip for now';

  @override
  String get skipIntro => 'skip';

  @override
  String get startDate => 'start date';

  @override
  String get startFromScratch => 'start from scratch';

  @override
  String get startFromScratchDesc =>
      'fill in each section manually, step by step.';

  @override
  String get startNow => 'start now';

  @override
  String get statistics => 'statistics';

  @override
  String get stayHere => 'stay here';

  @override
  String get stepCertifications => 'certifications';

  @override
  String get stepEducation => 'education';

  @override
  String get stepExperience => 'experience';

  @override
  String get stepFinish => 'finish';

  @override
  String get stepImportCV => 'quick setup';

  @override
  String get stepPersonalInfo => 'contact info';

  @override
  String get stepSkills => 'skills';

  @override
  String get suggestionsBugs => 'suggestions & bugs';

  @override
  String get summaryEmpty => 'summary cannot be empty';

  @override
  String get summaryHint => 'write a brief professional summary...';

  @override
  String get sun => 'sun';

  @override
  String get syncAnywhere => 'access from any device, auto-sync';

  @override
  String get syncData => 'sync data';

  @override
  String get tailoredDataMessage =>
      'this data has been tailored by ai to be relevant to your target position. please review!';

  @override
  String get takesLessThan3Min => 'takes less than 3 minutes.';

  @override
  String get targetPosition => 'target position';

  @override
  String get technicalDetails => 'technical details';

  @override
  String templateLoadError(Object error) {
    return 'error loading templates: $error';
  }

  @override
  String get termsAgreePrefix => 'by continuing, you agree to our';

  @override
  String get termsAgreeSuffix => '.';

  @override
  String get termsOfService => 'terms of service';

  @override
  String get thankYou => 'thank you!';

  @override
  String get thu => 'thu';

  @override
  String get totalCVs => 'total cvs';

  @override
  String get totalCreditsLabel => 'total credits';

  @override
  String get tue => 'tue';

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
  String get unlockFeatures => 'refill generation credits';

  @override
  String get untilNow => 'until now';

  @override
  String get untitled => 'untitled';

  @override
  String get uploadInstruction => 'tap to upload your professional photo';

  @override
  String get uploadingPhoto => 'uploading photo...';

  @override
  String get usageHistoryComingSoon => 'usage history coming soon';

  @override
  String get userLevelExpert => 'expert career builder';

  @override
  String get userLevelMid => 'mid-level professional';

  @override
  String get userLevelRookie => 'rookie job seeker';

  @override
  String get userNotLoggedIn => 'user not logged in';

  @override
  String get usingMasterPhoto => 'using master profile photo';

  @override
  String get validatingData => 'validating data...';

  @override
  String get validatingLink => 'validating link...';

  @override
  String get verificationEmailSent => 'verification email sent!';

  @override
  String verificationSentTo(String email) {
    return 'a verification link has been sent to $email. please check your inbox and spam folder.';
  }

  @override
  String get verifyYourEmail => 'verify your email';

  @override
  String get viewDrafts => 'view drafts';

  @override
  String get wallet => 'wallet';

  @override
  String get wed => 'wed';

  @override
  String get welcomeBack => 'welcome back';

  @override
  String get welcomeBackSuccess => 'welcome back!';

  @override
  String get whatJobApply => 'what job are you applying for?';

  @override
  String get workExperience => 'work experience';

  @override
  String get writeSomething => 'please write something';

  @override
  String get year => 'year';

  @override
  String get youreAllSet => 'you\'re all set!';

  @override
  String generateCvCost(int cost) {
    return 'generate';
  }

  @override
  String get generateCvFree => 'generate';

  @override
  String get onboardingStartFree => 'get started, it\'s free';

  @override
  String get onboardingFreeLabel => '2 free cvs, no credit card.';

  @override
  String get getCredits => 'get credits';

  @override
  String get benefitRegularTitle => '2 credits for regular templates';

  @override
  String get benefitRegularDesc =>
      'access clean, professional layouts for everyday use';

  @override
  String get benefitPremiumTitle => '4 credits for premium templates';

  @override
  String get benefitPremiumDesc =>
      'unlock exclusive designs that stand out to recruiters';

  @override
  String get benefitSkipAdsTitle => 'skip ads';

  @override
  String get benefitSkipAdsDesc =>
      'enjoy a seamless experience without interruptions';

  @override
  String creditsCount(int count) {
    return '$count credits';
  }

  @override
  String get popularBadge => 'popular';

  @override
  String get securePayment => 'secure payment via google play';

  @override
  String get perCredit => '/credit';

  @override
  String savePercent(int percent) {
    return 'save ~$percent%';
  }

  @override
  String get packageSmall => 'small';

  @override
  String get packageMedium => 'medium';

  @override
  String get packagePro => 'pro';

  @override
  String get noTransactionsYet => 'no transactions yet';

  @override
  String get topUp => 'top up';

  @override
  String get cvExport => 'cv export';

  @override
  String get failedToLoadTransactions => 'failed to load transactions';

  @override
  String freeExportsLeft(Object count) {
    return '$count free exports left';
  }

  @override
  String get transactionHistory => 'transaction history';

  @override
  String get exports => 'exports';

  @override
  String get topUps => 'top ups';

  @override
  String get onboardingTweetHandle1 => '@career_warrior';

  @override
  String get onboardingTweetContent1 =>
      'Spent 5 hours editing my CV layout, only for it to fall apart when saving as PDF. I\'m so done... 😭 #CVRelatable';

  @override
  String get onboardingTweetHandle2 => '@intern_life';

  @override
  String get onboardingTweetContent2 =>
      'Why is \'Updating CV\' the worst part of job hunting? It\'s just tiny changes but I have to copy-paste everything from scratch.';

  @override
  String get onboardingTweetHandle3 => '@stressed_grad';

  @override
  String get onboardingTweetContent3 =>
      'Found a great job post, but looking at my messy CV format gave me a headache. Ended up not applying because I was too tired. Ugh.';

  @override
  String get onboardingBurnoutTitle =>
      'What part makes you burnout most when making a CV?';

  @override
  String get onboardingBurnout1 => 'Copy paste from scratch';

  @override
  String get onboardingBurnout2 => 'Manual keyword analysis';

  @override
  String get onboardingBurnout3 => 'Fixing layout in Canva';

  @override
  String get onboardingTimeSpentTitle =>
      'How much time on average do you need to make a CV?';

  @override
  String get onboardingTime1 => '1 hour';

  @override
  String get onboardingTime2 => '2 hours';

  @override
  String get onboardingTime3 => '1 day';

  @override
  String get onboardingTime4 => '1 week';

  @override
  String get onboardingProcrastinationTitle =>
      'How often do you postpone making a CV because the process is exhausting?';

  @override
  String get onboardingProcrastination1 => 'Always, it\'s so stressful';

  @override
  String get onboardingProcrastination2 => 'Quite often, whenever I apply';

  @override
  String get onboardingProcrastination3 => 'Rarely, but I hate starting it';

  @override
  String get onboardingDiagnosisTitle =>
      'Diagnosis: You\'re Trapped in Routine';

  @override
  String onboardingDiagnosisSub(String time, String burnout) {
    return 'Spending $time purely on $burnout is draining your potential. Clever automates this in seconds, so you can focus on winning.';
  }

  @override
  String get onboardingSocialProof =>
      '1,240+ people are optimizing their CVs right now.';

  @override
  String get onboardingSolutionHeadline => 'Leave it to CleVer.\nIn seconds.';

  @override
  String get onboardingStepWallTitle => 'You are not alone.';

  @override
  String get onboardingStepWallSub => 'Millions feel the same exhaustion.';

  @override
  String get onboardingComparisonTitle =>
      'Achieve 2X more focus and clarity with CleVer';

  @override
  String get onboardingComparisonLabelLeft => 'Without CleVer';

  @override
  String get onboardingComparisonLabelRight => 'With CleVer';

  @override
  String get onboardingComparisonValueLeft => '20%';

  @override
  String get onboardingComparisonValueRight => '2X';

  @override
  String get onboardingComparisonFooter =>
      'CleVer makes it easy and holds you accountable.';

  @override
  String get onboardingViewSolution => 'View Solution';

  @override
  String get showMeTheWay => 'Show Me The Way';

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
  String get feedbackEmailSubject => 'CleVer CV Feedback';

  @override
  String get feedbackEmailBody =>
      'Hi Clever Team,\n\nI have some feedback regarding the app:\n\n';

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
  String get legalInformation => 'legal information';

  @override
  String get privacyPolicyAndTerms => 'privacy policy and terms';

  @override
  String get supportAndLegal => 'support & legal';
}
