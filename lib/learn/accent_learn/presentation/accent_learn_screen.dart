import 'dart:io';
import 'dart:io' show Platform;


import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/accent_learn_background_image.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/accent_line_chart.dart';
import 'package:saera/learn/accent_learn/presentation/widgets/audio_bar.dart';
import 'package:saera/login/data/refresh_token.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:saera/server.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../login/data/authentication_manager.dart';
import '../../../login/presentation/widget/profile_image_clipper.dart';


class AccentPracticePage extends StatefulWidget {

  final int id;

  const AccentPracticePage({Key? key, required this.id}) : super(key: key);

  @override
  State<AccentPracticePage> createState() => _AccentPracticePageState();
}

class _AccentPracticePageState extends State<AccentPracticePage> with TickerProviderStateMixin {
  final AuthenticationManager _authManager = Get.find();
  late FToast fToast;

  String content = "";
  String userName = "";

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

  showCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: ColorStyles.black00.withOpacity(0.6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
              "?????? ????????? ??????????????????.\n???????????? ??? ???????????? ?????? ????????? ?????????!",
              style: TextStyles.smallFFTextStyle,
          ),

          IconButton(
              onPressed: (){
                fToast.removeCustomToast();
              },
              icon: SvgPicture.asset(
                'assets/icons/close_toast.svg',
                fit: BoxFit.scaleDown,
              )
          )
        ],
      )
    );

    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  getExampleAccent() async {

    var url = Uri.parse('${serverHttp}/statements/${widget.id}');
    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}" });
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
    else if(response.statusCode == 401){
      String? before = _authManager.getToken();
      await RefreshToken(context);

      if(before != _authManager.getToken()){
        getExampleAccent();
      }
    }
    else{
      print(response.body);
    }
  }



  Future<dynamic> getTTS() async {

    var url = Uri.parse('${serverHttp}/statements/record/${widget.id}');

    final response = await http.get(url, headers: {'accept': 'application/json', "content-type": "audio/wav", "authorization" : "Bearer ${_authManager.getToken()}"});

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

    var url = Uri.parse('${serverHttp}/bookmark?type=STATEMENT&fk=${widget.id}');


    final response = await http.post(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}", "RefreshToken" : "Bearer ${_authManager.getRefreshToken()}" });

    if (response.statusCode == 200) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }
  }

  void deleteBookmark () async {
    var url = Uri.parse('${serverHttp}/bookmark?type=STATEMENT&fk=${widget.id}');

    final response = await http.delete(url, headers: {'accept': 'application/json', "content-type": "application/json", "authorization" : "Bearer ${_authManager.getToken()}", "RefreshToken" : "Bearer ${_authManager.getRefreshToken()}" });

    if (response.statusCode == 200) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }
  }

  getAccentEvaluation() async {
    var url = Uri.parse('${serverHttp}/practiced?type=STATEMENT&fk=${widget.id.toString()}&isTodayStudy=true');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({'accept': 'application/json', "content-type": "multipart/form-data" , "authorization" : "Bearer ${_authManager.getToken()}"});

    request.files.add(await http.MultipartFile.fromPath('record', recordingPath));


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
    else{
      showCustomToast();
      setState(() {
        recordingState = 1;
        _isRecording = false;
      });
    }
  }

  String accuracyComment(double score){
    if (score > 5 ) {
      return "?????? ??? ????????? ?????????!";
    }
    else if(score > 3 && score <= 5) {
      return "?????? ???????????????!";
    }
    else{
      return "???????????????!!";
    }
  }

  Widget accuracyRank(double score){
    if (score > 5 ) {
      return const Text(
        "B ",
        style: TextStyles.mediumBTextStyle,
      );
    }
    else if(score > 3 && score <= 5) {
      return const Text(
        "A ",
        style: TextStyles.mediumATextStyle,
      );
    }
    else{
      return const Text(
        "S ",
        style: TextStyles.mediumSTextStyle,
      );
    }
  }

  Widget rankIcon(double score){
    if (score > 5 ) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/flower.svg',
            color: ColorStyles.saeraYellow2,
            fit: BoxFit.scaleDown,
          ),
          const Text(
            "B",
            style: TextStyles.largeWhiteTextStyle,
          )
        ],
      );
    }
    else if(score > 3 && score <= 5) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/flower.svg',
            color: ColorStyles.saeraPink,
            fit: BoxFit.scaleDown,
          ),
          const Text(
            "A",
            style: TextStyles.largeWhiteTextStyle,
          )
        ],
      );
    }
    else if(score == 0){
      return Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/flower.svg',
            color: ColorStyles.searchFillGray,
            fit: BoxFit.scaleDown,
          ),
        ],
      );
    }
    else{
      return Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/flower.svg',
            color: ColorStyles.saeraRed,
            fit: BoxFit.scaleDown,
          ),
          const Text(
            "S",
            style: TextStyles.largeWhiteTextStyle,
          )
        ],
      );
    }
  }


  @override
  void initState(){
    initRecorder();
    getExampleAccent();
    _isAudioReady = getTTS();
    fToast = FToast();
    fToast.init(context);

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

        if(Platform.isAndroid){
          Directory appFolder = Directory("/storage/emulated/0/saera");
          bool appFolderExists = await appFolder.exists();

          if (!appFolderExists) {
            final created = await appFolder.create(recursive: true);
            print(created.path);
          }
        }

        await _recorder.openRecorder();
        isRecorderReady = true;
      }

    }

  }

  Future startRecording() async {
    if(!isRecorderReady){
      return;
    }
    if(Platform.isAndroid){
      await _recorder.startRecorder(toFile: '/storage/emulated/0/saera/practiceAudio.wav');
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
    print("????????? ?????????????????????. ${audioFile.path}");

    if(Platform.isAndroid){
      recordingPath = '/storage/emulated/0/saera/practiceAudio.wav';
    }
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
                color: ColorStyles.saeraAppBar,
                fit: BoxFit.scaleDown,
              ),
              label: const Text(' ??????',
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
                color: ColorStyles.saeraAppBar,
                fit: BoxFit.scaleDown,
              )
          )

        ],
      ),
    );
  }

  Widget practiceSentenceSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.only(top:20.0, bottom: 20.0),
      decoration: BoxDecoration(
          color: ColorStyles.searchFillGray,
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
        SvgPicture.asset(
            'assets/icons/flag.svg',
          color: ColorStyles.saeraRed,
        ),
        const SizedBox(width: 9,),
        const Text(
          "??? ????????? ????????? ????????? ??????????",
          style: TextStyles.medium00BoldTextStyle,
        )

      ],
    );
  }

  Widget exampleGraph(){
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 135,
      decoration: BoxDecoration(
        color: ColorStyles.saeraWhite,
        borderRadius: BorderRadius.circular(16), //border radius exactly to ClipRRect
        boxShadow:[
          BoxShadow(
            color: ColorStyles.black00.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: FutureBuilder(
            future: _isAudioReady,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
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
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }
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
              //?????? ????????? data??? ?????? ?????? ?????? ???????????? ???????????? ????????? ??????
              if (snapshot.hasData == false) {
                // return CircularProgressIndicator();
                return before_audio_bar();
              }
              //error??? ???????????? ??? ?????? ???????????? ?????? ??????
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }
              // ???????????? ??????????????? ???????????? ?????? ?????? ????????? ??????
              else {
                // AudioBar??? ????????? ?????? ??????
                //return AudioBar(recordPath: audioPath, isRecording: false, isAccent: true);

                return AudioBar(recordPath: audioPath, isRecording: false, isAccent: true);
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
        ClipPath(
            clipper: ProfileImageClipper(),
            child: Container(
              width: 20,
              height: 21,
              child: Image.network("${_authManager.getPhoto()}"),
            )

        ),
        const SizedBox(width: 9,),
        Text(
          "?????? ${_authManager.getName()}?????? ???????????????.",
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
          margin: const EdgeInsets.only(top: 8),
          height: 135,
          decoration: BoxDecoration(
            color: ColorStyles.saeraRed,
            borderRadius: BorderRadius.circular(16), //border radius exactly to ClipRRect
            boxShadow:[
              BoxShadow(
                color: ColorStyles.saeraRed.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "????????? ?????? ????????? ???????????????.",
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
          margin: const EdgeInsets.only(top: 8),
          height: 135,
          decoration: BoxDecoration(
            color: ColorStyles.saeraPink,
            borderRadius: BorderRadius.circular(16), //border radius exactly to ClipRRect
            boxShadow:[
              BoxShadow(
                color: ColorStyles.saeraPink.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(top:11),
                  child: const Text(
                    "?????? ????????????...\n????????? ?????? ?????? ????????? ????????? ??? ?????????.",
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
          margin: const EdgeInsets.only(top: 8),
          height: 135,
          decoration: BoxDecoration(
            color: ColorStyles.saeraPink2,
            borderRadius: BorderRadius.circular(16), //border radius exactly to ClipRRect
            boxShadow:[
              BoxShadow(
                color: ColorStyles.saeraPink2.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4), // changes position of shadow
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
                      "????????? ???????????? ????????????...\n?????? ??? ????????????!",
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
            margin: const EdgeInsets.only(top: 8),
            height: 135,
            decoration: BoxDecoration(
              color: ColorStyles.saeraWhite,
              borderRadius: BorderRadius.circular(16), //border radius exactly to ClipRRect
              boxShadow:[
                BoxShadow(
                  color: ColorStyles.saeraRed.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4), // changes position of shadow
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
                      accuracyRate = 0;
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
              color: ColorStyles.saeraRed.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    const Text("????????? ",
                      style: TextStyles.medium25TextStyle,
                    ),
                    accuracyRank(accuracyRate),
                    const Text(
                      " | ",
                    style: TextStyles.mediumEFTextStyle,
                    ),
                    Text(
                      accuracyComment(accuracyRate),
                      style: TextStyles.medium25TextStyle,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  child: const Text("?????? ?????? ????????? +100xp",
                    style: TextStyles.small99TextStyle,
                  ),
                )


              ],
            ),

            Row(
              children: [
                rankIcon(accuracyRate),
                const SizedBox(
                  width: 16,
                )
              ],
            )
          ],
        )
    );
  }

  Widget expInitSection() {
    return Container(
        margin: const EdgeInsets.only(top: 13, bottom: 25),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        height: 80,
        decoration: BoxDecoration(
          color: ColorStyles.saeraWhite,
          borderRadius: BorderRadius.circular(8), //border radius exactly to ClipRRect
          boxShadow:[
            BoxShadow(
              color: ColorStyles.saeraRed.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("????????? ????????????\n$userName?????? ?????? ???????????? ??? ??? ?????????.",
                  style: TextStyles.regular99TextStyle,
                ),
              ],
            ),

            Row(
              children: [
                rankIcon(accuracyRate),
                const SizedBox(
                  width: 16,
                )
              ],
            )
          ],
        )
    );
  }

  Widget before_audio_bar() {
    return Container(
      margin: const EdgeInsets.only(left: 2.0, right: 16.0, top: 8.0),
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
              return AudioBar(recordPath: recordingPath, isRecording: true, isAccent: true);
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

          (){
            if(accuracyRate  == 0){
              return expInitSection();
            }
            else{
              return expSection();
            }
          }(),

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
