import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        SafeArea(
            child: Scaffold(
              backgroundColor: Color(0xffBBE0CE),
              resizeToAvoidBottomInset: false,
              body: Container(),
            )
        )
      ],
    );
  }
}