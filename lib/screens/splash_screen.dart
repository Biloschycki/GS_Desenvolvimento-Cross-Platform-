// lib/screens/splash_screen.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _orbitCtrl;
  late final AnimationController _fadeCtrl;
  late final AnimationController _progressCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _progressAnim;

  // ── Contador regressivo ─────────────────────────────────
  int _countdown = 3;
  Timer? _countdownTimer;

  static const _totalMs = 3000;

  @override
  void initState() {
    super.initState();

    // Órbita: loop infinito
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Fade-in inicial
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim =
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    // Barra de progresso
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );
    _progressAnim =
        CurvedAnimation(parent: _progressCtrl, curve: Curves.linear);
    _progressCtrl.forward();

    // Contagem regressiva: decrementa a cada segundo
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown = (_countdown - 1).clamp(0, 3));
    });

    // Navega ao fim
    Future.delayed(
      const Duration(milliseconds: _totalMs + 100),
      () { if (mounted) Navigator.pushReplacementNamed(context, '/intro'); },
    );
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _fadeCtrl.dispose();
    _progressCtrl.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [Color(0xFF0A2040), AppTheme.bg],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Stack(
            children: [
              // Estrelas decorativas
              ..._buildStars(),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Animação orbital ─────────────────────
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: AnimatedBuilder(
                        animation: _orbitCtrl,
                        builder: (_, __) => CustomPaint(
                          painter: _OrbitPainter(_orbitCtrl.value),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Logo ─────────────────────────────────
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                          text: 'ORBIT',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.cyan,
                            letterSpacing: 4,
                          ),
                        ),
                        TextSpan(
                          text: 'WATCH',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.textPrimary,
                            letterSpacing: 4,
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'MONITORAMENTO AMBIENTAL POR SATÉLITE',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── Barra de progresso + contador ────────
                    SizedBox(
                      width: 200,
                      child: Column(children: [
                        // Rótulo "Carregando... / N"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'INICIALIZANDO',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 1.5,
                                color: AppTheme.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Contador animado
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Text(
                                '$_countdown',
                                key: ValueKey(_countdown),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.cyan,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Barra de progresso
                        AnimatedBuilder(
                          animation: _progressAnim,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _progressAnim.value,
                              backgroundColor: AppTheme.surface2,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      AppTheme.cyan),
                              minHeight: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Texto de status que muda conforme progresso
                        AnimatedBuilder(
                          animation: _progressAnim,
                          builder: (_, __) {
                            final pct = _progressAnim.value;
                            final msg = pct < 0.35
                                ? 'Conectando aos satélites...'
                                : pct < 0.70
                                    ? 'Carregando dados ambientais...'
                                    : 'Sistemas prontos ✓';
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: Text(
                                msg,
                                key: ValueKey(msg),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.muted,
                                  letterSpacing: .5,
                                ),
                              ),
                            );
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pontos de "estrelas" decorativos
  List<Widget> _buildStars() {
    const positions = [
      [0.1, 0.1], [0.3, 0.05], [0.7, 0.08], [0.9, 0.15],
      [0.05, 0.4], [0.95, 0.35], [0.15, 0.75], [0.85, 0.7],
      [0.4, 0.92], [0.6, 0.88], [0.5, 0.03], [0.2, 0.55],
    ];
    return positions.map((p) {
      return Positioned(
        left: MediaQuery.sizeOf(context).width * p[0],
        top: MediaQuery.sizeOf(context).height * p[1],
        child: Container(
          width: 2, height: 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.cyan.withOpacity(0.3),
          ),
        ),
      );
    }).toList();
  }
}

// ── CustomPainter orbital ─────────────────────────────────
class _OrbitPainter extends CustomPainter {
  final double progress;
  _OrbitPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    // Anel externo
    canvas.drawCircle(center, radius,
        Paint()
          ..color = const Color(0xFF00D4FF).withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);

    // Anel interno
    canvas.drawCircle(center, radius * 0.6,
        Paint()
          ..color = const Color(0xFF00FF9C).withOpacity(0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);

    // Planeta
    canvas.drawCircle(
      center, 30,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF1A4070), AppTheme.bg],
          center: const Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: center, radius: 30)),
    );
    canvas.drawCircle(center, 30,
        Paint()
          ..color = const Color(0xFF00D4FF).withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // Emoji Terra
    final tp = TextPainter(
      text: const TextSpan(text: '🌍', style: TextStyle(fontSize: 26)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));

    // Rastro ciano
    final angle = progress * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle - 0.8, 0.8, false,
      Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // Satélite
    final satX = center.dx + radius * math.cos(angle);
    final satY = center.dy + radius * math.sin(angle);
    final satPos = Offset(satX, satY);
    canvas.drawCircle(satPos, 8,
        Paint()..color = const Color(0xFF00D4FF).withOpacity(0.25));
    canvas.drawCircle(satPos, 5,
        Paint()..color = const Color(0xFF00D4FF));

    // Emoji satélite
    final se = TextPainter(
      text: const TextSpan(text: '🛸', style: TextStyle(fontSize: 13)),
      textDirection: TextDirection.ltr,
    )..layout();
    se.paint(canvas, satPos - Offset(se.width / 2, se.height / 2));
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.progress != progress;
}
