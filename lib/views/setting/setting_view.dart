import 'package:sabujak_application/views/setting/widgets/plan_setting_card.dart';
import 'package:flutter/material.dart';

import 'widgets/data_setting_card.dart';
import 'widgets/info_setting_card.dart';
import 'widgets/notification_setting_card.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: const [
        PlanSettingCard(),
        SizedBox(height: 18),
        NotificationSettingCard(),
        SizedBox(height: 18),
        DataSettingCard(),
        SizedBox(height: 18),
        InfoSettingCard(),
        SizedBox(height: 22),
      ],
    );
  }
}
