import 'package:flutter/material.dart';
import 'my_products_screen.dart';
import 'add_product_screen.dart';
import 'company_orders_screen.dart';
import '../shared/profile_screen.dart';

class CompanyHomeScreen extends StatefulWidget {
  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    MyProductsScreen(),
    CompanyOrdersScreen(),
    AddProductScreen(),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'منتجاتي'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'الطلبات'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'إضافة دواء'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}