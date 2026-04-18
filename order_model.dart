class OrderModel {
  final String id;
  final String pharmacyId;
  final String pharmacyName;
  final String companyId;
  final String companyName;
  final List<OrderItem> items;
  final double totalPrice;
  final String status; // pending, accepted, rejected, shipped, delivered
  final String? shippingAddress;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.companyId,
    required this.companyName,
    required this.items,
    required this.totalPrice,
    required this.status,
    this.shippingAddress,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'companyId': companyId,
      'companyName': companyName,
      'items': items.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      pharmacyId: map['pharmacyId'] ?? '',
      pharmacyName: map['pharmacyName'] ?? '',
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      items: (map['items'] as List?)?.map((e) => OrderItem.fromMap(e)).toList() ?? [],
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      shippingAddress: map['shippingAddress'],
      createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
      updatedAt: map['updatedAt'],
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}