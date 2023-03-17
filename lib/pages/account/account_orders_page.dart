import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/data/orders_api_client.dart';
import 'package:emarketapp/pages/account/account_order_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/values/colors.dart';
import '../../models/myorder.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../models/myuser.dart';

class AccountOrdersPage extends StatefulWidget {
  AccountOrdersPage({Key? key}) : super(key: key);

  @override
  State<AccountOrdersPage> createState() => _AccountOrdersPageState();
}

class _AccountOrdersPageState extends State<AccountOrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Siparişlerim',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Material(
            color: UiColorHelper.mainYellow.withAlpha(100),
            child: TabBar(
              onTap: (value) {
                _tabController.index = value;
                _pageController.animateToPage(value, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
              },
              controller: _tabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              tabs: [
                Tab(child: Text('Aktif Siparişlerim', style: textTheme.button!.copyWith(fontWeight: FontWeight.bold))),
                Tab(child: Text('Geçmiş Siparişlerim', style: textTheme.button!.copyWith(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [PageActiveOrders(), PagePastOrders()],
              onPageChanged: (index) {
                _tabController.animateTo(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PageActiveOrders extends StatefulWidget {
  PageActiveOrders({Key? key}) : super(key: key);

  @override
  State<PageActiveOrders> createState() => _PageActiveOrdersState();
}

class _PageActiveOrdersState extends State<PageActiveOrders> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  List<MyOrder> ordersList = [];

  @override
  void initState() {
    initLocale();
    getActiveOrders();
    super.initState();
  }

  initLocale() async {
    await initializeDateFormatting('tr_TR', null);
  }

  getActiveOrders() async {
    List<MyOrder> getList = await OrdersApiClient().fetchOrdersData(mAuth.currentUser!.uid);
    for (var order in getList) {
      if (order.deliveryState == 'Preparing') {
        print('true');
        ordersList.add(order);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return
        //LİSTE BOŞSA ????
        ordersList.isNotEmpty
            ? ListView.separated(
                itemCount: ordersList.length,
                itemBuilder: (context, index) {
                  MyOrder order = ordersList[index];
                  DateFormat dateFormat = DateFormat('dd MMMM y EEEE HH:mm', 'tr_TR');
                  return Container(
                    color: Colors.white,
                    padding: UiHelper.allPadding3x,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dateFormat.format(order.orderDateTime!),
                              style: textTheme.button!.copyWith(color: UiColorHelper.mainBlue),
                            ),
                            const Spacer(),
                            Text(
                              '${order.cartTotal!.toStringAsFixed(2)} TL',
                              style: textTheme.subtitle2!.copyWith(color: UiColorHelper.mainRed),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.chevron_right, size: 16)
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(MdiIcons.bicycle, size: 16),
                            const SizedBox(width: 10),
                            Text(
                              order.deliveryType!,
                              style: textTheme.button!.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              MdiIcons.navigationOutline,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Text(order.deliveryAddress!),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: order.cart!.length > 8 ? 8 : order.cart!.length,
                                itemBuilder: (context, index) {
                                  CartItem cartItem = order.cart![index];
                                  return Center(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          cartItem.resim!,
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
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${order.cart!.length} Ürün',
                              style: textTheme.button!.copyWith(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        Container(
                          color: UiColorHelper.mainBlue,
                          padding: UiHelper.allPadding2x,
                          child: Text(
                            'Siparişiniz Hazırlanıyor',
                            style: textTheme.button!.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(color: Colors.white, child: const Divider(height: 0, thickness: 1));
                })
            : SizedBox(
                width: width,
                height: height * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(MdiIcons.cartOff, size: 30),
                    SizedBox(height: 20),
                    Text('Henüz Siparişiniz bulunmuyor. Max Market ile hemen avantajlı alışverişe başlayıpi fırsatları kaçırmayın.', textAlign: TextAlign.center),
                  ],
                ),
              );
  }
}

class PagePastOrders extends StatefulWidget {
  PagePastOrders({Key? key}) : super(key: key);

  @override
  State<PagePastOrders> createState() => _PagePastOrdersState();
}

class _PagePastOrdersState extends State<PagePastOrders> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  List<MyOrder> ordersList = [];

  @override
  void initState() {
    initLocale();
    getPastOrders();
    super.initState();
  }

  initLocale() async {
    await initializeDateFormatting('tr_TR', null);
  }

  getPastOrders() async {
    List<MyOrder> getList = await OrdersApiClient().fetchOrdersData(mAuth.currentUser!.uid);
    for (var order in getList) {
      if (order.deliveryState == 'Done' || order.deliveryState == 'Canceled') {
        print('true');
        ordersList.add(order);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return
        //LİSTE BOŞSA ????
        ordersList.isNotEmpty
            ? ListView.separated(
                itemCount: ordersList.length,
                itemBuilder: (context, index) {
                  MyOrder order = ordersList[index];
                  DateFormat dateFormat = DateFormat('dd MMMM y EEEE HH:mm', 'tr_TR');
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountOrderDetailPage(order: order)));
                    },
                    child: Container(
                      color: Colors.white,
                      padding: UiHelper.allPadding3x,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dateFormat.format(order.orderDateTime!),
                                style: textTheme.button!.copyWith(color: UiColorHelper.mainBlue),
                              ),
                              const Spacer(),
                              Text(
                                '${order.cartTotal!.toStringAsFixed(2)} TL',
                                style: textTheme.subtitle2!.copyWith(color: UiColorHelper.mainRed),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.chevron_right, size: 16)
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(MdiIcons.bicycle, size: 16),
                              const SizedBox(width: 10),
                              Text(
                                order.deliveryType!,
                                style: textTheme.button!.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                MdiIcons.navigationOutline,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Text(order.deliveryAddress!),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: order.cart!.length > 8 ? 8 : order.cart!.length,
                                  itemBuilder: (context, index) {
                                    CartItem cartItem = order.cart![index];
                                    return Center(
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            cartItem.resim!,
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
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${order.cart!.length} Ürün',
                                style: textTheme.button!.copyWith(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          order.deliveryState == 'Done'
                              ? Container(
                                  color: UiColorHelper.mainGreen,
                                  padding: UiHelper.allPadding2x,
                                  child: Text(
                                    'Sipariş Teslim Edildi',
                                    style: textTheme.button!.copyWith(color: Colors.white),
                                  ),
                                )
                              : Container(
                                  color: UiColorHelper.mainRed,
                                  padding: UiHelper.allPadding2x,
                                  child: Text(
                                    'Sipariş İptal Edildi',
                                    style: textTheme.button!.copyWith(color: Colors.white),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(color: Colors.white, child: const Divider(height: 0, thickness: 1));
                })
            : SizedBox(
                width: width,
                height: height * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(MdiIcons.cartOff, size: 30),
                    SizedBox(height: 20),
                    Text('Henüz Siparişiniz bulunmuyor. Max Market ile hemen avantajlı alışverişe başlayıpi fırsatları kaçırmayın.', textAlign: TextAlign.center),
                  ],
                ),
              );
  }
}
