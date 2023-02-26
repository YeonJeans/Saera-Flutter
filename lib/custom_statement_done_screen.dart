import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

import 'learn/accent_learn/presentation/widgets/accent_learn_background_image.dart';

class CustomDonePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Widget checkIconSection = Container(
      padding: EdgeInsets.only(top: 300.0),
      child: SvgPicture.asset('assets/icons/check_round_fill.svg', fit: BoxFit.scaleDown,),
    );

    Widget doneSection = Container(
      padding: EdgeInsets.only(top: 36.0),
      child: const Text(
        "문장이 생성되었어요!\n'학습 - 사용자 정의 문장 학습/생성'에서\n방금 만든 문장을 학습할 수 있어요.",
        style: TextStyles.large25TextStyle,
        textAlign: TextAlign.center,
      ),
    );

    Widget goLearnPageSection = Container(
      padding: EdgeInsets.only(top: 185.0),
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          side: const BorderSide(
            width: 1.0,
            color: ColorStyles.primary,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: const Text(
            '학습 화면으로',
            style: TextStyles.mediumBlueBoldTextStyle,
            textAlign: TextAlign.center,
          ),
        )
      ),
    );

    Widget goAccentPageSection = Container(
      padding: EdgeInsets.only(top: 9.0),
      child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorStyles.primary,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            side: const BorderSide(
              width: 1.0,
              color: ColorStyles.primary,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: const Text(
              '바로 학습',
              style: TextStyles.mediumWhiteBoldTextStyle,
              textAlign: TextAlign.center,
            ),
          )
      ),
    );

    return Stack(
      children: [
        const AccentPracticeBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  checkIconSection,
                  doneSection,
                  goLearnPageSection,
                  goAccentPageSection
                ],
              ),
            )
        )
      ],
    );
  }
}