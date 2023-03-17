import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/cubit/user_cubit.dart';
import 'package:emarketapp/models/myuser.dart';
import 'package:emarketapp/pages/account/account_billing_info__main_page.dart';
import 'package:emarketapp/pages/account/account_favs_page.dart';
import 'package:emarketapp/pages/account/account_myaddresses_page.dart';
import 'package:emarketapp/pages/account/account_orders_page.dart';
import 'package:emarketapp/pages/account/account_payment_methods_page.dart';
import 'package:emarketapp/pages/account/account_send_message_page.dart';
import 'package:emarketapp/pages/account/account_user_info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'not_authenticated_page.dart';

class AccountPageMain extends StatefulWidget {
  AccountPageMain({Key? key}) : super(key: key);

  @override
  State<AccountPageMain> createState() => _AccountPageMainState();
}

class _AccountPageMainState extends State<AccountPageMain> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  List<String> titles = ['Kullanıcı Bilgilerim', 'Adreslerim', 'Favori Ürünlerim', 'Geçmiş Alışverişlerim', 'Ödeme Yöntemlerim', 'Fatura Bilgilerim', 'Mesaj Gönder'];
  List<IconData> icons = [MdiIcons.accountDetails, MdiIcons.mapMarkerRadius, MdiIcons.heartOutline, MdiIcons.cartArrowUp, MdiIcons.creditCardOutline, MdiIcons.fileOutline, MdiIcons.emailFastOutline];
  late MyUser myUser;
  // SignOut Method
  void signOut() {
    mAuth.signOut();
  }

  //NavigateToPages Method
  navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountUserInfoPage(user: myUser)));
        break;
      case 1:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountMyAddresses()));
        break;
      case 2:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountFavsPage(user: myUser)));
        break;
      case 3:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountOrdersPage()));
        break;
      case 4:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountPaymentMethodsPage()));
        break;
      case 5:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountBillingPageMain()));
        break;
      case 6:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountSendMessagePage()));
        break;
      default:
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const NotAuthenticatedPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              //Account Name Container
              Container(
                color: Colors.yellow.shade300,
                child: GestureDetector(
                  onTap: () {
                    if (mAuth.currentUser == null) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const NotAuthenticatedPage(),
                        ),
                      );
                    }
                  },
                  child: Material(
                    child: ListTile(
                      dense: true,
                      minLeadingWidth: 5,
                      leading: const Icon(MdiIcons.account, color: Colors.black),
                      title: Builder(
                        builder: (context) {
                          final userState = context.watch<UserCubit>().state;
                          if (userState is UserSignIn) {
                            return Text(userState.user.name ?? 'User Name');
                          } else if (userState is UserSignOut) {
                            return const Text('Lütfen Giriş Yapınız');
                          }
                          return const Text('Lütfen Giriş Yapınız');
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //Account Menu Items
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (mAuth.currentUser != null) {
                        myUser = (state as UserSignIn).user;
                        navigateToPage(index);
                      } else {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const NotAuthenticatedPage(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      child: Material(
                        child: ListTile(
                          dense: true,
                          minLeadingWidth: 5,
                          leading: Icon(icons[index], color: Colors.black),
                          title: Text(titles[index]),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(color: Colors.white, child: const Divider(height: 0, thickness: 1));
                },
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: const ListTile(
                  dense: true,
                  minLeadingWidth: 5,
                  leading: Icon(MdiIcons.helpCircleOutline, color: Colors.black),
                  title: Text('Yardım'),
                ),
              ),
              const Divider(height: 1),
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  // user logged in
                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          signOut();
                        },
                        child: const ListTile(
                          dense: true,
                          minLeadingWidth: 5,
                          leading: Icon(MdiIcons.exitToApp, color: Colors.black),
                          title: Text('Çıkış Yap'),
                        ),
                      ),
                    );
                  }
                  // user is not logged in
                  else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Padding(
                padding: UiHelper.topPadding4x,
                child: GestureDetector(
                  onTap: () async {
                    const phoneNumber = '+908508888888';
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: phoneNumber,
                    );
                    await launchUrl(launchUri);
                  },
                  child: Container(
                      color: UiColorHelper.mainYellow,
                      padding: UiHelper.allPadding3x,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Bizi arayın: ',
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '0 850 888 88 88', style: Theme.of(context).textTheme.subtitle2!),
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
