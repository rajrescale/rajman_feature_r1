import 'package:dalvi/common/widgets/loader.dart';
import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/features/account/services/account_services.dart';
import 'package:dalvi/features/order_details/screens/order_details.dart';
import 'package:dalvi/models/order.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  // int status = 0;
  String showStatus = "";
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.token.isNotEmpty) {
      orders = await accountServices.fetchMyOrders(context: context);
      setState(() {});
    } else {
      showSnackBar(context, "Not Authenticated");
    }
  }

  String formatTimeDifference(DateTime previousTime) {
    Duration difference = DateTime.now().difference(previousTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'second' : 'seconds'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.user.token.isNotEmpty
        ? orders == null
            ? const Loader() // Show loader while fetching orders
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: const Text(
                            'Your Orders ',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: Text(
                            ' ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // display orders
                    orders!.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Text("Empty"),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 20,
                              right: 10,
                            ),
                            child: ListView.builder(
                              shrinkWrap:
                                  true, // Added shrinkWrap to make ListView take only the space it needs
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: orders!.length,
                              itemBuilder: (context, index) {
                                switch (orders![index].status) {
                                  case 0:
                                    showStatus = "Order Placed ";
                                    break;
                                  case 1:
                                    showStatus = "Payment Received ";
                                    break;
                                  case 2:
                                    showStatus = "Delivered ";
                                    break;
                                  // case 3:
                                  //   showStatus = "Complaint ";
                                  //   break;
                                  // case 4:
                                  //   showStatus = "Cancelled ";
                                  //   break;
                                  // case 5:
                                  //   showStatus = "Refunded ";
                                  //   break;
                                  default:
                                    showStatus = "";
                                    break;
                                }
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      OrderDetailScreen.routeName,
                                      arguments: orders![index],
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order ID :',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            Text(
                                              orders![index].id,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order Date :',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            Text(
                                              DateFormat().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        orders![index]
                                                            .orderedAt),
                                              ),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total Amount :',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            Text(
                                              '₹ ${orders![index].totalPrice}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              ' ',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  showStatus,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorLight,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  formatTimeDifference(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          orders![index]
                                                              .lastUpdate)),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .primaryColorLight,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              )
        : const Text("Not authenticated");
  }
}
