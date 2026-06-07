// lib/screens/intro_screen.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ── Temporizador por slide ───────────────────────────────
  static const _slideDuration = Duration(seconds: 5);
  Timer? _slideTimer;

  // AnimationController para a barra de progresso circular
  late final AnimationController _timerCtrl = AnimationController(
    vsync: this,
    duration: _slideDuration,
  );

  static const _slides = [
    _SlideData(
      emoji: '🛸',
      title: 'Bem-vindo ao\nOrbitWatch',
      subtitle: 'MONITORAMENTO ESPACIAL',
      desc:
          'Tecnologia de ponta para monitorar eventos ambientais em tempo real, usando dados de satélites de última geração.',
      accentColor: AppTheme.cyan,
    ),
    _SlideData(
      emoji: '🔥',
      title: 'Detecção de\nEventos',
      subtitle: 'ALERTAS EM TEMPO REAL',
      desc:
          'Queimadas, enchentes, desmatamentos e tempestades detectados automaticamente — antes que virem catástrofe.',
      accentColor: AppTheme.orange,
    ),
    _SlideData(
      emoji: '🚨',
      title: 'Alertas\nInteligentes',
      subtitle: 'NOTIFICAÇÕES POR REGIÃO',
      desc:
          'Sistema de alertas com classificação por severidade e região geográfica. Saiba exatamente onde e o que está acontecendo.',
      accentColor: AppTheme.red,
    ),
    _SlideData(
      emoji: '🌿',
      title: 'Impacto\nAmbiental',
      subtitle: 'DADOS QUE SALVAM',
      desc:
          'Acompanhe o impacto ambiental em tempo real. Dados reais de satélites para decisões que fazem diferença no planeta.',
      accentColor: AppTheme.green,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Inicia (ou reinicia) o timer e a animação para o slide atual
  void _startTimer() {
    _slideTimer?.cancel();
    _timerCtrl.reset();
    _timerCtrl.forward();

    _slideTimer = Timer(_slideDuration, () {
      if (!mounted) return;
      _next(auto: true);
    });
  }

  // Pausa o timer quando o usuário interage manualmente
  void _pauseTimer() {
    _slideTimer?.cancel();
    _timerCtrl.stop();
  }

  void _next({bool auto = false}) {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      // _startTimer é chamado pelo onPageChanged
    } else {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _prev() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int i) {
    setState(() => _currentPage = i);
    _startTimer();
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    _timerCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = _slides[_currentPage].accentColor;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(children: [
          // ── Barra topo: PULAR + contagem de slides ─────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(children: [
              // Indicador "X / Y"
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  '${_currentPage + 1} / ${_slides.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              // Botão Pular
              TextButton(
                onPressed: () {
                  _pauseTimer();
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.muted,
                  side: const BorderSide(color: AppTheme.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('PULAR'),
              ),
            ]),
          ),

          // ── PageView ────────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _slides.length,
              itemBuilder: (_, i) => _SlideWidget(
                slide: _slides[i],
                timerCtrl: _timerCtrl,
                // O timer circular só aparece no slide ativo
                showTimer: i == _currentPage,
              ),
            ),
          ),

          // ── Dots indicadores ─────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? accent : AppTheme.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // ── Barra de progresso linear do slide ──────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AnimatedBuilder(
              animation: _timerCtrl,
              builder: (_, __) => Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Próximo em',
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.muted,
                          letterSpacing: .5),
                    ),
                    // Contador regressivo em segundos
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        '${((_slideDuration.inSeconds) * (1 - _timerCtrl.value)).ceil()}s',
                        key: ValueKey(
                          ((_slideDuration.inSeconds) *
                                  (1 - _timerCtrl.value))
                              .ceil(),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: accent,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _timerCtrl.value,
                    minHeight: 3,
                    backgroundColor: AppTheme.surface2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 16),

          // ── Botões Voltar / Avançar ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Voltar
                AnimatedOpacity(
                  opacity: _currentPage > 0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: OutlinedButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _pauseTimer();
                            _prev();
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.muted,
                      side: const BorderSide(color: AppTheme.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                    child: const Text('Voltar'),
                  ),
                ),

                // Avançar / Começar
                ElevatedButton(
                  onPressed: () {
                    _pauseTimer();
                    _next();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? 'Começar 🚀'
                        : 'Avançar →',
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Dados do slide ─────────────────────────────────────────
class _SlideData {
  final String emoji;
  final String title;
  final String subtitle;
  final String desc;
  final Color accentColor;

  const _SlideData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.accentColor,
  });
}

// ── Widget de cada slide ───────────────────────────────────
class _SlideWidget extends StatefulWidget {
  final _SlideData slide;
  final AnimationController timerCtrl;
  final bool showTimer;

  const _SlideWidget({
    required this.slide,
    required this.timerCtrl,
    required this.showTimer,
  });

  @override
  State<_SlideWidget> createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<_SlideWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.slide;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Emoji com anel de timer circular + glow ─────────
          SizedBox(
            width: 140,
            height: 140,
            child: AnimatedBuilder(
              animation: Listenable.merge(
                  [_glowCtrl, widget.timerCtrl]),
              builder: (_, __) {
                final glow = 0.2 + 0.35 * _glowCtrl.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow + fundo circular
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: s.accentColor.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: s.accentColor.withOpacity(glow),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    // Anel de progresso circular do timer
                    if (widget.showTimer)
                      SizedBox(
                        width: 136,
                        height: 136,
                        child: CustomPaint(
                          painter: _TimerRingPainter(
                            progress: widget.timerCtrl.value,
                            color: s.accentColor,
                            trackColor:
                                s.accentColor.withOpacity(0.12),
                          ),
                        ),
                      ),
                    // Emoji
                    Text(s.emoji,
                        style: const TextStyle(fontSize: 52)),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // Título
          Text(
            s.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: s.accentColor,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Subtítulo
          Text(
            s.subtitle,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // Card de descrição
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              s.desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.muted,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Anel de progresso circular do timer ────────────────────
class _TimerRingPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final Color color;
  final Color trackColor;

  const _TimerRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 3;
    const strokeWidth = 3.0;
    const startAngle = -math.pi / 2; // começa do topo

    // Track (fundo cinza)
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progresso (arco colorido)
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter old) =>
      old.progress != progress ||
      old.color != color;
}
