class Carousel {
  String? imageUrl;
  bool? status;
  DateTime? dateTime;
  String? productId;

  Carousel({required this.imageUrl, required this.status, required this.dateTime, required this.productId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['status'] = status;
    data['dateTime'] = dateTime?.millisecondsSinceEpoch;
    data['productId'] = productId;
    return data;
  }

  Carousel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    status = json['status'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(json['dateTime']);
    productId = json['productId'];
  }
}
