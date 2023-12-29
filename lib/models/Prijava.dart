class Prijava {
  final String id;
  final String userId;
  final String imageUrl;
  final String lat;
  final String long;
  final String description;
  final String status;
  final DateTime createdAt;
  const Prijava({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.lat,
    required this.long,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}
