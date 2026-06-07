// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:orbitwatch/main.dart';
import '../theme.dart';
import '../data/app_state.dart';
import 'report_detail_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppStateProvider.of(context),
      builder: (context, _) {
        final reports = AppStateProvider.of(context).reports;

        return Column(children: [
          // ── AppBar ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(
              color: AppTheme.bg,
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(children: [
              const Expanded(
                child: Text('Relatórios',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary)),
              ),
              if (reports.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppTheme.cyan.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${reports.length} enviado${reports.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.cyan,
                        fontWeight: FontWeight.w600),
                  ),
                ),
            ]),
          ),

          // ── Status bar ──────────────────────────────────────
          if (reports.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AppTheme.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.green.withOpacity(0.2)),
              ),
              child: Row(children: [
                Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.green)),
                const SizedBox(width: 10),
                const Text('CENTRAL RECEBEU TODOS OS RELATÓRIOS',
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: AppTheme.green,
                        fontWeight: FontWeight.w700)),
              ]),
            ),

          // ── Lista ───────────────────────────────────────────
          Expanded(
            child: reports.isEmpty
                ? _EmptyState()
                : LayoutBuilder(builder: (ctx, constraints) {
                    final wide = constraints.maxWidth > 700;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: reports.length,
                      itemBuilder: (_, i) {
                        // mais recente primeiro
                        final r = reports[reports.length - 1 - i];
                        return _ReportCard(
                          report: r,
                          wide: wide,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReportDetailScreen(report: r),
                            ),
                          ),
                        );
                      },
                    );
                  }),
          ),
        ]);
      },
    );
  }
}

// ── Empty state ────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: const Center(
                child: Text('📋', style: TextStyle(fontSize: 36))),
          ),
          const SizedBox(height: 16),
          const Text('Nenhum relatório enviado',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Acesse um evento e toque em "Enviar Relatório" para registrá-lo aqui.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: AppTheme.muted, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card clicável ──────────────────────────────────────────
class _ReportCard extends StatelessWidget {
  final SentReport report;
  final bool wide;
  final VoidCallback onTap;
  const _ReportCard(
      {required this.report,
      required this.wide,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sevColor = AppTheme.getSeverityColor(report.severity);
    final typeIcon = AppTheme.getEventTypeIcon(report.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Stack(children: [
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(16),
            child: wide
                ? _wideContent(sevColor, typeIcon)
                : _narrowContent(sevColor, typeIcon),
          ),
          // Seta "ver detalhes" no canto inferior direito
          Positioned(
            bottom: 12, right: 14,
            child: Row(children: [
              const Text('Ver detalhes',
                  style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.cyan,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios,
                  size: 10, color: AppTheme.cyan),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _wideContent(Color sevColor, String typeIcon) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Ícone check
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: AppTheme.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.green.withOpacity(0.3)),
        ),
        child: const Center(
            child: Icon(Icons.check_circle_outline,
                color: AppTheme.green, size: 22)),
      ),
      const SizedBox(width: 14),
      // Info principal
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(typeIcon,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(report.eventTitle,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.location_on, size: 11, color: AppTheme.muted),
            const SizedBox(width: 3),
            Text(report.location,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.muted)),
            const SizedBox(width: 12),
            const Icon(Icons.satellite_alt,
                size: 11, color: AppTheme.muted),
            const SizedBox(width: 3),
            Text(report.satellite,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.muted)),
          ]),
          const SizedBox(height: 4),
          Text('Protocolo: ${report.reportId}',
              style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.cyan,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5)),
        ],
      )),
      // Badges e hora
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        _SevBadge(label: AppTheme.getSeverityLabel(report.severity),
            color: sevColor),
        const SizedBox(height: 8),
        Text('Enviado às ${report.formattedTime}',
            style: const TextStyle(
                fontSize: 11, color: AppTheme.muted)),
        const SizedBox(height: 20), // espaço para a seta
      ]),
    ]);
  }

  Widget _narrowContent(Color sevColor, String typeIcon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.green.withOpacity(0.3)),
            ),
            child: const Center(
                child: Icon(Icons.check_circle_outline,
                    color: AppTheme.green, size: 18)),
          ),
          const SizedBox(width: 10),
          Text(typeIcon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(report.eventTitle,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary),
                overflow: TextOverflow.ellipsis),
          ),
          _SevBadge(label: AppTheme.getSeverityLabel(report.severity),
              color: sevColor),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.location_on, size: 11, color: AppTheme.muted),
          const SizedBox(width: 3),
          Text(report.location,
              style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
          const SizedBox(width: 8),
          const Icon(Icons.satellite_alt, size: 11, color: AppTheme.muted),
          const SizedBox(width: 3),
          Expanded(
            child: Text(report.satellite,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.muted)),
          ),
          Text('Às ${report.formattedTime}',
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.muted)),
        ]),
        const SizedBox(height: 6),
        Text('Protocolo: ${report.reportId}',
            style: const TextStyle(
                fontSize: 11,
                color: AppTheme.cyan,
                fontWeight: FontWeight.w600,
                letterSpacing: .5)),
        const SizedBox(height: 18), // espaço para a seta
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
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
