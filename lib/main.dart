import 'package:flutter/material.dart';
import 'package:search_list_project/country_list.dart';

void main() {
  runApp(const MyApp());
}
 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountryListScreen(),
    );
  }
}
