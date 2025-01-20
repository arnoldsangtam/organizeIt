import 'package:hive/hive.dart';

class TaskIdManager {
  static var box = Hive.box<int>('id');
  static int _currentId = box.get('lastID') as int;

  static int getNextId() {
    _currentId++;
    if (_currentId >= 2147483647) {
      _currentId = 0; // Reset if it exceeds the limit
    }
    box.put('lastID', _currentId);
    return _currentId;
  }
}
