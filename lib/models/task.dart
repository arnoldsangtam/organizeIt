import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String desc;

  @HiveField(2)
  String category;

  @HiveField(3)
  String date;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  String startTime;

  @HiveField(6)
  String endTime;

  @HiveField(7)
  String alarmMode;

  @HiveField(8)
  int id;

  Task({
    required this.name,
    required this.desc,
    required this.category,
    required this.date,
    required this.isCompleted,
    required this.endTime,
    required this.startTime,
    required this.alarmMode,
    required this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Reference equality
    if (other is! Task) return false; // Check type
    return other.name == name &&
        other.desc == desc &&
        other.category == category &&
        other.date == date &&
        other.isCompleted == isCompleted &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.alarmMode == alarmMode &&
        other.id == id; // Value equality
  }

  @override
  int get hashCode => Object.hash(
        name,
        desc,
        category,
        date,
        isCompleted,
        startTime,
        endTime,
        alarmMode,
        id,
      ); // Combine fields for a consistent hash code
}
