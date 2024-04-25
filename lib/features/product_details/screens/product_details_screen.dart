import 'package:carousel_slider/carousel_slider.dart';
import 'package:dalvi/common/widgets/custom_button.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/features/account/screens/account_screen.dart';
import 'package:dalvi/features/auth/screens/signin.dart';
import 'package:dalvi/features/cart/screens/cart_screen.dart';
import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:dalvi/features/product_details/screens/size_button.dart';
import 'package:dalvi/features/product_details/services/product_details_services.dart';
import 'package:dalvi/features/search/screens/search_screen.dart';
import 'package:dalvi/models/product.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  int defaultPrice = 500;
  int selectedIndex = 0;
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart(int index) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.token.isEmpty) {
      // User is not authenticated, navigate to SignInScreen
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    } else {
      // User is authenticated, proceed with adding to cart logic
      productDetailsServices
          .addToCart(
        context: context,
        product: widget.product,
        sizeIndex: index,
      )
          .then((_) {
        navigateToCartScreen();
        // Handle success or navigate to cart screen
      });
    }
  }

  void navigateToCartScreen() {
    Navigator.pushNamed(context, CartScreen.routeName);
  }

  final int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: widget.product.images.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '( ${widget.product.sizesAndPrices[selectedIndex]['size']} ) ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: GlobalVariables.specialGray,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Text(
                widget.product.sizesAndPrices.isNotEmpty
                    ? '₹ ${widget.product.sizesAndPrices[selectedIndex]['price']}'
                    : "500",
                style: const TextStyle(
                    color: GlobalVariables.specialColor, fontSize: 20),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Size: ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: GlobalVariables.specialGray),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: widget.product.sizesAndPrices.map((item) {
                  String size = item['size'] ?? ''; // Access the 'size' field
                  int price = item['price'] ?? 0; // Access the 'price' field
                  defaultPrice = price;
                  int index = widget.product.sizesAndPrices.indexOf(item);

                  return SizeButton(
                    text: ' $size ',
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    index: selectedIndex == index ? true : false,
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                text: 'Add to Cart',
                onTap: () {
                  addToCart(selectedIndex);
                },
                // color: GlobalVariables.customCyan,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(widget.product.description),
            ),
            const SizedBox(height: 8),
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
      selectedItemColor: Colors.black87,
      unselectedItemColor: Theme.of(context).primaryColorLight,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconSize: 28,
      onTap: (index) {
        performTap(index);
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
                      ? Colors.white
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
