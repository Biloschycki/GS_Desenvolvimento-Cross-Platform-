// lib/data/app_state.dart
import 'package:flutter/material.dart';
import 'mock_data.dart';
import '../models/event_model.dart';

class AppState extends ChangeNotifier {
  final List<SatelliteEvent> events = List.from(mockEvents);
  final List<EnvironmentalAlert> alerts = List.from(mockAlerts);
  final List<SentReport> reports = [];

  int get unreadCount => alerts.where((a) => !a.isRead).length;

  void toggleFavorite(int id) {
    final e = events.firstWhere((e) => e.id == id);
    e.isFavorite = !e.isFavorite;
    notifyListeners();
  }

  void toggleAlertRead(int id) {
    final a = alerts.firstWhere((a) => a.id == id);
    a.isRead = !a.isRead;
    notifyListeners();
  }

  void markAllAlertsRead() {
    for (final a in alerts) {
      a.isRead = true;
    }
    notifyListeners();
  }

  bool hasReport(int eventId) => reports.any((r) => r.eventId == eventId);

  void sendReport(SatelliteEvent event) {
    if (!hasReport(event.id)) {
      reports.add(SentReport(
        eventId: event.id,
        eventTitle: event.title,
        location: event.location,
        coordinates: event.coordinates,
        severity: event.severity,
        type: event.type,
        sentAt: DateTime.now(),
        satellite: event.satellite,
        area: event.area,
        description: event.description,
      ));
      notifyListeners();
    }
  }
}

class SentReport {
  final int eventId;
  final String eventTitle;
  final String location;
  final String coordinates;
  final EventSeverity severity;
  final EventType type;
  final DateTime sentAt;
  final String satellite;
  final String area;
  final String description;

  // Número sequencial gerado na criação
  static int _counter = 1000;
  final int reportNumber;

  SentReport({
    required this.eventId,
    required this.eventTitle,
    required this.location,
    required this.coordinates,
    required this.severity,
    required this.type,
    required this.sentAt,
    required this.satellite,
    required this.area,
    required this.description,
  }) : reportNumber = ++_counter;

  String get formattedTime {
    final h = sentAt.hour.toString().padLeft(2, '0');
    final m = sentAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get formattedDate {
    final d = sentAt.day.toString().padLeft(2, '0');
    final mo = sentAt.month.toString().padLeft(2, '0');
    final y = sentAt.year;
    return '$d/$mo/$y';
  }

  String get reportId => 'OW-$reportNumber';
}
