// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInSubtitle => 'Sign in to sync your CVs across devices';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSubtitle => 'Start your journey to a better career';

  @override
  String get fullName => 'Full Name';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logIn => 'Log In';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get welcomeBackSuccess => 'Welcome back!';

  @override
  String get googleSignInSuccess => 'Signed in with Google!';

  @override
  String googleSignInError(Object error) {
    return 'Google Sign-In failed: $error';
  }

  @override
  String get errorDetailsCopied => 'Error details copied to clipboard';

  @override
  String get technicalDetails => 'TECHNICAL DETAILS';

  @override
  String get goHome => 'Go Home';

  @override
  String get close => 'Close';

  @override
  String get rewrite => 'Rewrite';

  @override
  String get typeHere => 'Type here...';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get header => 'Header';

  @override
  String get locationLabel => 'Location (Search City/Regency)';

  @override
  String get locationHint => 'Ex: Jakarta -> DKI Jakarta, South Jakarta';

  @override
  String get schoolLabel => 'School / University';

  @override
  String get schoolHint => 'Ex: University of Indonesia';

  @override
  String get requiredField => 'Required';

  @override
  String get syncData => 'Sync Data';

  @override
  String get logOut => 'Log Out';

  @override
  String get completeProfileFirst => 'Complete profile first for best results';

  @override
  String get validatingData => 'Validating data...';

  @override
  String get preparingProfile => 'Preparing profile...';

  @override
  String get continuingToForm => 'Continuing to form...';

  @override
  String analyzeProfileError(Object error) {
    return 'Failed to analyze profile: $error';
  }

  @override
  String get fillJobTitle => 'Fill job title first!';

  @override
  String get scanJobPosting => 'Scan Job Posting';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get ocrScanning => 'OCR SCANNING';

  @override
  String get analyzingText => 'Analyzing text...';

  @override
  String get identifyingVacancy => 'Identifying vacancy...';

  @override
  String get organizingData => 'Organizing data...';

  @override
  String get finalizing => 'Finalizing...';

  @override
  String get jobExtractionSuccess => 'Job posting extracted successfully!';

  @override
  String get noTextFound => 'No text found in image';

  @override
  String get jobExtractionFailed => 'Failed to extract job posting';

  @override
  String get targetPosition => 'Target Position';

  @override
  String get continueToReview => 'Continue: Review Data';

  @override
  String get whatJobApply => 'What job are you applying for?';

  @override
  String get aiHelpCreateCV =>
      'AI will help create a CV perfectly tailored for this goal.';

  @override
  String get positionHint => 'Position (Ex: UI Designer)';

  @override
  String get companyHint => 'Company Name (Optional)';

  @override
  String get requiredFieldFriendly => 'This is required!';

  @override
  String get jobDetailLabel => 'Detail / Qualification (Optional)';

  @override
  String get jobDetailHint =>
      'Paste job description, requirements, or qualifications here...';

  @override
  String get reviewedByAI => 'Data & Summary tailored by AI';

  @override
  String get autoFillFromMaster => 'Data auto-filled from your Master Profile';

  @override
  String get jobInputMissing => 'Error: Job Input missing';

  @override
  String generateSummaryFailed(Object error) {
    return 'Failed to generate summary: $error';
  }

  @override
  String get masterProfileUpdated => 'Master Profile updated successfully';

  @override
  String get reviewData => 'Review Data';

  @override
  String get continueChooseTemplate => 'Continue: Choose Template';

  @override
  String get tailoredDataMessage =>
      'This data has been tailored by AI to be relevant to your target position. Please review!';

  @override
  String get personalInfo => 'Contact Information';

  @override
  String get professionalSummary => 'Professional Summary';

  @override
  String get workExperience => 'Work Experience';

  @override
  String get educationHistory => 'Education History';

  @override
  String get certifications => 'Certifications';

  @override
  String get skills => 'Skills';

  @override
  String get summaryHint => 'Write a brief professional summary...';

  @override
  String get summaryEmpty => 'Summary cannot be empty';

  @override
  String get generateWithAI => 'Generate with AI';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get add => 'Add';

  @override
  String get noExperience => 'No work experience yet.';

  @override
  String get present => 'Present';

  @override
  String get schoolName => 'School Name';

  @override
  String get degree => 'Degree / Major';

  @override
  String get degreeHint => 'Bachelor of Computer Science';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get year => 'Year';

  @override
  String get addEducation => 'ADD EDUCATION';

  @override
  String get editEducation => 'EDIT EDUCATION';

  @override
  String get cancelAllCaps => 'CANCEL';

  @override
  String get saveAllCaps => 'SAVE';

  @override
  String get noEducation => 'No education history yet.';

  @override
  String get certificationsLicenses => 'Certifications & Licenses';

  @override
  String get noCertifications => 'No certifications yet.';

  @override
  String get addSkill => 'Add Skill';

  @override
  String get skillHint => 'ex: Flutter, Leadership';

  @override
  String get noSkills => 'No skills yet.';

  @override
  String get thinking => 'Thinking...';

  @override
  String get writing => 'Writing...';

  @override
  String get fillDescriptionFirst =>
      'Please fill in the description first to use AI rewrite!';

  @override
  String get jobTitle => 'Job Title';

  @override
  String get company => 'Company';

  @override
  String get companyPlaceholder => 'Ex: Google';

  @override
  String get selectDate => 'Select Date';

  @override
  String get untilNow => 'Until Now';

  @override
  String get shortDescription => 'Short Description';

  @override
  String get improving => 'Improving...';

  @override
  String get polishing => 'Polishing...';

  @override
  String get rephrasing => 'Rephrasing...';

  @override
  String get rewriteAI => 'Rewrite AI';

  @override
  String get descriptionHint =>
      'Explain your main responsibilities and achievements...';

  @override
  String get addExperience => 'ADD EXPERIENCE';

  @override
  String get editExperienceTitle => 'EDIT EXPERIENCE';

  @override
  String get addCertification => 'Add Certification';

  @override
  String get editCertification => 'Edit Certification';

  @override
  String get certificationName => 'Certification Name';

  @override
  String get issuer => 'Issuer';

  @override
  String get dateLabel => 'Date:';

  @override
  String get myDrafts => 'My Drafts';

  @override
  String get searchJob => 'Search for jobs...';

  @override
  String get noDrafts => 'No drafts yet.';

  @override
  String get noMatchingJobs => 'No matching jobs found.';

  @override
  String get folderEmpty => 'Folder is empty';

  @override
  String get untitled => 'Untitled';

  @override
  String get created => 'Created';

  @override
  String get atsStandard => 'ATS Standard';

  @override
  String get modernProfessional => 'Modern Professional';

  @override
  String get creativeDesign => 'Creative Design';

  @override
  String get aiPowered => 'AI POWERED';

  @override
  String get createProfessionalCV => 'Create a\nProfessional CV.';

  @override
  String get createFirstCV => 'Create Your\nFirst CV.';

  @override
  String get startNow => 'START NOW';

  @override
  String get importCV => 'Import CV';

  @override
  String get viewDrafts => 'View Drafts';

  @override
  String get statistics => 'Statistics';

  @override
  String get createCV => 'Create CV';

  @override
  String get cvImportedSuccess =>
      'CV imported successfully! Let\'s complete your profile.';

  @override
  String get cvDataExists => 'CV data already exists in your profile.';

  @override
  String get loginToSave => 'Login to save your data';

  @override
  String get syncAnywhere => 'Access from any device, auto-sync';

  @override
  String get importFromCV => 'IMPORT FROM CV';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get premiumBadge => 'GET CREDITS';

  @override
  String get unlockFeatures => 'Refill generation credits';

  @override
  String get premiumFeaturesDesc =>
      '• ATS-optimized templates\n• Unlimited CV exports\n• Cloud sync across devices\n• Priority support';

  @override
  String get premiumComingSoon => 'Premium - Coming soon!';

  @override
  String get viewPremiumFeatures => 'View Premium Features';

  @override
  String get complete => 'Complete';

  @override
  String get cvs => 'CVs';

  @override
  String get experience => 'Experience';

  @override
  String cvImportSuccessWithCount(Object eduCount, Object expCount) {
    return 'CV imported successfully!\nAdded: $expCount experience, $eduCount education';
  }

  @override
  String helloName(Object name) {
    return 'Hello, $name';
  }

  @override
  String get userLevelRookie => 'Rookie Job Seeker';

  @override
  String get userLevelMid => 'Mid-Level Professional';

  @override
  String get userLevelExpert => 'Expert Career Builder';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeMessage => 'Start creating your first professional CV now.';

  @override
  String get cvTipsTitle => 'CV Tips';

  @override
  String get cvTipsMessage =>
      'Include numbers in your achievements to make them more attractive to recruiters.';

  @override
  String get justNow => 'Just now';

  @override
  String hoursAgo(Object hours) {
    return '$hours hours ago';
  }

  @override
  String get fillNameError => 'Please fill in your full name first.';

  @override
  String get termsAgreePrefix => 'By tapping \"START NOW\", you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsAgreeSuffix => '.';

  @override
  String get savingProfile => 'Saving Profile...';

  @override
  String get ready => 'Ready!';

  @override
  String get checkingSystem => 'Checking system...';

  @override
  String get validatingLink => 'Validating link...';

  @override
  String get almostThere => 'Almost there...';

  @override
  String get nextStep => 'NEXT STEP';

  @override
  String get back => 'Back';

  @override
  String get youreAllSet => 'YOU\'RE ALL SET!';

  @override
  String get dropYourDetails => 'DROP YOUR DETAILS.';

  @override
  String get onboardingSubtitle =>
      'Fill in data once, generate thousands of CVs without retyping. Save time, focus on \"grinding\".';

  @override
  String get experienceTitle => 'Work Experience';

  @override
  String get experienceSubtitle =>
      'Tell us your experience (work, internship, organization). AI will choose the most relevant ones for your goals.';

  @override
  String get educationTitle => 'Education History';

  @override
  String get educationSubtitle =>
      'Fill in all your education history. AI will choose the most relevant level to put on your CV.';

  @override
  String get certificationTitle => 'Certifications & Licenses';

  @override
  String get certificationSubtitle =>
      'Enter relevant certifications, licenses, or awards. This can be a huge plus.';

  @override
  String get skillsTitle => 'What are your skills?';

  @override
  String get skillsSubtitle =>
      'List all your skills. AI will highlight the ones that best match the position you are aiming for.';

  @override
  String get careerAnalytics => 'Career Analytics';

  @override
  String get activityOverview => 'Activity Overview';

  @override
  String get keyMetrics => 'Key Metrics';

  @override
  String get currentLevel => 'Current Level';

  @override
  String get keepBuilding =>
      'Keep building your profile to reach the next level!';

  @override
  String get onboardingFinalMessage =>
      'Master Profile safe. Now just quickly create your CV.';

  @override
  String get saveChangesTitle => 'Save Changes?';

  @override
  String get saveChangesMessage =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get exitWithoutSaving => 'Exit Without Saving';

  @override
  String get stayHere => 'Stay Here';

  @override
  String importSuccessMessage(
    Object eduCount,
    Object expCount,
    Object skillsCount,
  ) {
    return 'CV imported successfully!\nAdded: $expCount experience, $eduCount education, $skillsCount skills';
  }

  @override
  String get profileSavedSuccess =>
      'Profile Saved! Will be used for your next CV.';

  @override
  String profileSaveError(Object error) {
    return 'Failed to save profile: $error';
  }

  @override
  String get importCVTitle => 'Import CV';

  @override
  String get importCVMessage => 'Choose how to import your CV:';

  @override
  String get pdfFile => 'PDF File';

  @override
  String get importingCVBadge => 'IMPORTING CV';

  @override
  String get readingCV => 'Reading CV...';

  @override
  String get extractingData => 'Extracting data...';

  @override
  String get compilingProfile => 'Compiling profile...';

  @override
  String get readingPDF => 'Reading PDF...';

  @override
  String get noTextFoundInCV => 'No text found in CV';

  @override
  String get importFailedMessage => 'Failed to import CV. Please try again!';

  @override
  String get totalCVs => 'Total CVs';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get howCanWeHelp => 'How can we help you?';

  @override
  String get feedbackSubtitle => 'Share your experience or report an issue.';

  @override
  String get category => 'Category';

  @override
  String get bugReport => 'Bug Report';

  @override
  String get featureRequest => 'Feature Request';

  @override
  String get question => 'Question';

  @override
  String get other => 'Other';

  @override
  String get messageDetail => 'Message / Detail';

  @override
  String get writeSomething => 'Please write something';

  @override
  String get contactOptional => 'Email / WhatsApp (Optional)';

  @override
  String get contactHint => 'So we can get back to you...';

  @override
  String get thankYou => 'Thank You!';

  @override
  String get feedbackThanksMessage =>
      'Your feedback is valuable for CV Master development.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get feedback => 'Feedback';

  @override
  String get suggestionsBugs => 'Suggestions & Bugs';

  @override
  String get frequentQuestions => 'Common Questions';

  @override
  String get faqFreeQuestion => 'Is CV Master free?';

  @override
  String get faqFreeAnswer =>
      'Yes, basic features are free. We might add premium features in the future.';

  @override
  String get faqEditQuestion => 'How to edit profile?';

  @override
  String get faqEditAnswer =>
      'Go to the Profile menu, edit the section you want, and hit save.';

  @override
  String get faqDataQuestion => 'Is my data safe?';

  @override
  String get faqDataAnswer =>
      'Your data is stored locally (Master Profile). Data sent to AI is processed briefly and not stored.';

  @override
  String get faqPdfQuestion => 'Can I export to PDF?';

  @override
  String get faqPdfAnswer =>
      'Sure! After creating your CV, you can Download/Print PDF in the preview.';

  @override
  String get cantOpenEmail => 'Could not open email app.';

  @override
  String get incompleteData => 'Incomplete data. Returned to previous form.';

  @override
  String pdfOpenError(Object error) {
    return 'Failed to open PDF: $error';
  }

  @override
  String pdfGenerateError(Object error) {
    return 'Failed to generate PDF: $error';
  }

  @override
  String templateLoadError(Object error) {
    return 'Error loading templates: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get generatingPdfBadge => 'GENERATING PDF';

  @override
  String get processingData => 'Processing Data...';

  @override
  String get applyingDesign => 'Applying Design...';

  @override
  String get creatingPages => 'Creating Pages...';

  @override
  String get finalizingPdf => 'Finalizing PDF...';

  @override
  String get loadingTemplatesBadge => 'LOADING TEMPLATES';

  @override
  String get fetchingTemplates => 'Fetching Templates...';

  @override
  String get preparingGallery => 'Preparing Gallery...';

  @override
  String get loadingPreview => 'Loading Preview...';

  @override
  String get selectTemplate => 'SELECT TEMPLATE';

  @override
  String get premium => 'PREMIUM';

  @override
  String get exportPdf => 'EXPORT PDF';

  @override
  String get failed => 'Failed';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get unknownErrorDesc =>
      'Something went wrong, but we aren\'t sure what.';

  @override
  String get readyToAchieve => 'Ready to achieve your career goals?';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteMyData => 'Delete My Data';

  @override
  String get deleteAccountQuestion => 'Delete Account?';

  @override
  String get deleteAccountWarning =>
      'This action is irreversible. All your data, including generated CVs and credits, will be permanently deleted.';

  @override
  String get accountDeletedGoodbye => 'Account successfully deleted. Goodbye!';

  @override
  String accountDeleteError(Object error) {
    return 'Failed to delete account: $error';
  }

  @override
  String get keepLocalData => 'Keep my local data (Master Profile)';

  @override
  String get clearLocalData => 'Clear local data as well (Full Reset)';

  @override
  String creditWarning(int count) {
    return 'Warning: You have $count credits remaining. These are non-refundable.';
  }

  @override
  String get confirmDelete => 'Confirm Deletion';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get verifyYourEmail => 'Verify Your Email';

  @override
  String verificationSentTo(String email) {
    return 'A verification link has been sent to $email. Please check your inbox and spam folder.';
  }

  @override
  String get checkSpamFolder =>
      'Can\'t find it? Please check your Spam or Junk folder.';

  @override
  String get iHaveVerified => 'I HAVE VERIFIED';

  @override
  String get resendEmail => 'Resend Verification Email';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get sending => 'Sending...';

  @override
  String get verificationEmailSent => 'Verification email sent!';

  @override
  String get emailVerifiedSuccess => 'Email verified successfully!';

  @override
  String get emailNotVerifiedYet =>
      'Email not verified yet. Please check your inbox.';

  @override
  String get alreadyHaveCV => 'Already have a CV?';

  @override
  String get alreadyHaveCVSubtitle =>
      'Speed things up! Import your existing CV and we\'ll fill everything in for you.';

  @override
  String get importExistingCV => 'Import My CV';

  @override
  String get importExistingCVDesc =>
      'Upload a PDF or take a photo — AI fills in the rest.';

  @override
  String get startFromScratch => 'Start From Scratch';

  @override
  String get startFromScratchDesc =>
      'Fill in each section manually, step by step.';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String stepLabel(Object current, Object label, Object total) {
    return 'Step $current of $total — $label';
  }

  @override
  String get stepPersonalInfo => 'Contact Info';

  @override
  String get stepImportCV => 'Quick Setup';

  @override
  String get stepExperience => 'Experience';

  @override
  String get stepEducation => 'Education';

  @override
  String get stepCertifications => 'Certifications';

  @override
  String get stepSkills => 'Skills';

  @override
  String get stepFinish => 'Finish';

  @override
  String get home => 'Home';

  @override
  String get wallet => 'Wallet';

  @override
  String get profile => 'Profile';

  @override
  String get creditBalance => 'Credit Balance';

  @override
  String get credits => 'credits';

  @override
  String get usageHistoryComingSoon => 'Usage history coming soon';

  @override
  String get myCVs => 'My CVs';

  @override
  String get drafts => 'Drafts';

  @override
  String get generated => 'Generated';

  @override
  String get noCompletedCVs => 'No generated CVs yet';

  @override
  String get generateCVFirst => 'Generate your first CV to see it here';

  @override
  String get openPDF => 'Open PDF';

  @override
  String get newNotification => 'New Notification';

  @override
  String get cvGeneratedSuccess => 'CV Generated Successfully';

  @override
  String cvReadyMessage(Object jobTitle) {
    return 'Your CV for $jobTitle is ready!';
  }

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get forgotPasswordResetMessage =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get notificationNew => 'New Notification';

  @override
  String get notificationChannelCVTitle => 'CV Generation';

  @override
  String get notificationChannelCVDesc =>
      'Notifications for CV generation updates';

  @override
  String get notificationChannelGeneralTitle => 'General Alerts';

  @override
  String get notificationChannelGeneralDesc => 'General app notifications';

  @override
  String get authWallCreateCV => 'Sign in to create your CV';

  @override
  String get authWallCreateCVDesc =>
      'An account is required to create and save your CV';

  @override
  String get authWallBuyCredits => 'Sign in to buy credits';

  @override
  String get authWallBuyCreditsDesc =>
      'An account is required to purchase credits';

  @override
  String get authWallSelectTemplate => 'Sign in to select a template';

  @override
  String get authWallSelectTemplateDesc =>
      'An account is required to choose a template';

  @override
  String get onboardingHeadline1 => 'Still editing your CV at 1AM?';

  @override
  String get onboardingSubtext1 =>
      'Creating a \'universal\' CV doesn\'t work. Editing it manually for every application is exhausting. We get it.';

  @override
  String get onboardingHeadline2 => 'Qualified, but still getting rejected?';

  @override
  String get onboardingSubtext2 =>
      'Your CV might be rejected before a human even sees it. If your format isn\'t ATS-friendly or lacks the exact keywords, the system blocks you.';

  @override
  String get onboardingHeadline3 => 'Don\'t start from zero.';

  @override
  String get onboardingSubtext3 =>
      'Have pieces of your career scattered across old resumes? Upload a PDF, and we\'ll instantly extract and organize your entire history.';

  @override
  String get onboardingHeadline4 => 'Dump everything here.';

  @override
  String get onboardingSubtext4 =>
      'Farmer. Paperboy. Software engineer. Co-founder. Put it all in. We\'ll handle relevance.';

  @override
  String get onboardingHeadline5 => 'Screenshot a job. Let AI do the rest.';

  @override
  String get onboardingSubtext5 =>
      'Found a job poster? Screenshot it. Our AI analyzes the requirements and instantly highlights only your most relevant experience.';

  @override
  String get onboardingHeadline6 => 'One profile. Unlimited tailored CVs.';

  @override
  String get onboardingSubtext6 =>
      'No expensive resume services. No manual redesign. Instantly switch between professional, ATS-optimized templates with generous usage limits.';

  @override
  String get onboardingHeadline7 => 'We want you to try Clever for free.';

  @override
  String get onboardingSubtext7 =>
      'You\'ll never have to write a CV from scratch again. Ready to get hired?';

  @override
  String get takesLessThan3Min => 'Takes less than 3 minutes.';

  @override
  String get skipIntro => 'Skip Intro';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get cvLanguage => 'CV Language';

  @override
  String get previewCV => 'Preview CV';

  @override
  String get previewTemplate => 'Preview Template';

  @override
  String get regenerateSummary => 'Regenerate Summary';

  @override
  String get summaryRegenerating => 'Regenerating summary...';

  @override
  String get photoSupported => 'Supports Photo';

  @override
  String get photoSettings => 'Photo Settings';

  @override
  String get includeProfilePhoto => 'Include Profile Photo';

  @override
  String get uploadingPhoto => 'Uploading photo...';

  @override
  String get uploadInstruction => 'Tap to upload your professional photo';

  @override
  String get usingMasterPhoto => 'Using Master Profile photo';

  @override
  String get photoUpdateSuccess => 'Profile photo updated successfully!';

  @override
  String photoUpdateError(String error) {
    return 'Error uploading photo: $error';
  }

  @override
  String get userNotLoggedIn => 'User not logged in';
}
