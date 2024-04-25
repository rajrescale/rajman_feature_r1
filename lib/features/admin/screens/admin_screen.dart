import 'package:dalvi/features/admin/screens/analytics_screen.dart';
import 'package:dalvi/features/admin/screens/orders_screen.dart';
import 'package:dalvi/features/admin/screens/posts_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomNavigationBarWidth = 50;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PostsScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/dalviFarm.jpg',
                    height: 40,
                    width: 40,
                    fit: BoxFit
                        .cover, // Ensure the image fills the circular shape
                  ),
                ),
              ),
              const Text(
                'Admin',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // Post
          BottomNavigationBarItem(
            tooltip: "Products",
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: Text(
                'Home', // Text to display
                style: TextStyle(
                  // Add any text styling here
                  color: Theme.of(context).primaryColor,
                  fontSize: 13, // Adjust font size as needed
                ),
              ),
            ),
            label: '',
          ),
          // Analytics
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'Dashboard', // Text to display
                  style: TextStyle(
                    // Add any text styling here
                    color: Theme.of(context).primaryColor,
                    fontSize: 13, // Adjust font size as needed
                  ),
                ),
              ),
            ),
            label: '',
          ),
          //Order
          BottomNavigationBarItem(
            tooltip: "Orders",
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: Text(
                'Orders', // Text to display
                style: TextStyle(
                  // Add any text styling here
                  color: Theme.of(context).primaryColor,
                  fontSize: 13, // Adjust font size as needed
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
