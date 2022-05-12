import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';

class CalcProvider extends ChangeNotifier {
  bool _darkMode = false;
  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  bool _history = false;
  bool get history => _history;

  set history(bool value) {
    _history = value;
    notifyListeners();
  }

  String _equation = "0";
  String get equation => _equation;

  set equation(String value) {
    _equation = value;
    notifyListeners();
  }

  String _result = "0";
  String get result => _result;

  set result(String value) {
    _result = value;
    notifyListeners();
  }

  String _expression = "";
  String get expression => _expression;

  set expression(String value) {
    _expression = value;
    notifyListeners();
  }

  double _equationFontSize = 25.0;
  double get equationFontSize => _equationFontSize;

  set equationFontSize(double value) {
    _equationFontSize = value;
    notifyListeners();
  }

  double _resultFontSize = 30.0;
  double get resultFontSize => _resultFontSize;

  set resultFontSize(double value) {
    _resultFontSize = value;
    notifyListeners();
  }

  String _buttonValue = "";
  String get buttonValue => _buttonValue;

  set buttonValue(String value) {
    _buttonValue = value;
    notifyListeners();
  }

  List<dynamic> equationsList = [];
  List<dynamic> resultsList = [];
  // Map<String, dynamic> historyValue = {};
  // List<Map<String, dynamic>> historyValuesList = [];

  buttonPressed(String buttonText) {
    if (buttonText == "C") {
      equation = "0";
      result = "0";
      equationFontSize = 30.0;
      resultFontSize = 35.0;
    } else if (buttonText == "⌫") {
      equationFontSize = 30.0;
      resultFontSize = 35.0;
      equation = equation.substring(0, equation.length - 1);
      if (equation == "") {
        equation = "0";
      }
    } else if (buttonText == "=") {
      equationFontSize = 30.0;
      resultFontSize = 35.0;

      expression = equation;
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');

      try {
        Parser p = Parser();
        Expression exp = p.parse(expression);

        ContextModel cm = ContextModel();
        result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        if (!equationsList.contains(equation)) {
          equationsList.add(equation);
          notifyListeners();
        }

        if (!resultsList.contains(result)) {
          resultsList.add(result);
          print(resultsList);
          notifyListeners();
        }

        // historyValuesList.add(historyValue);

      } catch (e) {
        result = "Error";
      }
    } else {
      equationFontSize = 30.0;
      resultFontSize = 35.0;
      if (equation == "0") {
        equation = buttonText;
      } else {
        equation = equation + buttonText;
      }
    }
  }

  showHistory() {
    history = !history;
  }

  clearHistory() {
    resultsList.clear();
    equationsList.clear();
    // historyValuesList.clear();
    // historyValue.clear();
    notifyListeners();
  }
}
