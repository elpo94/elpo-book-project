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
      body: Stack(
        children: [

          /// 타이머 중앙
          Center(
            child: Text(
              "03:45:12",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// 닫기 버튼
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}