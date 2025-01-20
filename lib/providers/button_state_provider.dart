import 'package:flutter/widgets.dart';

class ButtonStateProvider with ChangeNotifier {
  String _selectedButton = '';

  String get selectedButton => _selectedButton;

  void selectButton(String buttonName) {
    _selectedButton = buttonName;
    notifyListeners();
  }
}
