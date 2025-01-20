import 'package:hive/hive.dart';
import 'package:todoapp/models/task.dart';

part 'user.g.dart'; //Hive type adapter file

@HiveType(typeId: 0) //unique ID for this data
class User extends HiveObject {
  @HiveField(0)
  String userName;
  @HiveField(1)
  String password;
  @HiveField(2)
  bool isLogin;
  @HiveField(3)
  List<Task> taskList;

  User({
    required this.userName,
    required this.password,
    required this.isLogin,
    List<Task>? taskList, // Allow null but handle it
  }) : taskList = taskList ?? [];
}
