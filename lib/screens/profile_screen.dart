import 'package:flutter/material.dart';

import 'laporan_screen.dart';
import 'login_screen.dart';

/// Halaman Profil Pengguna AquaGuard
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data Profil
  String _userName = 'Nama Kamu';
  final String _userEmail = 'nama@aquaguard.id';
  final String _userRole = 'Duta SDG 6 Kampus';
  final String _userRank = 'Level 3: Penjaga Mata Air';

  // Pengaturan Preferensi Air
  String _dailyTarget = '180 L/hari';
  String _unitMode = 'Liter & ml'; // 'Liter & ml' atau 'Gelas & Gayung'
  String _language = 'Indonesia';

  // Pengaturan Notifikasi & Pengingat
  bool _notifReminder = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _quotaWarning = true;

  /// Mengubah format waktu menjadi HH:mm
  String _formatReminderTime() {
    return '${_reminderTime.hour.toString().padLeft(2, '0')}:'
        '${_reminderTime.minute.toString().padLeft(2, '0')}';
  }

  /// Memilih waktu pengingat secara fleksibel
  Future<void> _selectReminderTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      helpText: 'Pilih Waktu Pengingat',
      cancelText: 'BATAL',
      confirmText: 'SIMPAN',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF006296),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _reminderTime = selectedTime;
      });
    }
  }

  /// Dialog Edit Profil
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
                nameEditController.dispose();
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

  /// Dialog Edit Target Hemat Air
  void _showEditTargetDialog() {
    final TextEditingController targetController = TextEditingController(
      text: _dailyTarget.replaceAll(' L/hari', ''),
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
                'Target Hemat Air Harian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: TextField(
            controller: targetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Target (Liter/hari)',
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
                if (targetController.text.trim().isNotEmpty) {
                  setState(() {
                    _dailyTarget = '${targetController.text.trim()} L/hari';
                  });
                }
                Navigator.pop(ctx);
                targetController.dispose();
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

  /// Dialog Konfirmasi Keluar
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
            'Apakah Anda yakin ingin keluar dari akun ini?',
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
                'Keluar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Modal Informasi Detail
  void _showInfoModal(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006296),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Identitas Profil
                _buildUserIdentityCard(),
                const SizedBox(height: 20),

                // 2. Ringkasan Konservasi Air
                _buildConservationSummarySection(),
                const SizedBox(height: 14),

                // 3. Laporan Saya
                _buildMyReportCard(),
                const SizedBox(height: 20),

                // 4. Poin dan Lencana SDG 6
                _buildEcoPointsBadgeSection(),
                const SizedBox(height: 20),

                // 5. Preferensi Penggunaan Air
                _buildWaterPreferenceSection(),
                const SizedBox(height: 20),

                // 6. Notifikasi & Pengingat
                _buildNotificationSection(),
                const SizedBox(height: 20),

                // 7. Tentang AquaGuard
                _buildAboutSection(),
                const SizedBox(height: 20),

                // 8. Pusat Bantuan & Masukan
                _buildHelpCenterSection(),
                const SizedBox(height: 24),

                // 9. Tombol Keluar Akun
                _buildLogoutButton(),
                const SizedBox(height: 16),

                const Center(
                  child: Text(
                    'AquaGuard v1.4 • Edisi Konservasi Air Bersih SDG 6',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 1. IDENTITAS PROFIL
  // --------------------------------------------------

  Widget _buildUserIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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

  // --------------------------------------------------
  // 2. RINGKASAN KONSERVASI AIR
  // --------------------------------------------------

  Widget _buildConservationSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
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
            SizedBox(width: 8),
            Text(
              'Bulan Ini',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7),
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
                statusText: '+14% dari target',
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
                statusText: 'Konsisten mencatat',
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
      padding: const EdgeInsets.all(12),
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

  // --------------------------------------------------
  // 3. LAPORAN SAYA
  // --------------------------------------------------

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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

  // --------------------------------------------------
  // 4. POIN DAN LENCANA SDG 6
  // --------------------------------------------------

  Widget _buildEcoPointsBadgeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: Color(0xFF0284C7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
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
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.85,
                    backgroundColor: Color(0xFFBAE6FD),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF006296),
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tinggal 150 poin lagi untuk klaim bibit mangrove kampus gratis',
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

  // --------------------------------------------------
  // 5. PREFERENSI PENGGUNAAN AIR
  // --------------------------------------------------

  Widget _buildWaterPreferenceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                Icons.water_drop_outlined,
                color: Color(0xFF006296),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferensi Penggunaan Air',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Sesuaikan takaran, bahasa, dan target konsumsi mandiri',
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
          const SizedBox(height: 16),

          // Target Hemat Air Harian
          InkWell(
            onTap: _showEditTargetDialog,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.track_changes_rounded,
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
                          'Target Hemat Air Harian',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Batas kuota normal keluarga/kos',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _dailyTarget,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(
                              0xFF006296,
                            ), // Warna teks dibuat lebih tua
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.edit_rounded,
                          size: 13,
                          color: Color(
                            0xFF006296,
                          ), // Warna ikon dibuat lebih tua
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Panduan Takaran Catat
          const Text(
            'Panduan Takaran Catat',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Tampilkan setara takaran gelas (250ml) & ember/gayung',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),

          // Kontainer Tergabung (Segmented Switcher)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _unitMode = 'Liter & ml'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _unitMode == 'Liter & ml'
                            ? const Color(0xFF006296)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _unitMode == 'Liter & ml'
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF006296)
                                      .withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        'Liter & ml',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: _unitMode == 'Liter & ml'
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _unitMode = 'Gelas & Gayung'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _unitMode == 'Gelas & Gayung'
                            ? const Color(0xFF006296)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _unitMode == 'Gelas & Gayung'
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF006296)
                                      .withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        'Gelas & Gayung',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: _unitMode == 'Gelas & Gayung'
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 14),

          // Bahasa Aplikasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bahasa Aplikasi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Bahasa tampilan aplikasi',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _language = 'Indonesia'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _language == 'Indonesia'
                              ? const Color(0xFF006296)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Indonesia',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _language == 'Indonesia'
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _language = 'English'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _language == 'English'
                              ? const Color(0xFF006296)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'English',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _language == 'English'
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 6. NOTIFIKASI & PENGINGAT
  // --------------------------------------------------

  Widget _buildNotificationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                Icons.notifications_active_outlined,
                color: Color(0xFF006296),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifikasi & Pengingat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Atur jadwal pengingat catat air & alarm kuota harian',
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
          const SizedBox(height: 16),

          // Notifikasi Pengingat Harian
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
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
                      'Notifikasi Pengingat Harian',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pengingat mencatat pemakaian air setiap hari',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _notifReminder,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF006296),
                onChanged: (val) => setState(() => _notifReminder = val),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Waktu Pengingat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waktu Pengingat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pilih waktu sesuai aktivitas harian',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _notifReminder ? _selectReminderTime : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _notifReminder
                          ? const Color(0xFFE0F2FE)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _notifReminder
                            ? const Color(0xFFBAE6FD)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: _notifReminder
                              ? const Color(0xFF006296)
                              : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatReminderTime(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _notifReminder
                                ? const Color(0xFF006296)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.edit_rounded,
                          size: 13,
                          color: _notifReminder
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 14),

          // Peringatan Batas Kuota Air
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444),
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peringatan Batas Kuota Air',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Beri tahu saat pemakaian harian mencapai 80%',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _quotaWarning,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF006296),
                onChanged: (val) => setState(() => _quotaWarning = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 7. TENTANG AQUAGUARD & KOMITMEN GLOBAL
  // --------------------------------------------------

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                color: Color(0xFF006296),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Aplikasi Pemantau & Penghemat Air Bersih Harian',
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
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop, size: 14, color: Color(0xFF0284C7)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Komitmen Global: SDG 6 Air Bersih & Sanitasi',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF006296),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'AquaGuard membantu masyarakat, keluarga, dan generasi muda memantau efisiensi konsumsi air harian untuk mendukung target 6.4 PBB: menjaga ketersediaan dan kelestarian sumber daya air bersih berkelanjutan.',
                  style: TextStyle(
                    fontSize: 11.5,
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

  // --------------------------------------------------
  // 8. PUSAT BANTUAN & MASUKAN
  // --------------------------------------------------

  Widget _buildHelpCenterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                Icons.help_outline_rounded,
                color: Color(0xFF006296),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pusat Bantuan & Masukan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildActionBox(
            icon: Icons.menu_book_rounded,
            title: 'Cara Membaca Meteran & Takaran Air',
            onTap: () {
              _showInfoModal(
                'Cara Membaca Meteran & Takaran Air',
                '1. Catat angka awal pada meteran air di pagi hari.\n'
                    '2. Gunakan takaran standar (1 gelas = 250ml, 1 gayung = 1.5 Liter).\n'
                    '3. Masukkan data harian secara rutin untuk melihat grafik efisiensi.',
              );
            },
          ),
          const SizedBox(height: 10),
          _buildActionBox(
            icon: Icons.shield_outlined,
            title: 'Kebijakan Privasi & Keamanan Data',
            onTap: () {
              _showInfoModal(
                'Kebijakan Privasi & Keamanan Data',
                'Aplikasi ini beroperasi secara lokal pada perangkat Anda. Data penggunaan air dan preferensi disimpan dengan aman dan tidak dibagikan ke pihak ketiga.',
              );
            },
          ),
          const SizedBox(height: 10),
          _buildActionBox(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Kirim Masukan & Laporan Kendala',
            onTap: () {
              _showInfoModal(
                'Kirim Masukan & Laporan Kendala',
                'Silakan kirimkan kritik, saran, atau laporan kendala melalui email resmi dukungan pengguna kami di support@aquaguard.id.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionBox({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF006296)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF0284C7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 9. KELUAR AKUN
  // --------------------------------------------------

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
