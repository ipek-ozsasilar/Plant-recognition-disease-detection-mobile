# PhytoGuard — Bitki Türü ve Hastalık Tanıma Mobil Uygulaması

<p align="center">
  <strong>Flutter · Firebase · TensorFlow Lite</strong><br>
  Bitirme tezi kapsamında geliştirilmiş, çevrimdışı makine öğrenmesi destekli bitki sağlığı izleme uygulaması
</p>

---

## İçindekiler

1. [Proje Hakkında](#proje-hakkında)
2. [Temel Özellikler](#temel-özellikler)
3. [Ekran Görüntüleri](#ekran-görüntüleri)
4. [Teknoloji Yığını](#teknoloji-yığını)
5. [Sistem Mimarisi](#sistem-mimarisi)
6. [Makine Öğrenmesi](#makine-öğrenmesi)
7. [Firebase ve Veri Modeli](#firebase-ve-veri-modeli)
8. [Proje Yapısı](#proje-yapısı)
9. [Kurulum](#kurulum)
10. [Yapılandırma (.env)](#yapılandırma-env)
11. [Çalıştırma](#çalıştırma)
12. [İsteğe Bağlı Backend](#isteğe-bağlı-backend)
13. [Firebase Kurallarını Yayınlama](#firebase-kurallarını-yayınlama)
14. [Yerelleştirme](#yerelleştirme)
15. [Bilinen Sınırlamalar](#bilinen-sınırlamalar)
16. [Lisans ve Tez](#lisans-ve-tez)

---

## Proje Hakkında

**PhytoGuard** (`bitirme_mobile`), kullanıcıların bitki yaprak veya bitki fotoğrafları üzerinden **bitki türünü** ve **genel hastalık sınıfını** tahmin etmesini sağlayan bir mobil uygulamadır. Uygulama, bitirme tezinde eğitilen derin öğrenme modellerinin uç kullanıcıya sunulması, sonuçların bulutta saklanması ve zaman içinde izlenmesi amacıyla tasarlanmıştır.

Uygulama **karar destek** niteliğindedir; profesyonel bitki patolojisi teşhisi veya tarımsal resmî raporlama yerine geçmez. Tüm tahminler güven skorlarıyla birlikte gösterilir; düşük güven veya “sink” (kolay yanlış sınıflanan) türlerde sonuç **tanınamadı** olarak işaretlenir.

### Ne yapar?

| Alan | Açıklama |
|------|----------|
| **Tür tanıma** | ~93 sınıflı PlantNet tabanlı EfficientNetB3 türevi TFLite modeli |
| **Hastalık sınıflandırma** | 5 sınıf: sağlıklı, yanıklık, küf, külleme, pas |
| **Çoklu bölge** | Tek fotoğrafta birden fazla bitki/bölge seçimi; her bölge ayrı analiz ve kayıt |
| **Geçmiş** | Taramalar tür etiketine göre gruplanır; detay, PDF, tür/hastalık bilgi sayfaları |
| **Sağlık ilerlemesi** | Seçilen tür için 14/30 günlük hastalık trend grafiği ve foto zaman çizelgesi |
| **Bulut senkronizasyonu** | Firebase Auth, Firestore, Storage |
| **Yerel çıkarım** | Ağ gerektirmeden cihaz üzerinde TFLite (mobil/masaüstü) |
| **Günün ipucu** | Son taramalara göre bağlamlı bakım önerisi (OpenAI veya yerel şablon) |
| **Bildirimler** | Düşük sağlık skorunda risk uyarısı; takip hatırlatmaları |
| **PDF rapor** | Tek tarama için paylaşılabilir / indirilebilir rapor |

---

## Temel Özellikler

### Kimlik doğrulama ve onboarding

- E-posta/şifre ile kayıt ve giriş
- Google ile oturum açma
- Şifremi unuttum akışı
- İlk açılışta dil seçimi (Türkçe / İngilizce) ve onboarding slaytları
- Oturum bilgisi yerel önbellek + Firebase Auth ile senkron

### Ana sayfa (Pano)

- Kullanıcı karşılama metni
- Hızlı kısayollar: tarama, geçmiş, rehber, ayarlar
- Merkezi tarama çağrı kartı
- **Günün ipucu** banner’ı (son 5 gün tarama bağlamı)
- Son taramalar yatay şeridi
- Özet istatistikler: toplam tarama, benzersiz tür, hastalık sayısı, düşük skorlu kayıt

### Tarama sihirbazı

Tam ekran adım adım akış:

1. **Görüntü seçimi** — kamera veya galeri (uzun kenar ~2048 px sınırı)
2. **Bölge seçimi** — normalize dikdörtgen bölgeler; sürükle-bırak veya varsayılan kare
3. **Tür analizi** — her bölge için sırayla model çıkarımı
4. **Tür sonuçları** — bölge bazlı liste
5. **Hastalık analizi** — her bölge için 5 sınıflı model
6. **Özet** — tür, hastalık, güven; PDF; kaydet

**Kayıt kuralları:**

- Tür güveni **%60 altı** → tanınamadı, geçmişe yazılmaz
- “Sink” türlerde eşik **%78**
- Hastalık güveni **%60 altı** → `unknown` (“Hastalık bilinmiyor”) olarak saklanır
- **Kaydedilebilir bölgeleri kaydet** yalnızca tanınmış tür + hastalık analizi tamamlanmış bölgeleri yazar

**Çoklu bölge kaydı:**

- Her kaydedilebilir bölge ayrı `scans` belgesi oluşturur
- Storage’a yalnızca o bölgenin **kırpılmış JPEG**’i yüklenir (geçmişte karışık çerçeve görünmez)
- Farklı türler aynı fotoğrafta ise her bölge **kendi tür etiketindeki** bitki kaydına otomatik bağlanır; bitki seçim diyaloğu gösterilmez
- Aynı tür için mevcut bitki varsa en son taramalı kayıt kullanılır; yoksa otomatik yeni bitki oluşturulur

### Geçmiş taramalar

- `speciesLabel` ile gruplanmış liste
- Arama
- Detay: büyük görsel, tür/hastalık satırları, güven göstergesi
- Tür ve hastalık detay sayfalarına geçiş
- PDF paylaşım / indirme

### Sağlık ilerlemesi

- Geçmişte tür etiketi olan tüm taramalar açılır listede
- 14 veya 30 günlük pencere
- `fl_chart` ile hastalık sınıfı zaman serisi
- Kronolojik fotoğraf şeridi ve tam ekran önizleme

### Profil ve ayarlar

- Profil fotoğrafı (Firebase Storage + Firestore `photoUrl`)
- Kişisel bilgiler: ad, telefon, bio, e-posta (Google hesabında e-posta salt okunur)
- Gizlilik ve şifre sıfırlama
- Tema: açık / koyu / sistem
- Dil ve bildirim anahtarı (`SharedPreferences`)

### Rehber ve hakkında

- İyi fotoğraf çekimi ve uygulama kullanım önerileri
- Proje / tez amacına uygun bilgilendirme metinleri

### Alt navigasyon

| Sekme | İşlev |
|-------|--------|
| Ana | Pano |
| Geçmiş | Tarama listesi |
| **FAB** | Tarama sihirbazı |
| İlerleme | Sağlık ilerlemesi |
| Menü | Rehber, profil, ayarlar, hakkında |

---

## Ekran Görüntüleri

Aşağıya uygulama ekran görüntülerinizi ekleyebilirsiniz. Hepsini bu bölümde alt alta yerleştirmeniz yeterlidir; başlık veya kısa açıklama isterseniz her görselin hemen üstüne yazabilirsiniz.

<br>

<!-- ═══════════════════════════════════════════════════════════════════ -->
<!--  EKRAN GÖRÜNTÜLERİNİZİ BURADAN İTİBAREN EKLEYİN                    -->
<!--  Örnek: ![Açıklama](docs/screenshots/01-splash.png)               -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

<!-- Yukarıdaki boş satırlar Word/README önizlemesinde alan bırakır; -->
<!-- görselleri ekledikten sonra fazla satırları silebilirsiniz.      -->

---

## Teknoloji Yığını

| Katman | Teknoloji |
|--------|-----------|
| Framework | Flutter 3.8+ (Dart 3.8+) |
| UI | Material Design 3, Google Fonts, responsive_framework |
| Durum yönetimi | Riverpod 2.x |
| Navigasyon | go_router 14.x |
| DI | get_it |
| Yerelleştirme | flutter gen-l10n (TR / EN) |
| Kimlik | Firebase Auth, Google Sign-In |
| Veritabanı | Cloud Firestore |
| Dosya depolama | Firebase Storage |
| ML çıkarım | TensorFlow Lite (`tflite_flutter`) |
| Görüntü | image_picker, image (kırpım / JPEG) |
| Grafik | fl_chart |
| PDF | pdf, printing |
| Bildirim | flutter_local_notifications, timezone |
| Gizli yapılandırma | envied + `.env` |
| Kod üretimi | build_runner, flutter_gen, json_serializable |

---

## Sistem Mimarisi

```
┌─────────────────────────────────────────────────────────────┐
│                    Sunum (Flutter UI)                        │
│  features/: home, scan, history, health_progress, auth, …   │
└──────────────────────────┬──────────────────────────────────┘
                           │ Riverpod Providers
┌──────────────────────────▼──────────────────────────────────┐
│              İş mantığı / ViewModel / Notifier               │
└──────────────────────────┬──────────────────────────────────┘
                           │ get_it (Service Locator)
┌──────────────────────────▼──────────────────────────────────┐
│  core/services/                                              │
│  · InferenceApiService (Mock / TFLite / HTTP)                │
│  · PlantScansFirestoreService, PlantsFirestoreService        │
│  · FirebaseStorageService, UserProfileFirestoreService       │
│  · ImageCropService, PdfReportService, NotificationService   │
│  · DailyTipApiService, CatalogFirestoreService               │
└───────┬──────────────────────────────┬──────────────────────┘
        │                              │
        ▼                              ▼
┌───────────────┐              ┌──────────────────┐
│ TFLite assets │              │ Firebase         │
│ (cihaz içi)   │              │ Auth · Firestore │
│               │              │ · Storage        │
└───────────────┘              └──────────────────┘
```

**Başlangıç sırası** (`AppInitializers`):

1. Firebase başlatma  
2. Yerel saat dilimi (`timezone`)  
3. Servis kayıtları (`service_locator.dart`)  
4. ML metadata yükleme (sınıf listeleri, PlantNet haritası, sink sınıfları)  
5. Bildirim kanalları  
6. Kayıtlı dil ve tema tercihleri  

---

## Makine Öğrenmesi

### Model dosyaları (`assets/ml/`)

| Dosya | Rol |
|-------|-----|
| `plant_species_model.tflite` | Tür sınıflandırıcı (~93 sınıf) |
| `class_names.json` | Tür sınıf etiketleri |
| `plantnet_species_id_map.json` | PlantNet ID → görünen ad |
| `sink_classes.json` | Sıkı eşik uygulanan “sink” sınıflar |
| `disease_5class.tflite` | 5 sınıflı hastalık modeli |
| `disease_class_names_5class.json` | Hastalık sınıf anahtarları |

### Hastalık sınıfları

| Anahtar | Anlam |
|---------|--------|
| `healthy` | Sağlıklı |
| `blight` | Yanıklık |
| `mold` | Küf |
| `powdery_mildew` | Külleme |
| `rust` | Pas |

### Çıkarım modları (`.env`)

| Mod | `USE_MOCK_INFERENCE` | `USE_LOCAL_TFLITE` | Açıklama |
|-----|----------------------|--------------------|----------|
| Yerel TFLite | `false` | `true` | Önerilen; çevrimdışı |
| HTTP API | `false` | `false` | `API_BASE_URL` üzerinden `/predict/species`, `/predict/disease` |
| Mock | `true` | — | Geliştirme / test |

**Ön işleme:** Görüntü decode → model giriş boyutuna yeniden boyutlandırma → softmax → en iyi sınıf + alternatifler.

**Sağlık skoru:** Hastalık anahtarı ve güven değerinden 0–100 tamsayı skor (`computeHealthScore`).

---

## Firebase ve Veri Modeli

### Firestore koleksiyonları

| Koleksiyon | Açıklama |
|------------|----------|
| `users/{uid}` | Profil: email, displayName, photoUrl, phone, bio, authProvider |
| `plants/{id}` | Kullanıcının fiziksel bitki kaydı (tür etiketi, son skor, foto) |
| `scans/{id}` | Tarama: tür, hastalık, güven, healthScore, imageUrl, plantId |
| `species/{id}` | Paylaşılan tür kataloğu (otomatik doldurulur) |
| `diseases/{id}` | Paylaşılan hastalık kataloğu (`unknown` yazılmaz) |

### Storage yolları

| Yol | İçerik |
|-----|--------|
| `scans/{userId}/{scanId}.jpg` | Tarama / bölge kırpım fotoğrafı |
| `users/{userId}/profile.jpg` | Profil fotoğrafı |

### Güvenlik kuralları

- `firestore.rules` — kullanıcı verisi yalnızca `ownerUid == auth.uid`
- `storage.rules` — kullanıcı klasörü izolasyonu

Kuralların Firebase Console’da **yayınlanması** gerekir:

```bash
firebase deploy --only firestore,storage
```

---

## Proje Yapısı

```
bitirme_mobile/
├── android/                 # Android native
├── ios/                     # iOS native
├── assets/
│   ├── ml/                  # TFLite modelleri ve JSON etiketler
│   ├── colors/
│   └── fonts/
├── backend/                 # İsteğe bağlı FastAPI (günün ipucu)
├── lib/
│   ├── main.dart
│   ├── models/              # PlantScanModel, PlantModel, UserProfileModel, …
│   ├── core/
│   │   ├── navigation/      # app_router, app_paths
│   │   ├── services/        # Firebase, ML, PDF, bildirim, …
│   │   ├── enums/
│   │   ├── widgets/
│   │   └── env/
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── scan/
│   │   ├── history/
│   │   ├── health_progress/
│   │   ├── profile/
│   │   ├── settings/
│   │   └── …
│   ├── l10n/                # app_tr.arb, app_en.arb
│   ├── gen/                 # flutter_gen çıktıları
│   └── service_locator/
├── firestore.rules
├── storage.rules
├── firebase.json
├── .env.example
└── pubspec.yaml
```

---

## Kurulum

### Gereksinimler

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.8
- Android Studio / Xcode (hedef platforma göre)
- Firebase projesi (Auth, Firestore, Storage etkin)
- `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) projeye eklenmiş olmalı

### Adımlar

```bash
# Depoyu klonlayın
git clone <repo-url>
cd bitirme_mobile

# Bağımlılıklar
flutter pub get

# Ortam dosyası
cp .env.example .env
# .env dosyasını düzenleyin (aşağıya bakın)

# Kod üretimi (envied, l10n vb.)
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# Firebase yapılandırması (FlutterFire CLI kullanıyorsanız)
# flutterfire configure
```

---

## Yapılandırma (.env)

`.env` dosyası git’e **dahil edilmez**. `.env.example` şablonunu kopyalayın:

| Değişken | Açıklama |
|----------|----------|
| `API_BASE_URL` | HTTP çıkarım sunucusu tabanı (ör. `http://127.0.0.1:8000`) |
| `USE_MOCK_INFERENCE` | `true` → rastgele mock tahmin |
| `USE_LOCAL_TFLITE` | `true` → cihazda TFLite (önerilen) |
| `GOOGLE_WEB_CLIENT_ID` | Google Sign-In web istemci kimliği |
| `OPENAI_API_KEY` | Günün ipucu için (isteğe bağlı) |
| `OPENAI_MODEL` | Örn. `gpt-4o-mini` |
| `USE_AI_DAILY_TIP` | `true` → OpenAI ile ipucu |
| `USE_MOCK_DAILY_TIP` | `true` → şablon ipucu |

Değişiklikten sonra:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Çalıştırma

```bash
# Bağlı cihaz / emülatör listesi
flutter devices

# Debug çalıştırma
flutter run

# Release APK (Android)
flutter build apk --release
```

**Not:** Web derlemesinde `tflite_flutter` FFI kısıtı nedeniyle yerel TFLite devre dışı kalabilir; bu durumda HTTP veya mock modu kullanın.

---

## İsteğe Bağlı Backend

`backend/` klasöründe FastAPI tabanlı hafif bir servis bulunur (ör. günün ipucu proxy). Mobil uygulama doğrudan OpenAI anahtarını da kullanabilir (`.env` içinde).

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate          # Windows
pip install -r requirements.txt
cp .env.example .env            # OPENAI_API_KEY doldurun
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

---

## Firebase Kurallarını Yayınlama

Projede `firestore.rules` ve `storage.rules` tanımlıdır. Console’da manuel yapıştırabilir veya CLI ile deploy edebilirsiniz:

```bash
firebase login
firebase use <proje-id>
firebase deploy --only firestore,storage
```

Yayınlanmamış kurallar `permission-denied` hatalarına yol açar (özellikle `species` / `diseases` katalog yazımları ve Storage yüklemeleri).

---

## Yerelleştirme

- Kaynak: `lib/l10n/app_tr.arb`, `lib/l10n/app_en.arb`
- ARB düzenledikten sonra: `flutter gen-l10n`
- İlk kurulumda dil seçimi ekranı

---

## Bilinen Sınırlamalar

- TFLite yalnızca Android / iOS / masaüstü native hedeflerde tam desteklenir; web’de sınırlıdır.
- Model çıktıları eğitim veri seti ve koşullarıyla sınırlıdır; düşük ışık, bulanık veya alakasız görüntülerde “tanınamadı” sık görülür.
- Aynı türden birden fazla saksı varsa kayıt, **en son taramalı** bitki kaydına otomatik bağlanır (manuel seçim yok).
- OpenAI ipucu özelliği geçerli API anahtarı gerektirir; anahtar yoksa yerel şablon metinler kullanılır.

---

## Lisans ve Tez

Bu proje **bitirme tezi** kapsamında akademik amaçla geliştirilmiştir. Model eğitimi, veri setleri ve deneysel sonuçlar tez metninde ayrıntılı anlatılmaktadır.

**Geliştirici:** İpek Özsaşılar  
**Kurum / program:** (Tez bilgilerinizi buraya ekleyebilirsiniz)

---

<p align="center">
  <sub>PhytoGuard — Bitkilerinizi fotoğraflayın, tür ve sağlık durumunu izleyin.</sub>
</p>
