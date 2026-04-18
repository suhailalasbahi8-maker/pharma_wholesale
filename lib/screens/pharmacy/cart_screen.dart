import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/category_helpers.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.items.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('سلة المشتريات'),
              centerTitle: true,
              backgroundColor: Colors.teal,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('السلة فارغة', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('أضف بعض الأدوية من صفحة التصفح', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('سلة المشتريات (${cartProvider.totalQuantity})'),
            centerTitle: true,
            backgroundColor: Colors.teal,
            actions: [
              IconButton(
                icon: Icon(Icons.delete_sweep),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('تفريغ السلة'),
                      content: Text('هل أنت متأكد من تفريغ السلة؟'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
                        TextButton(
                          onPressed: () {
                            cartProvider.clearCart();
                            Navigator.pop(context);
                          },
                          child: Text('تفريغ', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    String category = _getCategoryFromName(item.name);
                    
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: getCategoryColor(category),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(getCategoryIcon(category), color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(item.companyName, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text('${item.price} جنيه', style: TextStyle(color: Colors.teal)),
                                  if (item.requiresPrescription)
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text('يحتاج وصفة', style: TextStyle(fontSize: 10, color: Colors.orange.shade800)),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () => cartProvider.decreaseQuantity(item.id),
                                ),
                                Text('${item.quantity}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () => cartProvider.increaseQuantity(item.id),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.grey),
                                  onPressed: () => cartProvider.removeItem(item.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الإجمالي:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '${cartProvider.totalPrice.toStringAsFixed(2)} جنيه',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم إرسال الطلب بنجاح'), backgroundColor: Colors.green),
                          );
                          cartProvider.clearCart();
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                        child: Text('إتمام الطلب', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
