// lib/screens/report_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../data/app_state.dart';

class ReportDetailScreen extends StatelessWidget {
  final SentReport report;
  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final sevColor = AppTheme.getSeverityColor(report.severity);
    final typeColor = AppTheme.getEventTypeColor(report.type);
    final typeIcon  = AppTheme.getEventTypeIcon(report.type);
    final typeLabel = AppTheme.getEventTypeLabel(report.type);
    final sevLabel  = AppTheme.getSeverityLabel(report.severity);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(children: [
          // ── Header com gradiente ─────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  sevColor.withOpacity(0.22),
                  sevColor.withOpacity(0.07),
                  AppTheme.bg,
                ],
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Barra topo
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botão voltar
                    IconButton(
                      icon: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Icon(Icons.arrow_back, size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // ID do relatório
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(children: [
                        const Icon(Icons.tag, size: 12,
                            color: AppTheme.muted),
                        const SizedBox(width: 4),
                        Text(report.reportId,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.cyan,
                              letterSpacing: 1,
                            )),
                      ]),
                    ),
                  ],
                ),
              ),
              // Emoji + título
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(typeIcon,
                      style: const TextStyle(fontSize: 38)),
                  const SizedBox(height: 6),
                  Text(report.eventTitle,
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
                      child: Text(report.location,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.muted)),
                    ),
                  ]),
                ]),
              ),
            ]),
          ),

          // ── Conteúdo scrollável ──────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: LayoutBuilder(builder: (ctx, constraints) {
                final wide = constraints.maxWidth > 700;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: wide ? 32 : 16, vertical: 14),
                  child: wide
                      ? _wideBody(context, sevColor, typeColor,
                          sevLabel, typeLabel)
                      : _narrowBody(context, sevColor, typeColor,
                          sevLabel, typeLabel),
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Layout desktop (2 colunas) ─────────────────────────
  Widget _wideBody(BuildContext context, Color sevColor, Color typeColor,
      String sevLabel, String typeLabel) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Badges
      _badgesRow(sevColor, typeColor, sevLabel, typeLabel),
      const SizedBox(height: 20),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Coluna esquerda
        Expanded(flex: 6, child: Column(children: [
          _Section(title: 'Descrição do Evento',
              child: Text(report.description,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.muted, height: 1.7))),
          const SizedBox(height: 12),
          _Section(title: 'Satélite Detector',
              child: _SatelliteCard(satellite: report.satellite)),
          const SizedBox(height: 12),
          _Section(title: 'Status do Relatório',
              child: _StatusCard()),
        ])),
        const SizedBox(width: 16),
        // Coluna direita
        Expanded(flex: 4, child: Column(children: [
          _Section(title: 'Dados Técnicos', child: Column(children: [
            _TechRow(label: 'SATÉLITE',   value: report.satellite),
            _TechRow(label: 'ÁREA',       value: report.area),
            _TechRow(label: 'COORDS',     value: report.coordinates),
            _TechRow(label: 'PROTOCOLO',  value: report.reportId),
            _TechRow(label: 'DATA',       value: report.formattedDate),
            _TechRow(label: 'HORA',       value: report.formattedTime, last: true),
          ])),
          const SizedBox(height: 12),
          _CopyIdButton(reportId: report.reportId),
        ])),
      ]),
      const SizedBox(height: 32),
    ]);
  }

  // ── Layout mobile (coluna única) ───────────────────────
  Widget _narrowBody(BuildContext context, Color sevColor, Color typeColor,
      String sevLabel, String typeLabel) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _badgesRow(sevColor, typeColor, sevLabel, typeLabel),
      const SizedBox(height: 16),
      _Section(title: 'Descrição do Evento',
          child: Text(report.description,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.muted, height: 1.7))),
      const SizedBox(height: 12),
      _Section(title: 'Dados Técnicos', child: Column(children: [
        Row(children: [
          Expanded(child: _TechRow(label: 'SATÉLITE', value: report.satellite)),
          Expanded(child: _TechRow(label: 'ÁREA',     value: report.area)),
        ]),
        Row(children: [
          Expanded(child: _TechRow(label: 'COORDS',    value: report.coordinates)),
          Expanded(child: _TechRow(label: 'PROTOCOLO', value: report.reportId)),
        ]),
        Row(children: [
          Expanded(child: _TechRow(label: 'DATA',      value: report.formattedDate)),
          Expanded(child: _TechRow(label: 'HORA',      value: report.formattedTime, last: true)),
        ]),
      ])),
      const SizedBox(height: 12),
      _Section(title: 'Satélite Detector',
          child: _SatelliteCard(satellite: report.satellite)),
      const SizedBox(height: 12),
      _Section(title: 'Status do Relatório', child: _StatusCard()),
      const SizedBox(height: 20),
      _CopyIdButton(reportId: report.reportId),
      const SizedBox(height: 32),
    ]);
  }

  Widget _badgesRow(Color sevColor, Color typeColor,
      String sevLabel, String typeLabel) {
    return Row(children: [
      _Badge(label: sevLabel, color: sevColor),
      const SizedBox(width: 8),
      _Badge(label: typeLabel, color: typeColor),
      const Spacer(),
      Text('Às ${report.formattedTime}',
          style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
    ]);
  }
}

// ── Sub-widgets ────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _StatusRow(
        icon: Icons.check_circle,
        color: AppTheme.green,
        label: 'Relatório gerado',
        sub: 'Dados coletados do evento',
      ),
      const SizedBox(height: 10),
      _StatusRow(
        icon: Icons.send,
        color: AppTheme.cyan,
        label: 'Enviado à central',
        sub: 'Transmissão confirmada',
      ),
      const SizedBox(height: 10),
      _StatusRow(
        icon: Icons.done_all,
        color: AppTheme.green,
        label: 'Recebido com sucesso',
        sub: 'Aguardando análise da equipe',
      ),
    ]);
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String sub;
  const _StatusRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary)),
          Text(sub, style: const TextStyle(
              fontSize: 11, color: AppTheme.muted)),
        ],
      )),
      Icon(Icons.check, size: 14, color: color),
    ]);
  }
}

class _SatelliteCard extends StatelessWidget {
  final String satellite;
  const _SatelliteCard({required this.satellite});

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
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(satellite, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: AppTheme.cyan)),
          const Text('Sistema de monitoramento orbital ativo',
              style: TextStyle(fontSize: 11, color: AppTheme.muted)),
        ],
      )),
      Container(
        width: 8, height: 8,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: AppTheme.green),
      ),
    ]);
  }
}

class _CopyIdButton extends StatefulWidget {
  final String reportId;
  const _CopyIdButton({required this.reportId});

  @override
  State<_CopyIdButton> createState() => _CopyIdButtonState();
}

class _CopyIdButtonState extends State<_CopyIdButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          await Clipboard.setData(
              ClipboardData(text: widget.reportId));
          setState(() => _copied = true);
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) setState(() => _copied = false);
        },
        icon: Icon(
          _copied ? Icons.check : Icons.copy,
          size: 16,
          color: _copied ? AppTheme.green : AppTheme.cyan,
        ),
        label: Text(
          _copied ? 'Copiado!' : 'Copiar protocolo ${widget.reportId}',
          style: TextStyle(
            color: _copied ? AppTheme.green : AppTheme.cyan,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(
              color: _copied
                  ? AppTheme.green
                  : AppTheme.cyan.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// ── Widgets compartilhados ─────────────────────────────────
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border))),
          child: Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10, letterSpacing: 1.5,
                  color: AppTheme.muted, fontWeight: FontWeight.w700)),
        ),
        Padding(padding: const EdgeInsets.all(14), child: child),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 9, letterSpacing: 1,
                color: AppTheme.muted, fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700,
                color: AppTheme.cyan)),
      ]),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

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
              fontSize: 10, fontWeight: FontWeight.w700,
              color: color, letterSpacing: .5)),
    );
  }
}
