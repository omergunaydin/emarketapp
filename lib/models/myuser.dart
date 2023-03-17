// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyUser {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  bool? userAgreement;
  bool? offers;
  DateTime? createdAt;
  List<Fav>? fav;
  List<CartItem>? cart;
  FaturaBireysel? faturaBireysel;
  FaturaKurumsal? faturaKurumsal;

  MyUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.userAgreement,
      required this.offers,
      required this.createdAt,
      this.fav,
      this.cart,
      this.faturaBireysel,
      this.faturaKurumsal});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; //Map<String, dynamic>()
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['userAgreement'] = userAgreement;
    data['offers'] = offers;
    data['createdAt'] = createdAt?.millisecondsSinceEpoch;
    if (fav != null) {
      data['favs'] = fav!.map((v) => v.toJson()).toList();
    }
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    if (faturaBireysel != null) {
      data['faturabireysel'] = faturaBireysel!.toJson();
    }
    if (faturaKurumsal != null) {
      data['faturakurumsal'] = faturaKurumsal!.toJson();
    }
    return data;
  }

  MyUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    userAgreement = json['userAgreement'];
    offers = json['offers'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
    if (json['favs'] != null) {
      fav = <Fav>[];
      json['favs'].forEach((v) {
        fav!.add(Fav.fromJson(v));
      });
    }

    if (json['cart'] != null) {
      cart = <CartItem>[];
      json['cart'].forEach((v) {
        cart!.add(CartItem.fromJson(v));
      });
    }

    if (json['faturabireysel'] != null) {
      faturaBireysel = FaturaBireysel.fromJson(json['faturabireysel']);
    }

    if (json['faturakurumsal'] != null) {
      faturaKurumsal = FaturaKurumsal.fromJson(json['faturakurumsal']);
    }
  }

  MyUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    bool? userAgreement,
    bool? offers,
    DateTime? createdAt,
    List<Fav>? fav,
    List<CartItem>? cart,
    FaturaBireysel? faturaBireysel,
    FaturaKurumsal? faturaKurumsal,
  }) {
    return MyUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userAgreement: userAgreement ?? this.userAgreement,
      offers: offers ?? this.offers,
      createdAt: createdAt ?? this.createdAt,
      fav: fav ?? this.fav,
      cart: cart ?? this.cart,
      faturaBireysel: faturaBireysel ?? this.faturaBireysel,
      faturaKurumsal: faturaKurumsal ?? this.faturaKurumsal,
    );
  }
}

class Fav {
  String? id;
  String? name;
  String? resim;

  Fav({this.id, this.name, this.resim});

  Fav.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    resim = json['resim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['resim'] = resim;
    return data;
  }
}

class CartItem {
  String? id;
  String? ad;
  String? resim;
  double? fiyat;
  double? eskifiyat;
  String? indirim;
  String? birim;
  double? carpan;
  String? durum;

  CartItem({required this.id, required this.ad, required this.resim, required this.fiyat, required this.eskifiyat, required this.indirim, required this.birim, required this.carpan, this.durum});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ad = json['ad'];
    resim = json['resim'];
    fiyat = ((json['fiyat'] as num)).toDouble();
    eskifiyat = (((json['eskifiyat'] ?? -1) as num)).toDouble();
    indirim = json['indirim'];
    birim = json['birim'];
    carpan = ((json['carpan'] as num)).toDouble();
    durum = json['durum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ad'] = ad;
    data['resim'] = resim;
    data['fiyat'] = fiyat;
    data['eskifiyat'] = eskifiyat ?? -1;
    data['indirim'] = indirim;
    data['birim'] = birim;
    data['carpan'] = carpan;
    data['durum'] = durum;
    return data;
  }
}

class FaturaBireysel {
  String? faturaUnvan;
  String? tcKimlikNo;
  String? adres;
  String? il;
  String? ilce;

  FaturaBireysel({this.faturaUnvan, this.tcKimlikNo, this.adres, this.il, this.ilce});

  FaturaBireysel.fromJson(Map<String, dynamic> json) {
    faturaUnvan = json['faturaUnvan'];
    tcKimlikNo = json['tcKimlikNo'];
    adres = json['adres'];
    il = json['il'];
    ilce = json['ilce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['faturaUnvan'] = faturaUnvan;
    data['tcKimlikNo'] = tcKimlikNo;
    data['adres'] = adres;
    data['il'] = il;
    data['ilce'] = ilce;
    return data;
  }
}

class FaturaKurumsal {
  String? faturaUnvan;
  String? vergiDairesi;
  String? vergiNumarasi;
  String? adres;
  String? il;
  String? ilce;

  FaturaKurumsal({this.faturaUnvan, this.vergiDairesi, this.vergiNumarasi, this.adres, this.il, this.ilce});

  FaturaKurumsal.fromJson(Map<String, dynamic> json) {
    faturaUnvan = json['faturaUnvan'];
    vergiDairesi = json['vergiDairesi'];
    vergiNumarasi = json['vergiNumarasi'];
    adres = json['adres'];
    il = json['il'];
    ilce = json['ilce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['faturaUnvan'] = faturaUnvan;
    data['vergiDairesi'] = vergiDairesi;
    data['vergiNumarasi'] = vergiNumarasi;
    data['adres'] = adres;
    data['il'] = il;
    data['ilce'] = ilce;
    return data;
  }
}
