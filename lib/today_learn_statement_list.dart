import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

class TodayLearnStatementListPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TodayLearnStatementListPageState();
}

class _TodayLearnStatementListPageState extends State<TodayLearnStatementListPage> {
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
        '오늘 학습한 문장 목록',
        style: TextStyles.xxLargeTextStyle,
      ),
    );

    Widget wordListSection = Container(
      height: MediaQuery.of(context).size.height*0.53,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: ListView.separated(
          itemBuilder: ((context, index) {
            return ListTile(
              //디자인이 못생겨서 수정할 가능성이 큼...
              title: Text(
                '화장실은 어디에 있나요?',
                style: TextStyles.regular00TextStyle,
              ),
              subtitle: Wrap(
                spacing: 5,
                children: [
                  Chip(
                    label: Text(
                      '의문문',
                      style: TextStyles.small00TextStyle,
                    ),
                  ),
                  Chip(
                    label: Text(
                      '존댓말',
                      style: TextStyles.small00TextStyle,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                  onPressed: null,
                  icon: SvgPicture.asset(
                    'assets/icons/star_fill.svg',
                    fit: BoxFit.scaleDown,
                  )
              ),
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
              style: TextStyles.mediumSTextStyle,
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
            backgroundColor: ColorStyles.saeraRed,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            side: const BorderSide(
              width: 1.0,
              color: ColorStyles.saeraRed,
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