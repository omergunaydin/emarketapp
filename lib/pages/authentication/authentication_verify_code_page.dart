// ignore_for_file: use_build_context_synchronously

import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/pages/authentication/authentication_new_user_page.dart';
import 'package:emarketapp/widgets/reusable_app_bar.dart';
import 'package:emarketapp/widgets/reusable_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/values/colors.dart';

class AuthenticationVerifyCodePage extends StatefulWidget {
  final String phoneNumber;
  final bool registered;
  const AuthenticationVerifyCodePage({Key? key, required this.phoneNumber, required this.registered}) : super(key: key);

  @override
  State<AuthenticationVerifyCodePage> createState() => _AuthenticationVerifyCodePageState();
}

class _AuthenticationVerifyCodePageState extends State<AuthenticationVerifyCodePage> {
  final _verifyCodeTextController = TextEditingController();
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late String mVerificationId;
  late int mResendToken;
  late bool mVerificationInProgress = false;

  @override
  void initState() {
    super.initState();
    startPhoneNumberVerification();
  }

  // 1. Process: StartPhoneNumberVerification
  startPhoneNumberVerification() async {
    debugPrint('phone number verification started! $widget.phoneNumber');
    mVerificationInProgress = true;

    await mAuth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint('onVerificationCompleted : $credential');
        mVerificationInProgress = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('onVerificationFailed : $e');
        mVerificationInProgress = false;
        ReusableAlertDialog(text: 'Verification Failed!\n Birşeyler ters gitti', type: '1');
      },
      codeSent: (String verificationId, int? resendToken) async {
        debugPrint('onCodeSent: $verificationId');
        mVerificationId = verificationId;
        mResendToken = resendToken!;

        /* setState(() {
          codeTextFieldVisible = true;
          codeButtonVisible = true;
          sendTheCodeButtonEnabled = false;
        });*/
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // 2. Process : Verify the Phone number with Code
  verifyPhoneNumberWithCode(String verificationId, String code) {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      signInWithPhoneAuthCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 3. Process : If verification completed, SignIn!
  signInWithPhoneAuthCredential(PhoneAuthCredential credential) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: UiColorHelper.mainYellow,
            ),
          );
        });

    final UserCredential authResult = await mAuth.signInWithCredential(credential);
    Navigator.of(context).pop();

    if (authResult.additionalUserInfo!.isNewUser) {
      debugPrint('newUser created');
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: AuthenticationNewUserPage(phoneNumber: widget.phoneNumber),
        ),
      );
    } else {
      debugPrint('existing user!');
      Navigator.of(context).pop();
    }
    debugPrint(mAuth.currentUser!.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: UiColorHelper.mainYellow,
      appBar: ReusableAppBar(text: 'Onay Kodu', width: width, height: height),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Phone icon & info text
            Container(
              width: width,
              height: height * 0.40,
              color: UiColorHelper.mainYellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(MdiIcons.cellphoneCheck, size: 100),
                  Text(
                    'Lütfen ${widget.phoneNumber} numaralı cep\n\ntelefonunuza gönderilen onay kodunu\n\naşağıdaki kutucuklara giriniz.',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            //Verify Code TextField
            Padding(
              padding: UiHelper.horizontalSymmetricPadding6x,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                animationType: AnimationType.fade,
                controller: _verifyCodeTextController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.black,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderWidth: 1,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeFillColor: Colors.black,
                    activeColor: Colors.black,
                    inactiveColor: Colors.black,
                    selectedColor: Colors.black),
                onCompleted: (code) {
                  debugPrint("Completed");
                  // when complete start auth process...
                  verifyPhoneNumberWithCode(mVerificationId, code);
                },
                onChanged: (value) {
                  /*debugPrint(value);
                  code = value;*/
                },
              ),
            ),
            const SizedBox(height: 30),
            //Re-send SMS Button
            GestureDetector(
              onTap: () {
                //Resend SMS Process
              },
              child: Text(
                'Tekrar SMS Gönder',
                style: textTheme.subtitle2!.copyWith(decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      ),
    );
  }
}
