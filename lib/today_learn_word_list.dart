import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

class TodayLearnWordListPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TodayLearnWordListPageState();
}

class _TodayLearnWordListPageState extends State<TodayLearnWordListPage> {
  @override
  Widget build(BuildContext context) {

    Widget backSection = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
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

    Widget todayLearnWordTextSection = Container(
      margin: const EdgeInsets.only(left: 10.0),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03),
      child: const Text(
        '오늘 학습한 단어 목록',
        style: TextStyles.xxLargeTextStyle,
      ),
    );
    
    Widget wordListSection = Container(
      height: MediaQuery.of(context).size.height*0.53,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.separated(
          itemBuilder: ((context, index) {
            return Row(
                children: [
                  Text(
                    '굳이',
                    style: TextStyles.regular00TextStyle,
                  ),
                  Text(
                    '[구지]',
                    style: TextStyles.regularGreenTextStyle,
                  ),
                  Spacer(flex: 2,),
                  Chip(
                    label: Text(
                      "구개음화",
                      style: TextStyles.small00TextStyle,
                    ),
                    backgroundColor: ColorStyles.saeraBlue,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                    child: IconButton(
                        onPressed: null,
                        icon: SvgPicture.asset(
                          'assets/icons/star_fill.svg',
                          fit: BoxFit.scaleDown,
                        )
                    ),
                  )
                ],

            );
          }),
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(thickness: 1, height: 3,);
          },
          itemCount: 10
      ),
    );

    Widget retryLearnButtonSection = Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height*0.02,
        left: MediaQuery.of(context).size.width*0.04,
        right: MediaQuery.of(context).size.width*0.04
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 6,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ]
      ),
      child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            side: const BorderSide(
              width: 1.0,
              color: Colors.transparent,
            ),
            backgroundColor: Colors.white
          ),
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.023),
            child: const Text(
              '다시 학습',
              style: TextStyles.mediumRecordTextStyle,
              textAlign: TextAlign.center,
            ),
          )
      ),
    );

    Widget goMainPageSection = Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height*0.01,
        left: MediaQuery.of(context).size.width*0.04,
        right: MediaQuery.of(context).size.width*0.04
      ),
      child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorStyles.saeraOlive1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            side: const BorderSide(
              width: 1.0,
              color: ColorStyles.saeraOlive1,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.023),
            child: const Text(
              '메인 화면으로',
              style: TextStyles.mediumWhiteBoldTextStyle,
              textAlign: TextAlign.center,
            ),
          )
      ),
    );

    return Container(
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*0.15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      backSection,
                      todayLearnWordTextSection
                    ],
                  ),
                )
            ),
            body: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                wordListSection,
                retryLearnButtonSection,
                goMainPageSection
              ],
            ),
          ),
        )
    );
  }

}