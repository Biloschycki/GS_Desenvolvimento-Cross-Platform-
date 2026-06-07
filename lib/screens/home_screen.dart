// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:orbitwatch/main.dart';
import '../theme.dart';
import 'dashboard_screen.dart';
import 'events_screen.dart';
import 'satellites_screen.dart';
import 'reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    EventsScreen(),
    SatellitesScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final reportCount = appState.reports.length;
    final isWide = MediaQuery.of(context).size.width > 700;

    // ── Desktop: NavigationRail lateral ─────────────────────
    if (isWide) {
      return Scaffold(
        backgroundColor: AppTheme.bg,
        body: SafeArea(
          child: Row(children: [
            // Rail lateral
            Container(
              width: 220,
              decoration: const BoxDecoration(
                color: AppTheme.navy,
                border: Border(right: BorderSide(color: AppTheme.border)),
              ),
              child: Column(children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'ORBIT',
                        style: TextStyle(
                            color: AppTheme.cyan,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2),
                      ),
                      TextSpan(
                        text: 'WATCH',
                        style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2),
                      ),
                    ]),
                  ),
                ),
                // Itens de navegação
                ..._navItems(reportCount).asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  final active = _currentIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = i),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: active
                            ? AppTheme.cyan.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: active
                              ? AppTheme.cyan.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(item.icon,
                                size: 20,
                                color: active
                                    ? AppTheme.cyan
                                    : AppTheme.muted),
                            if (item.badge != null && item.badge! > 0)
                              Positioned(
                                top: -4, right: -6,
                                child: Container(
                                  width: 15, height: 15,
                                  decoration: BoxDecoration(
                                    color: AppTheme.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppTheme.navy, width: 1.5),
                                  ),
                                  child: Center(
                                    child: Text('${item.badge}',
                                        style: const TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Text(item.label,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? AppTheme.cyan
                                    : AppTheme.muted)),
                      ]),
                    ),
                  );
                }),
              ]),
            ),
            // Conteúdo principal
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ]),
        ),
      );
    }

    // ── Mobile: BottomNavigationBar ──────────────────────────
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.bg,
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.cyan,
          unselectedItemColor: AppTheme.muted,
          selectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: .5),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: _navItems(reportCount).map((item) {
            return BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(item.icon),
                  if (item.badge != null && item.badge! > 0)
                    Positioned(
                      top: -4, right: -6,
                      child: Container(
                        width: 15, height: 15,
                        decoration: BoxDecoration(
                          color: AppTheme.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppTheme.bg, width: 1.5),
                        ),
                        child: Center(
                          child: Text('${item.badge}',
                              style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                ],
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }

  List<_NavItem> _navItems(int reportCount) => [
    _NavItem(Icons.grid_view_rounded, 'Dashboard'),
    _NavItem(Icons.travel_explore_rounded, 'Eventos'),
    _NavItem(Icons.satellite_alt_rounded, 'Satélites'),
    _NavItem(Icons.description_rounded, 'Relatórios',
        badge: reportCount > 0 ? reportCount : null),
  ];
}

class _NavItem {
  final IconData icon;
  final String label;
  final int? badge;
  _NavItem(this.icon, this.label, {this.badge});
}
