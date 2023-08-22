import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'globalVariables.dart' as globals;
import 'edit_timer.dart' as edit_timer;

class BuildGestureDetector extends StatefulWidget {
  final bool isEditTimerVisible;

  const BuildGestureDetector(this.isEditTimerVisible, {super.key});

  @override
  State<BuildGestureDetector> createState() => _BuildGestureDetectorState();
}

class _BuildGestureDetectorState extends State<BuildGestureDetector>
    with AutomaticKeepAliveClientMixin<BuildGestureDetector> {
  int minutes = 0;
  int seconds = 5;

  bool isTapped = false;
  bool isFirstTap = true;

  late Timer myTimer;
  // salvare valori del timer per il reset
  late List<int> timerValues;

  Icon floatingIconTimer = const Icon(Icons.pause);
  bool isTimerPaused = false;

  void stopTimer() {
    myTimer.cancel();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        minutes = timerValues[0];
        seconds = timerValues[1];
        isTapped = false;
      });
    });
    debugPrint("TIMER TERMINATO");
  }

  void startTimer() {
    timerValues = [minutes, seconds];

    setState(() {
      isTapped = true;
    });
    myTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!globals.isEditTimerVisible && !isTimerPaused) {
        debugPrint("DECREMENTO TEMPO");
        setState(() {
          if (seconds == 0 && minutes > 0) {
            minutes--;
            seconds = 59;
          } else if (seconds > 0) {
            seconds--;
          }
        });
      }
      if (minutes == 0 && seconds == 0) {
        // STOP TIMER
        stopTimer();

        // produrre suono
        AudioPlayer().play(AssetSource('tap_timer.wav'));
      }
    });
  }

  void _changeSeconds(int seconds) {
    int newSeconds = (this.seconds + seconds) % 60;
    debugPrint("newSeconds = $newSeconds");
    setState(() {
      this.seconds = newSeconds;
      // if (newSeconds < 0) {
      //   this.seconds = 59;
      // } else if (newSeconds <= 59) {
      //   this.seconds = newSeconds;
      // } else {
      //   this.seconds = 0;
      // }
    });
  }

  void _changeMinutes(int minutes) {
    int newMinutes = (this.minutes + minutes) % 60;
    setState(() {
      this.minutes = newMinutes;
      // if (newMinutes < 0) {
      //   this.minutes = 59;
      // } else if (newMinutes <= 59) {
      //   this.minutes = newMinutes;
      // } else {
      //   this.minutes = 0;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double center = MediaQuery.of(context).size.height / 2 - 40;

    return Stack(
      children: [
        GestureDetector(
          // rileva il tap ovunque nello schermo
          behavior: HitTestBehavior.opaque,

          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontFamily: 'timer-font',
                    letterSpacing: 2,
                    fontSize: 100,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            debugPrint(
                "isTapped: $isTapped - isEditTimerVisible: ${globals.isEditTimerVisible}");
            if (!isTapped && !globals.isEditTimerVisible) {
              debugPrint(
                  "Puoi avviare timer! - isTapped: $isTapped - editTimer: false");

              AudioPlayer player = AudioPlayer();
              player.play(AssetSource('tap_timer.wav'));
              debugPrint("sound produced");

              // START TIMER
              startTimer();
            }
          },
        ),
        Visibility(
          visible: widget.isEditTimerVisible,
          child: Positioned(
            bottom: center - 175,
            child: edit_timer.EditTimer(
              changeSeconds: _changeSeconds,
              changeMinutes: _changeMinutes,
            ),
          ),
        ),
        Visibility(
          visible: isTapped && !globals.isEditTimerVisible ? true : false,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(8),
              child: FloatingActionButton(
                tooltip: isTimerPaused ? "Restart timer" : "Pause timer",
                onPressed: () {
                  if (!isTimerPaused) {
                    setState(() {
                      floatingIconTimer = const Icon(Icons.play_arrow_rounded);
                      debugPrint("timer paused");
                    });
                  } else {
                    setState(() {
                      floatingIconTimer = const Icon(Icons.pause);
                      debugPrint("timer restarted");
                    });
                  }
                  setState(() {
                    isTimerPaused = !isTimerPaused;
                  });
                },
                backgroundColor: Colors.red,
                child: floatingIconTimer,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
