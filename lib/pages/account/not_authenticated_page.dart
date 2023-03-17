import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/pages/authentication/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NotAuthenticatedPage extends StatelessWidget {
  const NotAuthenticatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: height / 100 * 75,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/notauth.png'),
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.bottomCenter,
                      ),
                    ),
                  ),
                  Container(
                    height: height / 100 * 25,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(height / 100 * 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: height / 100 * 6,
                            width: width / 100 * 90,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: AuthenticationPage(registered: true),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UiColorHelper.mainBlue,
                                shape: RoundedRectangleBorder(borderRadius: UiHelper.borderRadiusCircular1x),
                              ),
                              child: Text(
                                'Giriş Yap',
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 100 * 6,
                            width: width / 100 * 90,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: AuthenticationPage(registered: false),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UiColorHelper.softBlackColor,
                                shape: RoundedRectangleBorder(borderRadius: UiHelper.borderRadiusCircular1x),
                              ),
                              child: Text(
                                'Yeni Üyelik Oluştur',
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 100 * 6,
                            width: width / 100 * 75,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: UiHelper.borderRadiusCircular1x),
                              ),
                              child: Text(
                                'Giriş yapmadan devam et',
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
