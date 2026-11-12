import 'package:flutter/material.dart';

import '../services/points_manager.dart';
import 'profile_screen.dart';

/// Halaman Mandiri "Edukasi & Target SDG 6" (Tab Edukasi) - AquaGuard
/// Telah direvisi dengan menerapkan 8 Golden Rules of Interface Design (Shneiderman).
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
  // --- State: Kuis Kilat (Rule 4, 5, 6: Error Prevention, Closure, Reversal) ---
  int? _selectedQuizAnswer;
  final int _correctAnswer = 1; // B adalah jawaban benar
  bool _quizSubmitted = false;
  bool _quizRewardClaimed =
      false; // Mencegah farming XP saat fitur "Coba Lagi" dipakai

  // --- State: Unduh Panduan (Rule 3 & 5: Informative Feedback & Prevent Error) ---
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool _isDownloaded = false;

  // --- State: Diagram Alir Interaktif (Rule 3 & 7: Feedback & Locus of Control) ---
  int? _selectedFlowIndex;

  // --- State: Modul yang di-expand ---
  int? _expandedModuleId = 2; // Default expand modul yang sedang 'active'

  // --- State: Modul Progress ---
  final List _modules = [
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
      'description': 'Mengerti parameter kelayakan konsumsi, uji TDS sederhana, & teknologi filtrasi mikron rumah tangga.',
      'keyPoints': [
        'Air layak minum harus tidak berwarna, tidak berbau, dan TDS < 300 ppm.',
        'Filtrasi RO & Ultrafiltrasi efektif menyaring bakteri E. coli.',
      ],
      'action': 'Ulas Catatan Ringkas',
      'progress': 1.0,
      'step': 3,
      'totalStep': 3,
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
      'description': 'Pemberantasan BABS (Buang Air Besar Sembarangan) & penyediaan fasilitas sanitasi inklusif bagi wanita dan anak.',
      'keyPoints': [
        'Langkah 1-3: Standar tangki septik kedap air (SNI) agar tidak mencemari sumur.',
        'Langkah 4: Manajemen kebersihan menstruasi (MKM) di fasilitas umum/kampus.',
        'Langkah 5: Cuci tangan pakai sabun (CTPS) pada 5 waktu kritis.',
      ],
      'action': 'Lanjutkan Langkah',
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
      'description': 'Menghitung jejak air virtual dalam pangan serta pemetaan krisis defisit air regional di Indonesia.',
      'keyPoints': [
        'Jejak air (Water Footprint) 1 cangkir kopi setara dengan ~140 liter air.',
        'Penerapan keran aerator di kampus mampu menghemat debit air hingga 40%.',
      ],
      'action': 'Mulai Pembelajaran',
      'progress': 0.0,
      'step': 0,
      'totalStep': 3,
      'quizCount': 2,
    },
    {
      'id': 4,
      'target': 'Target 6.3',
      'title': 'Pengolahan Air Limbah',
      'duration': '4 Menit',
      'status': 'locked',
      'badge': 'Terkunci',
      'badgeColor': 0xFF94A3B8,
      'badgeBg': 0xFFF1F5F9,
      'icon': Icons.lock_rounded,
      'iconColor': 0xFF94A3B8,
      'iconBg': 0xFFF1F5F9,
      'description': 'Reduksi polusi kimiawi, daur ulang greywater domestik, dan teknologi phytoremediation.',
      'keyPoints': [
        'Pemisahan saluran blackwater (kloset) dan greywater (cucian/mandi).',
        'Pemanfaatan tanaman air (eceng gondok/melati air) sebagai biofilter alami.',
      ],
      'action': 'Mulai Pembelajaran',
      'progress': 0.0,
      'step': 0,
      'totalStep': 4,
      'quizCount': null,
    },
  ];

  int get _completedModules =>
      _modules.where((m) => m['status'] == 'done').length;
  int get _totalModules => _modules.length;

  // --- Diagram Alir Steps ---
  final List _flowSteps = [
    {
      'step': '01',
      'title': 'Sumber Air Bersih',
      'subtitle': 'Mata air, waduk, & sumur terlindung',
      'detail': 'Perlindungan daerah tangkapan air (catchment area) mencegah kontaminasi logam berat dan bakteri patogen sejak dari hulu.',
      'icon': Icons.water_outlined,
      'color': 0xFF0F4C81,
      'bgColor': 0xFFDEEBF7,
    },
    {
      'step': '02',
      'title': 'Penggunaan Domestik',
      'subtitle': 'Konsumsi higienis & dapur ramah air',
      'detail': 'Penggunaan deterjen ramah lingkungan (biodegradable) dan penghematan keran menekan beban polutan pada saluran pembuangan.',
      'icon': Icons.home_outlined,
      'color': 0xFF0284C7,
      'bgColor': 0xFFE0F2FE,
    },
    {
      'step': '03',
      'title': 'Filtrasi / IPAL Komunal',
      'subtitle': 'Penyaringan greywater terintegrasi',
      'detail': 'Instalasi Pengolahan Air Limbah (IPAL) menyaring lemak, sabun, dan partikel organik sebelum air dikembalikan ke alam.',
      'icon': Icons.filter_alt_outlined,
      'color': 0xFF0891B2,
      'bgColor': 0xFFCFFAFE,
    },
    {
      'step': '04',
      'title': 'Daur Ulang Resapan',
      'subtitle': 'Biopori tanah & irigasi vegetasi',
      'detail': 'Air hasil olahan IPAL aman digunakan untuk menyiram taman kampus dan mengisi ulang cadangan air tanah melalui lubang biopori.',
      'icon': Icons.recycling_rounded,
      'color': 0xFF059669,
      'bgColor': 0xFFD1FAE5,
    },
  ];

  // --- Quiz Options ---
  final List _quizOptions = [
    {
      'label': 'A',
      'text': 'Sekitar ~5 Liter per hari',
      'feedback': 'Kurang tepat. Tetesan konstan selama 24 jam menghasilkan volume yang jauh lebih besar.',
    },
    {
      'label': 'B',
      'text': 'Sekitar ~20 Liter per hari',
      'feedback': 'Tepat! Lebih dari 20L air bersih terbuang sia-sia per hari (setara ~1 galon penuh).',
    },
    {
      'label': 'C',
      'text': 'Sekitar ~50 Liter per hari',
      'feedback': 'Terlalu besar untuk 1 tetes/detik, namun kebocoran aliran kecil bisa mencapai angka ini.',
    },
  ];

  // ─────────────────────────────────────────────────
  // Logic & Handlers (Golden Rules Implementation)
  // ─────────────────────────────────────────────────

  // Rule 5: Prevent Errors (Pilih dulu, baru konfirmasi submit)
  void _onSelectOption(int index) {
    if (_quizSubmitted) return;
    setState(() {
      _selectedQuizAnswer = index;
    });
  }

  // Rule 4: Design Dialogs to Yield Closure
  void _submitQuizAnswer() {
    if (_selectedQuizAnswer == null || _quizSubmitted) return;

    setState(() {
      _quizSubmitted = true;
    });

    if (_selectedQuizAnswer == _correctAnswer && !_quizRewardClaimed) {
      _quizRewardClaimed = true;
      EcoPointsManager().addPoints(
        15,
        'Kuis Kilat: Keran Bocor Menetes',
        category: 'kuis',
      );
      _showFeedbackSnackBar(
        'Jawaban Benar! +15 Eco-Points berhasil ditambahkan.',
        const Color(0xFF059669),
      );
    } else if (_selectedQuizAnswer != _correctAnswer) {
      _showFeedbackSnackBar(
        'Jawaban kurang tepat. Silakan baca pembahasan atau coba lagi!',
        const Color(0xFFDC2626),
      );
    }
  }

  // Rule 6: Permit Easy Reversal of Actions
  void _resetQuiz() {
    setState(() {
      _selectedQuizAnswer = null;
      _quizSubmitted = false;
    });
  }

  // Rule 3: Offer Informative Feedback & Rule 7: Locus of Control
  void _toggleExpandModule(Map<String, dynamic> module) {
    final String status = module['status'] as String;
    if (status == 'locked') {
      _showFeedbackSnackBar(
        'Selesaikan modul "Target 6.4: Efisiensi & Kelangkaan Air" terlebih dahulu untuk membuka modul ini.',
        const Color(0xFF64748B),
      );
      return;
    }

    setState(() {
      if (_expandedModuleId == module['id']) {
        _expandedModuleId = null;
      } else {
        _expandedModuleId = module['id'] as int;
      }
    });
  }

  // Rule 4 & 6: Closure pada Modul + Easy Reversal (Undo)
  void _advanceModuleStep(
    Map<String, dynamic> module, {
    bool instantComplete = false,
  }) {
    // Simpan state lama untuk keperluan Undo (Rule 6)
    final String oldStatus = module['status'] as String;
    final int oldStep = (module['step'] as int?) ?? 0;
    final double oldProgress = (module['progress'] as double?) ?? 0.0;
    final String? oldDuration = module['duration'] as String?;
    final String oldBadge = module['badge'] as String;
    final int oldBadgeColor = module['badgeColor'] as int;
    final int oldBadgeBg = module['badgeBg'] as int;
    final IconData oldIcon = module['icon'] as IconData;
    final String? oldAction = module['action'] as String?;

    final int totalStep = (module['totalStep'] as int?) ?? 3;
    int nextStep = instantComplete ? totalStep : oldStep + 1;

    if (oldStatus == 'done') {
      // Opsi mengulang modul jika sudah selesai (Rule 6)
      setState(() {
        module['status'] = 'active';
        module['step'] = 1;
        module['progress'] = 1 / totalStep;
        module['badge'] = 'Berjalan';
        module['badgeColor'] = 0xFF0284C7;
        module['badgeBg'] = 0xFFE0F2FE;
        module['icon'] = Icons.play_circle_outline_rounded;
        module['iconColor'] = 0xFF0284C7;
        module['iconBg'] = 0xFFE0F2FE;
        module['duration'] = 'Progres ${(100 / totalStep).round()}%';
        module['action'] = 'Lanjutkan Langkah';
        _expandedModuleId = module['id'] as int;
      });
      _showFeedbackSnackBar(
        'Mengulang modul "${module['title']}" dari Langkah 1.',
        const Color(0xFF0284C7),
      );
      return;
    }

    setState(() {
      _expandedModuleId = module['id'] as int;
      if (nextStep >= totalStep) {
        // Modul Selesai (Closure)
        module['status'] = 'done';
        module['step'] = totalStep;
        module['progress'] = 1.0;
        module['badge'] = 'Selesai';
        module['badgeColor'] = 0xFF059669;
        module['badgeBg'] = 0xFFDCFCE7;
        module['icon'] = Icons.check_circle_rounded;
        module['iconColor'] = 0xFF059669;
        module['iconBg'] = 0xFFDCFCE7;
        module['duration'] = 'Selesai Dipelajari';
        module['action'] = 'Ulangi Modul';

        // Unlock Target 6.3 jika Target 6.4 selesai
        if (module['id'] == 3) {
          final lockedMod = _modules.firstWhere((m) => m['id'] == 4);
          if (lockedMod['status'] == 'locked') {
            lockedMod['status'] = 'available';
            lockedMod['badge'] = 'Tersedia';
            lockedMod['badgeColor'] = 0xFF7C3AED;
            lockedMod['badgeBg'] = 0xFFEDE9FE;
            lockedMod['icon'] = Icons.lock_open_rounded;
            lockedMod['iconColor'] = 0xFF7C3AED;
            lockedMod['iconBg'] = 0xFFEDE9FE;
          }
        }
      } else {
        // Modul Berjalan
        final double newPct = nextStep / totalStep;
        module['status'] = 'active';
        module['step'] = nextStep;
        module['progress'] = newPct;
        module['badge'] = 'Berjalan';
        module['badgeColor'] = 0xFF0284C7;
        module['badgeBg'] = 0xFFE0F2FE;
        module['icon'] = Icons.play_circle_outline_rounded;
        module['iconColor'] = 0xFF0284C7;
        module['iconBg'] = 0xFFE0F2FE;
        module['duration'] = 'Progres ${(newPct * 100).round()}%';
        module['action'] = 'Lanjutkan Langkah';
      }
    });

    final bool justFinished = module['status'] == 'done';
    if (justFinished) {
      EcoPointsManager().addPoints(
        25,
        'Menyelesaikan Modul ${module['target']}',
        category: 'edukasi',
      );
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          justFinished
              ? 'Selamat! Modul "${module['title']}" selesai (+25 XP).'
              : 'Melanjutkan ke Langkah $nextStep dari $totalStep...',
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(module['badgeColor'] as int),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // Rule 6: Permit Easy Reversal (Tombol Batal/Undo)
        action: SnackBarAction(
          label: 'BATAL',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              module['status'] = oldStatus;
              module['step'] = oldStep;
              module['progress'] = oldProgress;
              module['duration'] = oldDuration;
              module['badge'] = oldBadge;
              module['badgeColor'] = oldBadgeColor;
              module['badgeBg'] = oldBadgeBg;
              module['icon'] = oldIcon;
              module['iconColor'] = oldBadgeColor;
              module['iconBg'] = oldBadgeBg;
              module['action'] = oldAction;
            });
          },
        ),
      ),
    );
  }

  // Rule 3, 4, 5: Feedback progres unduhan, Closure selesai, & Cegah double click
  Future<void> _handleDownload() async {
    if (_isDownloading) return;

    if (_isDownloaded) {
      _showFeedbackSnackBar(
        'Membuka kembali "Lembar Panduan SDG 6 Kampus.pdf"...',
        const Color(0xFF0284C7),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.25;
    });

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _downloadProgress = 0.65);

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _downloadProgress = 1.0);

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() {
      _isDownloading = false;
      _isDownloaded = true;
    });

    _showFeedbackSnackBar(
      'Unduhan selesai! "Lembar Panduan SDG 6 Kampus (PDF 2.4 MB)" tersimpan.',
      const Color(0xFF059669),
    );
  }

  void _showFeedbackSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header AppBar (Tetap diam di atas saat di-scroll)
                Container(
                  color: const Color(0xFFF8FAFC),
                  padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                  child: _buildTopAppBar(),
                ),

                // Sisa konten di bawah header yang dapat di-scroll
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 6.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ─────────────────────────────────────────────────
  // 1. Top App Bar (Rule 2: Universal Usability dengan Tooltip & Semantics)
  // ─────────────────────────────────────────────────
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
                    InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        if (widget.onNavigateToBeranda != null) {
                          widget.onNavigateToBeranda!();
                        } else if (widget.onBottomNavTap != null) {
                          widget.onBottomNavTap!(0);
                        }
                      },
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Beranda',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 13,
                              color: Color(0xFF94A3B8),
                            ),
                            Text(
                              'Edukasi',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
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
            ],
          ),
        ),
        const SizedBox(width: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                tooltip: 'Notifikasi Pembelajaran',
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1E293B),
                  size: 19,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  _showFeedbackSnackBar(
                    'Info: Selesaikan Target 6.2 & Kuis Kilat untuk tambahan +40 XP hari ini!',
                    const Color(0xFF0F3B5F),
                  );
                },
              ),
            ),
            const SizedBox(width: 6),
            Semantics(
              label: 'Buka Halaman Profil Pengguna',
              button: true,
              child: Tooltip(
                message: 'Profil Saya',
                child: InkWell(
                  customBorder: const CircleBorder(),
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        Tooltip(
          message: 'Total potensi XP dari seluruh modul & kuis di halaman ini',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: const Column(
              children: [
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
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────
  // 3. Progres Modul Bar (Rule 3 & 8: Informative Feedback & Memory Load)
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
          colors: [Color(0xFF0C3B6E), Color(0xFF0369A1), Color(0xFF0EA5E9)],
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: _WavePainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Icon(Icons.public_rounded, color: Colors.white, size: 12),
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
  // 5. Bite-Sized Modul SDG 6 Section (Rule 2, 3, 4, 6, 7, 8)
  // ─────────────────────────────────────────────────
  Widget _buildModuleListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
              'Ketuk Kartu untuk Detail',
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
    final List<String> keyPoints =
        (module['keyPoints'] as List<dynamic>?)?.cast<String>() ?? [];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFFAFAFA) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive || isExpanded
              ? const Color(0xFF38BDF8)
              : const Color(0xFFE2E8F0),
          width: isActive || isExpanded ? 1.5 : 1.0,
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
            onTap: () => _toggleExpandModule(module),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        if (module['duration'] != null)
                          Row(
                            children: [
                              Icon(
                                isActive
                                    ? Icons.play_arrow_rounded
                                    : isDone
                                    ? Icons.check_rounded
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
                                      : isAvailable &&
                                            module['quizCount'] != null
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
                            maxLines: isExpanded ? 5 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (isLocked) ...[
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 12,
                                color: Color(0xFF94A3B8),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Syarat: Selesaikan Target 6.4 terlebih dahulu',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF94A3B8),
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
                  const SizedBox(width: 4),
                  Icon(
                    isLocked
                        ? Icons.info_outline_rounded
                        : isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF94A3B8),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Rule 3 & 8: Konten Expandable (Ringkasan Poin Kunci agar tidak membebani ingatan)
          if (isExpanded && !isLocked && keyPoints.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Materi Inti:',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...keyPoints.map(
                      (pt) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                pt,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF334155),
                                  height: 1.35,
                                ),
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
          ],

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

          // Tombol aksi modul + Shortcut Selesai Cepat (Rule 2: Universal Usability)
          if (!isLocked && module['action'] != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: _buildModuleActionButton(module, isExpanded),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModuleActionButton(
    Map<String, dynamic> module,
    bool isExpanded,
  ) {
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

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => _advanceModuleStep(module),
              icon: Icon(
                status == 'done'
                    ? Icons.replay_rounded
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
                  fontSize: 12.5,
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
          ),
        ),
        // Rule 2: Shortcut bagi expert user untuk langsung menyelesaikan modul saat di-expand
        if (status != 'done' && isExpanded) ...[
          const SizedBox(width: 8),
          Tooltip(
            message: 'Pintasan: Tandai seluruh langkah selesai (+25 XP)',
            child: SizedBox(
              height: 40,
              child: OutlinedButton(
                onPressed: () =>
                    _advanceModuleStep(module, instantComplete: true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF059669),
                  side: const BorderSide(color: Color(0xFF86EFAC)),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Icon(Icons.done_all_rounded, size: 18),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────
  // 6. Diagram Alir Interaktif (Rule 3 & 7: Feedback saat kartu diketuk)
  // ─────────────────────────────────────────────────
  Widget _buildFlowDiagramSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diagram Alir Interaktif: Siklus Air',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    'Ketuk tahap untuk melihat penjelasan proses',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.32,
          ),
          itemCount: _flowSteps.length,
          itemBuilder: (context, index) {
            final step = _flowSteps[index];
            final bool isLast = index == _flowSteps.length - 1;
            return _buildFlowStepCard(step, isLast, index);
          },
        ),

        // Panel Detail Interaktif saat salah satu tahap diklik
        if (_selectedFlowIndex != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_rounded,
                  color: Color(0xFF0284C7),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tahap ${_flowSteps[_selectedFlowIndex!]['step']} (${_flowSteps[_selectedFlowIndex!]['title']}): ${_flowSteps[_selectedFlowIndex!]['detail']}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0C4A6E),
                      height: 1.4,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedFlowIndex = null),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                        text: 'Lebih dari 80% air limbah global dialirkan kembali ke ekosistem tanpa pengolahan memadai. Ini mencemari sumber air minum bagi ratusan juta orang.',
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

  Widget _buildFlowStepCard(Map<String, dynamic> step, bool isLast, int index) {
    final Color color = Color(step['color'] as int);
    final Color bgColor = Color(step['bgColor'] as int);
    final bool isSelected = _selectedFlowIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _selectedFlowIndex = isSelected ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? bgColor.withValues(alpha: 0.35) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : bgColor,
            width: isSelected ? 1.8 : 1.5,
          ),
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
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // 7. Tantangan Kuis Kilat (Rule 4, 5, 6: Konfirmasi Submit & Tombol Reset)
  // ─────────────────────────────────────────────────
  Widget _buildQuizSection() {
    final bool isCorrectAnswer =
        _quizSubmitted && _selectedQuizAnswer == _correctAnswer;

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
                  color: _quizRewardClaimed
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _quizRewardClaimed
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFFED7AA),
                  ),
                ),
                child: Text(
                  _quizRewardClaimed ? 'Diklaim (+15 XP)' : '+15 XP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _quizRewardClaimed
                        ? const Color(0xFF15803D)
                        : const Color(0xFFEA580C),
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

          const SizedBox(height: 12),

          // Rule 5 & 6: Tombol Konfirmasi Jawaban (Mencegah salah tekan) & Tombol Ulangi
          if (!_quizSubmitted)
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: _selectedQuizAnswer != null
                    ? _submitQuizAnswer
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedQuizAnswer == null
                      ? 'Pilih Salah Satu Jawaban'
                      : 'Kirim Jawaban (${_quizOptions[_selectedQuizAnswer!]['label']})',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _selectedQuizAnswer == null
                        ? const Color(0xFF94A3B8)
                        : Colors.white,
                  ),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isCorrectAnswer
                        ? 'Hebat! Kamu memahami dampak kebocoran mikro.'
                        : 'Jangan menyerah, kamu bisa mencoba menjawab ulang.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isCorrectAnswer
                          ? const Color(0xFF15803D)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _resetQuiz,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text(
                    'Ulangi Kuis',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
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
      borderColor = const Color(0xFF38BDF8);
      bgColor = const Color(0xFFF0F9FF);
      labelBg = const Color(0xFF0284C7);
      labelText = Colors.white;
      textColor = const Color(0xFF0369A1);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _onSelectOption(index),
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
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: labelBg, shape: BoxShape.circle),
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
                  if (showResult && (isSelected || isCorrect)) ...[
                    const SizedBox(height: 3),
                    Text(
                      option['feedback'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isCorrect
                            ? const Color(0xFF15803D)
                            : const Color(0xFFDC2626),
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
  // 8. Kartu Unduh Panduan (Rule 3 & 4: State Unduhan & Closure)
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
                  color: _isDownloaded
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _isDownloaded
                        ? Icons.task_alt_rounded
                        : Icons.picture_as_pdf_rounded,
                    color: _isDownloaded
                        ? const Color(0xFF059669)
                        : const Color(0xFF0284C7),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          if (_isDownloading) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _downloadProgress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE0F2FE),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF0284C7),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _isDownloading ? null : _handleDownload,
              icon: Icon(
                _isDownloaded
                    ? Icons.folder_open_rounded
                    : Icons.download_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                _isDownloading
                    ? 'Mengunduh PDF (${(_downloadProgress * 100).round()}%)...'
                    : _isDownloaded
                    ? 'Tersimpan • Buka Lembar Panduan'
                    : 'Simpan Lembar Panduan (PDF Mini)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isDownloaded
                    ? const Color(0xFF059669)
                    : const Color(0xFF0F4C81),
                disabledBackgroundColor: const Color(0xFF94A3B8),
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
