
import './shared/custom_bottomAppBar.dart';
import './bookmark_page.dart';
import './order_page.dart';
import './home_page.dart';
import 'package:flutter/material.dart';

class SharedBottomAppBar extends StatefulWidget {
  @override
  _SharedBottomAppBarState createState() => _SharedBottomAppBarState();
}

class _SharedBottomAppBarState extends State<SharedBottomAppBar> {
  Widget _lastSelected = HomePage();

  String _title = 'Home';
  List<Widget> pages = [
    OrderPage(),
    BookmarkPage(),
    HomePage(),
  ];
  List<String> titles = ['My Orders', 'Bookmarked', 'Home'];

  void _selectedTab(int index) {
    setState(() {
      print(index);
      _lastSelected = pages[index];
      _title = titles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _lastSelected,
      bottomNavigationBar: CustomBottomAppBar(
        color: Colors.grey,
        selectedColor: Theme.of(context).accentColor,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          BottomAppBarItem(iconData: Icons.more_horiz, text: 'More'),
          BottomAppBarItem(iconData: Icons.card_travel, text: 'My Orders'),
          BottomAppBarItem(iconData: Icons.favorite, text: 'Favourite'),
          BottomAppBarItem(iconData: Icons.home, text: 'Home'),
        ],
      ),
    );
  }
}
