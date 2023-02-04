import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../style/font.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  int leftexp = 1313;
  int level = 13;
  String userName = "유사마동석";

  Widget userProfileImage(){
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/icons/mypage_profile_bg.svg',
            semanticsLabel: 'Acme Logo'),
        Image(image: AssetImage('assets/icons/user_profile.png'),)
      ],
    );
  }

  Widget userInfoTextSection(){
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Lv. $level ",
            style: TextStyles.largeHighlightBlueTextStyle,
          ),
          Text("$userName ",
            style: TextStyles.large00TextStyle,
          ),
          const Text("님",
            style: TextStyles.large00NormalTextStyle,
          ),

        ],
      ),
    );
  }

  Widget userLevelInfoSection(){
    return Container(
      margin: const EdgeInsets.only(top: 6.0),
      child: Text("다음 레벨까지 $leftexp xp 남았어요.",
        style: TextStyles.medium55TextStyle,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userProfileImage(),
        userInfoTextSection(),
        userLevelInfoSection()
      ],
    );
  }
}








