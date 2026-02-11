import 'package:firebase_core/firebase_core.dart';
import 'package:order_tracking_app/firebase_options.dart';

Future<FirebaseApp> initializeFirebase() async {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
