import 'package:dalvi/features/account/services/account_services.dart';
import 'package:dalvi/features/account/widgets/orders.dart';
import 'package:dalvi/features/auth/services/auth_service.dart';
import 'package:dalvi/features/cart/screens/cart_screen.dart';
import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:dalvi/features/account/widgets/below_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

int _page = 1;
double bottomBarWidth = 42;
double bottomBarBorderWidth = 5;

class AccountScreen extends StatefulWidget {
  static const String routeName = '/account';
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>().user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color:Colors.amber,
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
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        AccountServices()
                            .logOut(context); //mongodb remove token
                        AuthService.logout();
                      },
                      child: const Tooltip(
                        message: "Logout",
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.logout_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            BelowAppBar(),
            SizedBox(height: 10),
            // TopButtons(),
            SizedBox(height: 20),
            Orders(),
          ],
        ),
      ),
      bottomNavigationBar: userProvider.token.isNotEmpty
          ? buildBottomNavigation(context, userProvider.cart.length)
          : null,
    );
  }

  BottomNavigationBar buildBottomNavigation(
      BuildContext context, int userCartLen) {
    return BottomNavigationBar(
      currentIndex: _page,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColorLight,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconSize: 28,
      onTap: (index) {
        if (index != _page) {
          performTap(index);
        }
      },
      items: [
        // HOME
        BottomNavigationBarItem(
          icon: Container(
            width: bottomBarWidth,
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
            child: GestureDetector(
              onTap: () {
                performTap(0);
              },
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
          ),
          label: '',
        ),
        // ACCOUNT
        BottomNavigationBarItem(
          icon: Container(
            width: bottomBarWidth,
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
            child: GestureDetector(
              onTap: () {
                //performTap(1);
              },
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
          ),
          label: '',
        ),
        // CART
        BottomNavigationBarItem(
          icon: Container(
            width: bottomBarWidth,
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
            child: GestureDetector(
              onTap: () {
                performTap(2);
              },
              child: userCartLen > 0
                  ? Center(
                      child: badges.Badge(
                        badgeContent: Text(
                          userCartLen.toString(),
                        ),
                        position:
                            badges.BadgePosition.topEnd(top: -15, end: -15),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Colors.white,
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.shopping_cart_outlined,
                    ),
            ),
          ),
          label: '',
        ),
      ],
    );
  }

  void performTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
        break;
    }
  }
}
