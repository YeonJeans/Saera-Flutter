import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/learn/presentation/accent_main_screen.dart';
import 'package:saera/learn/presentation/pronunciation_main_screen.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';
import 'package:saera/tabbar.dart';

import '../custom_learn/learn_sentence/presentation/learn_statement_screen.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    Widget backSection = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
            onPressed: (){
              TabBarMainPage.myTabbedPageKey.currentState?.tabController.animateTo(0);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
              fit: BoxFit.scaleDown,
              color: ColorStyles.backIconGreen,
            ),
            label: const Text(' 뒤로',
                style: TextStyles.backBtnTextStyle
            )
        ),
      ],
    );

    Widget whatLearnSection = Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05, left: 10, right: 10),
      child: const Text(
        '무엇을 학습할까요?',
        style: TextStyles.xLarge25TextStyle,
      ),
    );

    Widget whatLearnTextSection = Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03, left: 10, right: 10),
      child: const Text(
        '발음 학습으로 단어를 따라 읽으며 올바른 남한 표준어 발음을,\n문장 학습으로 자연스러운 문장표현과 억양을 익힐 수 있어요.',
        style: TextStyles.littleBit25TextStyleHeight,
      ),
    );

    Widget customButtonSection = InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => LearnStatementPage(),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height*0.01,
        ),
        decoration: BoxDecoration(
            color: ColorStyles.customGreen,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.customGreen.withOpacity(0.25),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 8),
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.023,
                  bottom: MediaQuery.of(context).size.height*0.023,
                  left: MediaQuery.of(context).size.width*0.04
              ),
              child: const Text(
                '내가 만든 문장 학습/문장 생성',
                style: TextStyles.medium00MediumTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05),
              child: SvgPicture.asset('assets/icons/custom_statement.svg'),
            )
          ],
        ),
      ),
    );

    Container buttonTitle(String text) {
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.032, left: MediaQuery.of(context).size.width*0.07),
        child: Text(
          text,
          style: TextStyles.large00MediumTextStyle,
        ),
      );
    }
    
    Container buttonDescription(String text) {
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.082, left: MediaQuery.of(context).size.width*0.07),
        child: Text(
          text,
          style: TextStyles.regular55TextStyle,
        ),
      );
    }

    Widget goAccentButtonSection = InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => AccentMainPage(),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: ColorStyles.saeraAccent,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.saeraAccent.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 8),
              )
            ]
        ),
        child: Stack(
          children: [
            buttonTitle('문장 억양 학습'),
            buttonDescription('자연스러운 표준어 표현과\n억양을 익혀요.'),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.077,
                    left: MediaQuery.of(context).size.width*0.562
                ),
                child: SvgPicture.asset('assets/icons/statement_button_1.svg')
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.155,
                  left: MediaQuery.of(context).size.width*0.43
              ),
              child: SvgPicture.asset('assets/icons/statement_button_2.svg'),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.055,
                    left: MediaQuery.of(context).size.width*0.61
                ),
                child: SvgPicture.asset('assets/icons/statement_button_1_1.svg')
            ),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.14,
                    left: MediaQuery.of(context).size.width*0.47
                ),
                child: SvgPicture.asset('assets/icons/statement_button_2_1.svg')
            ),
          ],
        ),
      ),
    );

    Widget goPronunciationButtonSection = InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => PronunciationMainPage(),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ColorStyles.saeraPronunciation,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.saeraPronunciation.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 8),
              )
            ]
        ),
        child: Stack(
          children: [
            buttonTitle('단어 발음 학습'),
            buttonDescription('단어를 따라 읽으며\n올바른 표준어 발음을 익혀요.'),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.077,
                  left: MediaQuery.of(context).size.width*0.574
              ),
              child: SvgPicture.asset('assets/icons/word_button_1.svg')
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.155,
                  left: MediaQuery.of(context).size.width*0.43
              ),
              child: SvgPicture.asset('assets/icons/word_button_2.svg'),
            ),
          ],
        ),
      ),
    );

    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*0.24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      backSection,
                      whatLearnSection,
                      whatLearnTextSection
                    ],
                  ),
                )
            ),
            body: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  customButtonSection,
                  goPronunciationButtonSection,
                  goAccentButtonSection,
                ],
              ),
            ),
          )
      ),
    );
  }
}

