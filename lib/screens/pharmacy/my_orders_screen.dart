import 'package:flutter/material.dart';

// نموذج الطلب
class Order {
  final String id;
  final String companyName;
  final List<OrderItem> items;
  final double totalPrice;
  final String status; // pending, accepted, rejected, shipped, delivered
  final DateTime date;

  Order({
    required this.id,
    required this.companyName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.date,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// بيانات وهمية للطلبات
List<Order> dummyOrders = [
  Order(
    id: 'ORD-001',
    companyName: 'شركة الأدوية العربية',
    items: [
      OrderItem(name: 'باراسيتامول 500mg', quantity: 10, price: 15.0),
      OrderItem(name: 'إيبوبروفين 400mg', quantity: 5, price: 20.0),
    ],
    totalPrice: 250.0,
    status: 'delivered',
    date: DateTime(2026, 4, 10),
  ),
  Order(
    id: 'ORD-002',
    companyName: 'شركة النيل للأدوية',
    items: [
      OrderItem(name: 'أموكسيسيلين 500mg', quantity: 20, price: 25.0),
      OrderItem(name: 'سيتريزين 10mg', quantity: 15, price: 18.0),
    ],
    totalPrice: 770.0,
    status: 'shipped',
    date: DateTime(2026, 4, 15),
  ),
  Order(
    id: 'ORD-003',
    companyName: 'شركة الصافي',
    items: [
      OrderItem(name: 'فيتامين C 1000mg', quantity: 30, price: 10.0),
      OrderItem(name: 'ديكلوفيناك 50mg', quantity: 8, price: 18.0),
    ],
    totalPrice: 444.0,
    status: 'accepted',
    date: DateTime(2026, 4, 16),
  ),
  Order(
    id: 'ORD-004',
    companyName: 'شركة الحياة',
    items: [
      OrderItem(name: 'فيتامين D3 5000IU', quantity: 12, price: 25.0),
    ],
    totalPrice: 300.0,
    status: 'pending',
    date: DateTime(2026, 4, 17),
  ),
];

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلباتي'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: dummyOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('لا توجد طلبات', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('قم بإتمام طلب من السلة', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: dummyOrders.length,
              itemBuilder: (context, index) {
                final order = dummyOrders[index];
                return OrderCard(order: order);
              },
            ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد المراجعة';
      case 'accepted':
        return 'تم القبول';
      case 'rejected':
        return 'مرفوض';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التسليم';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.home;
      default:
        return Icons.shopping_bag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // رأس البطاقة
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.id,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.order.companyName,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getStatusIcon(widget.order.status), size: 16, color: _getStatusColor(widget.order.status)),
                            SizedBox(width: 4),
                            Text(
                              _getStatusText(widget.order.status),
                              style: TextStyle(fontSize: 12, color: _getStatusColor(widget.order.status)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'التاريخ: ${_formatDate(widget.order.date)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${widget.order.items.length} منتجات',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${widget.order.totalPrice.toStringAsFixed(2)} جنيه',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        _isExpanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // تفاصيل الطلب (تظهر عند التوسيع)
          if (_isExpanded)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المنتجات:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.order.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.order.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.name} × ${item.quantity}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Text(
                              '${(item.price * item.quantity).toStringAsFixed(2)} جنيه',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الإجمالي:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        '${widget.order.totalPrice.toStringAsFixed(2)} جنيه',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                      ),
                    ],
                  ),
                  if (widget.order.status == 'pending')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم إلغاء الطلب'), backgroundColor: Colors.orange),
                            );
                          },
                          style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                          child: Text('إلغاء الطلب', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ),
                  if (widget.order.status == 'shipped')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم تأكيد استلام الطلب'), backgroundColor: Colors.green),
                            );
                          },
                          child: Text('تأكيد الاستلام'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
