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
  String get homeTipBody =>
      'Use soft light so leaf veins are clear; heavy shade lowers confidence scores.';

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
      'If there are multiple plants, tap to add numbered regions; tap a region to select it for analysis.';

  @override
  String get scanRegionsAdd => 'Add region';

  @override
  String get scanRegionsClear => 'Clear';

  @override
  String get scanRegionsNext => 'Continue to species';

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
  String get scanDiseaseLoading => 'Analyzing disease / health…';

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
  String get scanSaveToPlantCta => 'Save to my home plant';

  @override
  String get scanSavedToPlantSuccess => 'Saved to plant tracking.';

  @override
  String get scanExportPdfCta => 'Share PDF report';

  @override
  String get scanDownloadPdfCta => 'Download PDF report';

  @override
  String get scanDone => 'Done';

  @override
  String get scanRetry => 'Try again';

  @override
  String get historyTitle => 'Scan history';

  @override
  String get historyHeadline => 'Scan timeline';

  @override
  String get historySubtitle =>
      'Browse your saved scans day by day, open details, and share PDF reports.';

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
      'Tips for better results: photo quality, multi-plant usage, and disease scan recommendations.';

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
      'Tip: Lighting, sharpness, and framing a single plant affect confidence the most.';

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
      'Symptoms should be visible on the upper leaf surface; blur lowers confidence.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsHeadline => 'Preferences';

  @override
  String get settingsSubtitle =>
      'Manage language, theme, and notification settings.';

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
  String get profilePlantsTracked => 'plants tracked';

  @override
  String get profileScansDone => 'scans';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutBody =>
      'This app was developed for a graduation thesis. Predictions are not medical diagnoses; seek expert advice for severely damaged plants.';

  @override
  String get aboutThesis =>
      'See project documentation for the thesis and TÜBİTAK report.';

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
  String get healthProgressSubtitle => 'Pick a plant and track trends';

  @override
  String get healthProgressHint =>
      'Only plants with past scans where both species and disease were confidently identified are listed.';

  @override
  String get healthProgressNoPlants =>
      'No eligible scans yet. Save a scan to history with both species and disease recognized.';

  @override
  String get healthProgressNoChartData =>
      'No eligible scans for this plant in the last 14 days.';

  @override
  String get healthProgressSelectPlant => 'Select a plant';

  @override
  String get healthProgressPickPlantTitle => 'Pick a plant';

  @override
  String get healthProgressChartTitle => 'Last 14 days';

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
      'Add plants and track health trends with daily scans.';

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
  String get notificationsSubtitle => 'Get watering and risk reminders';

  @override
  String get notificationWateringTitle => 'Care reminder';

  @override
  String get notificationWateringBody =>
      'It might be watering day. Want to check your plant today?';

  @override
  String get notificationRiskTitle => 'Plant risk may be increasing';

  @override
  String get notificationRiskBody =>
      'Risk was detected in the latest scan. Check your plant and review recommendations.';

  @override
  String get dataLabel => 'Data and privacy';

  @override
  String get apiHint => 'Server URL is configured via .env.';

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
