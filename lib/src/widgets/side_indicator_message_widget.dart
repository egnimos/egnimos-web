import 'package:egnimos/src/theme/color_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MessageIndicator {
  final String? id;
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Duration? duration;

  MessageIndicator({
    this.id,
    required this.leading,
    this.subtitle,
    required this.title,
    this.duration,
  });
}

final indicatorNotifier = ValueNotifier<List<MessageIndicator>>([]);
void showMessageIndicator(MessageIndicator msg) {
  final newMessage = MessageIndicator(
    id: const Uuid().v4(),
    leading: msg.leading,
    title: msg.title,
    subtitle: msg.subtitle,
  );
  final messages = indicatorNotifier.value;
  messages.add(newMessage);
  indicatorNotifier.value = messages;
}

void removeFromStack(String id) {
  final messages = indicatorNotifier.value;
  messages.removeWhere((msg) => msg.id == id);
  indicatorNotifier.value = messages;
}

class SideIndicatorMessage extends StatefulWidget {
  const SideIndicatorMessage({Key? key}) : super(key: key);

  @override
  State<SideIndicatorMessage> createState() => _SideIndicatorMessageState();
}

class _SideIndicatorMessageState extends State<SideIndicatorMessage> {
  Widget indicatorWidget({
    required String id,
    required Widget leading,
    required Widget title,
    Duration? duration,
    Widget? subtitle,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      if (duration != null) {
        Future.delayed(
          duration,
          () => removeFromStack(id),
        );
      }
      return GestureDetector(
        onTap: () => removeFromStack(id),
        child: Container(
          width: (constraints.maxWidth / 100.0) * 30.0,
          height: 80.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 30,
                spreadRadius: -5,
                offset: const Offset(0, 10),
              )
            ],
            borderRadius: BorderRadius.circular(10.0),
            border: const Border(
              bottom: BorderSide(
                width: 2.6,
                color: ColorTheme.bgColor10,
              ),
            ),
          ),
          child: Row(
            children: [
              //leading
              Flexible(
                child: leading,
              ),
              const SizedBox(
                width: 16.0,
              ),
              //column
              Column(
                children: [
                  //title
                  Flexible(
                    child: title,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  //subtitle
                  if (subtitle != null)
                    Flexible(
                      child: subtitle,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MessageIndicator>>(
        valueListenable: indicatorNotifier,
        builder: (context, value, __) {
          return Align(
            alignment: Alignment.bottomRight,
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              children: [
                //indicator widget
                ...value
                    .map((v) => indicatorWidget(
                          id: v.id!,
                          leading: v.leading,
                          title: v.title,
                          subtitle: v.subtitle,
                        ))
                    .toList(),
              ],
            ),
          );
        });
  }
}
