import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/learn/accent_learn/presentation/accent_learn_screen.dart';
import 'package:saera/learn/custom_learn/create_sentence/presentation/create_sentence_screen.dart';
import 'package:saera/learn/search_learn/presentation/widgets/response_statement.dart';
import 'package:saera/learn/search_learn/presentation/widgets/search_learn_background.dart';
import 'package:http/http.dart' as http;

import '../../../../server.dart';
import '../../../../style/color.dart';
import '../../../../style/font.dart';


class LearnStatementPage extends StatefulWidget {

  @override
  State<LearnStatementPage> createState() => _LearnStatementPageState();
}

class _LearnStatementPageState extends State<LearnStatementPage> {
  Future<dynamic>? statement;
  List<String> tagList = []; //서버에서 넘겨받을 리스트
  final List<ChipData> _chipList = [];
  int? _selectedIndex;

  late TextEditingController _textEditingController;
  var value = Get.arguments;

  bool _chipSectionVisibility = false;
  bool _categorySectionVisibility = false;

  bool checkChipList(String categoryName) {
    bool isExist = false;
    for(int i = _chipList.length-1; i >= 0; i--) { //리스트 검사해서
      if (_chipList[i].name == categoryName) { //버튼 눌렀을 때 이름이 같은게 있으면
        isExist = true;
        break;
      } else {
        isExist = false;
      }
    }
    return isExist;
  }

  void _setChipSectionVisibility() {
    setState(() {
      _chipList.isNotEmpty ? _chipSectionVisibility = true : _chipSectionVisibility = false;
    });
  }

  void _setCategorySectionVisibility() {
    setState(() {
      _selectedIndex != null ? _categorySectionVisibility = true : _categorySectionVisibility = false;
    });
  }

  void _setTypeVisibility(String categoryName) {
    bool isTypeCategorySelected = false;
    setState(() {
      if (_chipList.isEmpty) {
        _addChip(categoryName);
      }
      for(int i = _chipList.length-1; i >= 0; i--) {
        if (_chipList[i].name == categoryName) {
          isTypeCategorySelected = true;
          return;
        } else {
          isTypeCategorySelected = false;
        }
      }
      if (isTypeCategorySelected == false) {
        _addChip(categoryName);
        isTypeCategorySelected = true;
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
            color: {tagList.contains(chipText) ? ColorStyles.saeraBlue : ColorStyles.saeraBeige}
        ));
      } else {
        Container();
      }
      _setChipSectionVisibility();
    });
  }

  void _deleteChip(String id) {
    setState(() {
      _chipList.removeWhere((element) => element.id == id);
      _setChipSectionVisibility();
    });
  }

  void _deleteAllChip() {
    for (int i = _chipList.length-1; i >= 0; i--) {
      _deleteChip(_chipList[i].id);
    }
  }

  void createBookmark (int id) async {
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
                onSubmitted: null, //수정
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset('assets/icons/search.svg', fit: BoxFit.scaleDown),
                  hintText: 'OO님이 만든 문장 내에서 검색합니다.',
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

    List<String> filterList = ['태그'];
    Widget filterSection = Wrap(
        spacing: 7,
        children: List.generate(filterList.length, (index) {
          return ChoiceChip(
            label: Text(filterList[index]),
            labelStyle: TextStyles.small25TextStyle,
            avatar: _selectedIndex == index ? SvgPicture.asset('assets/icons/filter_up.svg') : SvgPicture.asset('assets/icons/filter_down.svg'),
            selectedColor: ColorStyles.saeraBlue,
            backgroundColor: Colors.white,
            side: BorderSide(color: ColorStyles.disableGray),
            selected: _selectedIndex == index,
            onSelected: (bool selected) {
              setState(() {
                _selectedIndex = selected ? index : null;
                _setCategorySectionVisibility();
              });
            },
          );
        }).toList()
    );

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
              Opacity(
                opacity: checkChipList(categoryName) ? 1.0 : 0.5,
                child: Text(
                  categoryName,
                  style: TextStyles.small00TextStyle,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.01),),
              Visibility(
                  visible: checkChipList(categoryName) ? true : false,
                  child: SvgPicture.asset('assets/icons/click_check.svg')
              )
            ],
          ),
        ),
      );
    }

    Widget selectCategorySection = Visibility(
        visible: _categorySectionVisibility,
        child: _selectedIndex == 0
            ? Container(
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
                  selectStatementCategory('태그1'),
                  selectStatementCategory('태그2'),
                  selectStatementCategory('태그3'),
                  selectStatementCategory('태그4'),
                  selectStatementCategory('태그5'),
                ],
              )
            )
            : Container()
    );

    Widget chipSection = Visibility(
        visible: _chipSectionVisibility,
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
                } else {
                  Container(),
                }
              },
              icon: SvgPicture.asset('assets/icons/refresh.svg', color: ColorStyles.totalGray,),
            ),
          ],
        )
    );

    Container notExistStatement() {
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset('assets/icons/box_open.svg'),
              Padding(padding: EdgeInsets.all(4)),
              const Text(
                '아직 생성한 문장이 없습니다.\n화면 우측 하단의 + 버튼을 눌러\n직접 학습할 문장을 생성해 보세요.',
                style: TextStyles.regular82TextStyleWithHeight,
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      );
    }

    Container existStatement(List<Statement> statements) {
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
              if (statements.isEmpty) {
                return notExistStatement();
              } else {
                return existStatement(statements);
              }
            }
          } else {
            return Container();
          }
        })
    );

    Widget floatingButtonSection = FloatingActionButton(
      onPressed: () => Get.to(CreateSentenceScreen()),
      backgroundColor: ColorStyles.saeraAppBar,
      child: SvgPicture.asset('assets/icons/plus.svg'),
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
                      statementSection,
                    ],
                  ),
                ),
              floatingActionButton: floatingButtonSection,
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