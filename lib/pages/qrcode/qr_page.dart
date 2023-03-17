import 'dart:async';

import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  int _remainingSeconds = 119;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds == 0) {
        _timer?.cancel();
        Navigator.pop(context);
      }
    });
  }

  String getFormattedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  refreshQrCodeAndTimer() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: UiColorHelper.mainYellow,
          ),
        );
      },
    );
    await Future.delayed(
      const Duration(milliseconds: 1200),
      () {
        _remainingSeconds = 120;
        _timer?.cancel();
        startTimer();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Qr İle Ödeme',
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
      ),
      body: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: mAuth.currentUser!.uid,
              version: QrVersions.auto,
              size: 200,
            ),
            const SizedBox(height: 50),
            const Text(
              'Ödeme anında kasa çalışanına\nqr kodunuzu okutarak alışverinizi\ntemassız olarak tamamlayabilirsiniz.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(MdiIcons.clockOutline),
                const SizedBox(width: 10),
                Text(
                  getFormattedTime(_remainingSeconds),
                  style: textTheme.headline6!,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: UiHelper.horizontalSymmetricPadding4x,
              child: ElevatedButton.icon(
                onPressed: () {
                  refreshQrCodeAndTimer();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Kodu Yenile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: UiColorHelper.mainBlue,
                  padding: UiHelper.horizontalSymmetricPadding3x,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: const Size(double.infinity, 48.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
