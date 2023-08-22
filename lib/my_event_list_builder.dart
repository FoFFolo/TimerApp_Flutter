import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'my_event.dart';

class MyEventListBuilder extends StatefulWidget {
  final BuildContext context;
  final List<CleanCalendarEvent> events;
  final VoidCallback refreshListBuilder;

  const MyEventListBuilder(this.context, this.events, this.refreshListBuilder,
      {super.key});

  @override
  State<MyEventListBuilder> createState() => _MyEventListBuilderState();
}

class _MyEventListBuilderState extends State<MyEventListBuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.events.length,
          itemBuilder: (context, index) =>
              MyEvent(widget.events[index], widget.refreshListBuilder),
        ),
      ),
    );
  }
}
