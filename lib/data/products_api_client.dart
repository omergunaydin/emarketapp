import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/models/product.dart';

class ProductsApiClient {
  final CollectionReference _promotionalProductsRef = FirebaseFirestore.instance.collection('kampanyalıurunler');
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('anaurunler');

  List<Product> productList = [];

  Future<Product?> getProductById(String id) async {
    DocumentReference productRef = _productsRef.doc(id);
    DocumentSnapshot productSnapshot = await productRef.get();
    if (productSnapshot.exists) {
      Product product = Product.fromJson(productSnapshot.data() as Map<String, dynamic>);
      product.id = id;
      return product;
    } else {
      return null;
    }
  }

  Future<List<Product>> fetchProductsData(String cat, String subCat) async => await _productsRef.where('kat', isEqualTo: cat).where('kat2', isEqualTo: subCat).get().then((snapshot) {
        productList.clear();
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Product product = Product.fromJson(data);
          product.id = document.id;
          productList.add(product);
        }
        return productList;
      });

  Future<List<Product>> fetchPromotionalProductsData() async => await _productsRef.where('indirim', isNotEqualTo: '').orderBy('indirim', descending: true).orderBy('ad').get().then((snapshot) {
        productList.clear();
        int i = 0;
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Product product = Product.fromJson(data);
          product.id = document.id;
          productList.add(product);
          i++;
        }
        print('sayııısı $i');
        return productList;
      });

  Future<List<Product>> searchProductsData(String searchText) async => await _productsRef.where('ad', isGreaterThanOrEqualTo: searchText).orderBy('ad').get().then((snapshot) {
        productList.clear();
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Product product = Product.fromJson(data);
          product.id = document.id;
          productList.add(product);
        }
        return productList;
      });
}
