import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isLoading = true;
  //Fetch products and cart items
  void getData() async {
    try {
      Response res1 =
          await get(Uri.parse('https://25ea-196-153-149-44.ngrok-free.app/products'));
      Response res2 = await get(Uri.parse('https://25ea-196-153-149-44.ngrok-free.app/cart'));
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'products': jsonDecode(res1.body),
        'cart': jsonDecode(res2.body)
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  //invoke the fetch method after initializing the state
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(child: Image.asset('assets/logo.png'))
            : Center(
                child: const Text(
                'Failed to Fetch',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Nyoh',
                ),
              )));
  }
}
