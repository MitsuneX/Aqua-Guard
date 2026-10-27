import 'package:flutter/material.dart';
import 'profile_screen.dart';

/// Halaman Mandiri "Edukasi & Target SDG 6" (Tab Edukasi) - AquaGuard
/// Pure Mobile UI & Local State dengan StatefulWidget berbasis SDG 6.
class EdukasiSdgScreen extends StatefulWidget {
  final VoidCallback? onNavigateToBeranda;
  final Function(int)? onBottomNavTap;
  final int currentNavIndex;

  const EdukasiSdgScreen({
    super.key,
    this.onNavigateToBeranda,
    this.onBottomNavTap,
    this.currentNavIndex = 3,
  });

  @override
  State<EdukasiSdgScreen> createState() => _EdukasiSdgScreenState();
}

class _EdukasiSdgScreenState extends State<EdukasiSdgScreen> {
  // --- State: Kuis Kilat ---
  // null = belum dipilih, 0 = A, 1 = B, 2 = C
  int? _selectedQuizAnswer;
  final int _correctAnswer = 1; // B adalah jawaban benar
  bool _quizSubmitted = false;

  // --- State: Modul Progress ---
  // Status modul: 'done', 'active', 'available', 'locked'
  final List<Map<String, dynamic>> _modules = [
    {
      'id': 1,
      'target': 'Target 6.1',
      'title': 'Air Minum Aman',
      'duration': '2 Menit Bacaan',
      'status': 'done',
      'badge': 'Selesai',
      'badgeColor': 0xFF059669,
      'badgeBg': 0xFFDCFCE7,
      'icon': Icons.check_circle_rounded,
      'iconColor': 0xFF059669,
      'iconBg': 0xFFDCFCE7,
      'description':
          'Mengerti parameter kelayakan konsumsi, uji TDS sederhana, & teknologi filtrasi mikron rumah tangga.',
      'action': 'Ulas Catatan Ringkas',
      'progress': 1.0,
      'step': null,
      'totalStep': null,
      'quizCount': null,
    },
    {
      'id': 2,
      'target': 'Target 6.2',
      'title': 'Sanitasi & Higienitas',
      'duration': 'Progres 60%',
      'status': 'active',
      'badge': 'Berjalan',
      'badgeColor': 0xFF0284C7,
      'badgeBg': 0xFFE0F2FE,
      'icon': Icons.play_circle_outline_rounded,
      'iconColor': 0xFF0284C7,
      'iconBg': 0xFFE0F2FE,
      'description':
          'Pemberantasan BABS (Buang Air Besar Sembarangan) & penyediaan fasilitas sanitasi inklusif bagi wanita dan anak.',
      'action': 'Lanjutkan Modul',
      'progress': 0.6,
      'step': 3,
      'totalStep': 5,
      'quizCount': null,
    },
    {
      'id': 3,
      'target': 'Target 6.4',
      'title': 'Efisiensi & Kelangkaan Air',
      'duration': '3 Menit',
      'status': 'available',
      'badge': 'Tersedia',
      'badgeColor': 0xFF7C3AED,
      'badgeBg': 0xFFEDE9FE,
      'icon': Icons.lock_open_rounded,
      'iconColor': 0xFF7C3AED,
      'iconBg': 0xFFEDE9FE,
      'description':
          'Menghitung jejak air virtual dalam pangan serta pemetaan krisis defisit air regional di Indonesia.',
      'action': 'Mulai Pembelajaran',
      'progress': 0.0,
      'step': null,
      'totalStep': null,
      'quizCount': 2,
    },
    {
      'id': 4,
      'target': 'Target 6.3',
      'title': 'Pengolahan Air Limbah',
      'duration': null,
      'status': 'locked',
      'badge': 'Terkunci',
      'badgeColor': 0xFF94A3B8,
      'badgeBg': 0xFFF1F5F9,
      'icon': Icons.lock_rounded,
      'iconColor': 0xFF94A3B8,
      'iconBg': 0xFFF1F5F9,
      'description': 'Buka setelah Target 6.4 selesai',
      'action': null,
      'progress': 0.0,
      'step': null,
      'totalStep': null,
      'quizCount': null,
    },
  ];

  // --- State: Modul yang di-expand ---
  int? _expandedModuleId;

  int get _completedModules =>
      _modules.where((m) => m['status'] == 'done').length;
  int get _totalModules => _modules.length + 2; // total 6 modul (4 + 2 mendatang)

  // --- Diagram Alir Steps ---
  final List<Map<String, dynamic>> _flowSteps = [
    {
      'step': '01',
      'title': 'Sumber Air Bersih',
      'subtitle': 'Mata air, waduk, & sumur terlindung',
      'icon': Icons.water_outlined,
      'color': 0xFF0F4C81,
      'bgColor': 0xFFDEEBF7,
    },
    {
      'step': '02',
      'title': 'Penggunaan Domestik',
      'subtitle': 'Konsumsi higienis & dapur ramah air',
      'icon': Icons.home_outlined,
      'color': 0xFF0284C7,
      'bgColor': 0xFFE0F2FE,
    },
    {
      'step': '03',
      'title': 'Filtrasi / IPAL Komunal',
      'subtitle': 'Penyaringan greywater terintegrasi',
      'icon': Icons.filter_alt_outlined,
      'color': 0xFF0891B2,
      'bgColor': 0xFFCFFAFE,
    },
    {
      'step': '04',
      'title': 'Daur Ulang Resapan',
      'subtitle': 'Biopori tanah & irigasi vegetasi',
      'icon': Icons.recycling_rounded,
      'color': 0xFF059669,
      'bgColor': 0xFFD1FAE5,
    },
  ];

  // --- Quiz Options ---
  final List<Map<String, dynamic>> _quizOptions = [
    {
      'label': 'A',
      'text': 'Sekitar ~5 Liter per hari',
    },
    {
      'label': 'B',
      'text': 'Sekitar ~20 Liter per hari',
      'hint': 'Tepat! Lebih dari 20L air terbuang sia-sia per hari',
    },
    {
      'label': 'C',
      'text': 'Sekitar ~50 Liter per hari',
    },
  ];

  void _selectQuizAnswer(int index) {
    if (_quizSubmitted) return;
    setState(() {
      _selectedQuizAnswer = index;
      _quizSubmitted = true;
    });
  }

  void _handleModuleAction(Map<String, dynamic> module) {
    final status = module['status'] as String;
    if (status == 'locked') return;

    setState(() {
      if (_expandedModuleId == module['id']) {
        _expandedModuleId = null;
      } else {
        _expandedModuleId = module['id'] as int;
      }
    });

    final String msg = status == 'done'
        ? 'Membuka catatan ringkas "${module['title']}"...'
        : status == 'active'
            ? 'Melanjutkan modul "${module['title']}" dari Langkah ${module['step']} dari ${module['totalStep']}...'
            : 'Memulai pembelajaran "${module['title']}"...';

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color(module['badgeColor'] as int),
      ),
    );
  }

  void _handleDownload() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Mengunduh "Lembar Panduan SDG 6 Kampus (PDF 2.4 MB)"... ✅',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF0F4C81),
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
                  // 1. Header AppBar
                  _buildTopAppBar(),
                  const SizedBox(height: 18),

                  // 2. Judul & XP Badge
                  _buildPageTitleSection(),
                  const SizedBox(height: 14),

                  // 3. Progres Modul
                  _buildModuleProgressBar(),
                  const SizedBox(height: 18),

                  // 4. Banner Misi Global
                  _buildGlobalMissionBanner(),
                  const SizedBox(height: 22),

                  // 5. Bite-Sized Modul SDG 6
                  _buildModuleListSection(),
                  const SizedBox(height: 22),

                  // 6. Diagram Alir Interaktif
                  _buildFlowDiagramSection(),
                  const SizedBox(height: 22),

                  // 7. Tantangan Kuis Kilat
                  _buildQuizSection(),
                  const SizedBox(height: 22),

                  // 8. Kartu Unduh Panduan
                  _buildDownloadGuideCard(),
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

  // ─────────────────────────────────────────────────
  // 1. Top App Bar
  // ─────────────────────────────────────────────────
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
                  child: const Icon(
                    Icons.water_drop,
                    color: Color(0xFF0284C7),
                  ),
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
                    'Edukasi',
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
                      content: Text('1 notifikasi baru: Kuis Kilat tersedia!'),
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
                  child: Icon(Icons.person, color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────
  // 2. Judul & XP Badge
  // ─────────────────────────────────────────────────
  Widget _buildPageTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Edukasi & Target SDG 6',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Pahami krisis global & target aksi nyata PBB',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // XP Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFED7AA)),
          ),
          child: Column(
            children: const [
              Text(
                '+120',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEA580C),
                  height: 1.1,
                ),
              ),
              Text(
                'XP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF97316),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────
  // 3. Progres Modul Bar
  // ─────────────────────────────────────────────────
  Widget _buildModuleProgressBar() {
    final double progress = _completedModules / _totalModules;
    final int pct = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Color(0xFF0284C7),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Progres Modul Pembelajaran',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_completedModules / $_totalModules Selesai ($pct%)',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE0F2FE),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF0284C7),
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

  // ─────────────────────────────────────────────────
  // 4. Banner Misi Global 2030
  // ─────────────────────────────────────────────────
  Widget _buildGlobalMissionBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C3B6E),
            Color(0xFF0369A1),
            Color(0xFF0EA5E9),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0369A1).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Dekorasi lingkaran latar belakang
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Pola gelombang air abstrak
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: _WavePainter(),
            ),
          ),
          // Konten utama
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label Misi Global
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.public_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'MISI GLOBAL 2030',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Judul utama banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.water_drop,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Akses Air Bersih & Sanitasi Berkelanjutan',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Sub info
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildBannerChip(Icons.flag_rounded, 'SDG 6'),
                    _buildBannerChip(Icons.groups_2_rounded, '2.2B Terdampak'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // 5. Bite-Sized Modul SDG 6 Section
  // ─────────────────────────────────────────────────
  Widget _buildModuleListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Text(
                'Bite-Sized Modul SDG 6',
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
              'Mikro-Sesi 2–3 Menit',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_modules.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _modules.length - 1 ? 12 : 0,
            ),
            child: _buildModuleCard(_modules[index]),
          );
        }),
      ],
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    final String status = module['status'] as String;
    final bool isLocked = status == 'locked';
    final bool isDone = status == 'done';
    final bool isActive = status == 'active';
    final bool isAvailable = status == 'available';
    final bool isExpanded = _expandedModuleId == module['id'];

    final Color badgeColor = Color(module['badgeColor'] as int);
    final Color badgeBg = Color(module['badgeBg'] as int);
    final Color iconColor = Color(module['iconColor'] as int);
    final Color iconBg = Color(module['iconBg'] as int);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isLocked
            ? const Color(0xFFFAFAFA)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive
              ? const Color(0xFFBAE6FD)
              : isLocked
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFE2E8F0),
          width: isActive ? 1.5 : 1.0,
        ),
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kartu modul
          InkWell(
            onTap: isLocked ? null : () => _handleModuleAction(module),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Status
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Icon(
                        module['icon'] as IconData,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Informasi modul
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Target label & badge baris atas
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${module['target']}: ${module['title']}',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: isLocked
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                module['badge'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        // Durasi / Status info
                        if (module['duration'] != null)
                          Row(
                            children: [
                              Icon(
                                isActive
                                    ? Icons.play_arrow_rounded
                                    : isDone
                                        ? Icons.schedule_rounded
                                        : Icons.timer_outlined,
                                size: 13,
                                color: isLocked
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  isActive
                                      ? '${module['duration']} • Langkah ${module['step']} dari ${module['totalStep']}'
                                      : isAvailable && module['quizCount'] != null
                                          ? '${module['duration']} • ${module['quizCount']} Kuis Kilat'
                                          : module['duration'] as String,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isLocked
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        // Deskripsi (bagi modul non-locked)
                        if (!isLocked) ...[
                          const SizedBox(height: 5),
                          Text(
                            module['description'] as String,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (isLocked) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 12,
                                color: Color(0xFFCBD5E1),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Buka setelah Target 6.4 selesai',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFCBD5E1),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isLocked)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_right_rounded,
                      color: const Color(0xFF94A3B8),
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
          // Progress bar untuk modul aktif
          if (isActive) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: module['progress'] as double,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE0F2FE),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          // Tombol aksi modul
          if (!isLocked && module['action'] != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: _buildModuleActionButton(module),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModuleActionButton(Map<String, dynamic> module) {
    final String status = module['status'] as String;
    final String label = module['action'] as String;
    final Color btnColor = status == 'done'
        ? const Color(0xFFE0F2FE)
        : status == 'active'
            ? const Color(0xFF0284C7)
            : const Color(0xFF0F4C81);
    final Color textColor = status == 'done'
        ? const Color(0xFF0369A1)
        : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: () => _handleModuleAction(module),
        icon: Icon(
          status == 'done'
              ? Icons.menu_book_rounded
              : status == 'active'
                  ? Icons.play_arrow_rounded
                  : Icons.rocket_launch_rounded,
          color: textColor,
          size: 18,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // 6. Diagram Alir Interaktif
  // ─────────────────────────────────────────────────
  Widget _buildFlowDiagramSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header bagian
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.account_tree_outlined,
                color: Color(0xFF0284C7),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Diagram Alir Interaktif: Sanitasi Aman & Siklus Air',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Grid 2x2 untuk diagram alir
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.35,
          ),
          itemCount: _flowSteps.length,
          itemBuilder: (context, index) {
            final step = _flowSteps[index];
            final bool isLast = index == _flowSteps.length - 1;
            return _buildFlowStepCard(step, isLast, index);
          },
        ),
        const SizedBox(height: 14),

        // Fakta Kritis UN Water
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFED7AA)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD97706),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF78350F),
                      height: 1.45,
                    ),
                    children: [
                      TextSpan(
                        text: 'Fakta Kritis UN Water — ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text:
                            'Lebih dari 80% air limbah global dialirkan kembali ke ekosistem tanpa pengolahan memadai. Ini mencemari sumber air minum bagi ratusan juta orang.',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlowStepCard(
    Map<String, dynamic> step,
    bool isLast,
    int index,
  ) {
    final Color color = Color(step['color'] as int);
    final Color bgColor = Color(step['bgColor'] as int);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bgColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 8,
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
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Icon(
                    step['icon'] as IconData,
                    color: color,
                    size: 17,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  step['step'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            step['title'] as String,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Text(
              step['subtitle'] as String,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
                height: 1.3,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          if (!isLast) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: color.withValues(alpha: 0.5),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // 7. Tantangan Kuis Kilat
  // ─────────────────────────────────────────────────
  Widget _buildQuizSection() {
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
          // Header Kuis
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Color(0xFFD97706),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Tantangan Kuis Kilat Hari Ini',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: const Text(
                  '+15 XP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Pertanyaan Kuis
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Text(
              'Berapa rata-rata volume air yang terbuang jika sebuah keran bocor menetes 1 tetes per detik sepanjang hari?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Opsi Jawaban
          ...List.generate(_quizOptions.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _quizOptions.length - 1 ? 8 : 0,
              ),
              child: _buildQuizOption(index),
            );
          }),

          // Footer kuis (setelah submit)
          if (_quizSubmitted) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '+15 Poin Wawasan Ditambahkan — Selesai Hari Ini',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15803D),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuizOption(int index) {
    final option = _quizOptions[index];
    final String label = option['label'] as String;
    final String text = option['text'] as String;
    final bool isSelected = _selectedQuizAnswer == index;
    final bool isCorrect = index == _correctAnswer;
    final bool showResult = _quizSubmitted;

    // Tentukan warna berdasarkan status
    Color borderColor = const Color(0xFFE2E8F0);
    Color bgColor = const Color(0xFFF8FAFC);
    Color labelBg = const Color(0xFFE2E8F0);
    Color labelText = const Color(0xFF64748B);
    Color textColor = const Color(0xFF334155);

    if (showResult) {
      if (isCorrect) {
        borderColor = const Color(0xFF86EFAC);
        bgColor = const Color(0xFFF0FDF4);
        labelBg = const Color(0xFF22C55E);
        labelText = Colors.white;
        textColor = const Color(0xFF15803D);
      } else if (isSelected && !isCorrect) {
        borderColor = const Color(0xFFFCA5A5);
        bgColor = const Color(0xFFFFF5F5);
        labelBg = const Color(0xFFEF4444);
        labelText = Colors.white;
        textColor = const Color(0xFFDC2626);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFF93C5FD);
      bgColor = const Color(0xFFEFF6FF);
      labelBg = const Color(0xFF3B82F6);
      labelText = Colors.white;
      textColor = const Color(0xFF1D4ED8);
    }

    return GestureDetector(
      onTap: () => _selectQuizAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            // Label A/B/C
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: labelBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: labelText,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  // Hint untuk jawaban benar setelah submit
                  if (showResult && isCorrect && option.containsKey('hint')) ...[
                    const SizedBox(height: 2),
                    Text(
                      option['hint'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF15803D),
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Ikon hasil
            if (showResult) ...[
              const SizedBox(width: 6),
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : isSelected
                        ? Icons.cancel_rounded
                        : Icons.radio_button_unchecked_rounded,
                color: isCorrect
                    ? const Color(0xFF22C55E)
                    : isSelected
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFCBD5E1),
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // 8. Kartu Unduh Panduan
  // ─────────────────────────────────────────────────
  Widget _buildDownloadGuideCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Color(0xFF0284C7),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lembar Panduan SDG 6 Kampus',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Infografis & Aksi Konservasi Praktis (PDF 2.4 MB)',
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
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _handleDownload,
              icon: const Icon(
                Icons.download_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Simpan Lembar Panduan (PDF Mini)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F4C81),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // 9. Bottom Navigation Bar
  // ─────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────
// Custom Painter: Gelombang Air untuk Banner
// ─────────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.8,
      size.width * 0.75,
      size.height * 0.35,
    );
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.1,
      size.width * 0.95,
      size.height * 0.45,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    path2.cubicTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.9,
      size.width,
      size.height * 0.6,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
