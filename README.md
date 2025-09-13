# Risto 🎬

[![English](https://img.shields.io/badge/English-README_EN.md-blue)](README_EN.md) [![Indonesia](https://img.shields.io/badge/Indonesia-README.md-green)](README.md)

Risto adalah aplikasi katalog film dan serial TV yang dikembangkan menggunakan Flutter. Aplikasi ini memungkinkan pengguna untuk menjelajahi, mencari, dan mengelola daftar tontonan film dan serial TV favorit mereka.

## ✨ Fitur Utama

### 🎥 Film (Movies)
- **Now Playing Movies** - Film yang sedang tayang saat ini
- **Popular Movies** - Film populer
- **Top Rated Movies** - Film dengan rating tertinggi
- **Movie Detail** - Detail lengkap film termasuk sinopsis, rating, dan rekomendasi
- **Search Movies** - Pencarian film berdasarkan judul
- **Watchlist Movies** - Daftar film yang ingin ditonton (disimpan lokal)

### 📺 Serial TV (TV Series)
- **Now Playing TV Series** - Serial TV yang sedang tayang
- **Popular TV Series** - Serial TV populer
- **Top Rated TV Series** - Serial TV dengan rating tertinggi
- **TV Series Detail** - Detail lengkap serial TV termasuk sinopsis, rating, dan rekomendasi
- **Search TV Series** - Pencarian serial TV berdasarkan judul
- **Watchlist TV Series** - Daftar serial TV yang ingin ditonton (disimpan lokal)

### 🔍 Fitur Lainnya
- **Dark Theme** - Tema gelap untuk pengalaman visual yang nyaman
- **Offline Support** - Data watchlist tersimpan secara lokal menggunakan SQLite
- **Rating Display** - Menampilkan rating film/serial menggunakan rating bar
- **Responsive Design** - Tampilan yang responsif di berbagai ukuran layar

## 🏗️ Arsitektur

Aplikasi ini menggunakan **Clean Architecture** dengan struktur sebagai berikut:

```
lib/
├── common/           # Komponen umum (constants, exceptions, failures)
├── data/            # Layer data
│   ├── datasources/ # Remote & Local data sources
│   ├── models/      # Data models
│   └── repositories/ # Repository implementations
├── domain/          # Layer domain
│   ├── entities/    # Business entities
│   ├── repositories/ # Repository contracts
│   └── usecases/    # Business logic
├── presentation/    # Layer presentation
│   ├── pages/       # UI screens
│   ├── provider/    # State management
│   └── widgets/     # Reusable widgets
└── injection.dart   # Dependency injection
```

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat
- Flutter SDK ^3.9.2
- Dart SDK
- Android Studio / VS Code dengan Flutter extension
- Android device/emulator atau iOS simulator

### Langkah-langkah

1. **Clone repository**
   ```bash
   git clone https://github.com/bobipermanasandi/Risto.git
   cd risto
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate mock files**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run aplikasi**
   ```bash
   flutter run
   ```

## 🧪 Testing

Aplikasi ini memiliki coverage testing yang komprehensif:

### Menjalankan Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Test dengan coverage
flutter test --coverage

# Generate ke HTML
genhtml coverage/lcov.info -o coverage/html
```

### Coverage Report
Setelah menjalankan test dengan coverage, buka file HTML di:
```bash
open coverage/html/index.html
```

### Struktur Testing
- **Unit Tests** - Testing untuk data sources, repositories, dan use cases
- **Widget Tests** - Testing untuk UI components dan pages
- **Integration Tests** - Testing untuk alur aplikasi secara keseluruhan

## 🔧 Konfigurasi API

Aplikasi menggunakan The Movie Database (TMDB) API :
```dart
// lib/common/constants.dart
const String apiKey = 'api_key=xxxxxxxx';
const String baseUrl = 'https://api.themoviedb.org/3';
```

## 📁 Struktur File Utama

```
lib/
├── main.dart                    # Entry point aplikasi
├── injection.dart              # Dependency injection setup
├── common/
│   ├── constants.dart          # App constants (API, colors, themes)
│   ├── exception.dart          # Custom exceptions
│   ├── failure.dart            # Failure classes
│   └── utils.dart              # Utility functions
├── data/
│   ├── datasources/            # Data sources (remote & local)
│   ├── models/                 # Data models
│   └── repositories/           # Repository implementations
├── domain/
│   ├── entities/               # Business entities
│   ├── repositories/           # Repository contracts
│   └── usecases/               # Business logic use cases
└── presentation/
    ├── pages/                  # UI screens
    ├── provider/               # State management
    └── widgets/                # Reusable widgets
```

## 🎨 UI/UX Features

- **Dark Theme** - Tema gelap dengan kombinasi warna yang menarik
- **Custom Colors** - Palet warna kustom dengan Google Fonts Poppins
- **Responsive Layout** - Layout yang responsif untuk berbagai ukuran layar
- **Smooth Navigation** - Navigasi yang smooth dengan Cupertino dan Material transitions
- **Loading States** - Indikator loading untuk pengalaman pengguna yang baik

## 📊 Performance

- **Cached Images** - Menggunakan cached network image untuk optimasi loading
- **Lazy Loading** - Implementasi lazy loading untuk list yang panjang
- **Local Storage** - Watchlist tersimpan lokal untuk akses offline
- **Error Handling** - Comprehensive error handling dengan user-friendly messages

## 🤝 Contributing

1. Fork repository ini
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 License

Proyek ini dibuat untuk tujuan pembelajaran dan demonstrasi Clean Architecture dengan Flutter.

---

**Note**: Aplikasi ini dibuat sebagai contoh pembelajaran Flutter Developer Expert dan menggunakan data dari The Movie Database (TMDB) API.