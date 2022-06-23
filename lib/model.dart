import 'dart:async';
import 'package:localstore/localstore.dart';



class Tasks {
  final String name;
  List<dynamic> items;
  int curcolor;
  bool status;

  Tasks(
      {
        required this.name,
        required this.items,
        required this.status,
        required this.curcolor
      });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'items': items,
      'status': status,
      'curcolor': curcolor
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
        name: map['name'],
        items: map['items'],
        status: map['status'],
        curcolor: map['curcolor']
      );
  }
}

extension ExtTasks on Tasks {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('TaskLists').doc(name).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('TaskLists').doc(name).delete();
  }

  Future addTask(Map<String, bool> task) async {
    final _db = Localstore.instance;

    items.add(task);

    final item =
        Tasks(
          name: name, 
          items: items, 
          status: status,
          curcolor: curcolor
        );
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future removeItems(int index) async{
    final _db = Localstore.instance;
    items.remove(items[index]);

    bool stt = true;
    if (items.isEmpty) {
      stt = false;
    } else     
    {  
      for (var task in items) {
        if (task.values.toList().first == false) {
          stt = false;
          break;
        }
      }
    }
    final item =
    Tasks(
      name: name, 
      items: items, 
      status: stt, 
      curcolor: curcolor
      );
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future updateTask(int index, bool status) async {
    final _db = Localstore.instance;
    
    String taskname = items[index].keys.toList().first;
    items[index][taskname] = status;

    bool stt = true;

 
    for (var task in items) {
      if (task.values.toList().first == false) {
        stt = false;
        break;
      }
    }

    final item =
        Tasks(
          name: name, 
          items: items, 
          status: stt, 
          curcolor: curcolor
          );
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future updateColor(int color) async{
    final _db= Localstore.instance;

    bool stt = true;

    if (items.isEmpty) {
      stt = false;
    } else     
    {  
      for (var task in items) {
        if (task.values.toList().first == false) {
          stt = false;
          break;
        }
      }
    }

    final item =
        Tasks(
          name: name, 
          items: items, 
          status: stt,
          curcolor: color
        );
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }
}
