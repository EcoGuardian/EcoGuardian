class Aktivnost {
  String id;
  String naziv;
  String opis;
  String lat;
  String long;
  String datum;
  String vrijeme;
  String likes;
  bool isLiked;
  DateTime createdAt;

  Aktivnost({
    required this.id,
    required this.naziv,
    required this.opis,
    required this.lat,
    required this.long,
    required this.datum,
    required this.vrijeme,
    required this.likes,
    required this.isLiked,
    required this.createdAt,
  });
}
