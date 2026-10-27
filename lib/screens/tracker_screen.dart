import 'package:flutter/material.dart';
import 'profile_screen.dart';

/// Halaman Mandiri "Kalkulator & Tracker Air" (Tab Tracker) - AquaGuard
/// Pure Mobile UI & Local State dengan StatefulWidget berbasis SDG 6.4.
class KalkulatorTrackerAirScreen extends StatefulWidget {
  final VoidCallback? onNavigateToBeranda;
  final Function(int)? onBottomNavTap;
  final int currentNavIndex;

  const KalkulatorTrackerAirScreen({
    super.key,
    this.onNavigateToBeranda,
    this.onBottomNavTap,
    this.currentNavIndex = 1,
  });

  @override
  State<KalkulatorTrackerAirScreen> createState() =>
      _KalkulatorTrackerAirScreenState();
}

class _KalkulatorTrackerAirScreenState
    extends State<KalkulatorTrackerAirScreen> {
  // Tab Navigasi Waktu: 0 = Harian, 1 = Mingguan, 2 = Bulanan
  int _selectedTimeTab = 0;
  final List<String> _timeTabs = ['Harian', 'Mingguan', 'Bulanan'];

  // Preset Simulasi Cepat: 'default', 'eco', 'keluarga'
  String _selectedPreset = 'eco';

  // 1. Mandi & Kebersihan Diri
  double _mandiDurationMinutes = 6.0; // Slider (default 6 Menit)
  int _mandiFrequencyPerDay = 2; // Counter (- 2 +)
  final double _showerRateLitersPerMinute = 6.0; // Aerator standar: 6L/menit

  // 2. Sanitasi & Toilet Flush
  int _toiletFlushCount = 4; // Counter (- 4 +)
  bool _isEcoFlush = true; // Eco (6L) vs Full (9L)

  // 3. Dapur & Masak
  int _dapurWashSessions = 3; // Counter (- 3 +)
  bool _useBaskomCuci = true; // Gunakan Baskom (10L/sesi) vs Mengalir (20L/sesi)

  // 4. Mencuci Pakaian
  int _cuciWeeklyLoads = 3; // 3x seminggu
  int _cuciDailyLiters = 20; // Rerata proporsi harian: 20 Liter / hari

  // Benchmark Standar Perkotaan (L/kapita/hari)
  final int _urbanBenchmarkLiters = 180;

  // Hitung liter per aktivitas
  int get _literMandi {
    return (_mandiDurationMinutes * _mandiFrequencyPerDay * _showerRateLitersPerMinute).round();
  }

  int get _literToilet {
    final int litersPerFlush = _isEcoFlush ? 6 : 9;
    return _toiletFlushCount * litersPerFlush;
  }

  int get _literDapur {
    final int litersPerSession = _useBaskomCuci ? 10 : 20;
    return _dapurWashSessions * litersPerSession;
  }

  int get _literCuci => _cuciDailyLiters;

  // Total Harian
  int get _totalDailyLiters {
    return _literMandi + _literToilet + _literDapur + _literCuci;
  }

  // Liter sesuai tab waktu yang dipilih
  int get _displayedLiters {
    if (_selectedTimeTab == 1) {
      return _totalDailyLiters * 7;
    } else if (_selectedTimeTab == 2) {
      return _totalDailyLiters * 30;
    }
    return _totalDailyLiters;
  }

  // Persentase distribusi pemakaian
  double get _pctMandi => _totalDailyLiters == 0 ? 0 : (_literMandi / _totalDailyLiters);
  double get _pctToilet => _totalDailyLiters == 0 ? 0 : (_literToilet / _totalDailyLiters);
  double get _pctDapur => _totalDailyLiters == 0 ? 0 : (_literDapur / _totalDailyLiters);
  double get _pctCuci => _totalDailyLiters == 0 ? 0 : (_literCuci / _totalDailyLiters);

  // Estimasi Biaya (PDAM rata-rata ~Rp 10/Liter)
  int get _estimatedCostDaily => _totalDailyLiters * 10;

  // Potensi Penghematan Air (L/hari)
  int get _potentialSavings {
    // Potensi jika shower 5 menit, flush eco, baskom cuci, dll.
    final int potential = (_totalDailyLiters - 108).clamp(0, 100);
    return potential > 0 ? potential : 38;
  }

  // Terapkan Preset Simulasi
  void _applyPreset(String presetKey) {
    setState(() {
      _selectedPreset = presetKey;
      if (presetKey == 'eco') {
        // Super Hemat (Eco) - Sesuai gambar
        _mandiDurationMinutes = 6.0;
        _mandiFrequencyPerDay = 2;
        _toiletFlushCount = 4;
        _isEcoFlush = true;
        _dapurWashSessions = 3;
        _useBaskomCuci = true;
        _cuciWeeklyLoads = 3;
        _cuciDailyLiters = 20;
      } else if (presetKey == 'default') {
        // Default Standar
        _mandiDurationMinutes = 8.0;
        _mandiFrequencyPerDay = 2;
        _toiletFlushCount = 5;
        _isEcoFlush = false;
        _dapurWashSessions = 3;
        _useBaskomCuci = false;
        _cuciWeeklyLoads = 4;
        _cuciDailyLiters = 26;
      } else if (presetKey == 'keluarga') {
        // Keluarga Mandiri
        _mandiDurationMinutes = 5.0;
        _mandiFrequencyPerDay = 3;
        _toiletFlushCount = 6;
        _isEcoFlush = true;
        _dapurWashSessions = 4;
        _useBaskomCuci = true;
        _cuciWeeklyLoads = 5;
        _cuciDailyLiters = 32;
      }
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          presetKey == 'eco'
              ? 'Preset Super Hemat (Eco) diaktifkan! Target hemat optimal.'
              : presetKey == 'default'
                  ? 'Preset Default Standar diaktifkan.'
                  : 'Preset Keluarga Mandiri diaktifkan.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF0F4C81),
      ),
    );
  }

  // Reset Custom
  void _resetCustom() {
    _applyPreset('eco');
  }

  // Dialog / Bottom Sheet Analisis Potensi Hemat
  void _showAnalysisModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      color: Color(0xFF0284C7),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analisis Potensi Hemat Air',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Peluang efisiensi berbasis panduan SDG 6.4',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAnalysisItem(
                icon: Icons.shower_outlined,
                title: 'Kurangi Durasi Mandi 1 Menit',
                saving: 'Potensi: ~12 Liter / hari',
                description: 'Memangkas 1 menit shower memangkas ~6L per mandi.',
              ),
              const SizedBox(height: 12),
              _buildAnalysisItem(
                icon: Icons.wc_rounded,
                title: 'Konsisten Gunakan Tombol Eco Flush',
                saving: 'Potensi: ~12 Liter / hari',
                description: 'Menghemat 3 Liter air pada setiap kali buang air kecil.',
              ),
              const SizedBox(height: 12),
              _buildAnalysisItem(
                icon: Icons.soup_kitchen_outlined,
                title: 'Rendam Cucian Piring di Baskom',
                saving: 'Potensi: ~14 Liter / hari',
                description: 'Menghindari keran mengalir terus-menerus saat sabun.',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4C81),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup Analisis',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalysisItem({
    required IconData icon,
    required String title,
    required String saving,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0284C7), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  saving,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Simpan ke Log Harian
  void _saveToDailyLog() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Berhasil disimpan ke Log Harian! Estimasi: $_totalDailyLiters L tercatat. 💧📋',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF059669),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header (AquaGuard, Beranda, Notifikasi, Avatar)
                  _buildTopAppBar(),
                  const SizedBox(height: 20),

                  // 2. Judul Utama & Subteks & Tombol Filter
                  _buildPageTitleHeader(),
                  const SizedBox(height: 16),

                  // 3. Tab Navigasi Waktu (Harian, Mingguan, Bulanan)
                  _buildTimeNavigationTabs(),
                  const SizedBox(height: 20),

                  // 4. Ringkasan Estimasi Penggunaan Air (Card Utama)
                  _buildEstimationSummaryCard(),
                  const SizedBox(height: 20),

                  // 5. Simulasi Preset Cepat (Default Standar, Super Hemat, Keluarga)
                  _buildQuickPresetSection(),
                  const SizedBox(height: 24),

                  // 6. Header Bagian: Aktivitas Personal Harian
                  _buildActivityListHeader(),
                  const SizedBox(height: 14),

                  // 7. Daftar Kartu Aktivitas
                  _buildCardMandi(),
                  const SizedBox(height: 14),
                  _buildCardToilet(),
                  const SizedBox(height: 14),
                  _buildCardDapur(),
                  const SizedBox(height: 14),
                  _buildCardCuci(),
                  const SizedBox(height: 20),

                  // 8. Kartu Informasi Sasaran SDG 6.4
                  _buildSdgTargetCard(),
                  const SizedBox(height: 22),

                  // 9. Tombol Aksi Bawah (Simpan & Analisis)
                  _buildBottomActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // 1. Top App Bar (AquaGuard, Beranda, Notifikasi, Avatar)
  Widget _buildTopAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/aquaguard_logo.png',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.water_drop, color: Color(0xFF0284C7)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'AquaGuard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F3B5F),
                    letterSpacing: -0.3,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.onNavigateToBeranda != null) {
                      widget.onNavigateToBeranda!();
                    } else if (widget.onBottomNavTap != null) {
                      widget.onBottomNavTap!(0);
                    }
                  },
                  child: const Text(
                    'Beranda',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1E293B),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak ada notifikasi baru untuk tracker.'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F3B5F),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Judul Utama & Subteks & Tombol Filter/Pengaturan
  Widget _buildPageTitleHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Kalkulator & Tracker Air',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Catat kebiasaan harian & ukur efisiensi (SDG 6.4)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Tombol filter / tune icon
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF0284C7),
              size: 22,
            ),
            padding: EdgeInsets.zero,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter & Preferensi Satuan: Liter / Kapita / Hari'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 3. Tab Navigasi Waktu (Harian, Mingguan, Bulanan)
  Widget _buildTimeNavigationTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(_timeTabs.length, (index) {
          final bool isSelected = _selectedTimeTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _timeTabs[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? const Color(0xFF0F4C81) : const Color(0xFF64748B),
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

  // 4. Ringkasan Estimasi Penggunaan Air (Card Utama)
  Widget _buildEstimationSummaryCard() {
    final int diffUnderBenchmark = _urbanBenchmarkLiters - _totalDailyLiters;
    final bool isUnder = diffUnderBenchmark >= 0;

    final String unitLabel = _selectedTimeTab == 0
        ? 'hari'
        : _selectedTimeTab == 1
            ? 'minggu'
            : 'bulan';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Baris: Label & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ESTIMASI PENGGUNAAN AIR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      size: 13,
                      color: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Hemat vs Standar',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Angka Besar: e.g. 146 Liter / hari
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_displayedLiters',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F4C81),
                  letterSpacing: -1.0,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Liter / $unitLabel',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Kotak Informasi Komparasi: e.g. "34L di bawah rata-rata perkotaan (180 L/kapita)"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isUnder ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUnder ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isUnder ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      isUnder ? Icons.check : Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF1E293B),
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: isUnder
                              ? '${diffUnderBenchmark}L di bawah '
                              : '${diffUnderBenchmark.abs()}L di atas ',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isUnder ? const Color(0xFF15803D) : const Color(0xFFB45309),
                          ),
                        ),
                        TextSpan(
                          text: 'rata-rata perkotaan ($_urbanBenchmarkLiters L/kapita).',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Baris Distribusi Pemakaian
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  'Distribusi Pemakaian',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '100% Tercatat',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Multi-Segment Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 8,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: (_pctMandi * 1000).toInt(),
                    child: Container(color: const Color(0xFF0F4C81)),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (_pctToilet * 1000).toInt(),
                    child: Container(color: const Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (_pctDapur * 1000).toInt(),
                    child: Container(color: const Color(0xFF38BDF8)),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (_pctCuci * 1000).toInt(),
                    child: Container(color: const Color(0xFF0E7490)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Legenda Distribusi (Bullet Points)
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _buildLegendDot(
                color: const Color(0xFF0F4C81),
                label: 'Mandi ${(_pctMandi * 100).round()}%',
              ),
              _buildLegendDot(
                color: const Color(0xFF0284C7),
                label: 'Toilet ${(_pctToilet * 100).round()}%',
              ),
              _buildLegendDot(
                color: const Color(0xFF38BDF8),
                label: 'Dapur ${(_pctDapur * 100).round()}%',
              ),
              _buildLegendDot(
                color: const Color(0xFF0E7490),
                label: 'Cuci ${(_pctCuci * 100).round()}%',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Baris Bawah: Biaya Estimasi & Potensi Penghematan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '~Rp ${_formatNumber(_estimatedCostDaily)} / hari',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_down_rounded,
                    size: 17,
                    color: Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Potensi: $_potentialSavings L/hari',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  // 5. Simulasi Preset Cepat
  Widget _buildQuickPresetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Simulasi Preset Cepat',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _resetCustom,
              child: const Text(
                'Reset Custom',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildPresetPill(
                keyName: 'default',
                label: 'Default Standar',
              ),
              const SizedBox(width: 8),
              _buildPresetPill(
                keyName: 'eco',
                label: 'Super Hemat (Eco)',
              ),
              const SizedBox(width: 8),
              _buildPresetPill(
                keyName: 'keluarga',
                label: 'Keluarga Mandiri',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetPill({required String keyName, required String label}) {
    final bool isSelected = _selectedPreset == keyName;

    return GestureDetector(
      onTap: () => _applyPreset(keyName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F4C81) : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F4C81).withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  // 6. Header Bagian: Aktivitas Personal Harian
  Widget _buildActivityListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          child: Text(
            'Aktivitas Personal Harian',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8),
        Text(
          'Ketuk untuk atur',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // 7. Aktivitas 1: Mandi & Kebersihan Diri
  Widget _buildCardMandi() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shower_outlined,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mandi & Kebersihan Diri',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Shower aerator standar',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_literMandi L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const Text(
                    'per hari',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Slider Durasi Mandi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Durasi Mandi:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_mandiDurationMinutes.toInt()} Menit',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F4C81),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: const Color(0xFF0F4C81),
              inactiveTrackColor: const Color(0xFFE0F2FE),
              thumbColor: const Color(0xFF0F4C81),
              overlayColor: const Color(0xFF0F4C81).withValues(alpha: 0.15),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _mandiDurationMinutes,
              min: 2,
              max: 15,
              divisions: 13,
              onChanged: (val) {
                setState(() {
                  _mandiDurationMinutes = val;
                });
              },
            ),
          ),

          // Frekuensi per Hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Frekuensi per Hari:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_mandiFrequencyPerDay > 1) {
                        setState(() => _mandiFrequencyPerDay--);
                      }
                    },
                    isPrimary: false,
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      '$_mandiFrequencyPerDay',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    onTap: () {
                      if (_mandiFrequencyPerDay < 5) {
                        setState(() => _mandiFrequencyPerDay++);
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tips Box
          _buildTipBox(
            icon: Icons.lightbulb_outline_rounded,
            text: 'Hemat ~12L jika kurangi durasi mandi 1 menit saja.',
          ),
        ],
      ),
    );
  }

  // 7. Aktivitas 2: Sanitasi & Toilet Flush
  Widget _buildCardToilet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.wc_rounded,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Sanitasi & Toilet Flush',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Dual-flush system',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_literToilet L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const Text(
                    'per hari',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Bilas / Flush per Hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Bilas / Flush per Hari:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_toiletFlushCount > 1) {
                        setState(() => _toiletFlushCount--);
                      }
                    },
                    isPrimary: false,
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      '$_toiletFlushCount',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    onTap: () {
                      if (_toiletFlushCount < 10) {
                        setState(() => _toiletFlushCount++);
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Jenis Katup (Eco 6L vs Full 9L)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Jenis Katup:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isEcoFlush = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isEcoFlush ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _isEcoFlush
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          'Eco (6L)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: _isEcoFlush ? FontWeight.w800 : FontWeight.w600,
                            color: _isEcoFlush ? const Color(0xFF0F4C81) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isEcoFlush = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: !_isEcoFlush ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: !_isEcoFlush
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          'Full (9L)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: !_isEcoFlush ? FontWeight.w800 : FontWeight.w600,
                            color: !_isEcoFlush ? const Color(0xFF0F4C81) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tips Box
          _buildTipBox(
            icon: Icons.info_outline_rounded,
            text: 'Tombol kecil menghemat 33% air per pembilasan.',
          ),
        ],
      ),
    );
  }

  // 7. Aktivitas 3: Dapur & Masak
  Widget _buildCardDapur() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dapur & Masak',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Cuci piring & olah bahan',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_literDapur L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const Text(
                    'per hari',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sesi Cuci Piring
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Sesi Cuci Piring:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_dapurWashSessions > 1) {
                        setState(() => _dapurWashSessions--);
                      }
                    },
                    isPrimary: false,
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      '$_dapurWashSessions',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    onTap: () {
                      if (_dapurWashSessions < 8) {
                        setState(() => _dapurWashSessions++);
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Metode Pembilasan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Metode Pembilasan:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() => _useBaskomCuci = !_useBaskomCuci);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _useBaskomCuci
                        ? const Color(0xFFE0F2FE)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _useBaskomCuci
                          ? const Color(0xFFBAE6FD)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wash_outlined,
                        size: 15,
                        color: _useBaskomCuci ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _useBaskomCuci ? 'Gunakan Baskom' : 'Keran Mengalir',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: _useBaskomCuci ? const Color(0xFF0284C7) : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tips Box
          _buildTipBox(
            icon: Icons.check_rounded,
            text: 'Baskom memangkas debit air keran hingga 50%.',
          ),
        ],
      ),
    );
  }

  // 7. Aktivitas 4: Mencuci Pakaian
  Widget _buildCardCuci() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_laundry_service_outlined,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mencuci Pakaian',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Mesin cuci front load',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_literCuci L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const Text(
                    'per hari',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Beban Cuci Mingguan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Beban Cuci Mingguan:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_cuciWeeklyLoads}x seminggu (~45L/sesi)',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rerata proporsi harian
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Rerata proporsi harian:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_literCuci Liter / hari',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 8. Kartu Informasi Sasaran SDG 6.4
  Widget _buildSdgTargetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4C81),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.local_drink_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sasaran SDG 6.4 Target',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7DD3FC),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Meningkatkan efisiensi pemanfaatan air lintas sektor untuk mengantisipasi kelangkaan air.',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.95),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 9. Tombol Aksi Utama di Bagian Bawah
  Widget _buildBottomActionButtons() {
    return Column(
      children: [
        // Tombol Utama Biru Tua: "Simpan ke Log Harian"
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _saveToDailyLog,
            icon: const Icon(
              Icons.assignment_turned_in_outlined,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Simpan ke Log Harian',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F4C81),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Tombol Sekunder Biru Muda: "Lihat Analisis Potensi Hemat"
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _showAnalysisModal,
            icon: const Icon(
              Icons.insights_rounded,
              color: Color(0xFF0369A1),
              size: 20,
            ),
            label: const Text(
              'Lihat Analisis Potensi Hemat',
              style: TextStyle(
                color: Color(0xFF0369A1),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE0F2FE),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widget Stepper Button (+ / -)
  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF0F4C81) : const Color(0xFFE0F2FE),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: isPrimary ? Colors.white : const Color(0xFF0F4C81),
          ),
        ),
      ),
    );
  }

  // Helper Widget Tips Box
  Widget _buildTipBox({required IconData icon, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0F2FE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF0284C7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Format Angka
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // 10. Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    final int selectedIndex = widget.currentNavIndex;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (widget.onBottomNavTap != null) {
            widget.onBottomNavTap!(index);
          } else if (index == 0 && widget.onNavigateToBeranda != null) {
            widget.onNavigateToBeranda!();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0284C7),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 11.5,
        unselectedFontSize: 11.5,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_outlined),
            activeIcon: Icon(Icons.water_drop),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded),
            activeIcon: Icon(Icons.check_circle_rounded),
            label: 'Aksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Edukasi',
          ),
        ],
      ),
    );
  }
}
