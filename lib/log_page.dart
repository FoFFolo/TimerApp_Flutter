import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:intl/intl.dart';
import 'package:timer_app/my_event_list_builder.dart';
import 'LogStorage/workouts_storage.dart' as storage;

final Map<DateTime, List<CleanCalendarEvent>> _events = {};

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String monthSelected =
      DateFormat('MMM').format(DateTime(0, DateTime.now().month));
  int monthWorkouts = 0;
  // int? monthWorkouts = 0;
  double percDiffMonthWorkouts = 0;
  // final Map<DateTime, List<CleanCalendarEvent>> _events = {
  //   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
  //     CleanCalendarEvent('Event A',
  //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day, 10, 0),
  //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day, 12, 0),
  //         description: 'A special event',
  //         color: Colors.blue),
  //   ],
  //   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
  //       [
  //     CleanCalendarEvent('Event B',
  //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 10, 0),
  //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 12, 0),
  //         color: Colors.orange),
  //     CleanCalendarEvent('Event C',
  //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 14, 30),
  //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 17, 0),
  //         color: Colors.pink),
  //   ],
  // };

  @override
  void initState() {
    super.initState();

    // addEvent
    // _events.addAll({
    //   DateTime(
    //       DateTime.now().year, DateTime.now().month, DateTime.now().day + 1): [
    //     CleanCalendarEvent('Event A',
    //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day, 10, 0),
    //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day, 12, 0),
    //         description: 'A special event',
    //         color: Colors.blue),
    //   ]
    // });

    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    setState(() {
      selectedYear = DateTime.now().year;
      selectedMonth = DateTime.now().month;
      monthWorkouts =
          getLengthMonthEvents(DateTime.now().year, DateTime.now().month);

      percDiffMonthWorkouts =
          getMonthDiffPerc(DateTime.now().year, DateTime.now().month);
    });

    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   refreshEvents();
    // });
  }

  late int selectedYear, selectedMonth, selectedDay;
  @override
  Widget build(BuildContext context) {
    const double textSize = 15;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trainings Calendar"),
        elevation: 7,

        backgroundColor: Colors.white,
        centerTitle: true,
        foregroundColor: Colors.black,
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: GestureDetector(
        //       onTap: () {
        //         debugPrint("tapped stats");
        //       },
        //       child: const Icon(Icons.bar_chart_sharp),
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Calendar(
              startOnMonday: true,
              weekDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
              events: _events,
              isExpandable: true,
              eventDoneColor: Colors.green,
              selectedColor: Colors.pink,
              todayColor: Colors.blue,
              eventColor: Colors.grey,
              locale: 'en_EN',
              todayButtonText: '',
              isExpanded: true,
              expandableDateFormat: 'EEEE, dd. MMMM yyyy',
              dayOfWeekStyle: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
              // onEventSelected: (value) {
              //   deleteEventDialog(value);
              // },
              onExpandStateChanged: (value) {
                debugPrint("!!!EXPAND STATE!!!");
              },
              onMonthChanged: (value) {
                debugPrint("onMonth: $value");
                setState(
                  () {
                    selectedYear = int.parse(value.toString().split('-')[0]);
                    selectedMonth = int.parse(value.toString().split('-')[1]);
                    selectedDay =
                        int.parse(value.toString().split(' ')[0].split('-')[2]);
                    monthSelected = DateFormat('MMM').format(
                        DateTime(0, int.parse(value.toString().split('-')[1])));
                    debugPrint("month changed: $monthSelected");
                    monthWorkouts =
                        getLengthMonthEvents(selectedYear, selectedMonth);
                    debugPrint("monthWorkouts: $monthWorkouts");
                    percDiffMonthWorkouts =
                        getMonthDiffPerc(selectedYear, selectedMonth);
                  },
                );
              },
              eventListBuilder: (context, events) {
                debugPrint("enveto?");
                return MyEventListBuilder(context, events, refreshEvents);
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // border: Border.all(width: 20),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[400],
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 10.0),
                            //   child: Text(
                            //     "$monthSelected stats:",
                            //     style: const TextStyle(fontSize: textSize),
                            //   ),
                            // ),
                            Tooltip(
                              message: "Workouts done in $monthSelected",
                              child: Text(
                                "WORKOUTS: $monthWorkouts",
                                style: const TextStyle(fontSize: textSize),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Text(
                                "|",
                                style: TextStyle(fontSize: textSize),
                              ),
                            ),
                            Tooltip(
                              message: "Differences with the previous month",
                              child: Text(
                                "PREV. MONTH: $percDiffMonthWorkouts%",
                                style: const TextStyle(fontSize: textSize),
                              ),
                            ),
                            Icon(
                              percDiffMonthWorkouts > 0
                                  ? Icons.arrow_upward
                                  : percDiffMonthWorkouts < 0
                                      ? Icons.arrow_downward
                                      : Icons.trending_neutral,
                              color: percDiffMonthWorkouts > 0
                                  ? Colors.green
                                  : percDiffMonthWorkouts < 0
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handleNewDate(date) {
    debugPrint('Date selected: $date');
  }

  void refreshEvents() {
    setState(() {
      _events;
      monthWorkouts = getLengthMonthEvents(selectedYear, selectedMonth);
      percDiffMonthWorkouts = getMonthDiffPerc(selectedYear, selectedMonth);
      debugPrint("REFRESHED");
    });
  }

  int getLengthMonthEvents(year, month) {
    int numEvents = 0;

    for (var i = 0; i < 31; i++) {
      numEvents += _events.containsKey(DateTime(year, month, i))
          ? _events[DateTime(year, month, i)]!.length
          : 0;
    }

    return numEvents;
  }

  double getMonthDiffPerc(year, month) {
    int lastMonthWorkouts = getLengthMonthEvents(year, month - 1);

    int thisMonthWorkouts = getLengthMonthEvents(year, month);

    double percDiff = ((thisMonthWorkouts - lastMonthWorkouts) * 100) /
        (lastMonthWorkouts * 2);
    debugPrint("diff: $percDiff");
    return lastMonthWorkouts == 0 && thisMonthWorkouts == 0
        ? 0.0
        : lastMonthWorkouts == 0
            ? (thisMonthWorkouts * 100)
            : thisMonthWorkouts == 0
                ? (-lastMonthWorkouts * 100)
                : percDiff;
  }

  // Widget _buildEventList() {
  //   return Expanded(
  //   child: ListView.builder(
  //     padding: const EdgeInsets.all(0.0),
  //     itemBuilder: (BuildContext context, int index) {
  //       final CleanCalendarEvent event = _selectedEvents[index];
  //       final String start =
  //           DateFormat('HH:mm').format(event.startTime).toString();
  //       final String end =
  //           DateFormat('HH:mm').format(event.endTime).toString();
  //       return ListTile(
  //         contentPadding:
  //             const EdgeInsets.only(left: 2.0, right: 8.0, top: 2.0, bottom: 2.0),
  //         leading: Container(
  //           width: 10.0,
  //           color: event.color,
  //         ),
  //         title: Text(event.summary),
  //         subtitle:
  //             event.description.isNotEmpty ? Text(event.description) : null,
  //         trailing: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [Text(start), Text(end)],
  //         ),
  //         onTap: () {},
  //       );
  //     },
  //     itemCount: _selectedEvents.length,
  //   ),
  // );
  // }
}

void addEvent(int year, int month, int day, int startHour, int startMinute,
    int endHour, int endMinute, String totalTime, Color color) {
  if (!_events.containsKey(DateTime(year, month, day))) {
    debugPrint("Create date in _events");
    _events[DateTime(year, month, day)] = [];
  }

  _events[DateTime(year, month, day)]?.add(
    CleanCalendarEvent(
      'Workout',
      startTime: DateTime(year, month, day, startHour, startMinute),
      endTime: DateTime(year, month, day, endHour, endMinute),
      description: "Time: $totalTime",
      color: color,
      isDone: true,
    ),
  );
}

void removeEvent(CleanCalendarEvent event) {
  debugPrint("remove element");
  var dateEvent = event.startTime.toString().split(" ")[0].split("-");
  debugPrint(dateEvent.toString());
  _events[DateTime(int.parse(dateEvent[0]), int.parse(dateEvent[1]),
          int.parse(dateEvent[2]))]
      ?.remove(event);
  debugPrint("rimosso evento");

  storage.WorkoutsStorage().removeEventFromFile(event);
}

Future<bool> deleteEventDialog(
    BuildContext context, CleanCalendarEvent value) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text("Delete Event?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              // call to workout storage that inspect the file and delete the event
              removeEvent(value);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Workout event deleted'),
                duration: Duration(seconds: 1),
              ));
            },
            child: const Text("YES"),
          ),
        ],
      );
    },
  );
}
