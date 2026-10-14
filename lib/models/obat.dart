class Obat {
  final String nama;
  final String kategori;
  final int stok;
  final int harga;

  const Obat({
    required this.nama,
    required this.kategori,
    required this.stok,
    required this.harga,
  });
}

const List<String> kategoriObat = ['Tablet', 'Kapsul', 'Sirup', 'Salep'];
