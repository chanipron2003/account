class TouristAttraction {
  final int? keyID;
  final String name;
  final String province;
  final DateTime date;
  final String highlight;
  final String feeling;
  final String imagePath;

  TouristAttraction({
    this.keyID,
    required this.name,
    required this.province,
    required this.date,
    required this.highlight,
    required this.feeling,
    required this.imagePath,
  });
}