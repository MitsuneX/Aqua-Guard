import 'package:flutter/material.dart';

import '../services/points_manager.dart';
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

  // Preset Simulasi Cepat: 'default', 'eco', 'keluarga', 'custom'
  String _selectedPreset = 'eco';

  // State Progressive Disclosure (8 Golden Rules: Reduce Short-Term Memory Load)
  // -1 = Semua tertutup, 0 = Mandi, 1 = Toilet, 2 = Dapur, 3 = Cuci
  int _expandedActivityIndex = 0;
  bool _showDistributionDetail = false;

  // State Riwayat / Undo (8 Golden Rules: Permit Easy Reversal of Actions)
  Map<String, dynamic>? _previousStateSnapshot;

  // 1. Mandi & Kebersihan Diri
  double _mandiDurationMinutes = 6.0; // Slider (default 6 Menit)
  int _mandiFrequencyPerDay = 2; // Counter (- 2 +)
  final double _showerRateLitersPerMinute = 6.0; // Aerator standar: 6L/menit

  // 2. Sanitasi & Toilet Flush
  int _toiletFlushCount = 4; // Counter (- 4 +)
  bool _isEcoFlush = true; // Eco (6L) vs Full (9L)

  // 3. Dapur & Masak
  int _dapurWashSessions = 3; // Counter (- 3 +)
  bool _useBaskomCuci =
      true; // Gunakan Baskom (10L/sesi) vs Mengalir (20L/sesi)

  // 4. Mencuci Pakaian
  int _cuciWeeklyLoads = 3; // 3x seminggu
  int get _cuciDailyLiters => ((_cuciWeeklyLoads * 45) / 7).round();

  // Benchmark Standar Perkotaan (L/kapita/hari)
  final int _urbanBenchmarkLiters = 180;

  // Hitung liter per aktivitas
  int get _literMandi {
    return (_mandiDurationMinutes *
            _mandiFrequencyPerDay *
            _showerRateLitersPerMinute)
        .round();
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
  double get _pctMandi =>
      _totalDailyLiters == 0 ? 0 : (_literMandi / _totalDailyLiters);
  double get _pctToilet =>
      _totalDailyLiters == 0 ? 0 : (_literToilet / _totalDailyLiters);
  double get _pctDapur =>
      _totalDailyLiters == 0 ? 0 : (_literDapur / _totalDailyLiters);
  double get _pctCuci =>
      _totalDailyLiters == 0 ? 0 : (_literCuci / _totalDailyLiters);

  // Estimasi Biaya (PDAM rata-rata ~Rp 10/Liter)
  int get _estimatedCostDaily => _totalDailyLiters * 10;

  // Potensi Penghematan Air (L/hari) secara dinamis per aktivitas
  int get _savingMandi => _mandiDurationMinutes > 5
      ? ((_mandiDurationMinutes - 5) *
                _mandiFrequencyPerDay *
                _showerRateLitersPerMinute)
            .round()
      : 0;
  int get _savingToilet => !_isEcoFlush ? (_toiletFlushCount * 3) : 0;
  int get _savingDapur => !_useBaskomCuci ? (_dapurWashSessions * 10) : 0;

  int get _potentialSavings {
    final int dynamicTotal = _savingMandi + _savingToilet + _savingDapur;
    return dynamicTotal > 0 ? dynamicTotal : 12;
  }

  // Simpan snapshot sebelum modifikasi (8 Golden Rules: Permit Easy Reversal of Actions)
  void _saveSnapshot() {
    _previousStateSnapshot = {
      'preset': _selectedPreset,
      'mandiDuration': _mandiDurationMinutes,
      'mandiFreq': _mandiFrequencyPerDay,
      'toiletFlush': _toiletFlushCount,
      'isEcoFlush': _isEcoFlush,
      'dapurSessions': _dapurWashSessions,
      'useBaskom': _useBaskomCuci,
      'cuciLoads': _cuciWeeklyLoads,
    };
  }

  void _restoreSnapshot() {
    if (_previousStateSnapshot == null) return;
    setState(() {
      _selectedPreset = _previousStateSnapshot!['preset'];
      _mandiDurationMinutes = _previousStateSnapshot!['mandiDuration'];
      _mandiFrequencyPerDay = _previousStateSnapshot!['mandiFreq'];
      _toiletFlushCount = _previousStateSnapshot!['toiletFlush'];
      _isEcoFlush = _previousStateSnapshot!['isEcoFlush'];
      _dapurWashSessions = _previousStateSnapshot!['dapurSessions'];
      _useBaskomCuci = _previousStateSnapshot!['useBaskom'];
      _cuciWeeklyLoads = _previousStateSnapshot!['cuciLoads'];
      _previousStateSnapshot = null;
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Perubahan berhasil dibatalkan (Undo).'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF334155),
      ),
    );
  }

  void _markAsCustom() {
    if (_selectedPreset != 'custom') {
      _selectedPreset = 'custom';
    }
  }

  // Terapkan Preset Simulasi
  void _applyPreset(String presetKey) {
    _saveSnapshot();
    setState(() {
      _selectedPreset = presetKey;
      if (presetKey == 'eco') {
        _mandiDurationMinutes = 6.0;
        _mandiFrequencyPerDay = 2;
        _toiletFlushCount = 4;
        _isEcoFlush = true;
        _dapurWashSessions = 3;
        _useBaskomCuci = true;
        _cuciWeeklyLoads = 3;
      } else if (presetKey == 'default') {
        _mandiDurationMinutes = 8.0;
        _mandiFrequencyPerDay = 2;
        _toiletFlushCount = 5;
        _isEcoFlush = false;
        _dapurWashSessions = 3;
        _useBaskomCuci = false;
        _cuciWeeklyLoads = 4;
      } else if (presetKey == 'keluarga') {
        _mandiDurationMinutes = 5.0;
        _mandiFrequencyPerDay = 3;
        _toiletFlushCount = 6;
        _isEcoFlush = true;
        _dapurWashSessions = 4;
        _useBaskomCuci = true;
        _cuciWeeklyLoads = 5;
      }
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          presetKey == 'eco'
              ? 'Preset Super Hemat (Eco) diterapkan.'
              : presetKey == 'default'
              ? 'Preset Default Standar diterapkan.'
              : 'Preset Keluarga Mandiri diterapkan.',
        ),
        action: SnackBarAction(
          label: 'BATAL',
          textColor: const Color(0xFF7DD3FC),
          onPressed: _restoreSnapshot,
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF0F4C81),
      ),
    );
  }

  // Reset Custom dengan Pencegahan Kesalahan & Undo
  void _resetCustom() {
    _applyPreset('eco');
  }

  // Terapkan rekomendasi langsung dari Modal Analisis (8 Golden Rules: Design Dialogs to Yield Closure)
  void _applyOptimalSettingsFromModal(BuildContext modalCtx) {
    _saveSnapshot();
    setState(() {
      _selectedPreset = 'eco';
      if (_mandiDurationMinutes > 5.0) _mandiDurationMinutes = 5.0;
      _isEcoFlush = true;
      _useBaskomCuci = true;
    });
    Navigator.pop(modalCtx);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Rekomendasi efisiensi diterapkan! Estimasi kini $_totalDailyLiters L/hari.',
        ),
        action: SnackBarAction(
          label: 'URUNGKAN',
          textColor: const Color(0xFFA7F3D0),
          onPressed: _restoreSnapshot,
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF059669),
      ),
    );
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Analisis Potensi Hemat Air',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Total potensi efisiensi: ~$_potentialSavings Liter / hari (~Rp ${_formatNumber(_estimatedCostDaily)}/hari)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildAnalysisItem(
                icon: Icons.shower_outlined,
                title: 'Durasi Mandi Ideal (5 Menit)',
                saving: _savingMandi > 0
                    ? 'Hemat ~$_savingMandi Liter / hari'
                    : 'Sudah Optimal (≤ 5 Menit)',
                description:
                    'Memangkas durasi shower mengurangi 6L air per menit.',
                isOptimal: _savingMandi == 0,
              ),
              const SizedBox(height: 10),
              _buildAnalysisItem(
                icon: Icons.wc_rounded,
                title: 'Mode Dual-Flush Eco (6L)',
                saving: _savingToilet > 0
                    ? 'Hemat ~$_savingToilet Liter / hari'
                    : 'Sudah Optimal (Mode Eco Aktif)',
                description: 'Menghemat 3 Liter air pada setiap pembilasan.',
                isOptimal: _savingToilet == 0,
              ),
              const SizedBox(height: 10),
              _buildAnalysisItem(
                icon: Icons.soup_kitchen_outlined,
                title: 'Bilas Piring dengan Baskom',
                saving: _savingDapur > 0
                    ? 'Hemat ~$_savingDapur Liter / hari'
                    : 'Sudah Optimal (Metode Baskom)',
                description:
                    'Memangkas 50% debit air dibanding keran mengalir.',
                isOptimal: _savingDapur == 0,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => _applyOptimalSettingsFromModal(ctx),
                      icon: const Icon(
                        Icons.auto_fix_high_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Terapkan Semua',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4C81),
                        minimumSize: const Size.fromHeight(46),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
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
    bool isOptimal = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOptimal ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOptimal ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isOptimal ? Icons.check_circle_rounded : icon,
            color: isOptimal
                ? const Color(0xFF16A34A)
                : const Color(0xFF0284C7),
            size: 20,
          ),
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
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isOptimal
                        ? const Color(0xFF15803D)
                        : const Color(0xFF0284C7),
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
    EcoPointsManager().addPoints(
      20,
      'Catat Log Harian Tracker Air ($_totalDailyLiters L)',
      category: 'misi',
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Berhasil disimpan ke Log Harian! Estimasi: $_totalDailyLiters L tercatat (+20 Poin). 💧📋',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
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
                  const SizedBox(height: 16),

                  // 5. Simulasi Preset Cepat (Default Standar, Super Hemat, Keluarga)
                  _buildQuickPresetSection(),
                  const SizedBox(height: 20),

                  // 6. Header Bagian: Aktivitas Personal Harian
                  _buildActivityListHeader(),
                  const SizedBox(height: 10),

                  // 7. Daftar Kartu Aktivitas (Accordion / Progressive Disclosure)
                  _buildCardMandi(),
                  const SizedBox(height: 10),
                  _buildCardToilet(),
                  const SizedBox(height: 10),
                  _buildCardDapur(),
                  const SizedBox(height: 10),
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
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/aquaguard_logo.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'AquaGuard',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F3B5F),
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pill Eco-Points Reaktif (💧 850 pts) -> Tekan untuk masuk Shop (Sesuai Gambar 3)
            const EcoPointsPillWidget(),
            const SizedBox(width: 6),

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1E293B),
                  size: 19,
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
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F3B5F),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 20),
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
                  content: Text(
                    'Filter & Preferensi Satuan: Liter / Kapita / Hari',
                  ),
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
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF0F4C81)
                          : const Color(0xFF64748B),
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

  // 4. Ringkasan Konsumsi dan Distribusi Air (Disederhanakan dengan Progressive Disclosure)
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
      padding: const EdgeInsets.all(16),
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
          // Header Ringkas + Status Benchmark Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'ESTIMASI PENGGUNAAN AIR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isUnder
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isUnder
                            ? const Color(0xFFBBF7D0)
                            : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUnder
                              ? Icons.check_circle_rounded
                              : Icons.warning_amber_rounded,
                          size: 13,
                          color: isUnder
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFD97706),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isUnder
                              ? 'Hemat ${diffUnderBenchmark}L vs Standar'
                              : '+${diffUnderBenchmark.abs()}L dari Standar',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isUnder
                                ? const Color(0xFF15803D)
                                : const Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Angka Utama & Shortcut Analisis Potensi Hemat
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$_displayedLiters',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F4C81),
                        letterSpacing: -1.0,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'L / $unitLabel',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: _showAnalysisModal,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_down_rounded,
                            size: 15,
                            color: Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Potensi -$_potentialSavings L',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0369A1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Multi-Segment Progress Bar Distribusi
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 8,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: (_pctMandi * 1000).toInt().clamp(1, 1000),
                    child: Container(color: const Color(0xFF0F4C81)),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (_pctToilet * 1000).toInt().clamp(1, 1000),
                    child: Container(color: const Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (_pctDapur * 1000).toInt().clamp(1, 1000),
                    child: Container(color: const Color(0xFF38BDF8)),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (_pctCuci * 1000).toInt().clamp(1, 1000),
                    child: Container(color: const Color(0xFF0E7490)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Toggle Progressive Disclosure untuk Detail Distribusi & Estimasi Biaya
          InkWell(
            onTap: () {
              setState(() {
                _showDistributionDetail = !_showDistributionDetail;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _showDistributionDetail
                          ? 'Sembunyikan rincian distribusi'
                          : 'Lihat rincian distribusi & estimasi biaya',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showDistributionDetail
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          // Detail Rincian yang hanya tampil saat diminta pengguna
          if (_showDistributionDetail) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildLegendDot(
                  color: const Color(0xFF0F4C81),
                  label: 'Mandi ${(_pctMandi * 100).round()}% ($_literMandi L)',
                ),
                _buildLegendDot(
                  color: const Color(0xFF0284C7),
                  label:
                      'Toilet ${(_pctToilet * 100).round()}% ($_literToilet L)',
                ),
                _buildLegendDot(
                  color: const Color(0xFF38BDF8),
                  label: 'Dapur ${(_pctDapur * 100).round()}% ($_literDapur L)',
                ),
                _buildLegendDot(
                  color: const Color(0xFF0E7490),
                  label: 'Cuci ${(_pctCuci * 100).round()}% ($_literCuci L)',
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Standar Perkotaan: $_urbanBenchmarkLiters L/kapita/hari',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  'Estimasi PDAM: ~Rp ${_formatNumber(_estimatedCostDaily)}/hari',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ],
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

  // 5. Simulasi Preset Cepat (Dilengkapi Indikator Kustom & Tombol Undo)
  Widget _buildQuickPresetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(
                    child: Text(
                      'Mode Simulasi Cepat',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_selectedPreset == 'custom') ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: const Text(
                        'Kustom',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_previousStateSnapshot != null) ...[
                  GestureDetector(
                    onTap: _restoreSnapshot,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.undo_rounded,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Undo',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                GestureDetector(
                  onTap: _resetCustom,
                  child: const Text(
                    'Reset Default',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ],
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
                keyName: 'eco',
                label: 'Super Hemat (146L)',
                icon: Icons.eco_outlined,
              ),
              const SizedBox(width: 8),
              _buildPresetPill(
                keyName: 'default',
                label: 'Standar (227L)',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(width: 8),
              _buildPresetPill(
                keyName: 'keluarga',
                label: 'Keluarga (198L)',
                icon: Icons.groups_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetPill({
    required String keyName,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedPreset == keyName;

    return GestureDetector(
      onTap: () => _applyPreset(keyName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F4C81) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F4C81)
                : const Color(0xFFE2E8F0),
          ),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. Header Bagian: Aktivitas Penggunaan Air
  Widget _buildActivityListHeader() {
    final bool isAnyExpanded = _expandedActivityIndex != -1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'Aktivitas Penggunaan Air',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedActivityIndex = isAnyExpanded ? -1 : 0;
            });
          },
          child: Text(
            isAnyExpanded ? 'Ringkas Semua' : 'Ketuk kartu untuk atur',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0284C7),
            ),
          ),
        ),
      ],
    );
  }

  // Wrapper Kartu Aktivitas dengan Pola Accordion (Mengatasi Information Overload)
  Widget _buildExpandableActivityCard({
    required int index,
    required IconData icon,
    required String title,
    required String summarySubtitle,
    required int liters,
    required Widget expandedContent,
  }) {
    final bool isExpanded = _expandedActivityIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
          width: isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isExpanded ? 0.04 : 0.015),
            blurRadius: isExpanded ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedActivityIndex = isExpanded ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? const Color(0xFF0F4C81)
                          : const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: isExpanded
                          ? Colors.white
                          : const Color(0xFF0284C7),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          summarySubtitle,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
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
                        '$liters L',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F4C81),
                        ),
                      ),
                      const Text(
                        '/ hari',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 12),
                  expandedContent,
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 7. Aktivitas 1: Mandi & Kebersihan Diri
  Widget _buildCardMandi() {
    return _buildExpandableActivityCard(
      index: 0,
      icon: Icons.shower_outlined,
      title: 'Mandi & Kebersihan Diri',
      summarySubtitle:
          '${_mandiDurationMinutes.toInt()} mnt × ${_mandiFrequencyPerDay}x sehari',
      liters: _literMandi,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Durasi Mandi (Shower 6L/mnt):',
                  style: TextStyle(
                    fontSize: 12,
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
              trackHeight: 5,
              activeTrackColor: const Color(0xFF0F4C81),
              inactiveTrackColor: const Color(0xFFE0F2FE),
              thumbColor: const Color(0xFF0F4C81),
              overlayColor: const Color(0xFF0F4C81).withValues(alpha: 0.12),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: _mandiDurationMinutes,
              min: 2,
              max: 15,
              divisions: 13,
              onChangeStart: (_) => _saveSnapshot(),
              onChanged: (val) {
                setState(() {
                  _mandiDurationMinutes = val;
                  _markAsCustom();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Frekuensi per Hari:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    enabled: _mandiFrequencyPerDay > 1,
                    onTap: () {
                      if (_mandiFrequencyPerDay > 1) {
                        _saveSnapshot();
                        setState(() {
                          _mandiFrequencyPerDay--;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: false,
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '$_mandiFrequencyPerDay',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    enabled: _mandiFrequencyPerDay < 5,
                    onTap: () {
                      if (_mandiFrequencyPerDay < 5) {
                        _saveSnapshot();
                        setState(() {
                          _mandiFrequencyPerDay++;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Aktivitas 2: Sanitasi & Toilet Flush
  Widget _buildCardToilet() {
    return _buildExpandableActivityCard(
      index: 1,
      icon: Icons.wc_rounded,
      title: 'Sanitasi & Toilet Flush',
      summarySubtitle:
          '${_toiletFlushCount}x bilas • ${_isEcoFlush ? "Eco (6L)" : "Full (9L)"}',
      liters: _literToilet,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Bilas / Flush per Hari:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    enabled: _toiletFlushCount > 1,
                    onTap: () {
                      if (_toiletFlushCount > 1) {
                        _saveSnapshot();
                        setState(() {
                          _toiletFlushCount--;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: false,
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '$_toiletFlushCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    enabled: _toiletFlushCount < 10,
                    onTap: () {
                      if (_toiletFlushCount < 10) {
                        _saveSnapshot();
                        setState(() {
                          _toiletFlushCount++;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Jenis Katup:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildSegmentedOption(
                leftLabel: 'Eco (6L)',
                rightLabel: 'Full (9L)',
                isLeftSelected: _isEcoFlush,
                onSelectLeft: () {
                  _saveSnapshot();
                  setState(() {
                    _isEcoFlush = true;
                    _markAsCustom();
                  });
                },
                onSelectRight: () {
                  _saveSnapshot();
                  setState(() {
                    _isEcoFlush = false;
                    _markAsCustom();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Aktivitas 3: Dapur & Masak
  Widget _buildCardDapur() {
    return _buildExpandableActivityCard(
      index: 2,
      icon: Icons.restaurant_rounded,
      title: 'Dapur & Masak',
      summarySubtitle:
          '${_dapurWashSessions}x cuci piring • ${_useBaskomCuci ? "Baskom" : "Keran Mengalir"}',
      liters: _literDapur,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Sesi Cuci Piring per Hari:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    enabled: _dapurWashSessions > 1,
                    onTap: () {
                      if (_dapurWashSessions > 1) {
                        _saveSnapshot();
                        setState(() {
                          _dapurWashSessions--;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: false,
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '$_dapurWashSessions',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    enabled: _dapurWashSessions < 8,
                    onTap: () {
                      if (_dapurWashSessions < 8) {
                        _saveSnapshot();
                        setState(() {
                          _dapurWashSessions++;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Metode Pembilasan:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildSegmentedOption(
                leftLabel: 'Baskom (10L)',
                rightLabel: 'Mengalir (20L)',
                isLeftSelected: _useBaskomCuci,
                onSelectLeft: () {
                  _saveSnapshot();
                  setState(() {
                    _useBaskomCuci = true;
                    _markAsCustom();
                  });
                },
                onSelectRight: () {
                  _saveSnapshot();
                  setState(() {
                    _useBaskomCuci = false;
                    _markAsCustom();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Aktivitas 4: Mencuci Pakaian (Konsisten memiliki kontrol interaktif - 8 Golden Rules: Internal Locus of Control)
  Widget _buildCardCuci() {
    return _buildExpandableActivityCard(
      index: 3,
      icon: Icons.local_laundry_service_outlined,
      title: 'Mencuci Pakaian',
      summarySubtitle: '${_cuciWeeklyLoads}x seminggu (~45L/sesi)',
      liters: _literCuci,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Frekuensi Cuci per Minggu:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    enabled: _cuciWeeklyLoads > 1,
                    onTap: () {
                      if (_cuciWeeklyLoads > 1) {
                        _saveSnapshot();
                        setState(() {
                          _cuciWeeklyLoads--;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: false,
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '$_cuciWeeklyLoads',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    enabled: _cuciWeeklyLoads < 7,
                    onTap: () {
                      if (_cuciWeeklyLoads < 7) {
                        _saveSnapshot();
                        setState(() {
                          _cuciWeeklyLoads++;
                          _markAsCustom();
                        });
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Proporsi harian: $_literCuci Liter/hari (Mesin cuci front-load ~45L/beban)',
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // Helper Segmented Control yang Konsisten (8 Golden Rules: Strive for Consistency)
  Widget _buildSegmentedOption({
    required String leftLabel,
    required String rightLabel,
    required bool isLeftSelected,
    required VoidCallback onSelectLeft,
    required VoidCallback onSelectRight,
  }) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onSelectLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isLeftSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(11),
                boxShadow: isLeftSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 3,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                leftLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isLeftSelected
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: isLeftSelected
                      ? const Color(0xFF0F4C81)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onSelectRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: !isLeftSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(11),
                boxShadow: !isLeftSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 3,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                rightLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: !isLeftSelected
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: !isLeftSelected
                      ? const Color(0xFF0F4C81)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
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

  // Helper Widget Stepper Button (+ / -) dengan Indikator Batas Maks/Min (8 Golden Rules: Prevent Errors)
  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.35,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isPrimary
                ? const Color(0xFF0F4C81)
                : const Color(0xFFE0F2FE),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: 16,
              color: isPrimary ? Colors.white : const Color(0xFF0F4C81),
            ),
          ),
        ),
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
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0)),
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
