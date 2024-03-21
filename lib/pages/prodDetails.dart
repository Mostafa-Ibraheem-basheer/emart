import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProdDetails extends StatefulWidget {
  const ProdDetails({Key? key}) : super(key: key);

  @override
  State<ProdDetails> createState() => _ProdDetailsState();
}

class _ProdDetailsState extends State<ProdDetails> {
  //items added to cart
  num quantity = 1;
  @override
  Widget build(BuildContext context) {
    Map product =
        (ModalRoute.of(context)?.settings.arguments as Map)['product'];
    List cart = (ModalRoute.of(context)?.settings.arguments as Map)['cart'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          //update the home page and return
          onPressed: () async {
            // Return a result to the previous page when arrow button is tapped
            try {
              Response res =
                  await get(Uri.parse('https://25ea-196-153-149-44.ngrok-free.app/products'));
                  Navigator.pushReplacementNamed(context, '/home',
                  arguments: {'products': jsonDecode(res.body), 'cart': cart});
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
        ),
        backgroundColor: Colors.white,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 241, 107, 38)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              //Product images
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(product['image']),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontFamily: 'Nyoh',
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        product['rating'],
                        (index) => Icon(
                          Icons.star,
                          size: 15,
                          color: Colors.orange[200],
                        ),
                      ),
                    ),
                    Text(
                      '(${product['rating']} stars)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nyoh',
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  children: const [
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Nyoh',
                      ),
                    ),
                  ],
                ),
              ),
              //details of product
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  product['details'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nyoh',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Divider(
                  thickness: 1,
                ),
              ),
              //Price tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nyoh',
                          color: Colors.black),
                      children: [
                        const TextSpan(
                          text: 'Price: ',
                        ),
                        TextSpan(
                          text: '${product['price']}EGP',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 241, 107, 38)),
                        ),
                      ],
                    ),
                  ),
                  //Quantity
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (quantity == 1) {
                                return;
                              } else {
                                quantity--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                          color: const Color.fromARGB(255, 241, 107, 38),
                          iconSize: 15,
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Nyoh',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add),
                          color: const Color.fromARGB(255, 241, 107, 38),
                          iconSize: 15,
                        )
                      ],
                    ),
                  )
                ],
              ),
              //Add to cart
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 241, 107, 38)),
                          onPressed: () async {
                            // Get current date and time
                            DateTime now = DateTime.now();
                            // Convert DateTime to a formatted string
                            String formattedDateTime =
                                '${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}';
                            Map data = {
                              "dateTime": formattedDateTime,
                              'name': product['name'],
                              "prodId": product['id'],
                              "quantity": quantity,
                              "cost": product['price'] * quantity
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green[700],
                                    content: const Text(
                                      'Successfully Added to Cart!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Nyoh',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                                //update cart items
                                setState(() {
                                  cart.add(jsonDecode(response.body));
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green[700],
                                    content: Text(
                                      'failed with status: ${response.statusCode}',
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
                                  backgroundColor: Colors.green[700],
                                  content: Text(
                                    'Error: $e',
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
                            Icons.add_shopping_cart_outlined,
                            size: 16,
                          ),
                          label: const Text(
                            'Add Items to Cart',
                            style: TextStyle(fontFamily: 'Nyoh'),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
