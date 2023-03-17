import 'package:emarketapp/data/orders_api_client.dart';
import 'package:emarketapp/data/user_api_client.dart';
import 'package:emarketapp/models/myorder.dart';
import 'package:emarketapp/pages/cart/cart_change_delivery_time.dart';
import 'package:emarketapp/widgets/reusable_button_outlined.dart';
import 'package:emarketapp/widgets/reusable_textfield.dart';
import 'package:emarketapp/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';
import '../../models/myuser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'cart_change_billing_info.dart';

class CartCompleteOrderPage extends StatefulWidget {
  List<CartItem> cartItems;
  CartCompleteOrderPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartCompleteOrderPage> createState() => _CartPageCompleteOrderState();
}

class _CartPageCompleteOrderState extends State<CartCompleteOrderPage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  late List<CartItem> cartItems;
  double cartTotal = 0;
  final List<String> _listAddressOptions = ['Adrese Teslim', 'Marketten Gel Al'];
  final List<String> _listAddressTitle = ['Ev Adresim', 'Max Market'];
  final List<String> _listAdressText = ['Sanayi Cad. 3C Fatih Mah. Deniz Sok. No:45', 'Sanayi Cad. 3C Fatih Mah. Deniz Sok. No:20'];
  int _selectedIndex = 0;
  int _selectedIndexPayment = 0;
  late String hourText;
  final _notTextController = TextEditingController();
  bool checked = false;
  String _selectedDate = '';
  String _selectedHour = '';
  String _selectedBillingMethod = 'Bireysel';
  bool orderResult = false;

  @override
  void initState() {
    cartItems = widget.cartItems;
    calculateCartTotal();
    calculateDate();
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    calculateDeliveryHour(currentHour);
    super.initState();
  }

  calculateDate() async {
    await initializeDateFormatting('tr_TR', null);
    setState(() {
      DateTime currentDate = DateTime.now();
      DateTime dateToday = DateTime(currentDate.year, currentDate.month, currentDate.day);
      _selectedDate = DateFormat('d MMMM yyyy EEEE', 'tr').format(currentDate);
      if (currentDate.hour >= 21) {
        DateTime second = currentDate.add(const Duration(days: 1));
        _selectedDate = DateFormat('d MMMM yyyy EEEE', 'tr').format(second);
      }
    });
  }

  calculateDeliveryHour(int currentHour) {
    if (currentHour >= 0 && currentHour < 9) {
      hourText = 'Bugün 09:00-10:00';
      _selectedHour = '09:00-10:00';
    } else if (currentHour >= 9 && currentHour <= 20) {
      hourText = 'Bugün $currentHour:00-${currentHour + 1}:00';
      _selectedHour = '$currentHour:00-${currentHour + 1}:00';
      if (currentHour == 9) {
        hourText = 'Bugün 0$currentHour:00-${currentHour + 1}:00';
        _selectedHour = '0$currentHour:00-${currentHour + 1}:00';
      }
    } else if (currentHour >= 0 && currentHour < 9) {
      hourText = 'Bugün $currentHour:00-${currentHour + 1}:00';
      _selectedHour = '$currentHour:00-${currentHour + 1}:00';
      if (currentHour == 9) {
        hourText = 'Bugün 0$currentHour:00-${currentHour + 1}:00';
        _selectedHour = '0$currentHour:00-${currentHour + 1}:00';
      }
    } else if (currentHour >= 21 && currentHour < 24) {
      hourText = 'Yarın 09:00-10:00';
      _selectedHour = '09:00-10:00';
    }
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

  showDateTimeData(String sDate, String sHour) {
    setState(() {
      _selectedDate = sDate;
      _selectedHour = sHour;
      if (_selectedHour.startsWith('0')) {
        String char = _selectedHour.substring(1, 2);
        int hour = int.parse(char);
        calculateDeliveryHour(hour);
      } else {
        String s = _selectedHour.substring(0, 2);
        int hour = int.parse(s);
        calculateDeliveryHour(hour);
      }
    });
  }

  onChangedSelectedBillingMethod(val) {
    setState(() {
      _selectedBillingMethod = val;
    });
  }

  addOrder() async {
    if (checked) {
      MyUser? user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
      if (user != null) {
        MyOrder newOrder = MyOrder(
            userid: user.id,
            deliveryState: 'Preparing',
            deliveryType: _listAddressOptions[_selectedIndex],
            deliveryAddress: _listAdressText[_selectedIndex],
            deliveryDate: _selectedDate,
            deliveryTime: _selectedHour,
            deliveryNote: _notTextController.text,
            cart: cartItems,
            cartTotal: cartTotal,
            orderDateTime: DateTime.now(),
            faturaTuru: _selectedBillingMethod,
            faturaBireysel: user.faturaBireysel,
            faturaKurumsal: user.faturaKurumsal);

        //send order to db
        orderResult = await OrdersApiClient().addOrder(newOrder);

        if (orderResult) {
          //remove cartItems from cart!
          showSnackBar(context: context, msg: 'Siparişiniz başarıyla alındı!', type: 'success');
          cartItems = [];
          UserApiClient().updateProductsOnUserCart(mAuth.currentUser!.uid, cartItems);
          Future.delayed(
            const Duration(seconds: 2),
            () => Navigator.of(context).popUntil(ModalRoute.withName("/HomePage")),
          );
        } else {
          showSnackBar(context: context, msg: 'Birşeyler yanlış gitti!', type: 'error');
        }
      }
    } else {
      showSnackBar(context: context, msg: 'Sözleşmeyi onaylamalısınız!', type: 'error');
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
          'Siparişi Tamamla',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: InkWell(
        onTap: () => orderResult ? null : addOrder(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Teslimat Yöntemi
            Padding(
              padding: UiHelper.allPadding3x,
              child: Text('Teslimat Yöntemi', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
            ),
            Material(
              elevation: 2,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listAddressOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile(
                      title: Padding(
                        padding: UiHelper.topPadding2x,
                        child: Text(
                          _listAddressOptions[index],
                          style: textTheme.subtitle2!,
                        ),
                      ),
                      subtitle: Padding(
                        padding: UiHelper.verticalSymmetricPadding2x,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  MdiIcons.mapMarkerOutline,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                Text(
                                  _listAddressTitle[index],
                                  style: textTheme.button,
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _listAdressText[index],
                              style: textTheme.button!.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'En yakın teslimat',
                                  style: textTheme.caption!.copyWith(color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  hourText,
                                  style: textTheme.button!.copyWith(color: UiColorHelper.mainGreen),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      value: index,
                      groupValue: _selectedIndex,
                      onChanged: (value) {
                        setState(() {
                          _selectedIndex = value!;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            //Teslimat Saati
            Padding(
              padding: UiHelper.allPadding3x,
              child: Text('Teslimat Saati', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
            ),
            Container(
              color: Colors.white,
              width: width,
              child: Padding(
                padding: UiHelper.allPadding3x,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedDate),
                        Text(
                          hourText,
                          style: textTheme.button!.copyWith(color: UiColorHelper.mainGreen),
                        ),
                      ],
                    ),
                    ReusableButtonOutlined(
                      text: 'text',
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft, child: CartChangeDeliveryTime(selectedDate: _selectedDate, selectedHour: _selectedHour, function: showDateTimeData)))
                            .then((value) {
                          print(value);
                        });
                      },
                      color: UiColorHelper.mainBlue,
                      widthPercent: 0.30,
                    ),
                  ],
                ),
              ),
            ),
            //Ödeme Yöntemi
            Padding(
              padding: UiHelper.allPadding3x,
              child: Text('Ödeme Yöntemi', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: UiHelper.verticalSymmetricPadding2x,
                child: RadioListTile(
                  value: 0,
                  groupValue: _selectedIndexPayment,
                  onChanged: (value) {},
                  title: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kartım HalkBank',
                            style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '543081**********12',
                            style: textTheme.button!.copyWith(color: Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          'assets/images/mastercard.png',
                        ),
                      ),
                      const Spacer(),
                      ReusableButtonOutlined(
                        text: 'Değiştir',
                        onPressed: () {},
                        widthPercent: 0.25,
                        color: UiColorHelper.mainBlue,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //Not Ekle
            Padding(
              padding: UiHelper.allPadding3x,
              child: Text('Not Ekle', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: UiHelper.allPadding2x,
                child: ReusableTextField(controller: _notTextController),
              ),
            ),
            //Özet
            Padding(
              padding: UiHelper.allPadding3x,
              child: Text('Özet', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: UiHelper.horizontalSymmetricPadding3x,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: UiHelper.verticalSymmetricPadding1x,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Fatura Bilgilerim'),
                          Text(' ($_selectedBillingMethod)', style: TextStyle(color: UiColorHelper.mainGreen)),
                          const Spacer(),
                          ReusableButtonOutlined(
                            text: 'Değiştir',
                            color: UiColorHelper.mainBlue,
                            widthPercent: 0.25,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft, child: CartChangeBillingInfo(selectedBillingMethod: _selectedBillingMethod, function: onChangedSelectedBillingMethod)));
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 2),
                    Padding(
                      padding: UiHelper.verticalSymmetricPadding2x,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ürünler'),
                          Text('${cartTotal.toStringAsFixed(2)} TL'),
                        ],
                      ),
                    ),
                    const Divider(height: 2),
                    Padding(
                      padding: UiHelper.verticalSymmetricPadding2x,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Teslimat Ücreti'),
                          Text(
                            'Ücretsiz',
                            style: TextStyle(color: UiColorHelper.mainRed),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 2),
                    Padding(
                      padding: UiHelper.verticalSymmetricPadding2x,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Toplam Tutar'),
                          Text(
                            '${cartTotal.toStringAsFixed(2)} TL',
                            style: const TextStyle(color: UiColorHelper.mainBlue),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 2),
                    Padding(
                      padding: UiHelper.verticalSymmetricPadding4x,
                      child: CheckboxListTile(
                        value: checked,
                        onChanged: (value) {
                          setState(() {
                            checked = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.all(0),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Ön Bilgilendirme Formu ve Mesafeli Satış Sözleşmesi', style: textTheme.button!.copyWith(color: UiColorHelper.mainBlue)),
                              TextSpan(text: '\'ni okudum, onaylıyorum.', style: textTheme.button!),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Masterpass info
            Padding(
              padding: UiHelper.allPadding3x,
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.60,
                    child: Text(
                      'Kart bilgileriniz MasterPass güvencesiyle saklanmaktadır. ',
                      style: textTheme.button!.copyWith(color: Colors.grey),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: width * 0.20,
                    child: Image.asset('assets/images/masterpass.png'),
                  ),
                ],
              ),
            ),
            //Empty Box
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
