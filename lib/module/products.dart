class Product {
  final int id;
  final String name;
  final String sku;
  final String description;
  final String shortDescription;
  final String regularPrice;
  final String salePrice;
  final int stockQuantity;
  final bool manageStock;
  final bool inStock;
  final List<Map<String, dynamic>>
      images; // List of images (you may need to parse image data further)
  // Add other attributes as needed

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.description,
    required this.shortDescription,
    required this.regularPrice,
    required this.salePrice,
    required this.stockQuantity,
    required this.manageStock,
    required this.inStock,
    required this.images,
    // Add other attributes as needed
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      description: json['description'],
      shortDescription: json['short_description'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
      stockQuantity: json['stock_quantity'],
      manageStock: json['manage_stock'],
      inStock: json['in_stock'],
      images: List<Map<String, dynamic>>.from(json['images'] ?? []),
      // Parse and include other attributes as needed
    );
  }
}
