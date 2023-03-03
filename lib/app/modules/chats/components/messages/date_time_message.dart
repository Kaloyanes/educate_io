import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/chats/components/message_settings.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class DateTimeMessage extends StatefulWidget {
  const DateTimeMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc,
      required this.personName});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;
  final String personName;

  @override
  State<DateTimeMessage> createState() => _DateTimeMessageState();
}

class _DateTimeMessageState extends State<DateTimeMessage> {
  void saveCalendar(DateTime date) {
    final Event event = Event(
      title: 'Среща с ${widget.personName}',
      startDate: date,
      endDate: date.add(const Duration(hours: 1, minutes: 30)),
      iosParams: const IOSParams(
        reminder: Duration(hours: 1),
      ),
    );

    Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat("H:mm | d/MM/yyyy");
    DateFormat messageFormatter = DateFormat("d/MM/yyyy\nH:mm");

    bool showInfo = false;

    DateTime date = (widget.message.value as Timestamp).toDate();

    return Align(
      alignment:
          widget.ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          setState(() {
            showInfo = !showInfo;
          });
          HapticFeedback.selectionClick();
        },
        onLongPress: () async {
          if (!widget.ownMessage) return;

          await showModalBottomSheet<String>(
            context: context,
            builder: (context) => MessageSettings(
              doc: widget.doc,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.ownMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: widget.ownMessage
                        ? const Radius.circular(40)
                        : const Radius.circular(10),
                    bottomRight: const Radius.circular(40),
                    topLeft: const Radius.circular(40),
                    topRight: widget.ownMessage
                        ? const Radius.circular(10)
                        : const Radius.circular(40),
                  ),
                  color: widget.ownMessage
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Column(
                  children: [
                    Text(
                      messageFormatter.format(date),
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => saveCalendar(date),
                      icon: const Icon(Icons.calendar_month),
                      label: const Text("Запази в календара"),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                height: showInfo ? 20 : 0,
                duration: 600.ms,
                alignment: widget.ownMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  formatter.format(widget.message.time),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
