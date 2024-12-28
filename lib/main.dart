import 'package:flutter/material.dart';
import 'package:poc_appsflyer_flutter/secondPage.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

// เพิ่มค่าคงที่สำหรับ AppsFlyer configuration
const String afDevKey = "YOUR_DEV_KEY_HERE";
const String appId = "YOUR_APP_ID_HERE"; // iOS only
const String oneLinkID = "YOUR_ONELINK_ID_HERE";

void main() {
  // สร้าง AppsFlyer configuration
  AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
    afDevKey: afDevKey,
    appId: appId,
    showDebug: true,
    timeToWaitForATTUserAuthorization: 50,
    appInviteOneLink: oneLinkID,
    disableAdvertisingIdentifier: false,
    disableCollectASA: false,
    manualStart: true,
  );

  // สร้าง AppsFlyer SDK instance
  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  // Initialization of the AppsFlyer SDK
  appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true);

  // Starting the SDK with optional success and error callbacks
  appsflyerSdk.startSDK(
    onSuccess: () {
      print("AppsFlyer SDK initialized successfully.");
    },
    onError: (int errorCode, String errorMessage) {
      print(
          "Error initializing AppsFlyer SDK: Code $errorCode - $errorMessage");
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าแรก'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          child: Text('ไปยังหน้าที่ 2'),
        ),
      ),
    );
  }
}
