# Panduan Mengaktifkan Login Google + Database (untuk pemula)

Situs ini sudah jalan tanpa login (data tersimpan di browser). Ikuti langkah
berikut **sekali saja** untuk menambahkan login Google + penyimpanan data per-akun
di awan (Supabase). Tidak perlu coding — kamu hanya menyalin beberapa nilai.

> Saat selesai, beri tahu 2 nilai (Project URL & anon key) ke asisten, atau
> tempel sendiri ke bagian atas `index.html` (lihat Langkah 5).

---

## Langkah 1 — Buat akun & proyek Supabase (gratis)
1. Buka https://supabase.com → **Start your project** → daftar (boleh pakai akun Google).
2. **New project** → beri nama `baserbinikah` → buat password database (catat) → pilih region terdekat (Singapore) → **Create**.
3. Tunggu ±2 menit sampai proyek siap.

## Langkah 2 — Buat tabel database
1. Di proyek Supabase, buka menu kiri **SQL Editor** → **New query**.
2. Buka file `schema.sql` (ada di repo ini), salin SELURUH isinya, tempel ke editor.
3. Klik **Run**. Akan muncul "Success". Ini membuat tabel `weddings` + aturan keamanan
   (tiap user hanya bisa akses datanya sendiri).

## Langkah 3 — Ambil kunci API
1. Buka **Project Settings** (ikon gerigi) → **API**.
2. Salin dua nilai:
   - **Project URL** → contoh `https://abcdefgh.supabase.co`
   - **Project API keys → anon public** → string panjang
3. Simpan dulu kedua nilai ini.

## Langkah 4 — Aktifkan login Google
1. Di Supabase: **Authentication → Sign In / Providers → Google** → **Enable**.
   - Di sini akan terlihat **Callback URL** berbentuk
     `https://<id>.supabase.co/auth/v1/callback` — **salin**, dipakai nanti.
2. Buka https://console.cloud.google.com → buat project baru (gratis).
3. **APIs & Services → OAuth consent screen** → pilih **External** → isi nama
   aplikasi & email → Save (cukup sampai bisa lanjut; mode "Testing" tidak apa-apa).
4. **APIs & Services → Credentials → Create Credentials → OAuth client ID**:
   - Application type: **Web application**
   - **Authorized redirect URIs** → tempel **Callback URL** dari langkah 4.1.
   - **Create** → muncul **Client ID** & **Client Secret** → salin keduanya.
5. Kembali ke Supabase (Google provider) → tempel **Client ID** & **Client Secret**
   → **Save**.
6. Di Supabase: **Authentication → URL Configuration**:
   - **Site URL**: `https://yudventure.github.io/baserbinikah/`
   - **Redirect URLs** → tambahkan juga `https://yudventure.github.io/baserbinikah/`
   (penting agar setelah login Google kembali ke situs dengan benar).

> Email/Password sudah aktif otomatis. Jika ingin login instan tanpa verifikasi
> email, di **Authentication → Providers → Email** matikan "Confirm email".

## Langkah 5 — Masukkan kunci ke aplikasi
Di file `index.html`, cari dua baris di dekat atas blok `cloud.jsx`:

```js
const SUPABASE_URL = "PASTE_SUPABASE_URL_HERE";
const SUPABASE_ANON_KEY = "PASTE_SUPABASE_ANON_KEY_HERE";
```

Ganti dengan nilai dari Langkah 3, lalu simpan & deploy ulang (push ke GitHub).
**Atau** cukup kirim 2 nilai itu ke asisten — biar dia yang memasang & deploy.

---

## Selesai 🎉
Setelah kunci terpasang, membuka situs akan menampilkan layar **login** (Google +
email/password). Data tiap akun tersimpan di awan dan otomatis sinkron antar
perangkat.

### Catatan keamanan
- **anon key boleh tampil publik** di front-end — keamanan dijaga oleh aturan RLS
  di `schema.sql`. **Jangan** pernah memakai `service_role` key di sini.
- Jika kunci belum diisi, situs tetap berfungsi normal (data di browser saja).
