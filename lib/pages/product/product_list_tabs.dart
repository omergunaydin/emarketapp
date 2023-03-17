import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/constants/values/constants.dart';
import 'package:emarketapp/models/product.dart';
import 'package:emarketapp/pages/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class ProductListTabs extends StatefulWidget {
  int initialIndex;

  ProductListTabs({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<ProductListTabs> createState() => _ProductListTabsState();
}

class _ProductListTabsState extends State<ProductListTabs> with SingleTickerProviderStateMixin {
  ConstValues constants = ConstValues();
  late final TabController _tabController;
  late final List<List<Future>> _futuresList;

  @override
  void initState() {
    super.initState();
    //TODO:bu sayfaya ana sayfadan gelirken initialIndex değeri kategori seçimine göre gelecek!
    _tabController = TabController(length: constants.mainTabs.length, vsync: this, initialIndex: widget.initialIndex);
    _futuresList = ConstValues().getFutureList(constants.mainTabs, constants.listOfTabList);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: UiColorHelper.tabYellow,
            child: TabBar(
              onTap: (value) {
                _tabController.index = value;
              },
              controller: _tabController,
              isScrollable: true,
              indicatorColor: UiColorHelper.tabIndicatorColor,
              tabs: [
                ...constants.mainTabs.map(
                  (label) => Tab(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProductList(tabsList: constants.listOfTabList[0], futuresList: _futuresList[0]),
                ProductList(tabsList: constants.listOfTabList[1], futuresList: _futuresList[1]),
                ProductList(tabsList: constants.listOfTabList[2], futuresList: _futuresList[2]),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text('Demo App - No Content!'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  List<Future> futuresList;
  List<String> tabsList;

  ProductList({Key? key, required this.tabsList, required this.futuresList}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> with AutomaticKeepAliveClientMixin {
  late List<int> indexList;

  @override
  void initState() {
    super.initState();
    indexList = List.generate(widget.tabsList.length, (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return ScrollableListTabView(
      tabHeight: 45,
      tabs: [
        ...indexList.map(
          (index) => ScrollableListTab(
            tab: ListTab(
              activeBackgroundColor: UiColorHelper.mainBlue,
              label: Text(widget.tabsList[index]),
              borderRadius: UiHelper.borderRadiusCircular6x,
            ),
            body: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FutureBuilder(
                  future: widget.futuresList[index],
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
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: width / 3, childAspectRatio: 1 / 1.6, mainAxisSpacing: 0),
                            itemCount: productsList.length,
                            itemBuilder: (context, index) {
                              Product product = productsList[index];
                              return GestureDetector(
                                onTap: () {
                                  debugPrint('tıklandı ${product.id}');
                                  debugPrint(product.carpan.toString());
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
                                                      return const SizedBox(
                                                        width: 70,
                                                        height: 70,
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            color: UiColorHelper.mainYellow,
                                                          ),
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
                                    // Add Icon
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
                      default:
                    }
                    return Text('data ${snapshot.data}');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
