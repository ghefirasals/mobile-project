# Nasi Padang Online - Flutter App

Aplikasi jualan nasi Padang dengan implementasi lengkap dari Modul 4: Penyimpanan Lokal & Cloud.

##  Fitur

###  Authentication & User Management
- Login/Register dengan email dan password
- Google Sign-In support
- Reset password functionality
- User profile management
- Admin role support

###  Penyimpanan Data (3 Jenis)
1. **SharedPreferences** - untuk tema aplikasi (light/dark mode)
2. **Hive** - untuk data terstruktur lokal (user profile, menu items, cart)
3. **Supabase** - untuk cloud storage, authentication, dan database

###  UI/UX Features
- Tema nasi Padang dengan warna oranye khas
- Dark/Light mode toggle
- Responsive design
- Beautiful card layouts
- Shopping cart functionality
- Spicy level indicators

###  Menu Management
- Kategori menu (Nasi, Lauk, Sayur, Minuman, Sambal)
- Menu dengan harga dan level kepedasan
- Add to cart functionality
- Checkout process

##  Tech Stack

- **Frontend**: Flutter with GetX state management
- **Local Storage**: Hive (NoSQL database), SharedPreferences
- **Cloud Storage**: Supabase (Authentication, Database, Storage)
- **Architecture**: Clean architecture with services separation

##  Prerequisites

1. Flutter SDK (>=3.9.2)
2. Android Studio / VS Code dengan Flutter extensions
3. Akun Supabase (gratis)

##  Setup Instructions

### 1. Clone & Install Dependencies

```bash
flutter pub get
```

### 2. Setup Supabase

1. Buat project baru di [supabase.com](https://supabase.com)
2. Copy URL dan Anon Key dari dashboard Supabase
3. Update konfigurasi di `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL', // Ganti dengan URL Supabase Anda
  anonKey: 'YOUR_SUPABASE_ANON_KEY', // Ganti dengan Anon Key Supabase Anda
);
```

### 3. Setup Database

Jalankan SQL script ini di SQL Editor Supabase Anda:

```sql
-- Copy contents dari file: database/nasi_padang_schema.sql
```

### 4. Generate Hive Adapters

```bash
flutter packages pub run build_runner build
```

### 5. Run App

```bash
flutter run
```

##  Project Structure

```
lib/
├── config/
│   └── supabase_config.dart       # Supabase configuration
├── models/
│   ├── user_profile.dart          # User profile model (Hive)
│   ├── menu_item.dart             # Menu item model (Hive)
│   └── cart_item.dart             # Cart item model (Hive)
├── services/
│   ├── auth_service.dart          # Authentication service (Supabase)
│   └── theme_service.dart         # Theme management (SharedPreferences)
├── views/
│   ├── auth/
│   │   └── login_view.dart        # Login/Register screen
│   └── home/
│       ├── nasi_padang_home_view.dart  # Main menu screen
│       ├── cart_view.dart         # Shopping cart
│       └── profile_view.dart      # User profile
├── bindings/
│   └── initial_binding.dart       # Dependency injection
└── main.dart                      # App entry point
```

##  Database Schema

### Tables di Supabase:
- `user_profiles` - Data pengguna
- `menu_categories` - Kategori menu
- `menu_items` - Items menu
- `orders` - Pesanan
- `order_items` - Detail pesanan
- `cart_items` - Keranjang belanja

### Local Storage (Hive):
- `user_profiles` - Cache user data
- `menu_items` - Cache menu data
- `cart_items` - Local cart data

##  Theme Configuration

App menggunakan tema warna oranye khas nasi Padang:
- Primary Color: `#D84315` (Deep Orange)
- Secondary Color: `#FF6F00` (Orange)
- Tertiary Color: `#8BC34A` (Green untuk sayur)

##  Screenshots

### Login Screen
- Beautiful login with nasi Padang theme
- Email/password authentication
- Google Sign-In option
- Theme toggle

### Home Screen
- Tabbed menu by category
- Beautiful card layouts
- Spicy level indicators
- Add to cart functionality

### Cart & Profile
- Shopping cart management
- User profile settings
- Dark/light mode toggle

##  Contributing

1. Fork this repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

##  License

This project is licensed under the MIT License - see the LICENSE file for details.

##  Troubleshooting

### Common Issues:

1. **Supabase Connection Error**
   - Pastikan URL dan Anon Key sudah benar
   - Cek koneksi internet
   - Verifikasi project Supabase sudah aktif

2. **Hive Adapter Error**
   - Jalankan `flutter packages pub run build_runner build`
   - Pastikan semua model file sudah ada part `.g.dart`

3. **Build Errors**
   - Run `flutter clean` dan `flutter pub get`
   - Pastikan Flutter SDK versi >=3.9.2

4. **Theme Issues**
   - Restart app setelah mengubah tema
   - Check SharedPreferences permissions

##  Support

Jika ada pertanyaan atau issues, silakan:
1. Cek troubleshooting section
2. Search existing issues di GitHub
3. Create new issue dengan deskripsi detail

