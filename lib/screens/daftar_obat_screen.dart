import 'package:flutter/material.dart';

import '../models/obat.dart';
import '../utils/format.dart';
import 'tambah_obat_screen.dart';

class DaftarObatScreen extends StatefulWidget {
  const DaftarObatScreen({super.key});

  @override
  State<DaftarObatScreen> createState() => _DaftarObatScreenState();
}

class _DaftarObatScreenState extends State<DaftarObatScreen> {
  final List<Obat> _daftarObat = [
    Obat(
      nama: 'Paracetamol 500 mg',
      kategori: 'Tablet',
      stok: 120,
      harga: 5000,
    ),
    Obat(
      nama: 'Amoxicillin 500 mg',
      kategori: 'Kapsul',
      stok: 60,
      harga: 12000,
    ),
    Obat(nama: 'OBH Combi', kategori: 'Sirup', stok: 25, harga: 18500),
  ];

  Obat? _obatBaru;

  Future<void> _bukaFormTambahObat() async {
    final Obat? hasil = await Navigator.push<Obat>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahObatScreen(
          namaObatTerdaftar: _daftarObat.map((obat) => obat.nama).toList(),
        ),
      ),
    );

    if (!mounted) return;

    if (hasil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penambahan obat dibatalkan')),
      );
      return;
    }

    setState(() {
      _daftarObat.insert(0, hasil);
      _obatBaru = hasil;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${hasil.nama} masuk ke daftar obat')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Obat'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Total ${_daftarObat.length} obat',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: _daftarObat.isEmpty
                ? const Center(child: Text('Belum ada obat'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: _daftarObat.length,
                    itemBuilder: (context, index) {
                      final obat = _daftarObat[index];
                      return _ObatCard(
                        obat: obat,
                        isBaru: identical(obat, _obatBaru),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambahObat,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Obat'),
      ),
    );
  }
}

class _ObatCard extends StatelessWidget {
  final Obat obat;
  final bool isBaru;

  const _ObatCard({required this.obat, required this.isBaru});

  IconData get _ikonKategori {
    switch (obat.kategori) {
      case 'Kapsul':
        return Icons.medication;
      case 'Sirup':
        return Icons.local_drink;
      case 'Salep':
        return Icons.healing;
      default:
        return Icons.medication_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isBaru ? colors.secondaryContainer : null,
      child: ListTile(
        leading: CircleAvatar(child: Icon(_ikonKategori)),
        title: Row(
          children: [
            Flexible(child: Text(obat.nama, overflow: TextOverflow.ellipsis)),
            if (isBaru) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Baru',
                  style: TextStyle(color: colors.onPrimary, fontSize: 11),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text('${obat.kategori} • Stok ${obat.stok}'),
        trailing: Text(
          formatRupiah(obat.harga),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
