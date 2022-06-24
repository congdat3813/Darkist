import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';

import 'package:tsk/models/model.dart';


class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key, required this.item }) : super(key: key);

  final Tasks item;
  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

  final _db = Localstore.instance;
  final _items = <String,Tasks>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  Color pickerColor = Colors.blue ;
  Color currentColor = Colors.blue ;
  bool isChecked = false;
  double progress = 0;
  int count=0;

  final myController = TextEditingController();

  @override
  void initState() {
    // _db.collection('TaskLists').get().then((value) {
    //   setState(() {
    //       final item = Tasks.fromMap(value!);
    //       _items.putIfAbsent(item.name, () => item);
    //     if (widget.item.items.isEmpty) {
    //       count=0;
    //       progress = 0;
    //     }
    //     else {
    //       int countDone = 0;
    //       for (var ele in widget.item.items){
    //         if (ele.values.toList().first) countDone++;
    //       }
    //       count= countDone;
    //       progress = countDone / widget.item.items.length;
    //     }
    //     pickerColor= Color(widget.item.curcolor);
    //     currentColor= Color(widget.item.curcolor);
    //   });
    // });
    pickerColor= Color(widget.item.curcolor);
    currentColor= Color(widget.item.curcolor);
    _subscription = _db.collection('TaskLists').stream.listen((event) {
      setState(() {
        final item = Tasks.fromMap(event);
        _items.putIfAbsent(item.name, () => item);
        if (widget.item.items.isEmpty) {
          count=0;
          progress = 0;
        }
        else {
          int countDone = 0;
          for (var ele in widget.item.items){
            if (ele.values.toList().first) countDone++;
          }
          count= countDone;
          progress = countDone / widget.item.items.length;
        }

      });
    });

    // if (kIsWeb) _db.collection('TaskLists').stream.asBroadcastStream();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: colorButton(),
        actions: [
          cancelButton(context),          
        ],
      ),
      backgroundColor: Colors.white,
      body: bodyView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => addItem(),
        ),
        child: const Icon(Icons.add),
        backgroundColor: currentColor,
      ),
    );
  }
  
  Widget colorButton(){
    return IconButton(
          color: currentColor,
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
                    setState((){
                      currentColor = pickerColor;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ),
          icon: Icon(Icons.circle, color: currentColor, size:35)
        );
  }

  Widget cancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: IconButton(
        onPressed: () {
          setState(() {
            widget.item.updateColor(currentColor.value);
          });
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.cancel_outlined, 
          color: currentColor,
          size: 35
        )
      )
    );
  }

  Widget bodyView(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 10, 10),
        child: Column(
          children:<Widget> [
            taskName(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('$count of ${widget.item.items.length} tasks', style: const TextStyle(fontSize: 20,color: Colors.grey),)
              ]
            ),
            processBar(),
            itemList(),
          ]
        )
      ),
    );
  }

  Widget taskName(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(widget.item.name, style: const TextStyle(
          fontSize: 40,
          color: Colors.black,
          fontWeight: FontWeight.w600
        )),
        deleteButton(),
      ]
    );
  }

  Widget deleteButton(){
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Delete: ${widget.item.name}'),
          content: const Text('Are you sure want to delete this list'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              }, 
              child: const Text('No'),
              style: ElevatedButton.styleFrom(
                primary: currentColor
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var nav = Navigator.of(context);
                nav.pop();
                nav.pop(true);
              }, 
              child: const Text('Yes'),
              style: ElevatedButton.styleFrom(
                primary: currentColor
              ),
            )
          ],
        )
      ),
      icon:  Icon(
        Icons.delete,
        color: currentColor,
        size: 40,
      )
    );
  }

  Widget processBar(){
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFecf0f1),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            alignment: Alignment.topRight,
            child: Text(
              '${(progress * 100).round()} %',
              style: const TextStyle(
                fontSize: 14,
              )
            )
          ),
        )
      ]
    );
  }

  Widget itemList(){
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 200,
      alignment: Alignment.topLeft,
      child: ListView.builder(
        itemCount: widget.item.items.length,
        itemBuilder: (BuildContext context, index) {
          Color getColor(Set<MaterialState> states) {
            return currentColor;
          }
          return Dismissible(
          background: Container(
            color: Colors.red,
          ),
            key: ValueKey<dynamic>(widget.item.items[index].keys),
            onDismissed: (DismissDirection direction) {
              setState(() {
                widget.item.removeItems(index);
              });   
            },
            child: Row(
              children: <Widget> [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: widget.item.items[index].values.toList().first, 
                  onChanged: (bool? value) {
                    setState(() {
                      widget.item.updateTask(index, !widget.item.items[index].values.toList().first, currentColor.value);
                    });
                  }
                ),
                Text(
                  widget.item.items[index].keys.toList().first,
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.item.items[index].values.toList().first ? currentColor : Colors.black,
                    decoration: widget.item.items[index].values.toList().first ? TextDecoration.lineThrough: null
                  )
                ),
              ],
            ),
          );
        }, 
      ),
    );
  }

  Widget addItem(){
    return AlertDialog(
      content: TextField(
        controller: myController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Item',
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 114, 130, 131)
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.item.addTask({myController.text: false},currentColor.value);
            Navigator.pop(context, 'OK');
          }, 
          child: const Text('Add'),
          style: ElevatedButton.styleFrom(
            primary: currentColor,
          ),
        ),
      ],
    );
  }
  
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}