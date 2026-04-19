import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب جميع المنتجات النشطة
  Stream<List<ProductModel>> getProducts() {
    return _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ProductModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  // جلب منتجات شركة معينة
  Stream<List<ProductModel>> getProductsByCompany(String companyId) {
    return _firestore
        .collection('products')
        .where('companyId', isEqualTo: companyId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ProductModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  // إضافة منتج جديد
  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  // تحديث منتج
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _firestore.collection('products').doc(id).update(data);
  }

  // حذف منتج (تعطيله)
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).update({'isActive': false});
  }
}
