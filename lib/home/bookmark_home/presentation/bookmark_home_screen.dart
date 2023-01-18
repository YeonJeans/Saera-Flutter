import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/home/bookmark_home/presentation/widgets/bookmark_home_background_image.dart';
import 'package:saera/home/bookmark_home/presentation/widgets/bookmark_list_tile.dart';
import 'package:saera/style/color.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  String userName = "수연";
  List<BookmarkListData> statement = [
    BookmarkListData('화장실은 어디에 있나요?', '질문'),
    BookmarkListData('아이스 아메리카노 한 잔 주세요.', '주문')
  ];

  @override
  Widget build(BuildContext context) {
    Widget textSection = Container(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Text(
        "$userName님이 즐겨찾기한\n문장들이에요.",
        style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: "NotoSansKR",
            fontWeight: FontWeight.bold),
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
