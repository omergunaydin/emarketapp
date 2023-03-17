import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/pages/account/account_main_page.dart';
import 'package:emarketapp/pages/cart/cart_page.dart';
import 'package:emarketapp/pages/main/main_page.dart';
import 'package:emarketapp/pages/product/product_list_tabs.dart';
import 'package:emarketapp/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import 'product/product_search.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  late int _initialIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _initialIndex = 0;
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    void changeSelectedIndex(int i) {
      //print('alttan gelen $i');

      setState(() {
        _pageController.jumpToPage(i);
        _initialIndex = i;
        print(_initialIndex);
        if (i < 5) CustomBottomNavigationBar.globalKey.currentState!.changeTabSelectedIndex(i);
      });
    }

    void changeSelectedInitialIndex(int i) {
      setState(() {
        _initialIndex = i;
      });
    }

    return Scaffold(
      backgroundColor: UiColorHelper.mainBackGround,
      appBar: CustomAppBar(width: width, height: height, selectedIndex: _initialIndex),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex, function: changeSelectedIndex),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          MainPage(function: changeSelectedIndex, function2: changeSelectedInitialIndex),
          ProductSearch(),
          Container(
            color: Colors.blue,
          ),
          CartPage(),
          AccountPageMain(),
          ProductListTabs(initialIndex: _initialIndex),
        ],
      ),
    );
  }
}
