class PlatformModel {
  final String name;
  final String logo;
  final String link;
  final String color;

  PlatformModel({
    required this.name,
    required this.logo,
    required this.link,
    required this.color,
  });

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      name: json['name'],
      logo: json['logo'],
      link: json['link'],
      color: json['color'],
    );
  }
}
