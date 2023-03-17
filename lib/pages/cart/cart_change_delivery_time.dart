import 'package:emarketapp/constants/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'cart_change_delivery_time_today_tab.dart';
import 'cart_change_delivery_time_tomorrow_tab.dart';

class CartChangeDeliveryTime extends StatefulWidget {
  String selectedDate;
  String selectedHour;
  Function function;
  CartChangeDeliveryTime({Key? key, required this.selectedDate, required this.selectedHour, required this.function}) : super(key: key);

  @override
  State<CartChangeDeliveryTime> createState() => _CartChangeDeliveryTimeState();
}

class _CartChangeDeliveryTimeState extends State<CartChangeDeliveryTime> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  String today = '';
  String tomorrow = '';

  @override
  void initState() {
    initDateTimeData();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  initDateTimeData() async {
    await initializeDateFormatting('tr_TR', null);
    DateTime now = DateTime.now();
    today = DateFormat('d MMM EEEE', 'tr').format(now);
    DateTime second = now.add(const Duration(days: 1));
    tomorrow = DateFormat('d MMM EEEE', 'tr').format(second);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teslimat Saati',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Material(
            color: UiColorHelper.mainYellow.withAlpha(100),
            child: TabBar(
              onTap: (value) {
                _tabController.index = value;
                _pageController.animateToPage(value, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
              },
              controller: _tabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bugün', style: textTheme.button),
                      Text(today, style: textTheme.button!.copyWith(color: Colors.black54)),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Yarın', style: textTheme.button),
                      Text(tomorrow, style: textTheme.button!.copyWith(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                PageToday(selectedDate: widget.selectedDate, selectedHour: widget.selectedHour, function: widget.function),
                PageTomorrow(selectedDate: widget.selectedDate, selectedHour: widget.selectedHour, function: widget.function),
              ],
              onPageChanged: (index) {
                _tabController.animateTo(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
