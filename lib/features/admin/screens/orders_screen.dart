import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dalvi/features/order_details/screens/order_details.dart';
import 'package:dalvi/models/order.dart';
import 'package:dalvi/common/widgets/loader.dart';
import 'package:dalvi/features/admin/services/admin_services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  String showStatus = "";
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
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
    return orders == null
        ? const Loader()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: List.generate(
                  orders!.length,
                  (index) {
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
                        showStatus = " ";
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
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Order ID :',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  orders![index].id,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.75)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Order Date :',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  DateFormat().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        orders![index].orderedAt),
                                  ),
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.75)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount :',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  '₹ ${orders![index].totalPrice}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.75)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Last Update :',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      showStatus,
                                      style: const TextStyle(
                                          color: Colors.black87),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        formatTimeDifference(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                orders![index].lastUpdate)),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.75)),
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
            ),
          );
  }
}
