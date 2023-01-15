import 'package:flutter/material.dart';
import 'package:saera/style/font.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("마이페이지"),
    );
  }
}
