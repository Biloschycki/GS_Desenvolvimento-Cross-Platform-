// lib/screens/events_screen.dart
import 'package:flutter/material.dart';
import 'package:orbitwatch/main.dart';
import '../theme.dart';
import '../models/event_model.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  EventType? _activeType;
  EventSeverity? _activeSeverity;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<SatelliteEvent> _filtered(List<SatelliteEvent> events) {
    return events.where((e) {
      final q = _searchCtrl.text.toLowerCase();
      final matchQ = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.location.toLowerCase().contains(q);
      final matchType = _activeType == null || e.type == _activeType;
      final matchSev =
          _activeSeverity == null || e.severity == _activeSeverity;
      return matchQ && matchType && matchSev;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppStateProvider.of(context),
      builder: (context, _) {
        final state = AppStateProvider.of(context);
        final filtered = _filtered(state.events);

        return LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth > 700;
          return Column(
            children: [
              // AppBar
              Container(
                padding: EdgeInsets.fromLTRB(
                    wide ? 24 : 16, 12, wide ? 24 : 16, 10),
                decoration: const BoxDecoration(
                  color: AppTheme.bg,
                  border:
                      Border(bottom: BorderSide(color: AppTheme.border)),
                ),
                child: Row(children: [
                  const Expanded(
                    child: Text('Eventos',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary)),
                  ),
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
                        '${filtered.length} resultado${filtered.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.cyan,
                            fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),

              // Busca + filtros em linha no desktop
              if (wide)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Row(children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                            color: AppTheme.textPrimary, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Buscar evento ou localização...',
                          prefixIcon: Icon(Icons.search,
                              color: AppTheme.muted, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Severidade inline
                    ...EventSeverity.values.map((s) {
                      final active = _activeSeverity == s;
                      final color = AppTheme.getSeverityColor(s);
                      return GestureDetector(
                        onTap: () => setState(() => _activeSeverity =
                            _activeSeverity == s ? null : s),
                        child: Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                active ? color : AppTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: active ? color : AppTheme.border),
                          ),
                          child: Text(AppTheme.getSeverityLabel(s),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .5,
                                  color: active
                                      ? Colors.black
                                      : AppTheme.muted)),
                        ),
                      );
                    }),
                  ]),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Buscar evento ou localização...',
                      prefixIcon: Icon(Icons.search,
                          color: AppTheme.muted, size: 18),
                    ),
                  ),
                ),

              // Filtros de tipo (scroll horizontal)
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: wide ? 24 : 16, vertical: 8),
                  children: [
                    _TypeChip(
                      label: 'Todos',
                      active: _activeType == null,
                      onTap: () => setState(() => _activeType = null),
                    ),
                    ...EventType.values.map((t) => _TypeChip(
                          label:
                              '${AppTheme.getEventTypeIcon(t)} ${AppTheme.getEventTypeLabel(t)}',
                          active: _activeType == t,
                          onTap: () => setState(() =>
                              _activeType = _activeType == t ? null : t),
                        )),
                  ],
                ),
              ),

              // Filtros severidade (só no mobile)
              if (!wide)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: EventSeverity.values.map((s) {
                      final active = _activeSeverity == s;
                      final color = AppTheme.getSeverityColor(s);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeSeverity =
                              _activeSeverity == s ? null : s),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding:
                                const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: active ? color : AppTheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: active ? color : AppTheme.border),
                            ),
                            child: Text(
                              AppTheme.getSeverityLabel(s),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .5,
                                  color: active
                                      ? Colors.black
                                      : AppTheme.muted),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // Lista de eventos — grade 2 col no desktop
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('Nenhum evento encontrado',
                            style: TextStyle(
                                color: AppTheme.muted, fontSize: 14)),
                      )
                    : wide
                        ? GridView.builder(
                            padding: const EdgeInsets.fromLTRB(
                                24, 0, 24, 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.8,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final e = filtered[i];
                              return _EventCard(
                                event: e,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            EventDetailScreen(event: e)),
                                  );
                                  setState(() {});
                                },
                                onFavToggle: () =>
                                    AppStateProvider.of(context)
                                        .toggleFavorite(e.id),
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 16),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final e = filtered[i];
                              return _EventCard(
                                event: e,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            EventDetailScreen(event: e)),
                                  );
                                  setState(() {});
                                },
                                onFavToggle: () =>
                                    AppStateProvider.of(context)
                                        .toggleFavorite(e.id),
                              );
                            },
                          ),
              ),
            ],
          );
        });
      },
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TypeChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? AppTheme.cyan.withOpacity(0.12)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? AppTheme.cyan : AppTheme.border),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: active ? AppTheme.cyan : AppTheme.muted)),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final SatelliteEvent event;
  final VoidCallback onTap;
  final VoidCallback onFavToggle;

  const _EventCard(
      {required this.event,
      required this.onTap,
      required this.onFavToggle});

  @override
  Widget build(BuildContext context) {
    final sevColor = AppTheme.getSeverityColor(event.severity);
    final typeColor = AppTheme.getEventTypeColor(event.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppTheme.getEventTypeIcon(event.type),
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(event.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.location_on,
                        size: 10, color: AppTheme.muted),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(event.location,
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.muted),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                ]),
              ),
              GestureDetector(
                onTap: onFavToggle,
                child: Text(event.isFavorite ? '❤️' : '🤍',
                    style: const TextStyle(fontSize: 18)),
              ),
            ]),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                event.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.muted, height: 1.5),
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              _Badge(
                  label: AppTheme.getEventTypeLabel(event.type),
                  color: typeColor),
              const SizedBox(width: 6),
              _Badge(
                  label: AppTheme.getSeverityLabel(event.severity),
                  color: sevColor),
              const Spacer(),
              Text(event.detectedAt,
                  style: const TextStyle(
                      fontSize: 10, color: AppTheme.muted)),
            ]),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.6)),
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
