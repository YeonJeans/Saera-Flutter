import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saera/login/presentation/login_screen.dart';
import 'package:saera/mypage/presentation/widgets/mypage_background_image.dart';
import 'package:saera/mypage/presentation/widgets/mypage_userInfo.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

import '../../login/data/login_platform.dart';
import '../../server.dart';


class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  LoginPlatform _loginPlatform = LoginPlatform.google;

  void signOut() async {
    // switch (_loginPlatform) {
    //   case LoginPlatform.google:
    //     print("Google logout");
    //     await GoogleSignIn(
    //         clientId: googleClientId,
    //         serverClientId: serverClientId
    //     ).signOut();
    //     break;
    //   case LoginPlatform.apple:
    //     break;
    //   case LoginPlatform.none:
    //     break;
    // }

    setState(() {
      _loginPlatform = LoginPlatform.none;
      // Get.to(() => LoginPage());
    });

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
                          UserInfo(),
                          Container(
                            margin: EdgeInsets.only(top: 53),
                            child: _mypageButton("프로필 수정", "edit.svg", true, (){print("here");}),
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

