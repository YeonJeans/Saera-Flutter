import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:saera/style/font.dart';
import 'package:http/http.dart' as http;

import '../../../learn/accent_learn/presentation/accent_learn_screen.dart';
import '../../../learn/search_learn/presentation/widgets/response_statement.dart';
import '../../../login/data/authentication_manager.dart';
import '../../../server.dart';
import '../../../style/color.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final AuthenticationManager _authManager = Get.find();

  Future<dynamic>? statement1;
  Future<dynamic>? word1;
  int _selectedIndex = 1;

  Future<List<Statement>> getStatement(int _selectedIndex) async {
    List<Statement> _list = [];
    var url;
    if (_selectedIndex == 1) {
      url = Uri.parse('$serverHttp/statements?bookmarked=true');
    } else {
      url = Uri.parse('$serverHttp/customs?bookmarked=true');
    }
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });

    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      for (dynamic i in body) {
        int id = i["id"];
        String content = i["content"];
        List<String> tags = List.from(i["tags"]);
        bool bookmarked = i["bookmarked"];
        bool recommended = i["recommended"];
        _list.add(Statement(id: id, content: content, tags: tags, bookmarked: bookmarked, recommended: recommended, ));
      }
      return _list;
    } else {
      print(response.body);
      return throw Exception("북마크 서버 문장 로딩 오류");
    }
  }

  Future<List<Word>> getWord(int _selectedIndex) async {
    List<Word> wordList = [];
    var url = Uri.parse('$serverHttp/words?bookmarked=true');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });

    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      for (dynamic i in body) {
        int id = i["id"];
        String notation = i["notation"];
        String pronunciation = i["pronunciation"];
        String tag = i["tag"];
        bool bookmarked = i["bookmarked"];
        wordList.add(Word(id: id, notation: notation, pronunciation: pronunciation, tag: tag, bookmarked: bookmarked));
      }
      return wordList;
    } else {
      print(response.body);
      return throw Exception("북마크 서버 단어 로딩 오류");
    }
  }

  void deleteBookmark (int id, int _selectedIndex) async {
    var url;
    if (_selectedIndex == 0) {
      url = Uri.parse('$serverHttp/bookmark?type=WORD&fk=$id');
    } else if (_selectedIndex == 1) {
      url = Uri.parse('$serverHttp/bookmark?type=STATEMENT&fk=$id');
    } else {
      url = Uri.parse('$serverHttp/bookmark?type=CUSTOM&fk=$id');
    }

    final response = await http.delete(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
    print("delete : $response");
  }

  Color selectTagColor(String tag) {
    if (tag == '일상' || tag == '소비' || tag == '인사' || tag == '은행/공공기관' || tag == '회사') {
      return ColorStyles.saeraPink2;
    } else if (tag == '의문문' || tag == '존댓말' || tag == '부정문' || tag == '감정 표현') {
      return ColorStyles.saeraBeige;
    } else {
      return ColorStyles.saeraYellow.withOpacity(0.5);
    }
  }

  Color selectWordTagColor(String tag) {
    if (tag == '구개음화') {
      return ColorStyles.saeraBlue.withOpacity(0.5);
    } else if (tag == "ㄴ첨가") {
      return ColorStyles.saeraKhaki.withOpacity(0.5);
    } else if (tag == '두음법칙') {
      return ColorStyles.saeraPink3.withOpacity(0.5);
    } else if (tag == '치조마찰음화') {
      return ColorStyles.saeraYellow.withOpacity(0.5);
    } else if (tag == '단모음화') {
      return ColorStyles.saeraOlive1.withOpacity(0.5);
    } else {
      return ColorStyles.saeraBeige.withOpacity(0.5);
    }
  }

  @override
  void initState() {
    super.initState();
    statement1 = getStatement(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    Widget textSection = Container(
      padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
      child: Text(
        "${_authManager.getName()}님이 즐겨찾기한\n문장들이에요.",
        style: TextStyles.xxLargeTextStyle
      )
    );

    List<String> filterList = ['발음', '억양', '사용자 정의'];
    Widget filterSection = Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height*0.02,
        left: 10.0,
        right: 10.0
      ),
      child: Wrap(
          spacing: 7,
          children: List.generate(filterList.length, (index) {
            return ChoiceChip(
              label: Text(filterList[index]),
              labelStyle: TextStyles.small25TextStyle,
              selectedColor: ColorStyles.saeraBeige,
              backgroundColor: Colors.white,
              side: _selectedIndex == index ? BorderSide(color: Colors.transparent) : BorderSide(color: ColorStyles.disableGray),
              visualDensity: VisualDensity(horizontal: 0.0, vertical: -2),
              selected: _selectedIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedIndex = selected ? index : _selectedIndex;
                });
              },
            );
          }).toList()
      ),
    );

    Widget bookmarkStatementSection(){
      return FutureBuilder(
          future: statement1 = getStatement(_selectedIndex),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child: Container(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                        child: LoadingAnimationWidget.waveDots(
                            color: ColorStyles.expFillGray,
                            size: 45.0
                        )
                    )
                );
              } else {
                List<Statement>? statements = snapshot.data;
                return Container(
                  padding: EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
                  height: MediaQuery.of(context).size.height*0.65,
                  child: RefreshIndicator(
                    onRefresh: () async => (
                        setState(() {
                          statement1 = getStatement(_selectedIndex);
                        })
                    ),
                    child: ListView.separated(
                        itemBuilder: ((context, index) {
                          Statement statement = statements[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AccentPracticePage(id: statement.id, isCustom: false),
                              ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Text(
                                          statement.content,
                                          style: TextStyles.regular00TextStyle
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      child: Wrap(
                                        spacing: 7.0,
                                        children: statement.tags.map((tag) {
                                          return Chip(
                                              label: Text(tag),
                                              labelStyle: TextStyles.small00TextStyle,
                                              backgroundColor: selectTagColor(tag),
                                              visualDensity: const VisualDensity(vertical: -4),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        statement.bookmarked = false;
                                      });
                                      deleteBookmark(statement.id, _selectedIndex);
                                      statement1 = getStatement(_selectedIndex);
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/icons/star_fill.svg',
                                      fit: BoxFit.scaleDown,
                                    )
                                )
                              ],
                            ),
                          );
                        }),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(thickness: 1,);
                        },
                        itemCount: statements!.length
                    ),
                  )
                );
              }
            } else {
              return Container();
            }
          })
      );
    }

    Widget bookmarkWordSection() {
      return FutureBuilder(
          future: word1 = getWord(_selectedIndex),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child: Container(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                        child: LoadingAnimationWidget.waveDots(
                            color: ColorStyles.expFillGray,
                            size: 45.0
                        )
                    )
                );
              } else {
                List<Word>? words = snapshot.data;
                return Container(
                    padding: EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
                    height: MediaQuery.of(context).size.height*0.65,
                    child: RefreshIndicator(
                      onRefresh: () async => (
                          setState(() {
                            word1 = getWord(_selectedIndex);
                          })
                      ),
                      child: ListView.separated(
                          itemBuilder: ((context, index) {
                            Word word = words[index];
                            return InkWell(
                              onTap: null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    word.notation,
                                    style: TextStyles.regular00TextStyle,
                                  ),
                                  Text(
                                    '[${word.pronunciation}]',
                                    style: TextStyles.regularGreenTextStyle,
                                  ),
                                  Spacer(flex: 2,),
                                  Chip(
                                    label: Text(
                                      word.tag,
                                      style: TextStyles.small00TextStyle,
                                    ),
                                    backgroundColor: selectWordTagColor(word.tag),
                                    visualDensity: const VisualDensity(vertical: -4),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                                    child: IconButton(
                                        onPressed: (){
                                          setState(() {
                                            word.bookmarked = false;
                                          });
                                          deleteBookmark(word.id, _selectedIndex);
                                          word1 = getWord(_selectedIndex);
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/star_fill.svg',
                                          fit: BoxFit.scaleDown,
                                        )
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(thickness: 1,);
                          },
                          itemCount: words!.length
                      ),
                    )
                );
              }
            } else {
              return Container();
            }
          })
      );
    }

    Widget listSection() {
      if (_selectedIndex == 0) {
        return bookmarkWordSection();
      } else {
        return bookmarkStatementSection();
      }
    }

    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    textSection,
                    filterSection,
                    listSection()
                  ],
                ),

            )
        )
      ],
    );
  }
}

class Word {
  final int id;
  final String notation;
  final String pronunciation;
  final String tag;
  bool bookmarked;
  Word({required this.id, required this.notation, required this.pronunciation, required this.tag, required this.bookmarked});
}