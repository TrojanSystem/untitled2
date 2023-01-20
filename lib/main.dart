import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled2/task_model.dart';

void main() async {
  await Hive.initFlutter('Hive Boxes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _width, _height;
  String newTask = '';
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _width * 0.25,
        backgroundColor: Colors.red,
        title: const Text('Taskly'),
      ),
      body: FutureBuilder(
        future: Hive.openBox('tasks'),
        builder: (BuildContext context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            _box = snap.data;
            List data = _box!.values.toList();

            return ListView.builder(
              itemBuilder: (context, index) {
                return _taskList(data, index);
              },
              itemCount: data.length,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add task',
        child: const Icon(
          Icons.add,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _taskList(List<dynamic> data, int index) {
    return ListTile(
      title: Text(
        data[index]['content'],
        style: TextStyle(
          decoration: data[index]['done']
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        data[index]['timeStamp'].toString(),
      ),
      trailing: IconButton(
        onPressed: () {
          setState(() {
            data[index]['done'] = !data[index]['done'];
            _box!.putAt(index, data[index]);
          });
          print('index: $index');
        },
        icon: Icon(
          data[index]['done'] ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.red,
        ),
      ),
      onLongPress: () {
        setState(() {
          _box!.deleteAt(index);
        });
      },
    );
  }

  _addTask() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add New Task'),
            content: TextField(
              onSubmitted: (_) {
                TaskModel model = TaskModel(
                    content: newTask, done: false, timeStamp: DateTime.now());
                _box!.add(model.toMap());
                Navigator.of(context).pop();
              },
              onChanged: (task) {
                setState(() {
                  newTask = task;
                });
              },
            ),
          );
        });
  }
}
