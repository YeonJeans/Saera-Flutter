import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/learn/search_learn/presentation/widgets/search_learn_background.dart';

import '../../../home/bookmark_home/presentation/widgets/bookmark_list_tile.dart';
import '../../../style/color.dart';
import '../../../style/font.dart';

class SearchPage extends StatefulWidget {

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget appBarSection = Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent
                ),
                icon: SvgPicture.asset(
                  'assets/icons/back.svg',
                ),
                label: Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: const Text(' 뒤로',
                    style: TextStyles.backBtnTextStyle,
                    textAlign: TextAlign.center,
                  ),
                )
            )
          ],
        ),
    );

    Widget searchSection = Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                autofocus: true,
                controller: _textEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset('assets/icons/search.svg', fit: BoxFit.scaleDown),
                  hintText: '어떤 문장을 학습할까요?',
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
    );

    List<BookmarkListData> statement = [
      BookmarkListData('화장실은 어디에 있나요?', '질문'),
      BookmarkListData('아이스 아메리카노 한 잔 주세요.', '주문')
    ];
    Widget statementSection = ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10),
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
        SearchLearnBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  children: <Widget>[
                    appBarSection,
                    searchSection,
                    statementSection
                  ],
                ),
              )
            )
        )
      ],
    );

  }
}