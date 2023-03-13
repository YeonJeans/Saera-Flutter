import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/mypage/presentation/widgets/mypage_background_image.dart';
import 'package:saera/mypage/presentation/widgets/mypage_userInfo.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

import '../../login/data/authentication_manager.dart';
import '../../login/data/login_platform.dart';
import '../../login/data/refresh_token.dart';
import '../../server.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final AuthenticationManager _authManager = Get.find();

  LoginPlatform _loginPlatform = LoginPlatform.google;

  int xp = 1;

  void signOut() async {

    setState(() {
      _loginPlatform = LoginPlatform.none;
      _authManager.logOut();
      //Get.to(() => LoginPage());
    });

  }

  getUserExp() async {
    await Future.delayed(const Duration(seconds: 1));
    var url = Uri.parse('${serverHttp}/member');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });

    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        xp = body["xp"];
      });

    }
    else if(response.statusCode == 401){
      String? before = _authManager.getToken();
      await RefreshToken(context);

      if(before != _authManager.getToken()){
        getUserExp();
      }
    }
  }

  @override
  void initState() {
    getUserExp();

    super.initState();
  }

  Widget _mypageButton(String label, String icon, bool isEnter, void func) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ElevatedButton(
          onPressed: (){
            func;
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(ColorStyles.searchFillGray),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                  )
              )
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/${icon}'),
                    Padding(padding: EdgeInsets.only(right: 9)),
                    Text(
                        label,
                        style: TextStyles.medium00TextStyle
                    ),
                  ],
                ),
                    (){
                  if(isEnter == true){
                    return SvgPicture.asset('assets/icons/enter.svg');
                  }
                  else{
                    return Spacer();
                  }
                }(),
              ],
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MyPageBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: Center(

                    child: Container(
                      margin: const EdgeInsets.only(left: 14, right: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          UserInfo(exp: xp,),
                          Container(
                            margin: EdgeInsets.only(top: 53, bottom: 4),
                            child: _mypageButton("프로필 수정", "edit.svg", true, (){
                              print("here");
                            }),
                          ),
                          _mypageButton("로그아웃", "signout.svg", false, signOut())
                        ],
                      ),
                    )
                )
            )
        )


      ],
    );
  }
}

