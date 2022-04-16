import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'package:intl/intl.dart';

// TODO: Resume at https://www.youtube.com/watch?v=ErP_xomHKTw&list=WL&index=3&t=172s

Future<void> main() async {
  // TODO: resume tutorial https://www.youtube.com/watch?v=ErP_xomHKTw&list=WL&index=2&t=172s
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
        ),
        actions: [
          IconButton(
            onPressed: () {
              final name = controller.text;
              createUser(name: name);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserPage()));
          },
          child: const Text('User Page'),
        ),
      ),
    );
  }

  Future createUser({required String name}) async {
    // Reference to document
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    // final json = {
    //   'name': name,
    //   'age': 21,
    //   'birthday': DateTime(2001, 7, 28),
    // };
    final user = User(
      id: docUser.id,
      name: 'David',
      age: 21,
      birthday: DateTime(1969, 12, 17),
    );
    final json = user.toJson();
    // Create document and write data to Firebase
    await docUser.set(json);
  }
}

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerAge,
            decoration: const InputDecoration(hintText: 'Age'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          DateTimeField(
            controller: controllerDate,
            decoration: const InputDecoration(hintText: 'Birthdate'),
            format: DateFormat('yyyy-MM-dd'),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                initialDate: currentValue ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final user = User(
                name: controllerName.text,
                age: int.parse(controllerAge.text),
                birthday: DateTime.parse(controllerDate.text),
              );
              createUser(user);
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future createUser(User user) async {
    // Reference to document
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    final json = user.toJson();
    // Create document and write data to Firebase
    await docUser.set(json);
  }
}

class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthday': birthday,
      };
}
