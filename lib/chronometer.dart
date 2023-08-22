import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'log_page.dart' as log_page;
import 'LogStorage/workouts_storage.dart' as json_storage;

class Chronometer extends StatefulWidget {
  const Chronometer({super.key});

  @override
  State<Chronometer> createState() => _ChronometerState();
}

class _ChronometerState extends State<Chronometer>
    with AutomaticKeepAliveClientMixin<Chronometer> {
  final Color defaultColor = Colors.redAccent;

  bool isChronometerStarted = false;
  final Color startBtnDefaultColor = Colors.redAccent.shade700;

  final double defaultSize = 40;

  int seconds = 0;
  int minutes = 0;
  int hours = 0;

  bool isChronometerPaused = true;
  bool isChronometerStopped = false;
  bool isChronometerForcedStop = false;

  late Timer myTimer;

  late List<int> startHour, endHour;
  late String totalTime;
  late Color randomColor;

  void startTimer() {
    myTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isChronometerPaused) {
        setState(
          () {
            if (seconds < 59) {
              seconds++;
            } else {
              seconds = 0;

              if (minutes < 59) {
                minutes++;
              } else {
                minutes = 0;

                if (hours < 59) {
                  hours++;
                } else {
                  hours++;
                  timer.cancel();
                }
              }
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    startTimer();

    super.initState();
  }

  void stopResetChronometer() {
    myTimer.cancel();
    setState(() {
      isChronometerPaused = true;
      isChronometerStopped = false;
      isChronometerStarted = false;
      isChronometerForcedStop = false;

      hours = 0;
      minutes = 0;
      seconds = 0;

      startTimer();
    });
    debugPrint("Timer stoppato");
  }

  // ignore: non_constant_identifier_names
  void setState_isChronometerPaused() {
    setState(() {
      isChronometerPaused = !isChronometerPaused;
    });
  }

  void restartChronometer() {
    if (isChronometerForcedStop) {
      setState(() {
        debugPrint("Chronometer restarted");
        isChronometerPaused = false;
      });
    }
  }

  String setTotalTime() {
    return "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    totalTime = setTotalTime();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.access_time_rounded,
          color: defaultColor,
          size: defaultSize,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              totalTime,
              style: TextStyle(color: defaultColor, fontSize: defaultSize - 5),
            ),
            IconButton(
              icon: Icon(
                isChronometerPaused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                color: !isChronometerStarted
                    ? startBtnDefaultColor
                    : isChronometerStopped
                        ? defaultColor.withOpacity(0.50)
                        : defaultColor,
                size: defaultSize,
              ),
              onPressed: () {
                setState_isChronometerPaused();
                setState(() {
                  if (!isChronometerStarted) {
                    startHour = [DateTime.now().hour, DateTime.now().minute];
                    isChronometerStarted = true;
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.stop,
                color: !isChronometerStarted
                    ? defaultColor.withOpacity(0.50)
                    : defaultColor,
                size: defaultSize,
              ),
              onPressed: !isChronometerStarted
                  ? null
                  : () {
                      setState(() {
                        if (!isChronometerPaused) {
                          isChronometerPaused = true;
                          isChronometerForcedStop = true;
                        } else {
                          isChronometerForcedStop = false;
                        }

                        endHour = [DateTime.now().hour, DateTime.now().minute];
                      });
                      // alert per la conferma della fine dell'allenamento
                      showAlertDialog();
                      // DA FARE....
                      // SALVARE MINUTAGGIO ALLENAMENTO
                      // AZZERARE CRONOMETRO
                      // PASSARE MINUTAGGIO A LOGPAGE.DART PER VISUALIZZARE TUTTI GLI ALLENAMENTI
                    },
            ),
            // Visibility(
            //   visible: isChronometerStopped,
            //   child: IconButton(
            //     icon: Icon(
            //       Icons.restart_alt_rounded,
            //       color: startBtnDefaultColor,
            //       size: defaultSize - 3,
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         hours = 0;
            //         minutes = 0;
            //         seconds = 0;
            //         // isChronometerPaused = false;
            //         isChronometerStopped = false;
            //         totalTime = setTotalTime();
            //         startTimer();
            //         debugPrint("Riavviato totalTime $totalTime");
            //       });
            //     },
            //   ),
            // )
          ],
        )
      ],
    );
  }

  Map<String, dynamic> getWorkoutInfo() {
    debugPrint("rand col: ${randomColor.toString()}");
    return {
      "date": [DateTime.now().year, DateTime.now().month, DateTime.now().day],
      "startTime": [startHour[0], startHour[1]],
      "endTime": [endHour[0], endHour[1]],
      "totalTime": totalTime,
      "color": randomColor.toString()
    };
  }

  void showAlertDialog() {
    List<int> rgb = [
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    ];
    randomColor = Color.fromARGB(255, rgb[0], rgb[1], rgb[2]);
    // randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    // randomColor = Colors.primaries[0xffcddc39];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Terminare l'allenamento?"),
          actions: [
            TextButton(
              child: const Text("NO"),
              onPressed: () {
                restartChronometer();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("SÌ"),
              onPressed: () {
                Navigator.of(context).pop();

                // add new workout done
                log_page.addEvent(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    startHour[0],
                    startHour[1],
                    endHour[0],
                    endHour[1],
                    totalTime,
                    randomColor);
                // log_page.pushCalendar(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const log_page.LogPage();
                    },
                  ),
                );

                // write workout info to the log .json file
                debugPrint("Write to the file");
                // debugPrint("RANDOM COLOR: $randomColor");
                json_storage.WorkoutsStorage().writeToFile(getWorkoutInfo());

                stopResetChronometer();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
