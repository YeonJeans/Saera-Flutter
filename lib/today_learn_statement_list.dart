import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:saera/learn/search_learn/presentation/widgets/response_statement.dart';
import 'package:saera/server.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

import 'home/presentation/home_screen.dart';
import 'login/data/authentication_manager.dart';

class TodayLearnStatementListPage extends StatefulWidget {

  final List<int> sentenceList;

  const TodayLearnStatementListPage({Key? key, required this.sentenceList});

  @override
  State<StatefulWidget> createState() => _TodayLearnStatementListPageState();
}

class _TodayLearnStatementListPageState extends State<TodayLearnStatementListPage> {
  final AuthenticationManager _authManager = Get.find();

  Future<dynamic>? statement;

  Future<List<Statement>> getStatement() async {
    List<Statement> statementList = [];
    String statement_id = "";
    for(int i = 0; i<widget.sentenceList.length; i++) {
      statement_id += 'idList=${widget.sentenceList[i]}&';
    }
    var url = Uri.parse('$serverHttp/complete?type=STATEMENT&$statement_id');
    print("url : $url");
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}"});
    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      for (dynamic i in body) {
        int id = i["id"];
        String content = i["content"];
        List<String> tags = List.from(i["tags"]);
        bool bookmarked = i["bookmarked"];
        statementList.add(Statement(id: id, content: content, tags: tags, bookmarked: bookmarked));
      }
    }
    return statementList;
  }

  Color selectTagColor(String tag) {
    if (tag == '일상' || tag == '소비' || tag == '인사' || tag == '은행/공공기관' || tag == '회사') {
      return ColorStyles.saeraBlue.withOpacity(0.5);
    } else if (tag == '의문문' || tag == '존댓말' || tag == '부정문' || tag == '감정 표현') {
      return ColorStyles.saeraBeige.withOpacity(0.5);
    } else {
      return ColorStyles.saeraYellow.withOpacity(0.5);
    }
  }

  createBookmark (int id) async {
    var url = Uri.parse('${serverHttp}/bookmark?type=STATEMENT&fk=$id');
    final response = await http.post(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
    print("create : $response");
  }

  deleteBookmark (int id) async {
    var url = Uri.parse('${serverHttp}/bookmark?type=STATEMENT&fk=$id');
    final response = await http.delete(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
    print("delete : $response");
  }

  @override
  void initState() {
    statement = getStatement();
    super.initState();
  }

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

    Widget wordListSection = FutureBuilder(
        future: statement,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                  child: LoadingAnimationWidget.waveDots(
                      color: ColorStyles.expFillGray,
                      size: 45.0
                  )
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                  child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                    child: const Text("서버 연결이 불안정합니다.", style: TextStyles.regular25TextStyle,),
                  )
              );
            } else {
              List<Statement> statements = snapshot.data;
              return Container(
                height: MediaQuery.of(context).size.height*0.53,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ListView.separated(
                    itemBuilder: ((context, index) {
                      Statement statement = statements[index];
                      return ListTile(
                        title: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            statement.content,
                            style: TextStyles.regular00TextStyle,
                          ),
                        ),
                        subtitle: Wrap(
                          spacing: 5,
                          children: statement.tags.map((tag) {
                            return Chip(
                                label: Text(tag),
                                labelStyle: TextStyles.small00TextStyle,
                                backgroundColor: selectTagColor(tag)
                            );
                          }).toList(),
                        ),
                        trailing: IconButton(
                            onPressed: (){
                              if(statement.bookmarked){
                                setState(() {
                                  statement.bookmarked = false;
                                });
                                deleteBookmark(statement.id);
                              }
                              else{
                                setState(() {
                                  statement.bookmarked = true;
                                });
                                createBookmark(statement.id);
                              }
                            },
                            icon: statement.bookmarked?
                            SvgPicture.asset(
                              'assets/icons/star_fill.svg',
                              fit: BoxFit.scaleDown,
                            )
                                :
                            SvgPicture.asset(
                              'assets/icons/star_unfill.svg',
                              fit: BoxFit.scaleDown,
                            )
                        )
                      );
                    }),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(thickness: 1, height: 3,);
                    },
                    itemCount: widget.sentenceList.length
                ),
              );
            }
          }
        }
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
          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage()), (route) => false),
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