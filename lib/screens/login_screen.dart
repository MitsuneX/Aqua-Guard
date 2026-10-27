import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../main.dart';

/// Halaman Mandiri "Login & Autentikasi" - AquaGuard
/// Pure Mobile UI & Local State dengan StatefulWidget berbasis SDG 6.
/// Seluruh tombol masuk / daftar / Google / tamu langsung mengarahkan pengguna ke Dashboard.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Mode Tab: true = Masuk, false = Daftar Akun
  bool _isLogin = true;

  // State Form
  bool _obscurePassword = true;
  bool _rememberMe = true;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Enter Your Name');
    _emailController = TextEditingController(text: 'name@aquaguard.id');
    _passwordController = TextEditingController(text: 'Enter Your Password');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Navigasi langsung ke Beranda (Dashboard) AquaGuard
  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AquaGuardMainScaffold(initialIndex: 0),
      ),
    );
  }

  /// Dialog informasi lupa sandi
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Color(0xFF0284C7)),
              SizedBox(width: 10),
              Text(
                'Lupa Kata Sandi?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: const Text(
            'Ini adalah aplikasi demonstrasi 100% Client-Side. Anda dapat langsung menekan tombol "Masuk ke AquaGuard" atau "Masuk Langsung sebagai Tamu" tanpa perlu reset kata sandi.',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToDashboard();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Masuk ke Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F6FE),
              Color(0xFFF7FAFD),
              Colors.white,
            ],
            stops: [0.0, 0.32, 0.7],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tombol Kembali jika dibuka dari WelcomeScreen
                    if (Navigator.canPop(context)) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
                          onPressed: () => Navigator.pop(context),
                          tooltip: 'Kembali ke Halaman Awal',
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // 1. Logo & Identitas AquaGuard
                    _buildHeaderLogo(),

                    const SizedBox(height: 24),

                    // 2. Segmented Pill Tab (Masuk / Daftar Akun)
                    _buildSegmentedTab(),

                    const SizedBox(height: 24),

                    // 3. Teks Sambutan
                    _buildGreetingText(),

                    const SizedBox(height: 22),

                    // 4. Form Input (Email & Password)
                    _buildFormInputs(),

                    const SizedBox(height: 16),

                    // 5. Checkbox "Ingat perangkat ini" & Badge "100% Client-Side"
                    _buildOptionsRow(),

                    const SizedBox(height: 22),

                    // 6. Tombol Utama (Masuk / Daftar ke AquaGuard)
                    _buildPrimaryButton(),

                    const SizedBox(height: 22),

                    // 7. Divider "ATAU"
                    _buildOrDivider(),

                    const SizedBox(height: 20),

                    // 8. Tombol "Lanjutkan dengan Google"
                    _buildGoogleButton(),

                    const SizedBox(height: 28),

                    // 9. Footer Prototipe & Tombol Masuk sebagai Tamu
                    _buildFooterSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Sub-Widgets ---

  /// Header Logo dengan Squircle Biru & Tetesan Air Putih
  Widget _buildHeaderLogo() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              'assets/images/aquaguard_logo.png',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0284C7),
                      Color(0xFF0369A1),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.water_drop,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AquaGuard',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F2644),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFBAE6FD),
                  width: 0.8,
                ),
              ),
              child: const Text(
                'SDG 6',
                style: TextStyle(
                  color: Color(0xFF0284C7),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Akses Air Bersih, Sanitasi Aman & Kebiasaan\nKonservasi Mandiri',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0284C7),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  /// Segmented Tab Pill: [Masuk] | [Daftar Akun]
  Widget _buildSegmentedTab() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Tab Masuk
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isLogin) {
                  setState(() => _isLogin = true);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _isLogin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isLogin
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _isLogin ? FontWeight.w800 : FontWeight.w600,
                      color: _isLogin ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Tab Daftar Akun
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_isLogin) {
                  setState(() => _isLogin = false);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: !_isLogin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !_isLogin
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'Daftar Akun',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: !_isLogin ? FontWeight.w800 : FontWeight.w600,
                      color: !_isLogin ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Teks Sambutan sesuai tab aktif
  Widget _buildGreetingText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isLogin ? 'Selamat Datang Kembali! 👋' : 'Buat Akun Baru! 🚀',
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _isLogin
              ? 'Masuk untuk memantau kuota air & progres SDG 6 harian Anda.'
              : 'Daftar untuk mulai memantau kuota air & aksi konservasi mandiri.',
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF64748B),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  /// Form Field untuk Email dan Password
  Widget _buildFormInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Tambahan: Nama Lengkap (hanya saat Daftar Akun)
        if (!_isLogin) ...[
          const Text(
            'Nama Lengkap',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: _nameController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF0284C7),
                size: 20,
              ),
              hintText: 'Masukkan nama lengkap',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 1. Alamat Email
        const Text(
          'Alamat Email',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: Color(0xFF0284C7),
              size: 20,
            ),
            hintText: 'nama@email.com',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 2. Kata Sandi
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kata Sandi',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            if (_isLogin)
              InkWell(
                onTap: _showForgotPasswordDialog,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Lupa sandi?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            letterSpacing: 2.0,
          ),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF0284C7),
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: const Color(0xFF94A3B8),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            hintText: '•••••••••••••',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), letterSpacing: 2.0),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  /// Opsi Checkbox & Badge "100% Client-Side"
  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Checkbox & Label
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _rememberMe = !_rememberMe;
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: const Color(0xFF0284C7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(color: Color(0xFF94A3B8), width: 1.5),
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _isLogin ? 'Ingat perangkat ini' : 'Setuju Komitmen SDG 6',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Badge "100% Client-Side"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFBBF7D0),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                '100% Client-Side',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF059669),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Tombol Utama Biru "Masuk ke AquaGuard ➔"
  Widget _buildPrimaryButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0284C7),
            Color(0xFF0369A1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToDashboard,
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'Masuk ke AquaGuard' : 'Daftar ke AquaGuard',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Garis Pembatas "ATAU"
  Widget _buildOrDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFE2E8F0),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'ATAU',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
              letterSpacing: 1.0,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFE2E8F0),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  /// Tombol "Lanjutkan dengan Google"
  Widget _buildGoogleButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToDashboard,
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Google 4-Warna Asli via CustomPainter
              SizedBox(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: GoogleLogoPainter(),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Lanjutkan dengan Google',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bagian Footer: Catatan Prototipe & Tombol Masuk sebagai Tamu
  Widget _buildFooterSection() {
    return Column(
      children: [
        const Divider(
          color: Color(0xFFF1F5F9),
          thickness: 1.0,
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 14.5,
              color: Color(0xFF0284C7),
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'Simulasi Prototipe • Tanpa Database • Aman & Privat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _navigateToDashboard,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Masuk Langsung sebagai Tamu (Mode Demo)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF0284C7),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Custom Painter untuk Logo Google 4-Warna Otentik (Merah, Kuning, Hijau, Biru)
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double stroke = w * 0.22;
    final Rect rect = Rect.fromLTWH(stroke / 2, stroke / 2, w - stroke, h - stroke);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    // Busur Merah (Atas)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -math.pi * 0.75, math.pi * 0.5, false, paint);

    // Busur Kuning (Kiri)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -math.pi * 1.25, math.pi * 0.5, false, paint);

    // Busur Hijau (Bawah)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, -math.pi * 1.75, math.pi * 0.5, false, paint);

    // Busur Biru (Kanan)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -math.pi * 0.25, math.pi * 0.35, false, paint);

    // Batang Horizontal Biru
    final Paint barPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);
    final Rect barRect = Rect.fromLTWH(w * 0.45, h * 0.5 - stroke / 2, w * 0.52, stroke);
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
