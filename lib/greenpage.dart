import 'package:flutter/material.dart';

class GreenPage extends StatelessWidget {
  const GreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Text('Green Page.', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
