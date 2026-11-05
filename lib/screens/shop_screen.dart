import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/points_manager.dart';
import 'profile_screen.dart';

/// Model Data untuk Voucher / Kupon yang dimiliki Pengguna
class MyCouponItem {
  final String id;
  final String title;
  final String category;
  final String code;
  final String expiryDate;
  final IconData icon;
  final String benefitDesc;
  final List<String> usageSteps;
  final int pointsCost;
  bool isUsed;
  final DateTime redeemedAt;

  MyCouponItem({
    required this.id,
    required this.title,
    required this.category,
    required this.code,
    required this.expiryDate,
    required this.icon,
    required this.benefitDesc,
    required this.usageSteps,
    required this.pointsCost,
    this.isUsed = false,
    required this.redeemedAt,
  });
}

/// Halaman Shop / Pusat Tukar Poin (Eco-Points Reward Catalog)
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'Semua';
  bool _isGridView = true;

  // 5 Kategori Sesuai Permintaan Pengguna
  final _categories = const [
    'Semua',
    'Tagihan & Rumah',
    'Voucher Kampus',
    'Alat Hemat Air',
    'Merch & Donasi',
  ];

  // Daftar Kupon Aktif Milik Pengguna (Default Awal: 2 Kupon)
  late final List<MyCouponItem> _myCoupons = [
    MyCouponItem(
      id: 'cp_refill_init',
      title: 'Voucher Refill Air Kampus (5x)',
      category: 'Voucher Kampus',
      code: 'AQ-REFILL-8821',
      expiryDate: '30 Nov 2024',
      icon: Icons.water_drop_outlined,
      benefitDesc:
          'Bebas isi ulang air minum higienis di stasiun air pintar kampus gedung perkuliahan dan asrama.',
      usageSteps: [
        'Datangi stasiun air minum pintar kampus terdekat.',
        'Pindai QR Code kupon pada sensor scanner dispenser.',
        'Dekatkan tumbler dan nikmati air mineral segar sepuasnya.',
      ],
      pointsCost: 150,
      isUsed: false,
      redeemedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MyCouponItem(
      id: 'cp_coffee_init',
      title: 'Diskon 50% Kopi Bawa Tumbler',
      category: 'Voucher Kampus',
      code: 'AQ-TUMBLER-4491',
      expiryDate: '15 Des 2024',
      icon: Icons.coffee_outlined,
      benefitDesc:
          'Potongan 50% seluruh racikan kopi di kafe dan kantin rekanan kampus dengan membawa tumbler sendiri.',
      usageSteps: [
        'Kunjungi kafe atau tenant minuman kampus mitra resmi.',
        'Bawa tumbler bersih kamu dan pilih minuman kopi favorit.',
        'Tunjukkan QR Code kupon ke kasir untuk potongan harga 50%.',
      ],
      pointsCost: 200,
      isUsed: false,
      redeemedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Katalog Lengkap 15 Item Reward (Ramah Orang Awam & Mahasiswa)
  final List<Map<String, dynamic>> _catalogRewards = [
    // ── 1. TAGIHAN & RUMAH (3 Item) ──
    {
      'id': 'tr_1',
      'title': 'Potongan Tagihan Air PDAM Rp15.000',
      'subtitle': 'Voucher potongan langsung rekening air bulanan rumah/kos.',
      'fullDesc':
          'Voucher potongan tagihan PDAM sebesar Rp15.000 untuk meringankan beban biaya air bersih rumah tangga maupun anak kos. Berlaku di loket pembayaran tagihan air mitra resmi se-Indonesia.',
      'category': 'Tagihan & Rumah',
      'points': 600,
      'icon': Icons.receipt_long_rounded,
      'codePrefix': 'PDAM',
      'steps': [
        'Salin kode voucher digital dari menu Kuponku.',
        'Buka aplikasi pembayaran tagihan air (m-Banking / E-Commerce favoritmu).',
        'Masukkan kode voucher pada kolom promo saat bayar rekening air PDAM.',
      ],
    },
    {
      'id': 'tr_2',
      'title': 'Kupon Isi Ulang Galon Air Minum 3x',
      'subtitle': 'Gratis 3 kali isi ulang galon air minum higienis di depot mitra.',
      'fullDesc':
          'Kupon gratis 3x isi ulang galon standar 19 liter di depot air minum mitra resmi AquaGuard. Air diproses melalui 5 tahap filtrasi karbon aktif, ozonisasi, dan sterilisasi sinar UV.',
      'category': 'Tagihan & Rumah',
      'points': 150,
      'icon': Icons.local_drink_rounded,
      'codePrefix': 'GALON',
      'steps': [
        'Kunjungi depot air isi ulang mitra AquaGuard terdekat.',
        'Tunjukkan kode QR kupon dari aplikasi AquaGuard kepada kasir depot.',
        'Kasir memindai voucher dan galon air Anda langsung diisi gratis.',
      ],
    },
    {
      'id': 'tr_3',
      'title': 'Sabun Cuci Piring Eco-Enzyme Ramah Air',
      'subtitle': 'Formula organik cepat dibilas, hemat air cucian hingga 40%.',
      'fullDesc':
          'Cairan pembersih piring dan peralatan makan dari fermentasi bahan alami buah. Bebas deterjen kimia keras, mudah dibilas tanpa sisa busa beracun, aman bagi tanah dan menghemat air bilasan hingga 40%.',
      'category': 'Tagihan & Rumah',
      'points': 300,
      'icon': Icons.eco_rounded,
      'codePrefix': 'SABUN',
      'steps': [
        'Klaim item di aplikasi dan ambil paket di titik drop-point/kantor mitra.',
        'Tuangkan 1 sendok makan sabun ke spons basah untuk membersihkan cucian.',
        'Bilas cukup sekali dengan kucuran air hemat mengalir.',
      ],
    },

    // ── 2. VOUCHER KAMPUS (4 Item) ──
    {
      'id': 'vk_1',
      'title': 'Voucher Refill Air Kampus (5x)',
      'subtitle': 'Isi ulang air mineral gratis di stasiun air pintar kampus.',
      'fullDesc':
          'Voucher digital untuk 5 kali isi ulang botol/tumbler di seluruh dispenser air minum otomatis gedung kuliah, laboratorium, perpustakaan, dan asrama kampus.',
      'category': 'Voucher Kampus',
      'points': 150,
      'icon': Icons.water_drop_outlined,
      'codePrefix': 'REFILL',
      'steps': [
        'Datangi stasiun air minum pintar kampus terdekat.',
        'Pindai QR Code voucher pada sensor scanner dispenser.',
        'Dekatkan tumbler dan isi air mineral segar sepuasnya.',
      ],
    },
    {
      'id': 'vk_2',
      'title': 'Diskon 50% Kopi Bawa Tumbler',
      'subtitle': 'Diskon 50% kopi favorit dengan membawa tumbler sendiri ke kafe.',
      'fullDesc':
          'Potongan harga 50% untuk seluruh menu kopi di kafe dan kantin kampus rekanan SDG 6 bagi relawan yang membawa tumbler minum pribadi demi kurangi sampah plastik sekali pakai.',
      'category': 'Voucher Kampus',
      'points': 200,
      'icon': Icons.coffee_outlined,
      'codePrefix': 'KOPI',
      'steps': [
        'Kunjungi kafe atau tenant minuman kampus mitra resmi.',
        'Bawa tumbler bersih kamu dan pilih menu kopi favorit.',
        'Tunjukkan QR kupon ke kasir untuk mendapatkan diskon 50%.',
      ],
    },
    {
      'id': 'vk_3',
      'title': 'Gratis Cuci Motor Hemat Air',
      'subtitle': 'Cuci motor steam uap salju yang hemat hingga 80% air bersih.',
      'fullDesc':
          'Voucher gratis 1x cuci motor di tempat cuci mitra kampus yang menggunakan teknologi steam uap bertekanan tinggi ramah lingkungan, hanya memakai 15 liter air per motor (dibandingkan 80 liter cuci biasa).',
      'category': 'Voucher Kampus',
      'points': 350,
      'icon': Icons.two_wheeler_rounded,
      'codePrefix': 'STEAM',
      'steps': [
        'Datang ke mitra cuci motor uap ramah lingkungan kampus.',
        'Tunjukkan kode voucher di aplikasi sebelum proses pencucian.',
        'Tunggu hingga motor bersih mengkilap tanpa membayar biaya jasa.',
      ],
    },
    {
      'id': 'vk_4',
      'title': 'Voucher Makan Siang Kantin Hijau',
      'subtitle': 'Potongan makan siang Rp15.000 menu bergizi minim jejak air.',
      'fullDesc':
          'Voucher subsidi makan siang senilai Rp15.000 di kantin kampus hijau. Berlaku untuk menu sehat bergizi yang disiapkan dari bahan lokal berkelanjutan berjejak air rendah.',
      'category': 'Voucher Kampus',
      'points': 500,
      'icon': Icons.restaurant_menu_rounded,
      'codePrefix': 'KANTIN',
      'steps': [
        'Pesan makanan pilihanmu di kantin mitra berstiker AquaGuard.',
        'Tunjukkan QR Code kupon saat pembayaran di kasir.',
        'Tagihan makan siangmu langsung dipotong Rp15.000.',
      ],
    },

    // ── 3. ALAT HEMAT AIR (4 Item) ──
    {
      'id': 'ah_1',
      'title': 'Aerator Keran Hemat Air 50%',
      'subtitle': 'Nosel keran campur udara, kucuran kencang namun hemat 50% air.',
      'fullDesc':
          'Nosel aerator keran stainless universal yang mencampurkan gelembung udara ke aliran air keran. Semburan terasa tetap kencang dan nyaman untuk cuci tangan, namun debit air yang keluar berkurang hingga 50%!',
      'category': 'Alat Hemat Air',
      'points': 350,
      'icon': Icons.tune_rounded,
      'codePrefix': 'AERATOR',
      'steps': [
        'Klaim item dan ambil aerator di sekretariat relawan atau dikirim ke alamatmu.',
        'Pasang putar nosel aerator di ujung bibir keran dapur atau wastafel.',
        'Rasakan kucuran lembut bertenaga yang langsung hemat separuh air.',
      ],
    },
    {
      'id': 'ah_2',
      'title': 'Filter Keran Penjernih Air Karbon Aktif',
      'subtitle': 'Penyaring karbon aktif penyerap kaporit, karat, dan bau tak sedap.',
      'fullDesc':
          'Filter keran portabel mini dengan 5 lapis karbon aktif dan batuan mineral alami. Menyaring partikel kotoran karat pipa, residu klorin/kaporit, serta bau tanah sehingga air keran rumah menjadi jernih dan higienis.',
      'category': 'Alat Hemat Air',
      'points': 500,
      'icon': Icons.filter_alt_outlined,
      'codePrefix': 'FILTER',
      'steps': [
        'Buka kemasan filter keran karbon aktif yang telah diklaim.',
        'Masukkan konektor karet universal ke bibir keran air rumah Anda.',
        'Kencangkan klem pengunci dan air jernih segar siap digunakan.',
      ],
    },
    {
      'id': 'ah_3',
      'title': 'Timer Mandi Pasir 4 Menit',
      'subtitle': 'Jam pasir tahan air berperekat untuk panduan shower hemat air.',
      'fullDesc':
          'Jam pasir mungil anti-air yang dilengkapi perekat suction cup untuk ditempelkan di dinding keramik shower. Mengingatkan Anda saat durasi mandi shower mencapai 4 menit ideal (menghemat hingga 40 liter air per sesi).',
      'category': 'Alat Hemat Air',
      'points': 250,
      'icon': Icons.hourglass_top_rounded,
      'codePrefix': 'TIMER',
      'steps': [
        'Tempelkan karet penghisap timer pada dinding keramik kamar mandi.',
        'Balikkan jam pasir tepat saat kamu mulai menyalakan keran shower.',
        'Selesaikan bilasan sebelum butiran pasir habis turun (4 menit).',
      ],
    },
    {
      'id': 'ah_4',
      'title': 'Tablet Cek Bocor Kloset',
      'subtitle': 'Tablet pewarna alami untuk deteksi kebocoran tersembunyi kloset.',
      'fullDesc':
          'Tablet pewarna ramah lingkungan untuk mendeteksi rembesan tangki toilet duduk yang tak terlihat. Kebocoran toilet tersembunyi dapat membuang sia-sia hingga 200 liter air bersih per hari tanpa disadari.',
      'category': 'Alat Hemat Air',
      'points': 150,
      'icon': Icons.science_outlined,
      'codePrefix': 'TABLET',
      'steps': [
        'Masukkan 1 tablet biru ke dalam tangki penampung air kloset duduk.',
        'Tunggu selama 15 menit tanpa menekan tuas tombol flush.',
        'Jika mangkuk kloset berubah biru, berarti terjadi rembesan katup yang perlu diperbaiki.',
      ],
    },

    // ── 4. MERCH & DONASI (4 Item) ──
    {
      'id': 'md_1',
      'title': 'Tumbler Stainless AquaGuard 500ml',
      'subtitle': 'Botol minum insulasi termal SUS304 tahan dingin 24 jam & tahan panas 12 jam.',
      'fullDesc':
          'Tumbler eksklusif berlogo resmi AquaGuard SDG 6 berbahan food grade double-wall stainless steel 304. Bebas BPA, anti karat, anti bocor, dan menjaga kesegaran air minum Anda sepanjang hari.',
      'category': 'Merch & Donasi',
      'points': 750,
      'icon': Icons.local_drink_rounded,
      'codePrefix': 'TUMBLER',
      'steps': [
        'Tukar kupon di aplikasi dan ambil tumbler di booth Merchandise SDG 6.',
        'Cuci bersih sebelum penggunaan pertama dengan air hangat.',
        'Bawa tumbler setiap hari untuk menolak pembelian botol plastik sekali pakai.',
      ],
    },
    {
      'id': 'md_2',
      'title': 'Totebag Kanvas Save Water',
      'subtitle': 'Tas kanvas katun daur ulang dengan kompartemen khusus botol air.',
      'fullDesc':
          'Tas jinjing kanvas kuat berdesain infografis edukasi konservasi air. Dibuat dari benang serat katun daur ulang ramah lingkungan yang menghemat ribuan liter air dalam rantai pasok tekstil.',
      'category': 'Merch & Donasi',
      'points': 450,
      'icon': Icons.shopping_bag_outlined,
      'codePrefix': 'TOTEBAG',
      'steps': [
        'Ambil tas fisik dengan menunjukkan kode kupon di pusat relawan.',
        'Gunakan untuk membawa buku kuliah, laptop, atau belanjaan mingguan.',
        'Sebarkan pesan kesadaran hemat air kepada orang-orang di sekitarmu.',
      ],
    },
    {
      'id': 'md_3',
      'title': 'Donasi Sabun & Sanitasi Sekolah',
      'subtitle': 'Penyediaan sabun cuci tangan & pembersih toilet di SD pelosok.',
      'fullDesc':
          'Paket donasi sabun batang antibakteri, cairan disinfektan, dan edukasi Cuci Tangan Pakai Sabun (CTPS) bagi murid-murid di sekolah dasar pedesaan yang minim fasilitas kebersihan.',
      'category': 'Merch & Donasi',
      'points': 400,
      'icon': Icons.clean_hands_rounded,
      'codePrefix': 'DONASI',
      'steps': [
        'Poin Anda langsung dikonversikan menjadi paket sabun & logistik sanitasi.',
        'Relawan AquaGuard mendistribusikan bantuan ke sekolah target.',
        'Laporan dokumentasi foto penyaluran akan dikirimkan ke tab Notifikasi akunmu.',
      ],
    },
    {
      'id': 'md_4',
      'title': 'Patungan Filter Air Desa Krisis Air',
      'subtitle': 'Donasi instalasi sistem penyaringan air minum bersih 1 keluarga desa.',
      'fullDesc':
          'Sumbangan pengadaan instalasi tabung filter pasir silika dan membran ultrafiltrasi untuk menyediakan air siap minum bagi keluarga di wilayah kekeringan dan krisis air bersih berkepanjangan.',
      'category': 'Merch & Donasi',
      'points': 1200,
      'icon': Icons.water_drop_rounded,
      'codePrefix': 'DESA',
      'steps': [
        'Konfirmasi penukaran poin Anda untuk berkontribusi pada instalasi filter air komunal.',
        'Tim teknis AquaGuard memasang unit penyaring di desa penerima manfaat.',
        'Sertifikat donasi digital dan koordinat GPS proyek akan muncul di profilmu.',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: EcoPointsManager(),
      builder: (context, _) {
        final int currentPoints = EcoPointsManager().points;

        // Filter item berdasarkan kategori yang dipilih
        final filteredItems = _selectedCategory == 'Semua'
            ? _catalogRewards
            : _catalogRewards
                .where((item) => item['category'] == _selectedCategory)
                .toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: _buildTopAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Sub-Header: Kalimat Jelas & Tanpa Duplikasi Judul AppBar
                    _buildSubHeader(),

                    const SizedBox(height: 14),

                    // 2. Hero Card Biru: Saldo Terkumpul & Aksi Riwayat
                    _buildHeroPointsCard(currentPoints),

                    const SizedBox(height: 16),

                    // 3. Tab Filter Kategori Horizontal (5 Kategori Lengkap)
                    _buildCategoryFilterTabs(),

                    const SizedBox(height: 18),

                    // 4. Header Bar Katalog Reward & Toggle Grid/List
                    _buildCatalogHeaderBar(filteredItems.length),

                    const SizedBox(height: 12),

                    // 5. Tampilan Katalog (Grid atau List Bebas Truncated & Overflow)
                    if (filteredItems.isEmpty)
                      _buildEmptyState()
                    else if (_isGridView)
                      _buildRewardGridSection(filteredItems, currentPoints)
                    else
                      _buildRewardListSection(filteredItems, currentPoints),

                    const SizedBox(height: 20),

                    // 6. Banner Edukasi Dampak Air Bersih Anda
                    _buildCleanWaterImpactBanner(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // 1. Top App Bar dengan Tombol "Kuponku (X)"
  // ─────────────────────────────────────────────────────────
  PreferredSizeWidget _buildTopAppBar() {
    final int activeCouponsCount = _myCoupons.where((c) => !c.isUsed).length;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF006296)),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      title: const Text(
        'Pusat Tukar Poin',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
          letterSpacing: -0.2,
        ),
      ),
      actions: [
        // Tombol Kuponku dengan Badge Interaktif
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: InkWell(
            onTap: _showMyCouponsSheet,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFBAE6FD),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.confirmation_number_rounded,
                    size: 15,
                    color: Color(0xFF006296),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Kuponku ($activeCouponsCount)',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF006296),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),

        // Riwayat Poin
        IconButton(
          tooltip: 'Riwayat Transaksi Poin',
          icon: const Icon(
            Icons.receipt_long_rounded,
            color: Color(0xFF006296),
            size: 21,
          ),
          onPressed: _showPointHistorySheet,
        ),

        // Avatar Profil Pengguna
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF006296),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 19),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 2. Sub-Header: Kalimat Jelas (Hapus Duplikasi Judul)
  // ─────────────────────────────────────────────────────────
  Widget _buildSubHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.water_drop_rounded,
                color: Color(0xFF0284C7),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AQUAGUARD SDG 6 • WATER SHOP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0284C7),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Tukarkan poin hemat airmu menjadi manfaat nyata',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 3. Hero Card Biru: Saldo Terkumpul & Aksi
  // ─────────────────────────────────────────────────────────
  Widget _buildHeroPointsCard(int currentPoints) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF006296), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006296).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 5),
                    Text(
                      'Saldo Terkumpul',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$currentPoints',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Eco-Points',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFBAE6FD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF86EFAC),
                size: 16,
              ),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  '+120 poin didapat minggu ini',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0F2FE),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _showPointHistorySheet,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                        width: 0.8,
                      ),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Riwayat Poin',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: _showHowToEarnPointsSheet,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insights_rounded,
                            color: Color(0xFF006296),
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Cara Dapat Poin',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF006296),
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
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 4. Tab Filter Kategori Horizontal (Stateful ChoiceChips)
  // ─────────────────────────────────────────────────────────
  Widget _buildCategoryFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF006296) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF006296)
                        : const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 5. Header Bar Katalog Reward
  // ─────────────────────────────────────────────────────────
  Widget _buildCatalogHeaderBar(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(
          child: Text(
            'Katalog Reward Konservasi',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count Tersedia',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF006296),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol Ganti Tampilan Grid / List
            InkWell(
              onTap: () => setState(() => _isGridView = !_isGridView),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Icon(
                  _isGridView
                      ? Icons.view_agenda_rounded
                      : Icons.grid_view_rounded,
                  size: 16,
                  color: const Color(0xFF006296),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 6. Tampilan Grid (Sesuai Gambar 1 - Bebas Overflow)
  // ─────────────────────────────────────────────────────────
  Widget _buildRewardGridSection(
    List<Map<String, dynamic>> items,
    int currentPoints,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        mainAxisExtent: 295, // Ruang proporsional untuk 2 baris judul & deskripsi
      ),
      itemBuilder: (context, index) {
        return _buildRewardGridCard(items[index], currentPoints);
      },
    );
  }

  Widget _buildRewardGridCard(Map<String, dynamic> item, int currentPoints) {
    final String title = item['title'] as String;
    final String subtitle = item['subtitle'] as String;
    final String category = item['category'] as String;
    final int points = item['points'] as int;
    final IconData icon = item['icon'] as IconData;

    final bool canAfford = currentPoints >= points;
    final int pointsNeeded = points - currentPoints;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showItemDetailSheet(item, currentPoints),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Atas: Banner Ikon & Badge Kategori
              Container(
                height: 88,
                decoration: BoxDecoration(
                  color: canAfford
                      ? const Color(0xFFE0F2FE)
                      : const Color(0xFFF1F5F9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        icon,
                        size: 38,
                        color: canAfford
                            ? const Color(0xFF0284C7)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    // Badge Kategori Kecil di Kiri Atas
                    Positioned(
                      top: 7,
                      left: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                    // Indikator Gembok / Siap Tukar di Kanan Atas
                    Positioned(
                      top: 7,
                      right: 7,
                      child: Container(
                        padding: const EdgeInsets.all(4.5),
                        decoration: BoxDecoration(
                          color: canAfford
                              ? const Color(0xFF006296)
                              : const Color(0xFF64748B),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          canAfford
                              ? Icons.redeem_rounded
                              : Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bagian Bawah: Informasi Item & Tombol Aksi
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Harga Poin
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: canAfford
                              ? const Color(0xFFE0F2FE)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              canAfford
                                  ? Icons.water_drop
                                  : Icons.lock_outline_rounded,
                              size: 10,
                              color: canAfford
                                  ? const Color(0xFF0284C7)
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '$points Poin',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: canAfford
                                    ? const Color(0xFF006296)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Judul Item (Anti-Terpotong: maxLines 2)
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 3),

                      // Deskripsi Singkat Awam (Anti-Terpotong: maxLines 2)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF64748B),
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),

                      // Progress Bar jika Poin Belum Cukup
                      if (!canAfford) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$currentPoints / $points',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              '${((currentPoints / points).clamp(0.0, 1.0) * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (currentPoints / points).clamp(0.0, 1.0),
                            minHeight: 4,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF0284C7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],

                      // Tombol Aksi "Tukar" (Aktif Biru) atau "Kurang X Poin" (Abu-abu)
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () => _showItemDetailSheet(item, currentPoints),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canAfford
                                ? const Color(0xFF006296)
                                : const Color(0xFFE2E8F0),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!canAfford) ...[
                                  const Icon(
                                    Icons.lock_rounded,
                                    size: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Kurang $pointsNeeded Poin',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ] else ...[
                                  const Text(
                                    'Tukar',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ],
                            ),
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
    );
  }

  // ─────────────────────────────────────────────────────────
  // 7. Tampilan List View (Format Kartu Horizontal Lebar)
  // ─────────────────────────────────────────────────────────
  Widget _buildRewardListSection(
    List<Map<String, dynamic>> items,
    int currentPoints,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _buildRewardListCard(items[index], currentPoints);
      },
    );
  }

  Widget _buildRewardListCard(Map<String, dynamic> item, int currentPoints) {
    final String title = item['title'] as String;
    final String subtitle = item['subtitle'] as String;
    final String category = item['category'] as String;
    final int points = item['points'] as int;
    final IconData icon = item['icon'] as IconData;

    final bool canAfford = currentPoints >= points;
    final int pointsNeeded = points - currentPoints;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showItemDetailSheet(item, currentPoints),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: canAfford
                      ? const Color(0xFFE0F2FE)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: canAfford
                      ? const Color(0xFF0284C7)
                      : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: canAfford
                                ? const Color(0xFFE0F2FE)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$points Eco-Points',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: canAfford
                                  ? const Color(0xFF006296)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Tombol Tukar / Kurang Poin
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => _showItemDetailSheet(item, currentPoints),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? const Color(0xFF006296)
                          : const Color(0xFFE2E8F0),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      canAfford ? 'Tukar' : 'Kurang $pointsNeeded',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: canAfford
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 40,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 8),
            Text(
              'Belum ada reward di kategori ini.',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 8. Banner Edukasi Dampak Air Bersih Anda
  // ─────────────────────────────────────────────────────────
  Widget _buildCleanWaterImpactBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBAE6FD), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFBAE6FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: Color(0xFF006296),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dampak Air Bersih Anda',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF006296),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Setiap 100 poin yang ditukarkan setara dengan penghematan 45 liter air bersih di jaringan kampus dan lingkungan mandiri.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF334155),
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

  // ─────────────────────────────────────────────────────────
  // 9. Modal Detail & Konfirmasi Penukaran (Bottom Sheet)
  // ─────────────────────────────────────────────────────────
  void _showItemDetailSheet(Map<String, dynamic> item, int currentPoints) {
    final String title = item['title'] as String;
    final String fullDesc = item['fullDesc'] as String;
    final String category = item['category'] as String;
    final int points = item['points'] as int;
    final IconData icon = item['icon'] as IconData;
    final List<String> steps = List<String>.from(item['steps'] as List);

    final bool canAfford = currentPoints >= points;
    final int pointsNeeded = points - currentPoints;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
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

                  // Header Badge Kategori & Poin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.water_drop,
                              size: 13,
                              color: Color(0xFF0284C7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$points Eco-Points',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF006296),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Ikon & Judul Lengkap Item
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          icon,
                          size: 30,
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              canAfford
                                  ? 'Poin kamu mencukupi untuk klaim ini'
                                  : 'Poin kamu belum mencukupi (Kurang $pointsNeeded Poin)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: canAfford
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Deskripsi Manfaat Lengkap (Bebas Truncated)
                  const Text(
                    'Manfaat & Deskripsi:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fullDesc,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF334155),
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Cara Pakai (3 Langkah Mudah)
                  const Text(
                    'Cara Pakai (3 Langkah Mudah):',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: List.generate(steps.length, (idx) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: idx < steps.length - 1 ? 8.0 : 0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF006296),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${idx + 1}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  steps[idx],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF334155),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ringkasan Poin
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saldo Sekarang',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$currentPoints Pts',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Color(0xFF94A3B8),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Sisa Saldo',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              canAfford
                                  ? '${currentPoints - points} Pts'
                                  : 'Tidak cukup',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: canAfford
                                    ? const Color(0xFF0284C7)
                                    : const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Tombol Konfirmasi Tukar
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: canAfford
                          ? () => _executeRedemption(sheetContext, item)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006296),
                        disabledBackgroundColor: const Color(0xFFE2E8F0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        canAfford
                            ? 'Konfirmasi Tukar ($points Poin)'
                            : 'Kurang $pointsNeeded Poin',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: canAfford
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
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

  // ─────────────────────────────────────────────────────────
  // 10. Eksekusi Penukaran Poin & Tambah ke Kuponku
  // ─────────────────────────────────────────────────────────
  void _executeRedemption(
    BuildContext sheetContext,
    Map<String, dynamic> item,
  ) {
    final int points = item['points'] as int;
    final String title = item['title'] as String;
    final String category = item['category'] as String;
    final String codePrefix = (item['codePrefix'] as String?) ?? 'AQ';

    final success = EcoPointsManager().redeemPoints(points, title);
    if (success) {
      // Buat Kode Kupon Unik
      final randomSuffix = (1000 + (DateTime.now().millisecondsSinceEpoch % 8999)).toString();
      final couponCode = 'AQ-$codePrefix-$randomSuffix';

      final newCoupon = MyCouponItem(
        id: 'cp_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        category: category,
        code: couponCode,
        expiryDate: '30 hari dari sekarang',
        icon: item['icon'] as IconData,
        benefitDesc: item['fullDesc'] as String,
        usageSteps: List<String>.from(item['steps'] as List),
        pointsCost: points,
        isUsed: false,
        redeemedAt: DateTime.now(),
      );

      setState(() {
        _myCoupons.insert(0, newCoupon);
      });

      // Tutup Sheet Detail
      Navigator.pop(sheetContext);

      // Tampilkan SnackBar Sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF006296),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF86EFAC),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Berhasil menukarkan "$title"! Tersimpan di Kuponku.',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'Buka Kupon',
            textColor: const Color(0xFFBAE6FD),
            onPressed: _showMyCouponsSheet,
          ),
        ),
      );

      // Tampilkan Dialog Sukses & QR Code
      _showRedeemSuccessDialog(newCoupon);
    }
  }

  // ─────────────────────────────────────────────────────────
  // 11. Modal Bottom Sheet: Daftar Voucher Aktif (Kuponku)
  // ─────────────────────────────────────────────────────────
  void _showMyCouponsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activeCoupons = _myCoupons.where((c) => !c.isUsed).toList();
            final usedCoupons = _myCoupons.where((c) => c.isUsed).toList();

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.82,
                  ),
                  child: Column(
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
                      const SizedBox(height: 14),

                      // Header Kuponku
                      Row(
                        children: [
                          const Icon(
                            Icons.confirmation_number_rounded,
                            color: Color(0xFF006296),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Kupon & Voucher Saya',
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${activeCoupons.length} Kupon Aktif',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tunjukkan kode QR atau salin kode saat transaksi di lokasi mitra.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Daftar Kupon
                      Expanded(
                        child: _myCoupons.isEmpty
                            ? const Center(
                                child: Text(
                                  'Kamu belum memiliki kupon.',
                                  style: TextStyle(color: Color(0xFF94A3B8)),
                                ),
                              )
                            : ListView(
                                children: [
                                  if (activeCoupons.isNotEmpty) ...[
                                    ...activeCoupons.map((coupon) {
                                      return _buildCouponCardItem(
                                        coupon: coupon,
                                        onUseTapped: () {
                                          _showCouponQRModal(coupon);
                                        },
                                      );
                                    }),
                                  ],
                                  if (usedCoupons.isNotEmpty) ...[
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Sudah Digunakan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...usedCoupons.map((coupon) {
                                      return _buildCouponCardItem(
                                        coupon: coupon,
                                        onUseTapped: () {
                                          _showCouponQRModal(coupon);
                                        },
                                      );
                                    }),
                                  ],
                                ],
                              ),
                      ),

                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006296),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
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
      },
    );
  }

  Widget _buildCouponCardItem({
    required MyCouponItem coupon,
    required VoidCallback onUseTapped,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: coupon.isUsed ? const Color(0xFFF8FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: coupon.isUsed
              ? const Color(0xFFE2E8F0)
              : const Color(0xFFBAE6FD),
          width: 0.9,
        ),
        boxShadow: coupon.isUsed
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF006296).withValues(alpha: 0.05),
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
                  color: coupon.isUsed
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  coupon.icon,
                  size: 22,
                  color: coupon.isUsed
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          coupon.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: coupon.isUsed
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF0284C7),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: coupon.isUsed
                                ? const Color(0xFFE2E8F0)
                                : const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            coupon.isUsed ? 'Digunakan' : 'Aktif',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: coupon.isUsed
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      coupon.title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: coupon.isUsed
                            ? const Color(0xFF64748B)
                            : const Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.qr_code_rounded,
                        size: 16,
                        color: Color(0xFF006296),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          coupon.code,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Color(0xFF006296),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: onUseTapped,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: coupon.isUsed
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF006296),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      coupon.isUsed ? 'Lihat QR' : 'Gunakan / QR',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
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

  // ─────────────────────────────────────────────────────────
  // 12. Modal Dialog Simulasi Kode QR & Voucher
  // ─────────────────────────────────────────────────────────
  void _showCouponQRModal(MyCouponItem coupon) {
    showDialog(
      context: context,
      builder: (qrDialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            coupon.category,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF006296),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: coupon.isUsed
                                ? const Color(0xFFE2E8F0)
                                : const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            coupon.isUsed ? 'Sudah Digunakan' : 'Siap Dipakai',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: coupon.isUsed
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      coupon.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Simulasi Kotak Kode QR Realistis
                    _buildSimulatedQRCodeWidget(coupon.code),

                    const SizedBox(height: 14),

                    // Kode Teks & Tombol Salin
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coupon.code,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: Color(0xFF006296),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: coupon.code));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kode voucher disalin!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Panduan Ringkas
                    Text(
                      'Tunjukkan kode QR ini ke kasir / sensor dispenser saat penukaran. Berlaku s/d: ${coupon.expiryDate}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tombol Tandai Sudah Dipakai
                    if (!coupon.isUsed)
                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: OutlinedButton(
                          onPressed: () {
                            setDialogState(() {
                              coupon.isUsed = true;
                            });
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kupon ditandai sudah digunakan.'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF006296)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Tandai Sudah Dipakai',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF006296),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(qrDialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006296),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Selesai',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Komponen Simulasi Tampilan QR Code Bersih & Realistis
  Widget _buildSimulatedQRCodeWidget(String code) {
    return Container(
      width: 170,
      height: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 4 Kotak Finder Pattern di Sudut
          Align(
            alignment: Alignment.topLeft,
            child: _buildFinderPattern(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _buildFinderPattern(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _buildFinderPattern(),
          ),
          // Matriks Pola Titik & Garis QR Tengah
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.water_drop,
                size: 26,
                color: Color(0xFF006296),
              ),
            ),
          ),
          // Titik-titik Data Simulasi di Area Sekitar
          Positioned(
            top: 48,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                6,
                (i) => Container(
                  width: 5,
                  height: 5,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                6,
                (i) => Container(
                  width: 5,
                  height: 5,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinderPattern() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0F172A), width: 4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 13. Dialog Perayaan Penukaran Berhasil
  // ─────────────────────────────────────────────────────────
  void _showRedeemSuccessDialog(MyCouponItem coupon) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Penukaran Berhasil! 🎉',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kamu telah berhasil menukarkan reward:\n"${coupon.title}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF475569),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.qr_code_rounded,
                      size: 18,
                      color: Color(0xFF006296),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      coupon.code,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Color(0xFF006296),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showCouponQRModal(coupon);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF006296)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Buka QR',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF006296),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006296),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
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

  // ─────────────────────────────────────────────────────────
  // 14. Bottom Sheet: Riwayat Poin
  // ─────────────────────────────────────────────────────────
  void _showPointHistorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final historyList = EcoPointsManager().history;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 16.0,
            ),
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
                      Icons.history_rounded,
                      color: Color(0xFF006296),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Riwayat Perolehan & Penukaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 380),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: historyList.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Color(0xFFF1F5F9), height: 1),
                    itemBuilder: (context, index) {
                      final item = historyList[index];
                      final isPositive = item.points > 0;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isPositive
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFFEE2E2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPositive
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            size: 16,
                            color: isPositive
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: Text(
                          '${item.date.day}/${item.date.month}/${item.date.year}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        trailing: Text(
                          isPositive
                              ? '+${item.points} pts'
                              : '${item.points} pts',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isPositive
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
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
                      'Tutup',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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

  // ─────────────────────────────────────────────────────────
  // 15. Bottom Sheet: Cara Dapat Poin
  // ─────────────────────────────────────────────────────────
  void _showHowToEarnPointsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
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
                const Text(
                  'Cara Mengumpulkan Eco-Points',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                _buildHowToItem(
                  icon: Icons.checklist_rounded,
                  title: 'Selesaikan Misi Harian',
                  points: '+50 Poin',
                  desc: 'Jalankan tantangan mandiri di Beranda setiap hari.',
                ),
                _buildHowToItem(
                  icon: Icons.quiz_outlined,
                  title: 'Jawab Kuis Kilat SDG 6',
                  points: '+15 Poin',
                  desc: 'Uji wawasan di tab Edukasi dan dapatkan XP instan.',
                ),
                _buildHowToItem(
                  icon: Icons.water_drop_outlined,
                  title: 'Catat Aksi Konservasi',
                  points: '+10 s/d +25 Poin',
                  desc: 'Centang kebiasaan hemat di tab Aksi secara rutin.',
                ),
                _buildHowToItem(
                  icon: Icons.local_fire_department_rounded,
                  title: 'Pertahankan Streak Harian',
                  points: '+20 Poin Bonus',
                  desc: 'Konsisten mencatat pemakaian air tanpa putus.',
                ),
                const SizedBox(height: 16),
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
                      'Saya Paham',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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

  Widget _buildHowToItem({
    required IconData icon,
    required String title,
    required String points,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0284C7), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      points,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11.5,
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
}
