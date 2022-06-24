import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import 'package:tsk/models/model.dart';

import 'package:tsk/screens/screens.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _db = Localstore.instance;
  final _items = <String, Tasks>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  late DateTime time;
  @override
  void initState() {
    // _db.collection('TaskLists').get().then((value) {
    //   setState(() {
    //       final item = Tasks.fromMap(value!);
    //       _items.putIfAbsent(item.name, () => item);
    //   });
    // });
    _subscription = _db.collection('TaskLists').stream.listen((event) {
      setState(() {
        final item = Tasks.fromMap(event);
        _items.putIfAbsent(item.name, () => item);
      });
    });
    // if (kIsWeb) _db.collection('TaskLists').stream.asBroadcastStream();

    super.initState();
    time = DateTime.now();
  }

  FutureOr onGoBack(Tasks item) {
    // if(value) {
    //   print('value');
    //   setState(() {
        
    //     item.delete();
    //     _items.remove(item.name);
    //   });
    // }
    // else {
      print('value 1');
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return const Homepage(index: 0);
        })
      );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            buildDatetime(),
            const SizedBox(height: 20),
            buildVerticalLine(),
            const SizedBox(height: 20),
            buildAddButton(),
            const SizedBox(height: 20),
            buildListView(context),
          ],
        ),
      ),
    ));
  }

  Widget buildDatetime() {
    String dateInWeek = DateFormat('EEEEEE').format(time);
    String date = DateFormat('d MMM').format(time);
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          Text(
            dateInWeek,
          ),
          Text(date)
        ],
      ),
    );
  }

  Widget buildVerticalLine() {
    return Row(
      children: const <Widget>[
        Flexible(
            child: Divider(
          color: Colors.black45,
        )),
        SizedBox(width: 30),
        Text(
          'Task',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text(
          'List',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
        ),
        SizedBox(width: 30),
        Flexible(
            child: Divider(
          color: Colors.black45,
        ))
      ],
    );
  }

  Widget buildAddButton() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddList()),
                    );
                  },
                  icon: const Icon(Icons.add))),
          const SizedBox(height: 10),
          const Text('Add List')
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    return Expanded(
      child: Container(
        height: 200,
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemCount: _items.keys.length,
          itemBuilder: (BuildContext context, index) {
            final key = _items.keys.elementAt(index);
            final item = _items[key]!;
            if (item.status == true) {
              return const SizedBox.shrink();
            }
            return InkWell(
              onTap: () {
                Route route = MaterialPageRoute(builder: (context) => ItemDetail(item: item));
                Navigator.push(context, route).then((_){
                  onGoBack(item);
                });
              },
              child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(item.curcolor),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 0),
                          child: Text(item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            )
                          )
                        ),
                        const Divider(
                          indent: 50,
                          thickness: 3,
                          color: Colors.white,
                        ),
                        SizedBox(
                          // width: 180,
                          // height: 150,
                          child: Column(
                            children: item.items.map((tsk) {
                              return Row(
                                children: <Widget>[
                                  Checkbox(
                                      checkColor: Colors.white,
                                      shape: const CircleBorder(),
                                      activeColor: Color(item.curcolor),
                                      value: tsk.values.toList().first,
                                      onChanged: (bool? value) {}),
                                  Text(tsk.keys.toList().first,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: tsk.values.toList().first
                                              ? const Color(0xFFf7f1e3)
                                              : Colors.white,
                                          decoration: tsk.values.toList().first
                                              ? TextDecoration.lineThrough
                                              : null)),
                                ],
                              );
                            }).toList(),
                          )
                        )
                      ],
                    ),
                  )
                )
            );
          },
          
        ),
      ),
    );
  }
    
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
