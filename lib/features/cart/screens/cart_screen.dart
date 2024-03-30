import 'package:dalvi/common/widgets/custom_button.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/features/account/screens/account_screen.dart';
import 'package:dalvi/features/address/screens/address_screen.dart';
import 'package:dalvi/features/cart/widgets/cart_product.dart';
import 'package:dalvi/features/cart/widgets/cart_subtotal.dart';
import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:dalvi/features/home/widgets/address_box.dart';
import 'package:dalvi/features/product_details/screens/product_details_screen.dart';
import 'package:dalvi/features/search/screens/search_screen.dart';
import 'package:dalvi/models/product.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }

  int _page = 2;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Mango...',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                  text: 'Proceed to Buy (${user.cart.length} items)',
                  onTap: () => navigateToAddress(sum),
                  color: GlobalVariables.customCyan),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(height: 5),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final productMap = user.cart[index]['product'];
                final product = Product.fromMap(productMap);
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailScreen.routeName,
                        arguments: product);
                  },
                  child: CartProduct(
                    index: index,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(context, userCartLen),
    );
  }

  BottomNavigationBar buildBottomNavigation(
      BuildContext context, int userCartLen) {
    return BottomNavigationBar(
      currentIndex: _page,
      selectedItemColor: GlobalVariables.selectedNavBarColor,
      unselectedItemColor: GlobalVariables.unselectedNavBarColor,
      backgroundColor: GlobalVariables.backgroundColor,
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
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
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
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBarBorderWidth,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                performTap(1);
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
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBarBorderWidth,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {},
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
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
        break;
    }
  }
}
