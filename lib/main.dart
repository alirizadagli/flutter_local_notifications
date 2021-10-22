/*
- RealTime Notification:
+ AppDelegate.swift içine eklenen kod
* if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
  }

+ pubspec.yaml içine:
* flutter_local_notifications: ^9.0.0


- Delayed Notification:
+ AndroidManifest.xml içine:
* <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

* <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
    </intent-filter>
</receiver>

* <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>

********************************
* delay details: Alarm manager *
*/

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var flp = FlutterLocalNotificationsPlugin();

  Future<void> kurulum() async {
    var androidAyari = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosAyari = IOSInitializationSettings();
    var kurulumAyari =
        InitializationSettings(android: androidAyari, iOS: iosAyari);

    await flp.initialize(kurulumAyari, onSelectNotification: bildirimSecilme);
  }

  Future<void> bildirimSecilme(payload) async {
    if (payload != null) {
      print("Bildirim seçildi: $payload");
    }
  }

  Future<void> bildirimGoster() async {
    var androidBildirimDetay = AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "channelDescription",
      priority: Priority.high,
      importance: Importance.max,
    );

    var iosBildirimDetay = IOSNotificationDetails();

    var bildirimDetay = NotificationDetails(
        android: androidBildirimDetay, iOS: iosBildirimDetay);

    await flp.show(0, "Başlık", "İçerik", bildirimDetay, payload: "payload içerik");
  }

  Future<void> bildirimGecikmeliGoster() async {
    tz.initializeTimeZones();

    var androidBildirimDetay = AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "channelDescription",
      priority: Priority.high,
      importance: Importance.max,
    );

    var iosBildirimDetay = IOSNotificationDetails();

    var bildirimDetay = NotificationDetails(
        android: androidBildirimDetay, iOS: iosBildirimDetay);

    var gecikme = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    try {
      await flp.zonedSchedule(
        0,
        "Başlık Gecikme",
        "İçerik Gecikme",
        gecikme,
        bildirimDetay,
        payload: "payload içerik gecikme",
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (ex) {
      print("Hata $ex");
    }
  }

  @override
  void initState() {
    super.initState();
    kurulum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                bildirimGoster();
              },
              child: Text("Bildirim Oluştur"),
            ),
            ElevatedButton(
              onPressed: () {
                bildirimGecikmeliGoster();
              },
              child: Text("Gecikmeli Bildirim Oluştur"),
            ),
          ],
        ),
      ),
    );
  }
}
