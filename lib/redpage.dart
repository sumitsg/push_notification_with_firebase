import 'package:flutter/material.dart';

class RedPage extends StatelessWidget {
  const RedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.redAccent,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Text('Red Page.', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
