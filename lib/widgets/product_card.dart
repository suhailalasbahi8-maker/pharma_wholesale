import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'category_helpers.dart';
import '../screens/pharmacy/product_details_screen.dart';  // أضف هذا الاستيراد

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isInCart;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isInCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    String category = _getCategoryFromName(product.name);
    
    return GestureDetector(
      onTap: () {
        // الانتقال إلى شاشة التفاصيل
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: getCategoryColor(category),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Stack(
                  children: [
                    Icon(getCategoryIcon(category), size: 50, color: Colors.white),
                    if (product.requiresPrescription)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('وصفة', style: TextStyle(fontSize: 10, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      product.concentration,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                    ),
                    SizedBox(height: 2),
                    Text(
                      product.companyName,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${product.price} جنيه',
                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'المتبقي: ${product.quantity}',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isInCart) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.name} موجود بالفعل في السلة')),
                            );
                          } else {
                            cartProvider.addToCart(CartItem.fromProduct(product));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم إضافة ${product.name} إلى السلة')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          minimumSize: Size(0, 32),
                          backgroundColor: isInCart ? Colors.grey : Colors.teal,
                        ),
                        child: Text(isInCart ? 'موجود' : 'أضف للسلة', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryFromName(String name) {
    if (name.contains('باراسيتامول') || name.contains('إيبوبروفين') || name.contains('ديكلوفيناك')) {
      return 'مسكنات';
    } else if (name.contains('أموكسيسيلين') || name.contains('أزيثروميسين')) {
      return 'مضادات حيوية';
    } else if (name.contains('فيتامين')) {
      return 'فيتامينات';
    } else if (name.contains('سيتريزين')) {
      return 'حساسية';
    } else {
      return 'أدوية';
    }
  }
}
