import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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

  Future<List<Statement>> searchStatement() async {
    List<Statement> _list = [];
    var url = Uri.parse('$serverHttp/statements');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
    if (response.statusCode == 200) {

      var body = jsonDecode(utf8.decode(response.bodyBytes));
      _list.clear();
      if (_list.isEmpty) {
        for (dynamic i in body) {
          if (i["bookmarked"] == true) {
            int id = i["id"];
            String content = i["content"];
            List<String> tags = List.from(i["tags"]);
            bool bookmarked = i["bookmarked"];
            bool recommended = i["recommended"];
            _list.add(Statement(id: id, content: content, tags: tags, bookmarked: bookmarked, recommended: recommended, ));
          }
        }
      }
      print("_list : $_list");
      return _list;
    } else {
      throw Exception("데이터를 불러오는데 실패했습니다.");
    }
  }

  createBookmark (int id) async {
    var url = Uri.parse('$serverHttp/bookmark?type=STATEMENT&fk=$id');
    final response = await http.post(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
    print("create : $response");
  }

  void deleteBookmark (int id) async {
    var url = Uri.parse('$serverHttp/bookmark?type=STATEMENT&fk=$id');
    final response = await http.delete(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
    print("delete : $response");
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

  @override
  void initState() {
    super.initState();
    statement1 = searchStatement();
  }

  @override
  Widget build(BuildContext context) {
    Widget textSection = Container(
      padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
      child: Text(
        "${_authManager.getName()}님이 즐겨찾기한\n문장들이에요.",
        style: TextStyles.xxLargeTextStyle
      )
    );

    Widget bookmarkStatementSection = FutureBuilder(
        future: statement1 = searchStatement(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              List<Statement>? statements = snapshot.data;
              return Container(
                padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
                height: MediaQuery.of(context).size.height*0.72,
                child: ListView.separated(
                    itemBuilder: ((context, index) {
                      Statement statement = statements[index];
                      return InkWell(
                          onTap: () => Get.to(AccentPracticePage(id: statement.id)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 3),
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
                                              backgroundColor: selectTagColor(tag)
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
                                      deleteBookmark(statement.id);
                                      statement1 = searchStatement();
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
              );
            }
          } else {
            return Container();
          }
        })
    );

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
                children: <Widget>[
                  textSection,
                  bookmarkStatementSection
                ],
              ),
            )
        )
      ],
    );
  }
}
