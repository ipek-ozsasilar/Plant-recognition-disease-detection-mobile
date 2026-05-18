# Firestore Veritabanı Yapısı

## 📋 Collections Şeması

### 1. `users` Collection
Kullanıcı profili bilgileri
```json
users/{uid}
├── email: string (örn: "user@gmail.com")
├── displayName: string (örn: "Ahmet Yılmaz")
├── authProvider: string (örn: "google", "email")
├── photoUrl?: string (isteğe bağlı)
├── createdAt: timestamp
└── updatedAt: timestamp
```

**Indexler:** Özel index gerekli değil

---

### 2. `plants` Collection
Kullanıcının takip ettiği bitkiler (tarama kaydedildiğinde tür etiketine göre **otomatik oluşturulur/güncellenir**; ayrı “geçmişe kaydet” akışı yoktur)
```json
plants/{plantId}
├── id: string (UUID)
├── ownerUid: string (users collection'a referans)
├── name: string (örn: "Ev Bitkisi")
├── speciesLabel: string (örn: "Monstera deliciosa")
├── photoUrl?: string (Firebase Storage path)
├── isFavorite: boolean (default: false)
├── lastHealthScore?: number (0-100)
├── lastScanDate?: timestamp
├── createdAt: timestamp
└── updatedAt?: timestamp
```

**Indexler:**
- Composite: `ownerUid`, `createdAt` DESC
- Composite: `ownerUid`, `isFavorite`, `createdAt` DESC

**Query Örnekleri:**
```dart
// Kullanıcının tüm bitkilerini listele (en yeni)
db.collection('plants')
  .where('ownerUid', isEqualTo: uid)
  .orderBy('createdAt', descending: true)
  .get()

// Favoriler
db.collection('plants')
  .where('ownerUid', isEqualTo: uid)
  .where('isFavorite', isEqualTo: true)
  .orderBy('createdAt', descending: true)
  .get()
```

---

### 3. `scans` Collection
Bitki tarama geçmişi (tek kayıt kaynağı; UI’daki “geçmiş taramalar” buradan okunur)
```json
scans/{scanId}
├── id: string (UUID)
├── ownerUid: string (users collection'a referans)
├── plantId: string (plants/{plantId} — her zaman dolu; `general` kullanılmaz)
├── createdAt: timestamp
├── speciesLabel: string (örn: "Monstera deliciosa")
├── speciesConfidence: number (0.0-1.0)
├── diseaseKey: string (örn: "powdery_mildew")
├── diseaseConfidence: number (0.0-1.0)
├── healthScore: number (0-100)
├── imageUrl?: string (Firebase Storage path)
└── notes?: string (kullanıcı notları)
```

**Indexler:**
- Composite: `ownerUid`, `createdAt` DESC
- Composite: `ownerUid`, `plantId`, `createdAt` DESC
- Composite: `plantId`, `createdAt` DESC

**Query Örnekleri:**
```dart
// Belirli bitkinin tarama geçmişi
db.collection('scans')
  .where('ownerUid', isEqualTo: uid)
  .where('plantId', isEqualTo: plantId)
  .orderBy('createdAt', descending: true)
  .limit(30)
  .get()

// Tüm taramalar (son 60)
db.collection('scans')
  .where('ownerUid', isEqualTo: uid)
  .orderBy('createdAt', descending: true)
  .limit(60)
  .get()
```

---

### 4. `diseases` Collection (Opsiyonel - Katalog)
Hastalık bilgi kataloğu (otomatik/admin doldurulur)
```json
diseases/{diseaseKey}
├── diseaseKey: string (unique, örn: "powdery_mildew")
├── name: string (Türkçe, örn: "Unlu Mildiyö")
├── nameEn: string (İngilizce)
├── description: string
├── symptoms: array[string]
├── treatment: array[string]
└── createdAt: timestamp
```

---

### 5. `species` Collection (Opsiyonel - Katalog)
Bitki türü bilgi kataloğu (otomatik/admin doldurulur)
```json
species/{speciesId}
├── speciesLabel: string (unique, örn: "Monstera deliciosa")
├── commonName: string (Türkçe)
├── commonNameEn: string (İngilizce)
├── imageUrl?: string
├── careLevel: string ("easy", "medium", "hard")
├── wateringFrequency: string
├── lightRequirements: string
└── commonDiseases: array[string] (diseaseKey'ler)
```

---

## 🔐 Güvenlik Kuralları

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Authenticated users only
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    match /plants/{plantId} {
      allow read, write: if request.auth.uid == resource.data.ownerUid;
      allow create: if request.auth.uid == request.resource.data.ownerUid;
    }
    
    match /scans/{scanId} {
      allow read, write: if request.auth.uid == resource.data.ownerUid;
      allow create: if request.auth.uid == request.resource.data.ownerUid;
    }
    
    // Kataloglar - herkese okunabilir, sadece admin yazabilir
    match /diseases/{diseaseKey} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }
    
    match /species/{speciesId} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }
  }
}
```

---

## 💾 Firebase Storage Yapısı

```
bitirme_mobile_firebase_storage/
├── plants/
│   └── {uid}/
│       ├── {plantId}_original.jpg
│       └── {plantId}_thumb.jpg
├── scans/
│   └── {uid}/
│       ├── {scanId}_original.jpg
│       └── {scanId}_thumb.jpg
└── users/
    └── {uid}/
        └── profile_picture.jpg
```

**Storage Kuralları:**
```storage
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User folders - only owner can access
    match /plants/{userId}/{allPaths=**} {
      allow read, write: if request.auth.uid == userId;
    }
    
    match /scans/{userId}/{allPaths=**} {
      allow read, write: if request.auth.uid == userId;
    }
    
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

---

## 🚀 Setup Adımları

1. **Firestore Database Oluştur**
   - Region: `europe-west1` (Avrupa)
   - Mode: Native
   - Production mode başlat

2. **Collections Oluştur** (otomatik, ilk veri yazıldığında)
   - `users`
   - `plants`
   - `scans`
   - `diseases` (opsiyonel)
   - `species` (opsiyonel)

3. **Indexler Ekle**
   - Firestore Console > Indexes sekmesi
   - Composite indexleri manuel ekle (Firebase önerecek)

4. **Güvenlik Kurallarını Yayınla**
   - Firestore Console > Rules sekmesi
   - Yukarıdaki kuralları yapıştır
   - Publish tıkla

5. **Storage Kurallarını Yayınla**
   - Storage Console > Rules sekmesi
   - Kuralları yapıştır
   - Publish tıkla

---

## 📱 Dart/Flutter Kullanım Örnekleri

### Bitki Ekle
```dart
final plantId = const Uuid().v4();
await FirebaseFirestore.instance
    .collection('plants')
    .doc(plantId)
    .set({
      'id': plantId,
      'ownerUid': FirebaseAuth.instance.currentUser!.uid,
      'name': 'Monstera',
      'speciesLabel': 'Monstera deliciosa',
      'isFavorite': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
```

### Tarama Kaydet
```dart
final scanId = const Uuid().v4();
await FirebaseFirestore.instance
    .collection('scans')
    .doc(scanId)
    .set({
      'id': scanId,
      'ownerUid': uid,
      'plantId': plantId,
      'createdAt': FieldValue.serverTimestamp(),
      'diseaseKey': 'powdery_mildew',
      'diseaseConfidence': 0.95,
      'healthScore': 65,
      'speciesLabel': 'Monstera deliciosa',
      'speciesConfidence': 0.98,
    });
```

---

## ⚠️ Önemli Notlar

- **FieldValue.serverTimestamp()** her zaman kullan - client saati güvenilmez
- **ownerUid** hareketli olmaması için immutable sakla
- **plantId, scanId** UUID v4 kullan (guid paket)
- **Soft Delete** gerekirse `deletedAt` timestamp alanı ekle
- **Backup** periyodik al (Firestore Export)
