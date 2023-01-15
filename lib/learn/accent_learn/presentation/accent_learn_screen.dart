import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/accent_learn_background_image.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

class AccentPracticePage extends StatefulWidget {
  const AccentPracticePage({Key? key}) : super(key: key);

  @override
  State<AccentPracticePage> createState() => _AccentPracticePageState();
}

class _AccentPracticePageState extends State<AccentPracticePage> with TickerProviderStateMixin {

  double _currentSliderValue = 20;
  String userName = "수연";

  double accuracyRate = 90;

  Widget appBarSection = Container(
    //padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            print ("pressed");
          },
          icon: SvgPicture.asset('assets/icons/back.svg',
              fit: BoxFit.scaleDown
          ),
          iconSize: 32,
        ),

        Text("뒤로",
          style: TextStyles.backBtnTextStyle,
        )

      ],
    ),
  );

  Widget practiceSentenceSection() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(top:30.0, bottom: 24.0),
      decoration: BoxDecoration(
          color: ColorStyles.etcYellow,
          borderRadius: BorderRadius.circular(10)
      ),
      child: const Center(
        child: Text(
          "화장실은 어디에 있나요?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff333333),
          ),
        ),
      ),
    );
  }

  Widget exampleSectionText(){
    return Row(
      children: [
        SvgPicture.asset('assets/icons/flag.svg'),
        const SizedBox(width: 9,),
        const Text(
          "이 억양을 목표로 연습해 볼까요?",
          style: TextStyles.medium00BoldTextStyle,
        )

      ],
    );
  }

  Widget exampleRecordBar(){
    return Container(
      margin: EdgeInsets.only(left: 2.0, right: 16.0, top: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              print ("pressed");
            },
            icon: SvgPicture.asset('assets/icons/play.svg',
                fit: BoxFit.scaleDown
            ),
            iconSize: 32,
          ),
          // SizedBox(
          //     width: 16
          // ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: Text("00:00",
                  style: TextStyles.small66TextStyle,
                ),
              ),
              SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                    trackHeight: 5.0,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 5.0),
                  ),
                  child: Container(
                    width: 200,
                    child: Slider(
                      value: _currentSliderValue,
                      max: 200,
                      activeColor: ColorStyles.primary.withOpacity(0.4),
                      inactiveColor: Color(0xffE7E7E7),
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text("00:03",
                  style: TextStyles.small66TextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget exampleGraph(){
    return Container(
      margin: EdgeInsets.only(top: 19),
      height: 135,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
        boxShadow:[
          BoxShadow(
            color: Color(0xff663E68A8).withOpacity(0.3),
            spreadRadius: 0.1,
            blurRadius: 8,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget exampleSection(){
    return Container(
      margin: EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          exampleSectionText(),
          exampleRecordBar(),
          exampleGraph(),
        ]
      ),
    );
  }

  Widget practiceSectionText(){
    return Row(
      children: [
        SvgPicture.asset('assets/icons/profile_image.svg',
          color: ColorStyles.saeraBlue
        ),
        const SizedBox(width: 9,),
        Text(
          "현재 ${userName}님의 억양이에요.",
          style: TextStyles.medium00BoldTextStyle,
        )

      ],
    );
  }

  Widget practiceGraph(){
    return GestureDetector(
      onTap: (){
        print("clicked!");
      },
      child: Container(
          margin: EdgeInsets.only(top: 19),
          height: 135,
          decoration: BoxDecoration(
            color: ColorStyles.primary,
            borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
            boxShadow:[
              BoxShadow(
                color: Color(0xff663E68A8).withOpacity(0.3),
                spreadRadius: 0.1,
                blurRadius: 8,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              "여기를 눌러 녹음을 시작하세요.",
              style: TextStyles.mediumWhiteTextStyle,
            ),
          )
      ),
    );
  }

  Widget expSection() {
    return Container(
        margin: EdgeInsets.only(top: 13, bottom: 25),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
          boxShadow:[
            BoxShadow(
              color: Color(0xff663E68A8).withOpacity(0.3),
              spreadRadius: 0.1,
              blurRadius: 8,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  width: 250,
                  height: 14,
                  margin: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: accuracyRate/100,
                      valueColor: AlwaysStoppedAnimation<Color>(ColorStyles.saeraBlue),
                      backgroundColor: ColorStyles.expFillGray,
                    ),
                  ),
                ),

                Text("정확도 ",
                  style: TextStyles.regular25BoldTextStyle,
                ),
                Text("90%",
                  style: TextStyles.regularHighlightBlueBoldTextStyle,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text("완벽합니다! 학습 완료 경험치 +120xp",
                style: TextStyles.small66TextStyle,
              ),
            )
          ],
        )
    );
  }


  Widget practiceSection(){
    return Container(
      margin: EdgeInsets.only(top:31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          practiceSectionText(),
          exampleRecordBar(),
          practiceGraph(),
          expSection()


        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AccentPracticeBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                children: [
                  appBarSection,
                  Container(
                    margin: EdgeInsets.only(left: 14, right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        practiceSentenceSection(),
                        exampleSection(),
                        practiceSection(),
                      ],
                    ),
                  )
                ]
              )
            )
        )


      ],
    );
  }
}
