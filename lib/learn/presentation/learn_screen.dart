import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/learn/presentation/widgets/learn_screen_background_image.dart';
import 'package:saera/style/font.dart';

import '../../style/color.dart';
import '../search_learn/presentation/search_learn_screen.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  @override
  Widget build(BuildContext context) {
    Widget textSection = const Padding(
      padding: EdgeInsets.only(top: 70.0, left: 10.0, right: 10.0),
      child: Text(
        '어떤 상황에\n사용하실 건가요?',
        style: TextStyles.large00TextStyle,
      ),
    );

    Widget searchSection = Container(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                maxLines: 1,
                readOnly: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage())),
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset('assets/icons/search.svg', fit: BoxFit.scaleDown),
                  hintText: '직접 검색해보세요.',
                  hintStyle: TextStyles.mediumAATextStyle,
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(99.0)),
                      borderSide: BorderSide(color: ColorStyles.searchFillGray)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(99.0)),
                    borderSide: BorderSide(color: ColorStyles.searchFillGray),
                  ),
                  filled: true,
                  fillColor: ColorStyles.searchFillGray,
                ),
              )
          )
        ],
      ),
    );
    
    return Stack(
      children: [
        LearnBackgroundImage(key: null),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: <Widget>[
                  textSection,
                  searchSection
                ],
              )
            )
        )
      ],
    );
  }
}

