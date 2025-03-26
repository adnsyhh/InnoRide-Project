# InnoRide API Documentation

> Versi: v1.0  
> Base URL: `http://127.0.0.1:8000/api`

---

## 🛂 Auth API

### ✅ Register
- **POST** `/register`
- **Body:**
```json
{
  "name": "Rizky",
  "email": "rizky@mail.com",
  "password": "password",
  "role": "user"
}
```
- **Response:** Token + data user

### ✅ Login
- **POST** `/login`
- **Body:**
```json
{
  "email": "rizky@mail.com",
  "password": "password"
}
```
- **Response:** Token + data user

---

## 👤 Profile

### ✅ GET Profile
- **GET** `/profile`
- **Header:** Bearer Token
- **Response:** Data user + history bookings

### ✅ Update Profile
- **PUT** `/profile`
- **Body:**
```json
{
  "username": "rizkyram",
  "profile_picture": "https://example.com/photo.jpg"
}
```

---

## 🚘 Vehicles

### ✅ List Kendaraan
- **GET** `/vehicles`
- **Response:** Semua kendaraan + rating & review_count

### ✅ Detail Kendaraan
- **GET** `/vehicles/{id}`

### ✅ Tambah Kendaraan (Admin)
- **POST** `/vehicles`

### ✅ Update Kendaraan
- **PUT** `/vehicles/{id}`

### ✅ Hapus Kendaraan
- **DELETE** `/vehicles/{id}`

---

## 📦 Bookings

### ✅ List Booking (Admin)
- **GET** `/bookings`

### ✅ Buat Booking (User)
- **POST** `/bookings`
```json
{
  "vehicle_id": 1,
  "start_date": "2025-04-01",
  "end_date": "2025-04-03"
}
```

### ✅ Update Booking
- **PUT** `/bookings/{id}`

### ✅ Hapus Booking
- **DELETE** `/bookings/{id}`

---

## ⭐ Reviews

### ✅ Tambah Review
- **POST** `/reviews`
```json
{
  "vehicle_id": 1,
  "rating": 5,
  "comment": "Mantap kendaraannya!"
}
```

### ✅ Lihat Semua Review
- **GET** `/reviews`

---

## 🎟 Promo

### ✅ Lihat Promo
- **GET** `/promos`

### ✅ Tambah Promo (Admin)
- **POST** `/promos`

### ✅ Update Promo
- **PUT** `/promos/{id}`

### ✅ Hapus Promo
- **DELETE** `/promos/{id}`

---

## ⚠️ Auth Required:
Semua endpoint (kecuali register & login) butuh header:
```
Authorization: Bearer <token>
```
