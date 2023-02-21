import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saera/learn/custom_learn/create_sentence/presentation/widgets/create_sentence_background.dart';
import 'package:saera/learn/custom_learn/create_sentence/presentation/widgets/subtitle_section.dart';

import 'package:saera/style/font.dart';
import 'package:saera/style/color.dart';

class CreateSentenceScreen extends StatefulWidget {
  const CreateSentenceScreen({Key? key}) : super(key: key);

  @override
  State<CreateSentenceScreen> createState() => _CreateSentenceScreenState();
}

class _CreateSentenceScreenState extends State<CreateSentenceScreen> {

  final TextEditingController _textEditingController = TextEditingController();
  bool isComplete = false;
  bool isExist = true;
  int inputFieldInfo = 0;

  late ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget appBarSection (){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
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
        style: TextStyles.xLargeTextStyle,
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
          style: TextStyles.medium99TextStyle,
        ),
      )
    );
  }

  Widget createBtn(){
    return GestureDetector(
      onTap: (){
        // TODO- 문장 생성 버튼 클릭시 진행될 내용을 이곳에 추가하면 됩니다!
      },
      child: Container(
          margin: const EdgeInsets.only(left: 14, right: 14, bottom: 15),
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorStyles.primary,
              boxShadow:[
                BoxShadow(
                  color: ColorStyles.primary.withOpacity(0.4),
                  spreadRadius: 0.1,
                  blurRadius: 12,
                  offset: const Offset(0, -2), // changes position of shadow
                ),
              ],
          ),
          child: const Center(
            child: Text(
              "문장 생성",
              style: TextStyles.mediumWhiteTextStyle,
            ),
          )
      ),
    );
  }

  Widget enterText (){
    RegExp hannum = new RegExp(r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9|\s]*$');
    return Container(
      child: TextField(
        autofocus: true,
        controller: _textEditingController,
        maxLines: 2,
        onChanged: (text){
          if(text.isNotEmpty){

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
      padding: EdgeInsets.only(top: 10, bottom: 25),
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
                        backgroundColor: ColorStyles.saeraYellow,
                        deleteIcon: SvgPicture.asset('assets/icons/delete.svg', fit: BoxFit.scaleDown),
                        deleteIconColor: ColorStyles.deleteGray,
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
                          autofocus: true,
                          enabled: _tags.length >= 3 ? false : true,
                          controller: _controller,
                          onSubmitted: (_) => _addTag(),
                          onTap: (){
                            _scrollController.animateTo(120.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CreateSentenceBackgroundImage(),
        SafeArea(
            child: GestureDetector(
              onTap: () {
                  FocusScope.of(context).unfocus();
                },
              child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: appBarSection(),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  backgroundColor: Colors.transparent,
                  // resizeToAvoidBottomInset: true,
                  bottomSheet: Container(
                      child: isComplete ? createBtn() : disableCreateBtn(),
                  ),
                  body: SingleChildScrollView(
                    controller: _scrollController,
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
                        ],
                      ),
                    ),
                  )
              ),

        )



        )
      ],
    );
  }
}
