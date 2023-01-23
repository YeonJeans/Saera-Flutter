import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

class RecordBar extends StatefulWidget {

  final String recordPath;

  const RecordBar({Key? key, required this.recordPath}) : super(key: key);

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {

  bool _isPlaying = false;

  AudioPlayer audioPlayer = AudioPlayer();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String url = 'mp3/omg.mp3';

  String formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      minutes,
      seconds,
    ].join(":");
  }

  @override
  void initState(){
    super.initState();

    setAudio();

    //listen to states
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    //listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

  }

  Future setAudio() async {
    audioPlayer.setSource(AssetSource(url));
  }

  @override
  void dispose(){
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2.0, right: 16.0, top: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              if(_isPlaying){
                await audioPlayer.pause();
              }
              else{
                await audioPlayer.resume();
              }
            },
            icon: _isPlaying ?
            SvgPicture.asset('assets/icons/stop.svg',
                fit: BoxFit.scaleDown
            )
                :
            SvgPicture.asset('assets/icons/play.svg',
                fit: BoxFit.scaleDown
            ),
            iconSize: 32,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                child: Text(formatTime(position),
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
                    width: 220,
                    child: Slider(
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      activeColor: ColorStyles.primary.withOpacity(0.4),
                      inactiveColor: Color(0xffE7E7E7),
                      label: position.inSeconds.round().toString(),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);

                        //optional: play audio if was paused
                        await audioPlayer.resume();
                      },
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text(formatTime(duration),
                  style: TextStyles.small66TextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}