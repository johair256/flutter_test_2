import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Simple Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final input1Control = TextEditingController();
  final input2Control = TextEditingController();

  @override
  void dispose() {
    input1Control.dispose();
    input2Control.dispose();
    super.dispose();
  }

  String dropdownValue = 'Add';
  int sumOfValues = 0;

  void adder() {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      switch(dropdownValue) {
        case 'Add':
          sumOfValues = int.parse(input1Control.text) + int.parse(input2Control.text);
          break;
        case 'Subtract':
          sumOfValues = int.parse(input1Control.text) - int.parse(input2Control.text);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(

        child: Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.numpadEnter): NextFocusIntent(),
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Input values to add together:',
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(75, 50)),
              child: TextField(
                controller: input1Control,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(75, 50)),
              child: TextField(
                controller: input2Control,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                items: <String>['Add', 'Subtract']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                    );
                }).toList(),
                onChanged: (String? position) {
                  setState(() {
                    dropdownValue = position!;
                  });
                }),
            Text(
              '$sumOfValues',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: adder,
        tooltip: 'Enter',
        child: const Icon(Icons.check_rounded),
      ),
    );
  }
}