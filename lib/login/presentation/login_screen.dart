import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/login/data/login_platform.dart';
import 'package:saera/login/data/user_info_controller.dart';
import 'package:saera/server.dart';
import 'package:saera/style/font.dart';
import 'package:saera/tabbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../style/color.dart';
import '../data/authentication_manager.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthenticationManager _authManager;
  LoginPlatform _loginPlatform = LoginPlatform.none;

  final UserInfoController _userController = Get.find();

  Future<dynamic> getToken(String ?serverAuthCode) async {

    var url = Uri.parse('$serverHttp/auth/google/callback?code=$serverAuthCode');

    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json"});

    print("getToken ${response.statusCode}");
    if (response.statusCode == 200) {

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      print(body);

      String accessToken = body["accessToken"];
      String refreshToken = body["refreshToken"];

      _authManager.login(accessToken, refreshToken);
      return true;
    }
    else{
      return false;
    }
  }

  Future<dynamic> getAppleToken(String ?code, String ?token, String ?state, String ?identifier, String ?name, String ?email) async {
    var url = Uri.parse('$serverHttp/auth/apple/callback');

    var data = {
      "code" : code,
      "token" : token,
      "state" : state,
      "identifier" : identifier,
      "email" : email,
      "name" : name
    };

    var body = json.encode(data);
    final response = await http.post(
        url,
        headers: {'accept': 'application/json', "content-type": "application/json" },
        body: body
    );

    // var url = Uri.parse('$serverHttps:443/auth/apple/callback?email=$email&name=$name');
    //
    // final response = await http.post(url, headers: {'accept': 'application/json', "content-type": "application/json"});

    print("getToken ${response.statusCode}");
    print(response.body);
    print(jsonDecode(utf8.decode(response.bodyBytes)));

    if (response.statusCode == 200) {

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      print(body);

      String accessToken = body["accessToken"];
      String refreshToken = body["refreshToken"];

      _authManager.login(accessToken, refreshToken);
      return true;
    }
    else{
      return false;
    }
  }

  @override
  void initState(){
    super.initState();
    _authManager = Get.find();
  }

  getUserExp() async {
    var url = Uri.parse('$serverHttp/member');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });

    // print("json: ${jsonDecode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      int xp = 0;
      String profileUrl = "";
      String name = "";

      setState(() {
        xp = body["xp"];
        profileUrl = body["profileUrl"];
        name = body["name"];
      });

      print("xp: ${xp}");
      print("profile: $profileUrl");
      print("name: $name");

      _authManager.saveName(name);
      _authManager.savePhoto(profileUrl);


      _userController.saveImage(profileUrl);
      _userController.saveUserName(name);
      _userController.saveExp(xp);

      print(_userController.getImage());

    }
    else{
      print(jsonDecode(utf8.decode(response.bodyBytes)));
    }
  }

  void signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential =
      await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "saera.yeonjeams.com",
          redirectUri: Uri.parse(
            "https://saera.app/auth/apple/callback",
          ),
        ),
      );

      print('credential.state = $credential');
      // print('authorizationcode state = ${credential.state}');
      // print('authorizationcode = ${credential.authorizationCode}');
      // print('identityToken = ${credential.identityToken}');
      // print('email = ${credential.email}');
      // print('userIdentifier = ${credential.userIdentifier}');

      await getAppleToken(credential.authorizationCode, credential.identityToken, credential.state, credential.userIdentifier, credential.familyName, credential.email);

      setState(() {
        _loginPlatform = LoginPlatform.apple;
      });

      await getUserExp();

      Get.offAll(() => TabBarMainPage());

    } catch (error) {
      print('error = $error');
    }
  }

  void signInWithGoogle() async {
    if(Platform.isAndroid){
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          serverClientId: serverClientId
      ).signIn();

      if (googleUser != null) {
        _authManager.saveEmail(googleUser.email);
        _authManager.saveName(googleUser.displayName);
        _authManager.savePhoto(googleUser.photoUrl);

        await getToken(googleUser.serverAuthCode);

        setState(() {
          _loginPlatform = LoginPlatform.google;
        });

        await getUserExp();

        Get.offAll(() => TabBarMainPage());
      }
    }
    else{
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          clientId: googleClientId,
          serverClientId: serverClientId
      ).signIn();

      if (googleUser != null) {
        _authManager.saveEmail(googleUser.email);
        // _authManager.saveName(googleUser.displayName);
        // _authManager.savePhoto(googleUser.photoUrl);
        await getToken(googleUser.serverAuthCode);

        setState(() {
          _loginPlatform = LoginPlatform.google;
        });

        await getUserExp();

        Get.offAll(() => TabBarMainPage());

      }
    }

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
          borderRadius: BorderRadius.circular(6), //border radius exactly to ClipRRect
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
          children:[
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: const Image(
                image: AssetImage('assets/icons/google_logo.png'),
                width: 18,
                height: 18,
              ),
            ),
            const SizedBox(width: 24,),
            const Text(
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
      onTap: () {
        signInWithApple();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: ColorStyles.saeraWhite,
          borderRadius: BorderRadius.circular(6), //border radius exactly to ClipRRect
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
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: const Image(
                image: AssetImage('assets/images/apple_logo.png'),
                width: 18,
                height: 18,
              ),
            ),
            const SizedBox(width: 24,),
            const Text(
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/images/saera_splash.svg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                //width: MediaQuery.of(context).size.width,
              ),
              Container(
                // width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/saera_title.svg',
                    alignment: Alignment.center,
                  ),
                ),
              ),

              Container(
                  padding: const EdgeInsets.only(left: 21, right: 21, bottom: 150),
                  child: Column(
                    children: [
                      const Spacer(),
                      googleLoginBtn(),
                      const SizedBox(
                        height: 16,
                      ),

                      (){
                        if(Platform.isIOS){
                          return appleLoginBtn();
                        }
                        else{
                          return Container();
                        }

                      }(),

                      // appleLoginBtn()
                    ],
                  )
              ),
            ],
          )
        ],
      )
    );
  }
}
