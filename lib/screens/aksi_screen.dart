import 'dart:async';
import 'package:flutter/material.dart';
import 'profile_screen.dart';

/// Model data representasi satu item checklist aksi kebiasaan air.
class ActionItemModel {
  final String id;
  final String category;
  final String title;
  final int litersSaved;
  final int points;
  final IconData icon;
  bool isCompleted;
  final bool hasTimer;
  final bool hasRecordAction;

  ActionItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.litersSaved,
    required this.points,
    required this.icon,
    this.isCompleted = false,
    this.hasTimer = false,
    this.hasRecordAction = false,
  });
}

/// Halaman Mandiri "Aksi & Kebiasaan Air" (Tab Aksi) - AquaGuard
/// Dibuat murni Flutter UI seluler sesuai dengan desain rujukan.
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
  // Filter Kategori
  String _selectedCategory = 'Semua';
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Semua', 'icon': Icons.grid_view_rounded},
    {'name': 'Kamar Mandi', 'icon': Icons.bathtub_outlined},
    {'name': 'Dapur', 'icon': Icons.soup_kitchen_outlined},
    {'name': 'Sampah', 'icon': Icons.recycling_outlined},
    {'name': 'Fasilitas Kampus', 'icon': Icons.business_outlined},
    {'name': 'Lingkungan', 'icon': Icons.eco_outlined},
  ];

  // Data Penghematan Mingguan (Mock Data)
  int _weeklySavedLiters = 142;
  final int _weeklyTargetLiters = 200;
  final int _streakDays = 5;
  final int _userLevel = 3;
  final String _levelTitle = 'Penjaga Mata Air';

  // Data Misi Kolektif Kampus
  int _campusVolunteers = 184;
  int _campusCollectedLiters = 740;
  final int _campusTargetLiters = 1000;
  bool _isCampusCommitmentJoined = false;

  // State Timer Shower Aktif
  Timer? _showerTimer;
  int _showerSecondsRemaining = 300; // 05:00 menit
  bool _isShowerTimerRunning = false;

  // Daftar Mock Data Aksi Harian
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
        icon: Icons.sanitizer_outlined,
        isCompleted: true, // Selesai
      ),
      ActionItemModel(
        id: '2',
        category: 'MANDI',
        title: 'Kurangi Shower 2 Menit',
        litersSaved: 18,
        points: 15,
        icon: Icons.timer_outlined,
        isCompleted: false, // Belum selesai, ada widget timer
        hasTimer: true,
      ),
      ActionItemModel(
        id: '3',
        category: 'DAPUR',
        title: 'Gunakan Baskom Cuci Piring',
        litersSaved: 25,
        points: 15,
        icon: Icons.soup_kitchen_outlined,
        isCompleted: false, // Belum selesai
      ),
      ActionItemModel(
        id: '4',
        category: 'FASILITAS KAMPUS',
        title: 'Cek & Laporkan Kerusakan',
        litersSaved: 30,
        points: 25,
        icon: Icons.edit_note_rounded,
        isCompleted: false,
        hasRecordAction: true, // Tombol aksi Catat Aksi
      ),
      ActionItemModel(
        id: '5',
        category: 'LINGKUNGAN',
        title: 'Daur Ulang Air untuk Tanaman',
        litersSaved: 15,
        points: 10,
        icon: Icons.eco_outlined,
        isCompleted: true, // Selesai
      ),
    ];
  }

  @override
  void dispose() {
    _showerTimer?.cancel();
    super.dispose();
  }

  // Filter list aksi berdasarkan kategori yang dipilih
  List<ActionItemModel> get _filteredActions {
    if (_selectedCategory == 'Semua') {
      return _actions;
    }
    return _actions.where((item) {
      if (_selectedCategory == 'Kamar Mandi') {
        return item.category == 'KAMAR MANDI' || item.category == 'MANDI';
      }
      return item.category.toLowerCase().contains(_selectedCategory.toLowerCase());
    }).toList();
  }

  // Toggle status checklist aksi
  void _toggleAction(ActionItemModel item) {
    setState(() {
      item.isCompleted = !item.isCompleted;
      if (item.isCompleted) {
        _weeklySavedLiters += item.litersSaved;
      } else {
        _weeklySavedLiters -= item.litersSaved;
      }
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.isCompleted
              ? 'Hebat! "${item.title}" selesai (+${item.litersSaved} L, +${item.points} Poin) 💧🎉'
              : 'Status "${item.title}" dibatalkan.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor:
            item.isCompleted ? const Color(0xFF0F4C81) : const Color(0xFF475569),
      ),
    );
  }

  // Logika stopwatch timer shower
  void _toggleShowerTimer() {
    if (_isShowerTimerRunning) {
      _showerTimer?.cancel();
      setState(() {
        _isShowerTimerRunning = false;
      });
    } else {
      setState(() {
        _isShowerTimerRunning = true;
      });
      _showerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_showerSecondsRemaining > 0) {
          setState(() {
            _showerSecondsRemaining--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isShowerTimerRunning = false;
            // Otomatis tandai aksi shower selesai jika waktu habis
            final showerItem = _actions.firstWhere(
              (a) => a.id == '2',
              orElse: () => _actions[1],
            );
            if (!showerItem.isCompleted) {
              showerItem.isCompleted = true;
              _weeklySavedLiters += showerItem.litersSaved;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Waktu shower selesai! Target hemat 18 L tercapai 🚿👏'),
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

  String _formatTimer(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Toggle Gabung Komitmen Mahasiswa
  void _toggleCampusCommitment() {
    setState(() {
      _isCampusCommitmentJoined = !_isCampusCommitmentJoined;
      if (_isCampusCommitmentJoined) {
        _campusVolunteers += 1;
        _campusCollectedLiters += 20;
      } else {
        _campusVolunteers -= 1;
        _campusCollectedLiters -= 20;
      }
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCampusCommitmentJoined
              ? 'Terima kasih telah bergabung dalam Komitmen Kampus Hijau! (+20 L) 🎓💧'
              : 'Komitmen mahasiswa diperbarui.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF0F4C81),
      ),
    );
  }

  // Dialog Catat Aksi (Fasilitas Kampus)
  void _showRecordActionDialog() {
    final TextEditingController locationCtrl = TextEditingController(text: 'Toilet Gedung B Lt. 2');
    final TextEditingController noteCtrl = TextEditingController(text: 'Keran wastafel menetes perlahan');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
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
                    child: const Icon(Icons.build_rounded, color: Color(0xFF0284C7), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catat Aksi Fasilitas Kampus',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Lapor kebocoran air untuk dampak nyata',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: locationCtrl,
                decoration: InputDecoration(
                  labelText: 'Lokasi Fasilitas',
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Keterangan Kerusakan / Kebocoran',
                  prefixIcon: const Icon(Icons.description_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      final item = _actions.firstWhere((a) => a.id == '4');
                      if (!item.isCompleted) {
                        item.isCompleted = true;
                        _weeklySavedLiters += item.litersSaved;
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Laporan tersimpan! Aksi diselesaikan (+30 L, +25 Poin) 🛠️💧'),
                        backgroundColor: Color(0xFF0F4C81),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                  label: const Text(
                    'Kirim & Selesaikan Aksi (+30 L)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4C81),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Modal Tambah Aksi Mandiri (+ Tambah Aksi Mandiri)
  void _showAddCustomActionModal() {
    final TextEditingController titleCtrl = TextEditingController();
    String category = 'Kamar Mandi';
    int savedLiters = 15;
    int points = 10;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
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
                  const Row(
                    children: [
                      Icon(Icons.add_task_rounded, color: Color(0xFF0284C7), size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Tambah Aksi Mandiri Baru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Buat kebiasaan hemat air harian versimu sendiri',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nama Kebiasaan / Aksi',
                      hintText: 'Contoh: Tampung air AC untuk pel lantai',
                      prefixIcon: const Icon(Icons.water_drop_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      prefixIcon: const Icon(Icons.category_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Kamar Mandi', child: Text('Kamar Mandi')),
                      DropdownMenuItem(value: 'Dapur', child: Text('Dapur')),
                      DropdownMenuItem(value: 'Lingkungan', child: Text('Lingkungan')),
                      DropdownMenuItem(value: 'Fasilitas Kampus', child: Text('Fasilitas Kampus')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => category = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimasi Hemat: $savedLiters L/hari',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Slider(
                              value: savedLiters.toDouble(),
                              min: 5,
                              max: 50,
                              divisions: 9,
                              activeColor: const Color(0xFF0284C7),
                              onChanged: (val) {
                                setModalState(() => savedLiters = val.round());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) return;
                        Navigator.pop(ctx);
                        setState(() {
                          _actions.add(
                            ActionItemModel(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              category: category.toUpperCase(),
                              title: titleCtrl.text.trim(),
                              litersSaved: savedLiters,
                              points: points,
                              icon: Icons.task_alt_rounded,
                              isCompleted: false,
                            ),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Aksi "${titleCtrl.text.trim()}" berhasil ditambahkan! 💧'),
                            backgroundColor: const Color(0xFF0F4C81),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'Simpan Aksi Mandiri',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4C81),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _actions.where((item) => item.isCompleted).length;
    final int totalCount = _actions.length;

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
                  // 1. Header (App Bar Kustom)
                  _buildTopAppBar(),
                  const SizedBox(height: 20),

                  // 2. Judul Halaman & Lencana Verifikasi
                  _buildPageTitleHeader(),
                  const SizedBox(height: 16),

                  // 3. Filter Kategori (Horizontal Scrollable)
                  _buildCategoryFilterRow(),
                  const SizedBox(height: 20),

                  // 4. Kartu Ringkasan Mingguan (Gradient Biru)
                  _buildWeeklySavingsSummaryCard(),
                  const SizedBox(height: 24),

                  // 5. Bagian Checklist Aksi Harian
                  _buildDailyChecklistSection(completedCount, totalCount),
                  const SizedBox(height: 24),

                  // 6. Kartu Misi Kolektif SDG 6
                  _buildCollectiveMissionCard(),
                  const SizedBox(height: 20),

                  // 7. Tombol Aksi Tambah Mandiri (Floating-style button di atas nav)
                  _buildAddActionButton(),
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
            // Logo AquaGuard resmi
            Image.asset(
              'assets/images/aquaguard_logo.png',
              width: 44,
              height: 44,
              fit: BoxFit.contain,
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak ada notifikasi baru hari ini.'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            // Tombol Avatar Profil
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

  // 2. Judul Halaman & Lencana Verifikasi
  Widget _buildPageTitleHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Aksi & Kebiasaan Air',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tindakan kecil harian untuk dampak nyata SDG 6',
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
        // Lencana Verifikasi / Prestasi (lingkaran biru muda berikon centang verified)
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
          ),
          child: const Center(
            child: Icon(
              Icons.verified_rounded,
              color: Color(0xFF0284C7),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  // 3. Filter Kategori (Horizontal Scrollable Chips)
  Widget _buildCategoryFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((cat) {
          final String name = cat['name'] as String;
          final IconData icon = cat['icon'] as IconData;
          final bool isSelected = _selectedCategory == name;

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = name;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F4C81) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0F4C81) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0F4C81).withValues(alpha: 0.2),
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
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF334155),
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

  // 4. Kartu Ringkasan Mingguan (Gradient Biru Elegan)
  Widget _buildWeeklySavingsSummaryCard() {
    final double targetPercent = (_weeklySavedLiters / _weeklyTargetLiters).clamp(0.0, 1.0);
    final int displayPercent = (targetPercent * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0277BD), // Biru cerah atas
            Color(0xFF007A99), // Biru tengah
            Color(0xFF00838F), // Toska tua
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Badge Level & Streak
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              // Badge Level
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Level $_userLevel: $_levelTitle',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge Streak
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 14,
                      color: Color(0xFFFED7AA),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_streakDays Hari Streak!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Baris Tengah: Total Liter & Icon Drop
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL HEMAT MINGGU INI',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 2),
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
                          height: 1.05,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Liter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Ikon Tetesan Air dalam lingkaran translusen
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.water_drop_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Baris Bawah: Target Mingguan & Keterangan Persentase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Target Mingguan (SDG 6.4)',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_weeklySavedLiters / $_weeklyTargetLiters Liter ($displayPercent%)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Linear Progress Bar Putih
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                FractionallySizedBox(
                  widthFactor: targetPercent,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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

  // 5. Bagian Checklist Aksi Harian
  Widget _buildDailyChecklistSection(int completedCount, int totalCount) {
    final filtered = _filteredActions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Bagian & Status Selesai
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: const [
                  Icon(
                    Icons.checklist_rounded,
                    color: Color(0xFF0284C7),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Checklist Aksi Harian',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                text: 'Hari ini: ',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '$completedCount/$totalCount Selesai',
                    style: const TextStyle(
                      color: Color(0xFF0F4C81),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Daftar Item Checklist
        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.water_drop_outlined, color: Color(0xFF94A3B8), size: 36),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada aksi untuk kategori "$_selectedCategory"',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...filtered.map((item) => _buildActionCard(item)),
      ],
    );
  }

  // Komponen Satu Kartu Aksi Harian
  Widget _buildActionCard(ActionItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Kategori di Kotak Biru Muda
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    color: const Color(0xFF0284C7),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Detail Teks (Kategori, Judul, Penghematan & Poin)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.water_drop,
                              size: 12,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 2)),
                          TextSpan(
                            text: '+${item.litersSaved} L/hari',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F4C81),
                            ),
                          ),
                          const TextSpan(text: '  '),
                          TextSpan(
                            text: '+${item.points} Poin',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Trailing Widget: Centang Selesai / Lingkaran Kosong / Tombol Khusus
              if (item.hasRecordAction)
                // Tombol "Catat Aksi" (Item 4)
                GestureDetector(
                  onTap: _showRecordActionDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBAE6FD),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Catat Aksi',
                      style: TextStyle(
                        color: Color(0xFF0369A1),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              else
                // Tombol Centang Selesai / Lingkaran Kosong
                GestureDetector(
                  onTap: () => _toggleAction(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isCompleted ? const Color(0xFF0F4C81) : Colors.transparent,
                      border: Border.all(
                        color: item.isCompleted ? const Color(0xFF0F4C81) : const Color(0xFF94A3B8),
                        width: 2,
                      ),
                    ),
                    child: item.isCompleted
                        ? const Center(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),

          // Sub-widget Timer Shower (Khusus Item 2)
          if (item.hasTimer) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.hourglass_top_rounded,
                          size: 15,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Timer Shower Aktif: ${_formatTimer(_showerSecondsRemaining)}',
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
                  Row(
                    children: [
                      if (_isShowerTimerRunning || _showerSecondsRemaining < 300)
                        GestureDetector(
                          onTap: _resetShowerTimer,
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: _toggleShowerTimer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            _isShowerTimerRunning ? 'Jeda' : 'Mulai Timer',
                            style: const TextStyle(
                              color: Color(0xFF0284C7),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 6. Kartu Misi Kolektif Kampus SDG 6
  Widget _buildCollectiveMissionCard() {
    final double collectivePercent = (_campusCollectedLiters / _campusTargetLiters).clamp(0.0, 1.0);
    final int displayPercent = (collectivePercent * 100).toInt();

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
          // Header Baris: SDG 6 MISI KOLEKTIF & Badge Persentase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(
                      Icons.groups_outlined,
                      size: 17,
                      color: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'SDG 6 MISI KOLEKTIF',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0284C7),
                          letterSpacing: 0.6,
                        ),
                        overflow: TextOverflow.ellipsis,
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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '$displayPercent% Selesai',
                  style: const TextStyle(
                    color: Color(0xFF0369A1),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Judul Tantangan
          const Text(
            'Tantangan Kampus Hijau: 1.000L',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),

          // Foto Mahasiswa Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/kampus_hijau.jpg',
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 140,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF0F4C81)],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.school, color: Colors.white, size: 48),
                    ),
                  ),
                ),
                // Gradien Gelap Overlay di bagian bawah foto
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ),
                // Teks Keterangan di Atas Foto
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Bersama $_campusVolunteers relawan mahasiswa minggu ini',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Progress Bar Kolektif
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  color: const Color(0xFFE2E8F0),
                ),
                FractionallySizedBox(
                  widthFactor: collectivePercent,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F4C81),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Keterangan Pengumpulan & Sisa Hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$_campusCollectedLiters / $_campusTargetLiters Liter Terkumpul',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Sisa 2 Hari',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tombol Penuh: Gabung Komitmen Mahasiswa
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
                size: 18,
              ),
              label: Text(
                _isCampusCommitmentJoined
                    ? '✓ Komitmen Mahasiswa Aktif'
                    : 'Gabung Komitmen Mahasiswa',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCampusCommitmentJoined
                    ? const Color(0xFF059669)
                    : const Color(0xFF0F4C81),
                elevation: 0,
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

  // 7. Tombol Melayang Tambah Aksi Mandiri (+ Tambah Aksi Mandiri)
  Widget _buildAddActionButton() {
    return Center(
      child: GestureDetector(
        onTap: _showAddCustomActionModal,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFF0F4C81),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F4C81).withValues(alpha: 0.32),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                '+ Tambah Aksi Mandiri',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 8. Bottom Navigation Bar
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
