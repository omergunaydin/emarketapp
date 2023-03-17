import 'package:emarketapp/pages/cart/cart_complete_order_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';
import '../../data/products_api_client.dart';
import '../../data/user_api_client.dart';
import '../../models/myuser.dart';
import '../../models/product.dart';
import '../../widgets/reusable_error_dialog.dart';
import '../../widgets/show_snackbar.dart';
import '../product/product_details.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late Future _promotionalProductsFuture;
  List<CartItem> cartItems = [];
  double cartTotal = 0;
  bool loading = false;

  @override
  void initState() {
    _promotionalProductsFuture = ProductsApiClient().fetchPromotionalProductsData();
    getUserData();
    super.initState();
  }

  changeLoadingState() {
    setState(() {
      loading = !loading;
    });
  }

  getUserData() async {
    changeLoadingState();
    cartItems = [];
    MyUser? user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
    cartItems = user!.cart!;
    calculateCartTotal();
    changeLoadingState();
    setState(() {});
  }

  calculateCartTotal() {
    cartTotal = 0;
    for (var cartItem in cartItems) {
      if (cartItem.indirim == '2') {
        cartTotal = cartTotal + ((cartItem.carpan! / 2).ceil() * cartItem.fiyat!);
      } else {
        cartTotal = cartTotal + (cartItem.carpan! * cartItem.fiyat!);
      }
    }
  }

  updateCartItem(CartItem cartItem, int index, String fnc) {
    setState(() {
      if (cartItem.birim! == 'kg') {
        if (fnc == 'add') {
          cartItems[index].carpan = cartItem.carpan! + 0.5;
        } else {
          cartItems[index].carpan = cartItem.carpan! - 0.5;
        }
      } else {
        if (fnc == 'add') {
          cartItems[index].carpan = cartItem.carpan! + 1;
        } else {
          cartItems[index].carpan = cartItem.carpan! - 1;
        }
      }
      calculateCartTotal();
      if (cartItems[index].carpan == 0) {
        showSnackBar(context: context, msg: 'Ürününüz sepetten silindi.', type: 'success');
        UserApiClient().deleteProductFromUserCart(mAuth.currentUser!.uid, cartItems[index]);
        cartItems.removeAt(index);
      } else {
        UserApiClient().updateProductsOnUserCart(mAuth.currentUser!.uid, cartItems);
      }
    });
  }

  deleteCartItems() {
    setState(() {
      cartItems = [];
      calculateCartTotal();
      UserApiClient().updateProductsOnUserCart(mAuth.currentUser!.uid, cartItems);
      Navigator.of(context).pop();
      showSnackBar(context: context, msg: 'Sepetinizdeki ürünler silindi.', type: 'success');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sepet',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            MdiIcons.chevronDown,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if (cartItems.isEmpty) {
                showSnackBar(context: context, msg: 'Sepetiniz zaten boş!');
                return;
              }
              showDialog(
                context: context,
                builder: (_) => ReusableAlertDialog(
                  text: 'Sepetinizdeki tüm ürünleri silmek istediğinize emin misiniz?',
                  type: '2',
                  onPressed: () => deleteCartItems(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? const SizedBox.shrink()
          : InkWell(
              onTap: () {
                if (cartTotal >= 80) {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CartCompleteOrderPage(cartItems: cartItems),
                    ),
                  );
                } else {
                  showSnackBar(context: context, msg: 'Sepet tutarı 80TLden az olamaz!');
                }
              },
              child: Container(
                color: Colors.white,
                width: width,
                height: height * 0.08,
                child: Center(
                  child: Container(
                    width: width * 0.90,
                    height: height * 0.06,
                    padding: UiHelper.horizontalSymmetricPadding3x,
                    decoration: BoxDecoration(
                      color: UiColorHelper.mainBlue,
                      borderRadius: UiHelper.borderRadiusCircular1x,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${cartTotal.toStringAsFixed(2)} TL', style: textTheme.subtitle2!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('Siparişi Tamamla', style: textTheme.subtitle2!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //info container
            Container(
              width: width,
              height: 40,
              color: UiColorHelper.mainYellow.withAlpha(75),
              child: Center(
                child: Text(
                  'Adrese teslim için min sepet tutarı 80TL\'nin üzerinde olmalıdır.',
                  style: textTheme.button,
                ),
              ),
            ),

            loading == true
                ? SizedBox(
                    width: width,
                    height: height * 0.75,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: UiColorHelper.mainYellow,
                      ),
                    ),
                  )
                : cartItems.isEmpty
                    ? SizedBox(
                        height: height * 0.75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(MdiIcons.cartOff),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Sepetinizde ürün bulunmuyor')
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          CartItem cartItem = cartItems[index];
                          String carpanStr = cartItem.birim == 'kg' ? cartItem.carpan.toString() : cartItem.carpan!.toStringAsFixed(0);
                          String str = '$carpanStr ${cartItem.birim!} x ${cartItem.fiyat!.toStringAsFixed(2)} TL';
                          String indirim1Str = 'Her 25 TL alışverişinize ${cartItem.ad} sadece ${cartItem.fiyat} TL.';
                          String indirim2Str = '${cartItem.ad} ikincisi hediye!';
                          return GestureDetector(
                            onTap: () async {
                              Product? product = await ProductsApiClient().getProductById(cartItem.id!);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: ProductDetails(product: product!),
                                ),
                              ).then((value) {
                                getUserData();
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              padding: UiHelper.allPadding2x,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                      Padding(
                                        padding: UiHelper.allPadding2x,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: width * 0.40, child: Text(cartItem.ad!, style: textTheme.button)),
                                            Text(str, style: textTheme.button!.copyWith(color: Colors.grey)),
                                            Card(
                                              elevation: 0,
                                              color: UiColorHelper.mainYellow,
                                              child: Padding(
                                                padding: UiHelper.allPadding1x,
                                                child: Text(
                                                  '${cartItem.fiyat!.toStringAsFixed(2)} TL',
                                                  style: Theme.of(context).textTheme.button!.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: UiColorHelper.mainRed,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      //Add-Remove Button
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
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () => updateCartItem(cartItem, index, 'remove'),
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: Colors.green,
                                                  size: 15,
                                                ),
                                              ),
                                              Padding(
                                                padding: UiHelper.horizontalSymmetricPadding1x,
                                                child: Text(
                                                  cartItem.birim == 'kg' ? '${cartItem.carpan!} ${cartItem.birim}' : '${cartItem.carpan!.toStringAsFixed(0)} ${cartItem.birim}',
                                                  style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.green),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => updateCartItem(cartItem, index, 'add'),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.green,
                                                  size: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //İndirim vs. varsa gösterilecek info

                                  cartItem.indirim != ''
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Opacity(
                                              opacity: 0,
                                              child: Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                                ),
                                                child: const Padding(
                                                  padding: UiHelper.allPadding3x,
                                                  child: SizedBox(
                                                    width: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: UiHelper.allPadding2x,
                                                child: Text(
                                                  cartItem.indirim! == '1' ? indirim1Str : indirim2Str,
                                                  maxLines: 3,
                                                  style: textTheme.button!.copyWith(color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: UiHelper.horizontalSymmetricPadding3x,
                            child: Container(color: Colors.white, child: const Divider(height: 0, thickness: 1)),
                          );
                        },
                      ),
            //promotionalProducts List

            cartItems.isEmpty ? const SizedBox.shrink() : promotionalProductsBuilder(context, width),
            //I have promotion code area
            cartItems.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20, bottom: 40),
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        'Promosyon Kodum Var',
                        style: textTheme.button!.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
          ],
        ),
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
                          ).then((value) {
                            getUserData();
                          });
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
}
