import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

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
      body: const Center(child: Text('')),
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

class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    required this.id,
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
