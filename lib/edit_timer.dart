import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';

class EditTimer extends StatelessWidget {
  final Function(int) changeSeconds;
  final Function(int) changeMinutes;

  const EditTimer(
      {required this.changeSeconds, required this.changeMinutes, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: const Color.fromARGB(66, 255, 255, 255),
      width: MediaQuery.of(context).size.width,
      height: 380,
      //margin: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              HoldDetector(
                onHold: () => changeMinutes(1),
                child: const Icon(
                  Icons.add_circle,
                  size: 45,
                ),
              ),
              HoldDetector(
                onHold: () => changeMinutes(-1),
                child: const Icon(
                  Icons.remove_circle,
                  size: 45,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              HoldDetector(
                onHold: () => changeSeconds(30),
                child: const CircleAvatar(
                  backgroundColor: Colors.black87,
                  radius: 19,
                  child: Icon(
                    Icons.keyboard_double_arrow_up_rounded,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              HoldDetector(
                onHold: () => changeSeconds(1),
                child: const Icon(
                  Icons.add_circle,
                  size: 45,
                ),
              ),
              const SizedBox(height: 133),
              HoldDetector(
                onHold: () => changeSeconds(-1),
                child: const Icon(
                  Icons.remove_circle,
                  size: 45,
                ),
              ),
              const SizedBox(height: 10),
              HoldDetector(
                onHold: () => changeSeconds(-30),
                child: const CircleAvatar(
                  backgroundColor: Colors.black87,
                  radius: 19,
                  child: Icon(
                    Icons.keyboard_double_arrow_down_rounded,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
