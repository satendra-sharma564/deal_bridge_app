// class PlatformModel {
//   final String name;
//   final String logo;
//   final String link;
//   final String color;

//   PlatformModel({
//     required this.name,
//     required this.logo,
//     required this.link,
//     required this.color,
//   });

//   factory PlatformModel.fromJson(Map<String, dynamic> json) {
//     return PlatformModel(
//       name: json['name'],
//       logo: json['logo'],
//       link: json['link'],
//       color: json['color'],
//     );
//   }

//   get id => null;
// }

class PlatformModel {
  final String id;
  final String name;
  final String logo;
  final String link;
  final String color;

  PlatformModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.link,
    required this.color,
  });

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      id: json['_id']?.toString() ?? "",
      name: json['name'] ?? "Unknown",
      logo: json['logo'] ?? "https://via.placeholder.com/100",
      link: json['link'] ?? "",
      color: json['color'] ?? "#ffffff",
    );
  }
}
