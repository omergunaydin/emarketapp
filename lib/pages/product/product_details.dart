import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/data/user_api_client.dart';
import 'package:emarketapp/models/product.dart';
import 'package:emarketapp/pages/product/product_image.dart';
import 'package:emarketapp/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/myuser.dart';

class ProductDetails extends StatefulWidget {
  Product product;
  final Function? callBack;
  ProductDetails({Key? key, required this.product, this.callBack}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late List<Fav> favsList;
  late List<CartItem> cartItemsList;
  late Product product;
  late CartItem cartItem;
  bool isFav = false;
  bool isOnCart = false;
  int favIndex = -1;
  int counter = 0;
  String buttonText = "Sepete Ekle";

  @override
  void initState() {
    super.initState();
    product = widget.product;
    if (mAuth.currentUser != null) {
      getUserFavsAndCartItems();
    }

    cartItem = CartItem(
      id: product.id,
      ad: product.ad,
      resim: product.resim,
      fiyat: product.fiyat,
      eskifiyat: product.eskifiyat,
      indirim: product.indirim,
      birim: product.birim,
      carpan: widget.product.carpan! * counter,
    );
  }

  getUserFavsAndCartItems() async {
    MyUser? user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
    cartItemsList = user!.cart ?? [];
    cartItemsList.asMap().forEach((index, cartItem) {
      final id = cartItem.id;
      if (widget.product.id == id) {
        print('CartItem Match found at index $index');
        setState(() {
          isOnCart = true;
          counter = cartItem.carpan! ~/ widget.product.carpan!;

          setButtonText();
        });
      }
    });

    favsList = user.fav ?? [];
    favsList.asMap().forEach((index, fav) {
      final name = fav.name;
      final id = fav.id;
      print('Index $index: $name, $id');
      if (widget.product.id == id) {
        print('Fav Match found at index $index');
        favIndex = index;
        setState(() {
          isFav = true;
        });
      }
    });
  }

  void changeIsFavState() {
    setState(() {
      isFav = !isFav;
    });
  }

  void changeIsOnCart() {
    isOnCart = !isOnCart;
  }

  addToCart() {
    isOnCart = true;
    setState(() {
      counter++;
      setButtonText();
      cartItem.carpan = widget.product.carpan! * counter;
      if (counter == 1) {
        //first add
        UserApiClient().addProductToUserCart(mAuth.currentUser!.uid, cartItem);
      } else {
        UserApiClient().updateProductOnUserCart(mAuth.currentUser!.uid, cartItem);
      }

      //
    });
  }

  removeFromCart() {
    setState(() {
      counter--;
      setButtonText();
      cartItem.carpan = widget.product.carpan! * counter;
      UserApiClient().updateProductOnUserCart(mAuth.currentUser!.uid, cartItem);
      if (counter == 0) {
        isOnCart = false;
        UserApiClient().deleteProductFromUserCart(mAuth.currentUser!.uid, cartItem);
      }
    });
  }

  setButtonText() {
    buttonText = widget.product.birim == 'kg' ? '${widget.product.carpan! * counter} ${widget.product.birim}' : '${(widget.product.carpan! * counter).toStringAsFixed(0)} ${widget.product.birim}';
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    Product product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ürün Detayı',
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
            icon: const Icon(Icons.share),
            onPressed: () async {
              await FlutterShare.share(
                title: 'Share this product',
                text: 'Bu ürüne göz atmak isteyebilirsin.',
                linkUrl: 'https://example.com/product-example',
              );
            },
          ),
          IconButton(
            icon: isFav ? const Icon(Icons.favorite_sharp) : const Icon(Icons.favorite_outline),
            onPressed: () {
              debugPrint(product.id);
              if (mAuth.currentUser != null) {
                if (isFav) {
                  if (favIndex != -1) {
                    UserApiClient().deleteFavFromUser(mAuth.currentUser!.uid, favIndex);
                    showSnackBar(context: context, msg: 'Ürün favorilerden silindi.', type: 'info');
                    widget.callBack!(product.id); //call callBack method
                  }
                } else {
                  if (favsList.isEmpty) {
                    favIndex = 0;
                  }
                  favIndex = favsList.length;
                  UserApiClient().addFavToUser(mAuth.currentUser!.uid, Fav(id: product.id, name: product.ad, resim: product.resim));
                  showSnackBar(context: context, msg: 'Ürün favorilere eklendi.', type: 'info');
                }
                changeIsFavState();
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: ProductImage(resim: product.resim!),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: height / 100 * 30,
                  child: Center(
                    child: SizedBox(
                      height: height / 100 * 25,
                      width: height / 100 * 25,
                      child: Image.network(
                        product.resim!,
                        fit: BoxFit.contain,
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
                ),
                const Positioned(bottom: 25, right: 25, child: Icon(MdiIcons.arrowExpand)),
                product.indirim != ''
                    ? Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: width / 3,
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
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Material(
            elevation: 2,
            child: Container(
              color: Colors.white,
              width: width,
              child: Column(
                children: [
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: UiHelper.horizontalSymmetricPadding3x,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Açıklamalar',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
          Material(
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: UiHelper.allPadding3x,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: UiHelper.bottomPadding1x,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ürün Kodu', style: Theme.of(context).textTheme.button),
                        Text(product.urunKodu!, style: Theme.of(context).textTheme.button),
                      ],
                    ),
                  ),
                  Padding(
                    padding: UiHelper.bottomPadding1x,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ürün Markası', style: Theme.of(context).textTheme.button),
                        Text(product.marka!, style: Theme.of(context).textTheme.button),
                      ],
                    ),
                  ),
                  Padding(
                    padding: UiHelper.bottomPadding1x,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ürün Menşei', style: Theme.of(context).textTheme.button),
                        Text(product.mensei!, style: Theme.of(context).textTheme.button),
                      ],
                    ),
                  ),
                  product.aciklama == ''
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: UiHelper.bottomPadding1x,
                          child: Text('Açıklama', style: Theme.of(context).textTheme.button),
                        ),
                  product.aciklama == '' ? const SizedBox.shrink() : Text(product.aciklama!, style: Theme.of(context).textTheme.button),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            color: Colors.green,
            height: height / 100 * 8,
            child: Center(
              child: SizedBox(
                width: width / 2,
                height: height / 100 * 6,
                child: ElevatedButton(
                  onPressed: () {
                    if (mAuth.currentUser != null) {
                      if (counter == 0) {
                        addToCart();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: isOnCart
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () => removeFromCart(),
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.green,
                                )),
                            Text(
                              buttonText,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.green),
                            ),
                            IconButton(
                                onPressed: () => addToCart(),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.green,
                                )),
                          ],
                        )
                      : Text(
                          "Sepete Ekle",
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.green),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
