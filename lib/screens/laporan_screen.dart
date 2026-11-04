import 'package:flutter/material.dart';

import 'profile_screen.dart';

/// Halaman Laporan Konservasi Air (Water Conservation Report Screen)
/// Menampilkan analitik periodik (Harian, Mingguan, Bulanan), grafik pemakaian,
/// distribusi aktivitas konsumsi air, sertifikat konservasi, dan opsi unduh laporan.
class LaporanKonservasiAirScreen extends StatefulWidget {
  const LaporanKonservasiAirScreen({super.key});

  @override
  State<LaporanKonservasiAirScreen> createState() =>
      _LaporanKonservasiAirScreenState();
}

class _LaporanKonservasiAirScreenState extends State<LaporanKonservasiAirScreen> {
  // Periode terpilih: 0 = Harian, 1 = Mingguan (Default), 2 = Bulanan
  int _selectedPeriodIndex = 1;

  // Data Mingguan Terkalibrasi (7 Hari: Total 994 L, Rata-rata 142 L/hari, Hemat 266 L vs standar 180 L)
  final List<Map<String, dynamic>> _weeklyBars = [
    {'day': 'Sen', 'liters': 142, 'exceeds': false},
    {'day': 'Sel', 'liters': 135, 'exceeds': false},
    {'day': 'Rab', 'liters': 128, 'exceeds': false},
    {'day': 'Kam', 'liters': 112, 'exceeds': false, 'isBest': true},
    {'day': 'Jum', 'liters': 140, 'exceeds': false},
    {'day': 'Sab', 'liters': 160, 'exceeds': true},
    {'day': 'Min', 'liters': 177, 'exceeds': true},
  ];

  // Batas efisiensi harian (L/hari)
  static const int _targetLimit = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Tab Navigasi Waktu (Harian, Mingguan, Bulanan)
                _buildPeriodTabs(),

                const SizedBox(height: 14),

                // 2. Baris Tanggal & Cakupan Lokasi
                _buildDateAndScopeRow(),

                const SizedBox(height: 16),

                // 3. Hero Card Ringkasan Penghematan (Kartu Biru Tanpa Tombol Dobel)
                _buildHeroSavingsCard(),

                const SizedBox(height: 16),

                // 4. Grid 2x2 Metrik Cepat
                _buildQuickStatsGrid(),

                const SizedBox(height: 18),

                // 5. Grafik Pemakaian Mingguan
                _buildWeeklyUsageChartCard(),

                const SizedBox(height: 18),

                // 6. Distribusi Berdasarkan Aktivitas
                _buildActivityDistributionCard(),

                const SizedBox(height: 18),

                // 7. Kartu Sertifikat Konservasi
                _buildCertificateCard(),

                const SizedBox(height: 18),

                // 8. Banner Inspirasi Konservasi
                _buildInspirationBanner(),

                const SizedBox(height: 22),

                // 9. Tombol Aksi Bawah
                _buildBottomActionButtons(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 1. Top App Bar
  // ─────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 100,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF006296),
                  size: 18,
                ),
                SizedBox(width: 2),
                Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF006296),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: const Text(
        'Laporan Air',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
          letterSpacing: -0.2,
        ),
      ),
      actions: [
        // Lencana Poin (850 pts)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBAE6FD), width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.water_drop, color: Color(0xFF0284C7), size: 14),
              SizedBox(width: 4),
              Text(
                '850 pts',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF006296),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Avatar Pengguna
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF006296),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 2. Tab Navigasi Waktu (Harian, Mingguan, Bulanan)
  // ─────────────────────────────────────────────────────────
  Widget _buildPeriodTabs() {
    final periods = ['Harian', 'Mingguan', 'Bulanan'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = _selectedPeriodIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedPeriodIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF006296) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF006296).withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    periods[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 3. Baris Tanggal & Cakupan Lokasi
  // ─────────────────────────────────────────────────────────
  Widget _buildDateAndScopeRow() {
    String dateRange;
    switch (_selectedPeriodIndex) {
      case 0:
        dateRange = 'Hari Ini, 23 Okt 2024';
        break;
      case 2:
        dateRange = '1 - 31 Okt 2024';
        break;
      case 1:
      default:
        dateRange = '17 - 23 Okt 2024';
        break;
    }

    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 13,
          color: Color(0xFF64748B),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            dateRange,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          '•',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
        const SizedBox(width: 4),
        const Flexible(
          child: Text(
            'Rumah / Kos Saya',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBAE6FD), width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF0284C7),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Catatan Mandiri',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 4. Hero Card Ringkasan Penghematan (Kartu Biru)
  // ─────────────────────────────────────────────────────────
  Widget _buildHeroSavingsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF006296),
            Color(0xFF0284C7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006296).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Badge Kategori + Streak Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Kategori A
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'KATEGORI A • ECO HERO',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Streak Box
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFFDBA74),
                      size: 20,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Hari Streak',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE2E8F0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Judul Utama & Subteks Penghematan
          const Text(
            'Penghematan Optimal!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Rata-rata 142 L/hari (38L lebih hemat dari standar 180L).',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE0F2FE),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),

          // 2 Metrik Pill: Air Dihemat (266L) & Hemat PDAM (Rp 18.500)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Air Dihemat',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFBAE6FD),
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              '266 L (7 hari)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Hemat PDAM',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFBAE6FD),
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Rp 18.500',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 5. Grid 2x2 Metrik Cepat
  // ─────────────────────────────────────────────────────────
  Widget _buildQuickStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Pemakaian',
                value: '994',
                unit: 'Liter',
                badgeText: '-21% Sangat Hemat',
                badgeColor: const Color(0xFF0284C7),
                badgeBg: const Color(0xFFE0F2FE),
                icon: Icons.water_damage_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Air Diselamatkan',
                value: '266',
                unit: 'Liter',
                badgeText: 'Setara 7 hari air minum keluarga.',
                badgeColor: const Color(0xFF64748B),
                isSubtextOnly: true,
                icon: Icons.send_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Eco-Points',
                value: '+120',
                unit: 'pts',
                badgeText: 'Saldo total: 850 pts',
                badgeColor: const Color(0xFF64748B),
                isSubtextOnly: true,
                icon: Icons.workspace_premium_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Hemat Bulanan',
                value: '1.420',
                unit: 'L',
                badgeText: '📈 +14% di atas target',
                badgeColor: const Color(0xFF0284C7),
                isSubtextOnly: true,
                icon: Icons.trending_up_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required String badgeText,
    required Color badgeColor,
    Color? badgeBg,
    bool isSubtextOnly = false,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F8FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF0284C7), size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isSubtextOnly)
            Text(
              badgeText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: badgeColor,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: badgeBg ?? const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: badgeColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 6. Grafik Pemakaian Mingguan
  // ─────────────────────────────────────────────────────────
  Widget _buildWeeklyUsageChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul & Chip Hari Paling Hemat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Grafik Pemakaian Mingguan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Batas efisiensi mandiri: 150 L/hari',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.water_drop, color: Color(0xFF0284C7), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Kam: 112L (Paling Hemat)',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF006296),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Komponen Batang Grafik Kustom (7 Hari)
          _buildCustomBarChart(),

          const SizedBox(height: 16),

          // Legenda Grafik (Di Bawah Batas Target vs Melebihi Target Harian)
          Row(
            children: [
              _buildLegendItem(
                color: const Color(0xFF0284C7),
                label: 'Di Bawah Batas Target',
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildLegendItem(
                  color: const Color(0xFF1E3A5F),
                  label: 'Melebihi Target Harian (150 L)',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBarChart() {
    const double chartHeight = 160.0;
    const double maxCapacity = 200.0; // Kapasitas skala maksimum (L)
    final double targetLineBottom = (chartHeight * (_targetLimit / maxCapacity));

    return SizedBox(
      height: chartHeight + 46, // ruang ekstra untuk label atas & bawah
      child: Stack(
        children: [
          // Garis horizontal putus-putus target 150 L
          Positioned(
            left: 0,
            right: 0,
            bottom: targetLineBottom + 26,
            child: Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxWidth = constraints.constrainWidth();
                      const dashWidth = 5.0;
                      const dashSpace = 4.0;
                      final dashCount =
                          (boxWidth / (dashWidth + dashSpace)).floor();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return const SizedBox(
                            width: dashWidth,
                            height: 1.2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFF94A3B8)),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006296),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '150 L',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 7 Bar Batang Pemakaian
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _weeklyBars.map((bar) {
                final int liters = bar['liters'] as int;
                final bool exceeds = bar['exceeds'] as bool;
                final bool isBest = (bar['isBest'] as bool?) ?? false;
                final String day = bar['day'] as String;

                final double barH = (liters / maxCapacity) * chartHeight;
                final Color barColor = exceeds
                    ? const Color(0xFF1E3A5F) // Navy tua untuk akhir pekan melebihi target
                    : const Color(0xFF0284C7); // Biru cyan untuk hemat di bawah target

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Angka Liter di Atas Batang
                        Text(
                          '$liters',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isBest
                                ? FontWeight.w900
                                : FontWeight.w700,
                            color: isBest
                                ? const Color(0xFF0284C7)
                                : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Batang Visual
                        Container(
                          height: barH,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: barColor.withValues(alpha: 0.22),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Nama Hari di Bawah Batang
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isBest
                                ? FontWeight.w900
                                : FontWeight.w700,
                            color: isBest
                                ? const Color(0xFF006296)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 7. Distribusi Berdasarkan Aktivitas
  // ─────────────────────────────────────────────────────────
  Widget _buildActivityDistributionCard() {
    final activities = [
      {
        'title': 'Mandi & Shower',
        'percent': 49,
        'liters': 69,
        'icon': Icons.shower_outlined,
        'color': const Color(0xFF006296),
      },
      {
        'title': 'Sanitasi & Toilet',
        'percent': 17,
        'liters': 24,
        'icon': Icons.wc_rounded,
        'color': const Color(0xFF0284C7),
      },
      {
        'title': 'Dapur & Masak',
        'percent': 20,
        'liters': 28,
        'icon': Icons.soup_kitchen_outlined,
        'color': const Color(0xFF38BDF8),
      },
      {
        'title': 'Cuci Pakaian & Lainnya',
        'percent': 14,
        'liters': 20,
        'icon': Icons.local_laundry_service_outlined,
        'color': const Color(0xFF94A3B8),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Aktivitas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  'Distribusi Berdasarkan Aktivitas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.pie_chart_outline_rounded,
                color: Color(0xFF006296),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Rata-rata 142 Liter / hari',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 16),

          // Daftar 4 Aktivitas
          ...activities.map((item) {
            final String title = item['title'] as String;
            final int percent = item['percent'] as int;
            final int liters = item['liters'] as int;
            final IconData icon = item['icon'] as IconData;
            final Color barColor = item['color'] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, size: 15, color: const Color(0xFF0284C7)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Teks persentase dan liter berada dalam satu baris utuh
                      Text(
                        '$percent% ($liters L)',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percent / 100.0,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 4),

          // Kotak Wawasan Cerdas
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBAE6FD), width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFF0284C7),
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Wawasan Cerdas: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF006296),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Mandi menyumbang efisiensi tertinggi minggu ini berkat pemangkasan durasi sebesar 2 menit!',
                          style: TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 8. Kartu Sertifikat Konservasi
  // ─────────────────────────────────────────────────────────
  Widget _buildCertificateCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Ikon Penghargaan + Misi + Judul
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kotak biru muda berisi ikon medali/penghargaan
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFF0284C7),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Misi Hemat Air Bersih',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0284C7),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('•', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Efisiensi Air',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Sertifikat Konservasi Minggu Ke-4',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Teks Keterangan Sertifikat
          const Text(
            'Selamat! Kamu memenuhi seluruh kriteria kelestarian lingkungan minggu ini. Rapor lengkap siap diverifikasi.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          // 2 Kotak Status Evaluasi & Estimasi Hemat
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.shield_outlined,
                              color: Color(0xFF0284C7), size: 14),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Status Evaluasi',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Kategori A (Eco Hero)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF006296),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.savings_outlined,
                              color: Color(0xFF0284C7), size: 14),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Estimasi Hemat Biaya',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Rp 18.500',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Baris Identitas Nama & ID Sertifikat (Terbaca Utuh)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: Color(0xFF0284C7),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Farhan Pratama',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: const Text(
                    'ID: AQ-2024-W42-892',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Tombol Buka Rapor Penuh (Full-Width) di Posisi Bawah
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _showDetailedReportModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006296),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Buka Rapor Konservasi Lengkap',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 9. Banner Inspirasi Konservasi
  // ─────────────────────────────────────────────────────────
  Widget _buildInspirationBanner() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF064E3B),
                Color(0xFF047857),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar latar / visual tetesan daun
              Stack(
                children: [
                  Image.asset(
                    'assets/images/kampus_hijau.jpg',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: const Color(0xFF065F46),
                        child: const Center(
                          child: Icon(
                            Icons.eco_rounded,
                            size: 44,
                            color: Color(0xFF6EE7B7),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 12,
                    right: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Inspirasi Konservasi',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Menjaga Sumber Mata Air Masa Depan',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Caption Tautan Artikel
              InkWell(
                onTap: _showArticleModal,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Baca 3 langkah mudah instalasi aerator kran.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                      Text(
                        'Baca >',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 10. Tombol Aksi Bawah
  // ─────────────────────────────────────────────────────────
  Widget _buildBottomActionButtons() {
    return Column(
      children: [
        // Tombol 1: Unduh Laporan Hemat Air (PDF)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF006296),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Laporan Hemat Air (PDF) berhasil diunduh ke memori perangkat!',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
            label: const Text(
              'Unduh Laporan Hemat Air (PDF)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006296),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Tombol 2: Bagikan Pencapaian ke Media Sosial
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF0284C7),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: const Text(
                    'Pencapaian berhasil disalin untuk dibagikan ke Media Sosial! 💧',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.share_outlined,
                color: Color(0xFF0284C7), size: 19),
            label: const Text(
              'Bagikan Pencapaian ke Media Sosial',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7),
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFF0F9FF),
              side: const BorderSide(color: Color(0xFFBAE6FD), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Tombol 3: Tukar Poin Konservasi di Shop
        TextButton(
          onPressed: _showShopModal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.card_giftcard_rounded,
                color: Color(0xFF0284C7),
                size: 18,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Tukar Poin Konservasi di Shop (850 pts)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: Color(0xFF0284C7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // Modal Rapor Lengkap
  // ─────────────────────────────────────────────────────────
  void _showDetailedReportModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F2FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF0284C7),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Rapor Konservasi Mingguan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Periode 17 - 23 Okt 2024 • ID: AQ-2024-W42-892',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),

                _buildRaporDetailRow('Total Konsumsi Air:', '994 Liter (7 Hari)'),
                _buildRaporDetailRow('Rata-rata Harian:', '142 L/hari (Target 150 L)'),
                _buildRaporDetailRow('Efisiensi vs Normal:', '266 L Dihemat (Standar 180L)'),
                _buildRaporDetailRow('Status Predikat:', 'Kategori A (Eco Hero)'),
                _buildRaporDetailRow('Kepatuhan Target SDG 6.4:', '100% Memenuhi Standar'),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006296),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Tutup Rapor',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRaporDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Modal Artikel
  // ─────────────────────────────────────────────────────────
  void _showArticleModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '3 Langkah Mudah Instalasi Aerator Kran',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Buka saringan kran lama menggunakan kunci pas atau tangan.\n'
                  '2. Pasang aerator hemat air bertipe swirl flow yang mampu mengurangi debit hingga 40% tanpa menurunkan tekanan rasa semprotan.\n'
                  '3. Kencangkan dan uji alirannya. Kamu telah menghemat rata-rata 6 Liter air per menit!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF334155),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006296),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Selesai Membaca',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // Modal Shop Tukar Poin
  // ─────────────────────────────────────────────────────────
  void _showShopModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tukar Poin Konservasi (Shop)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Saldo Poin Kamu: 850 pts',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.park_outlined, color: Color(0xFF0284C7)),
                  ),
                  title: const Text(
                    '1 Bibit Mangrove Konservasi',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Butuh 1.000 pts (Kurang 150 pts lagi)'),
                  trailing: const Text(
                    'Kunci',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.water_drop, color: Color(0xFF16A34A)),
                  ),
                  title: const Text(
                    'Aerator Kran Hemat Air 40%',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Tukar 600 pts'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voucher Aerator Kran berhasil diklaim! 🎉'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006296),
                      minimumSize: const Size(60, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Klaim', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
