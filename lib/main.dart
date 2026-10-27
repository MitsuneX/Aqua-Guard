import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'screens/aksi_screen.dart';
import 'screens/edukasi_screen.dart';
import 'screens/tracker_screen.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const AquaGuardApp());
}

class AquaGuardApp extends StatelessWidget {
  final Widget? homeScreen;

  const AquaGuardApp({super.key, this.homeScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F9FD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          primary: const Color(0xFF0284C7),
        ),
      ),
      // Layar awal aplikasi: WelcomeScreen sesuai alur onboarding AquaGuard
      home: homeScreen ?? const WelcomeScreen(),
    );
  }
}

/// Scaffold Utama AquaGuard yang mengelola navigasi antar tab
class AquaGuardMainScaffold extends StatefulWidget {
  final int initialIndex;

  const AquaGuardMainScaffold({super.key, this.initialIndex = 0});

  @override
  State<AquaGuardMainScaffold> createState() => _AquaGuardMainScaffoldState();
}

class _AquaGuardMainScaffoldState extends State<AquaGuardMainScaffold> {
  late int _selectedNavIndex;

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_selectedNavIndex) {
      case 0:
        return DashboardScreen(
          currentNavIndex: _selectedNavIndex,
          onBottomNavTap: _onNavTap,
        );
      case 1:
        return KalkulatorTrackerAirScreen(
          currentNavIndex: _selectedNavIndex,
          onBottomNavTap: _onNavTap,
          onNavigateToBeranda: () => _onNavTap(0),
        );
      case 2:
        return AksiKebiasaanAirScreen(
          currentNavIndex: _selectedNavIndex,
          onBottomNavTap: _onNavTap,
          onNavigateToBeranda: () => _onNavTap(0),
        );
      case 3:
        return EdukasiSdgScreen(
          currentNavIndex: _selectedNavIndex,
          onBottomNavTap: _onNavTap,
          onNavigateToBeranda: () => _onNavTap(0),
        );
      default:
        return _buildPlaceholderScreen(_selectedNavIndex);
    }
  }

  Widget _buildPlaceholderScreen(int index) {
    final String title = index == 1 ? 'Tracker Konsumsi Air' : 'Modul Edukasi SDG 6';
    final IconData icon = index == 1 ? Icons.calculate_outlined : Icons.school_outlined;
    final String desc = index == 1
        ? 'Fitur kalkulator dan pemantauan analitik meteran air cerdas.'
        : 'Pelajari konservasi air dan fakta penting seputar SDG 6.';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FD),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, size: 36, color: const Color(0xFF0284C7)),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _onNavTap(2),
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                  label: const Text(
                    'Kembali ke Tab Aksi',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4C81),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: _onNavTap,
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
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final int currentNavIndex;
  final Function(int)? onBottomNavTap;

  const DashboardScreen({
    super.key,
    this.currentNavIndex = 0,
    this.onBottomNavTap,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedNavIndex;
  bool _isChallengeCompleted = false;

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.currentNavIndex;
  }

  // Mocked user & water metrics data
  final String _userName = "Budi";
  final int _streakDays = 5;
  final double _targetLiters = 180.0;
  double _usedLiters = 112.0;

  // Category breakdowns
  double _showerLiters = 55.0;
  double _kitchenLiters = 28.0;
  double _sanitationLiters = 29.0;

  void _addWater(double amount, String source) {
    setState(() {
      _usedLiters = math.min(_usedLiters + amount, _targetLiters);
      if (source == "minum") {
        _kitchenLiters += amount;
      } else if (source == "shower") {
        _showerLiters += amount;
      } else if (source == "cuci") {
        _sanitationLiters += amount;
      }
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tercatat: +${amount >= 1 ? "${amount.toInt()} L" : "${(amount * 1000).toInt()} ml"} untuk $source!',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF026AA2),
      ),
    );
  }

  void _toggleChallenge() {
    setState(() {
      _isChallengeCompleted = !_isChallengeCompleted;
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isChallengeCompleted
              ? 'Selamat! Tantangan diselesaikan (+50 Poin SDG) 🎉'
              : 'Status tantangan diperbarui.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor:
            _isChallengeCompleted ? const Color(0xFF059669) : const Color(0xFF475569),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double usedPercentage = (_usedLiters / _targetLiters).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FD),
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
                  // 1. Header (App Bar Custom)
                  _buildAppBar(),
                  const SizedBox(height: 18),

                  // 2. Greeting Section
                  _buildGreetingSection(),
                  const SizedBox(height: 18),

                  // 3. Main Water Quota Usage Card
                  _buildWaterQuotaCard(usedPercentage),
                  const SizedBox(height: 16),

                  // 4. Daily Challenge Card (Tantangan Hari Ini)
                  _buildChallengeCard(),
                  const SizedBox(height: 16),

                  // 5. Monitoring Location Card (Lokasi Pemantauan)
                  _buildLocationMonitoringCard(),
                  const SizedBox(height: 16),

                  // 6. Micro-Insight Card (Tahukah Kamu?)
                  _buildMicroInsightCard(),
                  const SizedBox(height: 16),

                  // 7. Education Card (Placeholder Modul Edukasi)
                  _buildEducationCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),

      // 8. Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // 1. Header (AppBar Kustom)
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Logo resmi AquaGuard (wave + water drop)
            Image.asset(
              'assets/images/aquaguard_logo.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'AquaGuard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F3B5F),
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Beranda',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Tombol Notifikasi
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
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 10),
            // Tombol Avatar Profil
            GestureDetector(
              onTap: () => _showProfileSheet(context),
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

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F3B5F),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farhan Ramadhan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'farhan@aquaguard.id',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFF1F5F9)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  title: const Text(
                    'Keluar ke Halaman Login',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. Bagian Sambutan (Greeting Section)
  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $_userName! 👋',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.outlined_flag_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Target Harian: ',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                        children: [
                          TextSpan(
                            text: '${_targetLiters.toInt()} L',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
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
        ),
        const SizedBox(width: 10),
        // Badge Streak
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.water_drop,
                size: 18,
                color: Color(0xFF0284C7),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_streakDays Hari',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF026AA2),
                      height: 1.1,
                    ),
                  ),
                  const Text(
                    'Streak Bijak',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0369A1),
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. Kartu Penggunaan Air Utama
  Widget _buildWaterQuotaCard(double usedPercentage) {
    final int percentInt = (usedPercentage * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-header & Tag Terpakai
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(
                      Icons.water_drop_outlined,
                      size: 16,
                      color: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Status Kuota Air Hari Ini',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$percentInt% Terpakai',
                  style: const TextStyle(
                    color: Color(0xFF026AA2),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Donut Progress Circle
          Center(
            child: SizedBox(
              width: 215,
              height: 215,
              child: CustomPaint(
                painter: DonutProgressPainter(
                  progress: usedPercentage,
                  usedColor: const Color(0xFF026AA2),
                  remainingColor: const Color(0xFFD0E7FC),
                  strokeWidth: 20.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_usedLiters.toInt()}',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F3B5F),
                          letterSpacing: -1,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '/ ${_targetLiters.toInt()} Liter',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 13,
                              color: Color(0xFF0284C7),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Hemat & Optimal',
                              style: TextStyle(
                                color: Color(0xFF0284C7),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Rincian Kategori Penggunaan (3 Kolom)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildUsageCategory(
                icon: Icons.shower_outlined,
                title: 'Mandi',
                liters: '${_showerLiters.toInt()} L',
              ),
              _buildUsageCategory(
                icon: Icons.soup_kitchen_outlined,
                title: 'Dapur/Minum',
                liters: '${_kitchenLiters.toInt()} L',
              ),
              _buildUsageCategory(
                icon: Icons.sanitizer_outlined,
                title: 'Sanitasi',
                liters: '${_sanitationLiters.toInt()} L',
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),

          // Bagian Catat Cepat
          const Text(
            '+ CATAT CEPAT',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),

          // 3 Tombol Aksi Cepat Horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildQuickLogButton(
                  icon: Icons.local_drink_outlined,
                  label: '+ 250ml Air',
                  onTap: () => _addWater(0.25, 'minum'),
                ),
                const SizedBox(width: 10),
                _buildQuickLogButton(
                  icon: Icons.shower_outlined,
                  label: '+ Mandi 4m',
                  onTap: () => _addWater(15.0, 'shower'),
                ),
                const SizedBox(width: 10),
                _buildQuickLogButton(
                  icon: Icons.clean_hands_outlined,
                  label: '+ Cuci Tangan',
                  onTap: () => _addWater(2.0, 'cuci'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCategory({
    required IconData icon,
    required String title,
    required String liters,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          liters,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLogButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF5FD),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD8E9F9)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: const Color(0xFF0284C7),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Kartu Tantangan Hari Ini
  Widget _buildChallengeCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0369A1),
            Color(0xFF0E7490),
            Color(0xFF0284C7),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D0284C7),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Badge Atas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0x2EFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.track_changes_rounded, size: 13, color: Colors.white),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'SDG 6.4 • Efisiensi Air',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x2EFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.stars_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      '+50 Poin',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Teks Judul Tantangan
          const Text(
            'Tantangan Hari Ini: Kurangi 2 Menit Mandi Shower',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),

          // Teks Deskripsi Tantangan
          RichText(
            text: const TextSpan(
              text: 'Potensi hemat ',
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xE0FFFFFF),
                height: 1.35,
              ),
              children: [
                TextSpan(
                  text: '~18 Liter',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextSpan(
                  text: ' air bersih bernilai tinggi untuk menjaga resapan air lokal.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Baris Target Aksi & Tombol Tandai Selesai
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0x2EFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.water_drop_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Target Aksi',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '1x Sesi Shower',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleChallenge,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: _isChallengeCompleted ? const Color(0xFFE0F2FE) : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isChallengeCompleted ? 'Selesai' : 'Tandai Selesai',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: _isChallengeCompleted
                                ? const Color(0xFF059669)
                                : const Color(0xFF026AA2),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          _isChallengeCompleted
                              ? Icons.check_circle_rounded
                              : Icons.check_rounded,
                          size: 16,
                          color: _isChallengeCompleted
                              ? const Color(0xFF059669)
                              : const Color(0xFF026AA2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Kartu Lokasi Pemantauan
  Widget _buildLocationMonitoringCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Header Lokasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Lokasi Pemantauan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            'Zona Kampus & Sekitarnya',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.circle,
                      size: 7,
                      color: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Aktif',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2 Kotak Metrik: Kualitas Fisik & Standar Higienis
          Row(
            children: [
              // Kotak 1: Kualitas Fisik
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Flexible(
                            child: Text(
                              'Kualitas Fisik',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.science_outlined,
                            size: 16,
                            color: Color(0xFF0284C7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'BAIK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'TDS: 110 ppm • pH: 7.2',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Kotak 2: Standar Higienis
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Flexible(
                            child: Text(
                              'Standar Higienis',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: Color(0xFF0284C7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'AMAN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Layak Konsumsi\nSDG 6.1',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Teks Verifikasi Sensor
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: Color(0xFF64748B),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Terverifikasi sensor jaringan air minum kampus hari ini pukul 08:30 WIB',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. Kartu Wawasan (Tahukah Kamu?)
  Widget _buildMicroInsightCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBF5FE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xCCBAE6FD)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.lightbulb_outline_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                      child: Text(
                        'TAHUKAH KAMU?',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0284C7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Micro-Insight #42',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    text: 'Menutup keran saat menggosok gigi atau menyabuni tangan menghemat hingga ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF334155),
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(
                        text: '6 liter air',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      TextSpan(
                        text: ' per menit! Kebiasaan kecil ini melipatgandakan cadangan air komunal.',
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

  // 7. Kartu Edukasi (Placeholder)
  Widget _buildEducationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Placeholder Gambar Gelombang Air
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99BAE6FD),
                    Color(0x4D38BDF8),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(
                    Icons.waves,
                    size: 40,
                    color: Color(0x400284C7),
                  ),
                  Icon(
                    Icons.water,
                    size: 32,
                    color: Color(0xFF0284C7),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Teks Modul Edukasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Bersama Wujudkan Akses Sanitasi Bersih',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pelajari 8 indikator keberlanjutan SDG 6 di modul edukasi interaktif.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Tombol Panah Maju
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF0284C7),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // 8. Bilah Navigasi Bawah (BottomNavigationBar)
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          if (widget.onBottomNavTap != null) {
            widget.onBottomNavTap!(index);
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
            icon: Icon(Icons.water_drop),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded),
            label: 'Aksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Edukasi',
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk Grafik Donat Bersih dan Presisi
class DonutProgressPainter extends CustomPainter {
  final double progress; // nilai antara 0.0 sampai 1.0
  final Color usedColor;
  final Color remainingColor;
  final double strokeWidth;

  DonutProgressPainter({
    required this.progress,
    required this.usedColor,
    required this.remainingColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (size.width - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Pemisah sudut kecil (gap) antara segmen untuk efek visual round yang mulus
    const double gapAngle = 0.08; // sekitar ~4.5 derajat
    const double totalAngle = 2 * math.pi;

    final double usedAngle = (totalAngle * progress.clamp(0.05, 0.95)) - gapAngle;
    final double remainingAngle = (totalAngle * (1 - progress.clamp(0.05, 0.95))) - gapAngle;

    // Mulai dari atas agak ke kanan (~1 o'clock) persis seperti pada gambar
    const double startAngle = -math.pi / 2 + 0.35;

    // 1. Paint untuk segmen yang sudah digunakan (Biru Tua)
    final Paint usedPaint = Paint()
      ..color = usedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, usedAngle, false, usedPaint);

    // 2. Paint untuk segmen sisa kuota (Biru Muda)
    final Paint remainingPaint = Paint()
      ..color = remainingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double remainingStartAngle = startAngle + usedAngle + gapAngle;
    canvas.drawArc(rect, remainingStartAngle, remainingAngle, false, remainingPaint);
  }

  @override
  bool shouldRepaint(covariant DonutProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.usedColor != usedColor ||
        oldDelegate.remainingColor != remainingColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
