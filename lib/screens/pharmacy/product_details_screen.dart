import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/category_helpers.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isInCart(product.id);
    String category = _getCategoryFromName(product.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة أو أيقونة كبيرة
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: getCategoryColor(category).withOpacity(0.3),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Icon(
                getCategoryIcon(category),
                size: 120,
                color: getCategoryColor(category),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم الدواء
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  
                  // التركيز
                  Text(
                    product.concentration,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  
                  // السعر
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('السعر:', style: TextStyle(fontSize: 18)),
                        Text(
                          '${product.price.toStringAsFixed(2)} جنيه',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // شركة الأدوية
                  _buildInfoRow('شركة الأدوية:', product.companyName),
                  SizedBox(height: 12),
                  
                  // الكمية المتاحة
                  _buildInfoRow('الكمية المتاحة:', '${product.quantity} حبة'),
                  SizedBox(height: 12),
                  
                  // تاريخ الصلاحية
                  _buildInfoRow('تاريخ الصلاحية:', _formatDate(product.expiryDate)),
                  SizedBox(height: 12),
                  
                  // يحتاج وصفة
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: product.requiresPrescription ? Colors.orange.shade50 : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          product.requiresPrescription ? Icons.description : Icons.check_circle,
                          color: product.requiresPrescription ? Colors.orange : Colors.green,
                        ),
                        SizedBox(width: 12),
                        Text(
                          product.requiresPrescription ? 'يحتاج وصفة طبية' : 'لا يحتاج وصفة طبية',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // زر الإضافة للسلة
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isInCart) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} موجود بالفعل في السلة')),
                          );
                        } else {
                          cartProvider.addToCart(CartItem.fromProduct(product));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم إضافة ${product.name} إلى السلة'), backgroundColor: Colors.green),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart ? Colors.grey : Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isInCart ? 'المنتج موجود في السلة' : 'أضف إلى السلة',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
