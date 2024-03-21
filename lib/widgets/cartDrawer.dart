import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CartDrawer extends StatefulWidget {
  final List<dynamic> cart;
  final List<dynamic> products;
  final num currentTotal;
  final num total;

  const CartDrawer({
    required this.cart,
    required this.currentTotal,
    required this.products,
    required this.total,
    Key? key,
  }) : super(key: key);

  @override
  _CartDrawerState createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {

  late num currentTotal;
  late num total;
  late List<dynamic> cart;
  late List<dynamic> products;

  @override
  void initState() {
    super.initState();
    currentTotal = widget.currentTotal;
    total = widget.total;
    cart = widget.cart;
    products = widget.products;
  }

  @override
  Widget build(BuildContext context) {

    //get total cost of items
    for (int i = 0; i < cart.length; i++) {
      total = total + cart[i]['cost'];
    }

    setState(() {
      //reset the total cost whenever the drawer widget is disposed or built
      total = total - currentTotal;
      //assign new total cost
      currentTotal = total;
    });

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'My cart',
                style: TextStyle(fontFamily: 'Nyoh', fontSize: 25),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        // isThreeLine: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        tileColor: Colors.grey[100],
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(cart[index]['name'],
                              style: const TextStyle(
                                fontFamily: 'Nyoh',
                              )),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${cart[index]['dateTime']}',
                                style: const TextStyle(
                                  fontFamily: 'Nyoh',
                                )),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 5),
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Quantity: ${cart[index]['quantity']}',
                                        style: const TextStyle(
                                          fontFamily: 'Nyoh',
                                        )),
                                    Text('${cart[index]['cost']}EGP',
                                        style: const TextStyle(
                                          fontFamily: 'Nyoh',
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color.fromARGB(255, 241, 107, 38),
                          ),
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'details',
                              child: Text('Details',
                                  style: TextStyle(
                                    fontFamily: 'Nyoh',
                                  )),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Remove',
                                  style: TextStyle(
                                      fontFamily: 'Nyoh', color: Colors.red)),
                            ),
                            // Add more PopupMenuItems if needed
                          ],
                          onSelected: (String value) async {
                            // Handle menu item selection here
                            switch (value) {
                              case 'details':
                                Navigator.pushReplacementNamed(
                                    context, '/product', arguments: {
                                  'product': products[int.parse(cart[index]['prodId'])],
                                  'cart': cart
                                });
                                break;
                              case 'delete':
                                try {
                                  var response = await delete(Uri.parse(
                                      'https://25ea-196-153-149-44.ngrok-free.app/cart/${cart[index]['id']}'));
                                  if (response.statusCode == 200) {
                                    setState(() {
                                      cart.removeAt(index);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red[700],
                                        content: Text(
                                          'Error: Server Responded with ${response.statusCode}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Nyoh',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red[700],
                                      content: Text(
                                        'Error: $e \nRestarting Might help',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Nyoh',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                break;
                            // Add cases for other menu options if needed
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Nyoh',
                        color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'Total: ',
                      ),
                      TextSpan(
                        text: '${currentTotal}EGP',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 241, 107, 38)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}