import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

import 'person.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  var box = await Hive.openBox<Person>('persons');

  var data = box.get("fawad1");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Example'),
      ),
      body: ValueListenableBuilder<Box<Person>>(
        valueListenable: Hive.box<Person>('persons').listenable(),
        builder: (context, box, _) {
          final persons = box.values.toList();
          return ListView.builder(
            itemCount: persons.length,
            itemBuilder: (context, index) {
              final person = persons[index];
              return ListTile(
                title: Text(person.name),
                subtitle: Text('Age: ${person.age}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Person'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final name = _nameController.text;
                      final age = int.tryParse(_ageController.text) ?? 0;
                      if (name.isNotEmpty && age > 0) {
                        final person = Person(name: name);
                        final box = Hive.box<Person>('persons');
                        box.add(person);
                        _nameController.clear();
                        _ageController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
