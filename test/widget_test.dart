import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aquaguard/main.dart';

void main() {
  testWidgets('AquaGuard Kalkulator & Tracker Air Screen Smoke Test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build AquaGuardApp (specifying Tab 1: Tracker)
    await tester.pumpWidget(
      const AquaGuardApp(
        homeScreen: AquaGuardMainScaffold(initialIndex: 1),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Header & Title
    expect(find.text('AquaGuard'), findsOneWidget);
    expect(find.text('Kalkulator & Tracker Air'), findsOneWidget);
    expect(
      find.text('Catat kebiasaan harian & ukur efisiensi (SDG 6.4)'),
      findsOneWidget,
    );

    // Verify Time Tabs
    expect(find.text('Harian'), findsOneWidget);
    expect(find.text('Mingguan'), findsOneWidget);
    expect(find.text('Bulanan'), findsOneWidget);

    // Verify Estimation Summary Card
    expect(find.text('ESTIMASI PENGGUNAAN AIR'), findsOneWidget);
    expect(find.text('146'), findsOneWidget);
    expect(find.text('Liter / hari'), findsOneWidget);
    expect(find.text('Hemat vs Standar'), findsOneWidget);
    expect(find.text('Distribusi Pemakaian'), findsOneWidget);
    expect(find.text('100% Tercatat'), findsOneWidget);

    // Verify Presets
    expect(find.text('Simulasi Preset Cepat'), findsOneWidget);
    expect(find.text('Default Standar'), findsOneWidget);
    expect(find.text('Super Hemat (Eco)'), findsOneWidget);
    expect(find.text('Keluarga Mandiri'), findsOneWidget);
    expect(find.text('Reset Custom'), findsOneWidget);

    // Verify Personal Activities
    expect(find.text('Aktivitas Personal Harian'), findsOneWidget);
    expect(find.text('Mandi & Kebersihan Diri'), findsOneWidget);
    expect(find.text('Sanitasi & Toilet Flush'), findsOneWidget);
    expect(find.text('Dapur & Masak'), findsOneWidget);
    expect(find.text('Mencuci Pakaian'), findsOneWidget);

    // Verify SDG Target & Action Buttons
    expect(find.text('Sasaran SDG 6.4 Target'), findsOneWidget);
    expect(find.text('Simpan ke Log Harian'), findsOneWidget);
    expect(find.text('Lihat Analisis Potensi Hemat'), findsOneWidget);
  });

  testWidgets('AquaGuard Aksi & Kebiasaan Air Screen Smoke Test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build AquaGuardMainScaffold with initialIndex: 2 (Tab Aksi)
    await tester.pumpWidget(
      const MaterialApp(
        home: AquaGuardMainScaffold(initialIndex: 2),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Header & Title
    expect(find.text('AquaGuard'), findsOneWidget);
    expect(find.text('Aksi & Kebiasaan Air'), findsOneWidget);
    expect(
      find.text('Tindakan kecil harian untuk dampak nyata SDG 6'),
      findsOneWidget,
    );

    // Verify Weekly Savings Card
    expect(find.text('TOTAL HEMAT MINGGU INI'), findsOneWidget);
    expect(find.text('142'), findsOneWidget);
    expect(find.text('Liter'), findsOneWidget);

    // Verify Checklist Items
    expect(find.text('Checklist Aksi Harian'), findsOneWidget);
    expect(find.text('Tutup Keran Saat Sikat Gigi'), findsOneWidget);
    expect(find.text('Kurangi Shower 2 Menit'), findsOneWidget);
    expect(find.text('+ Tambah Aksi Mandiri'), findsOneWidget);
  });

  testWidgets('AquaGuard Dashboard Smoke Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build DashboardScreen directly
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify dashboard elements
    expect(find.text('AquaGuard'), findsOneWidget);
    expect(find.text('Status Kuota Air Hari Ini'), findsOneWidget);
    expect(find.text('112'), findsOneWidget);
    expect(find.text('/ 180 Liter'), findsOneWidget);
    expect(find.text('Hemat & Optimal'), findsOneWidget);
    expect(
      find.text('Tantangan Hari Ini: Kurangi 2 Menit Mandi Shower'),
      findsOneWidget,
    );
  });

  testWidgets('AquaGuard Edukasi & Target SDG 6 Screen Smoke Test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build AquaGuardMainScaffold with initialIndex: 3 (Tab Edukasi)
    await tester.pumpWidget(
      const MaterialApp(
        home: AquaGuardMainScaffold(initialIndex: 3),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Header & Title
    expect(find.text('AquaGuard'), findsOneWidget);
    expect(find.text('Edukasi & Target SDG 6'), findsOneWidget);
    expect(
      find.text('Pahami krisis global & target aksi nyata PBB'),
      findsOneWidget,
    );

    // Verify XP Badge
    expect(find.text('+120'), findsOneWidget);
    expect(find.text('XP'), findsOneWidget);

    // Verify Module Progress
    expect(find.text('Progres Modul Pembelajaran'), findsOneWidget);

    // Verify Global Mission Banner
    expect(find.text('MISI GLOBAL 2030'), findsOneWidget);
    expect(find.text('Akses Air Bersih & Sanitasi Berkelanjutan'), findsOneWidget);

    // Verify Modules Section
    expect(find.text('Bite-Sized Modul SDG 6'), findsOneWidget);
    expect(find.text('Mikro-Sesi 2–3 Menit'), findsOneWidget);

    // Verify module titles
    expect(find.text('Target 6.1: Air Minum Aman'), findsOneWidget);
    expect(find.text('Target 6.2: Sanitasi & Higienitas'), findsOneWidget);
    expect(find.text('Target 6.4: Efisiensi & Kelangkaan Air'), findsOneWidget);
    expect(find.text('Target 6.3: Pengolahan Air Limbah'), findsOneWidget);

    // Verify Flow Diagram Section
    expect(
      find.text('Diagram Alir Interaktif: Sanitasi Aman & Siklus Air'),
      findsOneWidget,
    );
    expect(find.text('Sumber Air Bersih'), findsOneWidget);
    expect(find.text('Penggunaan Domestik'), findsOneWidget);
    expect(find.text('Filtrasi / IPAL Komunal'), findsOneWidget);
    expect(find.text('Daur Ulang Resapan'), findsOneWidget);

    // Verify Quiz Section
    expect(find.text('Tantangan Kuis Kilat Hari Ini'), findsOneWidget);
    expect(find.text('+15 XP'), findsOneWidget);

    // Verify Download Card
    expect(find.text('Lembar Panduan SDG 6 Kampus'), findsOneWidget);
    expect(find.text('Simpan Lembar Panduan (PDF Mini)'), findsOneWidget);

    // Verify Bottom Navigation - 'Edukasi' label exists (active tab)
    expect(find.text('Edukasi'), findsWidgets);
  });

  testWidgets('AquaGuard Login & Autentikasi Screen Smoke Test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build AquaGuardApp with default LoginScreen
    await tester.pumpWidget(const AquaGuardApp());
    await tester.pumpAndSettle();

    // Verify Brand & Titles
    expect(find.text('AquaGuard'), findsOneWidget);
    expect(find.text('SDG 6'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar Akun'), findsOneWidget);
    expect(find.text('Selamat Datang Kembali! 👋'), findsOneWidget);
    expect(find.text('Alamat Email'), findsOneWidget);
    expect(find.text('Kata Sandi'), findsOneWidget);
    expect(find.text('Lupa sandi?'), findsOneWidget);
    expect(find.text('Ingat perangkat ini'), findsOneWidget);
    expect(find.text('100% Client-Side'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Masuk ke AquaGuard'), findsOneWidget);
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
    expect(find.text('Masuk Langsung sebagai Tamu (Mode Demo)'), findsOneWidget);

    // Test tab toggle to 'Daftar Akun'
    await tester.tap(find.text('Daftar Akun'));
    await tester.pumpAndSettle();
    expect(find.text('Buat Akun Baru! 🚀'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
    expect(find.text('Daftar ke AquaGuard'), findsOneWidget);

    // Test tap 'Daftar ke AquaGuard' navigates to Dashboard
    await tester.tap(find.text('Daftar ke AquaGuard'));
    await tester.pumpAndSettle();
    expect(find.text('Status Kuota Air Hari Ini'), findsOneWidget);
  });
}
