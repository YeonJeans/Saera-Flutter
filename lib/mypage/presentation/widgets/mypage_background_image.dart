import 'package:flutter/material.dart';

class MyPageBackgroundImage extends StatelessWidget {
  const MyPageBackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:100.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topLeft,
          image: AssetImage('assets/images/top_bird.png'), // 배경 이미지
            scale: 0.9
        ),
        color: Color(0xffFFFFFF),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.topRight,
              image: AssetImage('assets/images/mypage_flower.png'),
              scale: 2
            // 배경 이미지
          ),
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }
}
