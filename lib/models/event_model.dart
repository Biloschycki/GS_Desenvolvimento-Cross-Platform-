// lib/models/event_model.dart

enum EventType { queimada, enchente, desmatamento, tempestade, nivelMar }
enum EventSeverity { baixa, media, alta, critica }

class SatelliteEvent {
  final int id;
  final String title;
  final String description;
  final String location;
  final String coordinates;
  final EventType type;
  final EventSeverity severity;
  final String detectedAt;
  final String area;
  final String satellite;
  bool isFavorite;

  SatelliteEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.coordinates,
    required this.type,
    required this.severity,
    required this.detectedAt,
    required this.area,
    required this.satellite,
    this.isFavorite = false,
  });

  SatelliteEvent copyWith({bool? isFavorite}) => SatelliteEvent(
    id: id,
    title: title,
    description: description,
    location: location,
    coordinates: coordinates,
    type: type,
    severity: severity,
    detectedAt: detectedAt,
    area: area,
    satellite: satellite,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}

class SatelliteInfo {
  final int id;
  final String name;
  final String orbit;
  final String resolution;
  final String coverage;
  final bool isActive;
  final String altitude;
  final String purpose;

  const SatelliteInfo({
    required this.id,
    required this.name,
    required this.orbit,
    required this.resolution,
    required this.coverage,
    required this.isActive,
    required this.altitude,
    required this.purpose,
  });
}

class EnvironmentalAlert {
  final int id;
  final String title;
  final String message;
  final String region;
  final String issuedAt;
  bool isRead;
  final EventSeverity severity;

  EnvironmentalAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.region,
    required this.issuedAt,
    required this.severity,
    this.isRead = false,
  });
}
