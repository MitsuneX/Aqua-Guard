import 'package:flutter/material.dart';

import 'laporan_screen.dart';
import 'login_screen.dart';

/// Halaman Mandiri "Profil Pengguna" - AquaGuard
/// Menampilkan statistik konservasi, lencana SDG 6, preferensi air, notifikasi fleksibel, dan pusat bantuan.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── State Kelompok 1: Preferensi Penggunaan Air ──
  int _dailyTargetLiters = 180; // 150, 180, atau 200 Liter/hari
  String _measurementGuide = 'Liter & ml'; // 'Liter & ml' atau 'Gelas & Gayung'
  String _appLanguage = 'Indonesia'; // 'Indonesia' atau 'English'

  // ── State Kelompok 2: Notifikasi & Pengingat ──
  bool _notifDailyReminder = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _quotaAlert = true;

  // ── State Profil Pengguna ──
  String _userName = 'Nama Kamu';
  final String _userEmail = 'nama@aquaguard.id';
  final String _userRole = 'Duta SDG 6 Kampus';
  final String _userRank = 'Level 3: Penjaga Mata Air';

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Dialog Edit Profil Sederhana
  void _showEditProfileDialog() {
    final TextEditingController nameEditController = TextEditingController(
      text: _userName,
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.edit_rounded, color: Color(0xFF006296)),
              SizedBox(width: 8),
              Text(
                'Edit Nama Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: TextField(
            controller: nameEditController,
            decoration: InputDecoration(
              labelText: 'Nama Lengkap',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameEditController.text.trim().isNotEmpty) {
                  setState(() {
                    _userName = nameEditController.text.trim();
                  });
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006296),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Modal Bottom Sheet: Pemilih Target Hemat Air Harian
  void _showTargetPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                const Row(
                  children: [
                    Icon(
                      Icons.track_changes_rounded,
                      color: Color(0xFF006296),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Pilih Target Hemat Air Harian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sesuaikan batas kuota hemat dengan kebutuhan harian rumah tangga atau kos Anda.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                _buildTargetOptionTile(
                  liters: 150,
                  title: '150 Liter / hari',
                  subtitle:
                      'Super Hemat • Cocok untuk 1 orang / anak kos efisien',
                  isSelected: _dailyTargetLiters == 150,
                  onTap: () {
                    setState(() => _dailyTargetLiters = 150);
                    Navigator.pop(ctx);
                    _showTargetChangedSnackBar(150);
                  },
                ),
                const SizedBox(height: 10),
                _buildTargetOptionTile(
                  liters: 180,
                  title: '180 Liter / hari',
                  subtitle:
                      'Standar Normal SDG 6.4 • Rekomendasi keluarga mandiri',
                  isSelected: _dailyTargetLiters == 180,
                  onTap: () {
                    setState(() => _dailyTargetLiters = 180);
                    Navigator.pop(ctx);
                    _showTargetChangedSnackBar(180);
                  },
                ),
                const SizedBox(height: 10),
                _buildTargetOptionTile(
                  liters: 200,
                  title: '200 Liter / hari',
                  subtitle:
                      'Kapasitas Rumah Tangga • Konsumsi harian keluarga aktif',
                  isSelected: _dailyTargetLiters == 200,
                  onTap: () {
                    setState(() => _dailyTargetLiters = 200);
                    Navigator.pop(ctx);
                    _showTargetChangedSnackBar(200);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTargetOptionTile({
    required int liters,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0284C7)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF006296)
                    : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? const Color(0xFF006296)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF0284C7),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showTargetChangedSnackBar(int liters) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF006296),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF86EFAC)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Target hemat air harian diatur ke $liters Liter/hari 🎯💧',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog Konfirmasi Keluar Akun (Log Out)
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
              SizedBox(width: 8),
              Text(
                'Keluar Akun',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini? Seluruh data catatan mandiri Anda tetap tersimpan aman di perangkat.',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Keluar Akun',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Modal Informasi Detail (Bantuan / Kebijakan)
  void _showInfoModal(String title, String content) {
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
            padding: const EdgeInsets.all(22.0),
            child: SingleChildScrollView(
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
                  const SizedBox(height: 18),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006296),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Saya Mengerti',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Kartu Identitas Profil Pengguna
                _buildUserIdentityCard(),

                const SizedBox(height: 20),

                // 2. Ringkasan Konservasi Air (4 Grid Metrik)
                _buildConservationSummarySection(),

                const SizedBox(height: 14),

                // 2.5 Kartu Akses "Laporan Saya"
                _buildMyReportCard(),

                const SizedBox(height: 20),

                // 3. Poin & Lencana SDG 6
                _buildEcoPointsBadgeSection(),

                const SizedBox(height: 22),

                // ── 4. KELOMPOK 1: PREFERENSI PENGGUNAAN AIR ──
                _buildSectionHeader(
                  icon: Icons.water_drop_outlined,
                  title: 'Preferensi Penggunaan Air',
                  subtitle:
                      'Sesuaikan takaran, bahasa, dan target konsumsi mandiri',
                ),
                const SizedBox(height: 10),
                _buildWaterPreferencesCard(),

                const SizedBox(height: 22),

                // ── 5. KELOMPOK 2: NOTIFIKASI & PENGINGAT ──
                _buildSectionHeader(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notifikasi & Pengingat',
                  subtitle:
                      'Atur jadwal pengingat catat air & alarm kuota harian',
                ),
                const SizedBox(height: 10),
                _buildNotificationSettingsCard(),

                const SizedBox(height: 22),

                // ── 6. KELOMPOK 3: BANTUAN & INFORMASI APLIKASI ──
                _buildSectionHeader(
                  icon: Icons.info_outline_rounded,
                  title: 'Bantuan & Informasi Aplikasi',
                  subtitle:
                      'Panduan teknis, privasi data, dan pusat bantuan pengguna',
                ),
                const SizedBox(height: 10),
                _buildAboutAquaGuardCard(),

                const SizedBox(height: 14),
                _buildHelpAndFeedbackCard(),

                const SizedBox(height: 26),

                // ── 7. TOMBOL KELUAR AKUN (LOG OUT) ──
                _buildLogoutButton(),

                const SizedBox(height: 16),

                // Footer Versi Aplikasi
                const Center(
                  child: Text(
                    'AquaGuard v1.4 • Edisi Konservasi Air Bersih SDG 6',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- SUB-WIDGETS SECTIONS ---

  /// Header Sub-Judul Kelompok Menu
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF006296), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
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

  /// 1. Kartu Identitas Pengguna
  Widget _buildUserIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFBAE6FD),
                        width: 2.5,
                      ),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                      ),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: const Color(0xFFE0F2FE),
                        child: const Icon(
                          Icons.person,
                          size: 46,
                          color: Color(0xFF006296),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showEditProfileDialog,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF006296),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _userName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF0284C7),
                          size: 17,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.public_rounded,
                            size: 12,
                            color: Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _userRole,
                            style: const TextStyle(
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
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.military_tech_outlined,
                      color: Color(0xFF0284C7),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Peringkat Relawan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        _userRank,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Ringkasan Konservasi Air
  Widget _buildConservationSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: Color(0xFF006296),
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Ringkasan Konservasi Air',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'Bulan Ini',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: 'Total Dihemat',
                value: '1.420',
                unit: 'L',
                statusText: '📈 +14% dari target',
                statusColor: const Color(0xFF0284C7),
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFF0284C7),
                iconBg: const Color(0xFFE0F2FE),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                label: 'Rata-rata Harian',
                value: '42',
                unit: 'L/hari',
                statusText: 'Target SDG: 35 L',
                statusColor: const Color(0xFF64748B),
                icon: Icons.speed_outlined,
                iconColor: const Color(0xFF0284C7),
                iconBg: const Color(0xFFE0F2FE),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: 'Streak Berturut',
                value: '12',
                unit: 'Hari',
                statusText: 'Konsisten mencatat 🔥',
                statusColor: const Color(0xFF0284C7),
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFEF4444),
                iconBg: const Color(0xFFFEE2E2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                label: 'Jejak Air',
                value: 'Efisien',
                unit: '',
                statusText: 'Kategori A (Eco Hero)',
                statusColor: const Color(0xFF64748B),
                icon: Icons.eco_outlined,
                iconColor: const Color(0xFF0284C7),
                iconBg: const Color(0xFFE0F2FE),
                isHighlightValue: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2.5 Kartu Akses "Laporan Saya"
  Widget _buildMyReportCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LaporanKonservasiAirScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
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
                        'Laporan Saya',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Statistik mingguan & bulanan konservasi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Color(0xFF0284C7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Kartu Metrik Individual
  Widget _buildMetricCard({
    required String label,
    required String value,
    required String unit,
    required String statusText,
    required Color statusColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    bool isHighlightValue = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 14),
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
                style: TextStyle(
                  fontSize: isHighlightValue ? 19 : 22,
                  fontWeight: FontWeight.w900,
                  color: isHighlightValue
                      ? const Color(0xFF006296)
                      : const Color(0xFF0F172A),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 3),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Poin & Lencana SDG 6
  Widget _buildEcoPointsBadgeSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.military_tech_rounded,
                color: Color(0xFF0284C7),
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Poin & Lencana SDG 6',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Apresiasi aksi nyata hemat air',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Menuju Master Konservasi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '850 / 1.000 Poin',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF006296),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: 0.85,
                    backgroundColor: Color(0xFFBAE6FD),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF006296),
                    ),
                    minHeight: 8,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Tinggal 150 poin lagi untuk klaim bibit mangrove kampus gratis 🌱',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildBadgeItem(
                    icon: Icons.water_drop_outlined,
                    title: 'Pahlawan\nKeran',
                    status: 'Tercapai',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildBadgeItem(
                    icon: Icons.shower_outlined,
                    title: 'Shower\nCepat',
                    status: 'Tercapai',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildBadgeItem(
                    icon: Icons.search_rounded,
                    title: 'Detektif\nBocor',
                    status: 'Tercapai',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildBadgeItem(
                    icon: Icons.eco_outlined,
                    title: 'Duta\nHemat',
                    status: 'Tercapai',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem({
    required IconData icon,
    required String title,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0284C7), size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // KELOMPOK 1: PREFERENSI PENGGUNAAN AIR
  // ─────────────────────────────────────────────────────────
  Widget _buildWaterPreferencesCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Target Hemat Air Harian (Bisa diklik & fleksibel)
          _buildActionSettingRow(
            icon: Icons.track_changes_rounded,
            title: 'Target Hemat Air Harian',
            subtitle: 'Batas kuota normal keluarga/kos',
            trailing: InkWell(
              onTap: _showTargetPickerSheet,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_dailyTargetLiters L/hari',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF006296),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.edit_rounded,
                      size: 13,
                      color: Color(0xFF006296),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 20),

          // 2. Panduan Takaran Catat (Liter & ml vs Gelas & Gayung)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.straighten_rounded,
                      color: Color(0xFF0284C7),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panduan Takaran Catat',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tampilkan setara takaran gelas (250ml) & ember/gayung',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Segmented Toggle Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _measurementGuide = 'Liter & ml');
                          _showGuideToast('Liter & ml (Metrik Standar)');
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: _measurementGuide == 'Liter & ml'
                                ? const Color(0xFF006296)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              'Liter & ml',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: _measurementGuide == 'Liter & ml'
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _measurementGuide = 'Gelas & Gayung');
                          _showGuideToast('Gelas & Gayung (Takaran Awam)');
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: _measurementGuide == 'Gelas & Gayung'
                                ? const Color(0xFF006296)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              'Gelas & Gayung',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: _measurementGuide == 'Gelas & Gayung'
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 20),

          // 3. Bahasa Aplikasi (Interaktif: Indonesia / English)
          _buildActionSettingRow(
            icon: Icons.language_rounded,
            title: 'Bahasa Aplikasi',
            subtitle: 'Bahasa tampilan aplikasi',
            trailing: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageChoicePill('Indonesia'),
                  _buildLanguageChoicePill('English'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChoicePill(String lang) {
    final bool isSelected = _appLanguage == lang;
    return GestureDetector(
      onTap: () {
        setState(() => _appLanguage = lang);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bahasa aplikasi diubah ke $lang.'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006296) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          lang,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  void _showGuideToast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Panduan takaran diatur ke: $text'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // KELOMPOK 2: NOTIFIKASI & PENGINGAT (Golden Rule #7)
  // ─────────────────────────────────────────────────────────
  Widget _buildNotificationSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Switch Notifikasi Pengingat Harian
          _buildActionSettingRow(
            icon: Icons.notifications_none_rounded,
            title: 'Notifikasi Pengingat Harian',
            subtitle: 'Pengingat mencatat pemakaian air setiap hari',
            trailing: Switch(
              value: _notifDailyReminder,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF006296),
              onChanged: (val) {
                setState(() => _notifDailyReminder = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val
                          ? 'Pengingat harian aktif pukul ${_formatTimeOfDay(_reminderTime)}.'
                          : 'Pengingat harian dinonaktifkan.',
                    ),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),

          // 2. Baris Pilihan Waktu Fleksibel (showTimePicker)
          if (_notifDailyReminder) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBAE6FD), width: 0.8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 15,
                    color: Color(0xFF006296),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Waktu Pengingat',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF006296),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF006296),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF0F172A),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => _reminderTime = picked);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Waktu pengingat diatur ke pukul ${_formatTimeOfDay(picked)} ⏰💧',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF0284C7)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pukul ${_formatTimeOfDay(_reminderTime)}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.edit_rounded,
                            size: 12,
                            color: Color(0xFF0284C7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Divider(color: Color(0xFFF1F5F9), height: 20),

          // 3. Switch Peringatan Batas Kuota Air
          _buildActionSettingRow(
            icon: Icons.warning_amber_rounded,
            title: 'Peringatan Batas Kuota Air',
            subtitle: 'Beri tahu saat pemakaian harian mencapai 80%',
            trailing: Switch(
              value: _quotaAlert,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF006296),
              onChanged: (val) {
                setState(() => _quotaAlert = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val
                          ? 'Alarm peringatan kuota 80% diaktifkan.'
                          : 'Alarm peringatan kuota dinonaktifkan.',
                    ),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // KELOMPOK 3: BANTUAN & INFORMASI APLIKASI
  // ─────────────────────────────────────────────────────────

  /// Kartu Informasi Mandiri: Tentang AquaGuard v1.4
  Widget _buildAboutAquaGuardCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF0284C7),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tentang AquaGuard v1.4',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Aplikasi Pemantau & Penghemat Air Bersih Harian',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.eco_rounded,
                      color: Color(0xFF0284C7),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Komitmen Global: SDG 6 Air Bersih & Sanitasi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF006296),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'AquaGuard membantu masyarakat, keluarga, dan generasi muda memantau efisiensi konsumsi air harian untuk mendukung target 6.4 PBB: menjaga ketersediaan dan kelestarian sumber daya air bersih berkelanjutan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu Pusat Bantuan & Masukan (Daftar Menu Klik)
  Widget _buildHelpAndFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.help_outline_rounded, color: Color(0xFF006296), size: 19),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pusat Bantuan & Masukan',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Menu 1: Cara Membaca Meteran & Takaran Air
          _buildActionLinkRow(
            icon: Icons.speed_rounded,
            title: 'Cara Membaca Meteran & Takaran Air',
            onTap: () => _showInfoModal(
              'Cara Membaca Meteran & Takaran Air',
              '1. Membaca Meteran Air PDAM:\n'
              '• Angka Hitam (Kiri): Menunjukkan volume dalam satuan meter kubik (m³). 1 m³ setara dengan 1.000 Liter air.\n'
              '• Angka Merah (Kanan): Menunjukkan satuan ratusan liter dan desimal.\n'
              '• Jarum Gerigi Kecil: Bila jarum gerigi tetap berputar saat semua keran tertutup rapat, berarti terjadi rembesan atau kebocoran pipa tersembunyi.\n\n'
              '2. Panduan Takaran Praktis Rumah Tangga:\n'
              '• 1 Gelas Minum = ~250 ml (0,25 Liter)\n'
              '• 1 Gayung Mandi = ~1,5 Liter\n'
              '• 1 Ember Sedang = ~10 - 12 Liter\n'
              '• 1 Galon Air Minum = 19 Liter\n'
              '• 1 Menit Shower Mandi = ~6 Liter air.',
            ),
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 16),

          // Menu 2: Kebijakan Privasi & Keamanan Data
          _buildActionLinkRow(
            icon: Icons.shield_outlined,
            title: 'Kebijakan Privasi & Keamanan Data',
            onTap: () => _showInfoModal(
              'Kebijakan Privasi & Keamanan Data',
              'AquaGuard berkomitmen melindungi privasi pengguna seutuhnya:\n\n'
              '• Penyimpanan 100% Lokal (Client-Side):\n'
              'Seluruh data kalkulasi volume air, log harian, riwayat poin, dan preferensi akun Anda tersimpan di penyimpanan lokal perangkat tanpa dikirimkan ke server eksternal.\n\n'
              '• Bebas Pelacak Komersial:\n'
              'Kami tidak mengumpulkan identitas rahasia, nomor rekening, atau menjual data aktivitas ke pengiklan pihak ketiga.\n\n'
              '• Kontrol Penuh Pengguna:\n'
              'Anda bebas menghapus riwayat atau keluar sesi kapan saja tanpa jejak tersisa.',
            ),
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 16),

          // Menu 3: Kirim Masukan & Laporan Kendala
          _buildActionLinkRow(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Kirim Masukan & Laporan Kendala',
            onTap: () => _showInfoModal(
              'Kirim Masukan & Laporan Kendala',
              'Kami sangat menghargai saran, kritik, dan laporan kendala Anda demi meningkatkan kualitas aplikasi konservasi air AquaGuard.\n\n'
              '• Email Bantuan Pengguna:\n'
              'bantuan@aquaguard.id\n\n'
              '• Layanan WhatsApp Komunitas:\n'
              '+62 812-3456-7890 (Senin - Jumat, 08:00 - 17:00 WIB)\n\n'
              '• Sekretariat Komunitas:\n'
              'Gedung Pusat Konservasi Air Bersih SDG 6, Kampus Hijau Terpadu.\n\n'
              'Terima kasih atas partisipasi aktif Anda menjaga setiap tetes air bersih! 💧🌿',
            ),
          ),
        ],
      ),
    );
  }

  /// Row Pengaturan dengan Trailing Custom
  Widget _buildActionSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0284C7), size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }

  /// Tautan Menu Bawah
  Widget _buildActionLinkRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 17, color: const Color(0xFF006296)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  /// 7. Tombol Keluar Akun (Log Out)
  Widget _buildLogoutButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _confirmLogout,
          borderRadius: BorderRadius.circular(24),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 18),
              SizedBox(width: 8),
              Text(
                'Keluar Akun (Log Out)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
