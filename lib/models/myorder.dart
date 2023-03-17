import 'myuser.dart';

class MyOrder {
  String? id;
  String? userid;
  String? deliveryState;
  String? deliveryType;
  String? deliveryAddress;
  String? deliveryDate;
  String? deliveryTime;
  String? deliveryNote;
  List<CartItem>? cart;
  double? cartTotal;
  DateTime? orderDateTime;
  String? faturaTuru;
  FaturaBireysel? faturaBireysel;
  FaturaKurumsal? faturaKurumsal;

  MyOrder({
    this.id,
    required this.userid,
    required this.deliveryState,
    required this.deliveryType,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveryNote,
    required this.cart,
    required this.cartTotal,
    required this.orderDateTime,
    this.faturaTuru,
    this.faturaBireysel,
    this.faturaKurumsal,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; //Map<String, dynamic>()
    data['id'] = id;
    data['userid'] = userid;
    data['deliveryState'] = deliveryState;
    data['deliveryType'] = deliveryType;
    data['deliveryAddress'] = deliveryAddress;
    data['deliveryDate'] = deliveryDate;
    data['deliveryTime'] = deliveryTime;
    data['deliveryNote'] = deliveryNote;
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    data['cartTotal'] = cartTotal;
    data['faturaTuru'] = faturaTuru;
    data['orderDateTime'] = orderDateTime?.millisecondsSinceEpoch;
    if (faturaBireysel != null) {
      data['faturabireysel'] = faturaBireysel!.toJson();
    }
    if (faturaKurumsal != null) {
      data['faturakurumsal'] = faturaKurumsal!.toJson();
    }
    return data;
  }

  MyOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    deliveryState = json['deliveryState'];
    deliveryType = json['deliveryType'];
    deliveryAddress = json['deliveryAddress'];
    deliveryDate = json['deliveryDate'];
    deliveryTime = json['deliveryTime'];
    deliveryNote = json['deliveryNote'];
    if (json['cart'] != null) {
      cart = <CartItem>[];
      json['cart'].forEach((v) {
        cart!.add(CartItem.fromJson(v));
      });
    }
    cartTotal = json['cartTotal'];
    faturaTuru = json['faturaTuru'];
    orderDateTime = DateTime.fromMillisecondsSinceEpoch(json['orderDateTime']);
    if (json['faturabireysel'] != null) {
      faturaBireysel = FaturaBireysel.fromJson(json['faturabireysel']);
    }

    if (json['faturakurumsal'] != null) {
      faturaKurumsal = FaturaKurumsal.fromJson(json['faturakurumsal']);
    }
  }
}
