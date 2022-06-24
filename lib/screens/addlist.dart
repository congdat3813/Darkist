import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import 'package:tsk/models/model.dart';

class AddList extends StatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final _db = Localstore.instance;
  final _items = <String, Tasks>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  final myController = TextEditingController();

  Color pickerColor = Color(0xff6633ff);
  Color currentColor = Color(0xff6633ff);

  @override
  void initState() {
    _subscription = _db.collection('TaskLists').stream.listen((event) {
      setState(() {
        final item = Tasks.fromMap(event);
        _items.putIfAbsent(item.name, () => item);
      });
    });
    if (kIsWeb) _db.collection('TaskLists').stream.asBroadcastStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: const BackButton(color: Colors.black),
          ),
          Container(
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              'New',
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'List',
                              style:
                                  TextStyle(fontSize: 28.0, color: Colors.grey),
                            )
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Add the name of your list',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    TextField(
                      controller: myController,
                      decoration: const InputDecoration(
                        hintText: 'Your List...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 35, color: Colors.grey),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Row(children: <Widget>[
                      MaterialButton(
                        color: currentColor,
                        shape: const CircleBorder(),
                        onPressed: () => showDialog(
                          context: context, 
                          builder: (BuildContext context)=> AlertDialog(
                            title: const Text('Pick a color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  setState(() => currentColor = pickerColor);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          )
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox.shrink(),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ]),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final item = Tasks(name: myController.text, items: [], status: false,curcolor: currentColor.value);
          item.save();
          _items.putIfAbsent(item.name, () => item);
          Navigator.pop(context);
        },
        label: const Text('Create Task'),
        icon: const Icon(Icons.add),
        backgroundColor: currentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    myController.dispose();
    super.dispose();
  }
}
