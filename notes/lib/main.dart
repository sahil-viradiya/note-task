import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/module/Auth/presentation/pages/login_screen.dart';
import 'package:notes/routes/routes.dart';
import 'package:notes/utils/navigator_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorService.navigatorKey,
      getPages: AppRoutes.routes, // Use getPages instead of routes
      home: const LoginScreen(),
    );
  }
}
