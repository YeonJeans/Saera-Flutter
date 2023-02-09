import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/learn/accent_learn/presentation/accent_learn_screen.dart';
import 'package:saera/learn/search_learn/presentation/widgets/response_statement.dart';
import 'package:saera/learn/search_learn/presentation/widgets/search_learn_background.dart';
import 'package:http/http.dart' as http;

import '../../../server.dart';
import '../../../style/color.dart';
import '../../../style/font.dart';

class SearchPage extends StatefulWidget {

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<dynamic>? statement;
  final List<ChipData> _chipList = [];
  List<String> placeList = ["병원", "회사", "편의점", "카페", "은행", "옷가게", "음식점"];

  late TextEditingController _textEditingController;
  var value = Get.arguments;

  bool _visibility = false;

  void _setVisibility() {
    setState(() {
      _chipList.isNotEmpty ? _visibility = true : _visibility = false;
    });
  }

  void _addChip(var chipText) {
    setState(() {
      if (value != null) {
        _chipList.add(ChipData(
            id: DateTime.now().toString(),
            name: chipText,
            color: {placeList.contains(chipText) ? ColorStyles.saeraBlue : ColorStyles.saeraBeige}
        ));
        statement = searchStatement(chipText.toString(), "tag");
      } else {
        Container();
      }
      _setVisibility();
    });
  }

  void _deleteChip(String id) {
    setState(() {
      _chipList.removeWhere((element) => element.id == id);
      //칩 리스트를 하나씩 불러와서 url에 태그를 넣는 방법을 찾아야함!!
      _setVisibility();
    });
  }

  void _deleteAllChip() {
    for (ChipData data in _chipList) {
      var index = _chipList.indexOf(data);
      for (int i = 0; i <= index; i++) {
        _deleteChip(data.id);
      }
      break;
    }
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

  Future<List<Statement>> searchStatement(String input, String choose) async {
    List<Statement> _list = [];
    late var url;
    if (choose == "content") {
      url = Uri.parse('$serverHttp/statements?content=$input');
    } else if (choose == "tag") {
      url = Uri.parse('$serverHttp/statements?tags=$input');
    } else {
      throw Exception("태그 검색 오류");
    }

    final response = await http.get(url);
    if (response.statusCode == 200) {

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      if (_list.isEmpty) {
        for (dynamic i in body) {
          int id = i["statement_id"];
          String content = i["content"];
          List<String> tags = List.from(i["tags"]);
          bool bookmarked = i["bookmarked"];
          _list.add(Statement(id: id, content: content, tags: tags, bookmarked: bookmarked));
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

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    statement = searchStatement("", "content");
    _addChip(value);
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
                label: const Padding(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Text(' 뒤로',
                    style: TextStyles.backBtnTextStyle,
                    textAlign: TextAlign.center,
                  ),
                )
            )
          ],
        ),
    );

    Widget searchSection = Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                autofocus: true,
                controller: _textEditingController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))
                ],
                maxLines: 1,
                onSubmitted: (s) {
                  setState(() {
                    statement = searchStatement(s, "content");
                  });
                },
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
      ),
    );


    Widget chipSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
            spacing: 8.0,
            children: _chipList.map((chip) => Chip(
              labelPadding: const EdgeInsets.only(left: 8.0, right: 4.0, bottom: 2.0),
              labelStyle: TextStyles.small00TextStyle,
              label: Text(
                chip.name,
              ),
              backgroundColor: chip.color.first,
              onDeleted: () => _deleteChip(chip.id),
            )).toList()
        ),
        Visibility(
          visible: _visibility,
          child: IconButton(
            onPressed: () => {
              if (_chipList.isNotEmpty) {
                _deleteAllChip(),
                statement = searchStatement("", "content"),
              } else {
                Container(),
              }
            },
            icon: SvgPicture.asset('assets/icons/refresh.svg', color: ColorStyles.totalGray,),
          ),
        )
      ],
    );

    Widget statementSection = FutureBuilder(
        future: statement,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              List<Statement> statements = snapshot.data;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                    itemBuilder: ((context, index) {
                      Statement statement = statements[index];
                      return ListTile(
                          contentPadding: EdgeInsets.only(left: 11),
                          onTap: () => Get.to(AccentPracticePage(id: statement.id)),
                          title: Transform.translate(
                            offset: const Offset(0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        statement.content,
                                        style: TextStyles.regular00TextStyle
                                    ),
                                    Row(
                                      children: statement.tags.map((tag) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 4),
                                          child: Chip(
                                            label: Text(tag),
                                            labelStyle: TextStyles.small00TextStyle,
                                            backgroundColor: selectTagColor(tag)
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                                IconButton(
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
                              ],
                            ),
                          )
                      );
                    }),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(thickness: 1,);
                    },
                    itemCount: statements.length
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
        SearchLearnBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  children: <Widget>[
                    appBarSection,
                    searchSection,
                    chipSection,
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

class ChipData {
  final String id;
  final String name;
  final Set<Color> color;
  ChipData({required this.id, required this.name, required this.color});
}