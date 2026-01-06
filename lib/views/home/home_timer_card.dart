import 'package:flutter/material.dart';

class HomeTimerCard extends StatelessWidget {
  final String durationText;

  const HomeTimerCard({
    super.key,
    required this.durationText,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/timer");
      },
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              Text(
                durationText,
                style: Theme.of(context).textTheme.displaySmall,
              ),

              const SizedBox(height: 8),

              LinearProgressIndicator(
                value: 0.3,
                minHeight: 6,
                borderRadius: BorderRadius.circular(20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
