import 'package:flutter/material.dart';

import '../../style/font.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '수연';
  
  @override
  Widget build(BuildContext context) {

    Widget greetingTextSection = Container(
      margin: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height*0.10,
          left: MediaQuery.sizeOf(context).width*0.63
      ),
      child: Text(
        '$name 님,\n 어서 오세요!',
        style: TextStyles.xLarge25TextStyle,
        textAlign: TextAlign.right,
      ),
    );

    Widget studyTextSection = Container(
      margin: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height*0.185,
          left: MediaQuery.sizeOf(context).width*0.60
      ),
      child: Text(
        '오늘은 무엇을 학습할까요?',
        style: TextStyles.small25TextStyle,
        textAlign: TextAlign.right,
      ),
    );

    Widget container = Container(
      margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height*0.27),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffd9d9d9),
            blurRadius: 30.0,
            offset: Offset(0, -3)
          )
        ]
      ),
    );

    return Stack(
      children: [
        SafeArea(
            child: Scaffold(
              backgroundColor: Color(0xffBBE0CE),
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  greetingTextSection,
                  studyTextSection,
                  container
                ],
              ),
            )
        )
      ],
    );
  }
}