// lib/screens/satellites_screen.dart
import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../models/event_model.dart';

class SatellitesScreen extends StatefulWidget {
  const SatellitesScreen({super.key});

  @override
  State<SatellitesScreen> createState() => _SatellitesScreenState();
}

class _SatellitesScreenState extends State<SatellitesScreen> {
  bool _onlyActive = false;

  List<SatelliteInfo> get _filtered => _onlyActive
      ? mockSatellites.where((s) => s.isActive).toList()
      : mockSatellites;

  @override
  Widget build(BuildContext context) {
    final active = mockSatellites.where((s) => s.isActive).length;
    final inactive = mockSatellites.length - active;
    final filtered = _filtered;

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth > 700;

      return Column(children: [
        // ── AppBar ───────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(
              wide ? 24 : 16, 12, wide ? 24 : 16, 12),
          decoration: const BoxDecoration(
            color: AppTheme.bg,
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Row(children: [
            const Expanded(
              child: Text('Satélites',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary)),
            ),
            if (wide) ...[
              const Text('Apenas Ativos',
                  style: TextStyle(fontSize: 12, color: AppTheme.muted)),
              const SizedBox(width: 8),
              Switch(
                value: _onlyActive,
                onChanged: (v) => setState(() => _onlyActive = v),
                activeColor: AppTheme.cyan,
                activeTrackColor: AppTheme.cyan.withOpacity(0.3),
                inactiveThumbColor: AppTheme.muted,
                inactiveTrackColor: AppTheme.surface2,
              ),
            ],
          ]),
        ),

        // ── Corpo scrollável ─────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                wide ? 24 : 16, 16, wide ? 24 : 16, 24),
            child: Column(children: [
              // Card resumo
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(children: [
                  _SumItem(
                      value: '${mockSatellites.length}',
                      label: 'Total',
                      color: AppTheme.cyan),
                  Container(width: 1, height: 36, color: AppTheme.border),
                  _SumItem(
                      value: '$active',
                      label: 'Ativos',
                      color: AppTheme.green),
                  Container(width: 1, height: 36, color: AppTheme.border),
                  _SumItem(
                      value: '$inactive',
                      label: 'Inativos',
                      color: AppTheme.muted),
                ]),
              ),

              // Toggle (só mobile)
              if (!wide)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Mostrar apenas Ativos',
                          style: TextStyle(
                              fontSize: 13, color: AppTheme.muted)),
                      Switch(
                        value: _onlyActive,
                        onChanged: (v) => setState(() => _onlyActive = v),
                        activeColor: AppTheme.cyan,
                        activeTrackColor: AppTheme.cyan.withOpacity(0.3),
                        inactiveThumbColor: AppTheme.muted,
                        inactiveTrackColor: AppTheme.surface2,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              // Lista / grade
              if (wide)
                // Grade 2 colunas no desktop
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                  ),
                  itemBuilder: (_, i) =>
                      _SatCard(satellite: filtered[i]),
                )
              else
                // Lista simples no mobile
                Column(
                  children: filtered
                      .map((s) => _SatCard(satellite: s))
                      .toList(),
                ),
            ]),
          ),
        ),
      ]);
    });
  }
}

// ── Widgets ───────────────────────────────────────────────

class _SumItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _SumItem(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
      ]),
    );
  }
}

class _SatCard extends StatefulWidget {
  final SatelliteInfo satellite;
  const _SatCard({required this.satellite});

  @override
  State<_SatCard> createState() => _SatCardState();
}

class _SatCardState extends State<_SatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
      vsync: this, duration: const Duration(seconds: 2));
  late final Animation<double> _anim =
      Tween(begin: 0.3, end: 1.0).animate(_pulse);

  @override
  void initState() {
    super.initState();
    if (widget.satellite.isActive) _pulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.satellite;
    final statusColor = s.isActive ? AppTheme.green : AppTheme.muted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Não usa Expanded — altura determinada pelo conteúdo
        children: [
          // Topo: ícone + nome + status
          Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(12),
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
                  Text(s.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  Text(s.orbit,
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.muted)),
                ],
              ),
            ),
            Row(children: [
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                    boxShadow: s.isActive
                        ? [
                            BoxShadow(
                              color: statusColor.withOpacity(_anim.value),
                              blurRadius: 6,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(s.isActive ? 'ATIVO' : 'INATIVO',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                      letterSpacing: .5)),
            ]),
          ]),

          const SizedBox(height: 10),

          // Propósito (sem Expanded — sem altura fixa)
          Text(s.purpose,
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.muted, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),

          const SizedBox(height: 10),

          // Badges técnicos
          Wrap(spacing: 6, runSpacing: 4, children: [
            _TechBadge('🎯 ${s.resolution}'),
            _TechBadge('🌍 ${s.coverage}'),
            _TechBadge('📡 ${s.altitude}'),
          ]),
        ],
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  final String label;
  const _TechBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 10, color: AppTheme.muted)),
    );
  }
}
