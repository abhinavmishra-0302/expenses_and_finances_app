import 'package:flutter/material.dart';

class MakePlanPage extends StatelessWidget {
  const MakePlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make a plan"),
      ),
      body: Center(child: Text("Make a plan")),
    );
  }
}
