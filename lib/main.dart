import 'package:emart/pages/loading.dart';
import 'package:emart/pages/prodDetails.dart';
import 'package:emart/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => const Home(),
      '/product': (context) => const ProdDetails(),
    },
  ));
}
