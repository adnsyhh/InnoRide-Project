# InnoRide Project (Monorepo)

Selamat datang di proyek **InnoRide**! Ini adalah monorepo yang berisi:

- 📱 **mobile/** → Aplikasi Flutter untuk pengguna
- 🖥 **web-admin/** → Backend API menggunakan Laravel 12
- 📄 **docs/** → Dokumentasi API, Thunder Client Collection, README

---

## 🚀 Fitur Backend (Laravel)
- Autentikasi dengan Laravel Sanctum
- CRUD Kendaraan dengan review & rating otomatis
- Booking sistem dengan status & total harga
- Promo diskon kendaraan (admin)
- Profil user (view & edit)
- Seeder siap pakai

---

## 📁 Struktur Folder

```
InnoRide-Project/
├── mobile/              # Flutter app
├── web-admin/           # Laravel backend
├── docs/                # Dokumentasi & koleksi Thunder Client
│   ├── README.md
│   ├── API_Documentation.md
│   └── thunder-collection-InnoRide-FULL.json
└── .gitignore
```

---

## ⚙️ Setup Laravel Backend

```bash
cd web-admin
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

---

## 📱 Setup Flutter Frontend

```bash
cd mobile
flutter pub get
flutter run
```

---

## 🔐 Login Dummy

| Role  | Email               | Password  |
|-------|---------------------|-----------|
| Admin | admin@innoride.com  | password  |
| User  | rizky@mail.com      | password  |

---

## ⚡ Thunder Client

Import koleksi: `docs/thunder-collection-InnoRide-FULL.json` ke Thunder Client (VS Code)

---

## 📄 Dokumentasi API

Lihat `docs/API_Documentation.md` untuk penjelasan lengkap setiap endpoint.

---

## 📌 Tips Kolaborasi

- Gunakan **Git branch**: `feature/nama-fitur`, `fix/nama-bug`, dll
- Commit kecil & sering
- Buat Pull Request ke branch `dev`, bukan `main`
- Selalu sync dulu sebelum mulai kerja

---

## 🧠 Catatan Developer

- Jangan commit file `.env` atau folder `vendor/`
- Laravel dan Flutter disiapkan agar bisa dikembangkan secara paralel
- Gunakan akun dummy untuk testing awal sebelum login nyata

---

## 🧑‍💻 Kontak Developer

- 📧 adnansyah26@gmail.com
- 🐙 GitHub: [github.com/adnsyhh](https://github.com/adnsyhh)

---

Selamat berkarya dan semangat ngerjain InnoRide! 🚀🔥
