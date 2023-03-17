import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/models/carousel.dart';

class CarouselsApiClient {
  final CollectionReference _carouselsRef = FirebaseFirestore.instance.collection('carousel');
  List<Carousel> carouselList = [];

  Future<List<Carousel>> fetchCarouselsData() async => await _carouselsRef.orderBy('dateTime', descending: true).get().then((snapshot) {
        carouselList.clear();
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          var carousel = Carousel.fromJson(data);
          if (carousel.status!) {
            carouselList.add(carousel);
          }
        }
        return carouselList;
      });
}
