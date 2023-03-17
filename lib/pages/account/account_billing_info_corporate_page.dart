import 'dart:convert';
import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/widgets/reusable_button.dart';
import 'package:emarketapp/widgets/reusable_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/user_api_client.dart';
import '../../models/myuser.dart';
import '../../models/province_district.dart';
import '../../widgets/reusable_textfield.dart';
import '../../widgets/show_snackbar.dart';

class AccountBillingInfoCorporatePage extends StatefulWidget {
  AccountBillingInfoCorporatePage({Key? key}) : super(key: key);

  @override
  State<AccountBillingInfoCorporatePage> createState() => _AccountBillingInfoCorporatePageState();
}

class _AccountBillingInfoCorporatePageState extends State<AccountBillingInfoCorporatePage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late MyUser? user;
  final _faturaUnvaniTextController = TextEditingController();
  final _vergiDairesiTextController = TextEditingController();
  final _vergiNumarasiTextController = TextEditingController();
  final _adresTextController = TextEditingController();
  List<dynamic> _illerListesi = [];
  List<String> _ilIsimleriListesi = [];
  List<String> _ilceIsimleriListesi = [];
  String? _secilenIl = '';
  String? _secilenIlce = '';
  bool ilkYuklemeDurum = false;
  bool flag = false;

  changeSelectedIl(val) {
    setState(() {
      _secilenIl = val.toString();
      _secilenIlinIlceleriniGetir(val);
    });
  }

  changeSelectedIlce(val) {
    setState(() {
      _secilenIlce = val.toString();
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  //get User Data and Run _illeriGetir
  getUserData() async {
    user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
    if (user!.faturaKurumsal != null) {
      print('çalıştı!!!');
      _faturaUnvaniTextController.text = user!.faturaKurumsal!.faturaUnvan!;
      _vergiDairesiTextController.text = user!.faturaKurumsal!.vergiDairesi!;
      _vergiNumarasiTextController.text = user!.faturaKurumsal!.vergiNumarasi!;
      _adresTextController.text = user!.faturaKurumsal!.adres!;
    }
    _illeriGetir().then((value) => _ilIsimleriniGetir());
  }

  //İlleri Getir
  Future<void> _illeriGetir() async {
    String jsonString = await rootBundle.loadString('assets/json/il-ilce.json');
    final jsonResponse = json.decode(jsonString);
    _illerListesi = jsonResponse.map((x) => Il.fromJson(x)).toList();
  }

  //İl İsimlerini Getir
  void _ilIsimleriniGetir() {
    _ilIsimleriListesi = [];
    _illerListesi.forEach((element) {
      _ilIsimleriListesi.add(element.ilAdi);
    });

    setState(() {
      if (user!.faturaKurumsal != null) {
        if (user!.faturaKurumsal!.il != null) {
          _secilenIl = user!.faturaKurumsal!.il!;
          _secilenIlinIlceleriniGetir(user!.faturaKurumsal!.il!);
        } else {
          _secilenIl = _ilIsimleriListesi.first;
          _secilenIlinIlceleriniGetir(_ilIsimleriListesi.first);
        }
      } else {
        _secilenIl = _ilIsimleriListesi.first;
        _secilenIlinIlceleriniGetir(_ilIsimleriListesi.first);
      }
    });
  }

  //İlçe İsimlerini Getir
  void _secilenIlinIlceleriniGetir(String secilenIl) {
    _ilceIsimleriListesi = [];
    _illerListesi.forEach((element) {
      if (element.ilAdi == secilenIl) {
        element.ilceler.forEach((element) {
          _ilceIsimleriListesi.add(element.ilceAdi);
        });
      }
    });
    setState(() {
      if (ilkYuklemeDurum == true) {
        _secilenIlce = _ilceIsimleriListesi.first;
        print('buraya girdi 1');
      } else {
        if (user!.faturaKurumsal != null) {
          if (user!.faturaKurumsal!.ilce != null) {
            _secilenIlce = user!.faturaKurumsal!.ilce;
            if (flag == false) {
              ilkYuklemeDurum = true;
              flag = true;
            }
            print('buraya girdi 2');
          } else {
            _secilenIlce = _ilceIsimleriListesi.first;
            print('buraya girdi 3');
          }
        } else {
          _secilenIlce = _ilceIsimleriListesi.first;
        }
      }
    });
  }

  void saveUserData() {
    if (user != null) {
      FaturaKurumsal newF = FaturaKurumsal(
        faturaUnvan: _faturaUnvaniTextController.text.toString(),
        vergiDairesi: _vergiDairesiTextController.text.toString(),
        vergiNumarasi: _vergiNumarasiTextController.text.toString(),
        adres: _adresTextController.text.toString(),
        il: _secilenIl,
        ilce: _secilenIlce,
      );
      user = user!.copyWith(faturaKurumsal: newF);
      UserApiClient().updateUserData2(user!);
      showSnackBar(context: context, msg: 'Bilgileriniz kaydedildi.', type: 'success');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Fatura Bilgilerim',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: UiHelper.allPadding3x,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fatura Ünvanı', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
            ReusableTextField(controller: _faturaUnvaniTextController),
            Text('Vergi Dairesi', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
            ReusableTextField(controller: _vergiDairesiTextController),
            Text('Vergi Numarası', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
            ReusableTextField(controller: _vergiNumarasiTextController),
            Text('Adres', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
            ReusableTextField(controller: _adresTextController, maxLines: 3),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('İl', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ReusableDropdown(selectedItem: _secilenIl, itemsList: _ilIsimleriListesi, onChanged: changeSelectedIl),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('İlçe', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ReusableDropdown(selectedItem: _secilenIlce, itemsList: _ilceIsimleriListesi, onChanged: changeSelectedIlce),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ReusableButton(
                text: 'Kaydet',
                onPressed: () {
                  saveUserData();
                },
                color: UiColorHelper.mainBlue)
          ],
        ),
      ),
    );
  }
}
