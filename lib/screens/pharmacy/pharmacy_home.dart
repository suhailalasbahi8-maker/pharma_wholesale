import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_screen.dart';
import 'cart_screen.dart';
import 'my_orders_screen.dart';  // أضف هذا
import '../shared/profile_screen.dart';
import '../../providers/cart_provider.dart';

class PharmacyHomeScreen extends StatefulWidget {
  @override
  State<PharmacyHomeScreen> createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends State<PharmacyHomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    ProductsScreen(),
    CartScreen(),
    MyOrdersScreen(),     // أضف هذا
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'تصفح'),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Badge(
                  label: Text('${cart.totalQuantity}'),
                  child: child!,
                );
              },
              child: Icon(Icons.shopping_cart),
            ),
            label: 'السلة',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'طلباتي'),  // أضف هذا
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
