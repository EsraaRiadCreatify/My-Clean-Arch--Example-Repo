class ProductModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> images;
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.images = const [],
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'images': images,
      'isFavorite': isFavorite,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    List<String>? images,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 