import 'package:sabujak_application/views/setting/widgets/plan_setting_card.dart';
import 'package:flutter/material.dart';

import 'widgets/data_setting_card.dart';
import 'widgets/info_setting_card.dart';
import 'widgets/notification_setting_card.dart';

class SettingView extends StatelessWidget {
  static const double defaultPadding = 20.0;
  static const double cardMargin = 16.0;
  static const double sectionSpacing = 18.0;

  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: cardMargin,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  PlanSettingCard(),
                  SizedBox(height: sectionSpacing),
                  NotificationSettingCard(),
                  SizedBox(height: sectionSpacing),
                  DataSettingCard(),
                  SizedBox(height: sectionSpacing),
                  InfoSettingCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
