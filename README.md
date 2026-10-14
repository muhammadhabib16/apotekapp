# Apotek App: Workflow Tambah Obat

Practical Challenge: *Build One Complete Workflow*.

Alur: **Input/Event → State → Validation → Feedback → Navigation/Result**

```
DaftarObatScreen ──(namaObatTerdaftar)──▶ TambahObatScreen
       ▲                                         │
       └────────────(Obat hasil)─────────────────┘
```

## Struktur file

| File | Isi |
|---|---|
| `lib/main.dart` | Entry point, tema, halaman awal |
| `lib/models/obat.dart` | Model `Obat` dan daftar kategori |
| `lib/screens/daftar_obat_screen.dart` | Halaman daftar obat (awal dan akhir workflow) |
| `lib/screens/tambah_obat_screen.dart` | Form tambah obat (state, validasi, feedback) |
| `lib/utils/format.dart` | Format Rupiah |
| `test/tambah_obat_test.dart` | Widget test untuk seluruh workflow |

## 1. Input / Event
- User menekan tombol **Tambah Obat** (FAB) → `_bukaFormTambahObat()`.
- Di form, user mengetik nama, stok, harga, dan memilih kategori (dropdown), lalu menekan **Simpan** → `_simpan()`.

## 2. State
- `DaftarObatScreen`: `_daftarObat` (list obat) dan `_obatBaru` (untuk label "Baru").
- `TambahObatScreen`: `TextEditingController` tiap field, `_kategori`, `_isSaving`.
- Semua perubahan memakai `setState()` supaya UI di-render ulang.

## 3. Validation
| Field | Tidak valid jika |
|---|---|
| Nama | kosong, kurang dari 3 karakter, atau **sudah terdaftar** (pakai data yang dikirim dari halaman daftar) |
| Stok | kosong, ≤ 0, atau > 10.000 |
| Harga | kosong atau < Rp 100 |

Cara aplikasi menangani input tidak valid:
- Tombol **Simpan nonaktif** selama nama masih kosong.
- `_formKey.currentState!.validate()` menolak aksi simpan, pesan error merah tampil di bawah field, dan user **tetap di form**.
- `AutovalidateMode.onUserInteraction` membuat error langsung muncul/hilang saat user mengetik.

## 4. Feedback
- **Gagal:** SnackBar merah "Data belum valid, periksa kembali form" + error per field.
- **Proses:** tombol berubah jadi spinner + "Menyimpan...", field dinonaktifkan, tombol back diblokir (`PopScope`).
- **Berhasil:** dialog "Obat berhasil ditambahkan!" berisi ringkasan data.
- **Batal:** jika user kembali tanpa menyimpan, muncul SnackBar "Penambahan obat dibatalkan".

## 5. Navigation / Result
- **Data dikirim ke screen berikutnya:** `TambahObatScreen(namaObatTerdaftar: ...)` lewat constructor.
- **Result dikembalikan:** `Navigator.pop(context, obatBaru)` → diterima oleh `await Navigator.push<Obat>(...)` di halaman daftar.
- Halaman daftar memasukkan obat ke `_daftarObat`, total bertambah, item baru tampil paling atas dengan label **Baru**, dan muncul SnackBar konfirmasi.

## Menjalankan
```bash
flutter run      # jalankan aplikasi
flutter test     # jalankan widget test workflow
```
