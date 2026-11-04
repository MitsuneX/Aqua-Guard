import 'package:flutter/material.dart';

import '../screens/shop_screen.dart';

/// Transaksi Riwayat Eco-Points
class EcoPointTransaction {
  final String title;
  final int points; // Nilai positif = perolehan, negatif = penukaran
  final DateTime date;
  final String category; // 'misi', 'kuis', 'aksi', 'shop'

  const EcoPointTransaction({
    required this.title,
    required this.points,
    required this.date,
    required this.category,
  });
}

/// Pengelola State Tunggal (Singleton) Eco-Points AquaGuard
/// Memastikan perolehan poin dari Misi, Kuis, Aksi, maupun penukaran di Shop
/// langsung tersinkronisasi secara reaktif di seluruh halaman aplikasi.
class EcoPointsManager extends ChangeNotifier {
  static final EcoPointsManager _instance = EcoPointsManager._internal();
  factory EcoPointsManager() => _instance;
  EcoPointsManager._internal();

  int _points = 850;
  int get points => _points;

  final List<EcoPointTransaction> _history = [
    EcoPointTransaction(
      title: 'Tantangan Mingguan Mandi Singkat Selesai',
      points: 50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'misi',
    ),
    EcoPointTransaction(
      title: 'Kuis Kilat Deteksi Keran Bocor Benar',
      points: 15,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'kuis',
    ),
    EcoPointTransaction(
      title: 'Aksi Tutup Keran Saat Sikat Gigi',
      points: 10,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'aksi',
    ),
    EcoPointTransaction(
      title: 'Aksi Daur Ulang Air Tanaman',
      points: 10,
      date: DateTime.now().subtract(const Duration(days: 4)),
      category: 'aksi',
    ),
  ];

  List<EcoPointTransaction> get history => List.unmodifiable(_history);

  /// Tambah Poin (dari Misi Harian, Kuis Kilat, Catat Aksi, dll)
  void addPoints(int amount, String title, {String category = 'misi'}) {
    if (amount <= 0) return;
    _points += amount;
    _history.insert(
      0,
      EcoPointTransaction(
        title: title,
        points: amount,
        date: DateTime.now(),
        category: category,
      ),
    );
    notifyListeners();
  }

  /// Tukar Poin di Shop
  bool redeemPoints(int amount, String rewardTitle) {
    if (_points >= amount) {
      _points -= amount;
      _history.insert(
        0,
        EcoPointTransaction(
          title: 'Tukar: $rewardTitle',
          points: -amount,
          date: DateTime.now(),
          category: 'shop',
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}

/// Widget Kapsul Poin Reaktif di AppBar (💧 850 pts)
/// Sesuai desain Gambar 3: ketika ditekan langsung membuka Halaman Shop (Pusat Tukar Poin)
class EcoPointsPillWidget extends StatelessWidget {
  final VoidCallback? customOnTap;
  final bool isHeaderStyle;

  const EcoPointsPillWidget({
    super.key,
    this.customOnTap,
    this.isHeaderStyle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: EcoPointsManager(),
      builder: (context, _) {
        final currentPts = EcoPointsManager().points;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: customOnTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ShopScreen()),
                  );
                },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFBAE6FD),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.water_drop,
                    color: Color(0xFF0284C7),
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$currentPts pts',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF006296),
                      letterSpacing: -0.2,
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
}
