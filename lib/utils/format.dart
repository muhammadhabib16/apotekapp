String formatRupiah(int nilai) {
  final angka = nilai.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < angka.length; i++) {
    if (i > 0 && (angka.length - i) % 3 == 0) buffer.write('.');
    buffer.write(angka[i]);
  }
  return 'Rp $buffer';
}
