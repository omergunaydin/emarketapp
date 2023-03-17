import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/models/product.dart';
import 'package:emarketapp/pages/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/dimens/uihelper.dart';
import '../../data/products_api_client.dart';

class ProductSearch extends StatefulWidget {
  ProductSearch({Key? key}) : super(key: key);

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  late TextEditingController _controller;
  late Future _promotionalProductsFuture;
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('anaurunler');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _promotionalProductsFuture = ProductsApiClient().fetchPromotionalProductsData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  setSearchParameters(String name) {
    List<String> searchOptions = [];
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      searchOptions.add(temp);
    }
    return searchOptions;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          SearchTextField(controller: _controller),
          _controller.text.isNotEmpty
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _productsRef.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<DocumentSnapshot> newDocuments = [];
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      for (var document in documents) {
                        if (document['ad'].toString().toLowerCase().contains(_controller.text.toString().toLowerCase())) {
                          newDocuments.add(document);
                        }
                      }
                      int rowCount = (newDocuments.length / 3).ceil();
                      return Container(
                        color: Colors.white,
                        height: rowCount * width / 3 * 1.6 + 100,
                        child: GridView.builder(
                          physics: const ScrollPhysics(), //1 / 1.5
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: width / 3, childAspectRatio: 1 / 1.6, mainAxisSpacing: 5),
                          itemCount: newDocuments.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = newDocuments[index];
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            Product product = Product.fromJson(data);
                            product.id = document.id;
                            return GestureDetector(
                              onTap: () {
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
                                  Padding(
                                    padding: UiHelper.topPadding3x,
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                              ),
                                              child: Padding(
                                                padding: UiHelper.allPadding3x,
                                                child: Image.network(
                                                  product.resim!,
                                                  width: 70,
                                                  height: 70,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return const Center(
                                                      child: CircularProgressIndicator(
                                                        color: UiColorHelper.mainYellow,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            product.indirim != ''
                                                ? Positioned(
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Padding(
                                                      padding: UiHelper.cardTextPadding,
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
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (product.indirim == '1')
                                              Text(
                                                '${product.eskifiyat!.toStringAsFixed(2)}TL',
                                                style: Theme.of(context).textTheme.caption!.copyWith(decoration: TextDecoration.lineThrough, color: Colors.grey),
                                              )
                                            else
                                              const SizedBox.shrink(),
                                            Card(
                                              elevation: 0,
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
                                        Padding(
                                          padding: UiHelper.allPadding1x,
                                          child: Text(
                                            product.ad!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.button,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Material(
                                      borderRadius: UiHelper.borderRadiusCircular6x,
                                      elevation: 1,
                                      child: const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.add,
                                            color: UiColorHelper.mainGreen,
                                            size: 20,
                                          ),
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
                      /*ListView.builder(
                        itemCount: newDocuments.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = newDocuments[index];
                          return ListTile(
                            title: Text(document['ad']),
                            subtitle: Text(document['fiyat'].toString()),
                          );
                        },
                      );*/
                    },
                  ),
                )
              : Expanded(
                  child: FutureBuilder(
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
                          List<Product> productsList = snapshot.data;
                          int rowCount = (productsList.length / 3).ceil();
                          return Container(
                            color: Colors.white,
                            height: rowCount * width / 3 * 1.6 + 100,
                            child: GridView.builder(
                              physics: const ScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: width / 3, childAspectRatio: 1 / 1.6, mainAxisSpacing: 5),
                              itemCount: productsList.length,
                              itemBuilder: (context, index) {
                                Product product = productsList[index];
                                return GestureDetector(
                                  onTap: () {
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
                                      Padding(
                                        padding: UiHelper.topPadding3x,
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                                  ),
                                                  child: Padding(
                                                    padding: UiHelper.allPadding3x,
                                                    child: Image.network(
                                                      product.resim!,
                                                      width: 70,
                                                      height: 70,
                                                      loadingBuilder: (context, child, loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return const Center(
                                                          child: CircularProgressIndicator(
                                                            color: UiColorHelper.mainYellow,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                product.indirim != ''
                                                    ? Positioned(
                                                        left: 0,
                                                        bottom: 0,
                                                        right: 0,
                                                        child: Padding(
                                                          padding: UiHelper.cardTextPadding,
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
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (product.indirim == '1')
                                                  Text(
                                                    '${product.eskifiyat!.toStringAsFixed(2)}TL',
                                                    style: Theme.of(context).textTheme.caption!.copyWith(decoration: TextDecoration.lineThrough, color: Colors.grey),
                                                  )
                                                else
                                                  const SizedBox.shrink(),
                                                Card(
                                                  elevation: 0,
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
                                            Padding(
                                              padding: UiHelper.allPadding1x,
                                              child: Text(
                                                product.ad!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme.button,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 10,
                                        child: Material(
                                          borderRadius: UiHelper.borderRadiusCircular6x,
                                          elevation: 1,
                                          child: const SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.add,
                                                color: UiColorHelper.mainGreen,
                                                size: 20,
                                              ),
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
                      }
                      return Text('data ${snapshot.data}');
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    Key? key,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late bool _clearButtonVisibility;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clearButtonVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: TextField(
        controller: widget._controller,
        onChanged: (text) {
          setState(() {
            if (text.isNotEmpty) {
              _clearButtonVisibility = true;
            } else {
              _clearButtonVisibility = false;
            }
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: widget._controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      widget._controller.text = '';
                      _clearButtonVisibility = false;
                    });
                  },
                )
              : null,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          labelStyle: Theme.of(context).textTheme.subtitle2,
          hintText: 'Ürün Adı veya Marka',
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.grey),
        ),
        cursorColor: UiColorHelper.mainYellow,
      ),
    );
  }
}
