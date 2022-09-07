import 'package:apikicker/Common/color_settings.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        // Appbar
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          title: const Text(
            '検索',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: const Center(
            child: Icon(Icons.search, color: Colors.yellow, size: 80)));
  }
}