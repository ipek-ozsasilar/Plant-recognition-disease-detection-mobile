import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
    Locale('tr'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'PhytoGuard'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü ve hastalık analizi'**
  String get appTagline;

  /// No description provided for @splashLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor…'**
  String get splashLoading;

  /// No description provided for @onboardingTitle1.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı bitki analizi'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafınızdan önce bitki türünü, ardından hastalık riskini yapay zeka ile tahmin edin.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In tr, this message translates to:
  /// **'Çoklu bitki desteği'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In tr, this message translates to:
  /// **'Aynı karede birden fazla bitki varsa bölgeleri işaretleyin; hangisini analiz edeceğinizi seçin.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş ve rehber'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In tr, this message translates to:
  /// **'Taramalarınızı kaydedin, özet raporları görüntüleyin ve bakım ipuçlarına göz atın.'**
  String get onboardingBody3;

  /// No description provided for @onboardingNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get onboardingStart;

  /// Onboarding adım göstergesi
  ///
  /// In tr, this message translates to:
  /// **'{current} / {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza giriş yapın'**
  String get loginSubtitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama bağlantısı için e-posta adresinizi girin'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordCta.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı gönder'**
  String get forgotPasswordCta;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırlama bağlantısı e-postanıza gönderildi'**
  String get forgotPasswordSuccess;

  /// No description provided for @registerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ol'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni hesap oluşturun'**
  String get registerSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad'**
  String get nameLabel;

  /// No description provided for @loginCta.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get loginCta;

  /// No description provided for @registerCta.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ol'**
  String get registerCta;

  /// No description provided for @goRegister.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız yok mu? Kayıt olun'**
  String get goRegister;

  /// No description provided for @goLogin.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabınız var mı? Giriş yapın'**
  String get goLogin;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get logout;

  /// No description provided for @authOrDivider.
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get authOrDivider;

  /// No description provided for @loginWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile devam et'**
  String get loginWithGoogle;

  /// No description provided for @homeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba'**
  String get homeGreeting;

  /// No description provided for @homeQuickScan.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı tarama'**
  String get homeQuickScan;

  /// No description provided for @homeQuickScanDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kamera veya galeriden fotoğraf yükleyin'**
  String get homeQuickScanDesc;

  /// No description provided for @homeRecent.
  ///
  /// In tr, this message translates to:
  /// **'Son taramalar'**
  String get homeRecent;

  /// No description provided for @homeSeeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get homeSeeAll;

  /// No description provided for @homeStatsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get homeStatsTitle;

  /// No description provided for @homeStatScans.
  ///
  /// In tr, this message translates to:
  /// **'Toplam tarama'**
  String get homeStatScans;

  /// No description provided for @homeStatSpecies.
  ///
  /// In tr, this message translates to:
  /// **'Tür tespiti'**
  String get homeStatSpecies;

  /// No description provided for @homeStatAlerts.
  ///
  /// In tr, this message translates to:
  /// **'Uyarı'**
  String get homeStatAlerts;

  /// No description provided for @homeSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Bitki, hastalık veya rehber ara…'**
  String get homeSearchHint;

  /// No description provided for @homeQuickAccessTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı erişim'**
  String get homeQuickAccessTitle;

  /// No description provided for @homeHeroBadge.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka'**
  String get homeHeroBadge;

  /// No description provided for @homeTipTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günün ipucu'**
  String get homeTipTitle;

  /// No description provided for @homeTipLoading.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel ipucu hazırlanıyor…'**
  String get homeTipLoading;

  /// No description provided for @homeTipAiBadge.
  ///
  /// In tr, this message translates to:
  /// **'AI'**
  String get homeTipAiBadge;

  /// No description provided for @homeTipBody.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak damarları net görünsün diye yumuşak ışık kullanın; gölgede çekim güven skorunu düşürür.'**
  String get homeTipBody;

  /// No description provided for @homeTipBlight.
  ///
  /// In tr, this message translates to:
  /// **'Yanıklık riski olan bitkilerde yaprakları ıslatmadan sabah sulayın; havalandırmayı artırın.'**
  String get homeTipBlight;

  /// No description provided for @homeTipBlightFor.
  ///
  /// In tr, this message translates to:
  /// **'{species} taramalarınızda yanıklık sık görülüyor: yaprakları ıslatmadan sabah sulayın ve havalandırın.'**
  String homeTipBlightFor(String species);

  /// No description provided for @homeTipMold.
  ///
  /// In tr, this message translates to:
  /// **'Küf için nemli havayı azaltın; yaprak aralarında hava dolaşımı bırakın.'**
  String get homeTipMold;

  /// No description provided for @homeTipMoldFor.
  ///
  /// In tr, this message translates to:
  /// **'{species} için küf riski: fazla sulamayı kesin, yaprakları kuru tutun ve havalandırın.'**
  String homeTipMoldFor(String species);

  /// No description provided for @homeTipPowderyMildew.
  ///
  /// In tr, this message translates to:
  /// **'Külleme için yaprakları akşam ıslatmayın; sıkışık dalları budayın.'**
  String get homeTipPowderyMildew;

  /// No description provided for @homeTipPowderyMildewFor.
  ///
  /// In tr, this message translates to:
  /// **'{species} geçmişinizde külleme var: yaprakları akşam ıslatmayın, sık dalları seyreltin.'**
  String homeTipPowderyMildewFor(String species);

  /// No description provided for @homeTipRust.
  ///
  /// In tr, this message translates to:
  /// **'Pas için etkilenen yaprakları toplayıp atın; bitkiler arası mesafeyi açın.'**
  String get homeTipRust;

  /// No description provided for @homeTipRustFor.
  ///
  /// In tr, this message translates to:
  /// **'{species} için pas uyarısı: dökülen yaprakları uzaklaştırın ve bitkileri seyreltin.'**
  String homeTipRustFor(String species);

  /// No description provided for @homeTipHealthy.
  ///
  /// In tr, this message translates to:
  /// **'Sağlıklı görünen bitkilerde de haftada bir yaprak ve gövde kontrolü yapın.'**
  String get homeTipHealthy;

  /// No description provided for @homeTipHealthyFor.
  ///
  /// In tr, this message translates to:
  /// **'{species} genelde sağlıklı: rutin kontrol için haftada bir yaprak ve gövdeye bakın.'**
  String homeTipHealthyFor(String species);

  /// No description provided for @homeTipMixedRisk.
  ///
  /// In tr, this message translates to:
  /// **'Farklı hastalık işaretleri var; sulama, ışık ve havalandırmayı bitki bitki ayırın.'**
  String get homeTipMixedRisk;

  /// No description provided for @homeTipMixedRiskFor.
  ///
  /// In tr, this message translates to:
  /// **'{species} ve diğer bitkilerde karışık risk: her saksı için sulama ve ışığı ayrı ayarlayın.'**
  String homeTipMixedRiskFor(String species);

  /// No description provided for @homeEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz taramanız yok'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İlk fotoğrafınızı ekleyerek bitkilerinizi izlemeye başlayın.'**
  String get homeEmptySubtitle;

  /// No description provided for @homeStartScan.
  ///
  /// In tr, this message translates to:
  /// **'Tarama başlat'**
  String get homeStartScan;

  /// No description provided for @moreScreenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet ve yönet'**
  String get moreScreenTitle;

  /// No description provided for @moreScreenSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rehber, profil ve ayarlar tek yerde.'**
  String get moreScreenSubtitle;

  /// No description provided for @moreTileGuideDesc.
  ///
  /// In tr, this message translates to:
  /// **'Çekim ve çoklu bitki önerileri'**
  String get moreTileGuideDesc;

  /// No description provided for @moreTileProfileDesc.
  ///
  /// In tr, this message translates to:
  /// **'Hesap ve görünen ad'**
  String get moreTileProfileDesc;

  /// No description provided for @moreTileSettingsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Tema ve uygulama tercihleri'**
  String get moreTileSettingsDesc;

  /// No description provided for @moreTileMyPlantsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bitkilerinizi ekleyin ve günlük takip edin'**
  String get moreTileMyPlantsDesc;

  /// No description provided for @moreTileHealthProgressDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bitkilerinizin sağlık ve hastalık trendlerini görün'**
  String get moreTileHealthProgressDesc;

  /// No description provided for @moreTileAboutDesc.
  ///
  /// In tr, this message translates to:
  /// **'Proje tanıtımı ve uyarılar'**
  String get moreTileAboutDesc;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana'**
  String get navHome;

  /// No description provided for @navScan.
  ///
  /// In tr, this message translates to:
  /// **'Tarama'**
  String get navScan;

  /// No description provided for @navHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get navHistory;

  /// No description provided for @navProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get navProgress;

  /// No description provided for @navMore.
  ///
  /// In tr, this message translates to:
  /// **'Menü'**
  String get navMore;

  /// No description provided for @scanTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni tarama'**
  String get scanTitle;

  /// No description provided for @scanPickTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görüntü kaynağı'**
  String get scanPickTitle;

  /// No description provided for @scanPickCamera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get scanPickCamera;

  /// No description provided for @scanPickGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeri'**
  String get scanPickGallery;

  /// No description provided for @scanRegionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki bölgeleri'**
  String get scanRegionsTitle;

  /// No description provided for @scanRegionsHint.
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla bitki varsa sürükleyerek numaralı bölgeler ekleyin. Analizde her bölge ayrı değerlendirilir.'**
  String get scanRegionsHint;

  /// No description provided for @scanRegionsAdd.
  ///
  /// In tr, this message translates to:
  /// **'Bölge'**
  String get scanRegionsAdd;

  /// No description provided for @scanRegionsClear.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get scanRegionsClear;

  /// No description provided for @scanRegionsNext.
  ///
  /// In tr, this message translates to:
  /// **'Tür analizine geç'**
  String get scanRegionsNext;

  /// No description provided for @scanAnalyzingRegion.
  ///
  /// In tr, this message translates to:
  /// **'Bölge {current} / {total} analiz ediliyor…'**
  String scanAnalyzingRegion(int current, int total);

  /// No description provided for @scanAnalyzingRegionSpecies.
  ///
  /// In tr, this message translates to:
  /// **'Bölge {current} / {total} — tür analizi…'**
  String scanAnalyzingRegionSpecies(int current, int total);

  /// No description provided for @scanAnalyzingRegionDisease.
  ///
  /// In tr, this message translates to:
  /// **'Bölge {current} / {total} — hastalık analizi…'**
  String scanAnalyzingRegionDisease(int current, int total);

  /// No description provided for @scanSpeciesResultsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tür sonuçları (bölge bölge)'**
  String get scanSpeciesResultsTitle;

  /// No description provided for @scanSpeciesResultsHint.
  ///
  /// In tr, this message translates to:
  /// **'Her bölge ayrı değerlendirildi. Devam ile hastalık analizi yapılır.'**
  String get scanSpeciesResultsHint;

  /// No description provided for @scanDiseasePending.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık analizi bekleniyor'**
  String get scanDiseasePending;

  /// No description provided for @scanRegionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bölge {index}'**
  String scanRegionLabel(int index);

  /// No description provided for @scanSummaryMultiHint.
  ///
  /// In tr, this message translates to:
  /// **'Her bölge ayrı satırda gösterilir. Türü tanınan bölgeler geçmişe ayrı kayıt olarak yazılır.'**
  String get scanSummaryMultiHint;

  /// No description provided for @scanSaveMultiSuccess.
  ///
  /// In tr, this message translates to:
  /// **'{saved} tarama geçmişe kaydedildi.'**
  String scanSaveMultiSuccess(int saved);

  /// No description provided for @scanSaveMultiWithSkipped.
  ///
  /// In tr, this message translates to:
  /// **'{saved} kayıt eklendi. {skipped} bölge tür tanınmadığı için atlandı.'**
  String scanSaveMultiWithSkipped(int saved, int skipped);

  /// No description provided for @scanSaveMultiNone.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilemedi: tüm bölgelerde bitki türü tanınmadı.'**
  String get scanSaveMultiNone;

  /// No description provided for @scanSaveMultiCta.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilebilir bölgeleri kaydet ({count})'**
  String scanSaveMultiCta(int count);

  /// No description provided for @scanRegionNote.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf bölgesi {index}'**
  String scanRegionNote(int index);

  /// No description provided for @scanRegionsSelectPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen en az bir bölge ekleyin veya seçin.'**
  String get scanRegionsSelectPrompt;

  /// No description provided for @scanSpeciesLoading.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü tahmin ediliyor…'**
  String get scanSpeciesLoading;

  /// No description provided for @scanSpeciesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tür sonucu'**
  String get scanSpeciesTitle;

  /// No description provided for @scanSpeciesConfidence.
  ///
  /// In tr, this message translates to:
  /// **'Güven'**
  String get scanSpeciesConfidence;

  /// No description provided for @scanDiseaseLoading.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık / sağlık durumu analiz ediliyor…'**
  String get scanDiseaseLoading;

  /// No description provided for @scanDiseaseTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık / genel durum'**
  String get scanDiseaseTitle;

  /// No description provided for @scanDiseaseNote.
  ///
  /// In tr, this message translates to:
  /// **'Model türden bağımsız genel sınıflandırma yapar; sonuç öneri niteliğindedir.'**
  String get scanDiseaseNote;

  /// No description provided for @scanUnrecognizedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tanınamadı'**
  String get scanUnrecognizedTitle;

  /// No description provided for @scanUnrecognizedBody.
  ///
  /// In tr, this message translates to:
  /// **'Güven skoru düşük. Daha net, aydınlık bir fotoğraf çekip tek bitkiyi kadraja almaya çalışın.'**
  String get scanUnrecognizedBody;

  /// No description provided for @scanSummaryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özet rapor'**
  String get scanSummaryTitle;

  /// No description provided for @scanSaveHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmişe kaydet'**
  String get scanSaveHistory;

  /// No description provided for @scanSaveToPlantTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hangi bitkiye kaydedilsin?'**
  String get scanSaveToPlantTitle;

  /// No description provided for @scanSavePickPlantSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Aynı türden birden fazla saksınız varsa doğru bitkiyi seçin; yoksa yeni bitki ekleyin.'**
  String get scanSavePickPlantSubtitle;

  /// No description provided for @scanSavePlantLastHealth.
  ///
  /// In tr, this message translates to:
  /// **'Son sağlık skoru: {score}'**
  String scanSavePlantLastHealth(int score);

  /// No description provided for @scanSaveNewPlant.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bitki olarak kaydet'**
  String get scanSaveNewPlant;

  /// No description provided for @scanSaveToPlantCta.
  ///
  /// In tr, this message translates to:
  /// **'Bitkiyi kaydet'**
  String get scanSaveToPlantCta;

  /// No description provided for @scanSavedToPlantSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Tarama geçmişe kaydedildi.'**
  String get scanSavedToPlantSuccess;

  /// No description provided for @scanSavedPhotoFailed.
  ///
  /// In tr, this message translates to:
  /// **'Tarama kaydedildi; fotoğraf yüklenemedi. Firebase Storage kurallarını kontrol edin.'**
  String get scanSavedPhotoFailed;

  /// No description provided for @scanExportPdfCta.
  ///
  /// In tr, this message translates to:
  /// **'PDF raporu paylaş'**
  String get scanExportPdfCta;

  /// No description provided for @scanDownloadPdfCta.
  ///
  /// In tr, this message translates to:
  /// **'PDF raporu indir'**
  String get scanDownloadPdfCta;

  /// No description provided for @scanPdfDownloadSuccess.
  ///
  /// In tr, this message translates to:
  /// **'PDF indirildi. Açmak için bildirime dokunun.'**
  String get scanPdfDownloadSuccess;

  /// No description provided for @scanPdfDownloadError.
  ///
  /// In tr, this message translates to:
  /// **'PDF kaydedilemedi. Lütfen tekrar deneyin.'**
  String get scanPdfDownloadError;

  /// No description provided for @pdfDownloadNotificationTitle.
  ///
  /// In tr, this message translates to:
  /// **'İndirme tamamlandı'**
  String get pdfDownloadNotificationTitle;

  /// No description provided for @pdfDownloadNotificationBody.
  ///
  /// In tr, this message translates to:
  /// **'{fileName} telefona indirildi.'**
  String pdfDownloadNotificationBody(String fileName);

  /// No description provided for @scanDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get scanDone;

  /// No description provided for @scanRetry.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden dene'**
  String get scanRetry;

  /// No description provided for @historyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş taramalar'**
  String get historyTitle;

  /// No description provided for @historyHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Tarama geçmişi'**
  String get historyHeadline;

  /// No description provided for @historySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Taramalar bitki türüne göre gruplanır. Aynı türden kaç saksı olursa olsun tek kartta listelenir.'**
  String get historySubtitle;

  /// No description provided for @historyScanCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} tarama'**
  String historyScanCount(int count);

  /// No description provided for @historyEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıtlı tarama yok.'**
  String get historyEmpty;

  /// No description provided for @historyOpen.
  ///
  /// In tr, this message translates to:
  /// **'Detay'**
  String get historyOpen;

  /// No description provided for @search.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get search;

  /// No description provided for @guideTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rehber'**
  String get guideTitle;

  /// No description provided for @guidesHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Bitki Bakım Rehberi'**
  String get guidesHeadline;

  /// No description provided for @guidesSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydettiğiniz her tarama Geçmiş\'e eklenir. Geçmiş ve Sağlık ilerlemesi bitki türüne göre gruplanır; kayıt sırasında isterseniz hangi saksıya ait olduğunu seçebilirsiniz.'**
  String get guidesSubtitle;

  /// No description provided for @guideSectionApp.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama bölümleri'**
  String get guideSectionApp;

  /// No description provided for @guideAppTips.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş: tüm taramalarınız tür bazında listelenir.\n\nSağlık ilerlemesi: seçtiğiniz tür için son 14/30 gün grafiği ve tarama fotoğrafları.\n\nBitkilerim: kayıt sırasında saksı seçerseniz o bitkinin skoru ve taramaları güncellenir.\n\nTarama: önce tür, sonra hastalık tahmini; sonuç otomatik Geçmiş\'e yazılır.'**
  String get guideAppTips;

  /// No description provided for @guidesEssentialsBadge.
  ///
  /// In tr, this message translates to:
  /// **'Temel'**
  String get guidesEssentialsBadge;

  /// No description provided for @guidesAdvancedBadge.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get guidesAdvancedBadge;

  /// No description provided for @guidesLearnMore.
  ///
  /// In tr, this message translates to:
  /// **'Devamını oku'**
  String get guidesLearnMore;

  /// No description provided for @guidesSafetyCheckBadge.
  ///
  /// In tr, this message translates to:
  /// **'Kontrol listesi'**
  String get guidesSafetyCheckBadge;

  /// No description provided for @guidesCheckPlantsCta.
  ///
  /// In tr, this message translates to:
  /// **'Bitkini kontrol et'**
  String get guidesCheckPlantsCta;

  /// No description provided for @guidesFooterInfo.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt sonrası sağlık skoru düşükse cihazınızda takip hatırlatıcısı planlanabilir. Bildirimleri Ayarlar\'dan yönetin.'**
  String get guidesFooterInfo;

  /// No description provided for @guideSectionPhoto.
  ///
  /// In tr, this message translates to:
  /// **'İyi fotoğraf'**
  String get guideSectionPhoto;

  /// No description provided for @guidePhotoTips.
  ///
  /// In tr, this message translates to:
  /// **'Yaprakları net gösterin, gölgeden kaçının, mümkünse tek bitkiyi kadraja alın.'**
  String get guidePhotoTips;

  /// No description provided for @guideSectionMulti.
  ///
  /// In tr, this message translates to:
  /// **'Çoklu bitki'**
  String get guideSectionMulti;

  /// No description provided for @guideMultiTips.
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla tür varsa her bitki için ayrı bölge işaretleyin; yanlış eşleşmeyi azaltır.'**
  String get guideMultiTips;

  /// No description provided for @guideSectionDisease.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık taraması'**
  String get guideSectionDisease;

  /// No description provided for @guideDiseaseTips.
  ///
  /// In tr, this message translates to:
  /// **'Belirtiler yaprakta net görünmeli; bulanık çekim güven skorunu düşürür. Geçmişe kaydederken doğru saksıyı seçmek Bitkilerim takibini günceller.'**
  String get guideDiseaseTips;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Tercihler'**
  String get settingsHeadline;

  /// No description provided for @settingsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil, tema ve bildirim tercihlerinizi buradan yönetin.'**
  String get settingsSubtitle;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsAnalysisSection.
  ///
  /// In tr, this message translates to:
  /// **'Analiz ve veri'**
  String get settingsAnalysisSection;

  /// No description provided for @settingsAnalysisBody.
  ///
  /// In tr, this message translates to:
  /// **'Tür ve hastalık tahmini cihazınızda çalışır. Taramalarınız ve fotoğraflarınız hesabınıza bağlı olarak güvenli şekilde saklanır.'**
  String get settingsAnalysisBody;

  /// No description provided for @settingsShortcutsSection.
  ///
  /// In tr, this message translates to:
  /// **'Kısayollar'**
  String get settingsShortcutsSection;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileAccountSettingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesap ayarları'**
  String get profileAccountSettingsTitle;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel bilgiler'**
  String get profilePersonalInfo;

  /// No description provided for @profileNotificationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim ayarları'**
  String get profileNotificationSettings;

  /// No description provided for @profilePrivacySecurity.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik ve güvenlik'**
  String get profilePrivacySecurity;

  /// No description provided for @profileHelpCenter.
  ///
  /// In tr, this message translates to:
  /// **'Yardım merkezi'**
  String get profileHelpCenter;

  /// No description provided for @profilePlantsTracked.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı bitki'**
  String get profilePlantsTracked;

  /// No description provided for @profileScansDone.
  ///
  /// In tr, this message translates to:
  /// **'Toplam tarama'**
  String get profileScansDone;

  /// No description provided for @profileStatsHint.
  ///
  /// In tr, this message translates to:
  /// **'Sol: Bitkilerim’de eklediğiniz saksı sayısı. Sağ: hesabınıza kayıtlı tüm tarama sayısı.'**
  String get profileStatsHint;

  /// No description provided for @profileChangePhotoHint.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı değiştirmek için dokunun'**
  String get profileChangePhotoHint;

  /// No description provided for @profilePhotoGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden seç'**
  String get profilePhotoGallery;

  /// No description provided for @profilePhotoCamera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get profilePhotoCamera;

  /// No description provided for @profilePhotoUploadSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Profil fotoğrafı güncellendi.'**
  String get profilePhotoUploadSuccess;

  /// No description provided for @profilePhotoUploadError.
  ///
  /// In tr, this message translates to:
  /// **'Profil fotoğrafı yüklenemedi.'**
  String get profilePhotoUploadError;

  /// No description provided for @profilePersonalInfoIntro.
  ///
  /// In tr, this message translates to:
  /// **'Adınızı ve iletişim bilgilerinizi güncelleyebilirsiniz. E-posta değişikliğinde doğrulama bağlantısı gönderilir.'**
  String get profilePersonalInfoIntro;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad'**
  String get profileDisplayNameLabel;

  /// No description provided for @profileDisplayNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ad gerekli'**
  String get profileDisplayNameRequired;

  /// No description provided for @profileEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get profileEmailLabel;

  /// No description provided for @profileEmailRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta gerekli'**
  String get profileEmailRequired;

  /// No description provided for @profileEmailVerificationSent.
  ///
  /// In tr, this message translates to:
  /// **'Yeni e-posta adresinize doğrulama bağlantısı gönderildi. Gelen kutunuzu kontrol edin.'**
  String get profileEmailVerificationSent;

  /// No description provided for @profileEmailGoogleHint.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş yaptığınız için e-posta Google hesabınızdan gelir; buradan değiştirilemez.'**
  String get profileEmailGoogleHint;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon (isteğe bağlı)'**
  String get profilePhoneLabel;

  /// No description provided for @profileBioLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hakkımda (isteğe bağlı)'**
  String get profileBioLabel;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler kaydedildi.'**
  String get profileSaveSuccess;

  /// No description provided for @profileSaveError.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilemedi. Tekrar deneyin.'**
  String get profileSaveError;

  /// No description provided for @profileNotificationsIntro.
  ///
  /// In tr, this message translates to:
  /// **'Tarama kaydı sonrası takip ve risk uyarıları.'**
  String get profileNotificationsIntro;

  /// No description provided for @profileNotificationsDetail.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler cihazınızda yerel olarak planlanır. Her bitki için en son kayda göre tek bir takip hatırlatması tutulur.'**
  String get profileNotificationsDetail;

  /// No description provided for @profilePrivacyIntro.
  ///
  /// In tr, this message translates to:
  /// **'Hesap güvenliği ve verileriniz.'**
  String get profilePrivacyIntro;

  /// No description provided for @profileChangePassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama'**
  String get profileChangePassword;

  /// No description provided for @profilePrivacyDataNote.
  ///
  /// In tr, this message translates to:
  /// **'Tarama ve bitki verileriniz Firebase üzerinde {email} hesabına bağlıdır. Fotoğraflar güvenli depolamada saklanır.'**
  String profilePrivacyDataNote(String email);

  /// No description provided for @profileDeleteDataTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tüm verilerimi sil'**
  String get profileDeleteDataTitle;

  /// No description provided for @profileDeleteDataBody.
  ///
  /// In tr, this message translates to:
  /// **'Bitkiler, taramalar ve profil bilgileriniz kalıcı olarak silinir. Bu işlem geri alınamaz.'**
  String get profileDeleteDataBody;

  /// No description provided for @profileDeleteDataConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get profileDeleteDataConfirm;

  /// No description provided for @profileDeleteDataHint.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız açık kalır; yalnızca uygulama verileri silinir.'**
  String get profileDeleteDataHint;

  /// No description provided for @profileDeleteDataError.
  ///
  /// In tr, this message translates to:
  /// **'Veriler silinemedi.'**
  String get profileDeleteDataError;

  /// No description provided for @aboutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get aboutTitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü ve hastalık analizi — bitirme tezi mobil uygulaması'**
  String get aboutSubtitle;

  /// No description provided for @aboutPurposeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne işe yarar?'**
  String get aboutPurposeTitle;

  /// No description provided for @aboutPurposeBody.
  ///
  /// In tr, this message translates to:
  /// **'PhytoGuard, bitkilerinizin fotoğrafından yapay zeka destekli tür ve hastalık tahmini sunar. Ev bitkilerinizi veya bahçe bitkilerinizi düzenli taramalarla izleyebilir, geçmiş sonuçlara bakabilir ve sağlık trendini grafiklerle takip edebilirsiniz.'**
  String get aboutPurposeBody;

  /// No description provided for @aboutFeaturesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özellikler'**
  String get aboutFeaturesTitle;

  /// No description provided for @aboutFeaturesBody.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafla tür ve hastalık analizi (tahmin büyük ölçüde cihazınızda çalışır)\nTarama geçmişi; türe göre gruplanmış kayıtlar ve fotoğraflar\nSağlık ilerlemesi: son 14 veya 30 günlük hastalık trendi grafiği\nBitkilerim: saksı bazında kayıt ve tarama bağlama\nHatırlatıcı bildirimler (düşük sağlık skorunda takip)\nPDF analiz raporu indirme ve paylaşma\nRehber, günün ipucu ve çoklu bitki bölge seçimi'**
  String get aboutFeaturesBody;

  /// No description provided for @aboutHowItWorksTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl çalışır?'**
  String get aboutHowItWorksTitle;

  /// No description provided for @aboutHowItWorksBody.
  ///
  /// In tr, this message translates to:
  /// **'Tarama akışında önce bitki türü, ardından hastalık sınıfı değerlendirilir. Kaydettiğiniz her tarama hesabınıza yazılır; isteğe bağlı olarak hangi saksıya ait olduğunu seçebilirsiniz. Veriler Firebase ile güvenli şekilde senkronize edilir; tarama fotoğrafları bulut depolamada saklanır.'**
  String get aboutHowItWorksBody;

  /// No description provided for @aboutThesisTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitirme projesi'**
  String get aboutThesisTitle;

  /// No description provided for @aboutThesisBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulama bir üniversite bitirme tezi çalışması olarak geliştirilmiştir. Makine öğrenmesi modelleri, mobil arayüz ve bulut altyapısı tezin uygulama bileşenlerini oluşturur.'**
  String get aboutThesisBody;

  /// No description provided for @aboutDisclaimerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önemli uyarı'**
  String get aboutDisclaimerTitle;

  /// No description provided for @aboutDisclaimerBody.
  ///
  /// In tr, this message translates to:
  /// **'Sunulan sonuçlar bilgilendirme amaçlıdır; kesin teşhis veya tedavi önerisi değildir. Ciddi bitki hastalığı şüphesinde tarım uzmanı veya bahçıvan desteği alınmalıdır.'**
  String get aboutDisclaimerBody;

  /// No description provided for @aboutVersionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm 1.0.0'**
  String get aboutVersionLabel;

  /// No description provided for @themeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get themeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @languageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get languageSystem;

  /// No description provided for @languageTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @healthProgressTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık ilerlemesi'**
  String get healthProgressTitle;

  /// No description provided for @healthProgressHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Trend analizi'**
  String get healthProgressHeadline;

  /// No description provided for @healthProgressSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü seçin; o türdeki tüm taramalar birlikte analiz edilir'**
  String get healthProgressSubtitle;

  /// No description provided for @healthProgressHint.
  ///
  /// In tr, this message translates to:
  /// **'Aynı türden kaç saksı olursa olsun listede bir kez görünür. Grafik ve fotoğraflar o türün genel sağlık trendini gösterir.'**
  String get healthProgressHint;

  /// No description provided for @healthProgressPickSpeciesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü'**
  String get healthProgressPickSpeciesTitle;

  /// No description provided for @healthProgressSelectSpecies.
  ///
  /// In tr, this message translates to:
  /// **'Bir tür seçin'**
  String get healthProgressSelectSpecies;

  /// No description provided for @healthProgressNoPlants.
  ///
  /// In tr, this message translates to:
  /// **'Henüz uygun tarama yok. Geçmişe hem tür hem hastalık tanınmış bir tarama kaydedin.'**
  String get healthProgressNoPlants;

  /// No description provided for @healthProgressNoChartData.
  ///
  /// In tr, this message translates to:
  /// **'Son 14 günde bu tür için uygun tarama bulunamadı.'**
  String get healthProgressNoChartData;

  /// No description provided for @healthProgressNoChartDataDays.
  ///
  /// In tr, this message translates to:
  /// **'Son {days} günde bu tür için uygun tarama bulunamadı.'**
  String healthProgressNoChartDataDays(int days);

  /// No description provided for @healthProgressChartTitleDays.
  ///
  /// In tr, this message translates to:
  /// **'Son {days} gün'**
  String healthProgressChartTitleDays(int days);

  /// No description provided for @healthProgressChartDays14.
  ///
  /// In tr, this message translates to:
  /// **'14 gün'**
  String get healthProgressChartDays14;

  /// No description provided for @healthProgressChartDays30.
  ///
  /// In tr, this message translates to:
  /// **'30 gün'**
  String get healthProgressChartDays30;

  /// No description provided for @healthProgressSelectPlant.
  ///
  /// In tr, this message translates to:
  /// **'Bir bitki seçin'**
  String get healthProgressSelectPlant;

  /// No description provided for @healthProgressPickPlantTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki seçimi'**
  String get healthProgressPickPlantTitle;

  /// No description provided for @healthProgressChartTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son 14 gün'**
  String get healthProgressChartTitle;

  /// No description provided for @healthProgressPhotoTimelineTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tarama fotoğrafları'**
  String get healthProgressPhotoTimelineTitle;

  /// No description provided for @healthProgressPhotoTimelineHint.
  ///
  /// In tr, this message translates to:
  /// **'Zaman içinde yaprak görünümünü karşılaştırmak için fotoğraflara dokunun.'**
  String get healthProgressPhotoTimelineHint;

  /// No description provided for @healthProgressNoPhotoTimeline.
  ///
  /// In tr, this message translates to:
  /// **'Bu bitki için kayıtlı fotoğraf yok. Yeni taramada bölge seçerek kaydedin.'**
  String get healthProgressNoPhotoTimeline;

  /// No description provided for @healthProgressLegendHealth.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık'**
  String get healthProgressLegendHealth;

  /// No description provided for @healthProgressLegendDisease.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık'**
  String get healthProgressLegendDisease;

  /// No description provided for @healthProgressPlant1.
  ///
  /// In tr, this message translates to:
  /// **'Monstera'**
  String get healthProgressPlant1;

  /// No description provided for @healthProgressPlant2.
  ///
  /// In tr, this message translates to:
  /// **'Aloe vera'**
  String get healthProgressPlant2;

  /// No description provided for @healthProgressPlant3.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk'**
  String get healthProgressPlant3;

  /// No description provided for @myPlantsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitkilerim'**
  String get myPlantsTitle;

  /// No description provided for @myPlantsHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Koleksiyonun'**
  String get myPlantsHeadline;

  /// No description provided for @myPlantsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Her kart bir saksıdır. Aynı türden ikinci bitki için kayıt sırasında \"Yeni bitki olarak kaydet\" seçin.'**
  String get myPlantsSubtitle;

  /// No description provided for @myPlantsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bitki eklemediniz. Yeni bir bitki ekleyerek günlük takibe başlayın.'**
  String get myPlantsEmpty;

  /// No description provided for @myPlantsAddTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki ekle'**
  String get myPlantsAddTitle;

  /// No description provided for @myPlantsNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bitki adı'**
  String get myPlantsNameLabel;

  /// No description provided for @myPlantsSpeciesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tür etiketi'**
  String get myPlantsSpeciesLabel;

  /// No description provided for @myPlantsDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki takibi'**
  String get myPlantsDetailTitle;

  /// No description provided for @myPlantsDetailHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık özeti'**
  String get myPlantsDetailHeadline;

  /// No description provided for @myPlantsDetailSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu bitkinin son taramalarından sağlık skorunu ve zaman çizelgesini görüntüle.'**
  String get myPlantsDetailSubtitle;

  /// No description provided for @myPlantsLastScore.
  ///
  /// In tr, this message translates to:
  /// **'Son skor'**
  String get myPlantsLastScore;

  /// No description provided for @myPlantsAvgScore.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama'**
  String get myPlantsAvgScore;

  /// No description provided for @myPlantsNoScans.
  ///
  /// In tr, this message translates to:
  /// **'Henüz tarama kaydı yok.'**
  String get myPlantsNoScans;

  /// No description provided for @myPlantsTimelineTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş taramalar'**
  String get myPlantsTimelineTitle;

  /// No description provided for @myPlantsTimelineEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu bitki için kayıtlı tarama bulunamadı.'**
  String get myPlantsTimelineEmpty;

  /// No description provided for @myPlantsHealthScoreLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık skoru:'**
  String get myPlantsHealthScoreLabel;

  /// No description provided for @notificationsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notificationsLabel;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tarama kaydı sonrası takip ve risk uyarıları'**
  String get notificationsSubtitle;

  /// No description provided for @notificationFollowUpTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki kontrol zamanı'**
  String get notificationFollowUpTitle;

  /// No description provided for @notificationFollowUpHealthy.
  ///
  /// In tr, this message translates to:
  /// **'{plantName} için son tarama iyiydi. Bir hafta içinde yeni fotoğrafla kontrol edin.'**
  String notificationFollowUpHealthy(String plantName);

  /// No description provided for @notificationFollowUpMild.
  ///
  /// In tr, this message translates to:
  /// **'{plantName} için hafif risk vardı. 5 gün içinde tekrar tarayın.'**
  String notificationFollowUpMild(String plantName);

  /// No description provided for @notificationFollowUpMedium.
  ///
  /// In tr, this message translates to:
  /// **'{plantName} için orta risk kaydı var. 3 gün içinde kontrol taraması yapın.'**
  String notificationFollowUpMedium(String plantName);

  /// No description provided for @notificationFollowUpUrgent.
  ///
  /// In tr, this message translates to:
  /// **'{plantName} ciddi risk göstermişti. Lütfen en kısa sürede tekrar tarayın.'**
  String notificationFollowUpUrgent(String plantName);

  /// No description provided for @notificationSpeciesTipTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki kaydedildi'**
  String get notificationSpeciesTipTitle;

  /// No description provided for @notificationSpeciesTipBody.
  ///
  /// In tr, this message translates to:
  /// **'{plantName} ({species}) kaydedildi. Sulama ve ışık için tür rehberine bakın; hastalık bu taramada net değildi.'**
  String notificationSpeciesTipBody(String plantName, String species);

  /// No description provided for @notificationFollowUpSpeciesOnly.
  ///
  /// In tr, this message translates to:
  /// **'{plantName} ({species}) için bir hafta içinde yeni fotoğrafla kontrol edin.'**
  String notificationFollowUpSpeciesOnly(String plantName, String species);

  /// No description provided for @scanAlreadySaved.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi'**
  String get scanAlreadySaved;

  /// No description provided for @scanSavedDoneHint.
  ///
  /// In tr, this message translates to:
  /// **'Tarama kaydedildi. Yeni tarama için aşağıdan tekrar deneyin.'**
  String get scanSavedDoneHint;

  /// No description provided for @notificationRiskTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki riski artıyor olabilir'**
  String get notificationRiskTitle;

  /// No description provided for @notificationRiskBody.
  ///
  /// In tr, this message translates to:
  /// **'Son taramada risk tespit edildi. Bitkini kontrol edip önerilere göz at.'**
  String get notificationRiskBody;

  /// No description provided for @notificationRiskBodyFor.
  ///
  /// In tr, this message translates to:
  /// **'{plantName} için ciddi risk tespit edildi. Hemen kontrol edin.'**
  String notificationRiskBodyFor(String plantName);

  /// No description provided for @dataLabel.
  ///
  /// In tr, this message translates to:
  /// **'Veri ve gizlilik'**
  String get dataLabel;

  /// No description provided for @inferenceDiseaseBacterial.
  ///
  /// In tr, this message translates to:
  /// **'Bakteriyel'**
  String get inferenceDiseaseBacterial;

  /// No description provided for @inferenceDiseaseBlight.
  ///
  /// In tr, this message translates to:
  /// **'Yanıklık'**
  String get inferenceDiseaseBlight;

  /// No description provided for @inferenceDiseaseChlorosisYellowing.
  ///
  /// In tr, this message translates to:
  /// **'Kloroz / sararma'**
  String get inferenceDiseaseChlorosisYellowing;

  /// No description provided for @inferenceDiseaseHealthy.
  ///
  /// In tr, this message translates to:
  /// **'Sağlıklı'**
  String get inferenceDiseaseHealthy;

  /// No description provided for @inferenceDiseaseLeafDamage.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak hasarı'**
  String get inferenceDiseaseLeafDamage;

  /// No description provided for @inferenceDiseaseLeafDisease.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak hastalığı'**
  String get inferenceDiseaseLeafDisease;

  /// No description provided for @inferenceDiseaseLeafSpot.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak lekesi'**
  String get inferenceDiseaseLeafSpot;

  /// No description provided for @inferenceDiseaseMold.
  ///
  /// In tr, this message translates to:
  /// **'Küf'**
  String get inferenceDiseaseMold;

  /// No description provided for @inferenceDiseasePestDamage.
  ///
  /// In tr, this message translates to:
  /// **'Zararlı / fiziksel hasar'**
  String get inferenceDiseasePestDamage;

  /// No description provided for @inferenceDiseasePowderyMildew.
  ///
  /// In tr, this message translates to:
  /// **'Külleme'**
  String get inferenceDiseasePowderyMildew;

  /// No description provided for @inferenceDiseaseRot.
  ///
  /// In tr, this message translates to:
  /// **'Çürük'**
  String get inferenceDiseaseRot;

  /// No description provided for @inferenceDiseaseRust.
  ///
  /// In tr, this message translates to:
  /// **'Pas'**
  String get inferenceDiseaseRust;

  /// No description provided for @inferenceDiseaseScab.
  ///
  /// In tr, this message translates to:
  /// **'Kabuklanma'**
  String get inferenceDiseaseScab;

  /// No description provided for @inferenceDiseaseViral.
  ///
  /// In tr, this message translates to:
  /// **'Viral'**
  String get inferenceDiseaseViral;

  /// No description provided for @inferenceDiseaseViralMosaic.
  ///
  /// In tr, this message translates to:
  /// **'Viral mozaik'**
  String get inferenceDiseaseViralMosaic;

  /// No description provided for @validationRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunludur.'**
  String get validationRequired;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @continueCta.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get continueCta;

  /// No description provided for @detailCta.
  ///
  /// In tr, this message translates to:
  /// **'Detay'**
  String get detailCta;

  /// No description provided for @back.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get ok;

  /// No description provided for @errorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get errorTitle;

  /// No description provided for @successTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get successTitle;

  /// No description provided for @loading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor…'**
  String get loading;

  /// No description provided for @pdfReportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Analiz raporu'**
  String get pdfReportTitle;

  /// No description provided for @pdfReportDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get pdfReportDate;

  /// No description provided for @pdfReportSpecies.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü'**
  String get pdfReportSpecies;

  /// No description provided for @pdfReportSpeciesConfidence.
  ///
  /// In tr, this message translates to:
  /// **'Tür güven skoru'**
  String get pdfReportSpeciesConfidence;

  /// No description provided for @pdfReportDisease.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık'**
  String get pdfReportDisease;

  /// No description provided for @pdfReportDiseaseConfidence.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık güven skoru'**
  String get pdfReportDiseaseConfidence;

  /// No description provided for @pdfReportDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'Bu rapor bilgilendirme amaçlıdır; kesin teşhis değildir.'**
  String get pdfReportDisclaimer;

  /// No description provided for @emptyState.
  ///
  /// In tr, this message translates to:
  /// **'Gösterilecek kayıt yok.'**
  String get emptyState;

  /// No description provided for @unknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get unknown;

  /// No description provided for @placeholderDash.
  ///
  /// In tr, this message translates to:
  /// **'—'**
  String get placeholderDash;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Ağ bağlantısı kurulamadı. İnternetinizi kontrol edin.'**
  String get errorNetwork;

  /// No description provided for @errorImagePick.
  ///
  /// In tr, this message translates to:
  /// **'Görüntü seçilirken bir sorun oluştu.'**
  String get errorImagePick;

  /// No description provided for @errorImageDecode.
  ///
  /// In tr, this message translates to:
  /// **'Görüntü işlenemedi.'**
  String get errorImageDecode;

  /// No description provided for @errorCrop.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen bölge kırpılamadı.'**
  String get errorCrop;

  /// No description provided for @errorInference.
  ///
  /// In tr, this message translates to:
  /// **'Tahmin servisi yanıt vermedi.'**
  String get errorInference;

  /// No description provided for @errorSpeciesUnknownSave.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü tanınamadığı için kaydedilemiyor. Lütfen daha net bir fotoğraf ile tekrar deneyin.'**
  String get errorSpeciesUnknownSave;

  /// No description provided for @errorAuth.
  ///
  /// In tr, this message translates to:
  /// **'Oturum bilgisi doğrulanamadı.'**
  String get errorAuth;

  /// No description provided for @errorGoogleSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş tamamlanamadı. İnternet ve yapılandırmayı kontrol edin.'**
  String get errorGoogleSignIn;

  /// No description provided for @errorStorage.
  ///
  /// In tr, this message translates to:
  /// **'Yerel kayıt okunamadı veya yazılamadı.'**
  String get errorStorage;

  /// No description provided for @errorAuthEmailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta adresi zaten kayıtlı.'**
  String get errorAuthEmailInUse;

  /// No description provided for @errorAuthWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre çok zayıf. Daha güçlü bir şifre seçin.'**
  String get errorAuthWeakPassword;

  /// No description provided for @errorAuthInvalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz e-posta adresi.'**
  String get errorAuthInvalidEmail;

  /// No description provided for @errorAuthUserNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı kullanıcı bulunamadı.'**
  String get errorAuthUserNotFound;

  /// No description provided for @errorAuthWrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre hatalı.'**
  String get errorAuthWrongPassword;

  /// No description provided for @errorAuthInvalidCredential.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı.'**
  String get errorAuthInvalidCredential;

  /// No description provided for @errorAuthUserDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Bu hesap devre dışı bırakılmış.'**
  String get errorAuthUserDisabled;

  /// No description provided for @errorAuthTooManyRequests.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yapıldı. Lütfen bir süre sonra tekrar deneyin.'**
  String get errorAuthTooManyRequests;

  /// No description provided for @errorAuthOperationNotAllowed.
  ///
  /// In tr, this message translates to:
  /// **'Bu giriş yöntemi şu an kullanılamıyor. Firebase konsolunda etkinleştirin.'**
  String get errorAuthOperationNotAllowed;

  /// No description provided for @errorAuthRequiresRecentLogin.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik için çıkış yapıp tekrar giriş yapın, ardından e-postayı değiştirin.'**
  String get errorAuthRequiresRecentLogin;

  /// No description provided for @diseaseDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık detayları'**
  String get diseaseDetailTitle;

  /// No description provided for @diseaseDetailConfidenceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Güven skoru'**
  String get diseaseDetailConfidenceLabel;

  /// No description provided for @diseaseDetailSectionDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get diseaseDetailSectionDescription;

  /// No description provided for @diseaseDetailSectionCauses.
  ///
  /// In tr, this message translates to:
  /// **'Neden oluşur?'**
  String get diseaseDetailSectionCauses;

  /// No description provided for @diseaseDetailSectionTreatment.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl tedavi edilir?'**
  String get diseaseDetailSectionTreatment;

  /// No description provided for @diseaseDetailSectionPrevention.
  ///
  /// In tr, this message translates to:
  /// **'Önleyici öneriler'**
  String get diseaseDetailSectionPrevention;

  /// No description provided for @diseaseDetailDescriptionGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bu sınıf için henüz detaylı içerik eklenmedi. Sonuçlar öneri niteliğindedir.'**
  String get diseaseDetailDescriptionGeneric;

  /// No description provided for @diseaseDetailCausesGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Yetersiz ışık, yanlış sulama, düşük hava sirkülasyonu veya patojenler etkili olabilir.'**
  String get diseaseDetailCausesGeneric;

  /// No description provided for @diseaseDetailTreatmentGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Enfekte kısımları temizleyin, bakım koşullarını iyileştirin ve gerekiyorsa uygun ürün kullanın.'**
  String get diseaseDetailTreatmentGeneric;

  /// No description provided for @diseaseDetailPreventionGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Düzenli kontrol, uygun sulama ve iyi hava akışı riski azaltır.'**
  String get diseaseDetailPreventionGeneric;

  /// No description provided for @diseaseDetailDescriptionHealthy.
  ///
  /// In tr, this message translates to:
  /// **'Belirgin hastalık belirtisi görünmüyor; bitki genel olarak iyi durumda.'**
  String get diseaseDetailDescriptionHealthy;

  /// No description provided for @diseaseDetailCausesHealthy.
  ///
  /// In tr, this message translates to:
  /// **'Doğru sulama, yeterli ışık ve uygun ortam koşulları bitkinin sağlıklı kalmasına yardımcı olur.'**
  String get diseaseDetailCausesHealthy;

  /// No description provided for @diseaseDetailTreatmentHealthy.
  ///
  /// In tr, this message translates to:
  /// **'Bakımı aynı şekilde sürdürün; yaprakları tozdan arındırın ve düzenli gözlem yapın.'**
  String get diseaseDetailTreatmentHealthy;

  /// No description provided for @diseaseDetailPreventionHealthy.
  ///
  /// In tr, this message translates to:
  /// **'Aşırı sulamadan kaçının, ışık koşullarını sabit tutun ve zararlıları erken tespit edin.'**
  String get diseaseDetailPreventionHealthy;

  /// No description provided for @diseaseDetailDescriptionPowderyMildew.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak yüzeyinde beyaz, pudramsı tabaka ile görülen mantar hastalığıdır.'**
  String get diseaseDetailDescriptionPowderyMildew;

  /// No description provided for @diseaseDetailCausesPowderyMildew.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek nem, zayıf hava akışı ve ani sıcaklık değişimleri tetikleyebilir.'**
  String get diseaseDetailCausesPowderyMildew;

  /// No description provided for @diseaseDetailTreatmentPowderyMildew.
  ///
  /// In tr, this message translates to:
  /// **'Etkilenen yaprakları budayın; yaprakları kuru tutun ve gerekirse mantar ilacı uygulayın.'**
  String get diseaseDetailTreatmentPowderyMildew;

  /// No description provided for @diseaseDetailPreventionPowderyMildew.
  ///
  /// In tr, this message translates to:
  /// **'Bitkiler arası mesafe bırakın, havalandırmayı artırın ve yaprakları ıslatmadan sulayın.'**
  String get diseaseDetailPreventionPowderyMildew;

  /// No description provided for @diseaseDetailDescriptionLeafSpot.
  ///
  /// In tr, this message translates to:
  /// **'Yapraklarda kahverengi/siyah lekeler şeklinde ortaya çıkan enfeksiyon belirtisidir.'**
  String get diseaseDetailDescriptionLeafSpot;

  /// No description provided for @diseaseDetailCausesLeafSpot.
  ///
  /// In tr, this message translates to:
  /// **'Mantar veya bakteri kaynaklı olabilir; yaprakların uzun süre ıslak kalması riski artırır.'**
  String get diseaseDetailCausesLeafSpot;

  /// No description provided for @diseaseDetailTreatmentLeafSpot.
  ///
  /// In tr, this message translates to:
  /// **'Hastalıklı yaprakları alın; sulamayı düzenleyin ve uygun koruyucu/iyileştirici uygulayın.'**
  String get diseaseDetailTreatmentLeafSpot;

  /// No description provided for @diseaseDetailPreventionLeafSpot.
  ///
  /// In tr, this message translates to:
  /// **'Üstten sulamayı azaltın, yaprakları kuru tutun ve düzenli temizlik yapın.'**
  String get diseaseDetailPreventionLeafSpot;

  /// No description provided for @diseaseDetailDescriptionRust.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak altında turuncu-kahverengi püstüllerle görülen mantar hastalığıdır.'**
  String get diseaseDetailDescriptionRust;

  /// No description provided for @diseaseDetailCausesRust.
  ///
  /// In tr, this message translates to:
  /// **'Nemli ortam, zayıf hava akışı ve enfekte bitki materyali yayılımı artırır.'**
  String get diseaseDetailCausesRust;

  /// No description provided for @diseaseDetailTreatmentRust.
  ///
  /// In tr, this message translates to:
  /// **'Etkilenen yaprakları uzaklaştırın; hava akışını artırın ve gerekirse mantar ilacı kullanın.'**
  String get diseaseDetailTreatmentRust;

  /// No description provided for @diseaseDetailPreventionRust.
  ///
  /// In tr, this message translates to:
  /// **'Sıkışık dikimden kaçının, yaprakları kuru tutun ve karantina uygulayın.'**
  String get diseaseDetailPreventionRust;

  /// No description provided for @diseaseDetailDescriptionBacterial.
  ///
  /// In tr, this message translates to:
  /// **'Bakteriyel enfeksiyonlarda su toplamış görünümlü lekeler ve hızlı yayılım görülebilir.'**
  String get diseaseDetailDescriptionBacterial;

  /// No description provided for @diseaseDetailCausesBacterial.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek nem, yaralanmış doku ve kontamine ekipmanlar bulaşı artırabilir.'**
  String get diseaseDetailCausesBacterial;

  /// No description provided for @diseaseDetailTreatmentBacterial.
  ///
  /// In tr, this message translates to:
  /// **'Enfekte kısımları steril kesimle alın; hijyeni artırın ve gerekirse bakır içerikli ürün kullanın.'**
  String get diseaseDetailTreatmentBacterial;

  /// No description provided for @diseaseDetailPreventionBacterial.
  ///
  /// In tr, this message translates to:
  /// **'Aletleri dezenfekte edin, yaprakları ıslatmadan sulayın ve hava sirkülasyonunu güçlendirin.'**
  String get diseaseDetailPreventionBacterial;

  /// No description provided for @diseaseDetailDescriptionViral.
  ///
  /// In tr, this message translates to:
  /// **'Viral hastalıklarda mozaik desen, şekil bozukluğu ve gelişim geriliği görülebilir.'**
  String get diseaseDetailDescriptionViral;

  /// No description provided for @diseaseDetailCausesViral.
  ///
  /// In tr, this message translates to:
  /// **'Zararlılar (ör. yaprak biti), kontamine bitki materyali ve temas bulaşmaya neden olabilir.'**
  String get diseaseDetailCausesViral;

  /// No description provided for @diseaseDetailTreatmentViral.
  ///
  /// In tr, this message translates to:
  /// **'Viral hastalıklar için kesin tedavi sınırlıdır; bitkiyi izole edin ve zararlı kontrolü yapın.'**
  String get diseaseDetailTreatmentViral;

  /// No description provided for @diseaseDetailPreventionViral.
  ///
  /// In tr, this message translates to:
  /// **'Zararlıları kontrol edin, yeni bitkileri karantinaya alın ve sağlıklı fide kullanın.'**
  String get diseaseDetailPreventionViral;

  /// No description provided for @diseaseDetailDescriptionBlight.
  ///
  /// In tr, this message translates to:
  /// **'Yanıklık; yaprak ve gövdede hızla yayılan kararma ve doku ölümüyle ilerleyebilir.'**
  String get diseaseDetailDescriptionBlight;

  /// No description provided for @diseaseDetailCausesBlight.
  ///
  /// In tr, this message translates to:
  /// **'Mantar benzeri patojenler, aşırı nem ve düşük hava akışı riski artırır.'**
  String get diseaseDetailCausesBlight;

  /// No description provided for @diseaseDetailTreatmentBlight.
  ///
  /// In tr, this message translates to:
  /// **'Hastalıklı bölgeleri temizleyin, bitkiyi kurutun ve uygun koruyucu ürün uygulayın.'**
  String get diseaseDetailTreatmentBlight;

  /// No description provided for @diseaseDetailPreventionBlight.
  ///
  /// In tr, this message translates to:
  /// **'Yaprakları kuru tutun, doğru aralıkla dikin ve sulamayı sabah yapın.'**
  String get diseaseDetailPreventionBlight;

  /// No description provided for @diseaseDetailDescriptionMold.
  ///
  /// In tr, this message translates to:
  /// **'Küf; yaprak ve yüzeylerde gri/yeşilimsi tabaka şeklinde oluşabilir.'**
  String get diseaseDetailDescriptionMold;

  /// No description provided for @diseaseDetailCausesMold.
  ///
  /// In tr, this message translates to:
  /// **'Aşırı nem, yetersiz havalandırma ve organik kalıntılar büyümeyi hızlandırır.'**
  String get diseaseDetailCausesMold;

  /// No description provided for @diseaseDetailTreatmentMold.
  ///
  /// In tr, this message translates to:
  /// **'Etkilenen alanı temizleyin, nemi düşürün ve gerekirse uygun ürün uygulayın.'**
  String get diseaseDetailTreatmentMold;

  /// No description provided for @diseaseDetailPreventionMold.
  ///
  /// In tr, this message translates to:
  /// **'Havalandırmayı artırın, sulamayı azaltın ve yaprakları kuru tutun.'**
  String get diseaseDetailPreventionMold;

  /// No description provided for @diseaseDetailDescriptionPestDamage.
  ///
  /// In tr, this message translates to:
  /// **'Zararlılar veya fiziksel etkenler yapraklarda delik, ısırık izi ve deformasyon oluşturabilir.'**
  String get diseaseDetailDescriptionPestDamage;

  /// No description provided for @diseaseDetailCausesPestDamage.
  ///
  /// In tr, this message translates to:
  /// **'Akar, yaprak biti, tırtıl gibi zararlılar veya rüzgar/darbe gibi fiziksel nedenler olabilir.'**
  String get diseaseDetailCausesPestDamage;

  /// No description provided for @diseaseDetailTreatmentPestDamage.
  ///
  /// In tr, this message translates to:
  /// **'Zararlıyı tespit edin, yaprakları temizleyin ve gerekirse uygun biyolojik/kimyasal mücadele uygulayın.'**
  String get diseaseDetailTreatmentPestDamage;

  /// No description provided for @diseaseDetailPreventionPestDamage.
  ///
  /// In tr, this message translates to:
  /// **'Düzenli kontrol yapın, bitkiyi güçlendirin ve yeni bitkileri karantinaya alın.'**
  String get diseaseDetailPreventionPestDamage;

  /// No description provided for @diseaseDetailDescriptionRot.
  ///
  /// In tr, this message translates to:
  /// **'Çürük; kök veya gövdede yumuşama, koyulaşma ve kötü koku ile ilerleyebilir.'**
  String get diseaseDetailDescriptionRot;

  /// No description provided for @diseaseDetailCausesRot.
  ///
  /// In tr, this message translates to:
  /// **'Aşırı sulama, drenaj zayıflığı ve patojenler çürümeyi başlatabilir.'**
  String get diseaseDetailCausesRot;

  /// No description provided for @diseaseDetailTreatmentRot.
  ///
  /// In tr, this message translates to:
  /// **'Çürüyen kısımları temizleyin, sulamayı azaltın ve daha iyi drenajlı toprağa alın.'**
  String get diseaseDetailTreatmentRot;

  /// No description provided for @diseaseDetailPreventionRot.
  ///
  /// In tr, this message translates to:
  /// **'Toprağın kuruma durumuna göre sulayın, saksı drenajını iyileştirin.'**
  String get diseaseDetailPreventionRot;

  /// No description provided for @speciesDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tür detayları'**
  String get speciesDetailTitle;

  /// No description provided for @speciesDetailConfidenceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Güven skoru'**
  String get speciesDetailConfidenceLabel;

  /// No description provided for @speciesDetailCareTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bakım bilgileri'**
  String get speciesDetailCareTitle;

  /// No description provided for @speciesDetailWateringLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sulama'**
  String get speciesDetailWateringLabel;

  /// No description provided for @speciesDetailSunLabel.
  ///
  /// In tr, this message translates to:
  /// **'Güneş'**
  String get speciesDetailSunLabel;

  /// No description provided for @speciesDetailSoilLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toprak'**
  String get speciesDetailSoilLabel;

  /// No description provided for @speciesDetailWateringValue.
  ///
  /// In tr, this message translates to:
  /// **'Toprak kurudukça (ortalama haftada 1–2)'**
  String get speciesDetailWateringValue;

  /// No description provided for @speciesDetailSunValue.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlık, dolaylı ışık'**
  String get speciesDetailSunValue;

  /// No description provided for @speciesDetailSoilValue.
  ///
  /// In tr, this message translates to:
  /// **'İyi drenajlı karışım'**
  String get speciesDetailSoilValue;

  /// No description provided for @speciesDetailRiskTitle.
  ///
  /// In tr, this message translates to:
  /// **'Riskli hastalıklar'**
  String get speciesDetailRiskTitle;

  /// plantnet__… sınıfı için isim haritası yokken; gerçek ad plantnet_species_id_map.json ile eklenir
  ///
  /// In tr, this message translates to:
  /// **'Tür (ID: {id})'**
  String speciesPlantNetUnmapped(String id);
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
