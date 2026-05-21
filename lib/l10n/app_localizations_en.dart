// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PhytoGuard';

  @override
  String get appTagline => 'Plant species and disease analysis';

  @override
  String get splashLoading => 'Loading…';

  @override
  String get onboardingTitle1 => 'Smart plant analysis';

  @override
  String get onboardingBody1 =>
      'Use AI to predict plant species first, then disease risk from your photo.';

  @override
  String get onboardingTitle2 => 'Multiple plants';

  @override
  String get onboardingBody2 =>
      'If several plants appear in one frame, mark regions and choose which to analyze.';

  @override
  String get onboardingTitle3 => 'History and guide';

  @override
  String get onboardingBody3 =>
      'Save scans, view summaries, and browse care tips.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Get started';

  @override
  String onboardingStep(int current, int total) {
    return '$current / $total';
  }

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginSubtitle => 'Sign in to your account';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email for a password reset link';

  @override
  String get forgotPasswordCta => 'Send link';

  @override
  String get forgotPasswordSuccess => 'Reset link sent to your email';

  @override
  String get registerTitle => 'Sign up';

  @override
  String get registerSubtitle => 'Create a new account';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get nameLabel => 'Full name';

  @override
  String get loginCta => 'Sign in';

  @override
  String get registerCta => 'Sign up';

  @override
  String get goRegister => 'No account? Register';

  @override
  String get goLogin => 'Already have an account? Sign in';

  @override
  String get logout => 'Log out';

  @override
  String get authOrDivider => 'or';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeGreeting => 'Hello';

  @override
  String get homeQuickScan => 'Quick scan';

  @override
  String get homeQuickScanDesc => 'Add a photo from camera or gallery';

  @override
  String get homeRecent => 'Recent scans';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeStatsTitle => 'Summary';

  @override
  String get homeStatScans => 'Total scans';

  @override
  String get homeStatSpecies => 'Species ID';

  @override
  String get homeStatAlerts => 'Alerts';

  @override
  String get homeSearchHint => 'Search plants, disease, or guide…';

  @override
  String get homeQuickAccessTitle => 'Quick access';

  @override
  String get homeHeroBadge => 'AI';

  @override
  String get homeTipTitle => 'Tip of the day';

  @override
  String get homeTipLoading => 'Preparing your personal tip…';

  @override
  String get homeTipAiBadge => 'AI';

  @override
  String get homeTipBody =>
      'Use soft light so leaf veins are clear; heavy shade lowers confidence scores.';

  @override
  String get homeTipBlight =>
      'For blight risk, water in the morning without wetting leaves; improve airflow.';

  @override
  String homeTipBlightFor(String species) {
    return 'Your $species scans often show blight: water in the morning and improve ventilation.';
  }

  @override
  String get homeTipMold =>
      'For mold, reduce humidity and keep space between leaves.';

  @override
  String homeTipMoldFor(String species) {
    return 'Mold risk for $species: ease off watering, keep leaves dry, and ventilate.';
  }

  @override
  String get homeTipPowderyMildew =>
      'For powdery mildew, avoid evening leaf wetting and thin crowded stems.';

  @override
  String homeTipPowderyMildewFor(String species) {
    return 'Powdery mildew in your $species history: avoid evening wetting and thin dense growth.';
  }

  @override
  String get homeTipRust =>
      'For rust, remove affected leaves and space plants apart.';

  @override
  String homeTipRustFor(String species) {
    return 'Rust alert for $species: remove fallen leaves and give plants more space.';
  }

  @override
  String get homeTipHealthy =>
      'Even healthy plants benefit from a weekly leaf and stem check.';

  @override
  String homeTipHealthyFor(String species) {
    return '$species looks mostly healthy: do a quick leaf and stem check each week.';
  }

  @override
  String get homeTipMixedRisk =>
      'Mixed disease signs—adjust watering, light, and airflow per plant.';

  @override
  String homeTipMixedRiskFor(String species) {
    return 'Mixed risks for $species and others: tune watering and light for each pot separately.';
  }

  @override
  String get homeEmptyTitle => 'No scans yet';

  @override
  String get homeEmptySubtitle =>
      'Add your first photo to start tracking your plants.';

  @override
  String get homeStartScan => 'Start scan';

  @override
  String get moreScreenTitle => 'Explore and manage';

  @override
  String get moreScreenSubtitle => 'Guide, profile, and settings in one place.';

  @override
  String get moreTileGuideDesc => 'Photo and multi-plant tips';

  @override
  String get moreTileProfileDesc => 'Account and display name';

  @override
  String get moreTileSettingsDesc => 'Theme and app preferences';

  @override
  String get moreTileMyPlantsDesc => 'Add plants and track them daily';

  @override
  String get moreTileHealthProgressDesc =>
      'See health and disease trends of your plants';

  @override
  String get moreTileAboutDesc => 'Project and disclaimer';

  @override
  String get navHome => 'Home';

  @override
  String get navScan => 'Scan';

  @override
  String get navHistory => 'History';

  @override
  String get navProgress => 'Progress';

  @override
  String get navMore => 'Menu';

  @override
  String get scanTitle => 'New scan';

  @override
  String get scanPickTitle => 'Image source';

  @override
  String get scanPickCamera => 'Camera';

  @override
  String get scanPickGallery => 'Gallery';

  @override
  String get scanRegionsTitle => 'Plant regions';

  @override
  String get scanRegionsHint =>
      'Drag to add numbered regions when several plants appear in one photo. Each region is analyzed separately.';

  @override
  String get scanRegionsAdd => 'Region';

  @override
  String get scanRegionsClear => 'Clear';

  @override
  String get scanRegionsNext => 'Analyze species';

  @override
  String scanAnalyzingRegion(int current, int total) {
    return 'Analyzing region $current of $total…';
  }

  @override
  String scanAnalyzingRegionSpecies(int current, int total) {
    return 'Region $current / $total — species…';
  }

  @override
  String scanAnalyzingRegionDisease(int current, int total) {
    return 'Region $current / $total — disease…';
  }

  @override
  String get scanSpeciesResultsTitle => 'Species results (per region)';

  @override
  String get scanSpeciesResultsHint =>
      'Each region was analyzed separately. Continue for disease analysis.';

  @override
  String get scanDiseasePending => 'Disease analysis pending';

  @override
  String scanRegionLabel(int index) {
    return 'Region $index';
  }

  @override
  String get scanSummaryMultiHint =>
      'Each region is listed below. Recognized species are saved as separate history entries.';

  @override
  String scanSaveMultiSuccess(int saved) {
    return '$saved plant record(s) added to history.';
  }

  @override
  String scanSaveMultiWithSkipped(int saved, int skipped) {
    return '$saved saved. $skipped region(s) skipped (species not recognized).';
  }

  @override
  String get scanSaveMultiNone =>
      'Nothing saved: plant species was not recognized in any region.';

  @override
  String scanSaveMultiCta(int count) {
    return 'Save savable regions ($count)';
  }

  @override
  String scanRegionNote(int index) {
    return 'Photo region $index';
  }

  @override
  String get scanRegionsSelectPrompt =>
      'Please add or select at least one region.';

  @override
  String get scanSpeciesLoading => 'Predicting plant species…';

  @override
  String get scanSpeciesTitle => 'Species result';

  @override
  String get scanSpeciesConfidence => 'Confidence';

  @override
  String get scanDiseaseLoading => 'Detecting disease…';

  @override
  String get scanDiseaseTitle => 'Disease / overall status';

  @override
  String get scanDiseaseNote =>
      'The model performs a general classification independent of species; results are advisory only.';

  @override
  String get scanUnrecognizedTitle => 'Not recognized';

  @override
  String get scanUnrecognizedBody =>
      'Confidence is low. Try a sharper photo with better lighting and frame a single plant.';

  @override
  String get scanSummaryTitle => 'Summary';

  @override
  String get scanSaveHistory => 'Save to history';

  @override
  String get scanSaveToPlantTitle => 'Save to which plant?';

  @override
  String get scanSavePickPlantSubtitle =>
      'If you have more than one pot of the same species, pick the right plant—or add a new one.';

  @override
  String scanSavePlantLastHealth(int score) {
    return 'Last health score: $score';
  }

  @override
  String get scanSaveNewPlant => 'Save as new plant';

  @override
  String get scanSaveToPlantCta => 'Save plant';

  @override
  String get scanSavedToPlantSuccess => 'Plant saved.';

  @override
  String get scanSavedPhotoFailed =>
      'Scan saved, but the photo could not be uploaded. Check Firebase Storage rules.';

  @override
  String get scanExportPdfCta => 'Share PDF report';

  @override
  String get scanDownloadPdfCta => 'Download PDF report';

  @override
  String get scanPdfDownloadSuccess =>
      'PDF downloaded. Tap the notification to open it.';

  @override
  String get scanPdfDownloadError =>
      'Could not save the PDF. Please try again.';

  @override
  String get pdfDownloadNotificationTitle => 'Download complete';

  @override
  String pdfDownloadNotificationBody(String fileName) {
    return '$fileName downloaded to your device.';
  }

  @override
  String get scanDone => 'Done';

  @override
  String get scanRetry => 'Try again';

  @override
  String get historyTitle => 'Scan history';

  @override
  String get historyHeadline => 'Scan timeline';

  @override
  String get historyDiseaseUnknown => 'Disease unknown';

  @override
  String get historySubtitle =>
      'Scans are grouped by species. Multiple pots of the same type appear under one card.';

  @override
  String historyScanCount(int count) {
    return '$count scans';
  }

  @override
  String get historyEmpty => 'No saved scans yet.';

  @override
  String get historyOpen => 'Details';

  @override
  String get search => 'Search';

  @override
  String get guideTitle => 'Guide';

  @override
  String get guidesHeadline => 'Plant care guide';

  @override
  String get guidesSubtitle =>
      'Every saved scan goes to History. Health progress shows species trends; you can optionally pick a pot when saving.';

  @override
  String get guideSectionApp => 'App sections';

  @override
  String get guideAppTips =>
      'History: all your scans listed by plant species.\n\nHealth progress: 14/30-day chart and scan photos for the species you select.\n\nScan: species first, then disease; results are saved to History automatically. You can pick a pot when saving.';

  @override
  String get guidesEssentialsBadge => 'Essentials';

  @override
  String get guidesAdvancedBadge => 'Advanced';

  @override
  String get guidesLearnMore => 'Learn more';

  @override
  String get guidesSafetyCheckBadge => 'Safety check';

  @override
  String get guidesCheckPlantsCta => 'Check your plant';

  @override
  String get guidesFooterInfo =>
      'After saving, a low health score may schedule follow-up reminders on your device. Manage notifications in Settings.';

  @override
  String get guideSectionPhoto => 'Good photos';

  @override
  String get guidePhotoTips =>
      'Show leaves clearly, avoid deep shade, and frame a single plant when possible.';

  @override
  String get guideSectionMulti => 'Multiple plants';

  @override
  String get guideMultiTips =>
      'Mark a separate region for each plant to reduce mismatches.';

  @override
  String get guideSectionDisease => 'Disease scan';

  @override
  String get guideDiseaseTips =>
      'Keep symptoms clear on leaves; blur lowers confidence. Pick the correct pot when saving to keep records organized.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsHeadline => 'Preferences';

  @override
  String get settingsSubtitle =>
      'Manage language, theme, and notification preferences.';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsAnalysisSection => 'Analysis & data';

  @override
  String get settingsAnalysisBody =>
      'Species and disease detection runs on your device. Your scans and photos are stored securely under your account.';

  @override
  String get settingsShortcutsSection => 'Shortcuts';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAccountSettingsTitle => 'Account settings';

  @override
  String get profilePersonalInfo => 'Personal info';

  @override
  String get profileNotificationSettings => 'Notification settings';

  @override
  String get profilePrivacySecurity => 'Privacy & security';

  @override
  String get profileHelpCenter => 'Help center';

  @override
  String get profilePlantsTracked => 'Saved plants';

  @override
  String get profileScansDone => 'Total scans';

  @override
  String get profileSpeciesCount => 'Species count';

  @override
  String get profileDiseaseCount => 'Disease count';

  @override
  String get profileStatsHint =>
      'Left: recognized plant species count. Right: all scans saved to your account.';

  @override
  String get profileChangePhotoHint => 'Tap to change photo';

  @override
  String get profilePhotoGallery => 'Choose from gallery';

  @override
  String get profilePhotoCamera => 'Camera';

  @override
  String get profilePhotoUploadSuccess => 'Profile photo updated.';

  @override
  String get profilePhotoUploadError => 'Could not upload profile photo.';

  @override
  String get profilePersonalInfoIntro =>
      'Update your name and contact details.';

  @override
  String get profileEmailChangeSection => 'Change email';

  @override
  String get profileEmailChangeHint =>
      'A verification link is sent to your new address. After you confirm it, your sign-in email is updated.';

  @override
  String get profileDisplayNameLabel => 'Full name';

  @override
  String get profileDisplayNameRequired => 'Name is required';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileEmailRequired => 'Email is required';

  @override
  String get profileEmailVerificationSent =>
      'A verification link was sent to your new email. Check your inbox.';

  @override
  String get profileEmailGoogleHint =>
      'You signed in with Google; email comes from your Google account and cannot be changed here.';

  @override
  String get profilePhoneLabel => 'Phone (optional)';

  @override
  String get profileBioLabel => 'About (optional)';

  @override
  String get profileSaveSuccess => 'Profile saved.';

  @override
  String get profileSaveError => 'Could not save. Try again.';

  @override
  String get profileNotificationsIntro =>
      'Follow-ups after saved scans and risk alerts.';

  @override
  String get profileNotificationsDetail =>
      'Notifications are scheduled locally on your device. One follow-up reminder is kept per plant based on your latest scan.';

  @override
  String get profilePrivacyIntro => 'Account security and your data.';

  @override
  String get profileChangePassword => 'Reset password';

  @override
  String profilePasswordResetHint(String email) {
    return 'A password reset link will be sent to $email.';
  }

  @override
  String get profilePasswordResetConfirmTitle => 'Reset password';

  @override
  String profilePasswordResetConfirmBody(String email) {
    return 'Send a password reset link to $email?';
  }

  @override
  String get profilePasswordGoogleHint =>
      'You signed in with Google; reset your password in your Google account security settings.';

  @override
  String profilePrivacyDataNote(String email) {
    return 'Your plant and scan data is linked to $email in Firebase. Photos are stored in secure cloud storage.';
  }

  @override
  String get profileDeleteDataTitle => 'Delete all my data';

  @override
  String get profileDeleteDataBody =>
      'Plants, scans, and profile data will be permanently deleted. This cannot be undone.';

  @override
  String get profileDeleteDataConfirm => 'Delete';

  @override
  String get profileDeleteDataHint =>
      'Your login stays active; only app data is removed.';

  @override
  String get profileDeleteDataError => 'Could not delete data.';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutSubtitle =>
      'Atatürk University Computer Engineering graduation thesis — AI plant recognition and disease detection mobile app';

  @override
  String get aboutPurposeTitle => 'Project goal';

  @override
  String get aboutPurposeBody =>
      'This graduation project delivers PhytoGuard, a cloud-enabled mobile application. Users take or upload leaf photos to identify plant species and assess possible disease status with artificial intelligence. The aim is fast, accessible decision support where expert diagnosis is limited. The system combines species recognition and disease detection in one app and stores scan history for long-term health tracking.';

  @override
  String get aboutFeaturesTitle => 'System components';

  @override
  String get aboutFeaturesBody =>
      'Species model: EfficientNetB3-based ~93-class model (Leafsnap and PlantNet-300K datasets); runs on-device via TensorFlow Lite\nDisease model: Species-independent 5-class general model (healthy, mold, rust, blight, mildew); local TFLite inference\nMobile app: Flutter; multi-region selection, scan history, health charts, PDF reports, notifications\nCloud: Firebase Authentication, Firestore records, and Storage for photo sync\nWorkflow: Species first, then disease; results saved to your account';

  @override
  String get aboutHowItWorksTitle => 'Technical approach';

  @override
  String get aboutHowItWorksBody =>
      'Models were trained in Python with TensorFlow/Keras and converted to TensorFlow Lite for mobile use. In the app you select regions on the photo; species is predicted first, then disease class. Saves are blocked if species is unrecognized; low-confidence disease appears as \"Disease unknown\" in history. Scans can be linked to a plant record. Outputs are informational only—not a substitute for professional diagnosis.';

  @override
  String get aboutThesisTitle => 'Graduation thesis';

  @override
  String get aboutThesisBody =>
      'Thesis title: Artificial Intelligence Supported Plant Recognition and Disease Detection Cloud-Based Mobile Application\n\nAuthor: İpek ÖZSAŞILAR (220707057)\nAdvisor: Assoc. Prof. Dr. Ferhat BOZKURT\nAtatürk University — Faculty of Engineering, Department of Computer Engineering\nComputer Engineering Selected Design Course I — June 2026\n\nThe study integrates image processing, deep learning, mobile development, and cloud computing.';

  @override
  String get aboutDisclaimerTitle => 'Important notice';

  @override
  String get aboutDisclaimerBody =>
      'Results are informational only, not a definitive diagnosis or treatment plan. Consult an agricultural expert for serious plant health issues.';

  @override
  String get aboutVersionLabel => 'Version 1.0.0';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get healthProgressTitle => 'Health progress';

  @override
  String get healthProgressHeadline => 'Trend analysis';

  @override
  String get healthProgressSubtitle =>
      'Pick a species; all scans of that type are analyzed together';

  @override
  String get healthProgressHint =>
      'The same species appears once in the list even if you have many pots. Charts show the overall health trend for that species.';

  @override
  String get healthProgressPickSpeciesTitle => 'Species';

  @override
  String get healthProgressSelectSpecies => 'Select a species';

  @override
  String get healthProgressNoPlants =>
      'No eligible scans yet. Save a scan to history with both species and disease recognized.';

  @override
  String get healthProgressNoChartData =>
      'No eligible scans for this species in the last 14 days.';

  @override
  String healthProgressNoChartDataDays(int days) {
    return 'No eligible scans for this species in the last $days days.';
  }

  @override
  String healthProgressChartTitleDays(int days) {
    return 'Last $days days';
  }

  @override
  String get healthProgressChartDays14 => '14 days';

  @override
  String get healthProgressChartDays30 => '30 days';

  @override
  String get healthProgressSelectPlant => 'Select a plant';

  @override
  String get healthProgressPickPlantTitle => 'Pick a plant';

  @override
  String get healthProgressChartTitle => 'Last 14 days';

  @override
  String get healthProgressPhotoTimelineTitle => 'Scan photos';

  @override
  String get healthProgressPhotoTimelineHint =>
      'Tap photos to compare how the plant looked over time.';

  @override
  String get healthProgressNoPhotoTimeline =>
      'No photos for this plant yet. Select a region when saving a scan.';

  @override
  String get healthProgressLegendHealth => 'Health';

  @override
  String get healthProgressLegendDisease => 'Disease';

  @override
  String get healthProgressPlant1 => 'Monstera';

  @override
  String get healthProgressPlant2 => 'Aloe vera';

  @override
  String get healthProgressPlant3 => 'Rubber plant';

  @override
  String get myPlantsTitle => 'My plants';

  @override
  String get myPlantsHeadline => 'Your collection';

  @override
  String get myPlantsSubtitle =>
      'Each card is one pot. For a second plant of the same species, tap \"Save as new plant\" when saving a scan.';

  @override
  String get myPlantsEmpty =>
      'You haven\'t added any plants yet. Add one to start daily tracking.';

  @override
  String get myPlantsAddTitle => 'Add plant';

  @override
  String get myPlantsNameLabel => 'Plant name';

  @override
  String get myPlantsSpeciesLabel => 'Species label';

  @override
  String get myPlantsDetailTitle => 'Plant tracking';

  @override
  String get myPlantsDetailHeadline => 'Health summary';

  @override
  String get myPlantsDetailSubtitle =>
      'See this plant’s latest health score trend and scan timeline.';

  @override
  String get myPlantsLastScore => 'Last score';

  @override
  String get myPlantsAvgScore => 'Average';

  @override
  String get myPlantsNoScans => 'No scans yet.';

  @override
  String get myPlantsTimelineTitle => 'Scan history';

  @override
  String get myPlantsTimelineEmpty => 'No saved scans for this plant.';

  @override
  String get myPlantsHealthScoreLabel => 'Health score:';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get notificationsSubtitle =>
      'Follow-ups after saved scans and risk alerts';

  @override
  String get notificationFollowUpTitle => 'Time to check your plant';

  @override
  String notificationFollowUpHealthy(String plantName) {
    return '$plantName looked good last time. Scan again within a week.';
  }

  @override
  String notificationFollowUpMild(String plantName) {
    return '$plantName had mild risk. Scan again within 5 days.';
  }

  @override
  String notificationFollowUpMedium(String plantName) {
    return '$plantName had medium risk. Plan a check scan in 3 days.';
  }

  @override
  String notificationFollowUpUrgent(String plantName) {
    return '$plantName showed serious risk. Please scan again as soon as you can.';
  }

  @override
  String get notificationSpeciesTipTitle => 'Plant saved';

  @override
  String notificationSpeciesTipBody(String plantName, String species) {
    return '$plantName ($species) was saved. Check the species guide for watering and light; disease was unclear in this scan.';
  }

  @override
  String notificationFollowUpSpeciesOnly(String plantName, String species) {
    return 'Check $plantName ($species) again within a week with a new photo.';
  }

  @override
  String get scanAlreadySaved => 'Saved';

  @override
  String get scanSavedDoneHint => 'Scan saved. Use retry below for a new scan.';

  @override
  String get notificationRiskTitle => 'Plant risk may be increasing';

  @override
  String get notificationRiskBody =>
      'Risk was detected in the latest scan. Check your plant and review recommendations.';

  @override
  String notificationRiskBodyFor(String plantName) {
    return 'Serious risk for $plantName. Check your plant right away.';
  }

  @override
  String get dataLabel => 'Data and privacy';

  @override
  String get inferenceDiseaseBacterial => 'Bacterial';

  @override
  String get inferenceDiseaseBlight => 'Blight';

  @override
  String get inferenceDiseaseChlorosisYellowing => 'Chlorosis / yellowing';

  @override
  String get inferenceDiseaseHealthy => 'Healthy';

  @override
  String get inferenceDiseaseLeafDamage => 'Leaf damage';

  @override
  String get inferenceDiseaseLeafDisease => 'Leaf disease';

  @override
  String get inferenceDiseaseLeafSpot => 'Leaf spot';

  @override
  String get inferenceDiseaseMold => 'Mold';

  @override
  String get inferenceDiseasePestDamage => 'Pest / physical damage';

  @override
  String get inferenceDiseasePowderyMildew => 'Powdery mildew';

  @override
  String get inferenceDiseaseRot => 'Rot';

  @override
  String get inferenceDiseaseRust => 'Rust';

  @override
  String get inferenceDiseaseScab => 'Scab';

  @override
  String get inferenceDiseaseViral => 'Viral';

  @override
  String get inferenceDiseaseViralMosaic => 'Viral mosaic';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get continueCta => 'Continue';

  @override
  String get detailCta => 'Details';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get errorTitle => 'Error';

  @override
  String get successTitle => 'Success';

  @override
  String get loading => 'Loading…';

  @override
  String get pdfReportTitle => 'Analysis report';

  @override
  String get pdfReportDate => 'Date';

  @override
  String get pdfReportSpecies => 'Species';

  @override
  String get pdfReportSpeciesConfidence => 'Species confidence';

  @override
  String get pdfReportDisease => 'Disease';

  @override
  String get pdfReportDiseaseConfidence => 'Disease confidence';

  @override
  String get pdfReportDisclaimer =>
      'This report is informational and not a definitive diagnosis.';

  @override
  String get emptyState => 'Nothing to show.';

  @override
  String get unknown => 'Unknown';

  @override
  String get placeholderDash => '—';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'Could not connect. Check your internet.';

  @override
  String get errorImagePick => 'Could not pick an image.';

  @override
  String get errorImageDecode => 'Could not process the image.';

  @override
  String get errorCrop => 'Could not crop the selected region.';

  @override
  String get errorInference => 'Prediction service did not respond.';

  @override
  String get errorSpeciesUnknownSave =>
      'Cannot save because plant species is unrecognized. Please try again with a clearer photo.';

  @override
  String get errorAuth => 'Could not verify session.';

  @override
  String get errorGoogleSignIn =>
      'Google sign-in failed. Check network and configuration.';

  @override
  String get errorStorage => 'Could not read or write local storage.';

  @override
  String get errorAuthEmailInUse => 'This email is already registered.';

  @override
  String get errorAuthWeakPassword =>
      'Password is too weak. Choose a stronger one.';

  @override
  String get errorAuthInvalidEmail => 'Invalid email address.';

  @override
  String get errorAuthUserNotFound => 'No user found with this email.';

  @override
  String get errorAuthWrongPassword => 'Incorrect password.';

  @override
  String get errorAuthInvalidCredential => 'Incorrect email or password.';

  @override
  String get errorAuthUserDisabled => 'This account has been disabled.';

  @override
  String get errorAuthTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get errorAuthOperationNotAllowed =>
      'This sign-in method is disabled. Enable it in the Firebase console.';

  @override
  String get errorAuthRequiresRecentLogin =>
      'For security, sign out and sign in again, then change your email.';

  @override
  String get diseaseDetailTitle => 'Disease details';

  @override
  String get diseaseDetailConfidenceLabel => 'Confidence';

  @override
  String get diseaseDetailSectionDescription => 'Description';

  @override
  String get diseaseDetailSectionCauses => 'Why it happens';

  @override
  String get diseaseDetailSectionTreatment => 'How to treat';

  @override
  String get diseaseDetailSectionPrevention => 'Prevention tips';

  @override
  String get diseaseDetailDescriptionGeneric =>
      'Detailed content is not available for this class yet. Results are advisory.';

  @override
  String get diseaseDetailCausesGeneric =>
      'Low light, over/under watering, poor airflow, or pathogens can contribute.';

  @override
  String get diseaseDetailTreatmentGeneric =>
      'Remove affected parts, improve care conditions, and use an appropriate product if needed.';

  @override
  String get diseaseDetailPreventionGeneric =>
      'Regular checks, proper watering, and good airflow reduce risk.';

  @override
  String get diseaseDetailDescriptionHealthy =>
      'No clear disease symptoms are visible; the plant looks generally healthy.';

  @override
  String get diseaseDetailCausesHealthy =>
      'Proper watering, enough light, and stable conditions help plants stay healthy.';

  @override
  String get diseaseDetailTreatmentHealthy =>
      'Keep current care; wipe dust off leaves and monitor regularly.';

  @override
  String get diseaseDetailPreventionHealthy =>
      'Avoid overwatering, keep light consistent, and detect pests early.';

  @override
  String get diseaseDetailDescriptionPowderyMildew =>
      'A fungal disease that appears as a white, powder-like coating on leaves.';

  @override
  String get diseaseDetailCausesPowderyMildew =>
      'High humidity, poor airflow, and temperature swings can trigger it.';

  @override
  String get diseaseDetailTreatmentPowderyMildew =>
      'Prune affected leaves; keep foliage dry and apply fungicide if needed.';

  @override
  String get diseaseDetailPreventionPowderyMildew =>
      'Space plants out, improve ventilation, and water the soil (not leaves).';

  @override
  String get diseaseDetailDescriptionLeafSpot =>
      'Leaf spot shows as brown/black lesions on foliage and may spread.';

  @override
  String get diseaseDetailCausesLeafSpot =>
      'Often fungal or bacterial; prolonged wet leaves increase risk.';

  @override
  String get diseaseDetailTreatmentLeafSpot =>
      'Remove affected leaves; adjust watering and apply appropriate treatment if needed.';

  @override
  String get diseaseDetailPreventionLeafSpot =>
      'Reduce overhead watering, keep leaves dry, and clean regularly.';

  @override
  String get diseaseDetailDescriptionRust =>
      'A fungal disease seen as orange-brown pustules, often on the underside of leaves.';

  @override
  String get diseaseDetailCausesRust =>
      'Humid conditions, poor airflow, and infected material can spread spores.';

  @override
  String get diseaseDetailTreatmentRust =>
      'Remove affected leaves; improve airflow and use fungicide if necessary.';

  @override
  String get diseaseDetailPreventionRust =>
      'Avoid overcrowding, keep foliage dry, and quarantine new plants.';

  @override
  String get diseaseDetailDescriptionBacterial =>
      'Bacterial infections can cause water-soaked spots and fast spreading lesions.';

  @override
  String get diseaseDetailCausesBacterial =>
      'High humidity, wounded tissue, and contaminated tools can increase spread.';

  @override
  String get diseaseDetailTreatmentBacterial =>
      'Remove infected parts with sterile cuts; improve hygiene and consider copper-based products.';

  @override
  String get diseaseDetailPreventionBacterial =>
      'Disinfect tools, avoid wet foliage, and increase air circulation.';

  @override
  String get diseaseDetailDescriptionViral =>
      'Viral diseases may show mosaic patterns, deformities, and stunted growth.';

  @override
  String get diseaseDetailCausesViral =>
      'Pests (e.g., aphids), contaminated material, and contact transmission can spread viruses.';

  @override
  String get diseaseDetailTreatmentViral =>
      'Curative treatment is limited; isolate the plant and control pests.';

  @override
  String get diseaseDetailPreventionViral =>
      'Control pests, quarantine new plants, and use healthy propagation material.';

  @override
  String get diseaseDetailDescriptionBlight =>
      'Blight can cause rapid darkening and tissue dieback on leaves and stems.';

  @override
  String get diseaseDetailCausesBlight =>
      'Moist conditions and pathogen pressure can increase risk.';

  @override
  String get diseaseDetailTreatmentBlight =>
      'Remove affected areas, reduce moisture, and apply an appropriate protective product.';

  @override
  String get diseaseDetailPreventionBlight =>
      'Keep foliage dry, ensure spacing, and water early in the day.';

  @override
  String get diseaseDetailDescriptionMold =>
      'Mold can appear as gray/green growth on plant surfaces.';

  @override
  String get diseaseDetailCausesMold =>
      'Excess humidity, poor ventilation, and organic residue support growth.';

  @override
  String get diseaseDetailTreatmentMold =>
      'Clean affected areas, lower humidity, and use an appropriate product if needed.';

  @override
  String get diseaseDetailPreventionMold =>
      'Improve ventilation, reduce watering, and keep leaves dry.';

  @override
  String get diseaseDetailDescriptionPestDamage =>
      'Pests or physical factors can cause holes, bite marks, and deformities.';

  @override
  String get diseaseDetailCausesPestDamage =>
      'Mites, aphids, caterpillars, or wind/impact damage may be responsible.';

  @override
  String get diseaseDetailTreatmentPestDamage =>
      'Identify the pest, clean leaves, and apply suitable control methods if needed.';

  @override
  String get diseaseDetailPreventionPestDamage =>
      'Inspect regularly, keep plants strong, and quarantine new additions.';

  @override
  String get diseaseDetailDescriptionRot =>
      'Rot can cause softening, darkening, and bad odor in roots or stems.';

  @override
  String get diseaseDetailCausesRot =>
      'Overwatering, poor drainage, and pathogens can lead to rot.';

  @override
  String get diseaseDetailTreatmentRot =>
      'Remove rotten parts, reduce watering, and repot into well-draining soil.';

  @override
  String get diseaseDetailPreventionRot =>
      'Water based on soil dryness and ensure good drainage.';

  @override
  String get speciesDetailTitle => 'Species details';

  @override
  String get speciesDetailConfidenceLabel => 'Confidence';

  @override
  String get speciesDetailCareTitle => 'Care info';

  @override
  String get speciesDetailWateringLabel => 'Watering';

  @override
  String get speciesDetailSunLabel => 'Sunlight';

  @override
  String get speciesDetailSoilLabel => 'Soil';

  @override
  String get speciesDetailWateringValue => 'When soil dries (about 1–2x/week)';

  @override
  String get speciesDetailSunValue => 'Bright, indirect light';

  @override
  String get speciesDetailSoilValue => 'Well-draining mix';

  @override
  String get speciesDetailRiskTitle => 'Risky diseases';

  @override
  String speciesPlantNetUnmapped(String id) {
    return 'Species (ID: $id)';
  }
}
