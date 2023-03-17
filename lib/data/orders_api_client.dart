import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/models/myorder.dart';

class OrdersApiClient {
  final CollectionReference _ordersRef = FirebaseFirestore.instance.collection('orders');
  List<MyOrder> ordersList = [];

  Future<bool> addOrder(MyOrder order) async {
    try {
      final docMyOrder = _ordersRef.doc(order.id);
      order.id = docMyOrder.id;
      final json = order.toJson();
      await docMyOrder.set(json);

      return true;
    } catch (e) {
      print('Error adding order: $e');
      return false;
    }
  }

  Future<List<MyOrder>> fetchOrdersData(String userId) async => await _ordersRef.where('userid', isEqualTo: userId).orderBy('orderDateTime', descending: true).get().then((snapshot) {
        ordersList.clear();
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          MyOrder order = MyOrder.fromJson(data);
          order.id = document.id;
          ordersList.add(order);
        }
        return ordersList;
      });
}
