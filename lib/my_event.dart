import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'log_page.dart' as log_page;
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class MyEvent extends StatefulWidget {
  final CleanCalendarEvent event;
  final VoidCallback refreshListBuilder;

  const MyEvent(this.event, this.refreshListBuilder, {super.key});

  @override
  State<MyEvent> createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  bool setAutoClose = true;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        openThreshold: 0.2,
        dismissible: DismissiblePane(
          onDismissed: () {
            widget.refreshListBuilder();
          },
          confirmDismiss: () async {
            return await log_page.deleteEventDialog(context, widget.event);
          },
          // if user dont' wanna delete the event, the dismiss will close
          closeOnCancel: true,
          // duration of delete animation
          resizeDuration: const Duration(milliseconds: 100),
          // threshold the dismiss will auto run
          dismissThreshold: 0.50,
        ),
        children: [
          SlidableAction(
            backgroundColor: Colors.red.shade200,
            foregroundColor: Colors.white,
            onPressed: (context) {
              // widget.showDeleteDialog(context, widget.events[widget.index]);
              // log_page.deleteEventDialog(context, widget.events[widget.index]);
              // setState(() {
              //   const log_page.LogPage();
              //   debugPrint("refreshato");
              // });
              log_page.deleteEventDialog(context, widget.event).then((value) {
                widget.refreshListBuilder();
              });
            },
            icon: Icons.delete,
            label: "Delete",
            // close the slidable element
            autoClose: !setAutoClose,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: widget.event.color,
                  width: 10,
                ),
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.event.summary,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(widget.event.description)
                    ],
                  ),
                  Flexible(
                    // forced to fill the available space so it can align to the end
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.event.startTime.hour}:${widget.event.startTime.minute}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.event.endTime.hour}:${widget.event.endTime.minute}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
