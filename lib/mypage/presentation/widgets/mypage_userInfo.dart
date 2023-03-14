import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saera/style/color.dart';

import '../../../login/data/authentication_manager.dart';
import '../../../login/presentation/widget/profile_image_clipper.dart';
import '../../../style/font.dart';

import 'liquid_custom_progress.dart';

class UserInfo extends StatefulWidget {

  final int exp;

  const UserInfo({Key? key, required this.exp}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  final AuthenticationManager _authManager = Get.find();

  Widget userProfileImage(){
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LiquidCustomProgressIndicator(
                value: widget.exp == 0 ? 0.0 : widget.exp/1000 - ((widget.exp)/1000).floor(),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 14,),
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
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Lv. ${1+( widget.exp / 1000).floor()} ",
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
      child: Text("다음 레벨까지 ${widget.exp != 0 ? 1000 - widget.exp % 1000 : ""} xp 남았어요.",
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








