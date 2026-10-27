import 'package:flutter/material.dart';

import '../main.dart';
import 'login_screen.dart';

/// Halaman Selamat Datang (Welcome / Onboarding Screen) - AquaGuard
/// Tampilan awal interaktif yang merefleksikan misi konservasi air SDG 6.
/// Tombol "Mulai Sekarang" langsung mengarahkan pengguna ke halaman Login.
/// Tombol "Lanjut sebagai Tamu (Demo Mode)" langsung mengarahkan ke Dashboard.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Atas (Logo AquaGuard, SDG 6, dan Badge Hijau & Lestari)
                  _buildTopHeader(),

                  const SizedBox(height: 20),

                  // 2. Hero Card Ilustrasi Tetes Air & Floating Badges
                  _buildHeroIllustrationCard(),

                  const SizedBox(height: 24),

                  // 3. Judul Utama & Sub-Judul Edukatif
                  _buildMainTypography(),

                  const SizedBox(height: 22),

                  // 4. 3 Kartu Keunggulan Fitur
                  _buildFeatureCard(
                    icon: Icons.bolt_rounded,
                    title: 'Pencatatan Cepat & Akurat',
                    subtitle: 'Log instan debit keran, mandi, dan dapur',
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureCard(
                    icon: Icons.track_changes_rounded,
                    title: 'Misi Harian Berkelanjutan',
                    subtitle: 'Tantangan mikro ramah lingkungan setiap hari',
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureCard(
                    icon: Icons.insights_rounded,
                    title: 'Analisis Efisiensi Nyata',
                    subtitle: 'Evaluasi jejak air pribadi berbasis SDG 6',
                  ),

                  const SizedBox(height: 24),

                  // 5. Tombol Aksi Utama: "Mulai Sekarang ➔" (Masuk ke Login)
                  _buildPrimaryStartButton(context),

                  const SizedBox(height: 12),

                  // 6. Tombol Aksi Sekunder: "Lanjut sebagai Tamu (Demo Mode) →" (Masuk ke Dashboard)
                  _buildGuestDemoButton(context),

                  const SizedBox(height: 16),

                  // 7. Footer Tagline
                  _buildFooterTagline(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Sub-Widgets ---

  /// Header Atas
  Widget _buildTopHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kiri: Icon Logo + AquaGuard + SDG 6
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006296),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF006296).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.water_drop,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'AquaGuard',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F2644),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFBAE6FD),
                                  width: 0.8,
                                ),
                              ),
                              child: const Text(
                                'SDG 6',
                                style: TextStyle(
                                  color: Color(0xFF0284C7),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          'Konservasi Air & Sanitasi Bersih',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                // Kanan: Badge "Hijau & Lestari"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFBAE6FD),
                      width: 0.8,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        size: 14,
                        color: Color(0xFF0284C7),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Hijau & Lestari',
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
          ),
        );
      },
    );
  }

  /// Hero Card dengan Tetesan Air Artistik & Floating Badges
  Widget _buildHeroIllustrationCard() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F9FF),
            Color(0xFFE0F2FE),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFBAE6FD).withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Lingkaran Pendar Luar (Outer Ring Glow)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),

          // Lingkaran Pendar Tengah (Middle Ring)
          Container(
            width: 155,
            height: 155,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD6EEFD),
            ),
          ),

          // Tetesan Air Utama Artistik (Custom Painted)
          SizedBox(
            width: 80,
            height: 110,
            child: CustomPaint(
              painter: HeroWaterDropPainter(),
            ),
          ),

          // 1. Floating Badge Atas: "💧 100+ L Dihemat/Hari"
          Positioned(
            top: 14,
            child: _buildFloatingBadge(
              icon: Icons.water_drop,
              iconColor: const Color(0xFF0284C7),
              text: '100+ L Dihemat/Hari',
            ),
          ),

          // 2. Floating Badge Kanan: "🌍 Target SDG 6"
          Positioned(
            right: 20,
            top: 75,
            child: _buildFloatingBadge(
              emoji: '🌍',
              text: 'Target SDG 6',
            ),
          ),

          // 3. Floating Badge Bawah: "🌱 Dampak Lestari"
          Positioned(
            bottom: 14,
            child: _buildFloatingBadge(
              emoji: '🌱',
              text: 'Dampak Lestari',
            ),
          ),
        ],
      ),
    );
  }

  /// Badge Melayang (Pill Badge)
  Widget _buildFloatingBadge({
    IconData? icon,
    Color? iconColor,
    String? emoji,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: iconColor ?? const Color(0xFF0284C7)),
            const SizedBox(width: 6),
          ] else if (emoji != null) ...[
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F2644),
            ),
          ),
        ],
      ),
    );
  }

  /// Tipografi Judul & Subjudul
  Widget _buildMainTypography() {
    return Column(
      children: [
        const Text(
          'Jaga Setiap Tetes,\nSelamatkan Masa Depan',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A2540),
            height: 1.25,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: const Text(
            'Pantau penggunaan air harianmu, bangun kebiasaan hemat berkelanjutan, dan dukung terwujudnya akses air bersih & sanitasi aman untuk semua.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  /// Kartu Keunggulan Fitur
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                icon,
                color: const Color(0xFF0284C7),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

  /// Tombol Utama "Mulai Sekarang ➔" -> Mengarahkan ke Halaman Login
  Widget _buildPrimaryStartButton(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF006296),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006296).withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Sesuai permintaan: Menekan "Mulai Sekarang" akan langsung membuka halaman Login
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(26),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mulai Sekarang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tombol Sekunder "Lanjut sebagai Tamu (Demo Mode) →" -> Langsung ke Dashboard
  Widget _buildGuestDemoButton(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F0FE),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Mode tamu langsung membuka Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AquaGuardMainScaffold(initialIndex: 0),
              ),
            );
          },
          borderRadius: BorderRadius.circular(26),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 19,
                color: Color(0xFF026AA2),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Lanjut sebagai Tamu (Demo Mode) →',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF026AA2),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Footer Tagline
  Widget _buildFooterTagline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF006296),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Flexible(
          child: Text(
            'Prototipe Edukatif Mahasiswa • Berkomitmen pada SDG 6',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Painter untuk Tetesan Air Hero Card
class HeroWaterDropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Gradasi Tetes Air
    final Rect rect = Rect.fromLTWH(0, 0, w, h);
    final Paint dropPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF38BDF8),
          Color(0xFF0284C7),
          Color(0xFF006296),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    // Path Tetes Air Halus
    final Path path = Path();
    path.moveTo(w * 0.5, h * 0.05);
    path.cubicTo(
      w * 0.88, h * 0.42,
      w * 0.98, h * 0.88,
      w * 0.5, h * 0.98,
    );
    path.cubicTo(
      w * 0.02, h * 0.88,
      w * 0.12, h * 0.42,
      w * 0.5, h * 0.05,
    );
    path.close();

    // Bayangan Lembut
    canvas.drawShadow(
      path,
      const Color(0xFF006296).withValues(alpha: 0.35),
      8,
      true,
    );

    // Gambar Tetes Air
    canvas.drawPath(path, dropPaint);

    // Gelembung Dekoratif 1 (Besar)
    final Paint bubblePaint1 = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.65, h * 0.62), w * 0.11, bubblePaint1);

    // Gelembung Dekoratif 2 (Kecil)
    final Paint bubblePaint2 = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.44, h * 0.72), w * 0.06, bubblePaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
