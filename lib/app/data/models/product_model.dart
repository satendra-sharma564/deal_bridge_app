class AffiliateLinkModel {
  final String platform;
  final String url;

  AffiliateLinkModel({required this.platform, required this.url});

  factory AffiliateLinkModel.fromJson(Map<String, dynamic> json) =>
      AffiliateLinkModel(
        platform: json['platform'] ?? '',
        url: json['url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'url': url,
      };
}

class ProductModel {
  final String? id;
  final String title;
  final double price;
  final String category;
  final String image;
  final int clicks;
  final String? description;
  final String? affiliateLink;
  final String? link;
  final List<AffiliateLinkModel> links;

  ProductModel({
    this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    this.clicks = 0,
    this.description,
    this.affiliateLink,
    this.link,
    this.links = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['_id'],
        title: json['title'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        category: json['category'] ?? '',
        image: json['image'] ?? '',
        clicks: json['clicks'] ?? 0,
        description: json['description'],
        affiliateLink: json['affiliateLink'],
        link: json['link'],
        links: json['links'] != null
            ? List<AffiliateLinkModel>.from(
                json['links'].map((x) => AffiliateLinkModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'category': category,
        'image': image,
        'clicks': clicks,
        'description': description,
        'affiliateLink': affiliateLink,
        'link': link,
        'links': links.map((x) => x.toJson()).toList(),
      };
}
