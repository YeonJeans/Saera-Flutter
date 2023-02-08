import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/home/bookmark_home/presentation/widgets/bookmark_home_background_image.dart';
import 'package:saera/style/font.dart';
import 'package:http/http.dart' as http;

import '../../../learn/accent_learn/presentation/accent_learn_screen.dart';
import '../../../learn/search_learn/presentation/widgets/response_statement.dart';
import '../../../server.dart';
import '../../../style/color.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  String userName = "수연";
  Future<dynamic>? statement1;

  Future<List<Statement>> searchStatement() async {
    List<Statement> _list = [];
    var url = Uri.parse('$serverHttp/statements');
    final response = await http.get(url);
    if (response.statusCode == 200) {

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      if (_list.isEmpty) {
        for (dynamic i in body) {
          if (i["bookmarked"] == true) {
            int id = i["statement_id"];
            String content = i["content"];
            List<String> tags = List.from(i["tags"]);
            bool bookmarked = i["bookmarked"];
            _list.add(Statement(id: id, content: content, tags: tags, bookmarked: bookmarked));
          }
        }
      }
      return _list;
    } else {
      throw Exception("데이터를 불러오는데 실패했습니다.");
    }
  }

  createBookmark (int id) async {
    var url = Uri.parse('${serverHttp}/statements/${id}/bookmark');
    final response = await http.post(url, headers: {'accept': 'application/json', "content-type": "application/json" });
    print("create : $response");
  }

  void deleteBookmark (int id) async {
    var url = Uri.parse('${serverHttp}/statements/bookmark/${id}');
    final response = await http.delete(url, headers: {'accept': 'application/json', "content-type": "application/json" });
    print("delete : $response");
  }

  Color selectTagColor(String tag) {
    if (tag == '질문') {
      return ColorStyles.saeraYellow;
    } else if (tag == '업무') {
      return ColorStyles.saeraKhaki;
    } else if (tag == '은행') {
      return ColorStyles.saeraBlue;
    } else {
      return ColorStyles.saeraBeige;
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
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Text(
        "$userName님이 즐겨찾기한\n문장들이에요.",
        style: TextStyles.xLargeTextStyle
      )
    );

    Widget bookmarkStatementSection = ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 20),
        itemBuilder: (BuildContext context, int index) {
          return BookmarkListTile(statement[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(thickness: 1,);
        },
        itemCount: statement.length
    );

    return Stack(
      children: [
        BookmarkBackgroundImage(key: null,),
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
