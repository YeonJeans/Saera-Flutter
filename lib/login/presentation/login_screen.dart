import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saera/login/data/login_platform.dart';
import 'package:saera/server.dart';
import 'package:saera/style/font.dart';
import 'package:saera/tabbar.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../style/color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithGoogle() async {
    if(Platform.isAndroid){
      setState(() {
        Get.to(() => TabBarMainPage());
      });
    }
    else{
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          clientId: googleClientId
      ).signIn();

      if (googleUser != null) {
        print('google User: ${googleUser}');
        print('name = ${googleUser.displayName}');
        print('email = ${googleUser.email}');
        print('id = ${googleUser.id}');

        setState(() {
          _loginPlatform = LoginPlatform.google;
          Get.to(() => TabBarMainPage());
        });
      }
    }

  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut();
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }



  Widget googleLoginBtn (){
    return GestureDetector(
      onTap: () {
        signInWithGoogle();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: ColorStyles.saeraWhite,
          borderRadius: BorderRadius.circular(2), //border radius exactly to ClipRRect
          boxShadow:[
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.3),
              spreadRadius: 0.2,
              blurRadius: 8,
              offset: const Offset(2, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/icons/google_logo.png'),
              width: 18,
              height: 18,
            ),
            SizedBox(width: 24,),
            Text(
              "Google 계정으로 로그인",
              style: TextStyles.medium25TextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget appleLoginBtn (){
    return GestureDetector(
      onTap: () => Get.to(TabBarMainPage()),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2), //border radius exactly to ClipRRect
          boxShadow:[
            BoxShadow(
              color: const Color(0xff663e68a8).withOpacity(0.3),
              spreadRadius: 0.2,
              blurRadius: 8,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/icons/google_logo.png'),
              width: 18,
              height: 18,
            ),
            SizedBox(width: 24,),
            Text(
              "Apple로 로그인",
              style: TextStyles.medium25TextStyle,
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash_bg.png'),
          fit: BoxFit.fill
        )
      ),
      padding: const EdgeInsets.only(left: 21, right: 21, bottom: 180),
      child: Column(
        children: [
          const Spacer(),
          googleLoginBtn(),
          // appleLoginBtn()
        ],
      )
    );
  }
}
