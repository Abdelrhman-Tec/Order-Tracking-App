import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/constants/assets.dart';
import 'package:order_tracking_app/core/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    if (_navigated) return;
    _navigated = true;

    await Future.delayed(const Duration(milliseconds: 1500));
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      try {
        await user.reload();
        final refreshedUser = auth.currentUser;

        if (!mounted) return;

        if (refreshedUser != null) {
          context.pushReplacementNamed(Routes.homeScreen);
        } else {
          context.pushReplacementNamed(Routes.loginScreen);
        }
      } catch (e) {
        await auth.signOut();
        if (!mounted) return;
        context.pushReplacementNamed(Routes.loginScreen);
      }
    } else {
      if (!mounted) return;
      context.pushReplacementNamed(Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: (context.locale.languageCode == 'ar' ? Image.asset(Assets.arLogo, width: 250.w)  : Image.asset(Assets.enLogo, width: 250.w))
                .animate()
                .scale(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutBack,
                )
                .then(delay: 150.ms)
                .shimmer(),
      ),
    );
  }
}
