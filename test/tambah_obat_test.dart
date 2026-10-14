import 'package:apotekapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> bukaForm(WidgetTester tester) async {
  await tester.pumpWidget(const ApotekApp());
  await tester.tap(find.text('Tambah Obat'));
  await tester.pumpAndSettle();
}

Future<void> tapSimpan(WidgetTester tester) async {
  final tombol = find.byKey(const Key('tombol_simpan'));
  await tester.ensureVisible(tombol);
  await tester.tap(tombol);
  await tester.pump();
}

void main() {
  testWidgets('tombol Simpan nonaktif selama nama kosong', (tester) async {
    await bukaForm(tester);

    ButtonStyleButton tombol() => tester.widget<ButtonStyleButton>(
      find.byKey(const Key('tombol_simpan')),
    );
    expect(tombol().onPressed, isNull);

    await tester.enterText(find.byKey(const Key('field_nama')), 'Ibuprofen');
    await tester.pump();
    expect(tombol().onPressed, isNotNull);
  });

  testWidgets('input tidak valid ditolak dan user tetap di form', (
    tester,
  ) async {
    await bukaForm(tester);

    await tester.enterText(
      find.byKey(const Key('field_nama')),
      'paracetamol 500 mg',
    );
    await tester.enterText(find.byKey(const Key('field_stok')), '0');
    await tapSimpan(tester);

    expect(
      find.text('Obat "paracetamol 500 mg" sudah terdaftar'),
      findsOneWidget,
    );
    expect(find.text('Stok harus lebih dari 0'), findsOneWidget);
    expect(find.text('Harga wajib diisi'), findsOneWidget);
    expect(find.text('Data belum valid, periksa kembali form'), findsOneWidget);
    expect(find.text('Tambah Obat'), findsOneWidget);
  });

  testWidgets('input valid: loading, dialog sukses, kembali ke daftar', (
    tester,
  ) async {
    await bukaForm(tester);

    await tester.enterText(
      find.byKey(const Key('field_nama')),
      'Ibuprofen 400 mg',
    );
    await tester.enterText(find.byKey(const Key('field_stok')), '50');
    await tester.enterText(find.byKey(const Key('field_harga')), '8000');

    await tapSimpan(tester);
    expect(find.text('Menyimpan...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Obat berhasil ditambahkan!'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Daftar Obat'), findsOneWidget);
    expect(find.text('Total 4 obat'), findsOneWidget);
    expect(find.text('Ibuprofen 400 mg'), findsOneWidget);
    expect(find.text('Baru'), findsOneWidget);
    expect(find.text('Ibuprofen 400 mg masuk ke daftar obat'), findsOneWidget);
  });
}
