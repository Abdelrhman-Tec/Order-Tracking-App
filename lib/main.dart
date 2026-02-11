import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_tracking_app/core/constants/app_strings.dart';
import 'package:order_tracking_app/firebase_options.dart';
import 'package:order_tracking_app/order_tracking_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: AppStrings.translationsPath,
      saveLocale: true,
      startLocale: const Locale('en'),
      child: OrderTrackingApp(),
    ),
  );
}
