import 'package:flutter/material.dart';

import 'package:tsk/screens/screens.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  late DateTime time;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    time = DateTime.now();
  }
  
  static const List<Widget> _widgetOptions = <Widget>[
    TaskList(),
    TaskDone(),
    TaskSetting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: Colors.purple[400],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
