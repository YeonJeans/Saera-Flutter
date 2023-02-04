import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/learn/presentation/widgets/learn_category_list_tile.dart';
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
      padding: EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
      child: Text(
        '태그로 빠르게\n학습할 문장을 선택해 보세요.',
        style: TextStyles.large00TextStyle,
      ),
    );

    Widget searchSection = Container(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                maxLines: 1,
                readOnly: true,
                onTap: () => Get.to(SearchPage()),
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

    Widget categorySection = Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CategoryListTile(),
          ],
        ),
      )
    );
    
    return Stack(
      children: [
        LearnBackgroundImage(key: null),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textSection,
                      searchSection,
                    ],
                  ),
                ),
                body: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: <Widget>[
                    categorySection
                  ],
                )
            )
        )
      ],
    );
  }
}

