// import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:get/get.dart';

import '../learn/custom_learn/create_sentence/presentation/widgets/subtitle_section.dart';
import '../login/data/authentication_manager.dart';
import '../login/data/user_info_controller.dart';
import '../login/presentation/widget/profile_image_clipper.dart';
import '../server.dart';
import '../style/color.dart';
import '../style/font.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class UserInfoEditPage extends StatefulWidget {
  const UserInfoEditPage({Key? key}) : super(key: key);

  @override
  State<UserInfoEditPage> createState() => _UserInfoEditPageState();
}

class _UserInfoEditPageState extends State<UserInfoEditPage> {
  final AuthenticationManager _authManager = Get.find();
  final UserInfoController _userController = Get.find();

  final TextEditingController _textEditingController = TextEditingController();
  bool isComplete = false;
  bool isComplete2 = false;
  bool isExist = true;
  int inputFieldInfo = 0;
  String originUserName = "";
  String newUserName = "";

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String originImgUrl = "";
  String imgUrl = "";

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    originUserName = _userController.getUserName()!;
    originImgUrl = _userController.getImage()!;
    print("init");

    _textEditingController.text = _userController.getUserName();

    super.initState();
  }

  ModifyUserInfo() async {
    if(newUserName == ""){
      newUserName = originUserName;
    }
    var url = Uri.parse('$serverHttp/member?nickname=$newUserName');
    var request = http.MultipartRequest('PATCH', url);
    // var formData = FormData.fromMap({'image' :  await MultipartFile.fromFile(_imageFile)});
    request.headers.addAll({'accept': 'application/json', "content-type": "multipart/form-data" , "authorization" : "Bearer ${_authManager.getToken()}"});
    if(_imageFile?.path != null){
      print(_imageFile!.path);
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
    }

    print(request.files);
    var responsed = await request.send();
    var response = await http.Response.fromStream(responsed);

    print(responsed.statusCode);
    print(utf8.decode(response.bodyBytes));
    if (responsed.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);

      String profileUrl = "";

      setState(() {
        profileUrl = body["profileUrl"];
      });

      _userController.saveUserName(newUserName);
      _userController.saveImage(profileUrl);
      //

      if (!mounted) return;

      Navigator.pop(context);

      return true;
    }
    else{
      //
    }
  }

  void getImage({required ImageSource source}) async {
    final pickedFile = await _picker.getImage(source: source);
    if(pickedFile != null){
      setState(() {
        _imageFile = pickedFile!;

        if(_imageFile != null){
          setState(() {
            isComplete2 = true;
          });
        }
      });
    }
  }

  Widget appBarSection (){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton.icon(
              onPressed: (){
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
      ),
    );
  }

  Widget titleSection(){
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05, left: 10, right: 10),
      child: const Text(
        '프로필 수정',
        style: TextStyles.xLarge25TextStyle,
      ),
    );
  }

  Widget userImage(){
    return Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.only(top: 44, bottom: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              Container(
                child: ClipPath(
                    clipper: ProfileImageClipper(),
                    child: Container(
                      width: 121,
                      height: 116,
                      child: Image(
                        image: _imageFile == null ?
                        NetworkImage(_userController.getImage())
                            :
                        FileImage(File(_imageFile!.path)) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    )
                ),
              ),
              // The badge
              Positioned(
                right: -10,
                bottom: -10,
                child: GestureDetector(
                  onTap: (){
                    print("here!");
                    getImage(source: ImageSource.gallery);

                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorStyles.searchFillGray,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.edit_outlined,
                        color: ColorStyles.black00,
                      )
                    ),
                  ),
                )
              ),
            ],
          )
        ],
      )

    );
  }

  Widget enterText (){
    return Container(
        child: TextField(
          controller: _textEditingController,
          maxLines: 1,
          onChanged: (text){
            if(text.isNotEmpty){
              newUserName = text;
              if (text.length > 6){
                setState(() {
                  isComplete = false;
                });
              }
              else if(originUserName != text){
                setState(() {
                  isComplete = true;
                });
              }
              else{
                setState(() {
                  isComplete = false;
                });
              }

            }
            else {
              setState(() {
                isComplete = false;
              });
            }


          },
          decoration: InputDecoration(
            // hintText: _authManager.getName(),
            // hintStyle: TextStyles.medium00TextStyle,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                borderSide: BorderSide(color: Colors.transparent)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            contentPadding: EdgeInsets.only(top: 12,  bottom: 12, left: 16, right: 16),
            filled: true,
            fillColor: ColorStyles.searchFillGray,
          ),
        )
    );
  }

  Widget saveProfileBtn(bool isActive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isActive ? ColorStyles.black00.withOpacity(0.1) : Colors.transparent,
            spreadRadius: 4,
            blurRadius: 16,
            offset: Offset(0, 4),
          )
        ]
      ),
      margin: const EdgeInsets.only(left: 14, right: 14, bottom: 15),
      height: 56,
      child: OutlinedButton(
          onPressed: isActive ? () {
            ModifyUserInfo();
            print("here!");

            //var formData = FormData.fromMap({'file': await MultipartFile.fromFile(sendData)});

            // Navigator.pop(context);
          }  : null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 0.1, color: Colors.transparent),
            backgroundColor: isActive ? ColorStyles.saeraAppBar : ColorStyles.disableGray,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
          ),
          child: Center(
            child: isActive ?
                Text(
                  '프로필 수정',
                  style: TextStyles.mediumWhiteBoldTextStyle,
                  textAlign: TextAlign.center,
                )
                :
                Text(
                  '프로필 수정',
                  style: TextStyles.medium99TextStyle,
                  textAlign: TextAlign.center,
                )
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: appBarSection(),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: ListView(
                  //physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // appBarSection(),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            titleSection(),

                            userImage(),
                            SubTitleSection(subtitle: "닉네임", desc: "최대 6글자까지 가능합니다."),
                            enterText (),
                          ],
                        ),
                      )
                    ]
                ),
              bottomSheet: SizedBox(
                height: 71,
                child: Container(
                  color: Colors.white,
                  child: saveProfileBtn(isComplete || isComplete2),
                ),
              ),
            )
        )

      ],
    );
  }
}
