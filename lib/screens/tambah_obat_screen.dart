import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/obat.dart';
import '../utils/format.dart';

class TambahObatScreen extends StatefulWidget {
  final List<String> namaObatTerdaftar;

  const TambahObatScreen({super.key, required this.namaObatTerdaftar});

  @override
  State<TambahObatScreen> createState() => _TambahObatScreenState();
}

class _TambahObatScreenState extends State<TambahObatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaController = TextEditingController();
  String _kategori = kategoriObat.first;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _namaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  String? _validasiNama(String? value) {
    final nama = value?.trim() ?? '';
    if (nama.isEmpty) return 'Nama obat wajib diisi';
    if (nama.length < 3) return 'Nama obat minimal 3 karakter';
    final sudahAda = widget.namaObatTerdaftar.any(
      (n) => n.toLowerCase() == nama.toLowerCase(),
    );
    if (sudahAda) return 'Obat "$nama" sudah terdaftar';
    return null;
  }

  String? _validasiStok(String? value) {
    final stok = int.tryParse(value ?? '');
    if (stok == null) return 'Stok wajib diisi';
    if (stok <= 0) return 'Stok harus lebih dari 0';
    if (stok > 10000) return 'Stok maksimal 10.000';
    return null;
  }

  String? _validasiHarga(String? value) {
    final harga = int.tryParse(value ?? '');
    if (harga == null) return 'Harga wajib diisi';
    if (harga < 100) return 'Harga minimal Rp 100';
    return null;
  }

  Future<void> _simpan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data belum valid, periksa kembali form'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSaving = false);

    final obatBaru = Obat(
      nama: _namaController.text.trim(),
      kategori: _kategori,
      stok: int.parse(_stokController.text),
      harga: int.parse(_hargaController.text),
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 56),
        title: const Text('Obat berhasil ditambahkan!'),
        content: Text(
          '${obatBaru.nama} (${obatBaru.kategori})\n'
          'Stok: ${obatBaru.stok} • ${formatRupiah(obatBaru.harga)}',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;

    Navigator.pop(context, obatBaru);
  }

  @override
  Widget build(BuildContext context) {
    final namaTerisi = _namaController.text.trim().isNotEmpty;

    return PopScope(
      canPop: !_isSaving,
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Obat')),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                key: const Key('field_nama'),
                controller: _namaController,
                enabled: !_isSaving,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama obat',
                  hintText: 'contoh: Ibuprofen 400 mg',
                  prefixIcon: Icon(Icons.medication),
                ),
                validator: _validasiNama,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                ),
                items: kategoriObat
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _kategori = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('field_stok'),
                controller: _stokController,
                enabled: !_isSaving,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                validator: _validasiStok,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('field_harga'),
                controller: _hargaController,
                enabled: !_isSaving,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp)',
                  prefixIcon: Icon(Icons.payments),
                ),
                validator: _validasiHarga,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const Key('tombol_simpan'),
                onPressed: namaTerisi && !_isSaving ? _simpan : null,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
