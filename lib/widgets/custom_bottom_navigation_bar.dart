import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/constants/values/constants.dart';
import 'package:emarketapp/models/myuser.dart';
import 'package:emarketapp/pages/cart/cart_page.dart';
import 'package:emarketapp/pages/qrcode/qr_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../pages/account/not_authenticated_page.dart';
import '../pages/cart/cart_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  int selectedIndex;
  Function function;
  static final GlobalKey<_CustomBottomNavigationBarState> globalKey = GlobalKey();

  CustomBottomNavigationBar({Key? key, required this.selectedIndex, required this.function}) : super(key: globalKey);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late Stream<DocumentSnapshot> userStream;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    userStream = FirebaseFirestore.instance.collection('users').doc(mAuth.currentUser!.uid).snapshots();
  }

  void changeTabSelectedIndex(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  void changeTabAndCallFunction(int value) {
    setState(() {
      _selectedIndex = value;
      widget.function(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BottomNavigationBar(
      onTap: (value) {
        //print('value $value');
        if (value == 2) {
          debugPrint('qr code');
          if (FirebaseAuth.instance.currentUser != null) {
            _selectedIndex = value;
            Navigator.push(
              context,
              PageTransition(type: PageTransitionType.bottomToTop, child: QrCodePage()),
            );
          } else {
            showLoginDialog(context, height);
          }
        } else if (value == 3) {
          debugPrint('sepet');
          //TODO: Sepet işlemi yapılacak
          //Eğer loginse yapılacak değilse showLoginDialog gösterilecek

          if (FirebaseAuth.instance.currentUser != null) {
            //changeTabAndCallFunction(value);
            _selectedIndex = value;
            Navigator.push(
              context,
              PageTransition(type: PageTransitionType.bottomToTop, child: CartPage()),
            );
          } else {
            showLoginDialog(context, height);
          }
        } else {
          setState(() {
            _selectedIndex = value;
            widget.function(value);
            //print('value $value');
          });
        }
      },
      items: [
        BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(MdiIcons.shopping, color: _selectedIndex == 0 ? UiColorHelper.mainBlue : Colors.black),
                Text(
                  'Ürünler',
                  style: Theme.of(context).textTheme.caption!.copyWith(color: _selectedIndex == 0 ? UiColorHelper.mainBlue : Colors.black),
                )
              ],
            ),
            label: 'Ürünler'),
        BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(MdiIcons.magnify, color: _selectedIndex == 1 ? UiColorHelper.mainBlue : Colors.black),
                Text(
                  'Ürün Ara',
                  style: Theme.of(context).textTheme.caption!.copyWith(color: _selectedIndex == 1 ? UiColorHelper.mainBlue : Colors.black),
                )
              ],
            ),
            label: 'Ürün Ara'),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              const Icon(
                MdiIcons.qrcode,
                color: Colors.red,
              ),
              Text(
                'QR Code',
                style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.red),
              )
            ],
          ),
          label: 'QR Code',
        ),
        BottomNavigationBarItem(
            icon: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  // user logged in
                  if (snapshot.hasData) {
                    //if user logged in then check user cart!
                    return StreamBuilder<DocumentSnapshot>(
                        stream: userStream,
                        builder: (context, snapshot) {
                          //if user cart not hasData or error
                          if (!snapshot.hasData || snapshot.hasError) {
                            return Column(
                              children: [
                                Icon(
                                  MdiIcons.basket,
                                  color: _selectedIndex == 3 ? UiColorHelper.mainBlue : Colors.black,
                                ),
                                Text(
                                  'Sepet',
                                  style: Theme.of(context).textTheme.caption!.copyWith(color: _selectedIndex == 3 ? UiColorHelper.mainBlue : Colors.black),
                                )
                              ],
                            );
                            //if has data
                          } else {
                            MyUser user = MyUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Center(
                                      child: Icon(
                                        MdiIcons.basket,
                                        color: _selectedIndex == 3 ? UiColorHelper.mainBlue : Colors.black,
                                      ),
                                    ),
                                    user.cart!.isEmpty
                                        ? const SizedBox.shrink()
                                        : Positioned(
                                            top: 0,
                                            right: 20,
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: UiColorHelper.mainRed,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${user.cart!.length}',
                                                  style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                Text(
                                  'Sepet',
                                  style: Theme.of(context).textTheme.caption!.copyWith(color: _selectedIndex == 3 ? UiColorHelper.mainBlue : Colors.black),
                                )
                              ],
                            );
                          }
                        });
                  } else {
                    return Column(
                      children: [
                        Icon(
                          MdiIcons.basket,
                          color: _selectedIndex == 3 ? UiColorHelper.mainBlue : Colors.black,
                        ),
                        Text(
                          'Sepet',
                          style: Theme.of(context).textTheme.caption!.copyWith(color: _selectedIndex == 3 ? UiColorHelper.mainBlue : Colors.black),
                        )
                      ],
                    );
                  }
                }),
            label: 'Sepet'),
        BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(MdiIcons.account, color: _selectedIndex == 4 ? UiColorHelper.mainBlue : Colors.black),
                Text(
                  'Hesap',
                  style: Theme.of(context).textTheme.caption!.copyWith(color: _selectedIndex == 4 ? UiColorHelper.mainBlue : Colors.black),
                )
              ],
            ),
            label: 'Hesap'),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedLabelStyle: const TextStyle(fontSize: 2),
      unselectedLabelStyle: const TextStyle(fontSize: 2),
      currentIndex: _selectedIndex,
    );
  }

  Future<dynamic> showLoginDialog(BuildContext context, double height) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(
              height: height / 5,
              child: Image.asset(
                'assets/images/max_poset.png',
                fit: BoxFit.cover,
              )),
          content: Text(
            ConstValues.loginDialogText,
            style: Theme.of(context).textTheme.button,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Padding(
              padding: UiHelper.rightPadding4x,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Vazgeç',
                  style: Theme.of(context).textTheme.button!.copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: UiColorHelper.mainBlue),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const NotAuthenticatedPage(),
                  ),
                );
              },
              child: Text("Giriş Yap", style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
