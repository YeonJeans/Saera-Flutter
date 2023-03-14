import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/learn/pronounce_learn/pronounce_learn_screen.dart';
import 'package:saera/learn/search_learn/presentation/search_learn_screen.dart';
import 'package:saera/main.dart';
import 'package:saera/tabbar.dart';
import 'package:saera/learn/presentation/learn_screen.dart';

import 'package:http/http.dart' as http;
import 'package:saera/today_learn_word_list.dart';
import 'dart:convert';

import '../../learn/accent_learn/presentation/accent_todaylearn_screen.dart';
import '../../login/data/authentication_manager.dart';
import '../../login/data/refresh_token.dart';
import '../../server.dart';
import '../../style/font.dart';
import '../../style/color.dart';
import '../../today_learn_statement_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationManager _authManager = Get.find();

  List<int> wordList = [];
  List<int> statementList = [];

  String name = '수연';
  int todayWordLearnIdx = 0;
  int todayStatementLearnIdx = 0;

  int todayWordProgressIdx = 0;
  int todayStatementProgressIdx = 0;

  @override
  void initState() {
    if(_authManager.getTodayStatementIdx() == null){
      _authManager.saveTodayStatementIdx(0);
    }
    if(_authManager.getTodayWordIdx() == null){
      _authManager.saveTodayWordIdx(0);
    }

    todayWordProgressIdx = _authManager.getTodayWordIdx()!;
    todayStatementProgressIdx = _authManager.getTodayStatementIdx()!;

    getTodayWordList();
    getTodaySentenceList();
    super.initState();
  }

  getTodayWordList() async {
    await Future.delayed(const Duration(seconds: 1));
    var url = Uri.parse('${serverHttp}/today-list?type=WORD');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });

    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));

      wordList.clear();
      wordList = List.from(body);
      if(wordList[0] != todayWordLearnIdx){
        _authManager.saveTodayWordIdx(0);
      }
    }
    else if(response.statusCode == 401){
      String? before = _authManager.getToken();
      await RefreshToken(context);

      if(before != _authManager.getToken()){
        getTodayWordList();
      }
    }
  }

  getTodaySentenceList() async {
    await Future.delayed(const Duration(seconds: 1));
    var url = Uri.parse('${serverHttp}/today-list?type=STATEMENT');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });

    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      statementList.clear();
      statementList = List.from(body);
      if(statementList[0] != todayStatementLearnIdx){
        _authManager.saveTodayStatementIdx(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget imageSection = Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height*0.147,
        left: MediaQuery.of(context).size.width*0.05
      ),
      child: SvgPicture.asset('assets/images/home_image.svg'),
    );

    Widget greetingTextSection = Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height*0.07,
          left: MediaQuery.of(context).size.width*0.07
      ),
      child: Text(
        '$name 님,\n어서 오세요!',
        style: TextStyles.xLarge25TextStyle,
        textAlign: TextAlign.left,
      ),
    );

    Widget studyTextSection = Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height*0.1,
          left: MediaQuery.of(context).size.width*0.63
      ),
      child: const Text(
        '갑자일주 3월 10일 운세\n빨간색을 조심하세요',
        style: TextStyles.small25TextStyleWithHeight,
        textAlign: TextAlign.right,
      ),
    );

    Widget searchSection = Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04),
      //padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                readOnly: true,
                onTap: () {
                  TabBarMainPage.myTabbedPageKey.currentState?.tabController.animateTo(1);
                },
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset('assets/icons/search.svg', fit: BoxFit.scaleDown),
                  hintText: '무엇을 학습할까요?',
                  hintStyle: TextStyles.mediumAATextStyle,
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(99.0)),
                      borderSide: BorderSide(color: ColorStyles.searchFillGray)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(99.0)),
                    borderSide: BorderSide(color: ColorStyles.searchFillGray),
                  ),
                  filled: true,
                  fillColor: ColorStyles.searchFillGray,
                ),
              )
          )
        ],
      ),
    );

    Widget mostLearnTextSection = Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
      child: const Text(
        '가장 많이 학습한 문장 Top 5',
        style: TextStyles.medium25BoldTextStyle,
      ),
    );

    Container statementSection(String statement) {
      return Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.03),
        child: ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(8),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )
                )
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    statement,
                    style: TextStyles.regular25TextStyle,
                  ),
                  SvgPicture.asset('assets/icons/expand_right.svg'),
                ],
              ),
            )
        ),
      );
    }

    List<String> top5StatementList = [
      '화장실은 어디에 있나요?',
      '이건 얼마인가요?',
      '혹시 연세가 어떻게 되세요?',
      '아이스 아메리카노 한 잔 주세요.',
      '가게 마감시간은 언제인가요?'
    ];

    Widget top5StatementSection = Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
      child: CarouselSlider.builder(
        itemCount: 5,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height*0.09,
          initialPage: 0,
          aspectRatio: 6.0,
          enlargeCenterPage: true,
          autoPlay: true
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return statementSection(top5StatementList[index]);
        },
      ),
    );

    Widget todayRecommandSection = Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
      child: const Text(
        '오늘의 추천 학습',
        style: TextStyles.medium25BoldTextStyle,
      ),
    );

    Widget todayRecommandTextSection = Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015),
      child: const Text(
        '매일 새롭게 추천하는 5개의 단어와 문장으로\n빠르게 발음과 억양을 학습해요.',
        style: TextStyles.small55TextStyle,
      ),
    );

    Widget todayLearnSection = Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              onPressed: (){
                todayWordProgressIdx = _authManager.getTodayWordIdx()!;
                if(todayWordProgressIdx == 5){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const TodayLearnWordListPage(wordList: [], isTodayWord: true),
                  ));
                }
                else{
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PronouncePracticePage(idx: todayWordProgressIdx, isTodayLearn: true, wordList: wordList)
                  ));
                }
                //Get.to(PronouncePracticePage(idx: todayWordProgressIdx, isTodayLearn: true, wordList: wordList));
                },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(8),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )
                  )
              ),
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width*0.015,
                    right: MediaQuery.of(context).size.width*0.17
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.025)),
                    SvgPicture.asset('assets/icons/today_word.svg'),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015)),
                    const Text(
                      '오늘의\n단어 학습',
                      style: TextStyles.medium25TextStyle,
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.010)),
                    const Text(
                      '약 3분 소요',
                      style: TextStyles.tiny82TextStyle,
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.025)),
                  ],
                ),
              )
          ),
          ElevatedButton(
              onPressed: (){
                todayStatementProgressIdx = _authManager.getTodayStatementIdx()!;
                if(todayStatementProgressIdx == 5){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => TodayLearnStatementListPage(),
                  ));
                }else{
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AccentTodayPracticePage(idx: todayStatementProgressIdx, sentenceList: statementList)
                  ));
                }
                },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(8),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )
                  )
              ),
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width*0.015,
                    right: MediaQuery.of(context).size.width*0.17
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.025)),
                    SvgPicture.asset('assets/icons/today_statement.svg'),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015)),
                    const Text(
                      '오늘의\n문장 학습',
                      style: TextStyles.medium25TextStyle,
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.010)),
                    const Text(
                      '약 5분 소요',
                      style: TextStyles.tiny82TextStyle,
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.025)),
                  ],
                ),
              )
          )
        ],
      ),
    );

    Widget container = Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),
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
      child: Container(
        child: ListView(
          children: [
            searchSection,
            mostLearnTextSection,
            top5StatementSection,
            todayRecommandSection,
            todayRecommandTextSection,
            todayLearnSection,
          ],
        ),
      )
    );

    return Stack(
      children: [
        Container(
          color: Color(0xffBBE0CE),
        ),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  greetingTextSection,
                  studyTextSection,
                  container,
                  imageSection,
                ],
              ),
            )
        )
      ],
    );
  }
}