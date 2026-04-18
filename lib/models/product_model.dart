class ProductModel {
  final String id;
  final String companyId;
  final String companyName;
  final String name;
  final String concentration;
  final int quantity;
  final double price;
  final bool requiresPrescription;
  final String? imageUrl;
  final DateTime expiryDate;
  final bool isActive;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.name,
    required this.concentration,
    required this.quantity,
    required this.price,
    required this.requiresPrescription,
    this.imageUrl,
    required this.expiryDate,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'name': name,
      'concentration': concentration,
      'quantity': quantity,
      'price': price,
      'requiresPrescription': requiresPrescription,
      'imageUrl': imageUrl,
      'expiryDate': expiryDate,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      name: map['name'] ?? '',
      concentration: map['concentration'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      requiresPrescription: map['requiresPrescription'] ?? false,
      imageUrl: map['imageUrl'],
      expiryDate: (map['expiryDate'] as DateTime?) ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
    );
  }
}
