import 'dart:developer';
import 'package:calculaor/calc_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CalcProvider>(
          create: (context) => CalcProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Caculator(),
      ),
    );
  }
}

class Caculator extends StatefulWidget {
  const Caculator({Key? key}) : super(key: key);

  @override
  State<Caculator> createState() => _CaculatorState();
}

class _CaculatorState extends State<Caculator> {
  late CalcProvider provider;
  String buttonValue = "";
  @override
  void initState() {
    provider = Provider.of<CalcProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Consumer<CalcProvider>(builder: (context, provider, snapshot) {
          return Container(
            height: _height,
            color: provider.darkMode
                ? const Color(0xFF292D32)
                : const Color(0xFFEFEEEE),
            width: _width,
            child: Column(
              children: [
                buildResult(_height, _width, provider),
                const Spacer(),
                if (!provider.history)
                  buildButtons()
                else
                  buildShowHistory(provider),
                const SizedBox(
                  height: 20,
                ),
                if (!provider.history) buildButton("="),
                const Spacer(),
                buildHistoryButton(provider),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildResult(_height, _width, CalcProvider provider) {
    return Container(
      height: _height * 0.3,
      padding: const EdgeInsets.only(right: 50, bottom: 20),
      width: _width,
      color: Colors.amber,
      // alignment: Alignment.bottomRight,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                provider.darkMode = !provider.darkMode;
                log(",.,.,${provider.resultsList}");
                log("....${provider.equationsList}");
              },
              icon:
                  Icon(provider.darkMode ? Icons.dark_mode : Icons.light_mode),
              iconSize: 30,
              enableFeedback: true,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              provider.equation,
              style: TextStyle(
                fontSize: provider.equationFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              provider.result,
              style: TextStyle(
                fontSize: provider.resultFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHistoryButton(CalcProvider provider) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.pinkAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 15.0,
        ),
        onPressed: () {
          log("message");

          // log("...${provider.historyValue}");
          provider.showHistory();
        },
        child: Text(!provider.history ? "History" : "Calclator"));
  }

  Widget buildShowHistory(CalcProvider provider) {
    return Container(
      // color: !provider.darkMode
      //     ? const Color(0xFF292D32)
      //     : const Color(0xFFEFEEEE),
      height: 500,
      width: 500,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          ...historyValues(provider),
          provider.resultsList.isNotEmpty
              ? clearHistory(provider)
              : const Text(
                  "\n\n\n\n Nothing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }

  Widget clearHistory(CalcProvider provider) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.pinkAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 15.0,
        ),
        onPressed: () {
          provider.clearHistory();
        },
        child: const Text("Clear-History"));
  }

  List<Widget> historyValues(CalcProvider provider) {
    return List.generate(
      provider.equationsList.length,
      (index) {
        log("...${provider.equationsList.length}");

        return ListTile(
          // tileColor: Colors.amber,
          title: Text(
            provider.equationsList[index],
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.amber.shade300,
            ),
          ),
          subtitle: Text(provider.resultsList[index],
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
                color: provider.darkMode
                    ? Colors.white
                    : Colors.black.withOpacity(0.8),
              )),
        );
      },
    );
  }

  Widget buildButtons() {
    return Table(
      
      children: [
        TableRow(
            children: [buildButton("C"), buildButton("⌫"), buildButton("÷")]),
        TableRow(
            children: [buildButton("7"), buildButton("8"), buildButton("9")]),
        TableRow(
            children: [buildButton("4"), buildButton("5"), buildButton("6")]),
        TableRow(
            children: [buildButton("1"), buildButton("2"), buildButton("3")]),
        TableRow(
            children: [buildButton("."), buildButton("0"), buildButton("00")]),
        TableRow(
            children: [buildButton("×"), buildButton("-"), buildButton("+")]),
      ],
    );
  }

  Widget buildButton(String value) {
    return Selector<CalcProvider, bool>(
        selector: (p0, p1) => p1.darkMode,
        builder: (context, dark, snapshot) {
          return InkWell(
            onTap: () {
              provider.buttonPressed(value);
            },
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(6.0, 6.0),
                    blurRadius: 16.0,
                  ),
                  BoxShadow(
                    color: provider.darkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.5),
                    offset: Offset(-6.0, -6.0),
                    blurRadius: 16.0,
                  ),
                ],
                color: dark ? const Color(0xFF292D32) : Color(0xFFE3E2E2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        });
  }
}
