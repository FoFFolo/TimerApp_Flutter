import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../log_page.dart' as log_page;

class WorkoutsStorage {
  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();

    debugPrint("directory: ${directory.path}");
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File("$path/workouts_log.json");
  }

  Future<File> filePath() async {
    return await _localFile;
  }

  Future<String> logFileToJson() async {
    final file = await _localFile;

    // Read the file
    final contents = file.readAsStringSync();
    debugPrint("cont: $contents");

    return file.readAsString();
  }

  void writeToFile(Map log) async {
    final file = await _localFile;
    debugPrint("file_path: $file");

    // jsonDecode returns List<dynamic> because I need a list
    List<dynamic> total = [];

    // check if file is empty
    final fileData = file.readAsStringSync();
    if (fileData != '') {
      debugPrint("file populated");
      final List<dynamic> fileList = jsonDecode(fileData);

      // add stuff of the file to total
      total = fileList;
    } else {
      debugPrint("file is empty");
    }

    // add the new workout to the list
    debugPrint("log: $log");
    total.add(log);
    // write to the file
    // file.writeAsStringSync('');
    file.writeAsStringSync(jsonEncode(total));
    debugPrint("file written");

    debugPrint("leggi sto file");
    debugPrint(file.readAsStringSync());
  }

  void setUpWorkouts() async {
    final file = await _localFile;

    debugPrint("File exists? ${file.existsSync()}");
    if (!file.existsSync()) {
      debugPrint("creating file");
      file.writeAsString('');
    } else {
      debugPrint("file exists");
    }

    final fileData = file.readAsStringSync();
    if (fileData != '') {
      debugPrint("file populated");
      final List<dynamic> fileList = jsonDecode(fileData);

      int i = 0;
      int col, colPos;
      for (var workout in fileList) {
        // get info of each workout registered in the file
        debugPrint("${i.toString()}: ${workout.toString()}");
        i++;
        if (workout.toString() == '{}') {
          debugPrint("CONTINUE");
          continue;
        }
        colPos = workout['color'].toString().indexOf('0x');
        col = int.parse(
            workout['color'].toString().substring(colPos, colPos + 10));
        log_page.addEvent(
            workout['date'][0],
            workout['date'][1],
            workout['date'][2],
            workout['startTime'][0],
            workout['startTime'][1],
            workout['endTime'][0],
            workout['endTime'][1],
            workout['totalTime'],
            Color(col));
        debugPrint("workout added");
      }
    }
  }

  void deleteFile() async {
    final file = await _localFile;

    file.deleteSync();
    debugPrint("file deleted");
  }

  void removeEventFromFile(CleanCalendarEvent event) async {
    final file = await _localFile;
    final fileData = file.readAsStringSync();

    final startTime = event.startTime.toString().split(" ");
    final endTime = event.endTime.toString().split(" ");
    Map<String, dynamic> eventList = {
      "date": startTime[0].split("-").map(int.parse).toList(),
      "startTime":
          startTime[1].split(":").getRange(0, 2).map(int.parse).toList(),
      "endTime": endTime[1].split(":").getRange(0, 2).map(int.parse).toList(),
      "totalTime": event.description.split(" ")[1],
      "color": event.color
    };

    debugPrint("start tempo: ${eventList['date'][1].runtimeType}");

    // bool isFound = true;
    final List<dynamic> fileList = jsonDecode(fileData);
    for (var workout in fileList) {
      debugPrint("work: $workout");
      debugPrint("even: $eventList");
      // for (var elem in workout.keys) {
      //   debugPrint("key: $elem");
      //   debugPrint("work: ${workout[elem].toString()}");
      //   debugPrint("even: ${eventList[elem].toString()}");
      //   if (workout[elem].toString() != eventList[elem].toString()) {
      //     debugPrint("event not uqual");
      //     isFound = false;
      //     continue;
      //   }
      // }
      // debugPrint("isFound a fine: $isFound");
      // if (isFound) {
      //   debugPrint("event founded!!!");
      //   debugPrint("work: $workout");
      //   debugPrint("even: $eventList");

      //   fileList.remove(workout);
      //   // write to the file without the removed event
      //   file.writeAsStringSync(jsonEncode(fileList));

      //   debugPrint("event completely removed");
      //   break;
      // }
      if (workout.toString() == eventList.toString()) {
        debugPrint("event founded!!!");
        debugPrint("work: $workout");
        debugPrint("even: $eventList");

        fileList.remove(workout);
        // write to the file without the removed event
        file.writeAsStringSync(jsonEncode(fileList));

        debugPrint("event completely removed");
        break;
      }
    }
    debugPrint("erasing finished");
  }
}
