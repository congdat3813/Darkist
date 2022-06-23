import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskSetting extends StatelessWidget {
  const TaskSetting({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            buildVerticalLine(),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 240,
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0.0,0.05),
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Row(
                    children: <Widget>[
                      const Expanded(flex: 1,child: FaIcon(FontAwesomeIcons.gears)),
                      const Expanded(flex: 7,child: Text('Version', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal))),
                      Expanded(flex: 1,child: IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.angleRight, size: 14))),
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(flex: 1,child: FaIcon(FontAwesomeIcons.twitter, color: Color(0xFF74b9ff))),
                      const Expanded(flex: 7,child: Text('Twitter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal))),
                      Expanded(flex: 1,child: IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.angleRight, size: 14))),
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(flex: 1,child: FaIcon(FontAwesomeIcons.star, color: Color(0xFF74b9ff))),
                      const Expanded(flex: 7,child: Text('Rate Taskist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal))),
                      Expanded(flex: 1,child: IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.angleRight, size: 14))),
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(flex: 1,child: FaIcon(FontAwesomeIcons.share, color: Color(0xFF74b9ff))),
                      const Expanded(flex: 7,child: Text('Share Taskist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal))),
                      Expanded(flex: 1,child: IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.angleRight, size: 14))),
                    ]
                  ),
                ],
              )
            ),
          ],
        )
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
}