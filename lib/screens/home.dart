import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/text_styles.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/widgets/app_button.dart';
import 'package:todoapp/widgets/category_card.dart';

import '../providers/current_user_provider.dart';
import '../widgets/task_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //enable animation for selected category
  String selectedCategory = '';

  //category on tap function
  void _categoryOnTap(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? '' : category;
    });
  }

  //List of task to display depending on stateDate
  late List<Task> tasks;

  //Today Date
  String todayDate = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());

  // Can be any date that user selects
  DateTime stateDate = DateTime.now();
  String stateDateStr = DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());

  // Calendar icon onTap - change the date
  void _calenderOnTap(dynamic user, BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      //initialDate: stateDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      selectableDayPredicate: (day) {
        String date = DateFormat('dd MMMM yyyy, EEEE').format(day);
        List<String> dates = user.getDatesWithTask();
        if (dates.isEmpty) {
          dates.add(todayDate);
        } else if (!dates.contains(todayDate)) {
          dates.add(todayDate);
        }
        return dates.contains(date);
      },
    );

    if (selectedDate != null) {
      String fullDate = DateFormat('dd MMMM yyyy, EEEE').format(selectedDate);
      stateDate = selectedDate;
      stateDateStr = fullDate;

      tasks = user.getTaskList(fullDate);
      user.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic currentUser = Provider.of<UserProvider>(context);
    tasks = currentUser.getTaskList(stateDateStr);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${currentUser.getCurrentUser().userName}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentUser.hasTask(stateDateStr)
                              ? 'You\'ve task to do'
                              : 'No task left to do',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          'profile',
                          arguments: currentUser.getCurrentUser(),
                        );
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CategoryCard(
                      categoryName: 'Education',
                      taskNumber:
                          currentUser.taskCount('education', stateDateStr),
                      icon: Symbols.school,
                      color: const Color(0XFFB4C4FF),
                      onTap: () => _categoryOnTap('education'),
                      animate: selectedCategory == 'education',
                    ),
                    const SizedBox(width: 25),
                    CategoryCard(
                      categoryName: 'Work',
                      taskNumber: currentUser.taskCount('work', stateDateStr),
                      icon: Symbols.work,
                      color: const Color(0XFFCFF3E9),
                      onTap: () => _categoryOnTap('work'),
                      animate: selectedCategory == 'work',
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    CategoryCard(
                      categoryName: 'Personal',
                      taskNumber:
                          currentUser.taskCount('personal', stateDateStr),
                      icon: Symbols.sentiment_calm,
                      color: const Color(0X999747FF),
                      onTap: () => _categoryOnTap('personal'),
                      animate: selectedCategory == 'personal',
                    ),
                    const SizedBox(width: 25),
                    CategoryCard(
                      categoryName: 'Others',
                      taskNumber: currentUser.taskCount('others', stateDateStr),
                      icon: Symbols.stacks,
                      color: const Color(0X99EDBE7D),
                      onTap: () => _categoryOnTap('others'),
                      animate: selectedCategory == 'others',
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _calenderOnTap(currentUser, context),
                      child: const Icon(
                        Symbols.edit_calendar,
                        color: Color(0XFF9747FF),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      todayDate == stateDateStr
                          ? 'Today\'s Tasks'
                          : stateDateStr,
                      style: CustomTextStyles.smallStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, i) {
                            return TaskCard(
                              taskName: tasks[i].name,
                              isChecked: tasks[i].isCompleted,
                              isCompleted: (value) =>
                                  currentUser.toggle(tasks[i]),
                              startEndTime:
                                  '${tasks[i].startTime} - ${tasks[i].endTime}',
                              editOnTap: () {
                                Navigator.pushNamed(context, 'editTask',
                                    arguments: tasks[i]);
                              },
                              deleteOnTap: () =>
                                  currentUser.deleteTask(tasks[i]),
                              animate: selectedCategory == tasks[i].category
                                  ? true
                                  : false,
                              alarmMode: tasks[i].alarmMode,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      AppButton(
                        buttonText: 'Create new task',
                        color: const Color(0XFF9747FF),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            'createTask',
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
