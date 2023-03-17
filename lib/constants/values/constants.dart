import 'package:emarketapp/data/products_api_client.dart';

class ConstValues {
  static const String loginDialogText =
      'Max Market\'te alışverişe devam etmek için öncelikle üye girişi yapmalısınız. Üye değilseniz sadece bir kaç adımda üyeliğinizi kolaylıkla oluşturabilirsiniz. ';

  final mainTabs = [
    'Meyve & Sebze',
    'Et & Tavuk & Şarküteri',
    'Süt & Süt Ürünleri',
    'Kahvaltılık',
  ];

  List<List<String>> listOfTabList = [
    [
      'Patates, Soğan, Sarımsak',
      'Sebzeler',
      'Meyveler',
      'Narenciye',
      'Salata Malzemeleri',
      'Kurutulmuş Meyve & Sebze',
      'Kabuklu Sert Meyveler',
      'Dondurulmuş Meyve & Sebze',
    ],
    [
      'Kırmızı Et',
      'Tavuk',
      'Hindi',
      'Yumurta',
      'Sucuk',
      'Sosis & Salam & Füme Et',
      'Pastırma & Kavurma',
      'Sakatat',
      'Balık Konservesi',
      'Dondurulmuş Et & Balık',
    ],
    [
      'Süt',
      'Yoğurt',
      'Ayran & Kefir',
      'Beyaz Peynir',
      'Krem Peynir',
      'Kaşar Peyniri',
      'Yöresel Gurme Peynir',
      'Kaymak & Krema',
      'Tereyağ & Margarin',
      'Maya',
      'Probiyotik & Protein Ürünleri',
      'Tatlı & Puding',
      'Çocuk Ürünleri',
    ],
    [
      'Patates, Soğan, Sarımsak',
      'Sebzeler',
      'Meyveler',
      'Narenciye',
      'Salata Malzemeleri',
      'Kurutulmuş Meyve & Sebze',
      'Kabuklu Sert Meyveler',
      'Dondurulmuş Meyve & Sebze',
    ]
  ];

  getFutureList(List<String> mainTabs, List<List<String>> listOfTabList) {
    List<List<Future>> futureList = [];
    for (int i = 0; i < mainTabs.length; i++) {
      List<Future> list = List.generate(listOfTabList[i].length, (j) => ProductsApiClient().fetchProductsData(mainTabs[i], listOfTabList[i][j]));
      futureList.add(list);
    }
    return futureList;
  }
}
