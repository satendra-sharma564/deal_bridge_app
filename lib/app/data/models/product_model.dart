class ProductModel {
  final String? id;
  final String title;
  final double price;
  final String category;
  final String image;
  final int clicks;

  ProductModel({
    this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    this.clicks = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['_id'],
        title: json['title'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        category: json['category'] ?? '',
        image: json['image'] ?? '',
        clicks: json['clicks'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'category': category,
        'image': image,
        'clicks': clicks,
      };
}
