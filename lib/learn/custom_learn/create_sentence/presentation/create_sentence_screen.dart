import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:saera/learn/custom_learn/create_sentence/presentation/custom_statement_done_screen.dart';
import 'package:saera/learn/custom_learn/create_sentence/presentation/widgets/check_badword.dart';
import 'package:saera/learn/custom_learn/create_sentence/presentation/widgets/subtitle_section.dart';
import 'package:http/http.dart' as http;

import 'package:saera/style/font.dart';
import 'package:saera/style/color.dart';

import '../../../../login/data/authentication_manager.dart';
import '../../../../login/data/user_info_controller.dart';
import '../../../../server.dart';

class CreateSentenceScreen extends StatefulWidget {
  const CreateSentenceScreen({Key? key}) : super(key: key);

  @override
  State<CreateSentenceScreen> createState() => _CreateSentenceScreenState();
}

class _CreateSentenceScreenState extends State<CreateSentenceScreen> {
  final AuthenticationManager _authManager = Get.find();
  final UserInfoController _userController = Get.find();

  final TextEditingController _textEditingController = TextEditingController();
  bool isComplete = false;
  bool isExist = true;
  bool whatClick = false; //다이얼로그 버튼 뭐 눌렀는지
  int inputFieldInfo = 0;
  String customStatement = "";

  //late ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();
  List<String> _tags = [];

  Future<int> createStatement() async {
    var url = Uri.parse('$serverHttp/customs');
    var data = {
      "content" : customStatement,
      "tags" : _tags,
      "setPublic" : whatClick
    };
    var body = json.encode(data);
    final response = await http.post(
        url,
        headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" },
        body: body
    );
    int customStatementId = 0;
    print(response.statusCode);
    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
        int id = body["id"];
        customStatementId = id;
    } else {
      throw Exception("커스텀 문자 생성 오류 발생");
    }
    return customStatementId;
  }

  Future<bool> checkDuplication(String content) async {
    var url = Uri.parse('$serverHttp/customs/check-unique?문장 내용=$content');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
    bool isDuplicate = false;
    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      isDuplicate = body["result"];
    }
    print("isDuplicate : $isDuplicate");
    return isDuplicate;
  }

  @override
  void initState() {
    if(_userController.getUserName() == ""){
      _userController.saveUserName(_authManager.getName()!);
    }

    super.initState();
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  Widget appBarSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
              color: ColorStyles.saeraAppBar,
              fit: BoxFit.scaleDown,
            ),
            label: const Text(' 뒤로',
                style: TextStyles.backBtnTextStyle
            )
        ),

      ],
    );
  }

  Widget titleLabelSection(){
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 36),
      child: const Text(
        "학습할 문장 생성",
        style: TextStyles.xxLargeTextStyle,
      ),
    );
  }

  Widget checkValidText(bool isCorrect, String desc){
    return Row(
      children: [
        (){
          if(isCorrect){
            return SvgPicture.asset('assets/icons/correct.svg');
          }
          else{
            return SvgPicture.asset('assets/icons/incorrect.svg');
          }
        }(),

        const SizedBox(width: 5),

        (){
          if(isCorrect){
            return Text(
              desc,
              style: TextStyles.smallGreenTextStyle,
            );
          }
          else{
            return Text(
              desc,
              style: TextStyles.smallRedTextStyle,
            );
          }
        }()
      ],
    );
  }

  Widget disableCreateBtn(){
    return Container(
        margin: const EdgeInsets.only(left: 14, right: 14, bottom: 15),
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorStyles.disableGray
      ),
      child: const Center(
        child: Text(
          "문장 생성",
          style: TextStyles.medium99BoldTextStyle,
        ),
      )
    );
  }

  Widget createBtn(){
    return GestureDetector(
      onTap: () async {
        // 비속어 검사 진행
        var check = await isBadWord(customStatement);
        print("check: $check");

        if(check){
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 18),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                title: const Center(
                  child: Text("\u{1f625}", style: TextStyles.xxxxLargeTextStyle),
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height*0.075- 2,
                  child: Column(
                    children: [
                      Text(
                        "문장 생성에 실패했어요!",
                        style: TextStyles.medium00MediumTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 18),
                        child: Text(
                          "비속어가 포함된 문장은 생성할 수 없어요.",
                          style: TextStyles.regular52LightTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(padding: EdgeInsets.all(4)),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                  fixedSize: Size(MediaQuery.sizeOf(context).width-70, 48),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  backgroundColor: ColorStyles.saeraAppBar
                              ),
                              child: const Text(
                                "다른 문장 생성",
                                style: TextStyles.mediumWhiteVeryBoldTextStyle,
                              )
                          ),
                          const Padding(padding: EdgeInsets.all(4))
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(4))
                    ],
                  )
                ],
              )
          );
        } else {
          Future<dynamic> state = checkDuplication(customStatement);
          state.then((result) {
            if (result == true) { //중복이 없다면
              showDialog(
                  context: context,
                  builder: (dialogContext) =>
                      AlertDialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 17),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        title: const Center(
                          child: Text("\u{1f389}",
                              style: TextStyles.xxxxLargeTextStyle),
                        ),
                        content: Container(
                          child: publicStatementDialogSection(),
                        ),
                        actions: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        whatClick = false;
                                        Future<int> id;
                                        id = createStatement();
                                        id.then((id) {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomDonePage(id: id,))
                                          );
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                          fixedSize: const Size(144, 48),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(12)
                                          ),
                                          backgroundColor: ColorStyles
                                              .searchFillGray
                                      ),
                                      child: const Text(
                                        "문장 비공개",
                                        style: TextStyles.medium52BoldTextStyle,
                                      )
                                  ),
                                  const Padding(padding: EdgeInsets.all(10)),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        whatClick = true;
                                        Future<int> id;
                                        id = createStatement();
                                        id.then((id) {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomDonePage(id: id,))
                                          );
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                          fixedSize: const Size(144, 48),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(12)
                                          ),
                                          backgroundColor: ColorStyles
                                              .saeraAppBar
                                      ),
                                      child: const Text(
                                        "문장 공개",
                                        style: TextStyles
                                            .mediumWhiteVeryBoldTextStyle,
                                      )
                                  )
                                ],
                              ),
                              const Padding(padding: EdgeInsets.all(4))
                            ],
                          )
                        ],
                      )
              );
            } else {
              whatClick = false;
              Future<int> id = createStatement();
              id.then((id) {
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => CustomDonePage(id: id,))
                );
              });
            }
          });
        }
      },
      child: Container(
          margin: const EdgeInsets.only(left: 14, right: 14, bottom: 15),
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorStyles.saeraAppBar,
            boxShadow:[
              BoxShadow(
                color: ColorStyles.black00.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 8), // changes position of shadow
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "문장 생성",
              style: TextStyles.mediumWhiteBoldTextStyle,
            ),
          )
      ),
    );
  }

  Widget enterText (){
    RegExp hannum = new RegExp(r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9|\s]*$');
    return Container(
      child: TextField(
        controller: _textEditingController,
        maxLines: 2,
        onChanged: (text){
          if(text.isNotEmpty){
            customStatement = text;
            if(!hannum.hasMatch(text)){
              setState(() {
                inputFieldInfo = 3;
                isComplete = false;
              });
            }
            else if (text.length > 50){
              setState(() {
                inputFieldInfo = 2;
                isComplete = false;
              });
            }
            else{
              setState(() {
                inputFieldInfo = 1;
                if(_tags.isNotEmpty){
                  isComplete = true;
                }
              });
            }

          }
          else {
            setState(() {
              inputFieldInfo = 0;
              isComplete = false;
            });
          }


        },
        decoration: const InputDecoration(
          hintText: '50자 이내의 한국어로 작성해 주세요.',
          hintStyle: TextStyles.mediumAATextStyle,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.transparent)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          filled: true,
          fillColor: ColorStyles.searchFillGray,
        ),
      )
    );
  }

  void _addTag() {
    String tag = _controller.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _controller.clear();
        if(inputFieldInfo == 1 && _tags.length == 1){
          isComplete = true;
        }
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      if(_tags.isEmpty){
        isComplete = false;
      }
    });
  }

  Widget enterTextSection(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorStyles.searchFillGray
      ),
      child: enterText(),
    );
  }

  Widget checkValidSection(){
    return  Container(
      height: 52,
      padding: EdgeInsets.only(top: 8, bottom: 20),
      child: (){
        if(inputFieldInfo == 1){
          return checkValidText(true, "생성 가능한 문장입니다.");
        }
        else if(inputFieldInfo == 2){
          return checkValidText(false, "문장이 너무 깁니다. 50자 이내로 적어주세요.");
        }
        else if(inputFieldInfo == 3){
          return checkValidText(false, "한글과 숫자만 입력 가능합니다.");
        }
      }(),
    );
  }

  Widget enterTag(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //SizedBox(width: 8.0),
        Container(
          width: MediaQuery.of(context).size.width - 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (String tag in _tags)
                    Padding(
                      padding:EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(tag),
                        onDeleted: () => _removeTag(tag),
                        backgroundColor: ColorStyles.saeraYellow.withOpacity(0.5),
                      ),
                    ),

                      (){
                    if(_tags.length == 3){
                      return const SizedBox(
                        width: 0,
                      );
                    }
                    else{
                      return SizedBox(
                        width: 280,
                        child: TextField(
                          enabled: _tags.length >= 3 ? false : true,
                          controller: _controller,
                          onSubmitted: (_) => _addTag(),
                          onTap: (){
                            // _scrollController.animateTo(120.0,
                            //     duration: Duration(milliseconds: 500),
                            //     curve: Curves.ease);
                          },
                          onChanged: (text){
                            if(text.contains(" ")){
                              _addTag();
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _tags.length < 3 ? "추가할 태그를 입력해 주세요." : "",
                            hintStyle: TextStyles.mediumAATextStyle,
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(color: Colors.transparent)
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
                          ],
                        ),
                      );
                    }
                  }(),

                ]

            ),
          ),
        )
      ],
    );
  }

  Widget enterTagSection(){
    return Container(
        height: 54,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorStyles.searchFillGray
        ),
        child: enterTag()
    );
  }

  Widget publicStatementDialogSection() {
    return Container(
      height: MediaQuery.of(context).size.height*0.23,
      child: Column(
        children: [
          Text(
            "${_userController.getUserName()}님이 이 문장을 생성한\n첫 번째 사용자네요!",
            style: TextStyles.medium00MediumTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
            child: Text(
              "문장을 공개하면 다른 사용자들도 ${_userController.getUserName()}님이 만든 문장을 학습할 수 있어요. 문장을 공개하시겠어요?",
              style: TextStyles.regular52LightTextStyle,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 14),
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "공개된 문장은 ",
                    style: TextStyles.regular52LightTextStyle
                  ),
                  TextSpan(
                    text: "'내가 만든 문장 학습 > 공개된 문장 탭'",
                    style: TextStyles.regularMintLightTextStyle
                  ),
                  TextSpan(
                    text: "에서 확인할 수 있어요.",
                    style: TextStyles.regular52LightTextStyle
                  ),
                ]
              )
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 14),
            child: const Text(
              "공개한 문장은 비공개로 변경하거나 삭제할 수 없어요.",
              style: TextStyles.regular52BoldTextStyle,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Stack(
      children: [
        SafeArea(
            child: GestureDetector(
              onTap: () {
                  FocusScope.of(context).unfocus();
                },
              child: Scaffold(
                  //primary: false,
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: appBarSection(),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  backgroundColor: Colors.white,
                  bottomSheet: Container(
                  child: isComplete ? createBtn() : disableCreateBtn(),
                  ),
                  body: SingleChildScrollView(
                    //controller: _scrollController,
                    child: Container(
                      margin: const EdgeInsets.only(left: 14, right: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          titleLabelSection(),

                          SubTitleSection(subtitle: "연습하고 싶은 문장을 입력하세요.", desc: "띄어쓰기와 맞춤법을 잘 지켜서 적어주세요."),
                          enterTextSection(),
                          checkValidSection(),

                          SubTitleSection(subtitle: "이 문장에 대한 태그를 추가해 주세요.", desc: "최대 3개의 태그를 달 수 있으며, 각각의 태그는 띄어쓰기로 구분됩니다."),
                          enterTagSection(),
                          const SizedBox(height: 300,),
                        ],
                      ),
                    ),
                  ),
                // floatingActionButton: (){
                //     if(keyboardIsOpened){
                //       return null;
                //     }
                //     else{
                //       return Container(
                //         child: isComplete ? createBtn() : disableCreateBtn(),
                //       );
                //     }
                // }(),
                //
                // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              ),
            )
        )
      ],
    );
  }
}
