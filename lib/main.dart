import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mytask/homepage.dart';

import 'noti_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await NotificationService().initialize();
  runApp(MytaskApp());
}

class MytaskApp extends StatelessWidget{
  const MytaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Tasks',
      home: HomePage()
    );
  }
}