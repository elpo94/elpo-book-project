import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerLandscapeView extends StatefulWidget {
  const TimerLandscapeView({super.key});

  @override
  State<TimerLandscapeView> createState() => _TimerLandscapeViewState();
}

class _TimerLandscapeViewState extends State<TimerLandscapeView> {
  @override
  void initState() {
    super.initState();

    /// 가로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {

    /// 세로로 되돌리기
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                "03:45:12",
                style: const TextStyle(
                  fontSize: 90,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}