import 'package:flutter/material.dart';

// نموذج طلب للشركة
class CompanyOrder {
  final String id;
  final String pharmacyName;
  final List<CompanyOrderItem> items;
  final double totalPrice;
  String status;
  final DateTime date;

  CompanyOrder({
    required this.id,
    required this.pharmacyName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.date,
  });
}

class CompanyOrderItem {
  final String name;
  final int quantity;
  final double price;

  CompanyOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// بيانات وهمية لطلبات الشركة
List<CompanyOrder> dummyCompanyOrders = [
  CompanyOrder(
    id: 'ORD-001',
    pharmacyName: 'صيدلية النور',
    items: [
      CompanyOrderItem(name: 'باراسيتامول 500mg', quantity: 50, price: 15.0),
      CompanyOrderItem(name: 'إيبوبروفين 400mg', quantity: 30, price: 20.0),
    ],
    totalPrice: 1350.0,
    status: 'pending',
    date: DateTime(2026, 4, 17),
  ),
  CompanyOrder(
    id: 'ORD-002',
    pharmacyName: 'صيدلية السلام',
    items: [
      CompanyOrderItem(name: 'أموكسيسيلين 500mg', quantity: 40, price: 25.0),
      CompanyOrderItem(name: 'سيتريزين 10mg', quantity: 25, price: 18.0),
    ],
    totalPrice: 1450.0,
    status: 'accepted',
    date: DateTime(2026, 4, 16),
  ),
  CompanyOrder(
    id: 'ORD-003',
    pharmacyName: 'صيدلية الأمل',
    items: [
      CompanyOrderItem(name: 'فيتامين C 1000mg', quantity: 100, price: 10.0),
      CompanyOrderItem(name: 'فيتامين D3 5000IU', quantity: 50, price: 25.0),
    ],
    totalPrice: 2250.0,
    status: 'shipped',
    date: DateTime(2026, 4, 15),
  ),
];

class CompanyOrdersScreen extends StatefulWidget {
  @override
  State<CompanyOrdersScreen> createState() => _CompanyOrdersScreenState();
}

class _CompanyOrdersScreenState extends State<CompanyOrdersScreen> {
  List<CompanyOrder> orders = dummyCompanyOrders;

  void _updateOrderStatus(String orderId, String newStatus) {
    setState(() {
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index].status = newStatus;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديث حالة الطلب'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات الشراء (${orders.length})'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('لا توجد طلبات', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return CompanyOrderCard(
                  order: order,
                  onStatusUpdate: _updateOrderStatus,
                );
              },
            ),
    );
  }
}

class CompanyOrderCard extends StatefulWidget {
  final CompanyOrder order;
  final Function(String, String) onStatusUpdate;

  const CompanyOrderCard({
    Key? key,
    required this.order,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  State<CompanyOrderCard> createState() => _CompanyOrderCardState();
}

class _CompanyOrderCardState extends State<CompanyOrderCard> {
  bool _isExpanded = false;

  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return 'قيد المراجعة';
      case 'accepted': return 'تم القبول';
      case 'rejected': return 'مرفوض';
      case 'shipped': return 'تم الشحن';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.blue;
      case 'rejected': return Colors.red;
      case 'shipped': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
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
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.order.pharmacyName,
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
                        child: Text(
                          _getStatusText(widget.order.status),
                          style: TextStyle(fontSize: 12, color: _getStatusColor(widget.order.status)),
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
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, size: 20, color: Colors.grey),
                      Text(_isExpanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                            Text('${item.name} × ${item.quantity}', style: TextStyle(fontSize: 14)),
                            Text('${(item.price * item.quantity).toStringAsFixed(2)} جنيه'),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(height: 24),
                  if (widget.order.status == 'pending')
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => widget.onStatusUpdate(widget.order.id, 'rejected'),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                            child: Text('رفض', style: TextStyle(color: Colors.red)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => widget.onStatusUpdate(widget.order.id, 'accepted'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                            child: Text('قبول'),
                          ),
                        ),
                      ],
                    ),
                  if (widget.order.status == 'accepted')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => widget.onStatusUpdate(widget.order.id, 'shipped'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        child: Text('تأكيد الشحن'),
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
