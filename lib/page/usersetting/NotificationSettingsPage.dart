import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _allowNotifications = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _checkNotificationPermission();
  }

  void _initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // 앱 아이콘을 사용
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _allowNotifications = status.isGranted || status.isLimited;
    });
  }

  void _toggleNotifications(bool value) async {
    if (value) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        setState(() {
          _allowNotifications = true;
        });
        _showSnackBar("알림 허용이 켜졌습니다.");
      } else if (status.isDenied || status.isPermanentlyDenied) {
        _showSnackBar("알림 권한이 거부되었습니다. 설정에서 권한을 변경하세요.");
        openAppSettings();
      }
    } else {
      setState(() {
        _allowNotifications = false;
      });
      _showSnackBar("알림 허용이 꺼졌습니다.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('알림창 허용'),
                  trailing: Switch(
                    value: _allowNotifications,
                    onChanged: _toggleNotifications,
                  ),
                ),
                // 추가적인 알림 설정 항목들을 추가할 수 있습니다.
              ],
            ),
          ),
        ),
      ),
    );
  }
}