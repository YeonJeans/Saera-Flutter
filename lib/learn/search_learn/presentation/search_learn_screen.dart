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
  List<String> situationList = ["일상", "소비", "인사", "은행/공공기관", "회사"];
  List<String> statementTypeList = ["의문문", "존댓말", "부정문", "감정 표현"];
  int? _selectedIndex;

  late TextEditingController _textEditingController;
  var value = Get.arguments;

  bool _visibility = false;
  bool _tagVisibility = false;
  bool _checkVisibility = false;

  void _setVisibility() {
    setState(() {
      _chipList.isNotEmpty ? _visibility = true : _visibility = false;
    });
  }

  void _setTagVisibility() {
    setState(() {
      _selectedIndex != null ? _tagVisibility = true : _tagVisibility = false;
    });
  }

  void checkSituationCategorySelected(String categoryName) {
    bool isSituationCategorySelected = false;
    setState(() {
      for (int i = _chipList.length-1; i >= 0; i--) {
        for (int j = 0; j < situationList.length; j++) {
          if (_chipList[i].name == situationList[j]) {
            isSituationCategorySelected = true;
            break;
          }
        }
      }
      if (isSituationCategorySelected == false) {
        _addChip(categoryName);
        isSituationCategorySelected == true;
      }
    });
  }

  void _setTypeVisibility(String categoryName) {
    bool isTypeCategorySelected = false; //카테고리네임이랑 동일한 태그가 리스트에 있는가를 검사하는 변수
    setState(() {
      if (_chipList.isEmpty) { //리스트가 비어있으면 처음이니까 칩 추가
        _addChip(categoryName);
        _checkVisibility = true;
      }
      for(int i = _chipList.length-1; i >= 0; i--) { //리스트 검사해서
        if (_chipList[i].name == categoryName) { //버튼 눌렀을 때 이름이 같은게 있으면
          isTypeCategorySelected = true; //이미 있음을 표시
          return;
        } else {
          isTypeCategorySelected = false;
        }
      }
      if (isTypeCategorySelected == false) { //얘가 위에 검사 뚫고 false면 리스트에 없다는 뜻
        _addChip(categoryName); //추가해
        isTypeCategorySelected = true;
        _checkVisibility = true;
      } else {
        return;
      }
    });
  }

  void _addChip(var chipText) {
    setState(() {
      if (value != null) {
        _chipList.add(ChipData(
            id: DateTime.now().toString(),
            name: chipText,
            color: {situationList.contains(chipText) ? ColorStyles.saeraBlue : ColorStyles.saeraBeige}
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
      statement = searchStatement("", "content");
      _setVisibility();
    });
  }

  void _deleteAllChip() {
    for (int i = _chipList.length-1; i >= 0; i--) {
      _deleteChip(_chipList[i].id);
    }
    _checkVisibility = false;
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
                    color: ColorStyles.backIconGreen
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

    List<String> filterList = ['상황', '문장 유형'];
    Widget filterSection = Container(
      child: Wrap(
          spacing: 7,
          children: List.generate(filterList.length, (index) {
            return ChoiceChip(
              label: Text(filterList[index]),
              labelStyle: TextStyles.small25TextStyle,
              avatar: _selectedIndex == index ? SvgPicture.asset('assets/icons/filter_up.svg') : SvgPicture.asset('assets/icons/filter_down.svg'),
              selectedColor: filterList[index] == "상황" ? ColorStyles.saeraBlue : ColorStyles.saeraBeige,
              backgroundColor: Colors.white,
              side: BorderSide(color: ColorStyles.disableGray),
              selected: _selectedIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedIndex = selected ? index : null;
                  _setTagVisibility();
                });
              },
            );
          }).toList()
      ),
    );

    InkWell selectSituationCategory(String icon, String categoryName) {
      return InkWell(
        onTap: () {
          checkSituationCategorySelected(categoryName);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height*0.01,
            horizontal: MediaQuery.of(context).size.width*0.02
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              Padding(padding: EdgeInsets.only(top: 3)),
              Text(
                categoryName,
                style: TextStyles.tiny55TextStyle,
              )
            ],
          ),
        ),
      );
    }

    InkWell selectStatementCategory(String categoryName) {
      return InkWell(
        onTap: () {
          setState(() {
            _setTypeVisibility(categoryName);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width*0.18,
          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.2),
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.003),
          child: Row(
            children: [
              Text(
                categoryName,
                style: TextStyles.small00TextStyle,
              ),
              Padding(padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.01),),
              Visibility(
                  visible: _checkVisibility,
                  child: SvgPicture.asset('assets/icons/click_check.svg')
              )
            ],
          ),
        ),
      );
    }

    Widget selectCategorySection = Visibility(
        visible: _tagVisibility,
        child: _selectedIndex == 0
            ? Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height*0.01,
                horizontal: MediaQuery.of(context).size.width*0.038
            ),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.005),
            decoration: const BoxDecoration(
              color: ColorStyles.tagGray,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                selectSituationCategory('assets/icons/conservation.svg', '일상'),
                selectSituationCategory('assets/icons/order.svg', '소비'),
                selectSituationCategory('assets/icons/greeting.svg', '인사'),
                selectSituationCategory('assets/icons/public.svg', '은행/공공기관'),
                selectSituationCategory('assets/icons/company.svg', '회사'),
              ],
            )
        )
            : Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height*0.02,
                horizontal: MediaQuery.of(context).size.width*0.06
            ),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.005),
            decoration: const BoxDecoration(
              color: ColorStyles.tagGray,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Wrap(
              children: [
                selectStatementCategory('의문문'),
                selectStatementCategory('존댓말'),
                selectStatementCategory('부정문'),
                selectStatementCategory('감정 표현'),
              ],
            )
        )
    );

    Widget chipSection = Visibility(
      visible: _visibility,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.75,
              height: MediaQuery.of(context).size.height*0.05,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                  )
                ]
              ),
            ),
            IconButton(
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
          ],
        )
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
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                    filterSection,
                    selectCategorySection,
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