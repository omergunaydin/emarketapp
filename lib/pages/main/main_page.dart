import 'package:carousel_slider/carousel_slider.dart';
import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/data/carousels_api_client.dart';
import 'package:emarketapp/data/products_api_client.dart';
import 'package:emarketapp/models/carousel.dart';
import 'package:emarketapp/models/product.dart';
import 'package:emarketapp/widgets/carousel_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../product/product_details.dart';

class MainPage extends StatefulWidget {
  Function function;
  Function function2;
  MainPage({Key? key, required this.function, required this.function2}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {
  late Future _carouselFuture;
  late Future _promotionalProductsFuture;
  int switchPage = 0;

  @override
  void initState() {
    super.initState();
    _carouselFuture = CarouselsApiClient().fetchCarouselsData();
    _promotionalProductsFuture = ProductsApiClient().fetchPromotionalProductsData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          carouselBuilder(height, width),
          const DeliveryInformationsWidget(),
          promotionalProductsBuilder(context, width),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: UiHelper.allPadding3x,
                  child: Text(
                    'Kategoriler',
                    style: Theme.of(context).textTheme.button!.copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: UiHelper.bottomPadding5x,
                  child: GridView.builder(
                    physics: const ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: width / 3, mainAxisSpacing: 10),
                    itemCount: 19,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index == 0) {
                            //Haftanın Fırsatları
                            //Ayrıca tasarlanacak!
                          } else if (index == 1) {
                            //Kargo Teslimatlı Ürünler
                            //Ayrıca tasarlanacak!
                          } else if (index <= 5) {
                            //Demo app için index 5'e kadar yapıldı!
                            /*Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductListTabs(
                                  initialIndex: index - 2,
                                ),
                              ),
                            );*/
                            setState(() {
                              switchPage = 1;
                            });
                            widget.function(5);
                            widget.function2(index - 2);
                          }
                        },
                        child: Center(
                          child: ClipRRect(
                            borderRadius: UiHelper.borderRadiusCircular2x,
                            child: Image.asset("assets/images/cat${index + 1}.png"),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  promotionalProductsBuilder(BuildContext context, double width) {
    return Column(
      children: [
        Padding(
          padding: UiHelper.allPadding3x,
          child: Row(
            children: [
              Text(
                'Bunları Kaçırmayın',
                style: Theme.of(context).textTheme.button!.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  widget.function(1);
                },
                child: Text(
                  'Tüm Ürünler',
                  style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: _promotionalProductsFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(color: UiColorHelper.mainYellow),
                  ),
                );
              case ConnectionState.done:
                List<Product> productList = snapshot.data;
                return SizedBox(
                  width: width,
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      var product = productList[index];
                      return GestureDetector(
                        onTap: () {
                          print(product.id);
                          debugPrint('tıklandı ${product.id}');
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: ProductDetails(product: product),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: width / 100 * 75,
                              height: 150,
                              child: Card(
                                elevation: 1.5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: UiHelper.borderRadiusCircular2x,
                                ),
                                margin: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                          product.resim!,
                                          width: width / 100 * 25,
                                          height: width / 100 * 25,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: UiColorHelper.mainYellow,
                                              ),
                                            );
                                          },
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 10,
                                          right: 10,
                                          child: SizedBox(
                                            width: width / 100 * 20,
                                            child: Card(
                                              elevation: 0,
                                              color: product.indirim == '1' ? UiColorHelper.mainYellow : UiColorHelper.mainBlue,
                                              child: Padding(
                                                padding: UiHelper.allPadding1x,
                                                child: Text(
                                                  product.indirim == '1' ? '25 TL üzeri\nindirimli' : 'İkincisi Bedava',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.overline!.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: product.indirim == '1' ? Colors.black : Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.ad!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.button,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                product.indirim != '2'
                                                    ? Text(
                                                        '${product.eskifiyat!.toStringAsFixed(2)}TL',
                                                        style: Theme.of(context).textTheme.caption!.copyWith(decoration: TextDecoration.lineThrough, color: Colors.grey),
                                                      )
                                                    : const SizedBox.shrink(),
                                                Card(
                                                  elevation: 1,
                                                  color: UiColorHelper.mainYellow,
                                                  child: Padding(
                                                    padding: UiHelper.allPadding1x,
                                                    child: Text(
                                                      '${product.fiyat!.toStringAsFixed(2)} TL',
                                                      style: Theme.of(context).textTheme.button!.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            color: UiColorHelper.mainRed,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Material(
                                borderRadius: UiHelper.borderRadiusCircular6x,
                                elevation: 2,
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.add,
                                    color: UiColorHelper.mainGreen,
                                    size: 28,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );

              default:
                return SizedBox(
                  height: 200,
                  width: width,
                );
            }
          },
        )
      ],
    );
  }

  FutureBuilder<dynamic> carouselBuilder(double height, double width) {
    return FutureBuilder(
      future: _carouselFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CarouselShimmer(height: height, width: width);
          case ConnectionState.done:
            List<Carousel> carouselList = snapshot.data;
            return CarouselSlider(
              options: CarouselOptions(height: 200, viewportFraction: 1, autoPlay: true, disableCenter: true),
              items: carouselList.map((carousel) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () async {
                        Product? product = await ProductsApiClient().getProductById(carousel.productId!);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: ProductDetails(product: product!),
                          ),
                        );
                      },
                      child: Image.network(
                        carousel.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: UiColorHelper.mainYellow,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            );

          default:
            return SizedBox(
              height: 200,
              width: width,
            );
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class DeliveryInformationsWidget extends StatelessWidget {
  const DeliveryInformationsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: UiHelper.allPadding2x,
            child: Row(
              children: [
                const Icon(
                  Icons.navigation_outlined,
                  color: Colors.black,
                  size: 16,
                ),
                Padding(
                  padding: UiHelper.leftPadding1x,
                  child: Text('Ev Adresim', style: textTheme.button!),
                ),
                Expanded(
                  child: Padding(
                    padding: UiHelper.leftPadding1x,
                    child: Text(
                      'Sanayi Cad. 3C Fatih Mah. Deniz Sok. No:45 Beşikdüzü/Trabzon',
                      style: textTheme.button!.copyWith(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                //Spacer(),
                const Icon(Icons.navigate_next, size: 16),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: UiHelper.allPadding2x,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              MdiIcons.bicycle,
                              size: 14,
                            ),
                            Padding(
                              padding: UiHelper.leftPadding1x,
                              child: Text(
                                'Adrese Teslim',
                                style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Min Sepet',
                                  style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
                                ),
                                Text(
                                  '80,00',
                                  style: Theme.of(context).textTheme.caption!.copyWith(color: UiColorHelper.mainBlue),
                                ),
                              ],
                            ),
                            Padding(
                              padding: UiHelper.leftPadding2x,
                              child: Column(
                                children: [
                                  Text(
                                    'Gönderim',
                                    style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    '0,00',
                                    style: Theme.of(context).textTheme.caption!.copyWith(color: UiColorHelper.mainBlue),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: UiHelper.allPadding2x,
                              child: Column(
                                children: [
                                  Text(
                                    'Nasıl Çalışır?',
                                    style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    '80,00',
                                    style: Theme.of(context).textTheme.caption!.copyWith(color: UiColorHelper.mainBlue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ////
                  ///
                  const Padding(
                    padding: UiHelper.verticalSymmetricPadding1x,
                    child: VerticalDivider(),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              MdiIcons.storefront,
                              size: 14,
                            ),
                            Padding(
                              padding: UiHelper.leftPadding1x,
                              child: Text(
                                'Marketten Gel Al',
                                style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: UiHelper.verticalSymmetricPadding2x,
                          child: Column(
                            children: [
                              Text(
                                'Min Sepet',
                                style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
                              ),
                              Text(
                                '80,00',
                                style: Theme.of(context).textTheme.caption!.copyWith(color: UiColorHelper.mainBlue),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
