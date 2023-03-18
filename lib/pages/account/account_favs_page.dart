import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/models/product.dart';
import 'package:emarketapp/widgets/reusable_error_dialog.dart';
import 'package:emarketapp/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/values/colors.dart';
import '../../data/user_api_client.dart';
import '../../models/myuser.dart';
import '../../widgets/reusable_app_bar.dart';
import '../product/product_details.dart';

class AccountFavsPage extends StatefulWidget {
  MyUser user;
  AccountFavsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountFavsPage> createState() => _AccountFavsPageState();
}

class _AccountFavsPageState extends State<AccountFavsPage> {
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('anaurunler');
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late List<Fav> favsList;

  @override
  void initState() {
    super.initState();
    favsList = widget.user.fav ?? [];
  }

  deleteUserFav(int index) {
    showDialog(
        context: context,
        builder: (_) => ReusableAlertDialog(
              text: 'Favori ürününüzü silmek istediğinize emin misiniz?',
              type: '2',
              onPressed: () {
                UserApiClient().deleteFavFromUser(mAuth.currentUser!.uid, index);

                setState(() {
                  favsList.removeAt(index);
                });
                Navigator.of(context).pop();
                showSnackBar(context: context, msg: 'Favori ürününüz silindi.', type: 'success');
              },
            ));
  }

  deleteFavFromList(String favId) {
    for (int i = 0; i < favsList.length; i++) {
      if (favsList[i].id == favId) {
        setState(() {
          favsList.remove(favsList[i]);
        });
      }
    }
  }

  addFavToList(Fav fav) {
    setState(() {
      favsList.add(fav);
    });
  }

  showUserFav(String favId) async {
    print(favId);
    final docProduct = _productsRef.doc(favId);
    final snapshot = await docProduct.get();
    if (snapshot.exists) {
      Product product = Product.fromJson(snapshot.data() as Map<String, dynamic>);
      product.id = favId;
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: ProductDetails(product: product, deleteCallBack: deleteFavFromList, addCallBack: addFavToList),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ReusableAppBar(text: 'Favori Ürünlerim', width: width, height: height),
        body: favsList.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(MdiIcons.circleOffOutline),
                  SizedBox(height: 20),
                  Text('Favori listenizde ürün bulunmuyor.'),
                ],
              ))
            : ListView.separated(
                itemBuilder: (context, index) {
                  final Fav fav = favsList[index];
                  return GestureDetector(
                    onTap: () => showUserFav(fav.id!),
                    child: Container(
                      color: Colors.white,
                      height: width * 0.20,
                      child: Center(
                        child: ListTile(
                          leading: SizedBox(
                            width: width * 0.20,
                            child: Image.network(
                              fav.resim!,
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
                          title: Text(fav.name!, style: textTheme.subtitle2),
                          trailing: IconButton(
                            onPressed: () => deleteUserFav(index),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black87,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(color: Colors.white, child: const Divider(height: 0, thickness: 1));
                },
                itemCount: favsList.length));
  }
}
