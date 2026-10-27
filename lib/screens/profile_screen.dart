import 'package:flutter/material.dart';

import 'login_screen.dart';

/// Halaman Mandiri "Profil Pengguna" - AquaGuard
/// Menampilkan statistik konservasi, lencana SDG 6, pengaturan preferensi, dan informasi aplikasi.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State Pengaturan Aplikasi
  bool _notifReminder = true;
  bool _communityMission = true;
  bool _dataSaver = false;
  String _unit = 'Liter (L)'; // 'Liter (L)' atau 'Galon (Gal)'

  // State Profil
  String _userName = 'Farhan Pratama';
  final String _userEmail = 'farhan@aquaguard.id';
  final String _userRole = 'Duta SDG 6 Kampus';
  final String _userRank = 'Level 3: Penjaga Mata Air';

  /// Dialog Edit Profil Sederhana
  void _showEditProfileDialog() {
    final TextEditingController nameEditController =
        TextEditingController(text: _userName);

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
              child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
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
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// Dialog Konfirmasi Keluar Sesi Demo
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
                'Keluar Sesi Demo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari sesi demo ini? Anda akan kembali ke halaman login.',
            style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B), height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
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
              child: const Text('Keluar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// Modal Informasi Detail (Panduan / Privasi / Kritik)
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
            padding: const EdgeInsets.all(24.0),
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
                    child: const Text('Tutup', style: TextStyle(color: Colors.white)),
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

                const SizedBox(height: 20),

                // 3. Poin & Lencana SDG 6
                _buildEcoPointsBadgeSection(),

                const SizedBox(height: 20),

                // 4. Pengaturan Aplikasi
                _buildAppSettingsSection(),

                const SizedBox(height: 20),

                // 5. Tentang AquaGuard v1.4
                _buildAboutAquaGuardSection(),

                const SizedBox(height: 24),

                // 6. Tombol Keluar Sesi Demo
                _buildLogoutButton(),

                const SizedBox(height: 12),

                // 7. Footer Versi
                const Center(
                  child: Text(
                    'Versi Pratinjau Relawan • SDG 6 AquaGuard 2025',
                    style: TextStyle(
                      fontSize: 11.5,
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

  // --- SUB-WIDGETS ---

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
              // Avatar dengan Badge Tetes Air
              Stack(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFBAE6FD), width: 2.5),
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
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006296),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.water_drop,
                          color: Colors.white,
                          size: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Detail Nama, Email, & Role
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.public_rounded, size: 12, color: Color(0xFF0284C7)),
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

          // Banner Level & Tombol Edit
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                ElevatedButton.icon(
                  onPressed: _showEditProfileDialog,
                  icon: const Icon(Icons.edit_rounded, size: 13, color: Colors.white),
                  label: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006296),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

  /// 2. Ringkasan Konservasi Air (4 Grid Metrik)
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
                  Icon(Icons.bar_chart_rounded, color: Color(0xFF006296), size: 20),
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

        // Grid 2x2 Kartu Metrik
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
                  color: isHighlightValue ? const Color(0xFF006296) : const Color(0xFF0F172A),
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
          // Header Poin & Badge
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF0FD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  '850 Eco-Points',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF006296),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress Bar Menuju Master Konservasi
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
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006296)),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
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

          // Baris Lencana yang Dicapai
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildBadgeItem(
                  icon: Icons.water_drop_outlined,
                  title: 'Pahlawan\nKeran',
                  status: 'Tercapai',
                ),
                const SizedBox(width: 10),
                _buildBadgeItem(
                  icon: Icons.shower_outlined,
                  title: 'Shower\nCepat',
                  status: 'Tercapai',
                ),
                const SizedBox(width: 10),
                _buildBadgeItem(
                  icon: Icons.search_rounded,
                  title: 'Detektif\nBocor',
                  status: 'Tercapai',
                ),
                const SizedBox(width: 10),
                _buildBadgeItem(
                  icon: Icons.eco_outlined,
                  title: 'Duta\nHemat',
                  status: 'Tercapai',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Item Lencana
  Widget _buildBadgeItem({
    required IconData icon,
    required String title,
    required String status,
  }) {
    return Container(
      width: 82,
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

  /// 4. Pengaturan Aplikasi
  Widget _buildAppSettingsSection() {
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
              Icon(Icons.tune_rounded, color: Color(0xFF006296), size: 20),
              SizedBox(width: 6),
              Text(
                'Pengaturan Aplikasi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1. Pengingat Catat Air
          _buildSettingTile(
            icon: Icons.notifications_none_rounded,
            title: 'Pengingat Catat Air',
            subtitle: 'Notifikasi harian pukul 20:00',
            trailing: Switch(
              value: _notifReminder,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF006296),
              onChanged: (val) {
                setState(() => _notifReminder = val);
              },
            ),
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 16),

          // 2. Misi Komunitas SDG 6
          _buildSettingTile(
            icon: Icons.campaign_outlined,
            title: 'Misi Komunitas SDG 6',
            subtitle: 'Tantangan mingguan kampus',
            trailing: Switch(
              value: _communityMission,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF006296),
              onChanged: (val) {
                setState(() => _communityMission = val);
              },
            ),
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 16),

          // 3. Mode Hemat Kuota
          _buildSettingTile(
            icon: Icons.data_usage_rounded,
            title: 'Mode Hemat Kuota',
            subtitle: 'Kompresi data telemetri',
            trailing: Switch(
              value: _dataSaver,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF006296),
              onChanged: (val) {
                setState(() => _dataSaver = val);
              },
            ),
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 16),

          // 4. Satuan Pengukuran
          _buildSettingTile(
            icon: Icons.straighten_rounded,
            title: 'Satuan Pengukuran',
            subtitle: 'Format kalkulasi volume',
            trailing: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _unit = 'Liter (L)'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _unit == 'Liter (L)' ? const Color(0xFF006296) : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Liter (L)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _unit == 'Liter (L)' ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _unit = 'Galon (Gal)'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: _unit == 'Galon (Gal)' ? const Color(0xFF006296) : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Galon (Gal)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _unit == 'Galon (Gal)' ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(color: Color(0xFFF1F5F9), height: 16),

          // 5. Bahasa Aplikasi
          _buildSettingTile(
            icon: Icons.language_rounded,
            title: 'Bahasa Aplikasi',
            subtitle: 'Standar antarmuka',
            trailing: const Text(
              'Indonesia',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pengaturan Tile
  Widget _buildSettingTile({
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
                  fontSize: 11.5,
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

  /// 5. Tentang AquaGuard v1.4
  Widget _buildAboutAquaGuardSection() {
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
              Icon(Icons.verified_user_outlined, color: Color(0xFF0284C7), size: 20),
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
                      'Mitra PBB SDG 6 & Gerakan Kampus Bersih',
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

          // Kotak Informasi Pilar SDG 6
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
                    Icon(Icons.info_outline_rounded, color: Color(0xFF0284C7), size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Pilar SDG 6: Air Bersih & Sanitasi Layak',
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
                  'AquaGuard membantu mahasiswa dan komunitas memantau efisiensi air rumah tangga untuk mendukung target 6.4: memastikan ketersediaan dan pengelolaan air berkelanjutan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tautan Menu
          _buildActionLinkRow(
            icon: Icons.menu_book_rounded,
            title: 'Panduan Konservasi Air Praktis',
            onTap: () => _showInfoModal(
              'Panduan Konservasi Air Praktis',
              '1. Matikan keran saat menyikat gigi (menghemat hingga 12L/menit).\n2. Gunakan aerator keran bertekanan rendah.\n3. Periksa kebocoran kloset secara berkala.\n4. Kumpulkan air bekas cucian beras untuk menyiram tanaman.',
            ),
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 16),
          _buildActionLinkRow(
            icon: Icons.shield_outlined,
            title: 'Kebijakan Privasi & Mode Uji Coba',
            onTap: () => _showInfoModal(
              'Kebijakan Privasi & Mode Uji Coba',
              'Aplikasi ini beroperasi 100% pada sisi klien (Client-Side) tanpa pengiriman data ke server luar. Seluruh data input dan riwayat penggunaan hanya disimpan di memori lokal perangkat Anda.',
            ),
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 16),
          _buildActionLinkRow(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Kritik & Masukan Relawan',
            onTap: () => _showInfoModal(
              'Kritik & Masukan Relawan',
              'Terima kasih atas partisipasi Anda dalam gerakan relawan konservasi air AquaGuard! Silakan sampaikan masukan melalui email relawan: relawan@aquaguard.id.',
            ),
          ),
        ],
      ),
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
            const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  /// 6. Tombol Keluar Sesi Demo
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
                'Keluar Sesi Demo',
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
