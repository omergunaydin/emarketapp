class Product {
  String? ad;
  String? aciklama;
  double? fiyat;
  double? eskifiyat;
  String? indirim;
  bool? kargo;
  String? kat;
  String? kat2;
  String? mensei;
  String? resim;
  String? urunKodu;
  String? marka;
  String? id;
  String? birim;
  double? carpan;

  Product(
      {required this.ad,
      required this.aciklama,
      required this.fiyat,
      required this.indirim,
      required this.kargo,
      required this.kat,
      required this.kat2,
      required this.mensei,
      required this.resim,
      required this.urunKodu,
      required this.marka,
      required this.birim,
      required this.carpan});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ad'] = ad;
    data['açıklama'] = aciklama;
    data['fiyat'] = fiyat;
    data['eskifiyat'] = eskifiyat ?? -1;
    data['indirim'] = indirim;
    data['kargo'] = kargo;
    data['kat'] = kat;
    data['kat2'] = kat2;
    data['menşei'] = mensei;
    data['resim'] = resim;
    data['ürünKodu'] = urunKodu;
    data['marka'] = marka;
    data['birim'] = birim;
    data['carpan'] = carpan;
    return data;
  }

  Product.fromJson(Map<String, dynamic> json) {
    ad = json['ad'];
    aciklama = json['açıklama'];
    fiyat = ((json['fiyat'] as num)).toDouble();
    eskifiyat = (((json['eskifiyat'] ?? -1) as num)).toDouble();
    indirim = json['indirim'];
    kargo = json['kargo'];
    kat = json['kat'];
    kat2 = json['kat2'];
    mensei = json['menşei'];
    resim = json['resim'];
    urunKodu = json['ürünKodu'];
    marka = json['marka'];
    birim = json['birim'];
    carpan = ((json['carpan'] as num)).toDouble();
  }
}
