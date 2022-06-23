import 'package:flutter/material.dart';

import 'package:tsk/theme.dart';

import 'package:tsk/screens/screens.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Taskist());
}

class Taskist extends StatefulWidget {
  const Taskist({Key? key}) : super(key: key);

  @override
  State<Taskist> createState() => _TaskistState();
}

class _TaskistState extends State<Taskist> {
  ThemeData theme = TaskistTheme.light();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Darkist',
      home: const Homepage(index: 0,),
    );
  }
}