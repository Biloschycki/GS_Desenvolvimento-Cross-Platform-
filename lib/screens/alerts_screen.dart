// lib/screens/alerts_screen.dart
import 'package:flutter/material.dart';
import 'package:orbitwatch/main.dart';
import '../theme.dart';
import '../models/event_model.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _activeRegion = 'Todas';

  static const _regions = [
    'Todas', 'Norte', 'Nordeste', 'Centro-Oeste', 'Sul', 'Sudeste',
  ];

  static const _regionColors = {
    'Norte': AppTheme.cyan,
    'Nordeste': AppTheme.yellow,
    'Centro-Oeste': AppTheme.orange,
    'Sul': AppTheme.green,
    'Sudeste': Color(0xFF7C6FFF),
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppStateProvider.of(context),
      builder: (context, _) {
        final state = AppStateProvider.of(context);
        final allAlerts = state.alerts;
        final filtered = _activeRegion == 'Todas'
            ? allAlerts
            : allAlerts.where((a) => a.region == _activeRegion).toList();
        final unread = allAlerts.where((a) => !a.isRead).length;

        return Column(
          children: [
            // AppBar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              decoration: const BoxDecoration(
                color: AppTheme.bg,
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(children: [
                const Expanded(
                  child: Text('Alertas',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary)),
                ),
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.red.withOpacity(0.4)),
                    ),
                    child: Text('$unread não lido${unread > 1 ? 's' : ''}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.red,
                            fontWeight: FontWeight.w600)),
                  ),
              ]),
            ),

            // Filtros de região
            SizedBox(
              height: 46,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: _regions.length,
                itemBuilder: (_, i) {
                  final r = _regions[i];
                  final active = r == _activeRegion;
                  final color = _regionColors[r] ?? AppTheme.cyan;
                  return GestureDetector(
                    onTap: () => setState(() => _activeRegion = r),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: active
                            ? color.withOpacity(0.12)
                            : AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: active ? color : AppTheme.border),
                      ),
                      child: Text(r,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active ? color : AppTheme.muted)),
                    ),
                  );
                },
              ),
            ),

            // Botão "Ler todos"
            if (unread > 0)
              GestureDetector(
                onTap: () {
                  state.markAllAlertsRead();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('✅ Todos os alertas lidos!'),
                    backgroundColor: AppTheme.surface2,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppTheme.border),
                    ),
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.cyan.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.cyan.withOpacity(0.2)),
                  ),
                  child: const Center(
                    child: Text('✓ Marcar todos como lidos',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.cyan,
                            letterSpacing: .5)),
                  ),
                ),
              ),

            // Lista
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: const Center(
                                child: Text('🔔',
                                    style: TextStyle(fontSize: 28))),
                          ),
                          const SizedBox(height: 12),
                          const Text('Nenhum alerta nesta região',
                              style: TextStyle(
                                  color: AppTheme.muted, fontSize: 14)),
                        ],
                      ),
                    )
                  : LayoutBuilder(builder: (context, constraints) {
                      final wide = constraints.maxWidth > 700;
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final a = filtered[i];
                          return _AlertCard(
                            alert: a,
                            regionColor:
                                _regionColors[a.region] ?? AppTheme.cyan,
                            wide: wide,
                            onTap: () {
                              state.toggleAlertRead(a.id);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(a.isRead
                                    ? '● Marcado como não lido'
                                    : '✓ Marcado como lido'),
                                backgroundColor: AppTheme.surface2,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                      color: AppTheme.border),
                                ),
                                duration: const Duration(seconds: 2),
                              ));
                            },
                          );
                        },
                      );
                    }),
            ),
          ],
        );
      },
    );
  }
}

class _AlertCard extends StatefulWidget {
  final EnvironmentalAlert alert;
  final Color regionColor;
  final bool wide;
  final VoidCallback onTap;

  const _AlertCard({
    required this.alert,
    required this.regionColor,
    required this.wide,
    required this.onTap,
  });

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    _anim = Tween(begin: 0.4, end: 1.0).animate(_pulse);
    if (!widget.alert.isRead) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_AlertCard old) {
    super.didUpdateWidget(old);
    if (!widget.alert.isRead && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (widget.alert.isRead && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.reset();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.alert;
    final sevColor = AppTheme.getSeverityColor(a.severity);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: a.isRead
                ? AppTheme.border
                : AppTheme.cyan.withOpacity(0.35),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (!a.isRead)
            Container(
              width: 3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.cyan, AppTheme.green],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: widget.wide
                  ? _wideContent(a, sevColor)
                  : _narrowContent(a, sevColor),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _wideContent(EnvironmentalAlert a, Color sevColor) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      // dot
      AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: a.isRead ? AppTheme.muted : AppTheme.cyan,
            boxShadow: !a.isRead
                ? [
                    BoxShadow(
                      color: AppTheme.cyan.withOpacity(_anim.value * 0.6),
                      blurRadius: 6, spreadRadius: 2,
                    )
                  ]
                : null,
          ),
        ),
      ),
      const SizedBox(width: 14),
      // título + msg
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(a.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: a.isRead
                      ? AppTheme.muted
                      : AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(a.message,
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.muted, height: 1.4)),
        ]),
      ),
      const SizedBox(width: 16),
      // badges + hora
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Row(children: [
          _RegBadge(label: a.region, color: widget.regionColor),
          const SizedBox(width: 6),
          _SevBadge(label: AppTheme.getSeverityLabel(a.severity), color: sevColor),
        ]),
        const SizedBox(height: 6),
        Text(a.issuedAt,
            style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
      ]),
    ]);
  }

  Widget _narrowContent(EnvironmentalAlert a, Color sevColor) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: a.isRead ? AppTheme.muted : AppTheme.cyan,
              boxShadow: !a.isRead
                  ? [
                      BoxShadow(
                        color: AppTheme.cyan.withOpacity(_anim.value * 0.6),
                        blurRadius: 6, spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(a.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: a.isRead
                      ? AppTheme.muted
                      : AppTheme.textPrimary)),
        ),
      ]),
      const SizedBox(height: 8),
      Text(a.message,
          style: const TextStyle(
              fontSize: 12, color: AppTheme.muted, height: 1.5)),
      const SizedBox(height: 10),
      Row(children: [
        _RegBadge(label: a.region, color: widget.regionColor),
        const SizedBox(width: 6),
        _SevBadge(label: AppTheme.getSeverityLabel(a.severity), color: sevColor),
        const Spacer(),
        Text(a.issuedAt,
            style: const TextStyle(fontSize: 10, color: AppTheme.muted)),
      ]),
    ]);
  }
}

class _RegBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _RegBadge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _SevBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _SevBadge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: .5)),
    );
  }
}
