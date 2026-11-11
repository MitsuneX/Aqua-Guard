import 'dart:async';

import 'package:flutter/material.dart';

import 'profile_screen.dart';
import '../services/points_manager.dart';

/// Model aktivitas kebiasaan air.
class ActionItemModel {
  final String id;
  final String category;
  final String title;
  final int litersSaved;
  final int points;
  final IconData icon;
  final bool hasTimer;
  final bool isCustom;

  bool isCompleted;

  ActionItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.litersSaved,
    required this.points,
    required this.icon,
    this.isCompleted = false,
    this.hasTimer = false,
    this.isCustom = false,
  });
}

class AksiKebiasaanAirScreen extends StatefulWidget {
  final VoidCallback? onNavigateToBeranda;
  final Function(int)? onBottomNavTap;
  final int currentNavIndex;

  const AksiKebiasaanAirScreen({
    super.key,
    this.onNavigateToBeranda,
    this.onBottomNavTap,
    this.currentNavIndex = 2,
  });

  @override
  State<AksiKebiasaanAirScreen> createState() => _AksiKebiasaanAirScreenState();
}

class _AksiKebiasaanAirScreenState extends State<AksiKebiasaanAirScreen> {
  // FILTER KATEGORI

  String _selectedCategory = 'Semua';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Semua', 'icon': Icons.grid_view_rounded},
    {'name': 'Kamar Mandi', 'icon': Icons.bathtub_outlined},
    {'name': 'Dapur', 'icon': Icons.soup_kitchen_outlined},
    {'name': 'Lingkungan', 'icon': Icons.eco_outlined},
  ];

  // RINGKASAN MINGGUAN

  int _weeklySavedLiters = 142;
  final int _weeklyTargetLiters = 200;
  final int _streakDays = 5;
  final int _userLevel = 3;
  final String _levelTitle = 'Penjaga Mata Air';

  // MISI KOMUNITAS

  int _campusVolunteers = 184;
  int _campusCollectedLiters = 740;
  final int _campusTargetLiters = 1000;
  bool _isCampusCommitmentJoined = false;

  // TIMER SHOWER

  Timer? _showerTimer;
  int _showerSecondsRemaining = 300;
  bool _isShowerTimerRunning = false;

  // DATA LAPORAN FASILITAS
  // Laporan bersifat opsional dan tidak masuk checklist harian.

  final List<Map<String, String>> _facilityReports = [];

  // DATA AKTIVITAS

  late List<ActionItemModel> _actions;

  @override
  void initState() {
    super.initState();

    _actions = [
      ActionItemModel(
        id: '1',
        category: 'KAMAR MANDI',
        title: 'Tutup Keran Saat Sikat Gigi',
        litersSaved: 12,
        points: 10,
        icon: Icons.water_drop_outlined,
        isCompleted: true,
      ),
      ActionItemModel(
        id: '2',
        category: 'KAMAR MANDI',
        title: 'Kurangi Shower 2 Menit',
        litersSaved: 18,
        points: 15,
        icon: Icons.timer_outlined,
        hasTimer: true,
      ),
      ActionItemModel(
        id: '3',
        category: 'DAPUR',
        title: 'Gunakan Baskom Cuci Piring',
        litersSaved: 25,
        points: 15,
        icon: Icons.soup_kitchen_outlined,
      ),
      ActionItemModel(
        id: '5',
        category: 'LINGKUNGAN',
        title: 'Daur Ulang Air untuk Tanaman',
        litersSaved: 15,
        points: 10,
        icon: Icons.eco_outlined,
        isCompleted: true,
      ),
    ];
  }

  @override
  void dispose() {
    _showerTimer?.cancel();
    super.dispose();
  }

  // FILTER AKTIVITAS

  List<ActionItemModel> get _filteredActions {
    if (_selectedCategory == 'Semua') {
      return _actions;
    }

    return _actions.where((item) {
      return item.category.toLowerCase() == _selectedCategory.toUpperCase();
    }).toList();
  }

  // MENGHITUNG AKTIVITAS SELESAI

  int get _completedCount => _actions.where((item) => item.isCompleted).length;

  // MENYELESAIKAN AKTIVITAS

  void _toggleAction(ActionItemModel item) {
    if (item.isCompleted) {
      setState(() {
        item.isCompleted = false;
        _weeklySavedLiters -= item.litersSaved;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status "${item.title}" dibatalkan.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      item.isCompleted = true;
      _weeklySavedLiters += item.litersSaved;
    });

    EcoPointsManager().addPoints(
      item.points,
      'Aksi: ${item.title}',
      category: 'aksi',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Hebat! "${item.title}" selesai '
          '(+${item.litersSaved} L, +${item.points} Poin) 💧',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F4C81),
      ),
    );
  }

  // TIMER SHOWER

  void _toggleShowerTimer() {
    if (_isShowerTimerRunning) {
      _showerTimer?.cancel();

      setState(() {
        _isShowerTimerRunning = false;
      });
    } else {
      if (_showerSecondsRemaining <= 0) {
        _resetShowerTimer();
      }

      setState(() {
        _isShowerTimerRunning = true;
      });

      _showerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_showerSecondsRemaining > 1) {
          setState(() {
            _showerSecondsRemaining--;
          });
        } else {
          timer.cancel();

          setState(() {
            _showerSecondsRemaining = 0;
            _isShowerTimerRunning = false;

            final showerItem = _actions.firstWhere((a) => a.id == '2');

            if (!showerItem.isCompleted) {
              showerItem.isCompleted = true;
              _weeklySavedLiters += showerItem.litersSaved;

              EcoPointsManager().addPoints(
                showerItem.points,
                'Aksi: ${showerItem.title}',
                category: 'aksi',
              );
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Waktu shower selesai! Target hemat 18 L tercapai 🚿',
              ),
              backgroundColor: Color(0xFF0284C7),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  void _resetShowerTimer() {
    _showerTimer?.cancel();

    setState(() {
      _isShowerTimerRunning = false;
      _showerSecondsRemaining = 300;
    });
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // LAPORAN KERUSAKAN FASILITAS
  // Tidak lagi menjadi aktivitas wajib harian.

  void _showRecordActionDialog() {
    final locationCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
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
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Row(
                      children: [
                        Icon(
                          Icons.report_problem_outlined,
                          color: Color(0xFF0284C7),
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Laporkan Kerusakan Fasilitas',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Gunakan formulir ini apabila kamu menemukan '
                      'kebocoran atau kerusakan fasilitas air di kampus.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: locationCtrl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lokasi wajib diisi.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Lokasi Kerusakan *',
                        hintText: 'Contoh: Toilet Gedung B Lt. 2',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: noteCtrl,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Keterangan kerusakan wajib diisi.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Keterangan Kerusakan *',
                        hintText: 'Contoh: Keran wastafel terus menetes...',
                        prefixIcon: const Icon(Icons.description_outlined),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '* Wajib diisi. Laporkan hanya jika ditemukan '
                      'kerusakan yang nyata.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          setState(() {
                            _facilityReports.add({
                              'location': locationCtrl.text.trim(),
                              'note': noteCtrl.text.trim(),
                            });
                          });

                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Laporan kerusakan berhasil dicatat.',
                              ),
                              backgroundColor: Color(0xFF0F4C81),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          locationCtrl.dispose();
                          noteCtrl.dispose();
                        },
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Kirim Laporan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4C81),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // TAMBAH AKTIVITAS MANDIRI

  void _showAddCustomActionModal() {
    final titleCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String category = 'Kamar Mandi';
    int savedLiters = 15;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
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
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Row(
                          children: [
                            Icon(
                              Icons.add_task_rounded,
                              color: Color(0xFF0284C7),
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Tambah Aktivitas Mandiri',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Buat aktivitas hemat air sesuai kebiasaanmu.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: titleCtrl,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama aktivitas wajib diisi.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Nama Aktivitas *',
                            hintText: 'Contoh: Menampung air bekas AC',
                            prefixIcon: const Icon(Icons.water_drop_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: InputDecoration(
                            labelText: 'Kategori Aktivitas *',
                            prefixIcon: const Icon(Icons.category_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Kamar Mandi',
                              child: Text('Kamar Mandi'),
                            ),
                            DropdownMenuItem(
                              value: 'Dapur',
                              child: Text('Dapur'),
                            ),
                            DropdownMenuItem(
                              value: 'Lingkungan',
                              child: Text('Lingkungan'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() {
                                category = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Estimasi Penghematan Air *',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          '$savedLiters Liter / hari',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        Slider(
                          value: savedLiters.toDouble(),
                          min: 5,
                          max: 50,
                          divisions: 9,
                          activeColor: const Color(0xFF0284C7),
                          onChanged: (value) {
                            setModalState(() {
                              savedLiters = value.round();
                            });
                          },
                        ),

                        const Text(
                          'Geser untuk menentukan perkiraan '
                          'jumlah air yang dapat dihemat.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFF0284C7),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Aktivitas yang kamu buat akan '
                                  'memiliki penanda AKSI SAYA agar '
                                  'mudah dibedakan dari aktivitas '
                                  'bawaan AquaGuard.',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF334155),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              final newAction = ActionItemModel(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                category: category.toUpperCase(),
                                title: titleCtrl.text.trim(),
                                litersSaved: savedLiters,
                                points: 10,
                                icon: Icons.task_alt_rounded,
                                isCustom: true,
                              );

                              setState(() {
                                _actions.add(newAction);
                                _selectedCategory = 'Semua';
                              });

                              Navigator.pop(ctx);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Aktivitas baru berhasil ditambahkan!',
                                  ),
                                  backgroundColor: Color(0xFF0F4C81),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );

                              titleCtrl.dispose();
                            },
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Simpan Aktivitas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F4C81),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // KOMITMEN KOMUNITAS

  void _toggleCampusCommitment() {
    setState(() {
      _isCampusCommitmentJoined = !_isCampusCommitmentJoined;

      if (_isCampusCommitmentJoined) {
        _campusVolunteers++;
        _campusCollectedLiters += 20;

        EcoPointsManager().addPoints(
          20,
          'Komitmen Mahasiswa Kampus Hijau',
          category: 'aksi',
        );
      } else {
        _campusVolunteers--;
        _campusCollectedLiters -= 20;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCampusCommitmentJoined
              ? 'Kamu berhasil bergabung dalam Misi Kampus Hijau!'
              : 'Keikutsertaan komunitas diperbarui.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F4C81),
      ),
    );
  }

  // BUILD UTAMA

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FD),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopAppBar(),

                  const SizedBox(height: 22),

                  _buildPageTitleHeader(),

                  const SizedBox(height: 20),

                  _buildWeeklySavingsSummaryCard(),

                  const SizedBox(height: 24),

                  _buildDailyChecklistSection(),

                  const SizedBox(height: 22),

                  _buildFacilityReportCard(),

                  const SizedBox(height: 22),

                  _buildCollectiveMissionCard(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // HEADER APLIKASI

  Widget _buildTopAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/aquaguard_logo.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
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
                    );
                  },
                ),
              ),

              const SizedBox(width: 8),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AquaGuard',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F3B5F),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        if (widget.onNavigateToBeranda != null) {
                          widget.onNavigateToBeranda!();
                        } else {
                          widget.onBottomNavTap?.call(0);
                        }
                      },
                      child: const Text(
                        'Beranda',
                        style: TextStyle(
                          fontSize: 11,
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

        const EcoPointsPillWidget(),

        const SizedBox(width: 6),

        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tidak ada notifikasi baru hari ini.'),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF1E293B),
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF0F3B5F),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  // JUDUL HALAMAN

  Widget _buildPageTitleHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aksi & Kebiasaan Air',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tindakan kecil harian untuk dampak nyata SDG 6',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: const Icon(
            Icons.verified_rounded,
            color: Color(0xFF0284C7),
            size: 24,
          ),
        ),
      ],
    );
  }

  // FILTER KATEGORI
  // Sekarang berada tepat di bawah judul checklist.

  Widget _buildCategoryFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((cat) {
          final String name = cat['name'];
          final IconData icon = cat['icon'];
          final bool isSelected = _selectedCategory == name;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = name;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0F4C81)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0F4C81)
                        : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0F4C81)
                                .withValues(alpha: 0.18),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF475569),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // RINGKASAN PENGHEMATAN MINGGUAN

  Widget _buildWeeklySavingsSummaryCard() {
    final double percent = (_weeklySavedLiters / _weeklyTargetLiters).clamp(
      0.0,
      1.0,
    );

    final int displayPercent = (percent * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0277BD), Color(0xFF007A99), Color(0xFF00838F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildSummaryBadge(
                Icons.shield_outlined,
                'Level $_userLevel: $_levelTitle',
              ),
              _buildSummaryBadge(
                Icons.local_fire_department_rounded,
                '$_streakDays Hari Streak!',
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL HEMAT MINGGU INI',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$_weeklySavedLiters',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Liter',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Target Mingguan (SDG 6.4)',
                  style: TextStyle(color: Colors.white, fontSize: 11.5),
                ),
              ),

              Text(
                '$_weeklySavedLiters / $_weeklyTargetLiters L '
                '($displayPercent%)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // CHECKLIST AKTIVITAS HARIAN

  Widget _buildDailyChecklistSection() {
    final filtered = _filteredActions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER CHECKLIST + TOMBOL TAMBAH

        Row(
          children: [
            const Icon(
              Icons.checklist_rounded,
              color: Color(0xFF0284C7),
              size: 21,
            ),

            const SizedBox(width: 8),

            const Expanded(
              child: Text(
                'Checklist Aksi Harian',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),

            Text(
              '$_completedCount/${_actions.length}',
              style: const TextStyle(
                color: Color(0xFF0F4C81),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        const Text(
          'Pilih dan selesaikan kebiasaan hemat air setiap hari.',
          style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
        ),

        const SizedBox(height: 14),

        // TOMBOL TAMBAH AKTIVITAS DIPINDAHKAN KE ATAS
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showAddCustomActionModal,
            icon: const Icon(Icons.add_circle_outline_rounded, size: 19),
            label: const Text(
              'Tambah Aktivitas Mandiri',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0284C7),
              side: const BorderSide(color: Color(0xFF7DD3FC)),
              backgroundColor: const Color(0xFFF0F9FF),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        // FILTER BERADA DI ATAS DAFTAR AKTIVITAS
        const Text(
          'Filter Kategori',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF475569),
          ),
        ),

        const SizedBox(height: 10),

        _buildCategoryFilterRow(),

        const SizedBox(height: 16),

        // DAFTAR AKTIVITAS
        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 36,
                  color: Color(0xFF94A3B8),
                ),
                SizedBox(height: 8),
                Text(
                  'Belum ada aktivitas dalam kategori ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
          )
        else
          ...filtered.map((item) => _buildActionCard(item)),
      ],
    );
  }

  // KARTU AKTIVITAS

  Widget _buildActionCard(ActionItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isCustom
              ? const Color(0xFFBAE6FD)
              : const Color(0xFFF1F5F9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: const Color(0xFF0284C7),
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          size: 12,
                          color: Color(0xFF0284C7),
                        ),

                        const SizedBox(width: 3),

                        Text(
                          '+${item.litersSaved} L/hari',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F4C81),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          '+${item.points} Poin',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: () => _toggleAction(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isCompleted
                        ? const Color(0xFF0F4C81)
                        : Colors.transparent,
                    border: Border.all(
                      color: item.isCompleted
                          ? const Color(0xFF0F4C81)
                          : const Color(0xFF94A3B8),
                      width: 2,
                    ),
                  ),
                  child: item.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ),
            ],
          ),

          // PENANDA AKTIVITAS BUATAN PENGGUNA
          if (item.isCustom) ...[
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 12,
                      color: Color(0xFF0369A1),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'AKSI SAYA',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // TIMER SHOWER
          if (item.hasTimer) ...[
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.hourglass_top_rounded,
                    size: 15,
                    color: Color(0xFF475569),
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      'Timer: ${_formatTimer(_showerSecondsRemaining)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),

                  if (_isShowerTimerRunning || _showerSecondsRemaining < 300)
                    TextButton(
                      onPressed: _resetShowerTimer,
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),

                  ElevatedButton(
                    onPressed: _toggleShowerTimer,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFE0F2FE),
                      foregroundColor: const Color(0xFF0284C7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                    ),
                    child: Text(
                      _isShowerTimerRunning ? 'Jeda' : 'Mulai',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
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

  // BAGIAN LAPORAN FASILITAS
  // Dipisahkan dari checklist aktivitas harian.

  Widget _buildFacilityReportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.build_circle_outlined,
                color: Color(0xFF0284C7),
                size: 22,
              ),

              SizedBox(width: 8),

              Expanded(
                child: Text(
                  'Pelaporan Fasilitas Kampus',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Temukan keran bocor, pipa rusak, atau fasilitas '
            'air bermasalah? Laporkan agar dapat segera '
            'ditindaklanjuti oleh pihak kampus.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  '${_facilityReports.length} laporan dicatat',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),

              OutlinedButton.icon(
                onPressed: _showRecordActionDialog,
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text(
                  'Buat Laporan',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0284C7),
                  side: const BorderSide(color: Color(0xFF7DD3FC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          if (_facilityReports.isNotEmpty) ...[
            const Divider(height: 20),

            const Text(
              'Laporan yang telah dicatat',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF334155),
              ),
            ),

            const SizedBox(height: 8),

            ..._facilityReports.asMap().entries.map((entry) {
              final report = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF0284C7),
                      size: 17,
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report['location']!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            report['note']!,
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
            }),
          ],
        ],
      ),
    );
  }

  // MISI KOMUNITAS KAMPUS

  Widget _buildCollectiveMissionCard() {
    final double percent = (_campusCollectedLiters / _campusTargetLiters).clamp(
      0.0,
      1.0,
    );

    final int displayPercent = (percent * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
          // IDENTITAS KOMUNITAS

          Row(
            children: [
              const Icon(
                Icons.groups_rounded,
                color: Color(0xFF0284C7),
                size: 21,
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'MISI KOMUNITAS KAMPUS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0284C7),
                    letterSpacing: 0.4,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$displayPercent% Tercapai',
                  style: const TextStyle(
                    color: Color(0xFF0369A1),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Tantangan Kampus Hijau',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Aksi bersama seluruh mahasiswa untuk '
            'mengumpulkan 1.000 liter air melalui kebiasaan '
            'hemat dan pemanfaatan air secara bijak.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          // BANNER KOMUNITAS
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/kampus_hijau.jpg',
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 140,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF0F4C81)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        color: Colors.white,
                        size: 18,
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          '$_campusVolunteers mahasiswa telah bergabung',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TARGET DAN PROGRES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Progres Penghematan Komunitas',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Text(
                '$displayPercent%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F4C81),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 7,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF0F4C81),
              ),
            ),
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '$_campusCollectedLiters / $_campusTargetLiters Liter',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const Text(
                'Target: 1.000 L',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // INFORMASI KEIKUTSERTAAN
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF0284C7), size: 17),

                SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Berbeda dari checklist pribadi, misi ini '
                    'merupakan kegiatan bersama. Setiap mahasiswa '
                    'dapat berkontribusi untuk mencapai target kampus.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TOMBOL GABUNG
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _toggleCampusCommitment,
              icon: Icon(
                _isCampusCommitmentJoined
                    ? Icons.check_circle_rounded
                    : Icons.volunteer_activism_outlined,
                color: Colors.white,
                size: 19,
              ),
              label: Text(
                _isCampusCommitmentJoined
                    ? 'Kamu Telah Bergabung'
                    : 'Gabung Misi Kampus Hijau',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: _isCampusCommitmentJoined
                    ? const Color(0xFF059669)
                    : const Color(0xFF0F4C81),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentNavIndex,
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
