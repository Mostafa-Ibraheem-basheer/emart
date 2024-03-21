import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:badges/badges.dart';

import '../widgets/cartDrawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variable to store the total cost
  num currentTotal = 0;
  num total = 0;

  @override
  Widget build(BuildContext context) {
    // //reset the total cost whenever the drawer widget is disposed or built
    // total = total - currentTotal;
    // //assign new total cost
    // currentTotal = total;
    // //get data from argument
    Map data = {};
    data.addAll(
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>);
    //add saved cart items
    List cart = data['cart'];
    //get total cost of items
    // for (int i = 0; i < cart.length; i++) {
    //   total = total + cart[i]['cost'];
    // }
    //
    // setState(() {
    //   //reset the total cost whenever the drawer widget is disposed or built
    //   total = total - currentTotal;
    //   //assign new total cost
    //   currentTotal = total;
    // });
    //get products list from data
    List products = data['products'];
    return Scaffold(
      backgroundColor: Colors.white,
      ////////////////////////////cart/////////////////////////////////////////
      endDrawer: cart.isEmpty
          ? Drawer(
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/empty.png'), // Path to your image
                            fit: BoxFit.contain,
                          )),
                      child: Column(children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                      'My cart',
                      style: TextStyle(fontFamily: 'Nyoh', fontSize: 25),
                 ),
                ),
              ]
            ),
                    ),
                  )
          )
        )
          : CartDrawer(
              cart: cart,
              products: products,
              currentTotal: currentTotal,
              total: total,
            ),
      appBar: AppBar(
        //'Builder' is necessary so that the IconButton gets the context underneath the Scaffold.
        // Without that, it would instead be using the context of the App and therefore wouldn't be able to find the Scaffold.
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Badge(
                showBadge: cart.isEmpty ? false : true,
                badgeStyle: const BadgeStyle(
                    badgeColor: Color.fromARGB(255, 241, 107, 38)),
                badgeContent: Text(
                  cart.length.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Nyoh',
                    color: Colors.white,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 30,
                ),
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 241, 107, 38)),
        elevation: 0,
        title: const Text(
          'Emart',
          style: TextStyle(
            fontFamily: 'Nyoh',
            color: Colors.black,
          ),
        ),
      ),
      //////////////////////////Products/////////////////////////////
      body: ListView.builder(
        itemCount: products.length, // Number of items in the list
        itemBuilder: (context, index) {
          // itemBuilder will be called for each item in the list
          // 'index' represents the current item's position in the list
          return Column(
            children: [
              //
              Padding(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  tileColor: Colors.grey[100],
                  title: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        products[index]['name'],
                        style: const TextStyle(
                          fontSize: 25,
                          fontFamily: 'Nyoh',
                        ),
                      ),
                      const SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(products[index]['image']),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${products[index]['price']}EGP',
                          style: const TextStyle(
                            fontFamily: 'Nyoh',
                          ),
                        ),
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 241, 107, 38)),
                            onPressed: () async {
                              var random = Random();
                              int randomInt = random.nextInt(1001);
                              // Get current date and time
                              DateTime now = DateTime.now();
                              // Convert DateTime to a formatted string
                              String formattedDateTime =
                                  '${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}';
                              Map data = {
                                'id': randomInt.toString(),
                                'dateTime': formattedDateTime,
                                'name': products[index]['name'],
                                "prodId": products[index]['id'],
                                "quantity": 1,
                                "cost": products[index]['price']
                              };
                              try {
                                // Make the POST request
                                Response response = await post(
                                  Uri.parse('https://25ea-196-153-149-44.ngrok-free.app/cart'),
                                  headers: {
                                    'Content-Type':
                                        'application/json', // Specify content-type
                                  },
                                  body: jsonEncode(
                                      data), // Pass the encoded data as the request body
                                );

                                // Check if the request was successful (status code 200)
                                if (response.statusCode == 201) {
                                  setState(() {
                                    cart.add(data);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                            },
                            icon: const Icon(
                              Icons.shopping_cart,
                              size: 12,
                            ),
                            label: const Text(
                              'Add',
                              style: TextStyle(fontFamily: 'Nyoh'),
                            ))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/product',
                        arguments: {'product': products[index], 'cart': cart});
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Divider(
                  thickness: 1,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
