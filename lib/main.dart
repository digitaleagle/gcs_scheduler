import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gcs_scheduler/data_display.dart';
import 'package:gcs_scheduler/engine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Generator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Class Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Engine engine;
  Timer? _timer;

  void _incrementCounter() {
    if (engine.running) {
      engine.running = false;
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          print("Refresh");
        });
      });
      engine.run().then((dataSet) {
        return null;
      });
    }
  }

  @override
  void initState() {
    engine = SequentialEngine();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                  child: ClassesTable(dataSet: engine.completeDataSets[0])),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Running: ${engine.running}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Pending: ${engine.pendingDataSets.length}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Complete: ${engine.completeDataSets.length}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
