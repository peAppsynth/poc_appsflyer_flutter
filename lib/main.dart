import 'package:flutter/material.dart';
import 'package:poc_appsflyer_flutter/second_page.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'dart:convert';

// เพิ่มค่าคงที่สำหรับ AppsFlyer configuration
const String afDevKey = "YdMKUxiBcBt5Jr2xXCxwEj";
const String appId = "6739964214"; // iOS only
const String oneLinkID = "gQ1s";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      registerOnDeepLinkingCallback: false);

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

  // Deferred Deep Linking (Get Conversion Data)
  appsflyerSdk.onInstallConversionData((res) {
    print("POC ConversionData Res: $res");
  });

  // Direct Deeplinking
  appsflyerSdk.onAppOpenAttribution((res) {
    print("POC OpenAttribution Res: $res");
  });

  // Unified deep linking
  appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
    switch (dp.status) {
      case Status.FOUND:
        print(dp.deepLink?.toString());
        print("deep link value: ${dp.deepLink?.deepLinkValue}");
        break;
      case Status.NOT_FOUND:
        print("deep link not found");
        break;
      case Status.ERROR:
        print("deep link error: ${dp.error}");
        break;
      case Status.PARSE_ERROR:
        print("deep link status parsing error");
        break;
    }
  });

  runApp(MyApp(appsflyerSdk: appsflyerSdk));
}

class MyApp extends StatelessWidget {
  final AppsflyerSdk appsflyerSdk;
  const MyApp({super.key, required this.appsflyerSdk});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(appsflyerSdk: appsflyerSdk),
    );
  }
}

class FirstPage extends StatelessWidget {
  final AppsflyerSdk appsflyerSdk;
  const FirstPage({super.key, required this.appsflyerSdk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าแรก'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            logEvent("event_page_two", null);

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

  Future<bool?> logEvent(String eventName, Map? eventValues) async {
    bool? result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (_) {}
    print("Result logEvent: $result");
    return result;
  }
}

class DeepLink {
  DeepLink(this._clickEvent);
  final Map<String, dynamic> _clickEvent;
  Map<String, dynamic> get clickEvent => _clickEvent;
  String? get deepLinkValue => _clickEvent["deep_link_value"] as String;
  String? get matchType => _clickEvent["match_type"] as String;
  String? get clickHttpReferrer => _clickEvent["click_http_referrer"] as String;
  String? get mediaSource => _clickEvent["media_source"] as String;
  String? get campaign => _clickEvent["campaign"] as String;
  String? get campaignId => _clickEvent["campaign_id"] as String;
  String? get afSub1 => _clickEvent["af_sub1"] as String;
  String? get afSub2 => _clickEvent["af_sub2"] as String;
  String? get afSub3 => _clickEvent["af_sub3"] as String;
  String? get afSub4 => _clickEvent["af_sub4"] as String;
  String? get afSub5 => _clickEvent["af_sub5"] as String;
  bool get isDeferred => _clickEvent["is_deferred"] as bool;

  @override
  String toString() {
    return 'DeepLink: ${jsonEncode(_clickEvent)}';
  }

  String? getStringValue(String key) {
    return _clickEvent[key] as String;
  }
}
