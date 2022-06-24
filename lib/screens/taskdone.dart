import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';

import 'package:tsk/screens/screens.dart';

import 'package:tsk/models/model.dart';

class TaskDone extends StatefulWidget {
  const TaskDone({Key? key}) : super(key: key);

  @override
  State<TaskDone> createState() => _TaskDoneState();
}

class _TaskDoneState extends State<TaskDone> {
  final _db = Localstore.instance;
  final _items = <String, Tasks>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  late DateTime time;

  @override
  void initState() {
    // _db.collection('TaskLists').get().then((value) {
    //   setState(() {
    //     value?.entries.forEach((element) {
    //       final item = Tasks.fromMap(element.value);
    //       _items.putIfAbsent(item.name, () => item);
    //     });
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
      
    //   setState(() {
    //     item.delete();
    //     _items.remove(item.name);
    //   });
    // }
    // else {
      
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return const Homepage(index: 1);
        })
      );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          buildDatetime(),
          const SizedBox(
            height: 20,
          ),
          buildTaskDone(),
          const SizedBox(
            height: 20,
          ),
          buildListView(context),
        ],
      )),
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

  Widget buildTaskDone() {
    return Row(
      children: const <Widget>[
        Flexible(
            child: Divider(
          color: Colors.black45,
        )),
        SizedBox(
          width: 30,
        ),
        Text(
          'Task',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text('Done',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        SizedBox(
          width: 30,
        ),
        Flexible(
            child: Divider(
          color: Colors.black45,
        )),
      ],
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
          itemBuilder: (BuildContext context, index) {
            final key = _items.keys.elementAt(index);
            final item = _items[key]!;
            if (item.status == false) {
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
                      taskName(item),
                      const Divider(
                        indent: 50,
                        thickness: 3,
                        color: Colors.white,
                      ),
                      itemList(item),
                    ],
                  ),
                )
              )
            );
          },
          itemCount: _items.keys.length,
          
        ),
      ),
    );
  }

  Widget taskName(Tasks item){
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 0),
      child: Text(item.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )
        )
      );
  }

  Widget itemList(Tasks item){
    return SizedBox(
      child: Column(
        children: item.items.map((item) {
          return Row(
            children: <Widget>[
              Checkbox(
                  checkColor: Colors.white,
                  shape: const CircleBorder(),
                  activeColor: const Color(0xFF6933FF),
                  value: item.values.toList().first,
                  onChanged: (bool? value) {}),
              Text(item.keys.toList().first,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: item.values.toList().first
                        ? const Color(0xFFf7f1e3)
                        : Colors.white,
                    decoration: item.values.toList().first
                        ? TextDecoration.lineThrough
                        : null
                    )
                ),
            ],
          );
        }).toList(),
      )
    );
  }
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
