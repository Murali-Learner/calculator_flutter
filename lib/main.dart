import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Caculator(),
    );
  }
}

class Caculator extends StatefulWidget {
  const Caculator({Key? key}) : super(key: key);

  @override
  State<Caculator> createState() => _CaculatorState();
}

class _CaculatorState extends State<Caculator> {
  bool darkMode = false;

  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;
  String buttonValue = "";
  buttonPressed(String buttonText) {
    print(buttonText);
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          print(equation);
          print(result);
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF292D32),
      body: SafeArea(
        child: SizedBox(
          height: _height,
          width: _width,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  // height: _height * 0.2,
                  padding: EdgeInsets.only(right: 50, bottom: 20),
                  width: _width,
                  color: Colors.amber,
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              // darkMode = !darkMode;
                            });
                          },
                          icon: Icon(
                              darkMode ? Icons.dark_mode : Icons.light_mode)),
                      Text(
                        equation,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        result,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Flexible(
                flex: 3,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", Colors.redAccent),
                      buildButton("⌫", Colors.blue),
                      buildButton("÷", Colors.blue),
                    ]),
                    TableRow(children: [
                      buildButton("7", Colors.black54),
                      buildButton("8", Colors.black54),
                      buildButton("9", Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("4", Colors.black54),
                      buildButton("5", Colors.black54),
                      buildButton("6", Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("1", Colors.black54),
                      buildButton("2", Colors.black54),
                      buildButton("3", Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton(".", Colors.black54),
                      buildButton("0", Colors.black54),
                      buildButton("00", Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("×", Colors.blue),
                      buildButton("-", Colors.blue),
                      buildButton("+", Colors.blue),
                    ]),
                  ],
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.25,
              //   child:,
              // ),
              buildButton("=", Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String value, Color color) {
    return InkWell(
      onTap: () {
        buttonPressed(value);

        // print("object;");
        // // int value2 = int.parse("1");
        // setState(() {
        //   value2++;
        //   // value2 = int.parse(value);
        // });
        // print(value);
        // print(",..$value2");

        // setState(() {
        //   isClicked = !isClicked;
        // });
      },
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: darkMode ? Offset(-6.0, -6.0) : Offset(6.0, 6.0),
              blurRadius: 16.0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: darkMode ? Offset(6.0, 6.0) : Offset(-6.0, -6.0),
              blurRadius: 16.0,
            ),
          ],
          color: Color(0xFF292D32),
          borderRadius: BorderRadius.circular(12.0),
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
