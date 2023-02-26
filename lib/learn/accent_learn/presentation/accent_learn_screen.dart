import 'dart:io';
import 'dart:math';
import 'dart:io' show Platform;


import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/accent_learn_background_image.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/accent_line_chart.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/audio_bar.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:saera/server.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import '../../../login/data/authentication_manager.dart';


class AccentPracticePage extends StatefulWidget {

  final int id;

  const AccentPracticePage({Key? key, required this.id}) : super(key: key);

  @override
  State<AccentPracticePage> createState() => _AccentPracticePageState();
}

class _AccentPracticePageState extends State<AccentPracticePage> with TickerProviderStateMixin {
  final AuthenticationManager _authManager = Get.find();

  String content = "";
  String userName = "수연";

  double accuracyRate = 0;
  int recordingState = 1;


  bool _isBookmarked = false;
  bool _isRecording = false;
  late Future <dynamic> _isAudioReady;

  AudioPlayer audioPlayer = AudioPlayer();

  // String audioPath = "mp3/ex.wav";
  String audioPath = "";
  String recordingPath = "";
  String _fileName = "record.wav";

  final _recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  late List<double> x = [];
  late List<double> y = [];

  late List<double> x2 = [];
  late List<double> y2 = [];

  getExampleAccent() async {

    var url = Uri.parse('${serverHttp}/statements/${widget.id}');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}", "RefreshToken" : "Bearer ${_authManager.getRefreshToken()}" });
    print(response.statusCode);
    print(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));

      x.clear();
      y.clear();

      setState(() {
        content = body["content"];
      });

      setState(() {
        _isBookmarked = body["bookmarked"];
      });

      for(int i in body["pitch_x"]){
        double pitch  = i.toDouble();
        x.add(pitch);
      }

      y = List.from(body["pitch_y"]);

    }
  }



  Future<dynamic> getTTS() async {

    var url = Uri.parse('${serverHttp}/statements/record/${widget.id}');

    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "audio/wav", "authorization" : "Bearer ${_authManager.getToken()}", "RefreshToken" : "Bearer ${_authManager.getRefreshToken()}" });

    if (response.statusCode == 200) {

      Uint8List audioInUnit8List = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();

      File file = await File('${tempDir.path}/exampleAudio${widget.id}.wav').create();
      file.writeAsBytesSync(audioInUnit8List);

      setState(() {
        audioPath = file.path;
      });

      return true;
    }
    else{
      return false;
    }
  }

  createBookmark (int id) async {

    var url = Uri.parse('${serverHttp}/statements/${id}/bookmark');


    final response = await http.post(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}", "RefreshToken" : "Bearer ${_authManager.getRefreshToken()}" });


    if (response.statusCode == 200) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }
  }

  void deleteBookmark () async {
    var url = Uri.parse('${serverHttp}/statements/bookmark/${widget.id}');

    final response = await http.delete(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}", "RefreshToken" : "Bearer ${_authManager.getRefreshToken()}" });

    if (response.statusCode == 200) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }
  }

  getAccentEvaluation() async {
    var url = Uri.parse('${serverHttp}/practiced');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({'accept': 'application/json', "content-type": "multipart/form-data" , "authorization" : "Bearer ${_authManager.getToken()}", "RefreshToken" : "Bearer ${_authManager.getRefreshToken()}"});
    request.files.add(await http.MultipartFile.fromPath('record', recordingPath));

    request.fields['id'] = widget.id.toString();

    var responsed = await request.send();
    var response = await http.Response.fromStream(responsed);

    if (responsed.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        recordingState = 4;
        accuracyRate = body["score"];
      });

      x2.clear();
      y2.clear();

      for(int i in body["pitch_x"]){
        double pitch  = i.toDouble();
        x2.add(pitch);
      }

      y2 = List.from(body["pitch_y"]);

      return true;
    }
  }

  String accuracyComment(double score){
    if(score == 0){
      return "녹음하여 정확도를 측정해 보세요!";
    }
    else if(score > 0 && score < 30){
      return "할 수 있어요!";
    }
    else if (score >= 30 && score < 60) {
      return "좀 더 노력해 봅시다!";
    }
    else if(score >= 60 && score < 80) {
      return "거의 완벽했어요!";
    }
    else{
      return "완벽합니다!!";
    }

  }


  @override
  void initState(){
    initRecorder();
    getExampleAccent();
    _isAudioReady = getTTS();

    super.initState();
  }

  @override
  void dispose(){
    _recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();



    if(status != PermissionStatus.granted){
      throw 'Microphone permission not granted';
    }else{
      if (await Permission.storage.request().isGranted){
        await _recorder.openRecorder();
        isRecorderReady = true;
      }


      // _recorder.setSubscriptionDuration(
      //     const Duration(milliseconds: 500)
      // );
    }

  }

  Future startRecording() async {
    if(!isRecorderReady){
      return;
    }
    if(Platform.isAndroid){
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      new Directory(appDocDirectory.path+'/'+'dir').create(recursive: true)
          .then((Directory directory) async {
        print('Path of New Dir: '+directory.path);
      });
      await _recorder.startRecorder(toFile: '${appDocDirectory.path}/dir/audio.wav');

    }
    else{
      await _recorder.startRecorder(toFile: 'audio.wav');

    }
  }

  Future stopRecording() async {
    if(!isRecorderReady){
      return;
    }

    recordingPath  = (await _recorder.stopRecorder())!;
    final audioFile = File(recordingPath!);
    print("녹음이 완료되었습니다. ${audioFile.path}");
  }


  Widget appBarSection (){
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton.icon(
              onPressed: () => Get.back(),
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
                if(_isBookmarked){
                  deleteBookmark();
                }
                else{
                  createBookmark(widget.id);
                }
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
      child: Center(
        child: Text(
          content,
          style: TextStyles.large33TextStyle,
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
        child: FutureBuilder(
            future: _isAudioReady,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미
              if (snapshot.hasData == false) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                )]
                );
              }
              //error가 발생하게 될 경우 반환하게 되는 부분
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }
              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행
              else {
                return AccentLineChart(x: x, y: y);
              }
            }),
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
        FutureBuilder(
            future: _isAudioReady,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미
              if (snapshot.hasData == false) {
                // return CircularProgressIndicator();
                return before_audio_bar();
              }
              //error가 발생하게 될 경우 반환하게 되는 부분
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }
              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행
              else {
                return AudioBar(recordPath: audioPath, isRecording: false,);
              }
            }),
          exampleGraph(),
        ]
      ),
    );
  }

  Widget practiceSectionText(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          width: 22,
          image: AssetImage('assets/icons/user_profile.png'),),
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
      onTap: () async {
        await startRecording();
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
      onTap: () async {
        await stopRecording();
        getAccentEvaluation();

        setState(() {
          _isRecording = true;
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
        // setState(() {
        //
        // });
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
              child: AccentLineChart(x: x2, y: y2),
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
                      _isRecording = false;
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
                  width: MediaQuery.of(context).size.width - 160,
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
                    Text("${accuracyRate.round()}%",
                      style: TextStyles.regularHighlightBlueBoldTextStyle,
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 7),
              child: Text(accuracyComment(accuracyRate),
                style: TextStyles.small66TextStyle,
              ),
            )
          ],
        )
    );
  }

  Widget before_audio_bar() {
    return Container(
      margin: const EdgeInsets.only(left: 2.0, right: 16.0, top: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              //
            },
            icon: SvgPicture.asset('assets/icons/play.svg',
                fit: BoxFit.scaleDown
            ),
            iconSize: 32,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                child: Text(formatTime(Duration.zero),
                  style: TextStyles.small66TextStyle,
                ),
              ),
              SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                    trackHeight: 5.0,
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Slider(
                      min: 0,
                      max: 0,
                      value: 0,
                      activeColor: ColorStyles.primary.withOpacity(0.4),
                      inactiveColor: Color(0xffE7E7E7),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                      },
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text(formatTime(Duration.zero),
                  style: TextStyles.small66TextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget practiceSection(){
    return Container(
      margin: const EdgeInsets.only(top:31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          practiceSectionText(),
          (){
            if(!_isRecording){
              return before_audio_bar();
            }
            else{
              return AudioBar(recordPath: recordingPath, isRecording: true,);
            }
          }(),
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
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: appBarSection(),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                children: [
                  // appBarSection(),
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
