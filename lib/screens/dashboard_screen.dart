// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:orbitwatch/main.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../models/event_model.dart';
import 'event_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _refreshing = false;

  Future<void> _onRefresh() async {
    setState(() => _refreshing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppStateProvider.of(context),
      builder: (context, _) {
        final state = AppStateProvider.of(context);
        final events = state.events;
        final criticalEvents =
            events.where((e) => e.severity == EventSeverity.critica).toList();
        final recentEvents = events.take(4).toList();

        return LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth > 700;
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppTheme.cyan,
            backgroundColor: AppTheme.surface,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppTheme.bg,
                  floating: true,
                  automaticallyImplyLeading: false,
                  title: wide
                      ? null
                      : RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                              text: 'ORBIT',
                              style: TextStyle(
                                  color: AppTheme.cyan,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2),
                            ),
                            TextSpan(
                              text: 'WATCH',
                              style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2),
                            ),
                          ]),
                        ),
                  actions: [
                    IconButton(
                      onPressed: _onRefresh,
                      icon: _refreshing
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.cyan))
                          : const Icon(Icons.refresh_rounded,
                              color: AppTheme.muted),
                    ),
                    const SizedBox(width: 8),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(height: 1, color: AppTheme.border),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: wide ? 24 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatusBar(),
                        const SizedBox(height: 4),
                        // Grid stats — 4 colunas em desktop, 2 no mobile
                        GridView.count(
                          crossAxisCount: wide ? 4 : 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: wide ? 1.6 : 1.4,
                          children: [
                            _StatCard(
                              label: 'EVENTOS HOJE',
                              value: '${dashboardStats['totalEvents']}',
                              sub: '↑ 3 desde ontem',
                              color: AppTheme.cyan,
                            ),
                            _StatCard(
                              label: 'CRÍTICOS',
                              value: '${dashboardStats['criticalEvents']}',
                              sub: 'Atenção requerida',
                              color: AppTheme.red,
                            ),
                            _StatCard(
                              label: 'SATÉLITES',
                              value: '${dashboardStats['activeSatellites']}',
                              sub: 'de 6 ativos',
                              color: AppTheme.green,
                            ),
                            _StatCard(
                              label: 'ESTE MÊS',
                              value: '${dashboardStats['eventsThisMonth']}',
                              sub: 'eventos registrados',
                              color: AppTheme.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Layout de duas colunas no desktop
                        if (wide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(children: [
                                  _SectionLabel(label: '⚠  EVENTOS CRÍTICOS'),
                                  ...criticalEvents.map((e) => _MiniEventCard(
                                        event: e,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EventDetailScreen(event: e)),
                                        ),
                                      )),
                                ]),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(children: [
                                  _SectionLabel(label: '🕐  EVENTOS RECENTES'),
                                  ...recentEvents.map((e) => _MiniEventCard(
                                        event: e,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EventDetailScreen(event: e)),
                                        ),
                                      )),
                                ]),
                              ),
                            ],
                          )
                        else ...[
                          _SectionLabel(label: '⚠  EVENTOS CRÍTICOS'),
                          ...criticalEvents.map((e) => _MiniEventCard(
                                event: e,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          EventDetailScreen(event: e)),
                                ),
                              )),
                          const SizedBox(height: 8),
                          _SectionLabel(label: '🕐  EVENTOS RECENTES'),
                          ...recentEvents.map((e) => _MiniEventCard(
                                event: e,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          EventDetailScreen(event: e)),
                                ),
                              )),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class _StatusBar extends StatefulWidget {
  @override
  State<_StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<_StatusBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 14, 0, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.green.withOpacity(0.2)),
      ),
      child: Row(children: [
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.green,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.green.withOpacity(_anim.value),
                  blurRadius: 6, spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'SISTEMAS ATIVOS — MONITORANDO 6 SATÉLITES',
          style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              color: AppTheme.green,
              fontWeight: FontWeight.w700),
        ),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w700)),
          Text(value,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1)),
          Text(sub,
              style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(label,
          style: const TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              color: AppTheme.muted,
              fontWeight: FontWeight.w700)),
    );
  }
}

class _MiniEventCard extends StatelessWidget {
  final SatelliteEvent event;
  final VoidCallback onTap;

  const _MiniEventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sevColor = AppTheme.getSeverityColor(event.severity);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: sevColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(AppTheme.getEventTypeIcon(event.type),
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('📍 ${event.location}',
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.muted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: sevColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: sevColor),
            ),
            child: Text(AppTheme.getSeverityLabel(event.severity),
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: sevColor,
                    letterSpacing: .5)),
          ),
        ]),
      ),
    );
  }
}
