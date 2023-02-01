import 'package:flutter/material.dart';

void main() {
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok_Clone',
      theme: ThemeData(
        primaryColor: const Color(0xFFE9435A),
      ),
      home: Container(),
    );
  }
}
