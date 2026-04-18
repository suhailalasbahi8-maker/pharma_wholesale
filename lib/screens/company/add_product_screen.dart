import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/dummy_products.dart';
import '../../widgets/category_helpers.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _concentrationController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  
  bool _requiresPrescription = false;
  DateTime? _expiryDate;
  bool _isLoading = false;

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1825)),
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  void _addProduct() {
    if (!_formKey.currentState!.validate()) return;
    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار تاريخ الصلاحية'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    // إنشاء منتج جديد
    final newProduct = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      companyId: 'comp_001',
      companyName: 'شركة الأدوية العربية',
      name: _nameController.text.trim(),
      concentration: _concentrationController.text.trim(),
      quantity: int.parse(_quantityController.text),
      price: double.parse(_priceController.text),
      requiresPrescription: _requiresPrescription,
      imageUrl: null,
      expiryDate: _expiryDate!,
      isActive: true,
      createdAt: DateTime.now(),
    );

    // إضافة إلى القائمة (بيانات وهمية)
    dummyProducts.add(newProduct);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إضافة المنتج بنجاح'), backgroundColor: Colors.green),
    );

    // تنظيف الحقول
    _nameController.clear();
    _concentrationController.clear();
    _quantityController.clear();
    _priceController.clear();
    setState(() {
      _requiresPrescription = false;
      _expiryDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة دواء جديد'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم الدواء
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم الدواء',
                  prefixIcon: Icon(Icons.medication),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'أدخل اسم الدواء' : null,
              ),
              SizedBox(height: 16),
              
              // التركيز
              TextFormField(
                controller: _concentrationController,
                decoration: InputDecoration(
                  labelText: 'التركيز (مثال: 500mg)',
                  prefixIcon: Icon(Icons.science),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'أدخل التركيز' : null,
              ),
              SizedBox(height: 16),
              
              // الكمية
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'الكمية المتاحة',
                  prefixIcon: Icon(Icons.inventory),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'أدخل الكمية' : null,
              ),
              SizedBox(height: 16),
              
              // السعر
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'سعر الجملة (جنيه)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'أدخل السعر' : null,
              ),
              SizedBox(height: 16),
              
              // تاريخ الصلاحية
              InkWell(
                onTap: _selectExpiryDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.teal),
                      SizedBox(width: 12),
                      Text(
                        _expiryDate == null
                            ? 'اختر تاريخ الصلاحية'
                            : 'تاريخ الصلاحية: ${_expiryDate!.year}-${_expiryDate!.month}-${_expiryDate!.day}',
                        style: TextStyle(
                          color: _expiryDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // يحتاج وصفة
              SwitchListTile(
                title: Text('يحتاج وصفة طبية'),
                subtitle: Text('تحديد إذا كان هذا الدواء يحتاج وصفة من الطبيب'),
                value: _requiresPrescription,
                onChanged: (value) => setState(() => _requiresPrescription = value),
                activeColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 24),
              
              // زر الإضافة
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('إضافة المنتج', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
