import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/style/color.dart';

import '../../../login/data/authentication_manager.dart';
import '../../../login/presentation/widget/profile_image_clipper.dart';
import '../../../style/font.dart';

import 'liquid_custom_progress.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  final AuthenticationManager _authManager = Get.find();

  int leftexp = 1313;
  int level = 13;

  Widget userProfileImage(){
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LiquidCustomProgressIndicator(
                value: 0.8,
                valueColor: AlwaysStoppedAnimation(ColorStyles.saeraKhaki),
                backgroundColor: ColorStyles.searchFillGray,
                direction: Axis.vertical,
                shapePath: ProfileImageClipper().getClip(Size(189, 181)),
              ),
            ],
          ),
        ),

        SizedBox(
          width: 200,
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 14,),
              Container(
                child: ClipPath(
                    clipper: ProfileImageClipper(),
                    child: Container(
                      width: 165,
                      height: 158,
                      child: Image.network("${_authManager.getPhoto()}",
                        fit: BoxFit.cover,
                      ),
                    )
                ),
              ),
              Spacer()
            ],
          ),
        )

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
          Text("${_authManager.getName()} ",
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








