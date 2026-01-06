import 'package:flutter/material.dart';

class TimerDetailView extends StatelessWidget {
  const TimerDetailView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("타이머"),
      ),

      body: Center(
        child: Text(
          "03:45:12",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
