// lib/screens/event_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:orbitwatch/main.dart';
import '../models/event_model.dart';
import '../theme.dart';
import '../data/app_state.dart';

class EventDetailScreen extends StatelessWidget {
  final SatelliteEvent event;
  const EventDetailScreen({super.key, required this.event});

  // ── Dialog confirmar relatório ────────────────────────────
  void _sendReport(BuildContext ctx, AppState state) async {
    if (state.hasReport(event.id)) return;
    final ok = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Text('Confirmar Relatório',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
        content: const Text(
            'Enviar relatório para a central de monitoramento?',
            style: TextStyle(color: AppTheme.muted, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar',
                style: TextStyle(color: AppTheme.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (ok == true && ctx.mounted) {
      state.sendReport(event);
      ScaffoldMessenger.of(ctx).showSnackBar(_snack(
          '✅ Relatório salvo na aba Relatórios!'));
    }
  }

  void _toggleFav(BuildContext ctx, AppState state) {
    state.toggleFavorite(event.id);
    final fav = state.events.firstWhere((e) => e.id == event.id).isFavorite;
    ScaffoldMessenger.of(ctx)
        .showSnackBar(_snack(fav ? '❤️ Adicionado!' : '💔 Removido'));
  }

  SnackBar _snack(String msg) => SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.surface2,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.border),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final e = event;
    final sevColor = AppTheme.getSeverityColor(e.severity);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      // ── Sem SliverAppBar: usa AppBar normal + SingleChildScrollView ──
      // Isso elimina o overflow do FlexibleSpaceBar
      body: SafeArea(
        child: Column(
          children: [
            // ── Header fixo com gradiente ──────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    sevColor.withOpacity(0.25),
                    sevColor.withOpacity(0.08),
                    AppTheme.bg,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra topo: back + fav
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: const Icon(Icons.arrow_back, size: 18),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        AnimatedBuilder(
                          animation: state,
                          builder: (_, __) {
                            final fav = state.events
                                .firstWhere((ev) => ev.id == e.id)
                                .isFavorite;
                            return IconButton(
                              icon: Text(fav ? '❤️' : '🤍',
                                  style: const TextStyle(fontSize: 22)),
                              onPressed: () =>
                                  _toggleFav(context, state),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Emoji + título + local
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppTheme.getEventTypeIcon(e.type),
                            style: const TextStyle(fontSize: 38)),
                        const SizedBox(height: 6),
                        Text(e.title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.location_on,
                              size: 12, color: AppTheme.muted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(e.location,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.muted)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Conteúdo scrollável ────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: LayoutBuilder(builder: (ctx, constraints) {
                  final wide = constraints.maxWidth > 700;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: wide ? 32 : 16, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges
                        Row(children: [
                          _DetailBadge(
                              label: AppTheme.getSeverityLabel(e.severity),
                              color: sevColor),
                          const SizedBox(width: 8),
                          _DetailBadge(
                              label: AppTheme.getEventTypeLabel(e.type),
                              color: AppTheme.getEventTypeColor(e.type)),
                          const Spacer(),
                          Text(e.detectedAt,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.muted)),
                        ]),

                        const SizedBox(height: 16),

                        if (wide)
                          // ── Desktop: 2 colunas ─────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(children: [
                                  _Section(
                                    title: 'Descrição',
                                    child: Text(e.description,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.muted,
                                            height: 1.7)),
                                  ),
                                  const SizedBox(height: 12),
                                  _Section(
                                    title: 'Satélite Detector',
                                    child: _SatCard(satellite: e.satellite),
                                  ),
                                ]),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 4,
                                child: Column(children: [
                                  _Section(
                                    title: 'Dados Técnicos',
                                    child: Column(children: [
                                      _TechRow(label: 'SATÉLITE', value: e.satellite),
                                      _TechRow(label: 'ÁREA', value: e.area),
                                      _TechRow(label: 'DETECÇÃO', value: e.detectedAt),
                                      _TechRow(label: 'COORDS', value: e.coordinates, last: true),
                                    ]),
                                  ),
                                  const SizedBox(height: 12),
                                  AnimatedBuilder(
                                    animation: state,
                                    builder: (_, __) => _ReportButton(
                                      sent: state.hasReport(e.id),
                                      onPressed: () =>
                                          _sendReport(context, state),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          )
                        else ...[
                          // ── Mobile: coluna única ───────────
                          _Section(
                            title: 'Descrição',
                            child: Text(e.description,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.muted,
                                    height: 1.7)),
                          ),
                          const SizedBox(height: 12),
                          _Section(
                            title: 'Dados Técnicos',
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: _TechRow(
                                        label: 'SATÉLITE',
                                        value: e.satellite)),
                                Expanded(
                                    child: _TechRow(
                                        label: 'ÁREA', value: e.area)),
                              ]),
                              Row(children: [
                                Expanded(
                                    child: _TechRow(
                                        label: 'DETECÇÃO',
                                        value: e.detectedAt)),
                                Expanded(
                                    child: _TechRow(
                                        label: 'COORDS',
                                        value: e.coordinates,
                                        last: true)),
                              ]),
                            ]),
                          ),
                          const SizedBox(height: 12),
                          _Section(
                            title: 'Satélite Detector',
                            child: _SatCard(satellite: e.satellite),
                          ),
                          const SizedBox(height: 20),
                          AnimatedBuilder(
                            animation: state,
                            builder: (_, __) => _ReportButton(
                              sent: state.hasReport(e.id),
                              onPressed: () =>
                                  _sendReport(context, state),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────

class _SatCard extends StatelessWidget {
  final String satellite;
  const _SatCard({required this.satellite});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Center(
            child: Text('🛰️', style: TextStyle(fontSize: 20))),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(satellite,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.cyan)),
          const Text('Sistema de monitoramento orbital ativo',
              style: TextStyle(fontSize: 11, color: AppTheme.muted)),
        ]),
      ),
      Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppTheme.green)),
    ]);
  }
}

class _ReportButton extends StatelessWidget {
  final bool sent;
  final VoidCallback onPressed;
  const _ReportButton({required this.sent, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: sent
          ? OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.check_circle, size: 18),
              label: const Text('Relatório Enviado'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.green,
                side: const BorderSide(color: AppTheme.green),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Enviar Relatório'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyan,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: AppTheme.border))),
          child: Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w700)),
        ),
        Padding(
            padding: const EdgeInsets.all(14), child: child),
      ]),
    );
  }
}

class _TechRow extends StatelessWidget {
  final String label;
  final String value;
  final bool last;
  const _TechRow(
      {required this.label, required this.value, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12, right: 8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(label,
            style: const TextStyle(
                fontSize: 9,
                letterSpacing: 1,
                color: AppTheme.muted,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.cyan)),
      ]),
    );
  }
}

class _DetailBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _DetailBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: .5)),
    );
  }
}
