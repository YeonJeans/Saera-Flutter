import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saera/home/bookmark_home/presentation/bookmark_home_screen.dart';
import 'package:saera/home/presentation/widgets/home_screen_background_image.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Row _recentlyLearnStatement(String label, bool bookmark) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/time_24.svg',
                  fit: BoxFit.scaleDown),
              Column(
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "NotoSansKR", fontWeight: FontWeight.normal),
                  ),
                  Row(
                    children: const [
                      Chip(label: Text('질문'))
                    ],
                  )
                ],
              ),
            ]
          ),
          IconButton(
              onPressed: null,
              icon: SvgPicture.asset(
                'assets/icons/star_unfill.svg',
                fit: BoxFit.scaleDown,
              )
          )
        ],
      );
    }

    Widget searchSection = Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                controller: _textEditingController,
                maxLines: 1,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset('assets/icons/search.svg', fit: BoxFit.scaleDown),
                  hintText: '어떤 문장을 학습할까요?',
                  hintStyle: const TextStyle(color: ColorStyles.searchTextGray, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.normal),
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

    Widget recentlyLearnedSection = Container(
      padding: const EdgeInsets.only(top: 50, bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: SvgPicture.asset('assets/icons/time_32.svg',
            fit: BoxFit.scaleDown),
          ),
          const Text(
            '최근 학습한 문장이 없습니다.\n하단에서 학습 버튼을 눌러 억양 학습을 시작하세요.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorStyles.recentInfoGray, fontSize: 14, fontFamily: "NotoSansKR", fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );

    Widget nearPlaceSection = const Text(
      '@@님 근처에 이 있네요.\n에서 사용할 수 있는 문장을\n빠르게 학습해 보세요.',
      style: TextStyle(color: ColorStyles.textBlack, fontFamily: "NotoSansKR", fontSize: 20, fontWeight: FontWeight.bold)
    );

    Container _recommendStatementButton(Color color, String label) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color),
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
                  Text(
                    label,
                    style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.normal),
                  ),
                  SvgPicture.asset('assets/icons/enter.svg')
                ],
              ),
            )
        ),
      );
    }

    Widget placeRecommendSection = Column(
      children: [
        const Padding(padding: EdgeInsets.all(8)),
        _recommendStatementButton(ColorStyles.saeraYellow, '목이 아프고 열이 나요.'),
        _recommendStatementButton(ColorStyles.saeraYellow, '먹으면 안되는 음식이 있나요?'),
        _recommendStatementButton(ColorStyles.saeraYellow, '근처에 약국은 어디에 있나요?'),
        const Padding(padding: EdgeInsets.all(5)),
        _recommendStatementButton(ColorStyles.etcYellow, '더보기')
      ],
    );

    return Stack(
      children: [
        HomeBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                children: <Widget>[
                  searchSection,
                  recentlyLearnedSection,
                  nearPlaceSection,
                  placeRecommendSection
                ],
              ),
            )
        )
      ],
    );
  }
}