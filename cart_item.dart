import 'product_model.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String companyName;
  final String concentration;
  final bool requiresPrescription;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.companyName,
    required this.concentration,
    required this.requiresPrescription,
    this.quantity = 1,
  });

  // تحويل من ProductModel إلى CartItem
  factory CartItem.fromProduct(ProductModel product) {
    return CartItem(
      id: product.id,
      name: product.name,
      price: product.price,
      companyName: product.companyName,
      concentration: product.concentration,
      requiresPrescription: product.requiresPrescription,
    );
  }
}