import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:todoapp/constants/custom_icons.dart';
import 'package:todoapp/constants/text_styles.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final String startEndTime;
  final void Function()? editOnTap;
  final void Function()? deleteOnTap;
  final bool isChecked;
  final void Function(bool?)? isCompleted;
  final bool animate;
  final String alarmMode;

  const TaskCard({
    super.key,
    required this.taskName,
    required this.isCompleted,
    required this.startEndTime,
    required this.editOnTap,
    required this.deleteOnTap,
    required this.isChecked,
    required this.animate,
    required this.alarmMode,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0XFFD5D5D5),
            width: 1,
          )),
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          shape: const CircleBorder(),
          onChanged: isCompleted,
        ),
        title: Text(
          taskName,
          style: CustomTextStyles.titleStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          startEndTime,
          style: CustomTextStyles.smallStyle,
        ),
        trailing: IntrinsicWidth(
          child: Row(
            spacing: 8,
            children: [
              GestureDetector(
                onTap: editOnTap,
                child: const CustomIcons(icon: Symbols.edit_note),
              ),
              CustomIcons(
                icon: alarmMode == 'on' ? Symbols.alarm_on : Symbols.alarm_off,
              ),
              GestureDetector(
                onTap: deleteOnTap,
                child: const CustomIcons(icon: Symbols.delete),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
      ),
    );

    return animate
        ? content
            .animate(
              onPlay: (controller) => controller.repeat(), // loop
            )
            .shimmer(duration: 2.seconds, delay: 0.seconds, color: Colors.blue)
        : content;
  }
}
