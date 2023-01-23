import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/accent_learn_background_image.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/accent_line_chart.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/record_bar.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';
import 'package:audioplayers/audioplayers.dart';


class AccentPracticePage extends StatefulWidget {
  const AccentPracticePage({Key? key}) : super(key: key);

  @override
  State<AccentPracticePage> createState() => _AccentPracticePageState();
}

class _AccentPracticePageState extends State<AccentPracticePage> with TickerProviderStateMixin {


  String userName = "수연";

  int accuracyRate = 90;
  int recordingState = 1;

  bool _isBookmarked = false;

  AudioPlayer audioPlayer = AudioPlayer();

  String audioPath = "https://www.youtube.com/watch?v=_LXp1Lgfdk0";

  Widget appBarSection (){
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton.icon(
              onPressed: () {
                //print("뒤로!");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.scaleDown,
              ),
              label: const Text(' 뒤로',
                  style: TextStyles.backBtnTextStyle
              )
          ),

          IconButton(
              onPressed: (){
                setState(() {
                  _isBookmarked = !_isBookmarked;
                });
              },
              icon: _isBookmarked ?
              SvgPicture.asset(
                'assets/icons/star_fill.svg',
                fit: BoxFit.scaleDown,
              )
                  :
              SvgPicture.asset(
                'assets/icons/star_unfill.svg',
                fit: BoxFit.scaleDown,
              )
          )

        ],
      ),
    );
  }

  Widget practiceSentenceSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(top:30.0, bottom: 24.0),
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

  Widget exampleGraph(){
    return Container(
      margin: const EdgeInsets.only(top: 19),
      height: 135,
      decoration: BoxDecoration(
        color: ColorStyles.saeraWhite,
        borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
        boxShadow:[
          BoxShadow(
            color: const Color(0xff663e68a8).withOpacity(0.3),
            spreadRadius: 0.1,
            blurRadius: 8,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: const AccentLineChart(),
      ),
    );
  }

  Widget exampleSection(){
    return Container(
      margin: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          exampleSectionText(),
          RecordBar(recordPath: audioPath),
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
          "현재 $userName님의 억양이에요.",
          style: TextStyles.medium00BoldTextStyle,
        )

      ],
    );
  }

  Widget recordingStart(){
    return GestureDetector(
      onTap: (){
        setState(() {
          recordingState = 2;
        });
      },
      child: Container(
          margin: const EdgeInsets.only(top: 19),
          height: 135,
          decoration: BoxDecoration(
            color: ColorStyles.primary,
            borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
            boxShadow:[
              BoxShadow(
                color: const Color(0xff663e68a8).withOpacity(0.3),
                spreadRadius: 0.1,
                blurRadius: 8,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "여기를 눌러 녹음을 시작하세요.",
              style: TextStyles.mediumWhiteTextStyle,
            ),
          )
      ),
    );
  }

  Widget recordingWidget(){
    return GestureDetector(
      onTap: (){
        setState(() {
          recordingState = 3;
        });
      },
      child: Container(
          margin: const EdgeInsets.only(top: 19),
          height: 135,
          decoration: BoxDecoration(
            color: ColorStyles.saeraBlue,
            borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
            boxShadow:[
              BoxShadow(
                color: const Color(0xff663e68a8).withOpacity(0.3),
                spreadRadius: 0.1,
                blurRadius: 8,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/record.svg',
                    fit: BoxFit.scaleDown
                ),
                Container(
                  margin: const EdgeInsets.only(top:11),
                  child: const Text(
                    "녹음 중이에요...\n여기를 다시 눌러 녹음을 완료할 수 있어요.",
                    style: TextStyles.small25TextStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          )
      ),
    );
  }

  Widget analysisAccent(){
    return GestureDetector(
      onTap: (){
        setState(() {
          recordingState = 4;
        });
      },
      child: Container(
          margin: const EdgeInsets.only(top: 19),
          height: 135,
          decoration: BoxDecoration(
            color: ColorStyles.saeraBlue,
            borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
            boxShadow:[
              BoxShadow(
                color: const Color(0xff663e68a8).withOpacity(0.3),
                spreadRadius: 0.1,
                blurRadius: 8,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      'assets/icons/headphones.svg',
                      fit: BoxFit.scaleDown
                  ),
                  Container(
                    margin: const EdgeInsets.only(top:15),
                    child: const Text(
                      "억양을 분석하고 있습니다...\n거의 다 되었어요!",
                      style: TextStyles.small25TextStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
          )
      ),
    );
  }

  Widget practiceGraph(){
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 19),
            height: 135,
            decoration: BoxDecoration(
              color: ColorStyles.saeraWhite,
              borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
              boxShadow:[
                BoxShadow(
                  color: const Color(0xff663E68A8).withOpacity(0.3),
                  spreadRadius: 0.1,
                  blurRadius: 8,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(25),
              child: const AccentLineChart(),
            ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 18, right: 3),
              child: IconButton(
                  onPressed: (){
                    setState(() {
                      recordingState = 1;
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/refresh.svg',
                    fit: BoxFit.scaleDown,
                  )
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget expSection() {
    return Container(
        margin: const EdgeInsets.only(top: 13, bottom: 25),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        height: 80,
        decoration: BoxDecoration(
          color: ColorStyles.saeraWhite,
          borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
          boxShadow:[
            BoxShadow(
              color: const Color(0xff663e68a8).withOpacity(0.3),
              spreadRadius: 0.1,
              blurRadius: 8,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                  width: 250,
                  height: 14,
                  margin: const EdgeInsets.only(right: 5),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: accuracyRate/100.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(ColorStyles.saeraBlue),
                      backgroundColor: ColorStyles.expFillGray,
                    ),
                  ),
                ),

                Row(
                  children: [
                    const Text("정확도 ",
                      style: TextStyles.regular25BoldTextStyle,
                    ),
                    Text("$accuracyRate%",
                      style: TextStyles.regularHighlightBlueBoldTextStyle,
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text("완벽합니다! 학습 완료 경험치 +120xp",
                style: TextStyles.small66TextStyle,
              ),
            )
          ],
        )
    );
  }


  Widget practiceSection(){
    return Container(
      margin: const EdgeInsets.only(top:31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          practiceSectionText(),
          RecordBar(recordPath: audioPath),
          (){
            if(recordingState == 1){
              return recordingStart();
            }
            else if(recordingState == 2){
              return recordingWidget();
            }
            else if(recordingState == 3){
              return analysisAccent();
            }
            return practiceGraph();
          }(),
          expSection()


        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AccentPracticeBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                children: [
                  appBarSection(),
                  Container(
                    margin: const EdgeInsets.only(left: 14, right: 14),
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
