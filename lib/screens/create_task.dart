import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/text_styles.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/task_id.dart';
import 'package:todoapp/providers/alarm_state_provider.dart';
import 'package:todoapp/providers/button_state_provider.dart';
import 'package:todoapp/providers/current_user_provider.dart';
import 'package:todoapp/services/notifi_service.dart';
import 'package:todoapp/widgets/alert_message.dart';
import 'package:todoapp/widgets/app_button.dart';
import 'package:todoapp/widgets/app_textfield.dart';
import 'package:todoapp/widgets/category_button.dart';
import 'package:todoapp/widgets/datetime_textfield.dart';
import 'package:todoapp/widgets/task_alert.dart';

import '../constants/borders.dart';

class CreateTask extends StatefulWidget {
  final bool isCreate;
  final Task? task;

  const CreateTask({super.key, required this.isCreate, this.task});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late String _selectedCategory;
  String _alarmMode = 'off';
  late TimeOfDay notifiTime;
  late DateTime notifiDate;

  //update thee field if in EDIT mode
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      final Task task = widget.task!;
      _alarmMode = task.alarmMode;
      _taskNameController.text = task.name;
      _startTimeController.text = task.startTime;
      _endTimeController.text = task.endTime;
      _dateController.text = task.date;
      _descController.text = task.desc;
      _selectedCategory = task.category;
      //set the notification date and time
      notifiDate = DateFormat('dd MMMM yyyy, EEEE').parse(task.date);
      DateTime dt = DateFormat.jm().parseLoose(task.startTime);
      notifiTime = TimeOfDay.fromDateTime(dt);
    } else {
      _selectedCategory = 'others';
    }
  }

  //category button on tap function
  void categoryOnTap(String buttonName, BuildContext context) {
    final buttonState =
        Provider.of<ButtonStateProvider>(context, listen: false);
    if (buttonState.selectedButton == buttonName) {
      buttonState.selectButton('');
      _selectedCategory = 'others';
    } else {
      buttonState.selectButton(buttonName);
      _selectedCategory = buttonName;
    }
  }

  //alarm button on tap function
  void alarmOnTap(String value, BuildContext context) {
    _alarmMode = value;
    final alarmState = Provider.of<AlarmStateProvider>(context, listen: false);
    if (alarmState.selectedButton != value) {
      alarmState.selectButton(value);
    }
  }

  final defaultBtnColor = const Color(0XFFe0c8ff);
  final selectedBtnColor = const Color(0XFF9747FF);

  //set category button color function
  Color buttonColor(String buttonName, BuildContext context) {
    final buttonState =
        Provider.of<ButtonStateProvider>(context, listen: false);
    if (!widget.isCreate) {
      buttonState.selectButton(_selectedCategory);
      return buttonState.selectedButton == buttonName
          ? selectedBtnColor
          : defaultBtnColor;
    } else {
      return buttonState.selectedButton == buttonName
          ? selectedBtnColor
          : defaultBtnColor;
    }
  }

  //set category Text button color
  Color buttonTextColor(String buttonName, BuildContext context) {
    final buttonState =
        Provider.of<ButtonStateProvider>(context, listen: false);
    return buttonState.selectedButton == buttonName
        ? Colors.white
        : Colors.black;
  }

  //select Date and set it to textField controller
  Future<void> _calenderOnTap(context) async {
    DateTime oldDate = DateTime.now();

    if (widget.task != null) {
      oldDate = DateFormat('dd MMMM yyyy, EEEE').parse(_dateController.text);
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: oldDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (selectedDate != null) {
      notifiDate = selectedDate;
      String fullDate = DateFormat('dd MMMM yyyy, EEEE').format(selectedDate);
      _dateController.text = fullDate;
      oldDate = selectedDate;
    }
  }

  //Select Start time
  Future<void> _selectStartTime(context) async {
    //Set the UI time to Time from Task
    late TimeOfDay oldStartTime;

    if (widget.task != null) {
      DateTime rawOldTime = DateFormat.jm().parseLoose(_endTimeController.text);
      oldStartTime =
          TimeOfDay(hour: rawOldTime.hour, minute: rawOldTime.minute);
    } else {
      oldStartTime = TimeOfDay.now();
    }

    TimeOfDay? selectedStartTime =
        await showTimePicker(context: context, initialTime: oldStartTime);

    if (selectedStartTime != null) {
      //save the start time for notification
      notifiTime = selectedStartTime;
      DateTime dateTime =
          DateTime(1, 1, 1, selectedStartTime.hour, selectedStartTime.minute);
      final String startTime = DateFormat('hh:mm a').format(dateTime);
      if (_endTimeController.text.isNotEmpty) {
        DateTime rawEndTime =
            DateFormat.jm().parseLoose(_endTimeController.text);
        TimeOfDay endTime =
            TimeOfDay(hour: rawEndTime.hour, minute: rawEndTime.minute);
        if (selectedStartTime.isBefore(endTime)) {
          _startTimeController.text = startTime;
        } else {
          _startTimeController.text = '';
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Start time cannot be after end time !'),
            duration: Duration(seconds: 3),
          ));
        }
      } else {
        _startTimeController.text = startTime;
      }
    }
  }

  //Select end time
  Future<void> _selectEndTime(context) async {
    //Set the UI time to Time from Task
    TimeOfDay oldEndTime = TimeOfDay.now();

    if (widget.task != null) {
      DateTime rawOldTime = DateFormat.jm().parseLoose(_endTimeController.text);
      oldEndTime = TimeOfDay(hour: rawOldTime.hour, minute: rawOldTime.minute);
    }

    TimeOfDay? selectedEndTime = await showTimePicker(
      context: context,
      initialTime: oldEndTime,
    );

    if (selectedEndTime != null) {
      DateTime dateTime =
          DateTime(1, 1, 1, selectedEndTime.hour, selectedEndTime.minute);
      final String endTime = DateFormat('hh:mm a').format(dateTime);
      if (_startTimeController.text.isNotEmpty) {
        DateTime rawStartTime =
            DateFormat.jm().parseLoose(_startTimeController.text);
        TimeOfDay startTime =
            TimeOfDay(hour: rawStartTime.hour, minute: rawStartTime.minute);
        if (selectedEndTime.isAfter(startTime)) {
          _endTimeController.text = endTime;
        } else {
          _endTimeController.text = '';
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('End time cannot be before start time !'),
            duration: Duration(seconds: 3),
          ));
        }
      } else {
        _endTimeController.text = endTime;
      }
    }
  }

  // ADD or UPDATE Task
  void _addTask(BuildContext context) {
    if (_taskNameController.text.isNotEmpty &&
        _selectedCategory.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _startTimeController.text.isNotEmpty &&
        _endTimeController.text.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final Task newTask = Task(
        id: TaskIdManager.getNextId(),
        name: _taskNameController.text,
        category: _selectedCategory,
        date: _dateController.text,
        desc: _descController.text,
        isCompleted: false,
        endTime: _endTimeController.text,
        startTime: _startTimeController.text,
        alarmMode: _alarmMode,
      );
      if (widget.task == null && userProvider.addTask(newTask)) {
        //set notification if alarm is ON
        if (newTask.alarmMode == 'on') {
          NotificationService().showNotification(
            id: newTask.id,
            title: 'You have a task to start ⚡',
            body: newTask.name,
            scheduledDate: DateTime(notifiDate.year, notifiDate.month,
                notifiDate.day, notifiTime.hour, notifiTime.minute, 0, 0),
          );
        }
        //show success dialog box
        showDialog(
          context: context,
          builder: (context) {
            return TaskAlert(
                newTask: newTask, title: 'Task Added Successfully');
          },
        );
      } else if (widget.task != null) {
        //don't change the id since its update
        final Task updatedTask = Task(
          id: widget.task!.id,
          name: _taskNameController.text,
          category: _selectedCategory,
          date: _dateController.text,
          desc: _descController.text,
          isCompleted: false,
          endTime: _endTimeController.text,
          startTime: _startTimeController.text,
          alarmMode: _alarmMode,
        );

        //Set or Delete notification
        if (newTask.alarmMode == 'on') {
          NotificationService().showNotification(
            id: updatedTask.id,
            title: 'You have a task to start ⚡',
            body: newTask.name,
            scheduledDate: DateTime(notifiDate.year, notifiDate.month,
                notifiDate.day, notifiTime.hour, notifiTime.minute, 0, 0),
          );
        } else {
          NotificationService().deleteNotification(updatedTask.id);
        }
        //update the task in HIVE
        userProvider.updateTask(widget.task!, updatedTask);
        //show update success dialog box
        showDialog(
          context: context,
          builder: (context) {
            return TaskAlert(newTask: updatedTask, title: 'Task Updated');
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertMessage(
              buttonText: 'Ok',
              onPressed: () => Navigator.of(context).pop(),
              message: 'Task already exist',
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the information !'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _taskNameController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //set the title of the screen
    final String title =
        widget.isCreate ? 'Create a new task' : 'Edit your task';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              //height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Task Name',
                    style: CustomTextStyles.fieldTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  AppTextfield(
                      hintText: 'Call Alex', controller: _taskNameController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Category',
                        style: CustomTextStyles.fieldTitleStyle,
                      ),
                      Text(
                        ' (default to others if none selected)',
                        style: CustomTextStyles.smallStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<ButtonStateProvider>(
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CategoryButton(
                            buttonText: 'Education',
                            onPressed: () =>
                                categoryOnTap('education', context),
                            color: buttonColor('education', context),
                            textColor: buttonTextColor('education', context),
                          ),
                          CategoryButton(
                            buttonText: 'Work',
                            onPressed: () => categoryOnTap('work', context),
                            color: buttonColor('work', context),
                            textColor: buttonTextColor('work', context),
                          ),
                          CategoryButton(
                            buttonText: 'Personal',
                            onPressed: () => categoryOnTap('personal', context),
                            color: buttonColor('personal', context),
                            textColor: buttonTextColor('personal', context),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date & Time',
                    style: CustomTextStyles.fieldTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  DateTimeTextField(
                    hintText: '22 September, Sunday',
                    icon: Symbols.calendar_add_on,
                    controller: _dateController,
                    onTap: () => _calenderOnTap(context),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Start time',
                                style: CustomTextStyles.fieldTitleStyle,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DateTimeTextField(
                              icon: Symbols.keyboard_arrow_down,
                              controller: _startTimeController,
                              onTap: () => _selectStartTime(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'End time',
                                style: CustomTextStyles.fieldTitleStyle,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DateTimeTextField(
                              icon: Symbols.keyboard_arrow_down,
                              controller: _endTimeController,
                              onTap: () => _selectEndTime(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<AlarmStateProvider>(
                    builder: (context, value, child) {
                      String state = value.selectedButton;
                      return Row(
                        spacing: 16,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => alarmOnTap('on', context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: state == 'on'
                                    ? selectedBtnColor
                                    : defaultBtnColor,
                              ),
                              child: Icon(
                                Symbols.alarm_on,
                                color:
                                    state == 'on' ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => alarmOnTap('off', context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: state == 'off'
                                    ? selectedBtnColor
                                    : defaultBtnColor,
                              ),
                              child: Icon(Symbols.alarm_off,
                                  color: state == 'off'
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: CustomTextStyles.fieldTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    minLines: 5,
                    maxLines: 5,
                    controller: _descController,
                    decoration: InputDecoration(
                      hintText: 'Remind Alex about our class re-union.',
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0XFF757575),
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                      fillColor: const Color.fromRGBO(255, 255, 255, 0.5),
                      filled: true,
                      border: AppBorders.transparentBorder,
                      enabledBorder: AppBorders.transparentBorder,
                      focusedBorder: AppBorders.transparentBorder,
                      errorBorder: AppBorders.transparentBorder,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    buttonText: widget.isCreate ? 'Create' : 'Update',
                    onPressed: () => _addTask(context),
                    color: const Color(0XFF9747FF),
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
