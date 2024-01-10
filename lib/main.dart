import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/providers/club_category_provider.dart';
import 'package:tttttt/providers/club_provider.dart';
import 'package:tttttt/providers/application_provider.dart';
import 'package:tttttt/providers/comment_provider.dart';
import 'package:tttttt/providers/event_provider.dart';
import 'package:tttttt/providers/notification_provider.dart';
import 'package:tttttt/providers/user_provider.dart';

import 'firebase_options.dart';
import 'firekakao/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'e2f2095dcfe815123318c35680fa5ad7',
    javaScriptAppKey: '9ed6782d006d95bfdfb6005a1cb6ab1f',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClubProvider()),
        ChangeNotifierProvider(create: (_) => ClubCategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'pretendard'),

      debugShowCheckedModeBanner: false,
      // home: TestScreen(),
      home: const MyHomePage(
        title: 'login',
      ),
    );
  }
}
