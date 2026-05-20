// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'PhytoGuard';

  @override
  String get appTagline => 'Bitki türü ve hastalık analizi';

  @override
  String get splashLoading => 'Yükleniyor…';

  @override
  String get onboardingTitle1 => 'Akıllı bitki analizi';

  @override
  String get onboardingBody1 =>
      'Fotoğrafınızdan önce bitki türünü, ardından hastalık riskini yapay zeka ile tahmin edin.';

  @override
  String get onboardingTitle2 => 'Çoklu bitki desteği';

  @override
  String get onboardingBody2 =>
      'Aynı karede birden fazla bitki varsa bölgeleri işaretleyin; hangisini analiz edeceğinizi seçin.';

  @override
  String get onboardingTitle3 => 'Geçmiş ve rehber';

  @override
  String get onboardingBody3 =>
      'Taramalarınızı kaydedin, özet raporları görüntüleyin ve bakım ipuçlarına göz atın.';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingStart => 'Başla';

  @override
  String onboardingStep(int current, int total) {
    return '$current / $total';
  }

  @override
  String get loginTitle => 'Hoş geldiniz';

  @override
  String get loginSubtitle => 'Hesabınıza giriş yapın';

  @override
  String get forgotPasswordTitle => 'Şifremi unuttum';

  @override
  String get forgotPasswordSubtitle =>
      'Şifre sıfırlama bağlantısı için e-posta adresinizi girin';

  @override
  String get forgotPasswordCta => 'Bağlantı gönder';

  @override
  String get forgotPasswordSuccess =>
      'Sıfırlama bağlantısı e-postanıza gönderildi';

  @override
  String get registerTitle => 'Kayıt ol';

  @override
  String get registerSubtitle => 'Yeni hesap oluşturun';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get nameLabel => 'Ad soyad';

  @override
  String get loginCta => 'Giriş yap';

  @override
  String get registerCta => 'Kayıt ol';

  @override
  String get goRegister => 'Hesabınız yok mu? Kayıt olun';

  @override
  String get goLogin => 'Zaten hesabınız var mı? Giriş yapın';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get authOrDivider => 'veya';

  @override
  String get loginWithGoogle => 'Google ile devam et';

  @override
  String get homeTitle => 'Ana sayfa';

  @override
  String get homeGreeting => 'Merhaba';

  @override
  String get homeQuickScan => 'Hızlı tarama';

  @override
  String get homeQuickScanDesc => 'Kamera veya galeriden fotoğraf yükleyin';

  @override
  String get homeRecent => 'Son taramalar';

  @override
  String get homeSeeAll => 'Tümü';

  @override
  String get homeStatsTitle => 'Özet';

  @override
  String get homeStatScans => 'Toplam tarama';

  @override
  String get homeStatSpecies => 'Tür tespiti';

  @override
  String get homeStatAlerts => 'Uyarı';

  @override
  String get homeSearchHint => 'Bitki, hastalık veya rehber ara…';

  @override
  String get homeQuickAccessTitle => 'Hızlı erişim';

  @override
  String get homeHeroBadge => 'Yapay zeka';

  @override
  String get homeTipTitle => 'Günün ipucu';

  @override
  String get homeTipLoading => 'Kişisel ipucu hazırlanıyor…';

  @override
  String get homeTipAiBadge => 'AI';

  @override
  String get homeTipBody =>
      'Yaprak damarları net görünsün diye yumuşak ışık kullanın; gölgede çekim güven skorunu düşürür.';

  @override
  String get homeTipBlight =>
      'Yanıklık riski olan bitkilerde yaprakları ıslatmadan sabah sulayın; havalandırmayı artırın.';

  @override
  String homeTipBlightFor(String species) {
    return '$species taramalarınızda yanıklık sık görülüyor: yaprakları ıslatmadan sabah sulayın ve havalandırın.';
  }

  @override
  String get homeTipMold =>
      'Küf için nemli havayı azaltın; yaprak aralarında hava dolaşımı bırakın.';

  @override
  String homeTipMoldFor(String species) {
    return '$species için küf riski: fazla sulamayı kesin, yaprakları kuru tutun ve havalandırın.';
  }

  @override
  String get homeTipPowderyMildew =>
      'Külleme için yaprakları akşam ıslatmayın; sıkışık dalları budayın.';

  @override
  String homeTipPowderyMildewFor(String species) {
    return '$species geçmişinizde külleme var: yaprakları akşam ıslatmayın, sık dalları seyreltin.';
  }

  @override
  String get homeTipRust =>
      'Pas için etkilenen yaprakları toplayıp atın; bitkiler arası mesafeyi açın.';

  @override
  String homeTipRustFor(String species) {
    return '$species için pas uyarısı: dökülen yaprakları uzaklaştırın ve bitkileri seyreltin.';
  }

  @override
  String get homeTipHealthy =>
      'Sağlıklı görünen bitkilerde de haftada bir yaprak ve gövde kontrolü yapın.';

  @override
  String homeTipHealthyFor(String species) {
    return '$species genelde sağlıklı: rutin kontrol için haftada bir yaprak ve gövdeye bakın.';
  }

  @override
  String get homeTipMixedRisk =>
      'Farklı hastalık işaretleri var; sulama, ışık ve havalandırmayı bitki bitki ayırın.';

  @override
  String homeTipMixedRiskFor(String species) {
    return '$species ve diğer bitkilerde karışık risk: her saksı için sulama ve ışığı ayrı ayarlayın.';
  }

  @override
  String get homeEmptyTitle => 'Henüz taramanız yok';

  @override
  String get homeEmptySubtitle =>
      'İlk fotoğrafınızı ekleyerek bitkilerinizi izlemeye başlayın.';

  @override
  String get homeStartScan => 'Tarama başlat';

  @override
  String get moreScreenTitle => 'Keşfet ve yönet';

  @override
  String get moreScreenSubtitle => 'Rehber, profil ve ayarlar tek yerde.';

  @override
  String get moreTileGuideDesc => 'Çekim ve çoklu bitki önerileri';

  @override
  String get moreTileProfileDesc => 'Hesap ve görünen ad';

  @override
  String get moreTileSettingsDesc => 'Tema ve uygulama tercihleri';

  @override
  String get moreTileMyPlantsDesc =>
      'Bitkilerinizi ekleyin ve günlük takip edin';

  @override
  String get moreTileHealthProgressDesc =>
      'Bitkilerinizin sağlık ve hastalık trendlerini görün';

  @override
  String get moreTileAboutDesc => 'Proje tanıtımı ve uyarılar';

  @override
  String get navHome => 'Ana';

  @override
  String get navScan => 'Tarama';

  @override
  String get navHistory => 'Geçmiş';

  @override
  String get navProgress => 'İlerleme';

  @override
  String get navMore => 'Menü';

  @override
  String get scanTitle => 'Yeni tarama';

  @override
  String get scanPickTitle => 'Görüntü kaynağı';

  @override
  String get scanPickCamera => 'Kamera';

  @override
  String get scanPickGallery => 'Galeri';

  @override
  String get scanRegionsTitle => 'Bitki bölgeleri';

  @override
  String get scanRegionsHint =>
      'Birden fazla bitki varsa sürükleyerek numaralı bölgeler ekleyin. Analizde her bölge ayrı değerlendirilir.';

  @override
  String get scanRegionsAdd => 'Bölge';

  @override
  String get scanRegionsClear => 'Temizle';

  @override
  String get scanRegionsNext => 'Tür analizine geç';

  @override
  String scanAnalyzingRegion(int current, int total) {
    return 'Bölge $current / $total analiz ediliyor…';
  }

  @override
  String scanAnalyzingRegionSpecies(int current, int total) {
    return 'Bölge $current / $total — tür analizi…';
  }

  @override
  String scanAnalyzingRegionDisease(int current, int total) {
    return 'Bölge $current / $total — hastalık analizi…';
  }

  @override
  String get scanSpeciesResultsTitle => 'Tür sonuçları (bölge bölge)';

  @override
  String get scanSpeciesResultsHint =>
      'Her bölge ayrı değerlendirildi. Devam ile hastalık analizi yapılır.';

  @override
  String get scanDiseasePending => 'Hastalık analizi bekleniyor';

  @override
  String scanRegionLabel(int index) {
    return 'Bölge $index';
  }

  @override
  String get scanSummaryMultiHint =>
      'Her bölge ayrı satırda gösterilir. Türü tanınan bölgeler geçmişe ayrı kayıt olarak yazılır.';

  @override
  String scanSaveMultiSuccess(int saved) {
    return '$saved tarama geçmişe kaydedildi.';
  }

  @override
  String scanSaveMultiWithSkipped(int saved, int skipped) {
    return '$saved kayıt eklendi. $skipped bölge tür tanınmadığı için atlandı.';
  }

  @override
  String get scanSaveMultiNone =>
      'Kaydedilemedi: tüm bölgelerde bitki türü tanınmadı.';

  @override
  String scanSaveMultiCta(int count) {
    return 'Kaydedilebilir bölgeleri kaydet ($count)';
  }

  @override
  String scanRegionNote(int index) {
    return 'Fotoğraf bölgesi $index';
  }

  @override
  String get scanRegionsSelectPrompt =>
      'Lütfen en az bir bölge ekleyin veya seçin.';

  @override
  String get scanSpeciesLoading => 'Bitki türü tahmin ediliyor…';

  @override
  String get scanSpeciesTitle => 'Tür sonucu';

  @override
  String get scanSpeciesConfidence => 'Güven';

  @override
  String get scanDiseaseLoading => 'Hastalık / sağlık durumu analiz ediliyor…';

  @override
  String get scanDiseaseTitle => 'Hastalık / genel durum';

  @override
  String get scanDiseaseNote =>
      'Model türden bağımsız genel sınıflandırma yapar; sonuç öneri niteliğindedir.';

  @override
  String get scanUnrecognizedTitle => 'Tanınamadı';

  @override
  String get scanUnrecognizedBody =>
      'Güven skoru düşük. Daha net, aydınlık bir fotoğraf çekip tek bitkiyi kadraja almaya çalışın.';

  @override
  String get scanSummaryTitle => 'Özet rapor';

  @override
  String get scanSaveHistory => 'Geçmişe kaydet';

  @override
  String get scanSaveToPlantTitle => 'Hangi bitkiye kaydedilsin?';

  @override
  String get scanSavePickPlantSubtitle =>
      'Aynı türden birden fazla saksınız varsa doğru bitkiyi seçin; yoksa yeni bitki ekleyin.';

  @override
  String scanSavePlantLastHealth(int score) {
    return 'Son sağlık skoru: $score';
  }

  @override
  String get scanSaveNewPlant => 'Yeni bitki olarak kaydet';

  @override
  String get scanSaveToPlantCta => 'Bitkiyi kaydet';

  @override
  String get scanSavedToPlantSuccess => 'Tarama geçmişe kaydedildi.';

  @override
  String get scanSavedPhotoFailed =>
      'Tarama kaydedildi; fotoğraf yüklenemedi. Firebase Storage kurallarını kontrol edin.';

  @override
  String get scanExportPdfCta => 'PDF raporu paylaş';

  @override
  String get scanDownloadPdfCta => 'PDF raporu indir';

  @override
  String get scanPdfDownloadSuccess =>
      'PDF indirildi. Açmak için bildirime dokunun.';

  @override
  String get scanPdfDownloadError =>
      'PDF kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get pdfDownloadNotificationTitle => 'İndirme tamamlandı';

  @override
  String pdfDownloadNotificationBody(String fileName) {
    return '$fileName telefona indirildi.';
  }

  @override
  String get scanDone => 'Tamam';

  @override
  String get scanRetry => 'Yeniden dene';

  @override
  String get historyTitle => 'Geçmiş taramalar';

  @override
  String get historyHeadline => 'Tarama geçmişi';

  @override
  String get historySubtitle =>
      'Taramalar bitki türüne göre gruplanır. Aynı türden kaç saksı olursa olsun tek kartta listelenir.';

  @override
  String historyScanCount(int count) {
    return '$count tarama';
  }

  @override
  String get historyEmpty => 'Henüz kayıtlı tarama yok.';

  @override
  String get historyOpen => 'Detay';

  @override
  String get search => 'Ara';

  @override
  String get guideTitle => 'Rehber';

  @override
  String get guidesHeadline => 'Bitki Bakım Rehberi';

  @override
  String get guidesSubtitle =>
      'Kaydettiğiniz her tarama Geçmiş\'e eklenir. Geçmiş ve Sağlık ilerlemesi bitki türüne göre gruplanır; kayıt sırasında isterseniz hangi saksıya ait olduğunu seçebilirsiniz.';

  @override
  String get guideSectionApp => 'Uygulama bölümleri';

  @override
  String get guideAppTips =>
      'Geçmiş: tüm taramalarınız tür bazında listelenir.\n\nSağlık ilerlemesi: seçtiğiniz tür için son 14/30 gün grafiği ve tarama fotoğrafları.\n\nBitkilerim: kayıt sırasında saksı seçerseniz o bitkinin skoru ve taramaları güncellenir.\n\nTarama: önce tür, sonra hastalık tahmini; sonuç otomatik Geçmiş\'e yazılır.';

  @override
  String get guidesEssentialsBadge => 'Temel';

  @override
  String get guidesAdvancedBadge => 'İleri';

  @override
  String get guidesLearnMore => 'Devamını oku';

  @override
  String get guidesSafetyCheckBadge => 'Kontrol listesi';

  @override
  String get guidesCheckPlantsCta => 'Bitkini kontrol et';

  @override
  String get guidesFooterInfo =>
      'Kayıt sonrası sağlık skoru düşükse cihazınızda takip hatırlatıcısı planlanabilir. Bildirimleri Ayarlar\'dan yönetin.';

  @override
  String get guideSectionPhoto => 'İyi fotoğraf';

  @override
  String get guidePhotoTips =>
      'Yaprakları net gösterin, gölgeden kaçının, mümkünse tek bitkiyi kadraja alın.';

  @override
  String get guideSectionMulti => 'Çoklu bitki';

  @override
  String get guideMultiTips =>
      'Birden fazla tür varsa her bitki için ayrı bölge işaretleyin; yanlış eşleşmeyi azaltır.';

  @override
  String get guideSectionDisease => 'Hastalık taraması';

  @override
  String get guideDiseaseTips =>
      'Belirtiler yaprakta net görünmeli; bulanık çekim güven skorunu düşürür. Geçmişe kaydederken doğru saksıyı seçmek Bitkilerim takibini günceller.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsHeadline => 'Tercihler';

  @override
  String get settingsSubtitle =>
      'Dil, tema ve bildirim tercihlerinizi buradan yönetin.';

  @override
  String get settingsNotificationsSection => 'Bildirimler';

  @override
  String get settingsAnalysisSection => 'Analiz ve veri';

  @override
  String get settingsAnalysisBody =>
      'Tür ve hastalık tahmini cihazınızda çalışır. Taramalarınız ve fotoğraflarınız hesabınıza bağlı olarak güvenli şekilde saklanır.';

  @override
  String get settingsShortcutsSection => 'Kısayollar';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileAccountSettingsTitle => 'Hesap ayarları';

  @override
  String get profilePersonalInfo => 'Kişisel bilgiler';

  @override
  String get profileNotificationSettings => 'Bildirim ayarları';

  @override
  String get profilePrivacySecurity => 'Gizlilik ve güvenlik';

  @override
  String get profileHelpCenter => 'Yardım merkezi';

  @override
  String get profilePlantsTracked => 'Kayıtlı bitki';

  @override
  String get profileScansDone => 'Toplam tarama';

  @override
  String get profileStatsHint =>
      'Sol: Bitkilerim’de eklediğiniz saksı sayısı. Sağ: hesabınıza kayıtlı tüm tarama sayısı.';

  @override
  String get profileChangePhotoHint => 'Fotoğrafı değiştirmek için dokunun';

  @override
  String get profilePhotoGallery => 'Galeriden seç';

  @override
  String get profilePhotoCamera => 'Kamera';

  @override
  String get profilePhotoUploadSuccess => 'Profil fotoğrafı güncellendi.';

  @override
  String get profilePhotoUploadError => 'Profil fotoğrafı yüklenemedi.';

  @override
  String get profilePersonalInfoIntro =>
      'Adınızı ve iletişim bilgilerinizi güncelleyebilirsiniz. E-posta değişikliğinde doğrulama bağlantısı gönderilir.';

  @override
  String get profileDisplayNameLabel => 'Ad soyad';

  @override
  String get profileDisplayNameRequired => 'Ad gerekli';

  @override
  String get profileEmailLabel => 'E-posta';

  @override
  String get profileEmailRequired => 'E-posta gerekli';

  @override
  String get profileEmailVerificationSent =>
      'Yeni e-posta adresinize doğrulama bağlantısı gönderildi. Gelen kutunuzu kontrol edin.';

  @override
  String get profileEmailGoogleHint =>
      'Google ile giriş yaptığınız için e-posta Google hesabınızdan gelir; buradan değiştirilemez.';

  @override
  String get profilePhoneLabel => 'Telefon (isteğe bağlı)';

  @override
  String get profileBioLabel => 'Hakkımda (isteğe bağlı)';

  @override
  String get profileSaveSuccess => 'Bilgiler kaydedildi.';

  @override
  String get profileSaveError => 'Kaydedilemedi. Tekrar deneyin.';

  @override
  String get profileNotificationsIntro =>
      'Tarama kaydı sonrası takip ve risk uyarıları.';

  @override
  String get profileNotificationsDetail =>
      'Bildirimler cihazınızda yerel olarak planlanır. Her bitki için en son kayda göre tek bir takip hatırlatması tutulur.';

  @override
  String get profilePrivacyIntro => 'Hesap güvenliği ve verileriniz.';

  @override
  String get profileChangePassword => 'Şifre sıfırlama';

  @override
  String profilePrivacyDataNote(String email) {
    return 'Tarama ve bitki verileriniz Firebase üzerinde $email hesabına bağlıdır. Fotoğraflar güvenli depolamada saklanır.';
  }

  @override
  String get profileDeleteDataTitle => 'Tüm verilerimi sil';

  @override
  String get profileDeleteDataBody =>
      'Bitkiler, taramalar ve profil bilgileriniz kalıcı olarak silinir. Bu işlem geri alınamaz.';

  @override
  String get profileDeleteDataConfirm => 'Sil';

  @override
  String get profileDeleteDataHint =>
      'Hesabınız açık kalır; yalnızca uygulama verileri silinir.';

  @override
  String get profileDeleteDataError => 'Veriler silinemedi.';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String get aboutSubtitle =>
      'Bitki türü ve hastalık analizi — bitirme tezi mobil uygulaması';

  @override
  String get aboutPurposeTitle => 'Ne işe yarar?';

  @override
  String get aboutPurposeBody =>
      'PhytoGuard, bitkilerinizin fotoğrafından yapay zeka destekli tür ve hastalık tahmini sunar. Ev bitkilerinizi veya bahçe bitkilerinizi düzenli taramalarla izleyebilir, geçmiş sonuçlara bakabilir ve sağlık trendini grafiklerle takip edebilirsiniz.';

  @override
  String get aboutFeaturesTitle => 'Özellikler';

  @override
  String get aboutFeaturesBody =>
      'Fotoğrafla tür ve hastalık analizi (tahmin büyük ölçüde cihazınızda çalışır)\nTarama geçmişi; türe göre gruplanmış kayıtlar ve fotoğraflar\nSağlık ilerlemesi: son 14 veya 30 günlük hastalık trendi grafiği\nBitkilerim: saksı bazında kayıt ve tarama bağlama\nHatırlatıcı bildirimler (düşük sağlık skorunda takip)\nPDF analiz raporu indirme ve paylaşma\nRehber, günün ipucu ve çoklu bitki bölge seçimi';

  @override
  String get aboutHowItWorksTitle => 'Nasıl çalışır?';

  @override
  String get aboutHowItWorksBody =>
      'Tarama akışında önce bitki türü, ardından hastalık sınıfı değerlendirilir. Kaydettiğiniz her tarama hesabınıza yazılır; isteğe bağlı olarak hangi saksıya ait olduğunu seçebilirsiniz. Veriler Firebase ile güvenli şekilde senkronize edilir; tarama fotoğrafları bulut depolamada saklanır.';

  @override
  String get aboutThesisTitle => 'Bitirme projesi';

  @override
  String get aboutThesisBody =>
      'Bu uygulama bir üniversite bitirme tezi çalışması olarak geliştirilmiştir. Makine öğrenmesi modelleri, mobil arayüz ve bulut altyapısı tezin uygulama bileşenlerini oluşturur.';

  @override
  String get aboutDisclaimerTitle => 'Önemli uyarı';

  @override
  String get aboutDisclaimerBody =>
      'Sunulan sonuçlar bilgilendirme amaçlıdır; kesin teşhis veya tedavi önerisi değildir. Ciddi bitki hastalığı şüphesinde tarım uzmanı veya bahçıvan desteği alınmalıdır.';

  @override
  String get aboutVersionLabel => 'Sürüm 1.0.0';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get languageLabel => 'Dil';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get healthProgressTitle => 'Sağlık ilerlemesi';

  @override
  String get healthProgressHeadline => 'Trend analizi';

  @override
  String get healthProgressSubtitle =>
      'Bitki türü seçin; o türdeki tüm taramalar birlikte analiz edilir';

  @override
  String get healthProgressHint =>
      'Aynı türden kaç saksı olursa olsun listede bir kez görünür. Grafik ve fotoğraflar o türün genel sağlık trendini gösterir.';

  @override
  String get healthProgressPickSpeciesTitle => 'Bitki türü';

  @override
  String get healthProgressSelectSpecies => 'Bir tür seçin';

  @override
  String get healthProgressNoPlants =>
      'Henüz uygun tarama yok. Geçmişe hem tür hem hastalık tanınmış bir tarama kaydedin.';

  @override
  String get healthProgressNoChartData =>
      'Son 14 günde bu tür için uygun tarama bulunamadı.';

  @override
  String healthProgressNoChartDataDays(int days) {
    return 'Son $days günde bu tür için uygun tarama bulunamadı.';
  }

  @override
  String healthProgressChartTitleDays(int days) {
    return 'Son $days gün';
  }

  @override
  String get healthProgressChartDays14 => '14 gün';

  @override
  String get healthProgressChartDays30 => '30 gün';

  @override
  String get healthProgressSelectPlant => 'Bir bitki seçin';

  @override
  String get healthProgressPickPlantTitle => 'Bitki seçimi';

  @override
  String get healthProgressChartTitle => 'Son 14 gün';

  @override
  String get healthProgressPhotoTimelineTitle => 'Tarama fotoğrafları';

  @override
  String get healthProgressPhotoTimelineHint =>
      'Zaman içinde yaprak görünümünü karşılaştırmak için fotoğraflara dokunun.';

  @override
  String get healthProgressNoPhotoTimeline =>
      'Bu bitki için kayıtlı fotoğraf yok. Yeni taramada bölge seçerek kaydedin.';

  @override
  String get healthProgressLegendHealth => 'Sağlık';

  @override
  String get healthProgressLegendDisease => 'Hastalık';

  @override
  String get healthProgressPlant1 => 'Monstera';

  @override
  String get healthProgressPlant2 => 'Aloe vera';

  @override
  String get healthProgressPlant3 => 'Kauçuk';

  @override
  String get myPlantsTitle => 'Bitkilerim';

  @override
  String get myPlantsHeadline => 'Koleksiyonun';

  @override
  String get myPlantsSubtitle =>
      'Her kart bir saksıdır. Aynı türden ikinci bitki için kayıt sırasında \"Yeni bitki olarak kaydet\" seçin.';

  @override
  String get myPlantsEmpty =>
      'Henüz bitki eklemediniz. Yeni bir bitki ekleyerek günlük takibe başlayın.';

  @override
  String get myPlantsAddTitle => 'Bitki ekle';

  @override
  String get myPlantsNameLabel => 'Bitki adı';

  @override
  String get myPlantsSpeciesLabel => 'Tür etiketi';

  @override
  String get myPlantsDetailTitle => 'Bitki takibi';

  @override
  String get myPlantsDetailHeadline => 'Sağlık özeti';

  @override
  String get myPlantsDetailSubtitle =>
      'Bu bitkinin son taramalarından sağlık skorunu ve zaman çizelgesini görüntüle.';

  @override
  String get myPlantsLastScore => 'Son skor';

  @override
  String get myPlantsAvgScore => 'Ortalama';

  @override
  String get myPlantsNoScans => 'Henüz tarama kaydı yok.';

  @override
  String get myPlantsTimelineTitle => 'Geçmiş taramalar';

  @override
  String get myPlantsTimelineEmpty =>
      'Bu bitki için kayıtlı tarama bulunamadı.';

  @override
  String get myPlantsHealthScoreLabel => 'Sağlık skoru:';

  @override
  String get notificationsLabel => 'Bildirimler';

  @override
  String get notificationsSubtitle =>
      'Tarama kaydı sonrası takip ve risk uyarıları';

  @override
  String get notificationFollowUpTitle => 'Bitki kontrol zamanı';

  @override
  String notificationFollowUpHealthy(String plantName) {
    return '$plantName için son tarama iyiydi. Bir hafta içinde yeni fotoğrafla kontrol edin.';
  }

  @override
  String notificationFollowUpMild(String plantName) {
    return '$plantName için hafif risk vardı. 5 gün içinde tekrar tarayın.';
  }

  @override
  String notificationFollowUpMedium(String plantName) {
    return '$plantName için orta risk kaydı var. 3 gün içinde kontrol taraması yapın.';
  }

  @override
  String notificationFollowUpUrgent(String plantName) {
    return '$plantName ciddi risk göstermişti. Lütfen en kısa sürede tekrar tarayın.';
  }

  @override
  String get notificationSpeciesTipTitle => 'Bitki kaydedildi';

  @override
  String notificationSpeciesTipBody(String plantName, String species) {
    return '$plantName ($species) kaydedildi. Sulama ve ışık için tür rehberine bakın; hastalık bu taramada net değildi.';
  }

  @override
  String notificationFollowUpSpeciesOnly(String plantName, String species) {
    return '$plantName ($species) için bir hafta içinde yeni fotoğrafla kontrol edin.';
  }

  @override
  String get scanAlreadySaved => 'Kaydedildi';

  @override
  String get scanSavedDoneHint =>
      'Tarama kaydedildi. Yeni tarama için aşağıdan tekrar deneyin.';

  @override
  String get notificationRiskTitle => 'Bitki riski artıyor olabilir';

  @override
  String get notificationRiskBody =>
      'Son taramada risk tespit edildi. Bitkini kontrol edip önerilere göz at.';

  @override
  String notificationRiskBodyFor(String plantName) {
    return '$plantName için ciddi risk tespit edildi. Hemen kontrol edin.';
  }

  @override
  String get dataLabel => 'Veri ve gizlilik';

  @override
  String get inferenceDiseaseBacterial => 'Bakteriyel';

  @override
  String get inferenceDiseaseBlight => 'Yanıklık';

  @override
  String get inferenceDiseaseChlorosisYellowing => 'Kloroz / sararma';

  @override
  String get inferenceDiseaseHealthy => 'Sağlıklı';

  @override
  String get inferenceDiseaseLeafDamage => 'Yaprak hasarı';

  @override
  String get inferenceDiseaseLeafDisease => 'Yaprak hastalığı';

  @override
  String get inferenceDiseaseLeafSpot => 'Yaprak lekesi';

  @override
  String get inferenceDiseaseMold => 'Küf';

  @override
  String get inferenceDiseasePestDamage => 'Zararlı / fiziksel hasar';

  @override
  String get inferenceDiseasePowderyMildew => 'Külleme';

  @override
  String get inferenceDiseaseRot => 'Çürük';

  @override
  String get inferenceDiseaseRust => 'Pas';

  @override
  String get inferenceDiseaseScab => 'Kabuklanma';

  @override
  String get inferenceDiseaseViral => 'Viral';

  @override
  String get inferenceDiseaseViralMosaic => 'Viral mozaik';

  @override
  String get validationRequired => 'Bu alan zorunludur.';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get continueCta => 'Devam et';

  @override
  String get detailCta => 'Detay';

  @override
  String get back => 'Geri';

  @override
  String get close => 'Kapat';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get ok => 'Tamam';

  @override
  String get errorTitle => 'Hata';

  @override
  String get successTitle => 'Başarılı';

  @override
  String get loading => 'Yükleniyor…';

  @override
  String get pdfReportTitle => 'Analiz raporu';

  @override
  String get pdfReportDate => 'Tarih';

  @override
  String get pdfReportSpecies => 'Bitki türü';

  @override
  String get pdfReportSpeciesConfidence => 'Tür güven skoru';

  @override
  String get pdfReportDisease => 'Hastalık';

  @override
  String get pdfReportDiseaseConfidence => 'Hastalık güven skoru';

  @override
  String get pdfReportDisclaimer =>
      'Bu rapor bilgilendirme amaçlıdır; kesin teşhis değildir.';

  @override
  String get emptyState => 'Gösterilecek kayıt yok.';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get placeholderDash => '—';

  @override
  String get errorGeneric =>
      'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get errorNetwork =>
      'Ağ bağlantısı kurulamadı. İnternetinizi kontrol edin.';

  @override
  String get errorImagePick => 'Görüntü seçilirken bir sorun oluştu.';

  @override
  String get errorImageDecode => 'Görüntü işlenemedi.';

  @override
  String get errorCrop => 'Seçilen bölge kırpılamadı.';

  @override
  String get errorInference => 'Tahmin servisi yanıt vermedi.';

  @override
  String get errorSpeciesUnknownSave =>
      'Bitki türü tanınamadığı için kaydedilemiyor. Lütfen daha net bir fotoğraf ile tekrar deneyin.';

  @override
  String get errorAuth => 'Oturum bilgisi doğrulanamadı.';

  @override
  String get errorGoogleSignIn =>
      'Google ile giriş tamamlanamadı. İnternet ve yapılandırmayı kontrol edin.';

  @override
  String get errorStorage => 'Yerel kayıt okunamadı veya yazılamadı.';

  @override
  String get errorAuthEmailInUse => 'Bu e-posta adresi zaten kayıtlı.';

  @override
  String get errorAuthWeakPassword =>
      'Şifre çok zayıf. Daha güçlü bir şifre seçin.';

  @override
  String get errorAuthInvalidEmail => 'Geçersiz e-posta adresi.';

  @override
  String get errorAuthUserNotFound =>
      'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';

  @override
  String get errorAuthWrongPassword => 'Şifre hatalı.';

  @override
  String get errorAuthInvalidCredential => 'E-posta veya şifre hatalı.';

  @override
  String get errorAuthUserDisabled => 'Bu hesap devre dışı bırakılmış.';

  @override
  String get errorAuthTooManyRequests =>
      'Çok fazla deneme yapıldı. Lütfen bir süre sonra tekrar deneyin.';

  @override
  String get errorAuthOperationNotAllowed =>
      'Bu giriş yöntemi şu an kullanılamıyor. Firebase konsolunda etkinleştirin.';

  @override
  String get errorAuthRequiresRecentLogin =>
      'Güvenlik için çıkış yapıp tekrar giriş yapın, ardından e-postayı değiştirin.';

  @override
  String get diseaseDetailTitle => 'Hastalık detayları';

  @override
  String get diseaseDetailConfidenceLabel => 'Güven skoru';

  @override
  String get diseaseDetailSectionDescription => 'Açıklama';

  @override
  String get diseaseDetailSectionCauses => 'Neden oluşur?';

  @override
  String get diseaseDetailSectionTreatment => 'Nasıl tedavi edilir?';

  @override
  String get diseaseDetailSectionPrevention => 'Önleyici öneriler';

  @override
  String get diseaseDetailDescriptionGeneric =>
      'Bu sınıf için henüz detaylı içerik eklenmedi. Sonuçlar öneri niteliğindedir.';

  @override
  String get diseaseDetailCausesGeneric =>
      'Yetersiz ışık, yanlış sulama, düşük hava sirkülasyonu veya patojenler etkili olabilir.';

  @override
  String get diseaseDetailTreatmentGeneric =>
      'Enfekte kısımları temizleyin, bakım koşullarını iyileştirin ve gerekiyorsa uygun ürün kullanın.';

  @override
  String get diseaseDetailPreventionGeneric =>
      'Düzenli kontrol, uygun sulama ve iyi hava akışı riski azaltır.';

  @override
  String get diseaseDetailDescriptionHealthy =>
      'Belirgin hastalık belirtisi görünmüyor; bitki genel olarak iyi durumda.';

  @override
  String get diseaseDetailCausesHealthy =>
      'Doğru sulama, yeterli ışık ve uygun ortam koşulları bitkinin sağlıklı kalmasına yardımcı olur.';

  @override
  String get diseaseDetailTreatmentHealthy =>
      'Bakımı aynı şekilde sürdürün; yaprakları tozdan arındırın ve düzenli gözlem yapın.';

  @override
  String get diseaseDetailPreventionHealthy =>
      'Aşırı sulamadan kaçının, ışık koşullarını sabit tutun ve zararlıları erken tespit edin.';

  @override
  String get diseaseDetailDescriptionPowderyMildew =>
      'Yaprak yüzeyinde beyaz, pudramsı tabaka ile görülen mantar hastalığıdır.';

  @override
  String get diseaseDetailCausesPowderyMildew =>
      'Yüksek nem, zayıf hava akışı ve ani sıcaklık değişimleri tetikleyebilir.';

  @override
  String get diseaseDetailTreatmentPowderyMildew =>
      'Etkilenen yaprakları budayın; yaprakları kuru tutun ve gerekirse mantar ilacı uygulayın.';

  @override
  String get diseaseDetailPreventionPowderyMildew =>
      'Bitkiler arası mesafe bırakın, havalandırmayı artırın ve yaprakları ıslatmadan sulayın.';

  @override
  String get diseaseDetailDescriptionLeafSpot =>
      'Yapraklarda kahverengi/siyah lekeler şeklinde ortaya çıkan enfeksiyon belirtisidir.';

  @override
  String get diseaseDetailCausesLeafSpot =>
      'Mantar veya bakteri kaynaklı olabilir; yaprakların uzun süre ıslak kalması riski artırır.';

  @override
  String get diseaseDetailTreatmentLeafSpot =>
      'Hastalıklı yaprakları alın; sulamayı düzenleyin ve uygun koruyucu/iyileştirici uygulayın.';

  @override
  String get diseaseDetailPreventionLeafSpot =>
      'Üstten sulamayı azaltın, yaprakları kuru tutun ve düzenli temizlik yapın.';

  @override
  String get diseaseDetailDescriptionRust =>
      'Yaprak altında turuncu-kahverengi püstüllerle görülen mantar hastalığıdır.';

  @override
  String get diseaseDetailCausesRust =>
      'Nemli ortam, zayıf hava akışı ve enfekte bitki materyali yayılımı artırır.';

  @override
  String get diseaseDetailTreatmentRust =>
      'Etkilenen yaprakları uzaklaştırın; hava akışını artırın ve gerekirse mantar ilacı kullanın.';

  @override
  String get diseaseDetailPreventionRust =>
      'Sıkışık dikimden kaçının, yaprakları kuru tutun ve karantina uygulayın.';

  @override
  String get diseaseDetailDescriptionBacterial =>
      'Bakteriyel enfeksiyonlarda su toplamış görünümlü lekeler ve hızlı yayılım görülebilir.';

  @override
  String get diseaseDetailCausesBacterial =>
      'Yüksek nem, yaralanmış doku ve kontamine ekipmanlar bulaşı artırabilir.';

  @override
  String get diseaseDetailTreatmentBacterial =>
      'Enfekte kısımları steril kesimle alın; hijyeni artırın ve gerekirse bakır içerikli ürün kullanın.';

  @override
  String get diseaseDetailPreventionBacterial =>
      'Aletleri dezenfekte edin, yaprakları ıslatmadan sulayın ve hava sirkülasyonunu güçlendirin.';

  @override
  String get diseaseDetailDescriptionViral =>
      'Viral hastalıklarda mozaik desen, şekil bozukluğu ve gelişim geriliği görülebilir.';

  @override
  String get diseaseDetailCausesViral =>
      'Zararlılar (ör. yaprak biti), kontamine bitki materyali ve temas bulaşmaya neden olabilir.';

  @override
  String get diseaseDetailTreatmentViral =>
      'Viral hastalıklar için kesin tedavi sınırlıdır; bitkiyi izole edin ve zararlı kontrolü yapın.';

  @override
  String get diseaseDetailPreventionViral =>
      'Zararlıları kontrol edin, yeni bitkileri karantinaya alın ve sağlıklı fide kullanın.';

  @override
  String get diseaseDetailDescriptionBlight =>
      'Yanıklık; yaprak ve gövdede hızla yayılan kararma ve doku ölümüyle ilerleyebilir.';

  @override
  String get diseaseDetailCausesBlight =>
      'Mantar benzeri patojenler, aşırı nem ve düşük hava akışı riski artırır.';

  @override
  String get diseaseDetailTreatmentBlight =>
      'Hastalıklı bölgeleri temizleyin, bitkiyi kurutun ve uygun koruyucu ürün uygulayın.';

  @override
  String get diseaseDetailPreventionBlight =>
      'Yaprakları kuru tutun, doğru aralıkla dikin ve sulamayı sabah yapın.';

  @override
  String get diseaseDetailDescriptionMold =>
      'Küf; yaprak ve yüzeylerde gri/yeşilimsi tabaka şeklinde oluşabilir.';

  @override
  String get diseaseDetailCausesMold =>
      'Aşırı nem, yetersiz havalandırma ve organik kalıntılar büyümeyi hızlandırır.';

  @override
  String get diseaseDetailTreatmentMold =>
      'Etkilenen alanı temizleyin, nemi düşürün ve gerekirse uygun ürün uygulayın.';

  @override
  String get diseaseDetailPreventionMold =>
      'Havalandırmayı artırın, sulamayı azaltın ve yaprakları kuru tutun.';

  @override
  String get diseaseDetailDescriptionPestDamage =>
      'Zararlılar veya fiziksel etkenler yapraklarda delik, ısırık izi ve deformasyon oluşturabilir.';

  @override
  String get diseaseDetailCausesPestDamage =>
      'Akar, yaprak biti, tırtıl gibi zararlılar veya rüzgar/darbe gibi fiziksel nedenler olabilir.';

  @override
  String get diseaseDetailTreatmentPestDamage =>
      'Zararlıyı tespit edin, yaprakları temizleyin ve gerekirse uygun biyolojik/kimyasal mücadele uygulayın.';

  @override
  String get diseaseDetailPreventionPestDamage =>
      'Düzenli kontrol yapın, bitkiyi güçlendirin ve yeni bitkileri karantinaya alın.';

  @override
  String get diseaseDetailDescriptionRot =>
      'Çürük; kök veya gövdede yumuşama, koyulaşma ve kötü koku ile ilerleyebilir.';

  @override
  String get diseaseDetailCausesRot =>
      'Aşırı sulama, drenaj zayıflığı ve patojenler çürümeyi başlatabilir.';

  @override
  String get diseaseDetailTreatmentRot =>
      'Çürüyen kısımları temizleyin, sulamayı azaltın ve daha iyi drenajlı toprağa alın.';

  @override
  String get diseaseDetailPreventionRot =>
      'Toprağın kuruma durumuna göre sulayın, saksı drenajını iyileştirin.';

  @override
  String get speciesDetailTitle => 'Tür detayları';

  @override
  String get speciesDetailConfidenceLabel => 'Güven skoru';

  @override
  String get speciesDetailCareTitle => 'Bakım bilgileri';

  @override
  String get speciesDetailWateringLabel => 'Sulama';

  @override
  String get speciesDetailSunLabel => 'Güneş';

  @override
  String get speciesDetailSoilLabel => 'Toprak';

  @override
  String get speciesDetailWateringValue =>
      'Toprak kurudukça (ortalama haftada 1–2)';

  @override
  String get speciesDetailSunValue => 'Aydınlık, dolaylı ışık';

  @override
  String get speciesDetailSoilValue => 'İyi drenajlı karışım';

  @override
  String get speciesDetailRiskTitle => 'Riskli hastalıklar';

  @override
  String speciesPlantNetUnmapped(String id) {
    return 'Tür (ID: $id)';
  }
}
