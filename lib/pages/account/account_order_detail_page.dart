import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/myorder.dart';
import '../../models/myuser.dart';

class AccountOrderDetailPage extends StatefulWidget {
  MyOrder order;
  AccountOrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  State<AccountOrderDetailPage> createState() => _AccountOrderDetailPageState();
}

class _AccountOrderDetailPageState extends State<AccountOrderDetailPage> {
  late MyOrder order;
  List<CartItem> notItemsList = [];
  List<CartItem> itemsList = [];
  double itemsListTotal = 0;
  double discountTotal = 0;
  double notItemsListTotal = 0;

  @override
  void initState() {
    super.initState();
    createListsAndCalculateTotalsDiscounts();
  }

  createListsAndCalculateTotalsDiscounts() {
    order = widget.order;
    for (int i = 0; i < order.cart!.length; i++) {
      if (order.cart![i].durum == 'yok') {
        notItemsList.add(order.cart![i]);
      } else {
        itemsList.add(order.cart![i]);
      }
      if (order.cart![i].eskifiyat != -1) {
        discountTotal += (order.cart![i].eskifiyat! - order.cart![i].fiyat!) * order.cart![i].carpan!;
      }
      if (order.cart![i].indirim == '2') {
        discountTotal += order.cart![i].fiyat!;
      }
    }

    for (var item in itemsList) {
      itemsListTotal += item.fiyat! * item.carpan!;
    }
    for (var item in notItemsList) {
      notItemsListTotal += item.fiyat! * item.carpan!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sipariş Özeti',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: UiHelper.allPadding3x,
            color: UiColorHelper.mainYellow.withAlpha(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    const Icon(MdiIcons.bicycle, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      order.deliveryType!,
                      style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.30,
                      child: Text(
                        'Sipariş Kodu :   ',
                        style: textTheme.button!.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: Colors.black,
                      padding: UiHelper.allPadding2x,
                      width: width * 0.50,
                      child: Text(
                        order.id!,
                        style: textTheme.button!.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.30,
                      child: Text(
                        'Sipariş Durumu :',
                        style: textTheme.button!.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: UiColorHelper.mainGreen,
                      padding: UiHelper.allPadding2x,
                      width: width * 0.50,
                      child: Text(
                        'Sipariş Teslim Edildi',
                        style: textTheme.button!.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                //Sipariş Süreci Değerlendirme
                Padding(
                  padding: UiHelper.allPadding3x,
                  child: Text('Sipariş Sürecinizi Değerlendirin', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                ),
                Container(
                  color: Colors.white,
                  padding: UiHelper.allPadding3x,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: const [
                            Icon(MdiIcons.emoticonOutline),
                            SizedBox(width: 5),
                            Text('Beğendim'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: const [
                            Icon(MdiIcons.emoticonOutline),
                            SizedBox(width: 5),
                            Text('Beğenmedim'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 2),
                //Adres Bilgisi
                Padding(
                  padding: UiHelper.allPadding3x,
                  child: Text('Teslimat Yöntemi', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: UiHelper.allPadding3x,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adrese Teslim',
                          style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(MdiIcons.navigationOutline, size: 16),
                            const SizedBox(width: 10),
                            Text(
                              order.deliveryAddress!,
                              style: textTheme.button!.copyWith(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 2),
                //Teslimat Saati
                Padding(
                  padding: UiHelper.allPadding3x,
                  child: Text('Teslimat Yöntemi', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                ),
                Container(
                  color: Colors.white,
                  padding: UiHelper.allPadding3x,
                  child: Row(
                    children: [
                      Text(
                        order.deliveryDate!,
                        style: textTheme.button!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        order.deliveryTime!,
                        style: textTheme.button!.copyWith(fontWeight: FontWeight.bold, color: UiColorHelper.mainGreen),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 2),
                //CartItems List
                Padding(
                  padding: UiHelper.allPadding3x,
                  child: Text('Ürünler', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                ),
                Container(
                  color: Colors.white,
                  padding: UiHelper.allPadding3x,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      CartItem cartItem = itemsList[index];
                      String carpanStr = cartItem.birim == 'kg' ? cartItem.carpan.toString() : cartItem.carpan!.toStringAsFixed(0);
                      String str = '$carpanStr ${cartItem.birim!} x ${cartItem.fiyat!.toStringAsFixed(2)} TL';

                      return Padding(
                        padding: () {
                          if (index == 0) {
                            return UiHelper.bottomPadding2x;
                          }
                          if (index == order.cart!.length - 1) {
                            return UiHelper.topPadding2x;
                          }
                          return UiHelper.verticalSymmetricPadding2x;
                        }(),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //cartItem Resim
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                  ),
                                  child: Padding(
                                    padding: UiHelper.allPadding3x,
                                    child: Image.network(
                                      cartItem.resim!,
                                      width: 40,
                                      height: 40,
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
                                //carItem Ad Fiyat
                                Padding(
                                  padding: UiHelper.allPadding2x,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: width * 0.40, child: Text(cartItem.ad!, style: textTheme.button)),
                                      Text(str, style: textTheme.button!.copyWith(color: Colors.grey)),
                                      Row(
                                        children: [
                                          cartItem.eskifiyat != -1
                                              ? Text(
                                                  '${(cartItem.eskifiyat! * cartItem.carpan!).toStringAsFixed(2)} TL',
                                                  style: Theme.of(context).textTheme.button!.copyWith(
                                                        color: Colors.grey,
                                                        decoration: TextDecoration.lineThrough,
                                                      ),
                                                )
                                              : const SizedBox.shrink(),
                                          Card(
                                            elevation: 0,
                                            color: UiColorHelper.mainYellow,
                                            child: Padding(
                                              padding: UiHelper.allPadding1x,
                                              child: Text(
                                                '${(cartItem.fiyat! * cartItem.carpan!).toStringAsFixed(2)} TL',
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
                                const Spacer(),
                                //cartItem Adet Kg
                                Container(
                                  padding: UiHelper.allPadding1x,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: UiHelper.borderRadiusCircular4x,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: UiHelper.horizontalSymmetricPadding3x,
                                    child: Text(
                                      cartItem.birim == 'kg' ? '${cartItem.carpan!} ${cartItem.birim}' : '${cartItem.carpan!.toStringAsFixed(0)} ${cartItem.birim}',
                                      style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(color: Colors.white, child: const Divider(height: 0, thickness: 1));
                    },
                  ),
                ),

                //NotFounded Items List
                notItemsList.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: UiHelper.allPadding3x,
                        child: Text('Bulunamayan Ürünler', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                      ),
                notItemsList.isEmpty
                    ? const SizedBox.shrink()
                    : Container(
                        color: Colors.white,
                        padding: UiHelper.allPadding3x,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notItemsList.length,
                          itemBuilder: (context, index) {
                            CartItem cartItem = notItemsList[index];
                            String carpanStr = cartItem.birim == 'kg' ? cartItem.carpan.toString() : cartItem.carpan!.toStringAsFixed(0);
                            String str = '$carpanStr ${cartItem.birim!} x ${cartItem.fiyat!.toStringAsFixed(2)} TL';
                            return Padding(
                              padding: () {
                                if (index == 0) {
                                  return UiHelper.bottomPadding2x;
                                }
                                if (index == order.cart!.length - 1) {
                                  return UiHelper.topPadding2x;
                                }
                                return UiHelper.verticalSymmetricPadding2x;
                              }(),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //cartItem Resim
                                      Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                        ),
                                        child: Padding(
                                          padding: UiHelper.allPadding3x,
                                          child: Image.network(
                                            cartItem.resim!,
                                            width: 40,
                                            height: 40,
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
                                      //carItem Ad Fiyat
                                      Padding(
                                        padding: UiHelper.allPadding2x,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: width * 0.40, child: Text(cartItem.ad!, style: textTheme.button)),
                                            Text(str, style: textTheme.button!.copyWith(color: Colors.grey)),
                                            Row(
                                              children: [
                                                cartItem.eskifiyat != -1
                                                    ? Text(
                                                        '${(cartItem.eskifiyat! * cartItem.carpan!).toStringAsFixed(2)} TL',
                                                        style: Theme.of(context).textTheme.button!.copyWith(
                                                              color: Colors.grey,
                                                              decoration: TextDecoration.lineThrough,
                                                            ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                Card(
                                                  elevation: 0,
                                                  color: UiColorHelper.mainYellow,
                                                  child: Padding(
                                                    padding: UiHelper.allPadding1x,
                                                    child: Text(
                                                      '${(cartItem.fiyat! * cartItem.carpan!).toStringAsFixed(2)} TL',
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
                                      const Spacer(),
                                      //cartItem Adet Kg
                                      Container(
                                        padding: UiHelper.allPadding1x,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: UiHelper.borderRadiusCircular4x,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: UiHelper.horizontalSymmetricPadding3x,
                                          child: Text(
                                            cartItem.birim == 'kg' ? '${cartItem.carpan!} ${cartItem.birim}' : '${cartItem.carpan!.toStringAsFixed(0)} ${cartItem.birim}',
                                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(color: Colors.white, child: const Divider(height: 0, thickness: 1));
                          },
                        ),
                      ),
                notItemsList.isEmpty
                    ? const SizedBox.shrink()
                    : Container(
                        color: Colors.white,
                        padding: UiHelper.bottomPadding4x,
                        child: Text(
                          'Bulunamayan ürünlerin iadesi \nKredi Kartınıza 3-5 iş günü içerisinde yapılacaktır. ',
                          textAlign: TextAlign.center,
                          style: textTheme.button!.copyWith(color: UiColorHelper.mainRed),
                        ),
                      ),
                const Divider(height: 2),
                //Sipariş Özeti
                Padding(
                  padding: UiHelper.allPadding3x,
                  child: Text('Sipariş Özeti', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
                ),
                Container(
                  color: Colors.white,
                  padding: UiHelper.allPadding3x,
                  child: Column(
                    children: [
                      Padding(
                        padding: UiHelper.bottomPadding3x,
                        child: Row(
                          children: [
                            Text('Ürünler', style: textTheme.subtitle2!),
                            const Spacer(),
                            Text('${order.cartTotal!.toStringAsFixed(2)} TL', style: textTheme.subtitle2!),
                          ],
                        ),
                      ),
                      const Divider(height: 2),
                      Padding(
                        padding: UiHelper.verticalSymmetricPadding3x,
                        child: Row(
                          children: [
                            Text('Kampanyalar', style: textTheme.subtitle2!),
                            const Spacer(),
                            Text('- ${discountTotal.toStringAsFixed(2)} TL', style: textTheme.subtitle2!.copyWith(color: UiColorHelper.mainRed)),
                          ],
                        ),
                      ),
                      const Divider(height: 2),
                      Padding(
                        padding: UiHelper.verticalSymmetricPadding3x,
                        child: Row(
                          children: [
                            Text('Teslimat Ücreti', style: textTheme.subtitle2!),
                            const Spacer(),
                            Text('Ücretsiz', style: textTheme.subtitle2!.copyWith(color: UiColorHelper.mainGreen)),
                          ],
                        ),
                      ),
                      const Divider(height: 2),
                      Padding(
                        padding: UiHelper.topPadding3x,
                        child: Row(
                          children: [
                            Text('Toplam Tutar', style: textTheme.subtitle2!.copyWith(color: UiColorHelper.mainBlue, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text('${(order.cartTotal! - discountTotal).toStringAsFixed(2)} TL', style: textTheme.subtitle2!.copyWith(color: UiColorHelper.mainBlue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 2),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
