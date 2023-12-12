import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EntryRecordScreen extends StatefulWidget {
  const EntryRecordScreen({Key? key}) : super(key: key);

  @override
  State<EntryRecordScreen> createState() => _EntryRecordScreenState();
}

class _EntryRecordScreenState extends State<EntryRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Record'),
      ),
      body: Center(
          child:Text('Hello'
          )
      ),
    );
  }
}
