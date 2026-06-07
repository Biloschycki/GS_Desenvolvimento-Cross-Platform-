// lib/data/mock_data.dart
import '../models/event_model.dart';

final List<SatelliteEvent> mockEvents = [
  SatelliteEvent(
    id: 1,
    title: 'Queimada no Pará',
    description:
        'Foco de incêndio detectado em área de floresta densa próxima ao Rio Tapajós. '
        'Risco de expansão para reservas indígenas e parques nacionais. Vento favorece propagação.',
    location: 'Pará, BR',
    coordinates: '-3.4°, -55.2°',
    type: EventType.queimada,
    severity: EventSeverity.critica,
    detectedAt: 'Há 2h',
    area: '12.400 ha',
    satellite: 'CBERS-4A',
  ),
  SatelliteEvent(
    id: 2,
    title: 'Queimada no Pantanal',
    description:
        'Incêndio de grandes proporções no Pantanal Sul. Animais silvestres em risco de fuga. '
        'Fumaça detectada a 300 km de altitude.',
    location: 'Mato Grosso do Sul, BR',
    coordinates: '-19.5°, -57.1°',
    type: EventType.queimada,
    severity: EventSeverity.alta,
    detectedAt: 'Há 5h',
    area: '8.200 ha',
    satellite: 'Landsat-9',
  ),
  SatelliteEvent(
    id: 3,
    title: 'Enchente no Amazonas',
    description:
        'Nível do Rio Amazonas 4 m acima do normal. Comunidades ribeirinhas isoladas. '
        'Sistema de baixa pressão estacionado sobre a bacia.',
    location: 'Amazonas, BR',
    coordinates: '-3.1°, -60.0°',
    type: EventType.enchente,
    severity: EventSeverity.critica,
    detectedAt: 'Há 1h',
    area: '3.100 km²',
    satellite: 'GOES-16',
  ),
  SatelliteEvent(
    id: 4,
    title: 'Enchente em Itajaí',
    description:
        'Chuvas intensas causam alagamentos no Vale do Itajaí. '
        'Previsão de continuidade por 48 h. Rodovias estaduais bloqueadas.',
    location: 'Santa Catarina, BR',
    coordinates: '-26.9°, -48.7°',
    type: EventType.enchente,
    severity: EventSeverity.alta,
    detectedAt: 'Há 3h',
    area: '420 km²',
    satellite: 'Sentinel-1',
  ),
  SatelliteEvent(
    id: 5,
    title: 'Desmatamento no Mato Grosso',
    description:
        'Atividade de desmatamento identificada em área de amortecimento de unidade de conservação. '
        'Cicatrizes de vegetação confirmadas por imagem SAR.',
    location: 'Mato Grosso, BR',
    coordinates: '-12.5°, -53.4°',
    type: EventType.desmatamento,
    severity: EventSeverity.alta,
    detectedAt: 'Há 6h',
    area: '2.800 ha',
    satellite: 'Sentinel-2',
  ),
  SatelliteEvent(
    id: 6,
    title: 'Desmatamento na Bahia',
    description:
        'Supressão vegetal em Caatinga identificada. '
        'Área anteriormente protegida por RPPN apresenta abertura de clareiras.',
    location: 'Bahia, BR',
    coordinates: '-12.2°, -41.1°',
    type: EventType.desmatamento,
    severity: EventSeverity.media,
    detectedAt: 'Há 8h',
    area: '950 ha',
    satellite: 'Landsat-9',
  ),
  SatelliteEvent(
    id: 7,
    title: 'Tempestade em SC',
    description:
        'Sistema de baixa pressão com ventos de 95 km/h e granizo. '
        'Alerta máximo emitido pela Defesa Civil. Telhados danificados.',
    location: 'Santa Catarina, BR',
    coordinates: '-27.6°, -48.5°',
    type: EventType.tempestade,
    severity: EventSeverity.critica,
    detectedAt: 'Há 30 min',
    area: '—',
    satellite: 'GOES-16',
  ),
  SatelliteEvent(
    id: 8,
    title: 'Elevação do Mar em PE',
    description:
        'Nível do mar 0,4 m acima da média histórica. '
        'Impacto em recifes de coral e praias urbanas do litoral pernambucano.',
    location: 'Pernambuco, BR',
    coordinates: '-8.0°, -34.9°',
    type: EventType.nivelMar,
    severity: EventSeverity.media,
    detectedAt: 'Há 12h',
    area: '180 km',
    satellite: 'Jason-3',
  ),
];

final List<SatelliteInfo> mockSatellites = [
  const SatelliteInfo(
    id: 1,
    name: 'CBERS-4A',
    orbit: 'Polar Heliossincrona',
    resolution: '8 m/pixel',
    coverage: 'Global',
    isActive: true,
    altitude: '615 km',
    purpose:
        'Sensoriamento remoto multifuncional para monitoramento ambiental e agrícola do território brasileiro.',
  ),
  const SatelliteInfo(
    id: 2,
    name: 'Sentinel-2',
    orbit: 'Polar Heliossincrona',
    resolution: '10 m/pixel',
    coverage: 'Europa / América',
    isActive: true,
    altitude: '786 km',
    purpose:
        'Monitoramento terrestre de alta resolução para vegetação, uso do solo e eventos ambientais.',
  ),
  const SatelliteInfo(
    id: 3,
    name: 'GOES-16',
    orbit: 'Geoestacionária',
    resolution: '500 m/pixel',
    coverage: 'Américas',
    isActive: true,
    altitude: '35.786 km',
    purpose:
        'Imagens meteorológicas contínuas e detecção de fenômenos climáticos severos em tempo real.',
  ),
  const SatelliteInfo(
    id: 4,
    name: 'Landsat-9',
    orbit: 'Polar Heliossincrona',
    resolution: '30 m/pixel',
    coverage: 'Global',
    isActive: true,
    altitude: '705 km',
    purpose:
        'Monitoramento de longo prazo de recursos terrestres e análise de mudanças de uso do solo.',
  ),
  const SatelliteInfo(
    id: 5,
    name: 'Jason-3',
    orbit: 'Não-polar',
    resolution: '—',
    coverage: 'Oceânica',
    isActive: false,
    altitude: '1.336 km',
    purpose:
        'Altimetria oceânica e monitoramento preciso do nível global dos mares.',
  ),
  const SatelliteInfo(
    id: 6,
    name: 'Sentinel-1',
    orbit: 'Polar Heliossincrona',
    resolution: '5 m/pixel',
    coverage: 'Global',
    isActive: true,
    altitude: '693 km',
    purpose:
        'Radar SAR para monitoramento 24/7 independente de cobertura de nuvens ou condição de luz.',
  ),
];

final List<EnvironmentalAlert> mockAlerts = [
  EnvironmentalAlert(
    id: 1,
    title: 'Queimada Crítica — Amazônia',
    message:
        'Foco ativo detectado pelo CBERS-4A. Área afetada superior a 10.000 ha. Risco de expansão.',
    region: 'Norte',
    issuedAt: '14:23',
    severity: EventSeverity.critica,
    isRead: false,
  ),
  EnvironmentalAlert(
    id: 2,
    title: 'Enchente Iminente — AM',
    message:
        'Rio Solimões em nível de emergência. Evacuação recomendada para zona de risco.',
    region: 'Norte',
    issuedAt: '13:10',
    severity: EventSeverity.critica,
    isRead: false,
  ),
  EnvironmentalAlert(
    id: 3,
    title: 'Tempestade — SC',
    message:
        'Ventos superiores a 90 km/h confirmados. Chuva de granizo em Blumenau.',
    region: 'Sul',
    issuedAt: '12:45',
    severity: EventSeverity.alta,
    isRead: true,
  ),
  EnvironmentalAlert(
    id: 4,
    title: 'Desmatamento — MT',
    message:
        'Nova área suprimida identificada próxima ao Parque do Xingu.',
    region: 'Centro-Oeste',
    issuedAt: '10:00',
    severity: EventSeverity.alta,
    isRead: true,
  ),
  EnvironmentalAlert(
    id: 5,
    title: 'Nível do Mar — PE',
    message:
        'Elevação de maré registrada pelo Jason-3. Monitoramento contínuo ativo.',
    region: 'Nordeste',
    issuedAt: '08:30',
    severity: EventSeverity.media,
    isRead: true,
  ),
];

const Map<String, dynamic> dashboardStats = {
  'totalEvents': 8,
  'criticalEvents': 3,
  'activeSatellites': 5,
  'alertsToday': 5,
  'eventsThisMonth': 34,
};
