import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/constants/style/app_text_style.dart';
import 'package:order_tracking_app/core/routes/routes.dart';
import 'package:order_tracking_app/core/utils/extension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Home',
          style: AppTextStyle.font20Bold.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Row(
            children: [
              HomeActionCard(
                title: 'Orders',
                onTap: () {
                  context.pushNamed(Routes.ordersScreen);
                },
              ),
              const SizedBox(width: 20),
              HomeActionCard(
                title: 'Add Order',
                onTap: () {
                  context.pushNamed(Routes.addOrderScreen);
                },
              ),
            ],
          ).paddingSymmetric(h: 20.w, v: 20.h),
        ),
      ),
    );
  }
}

class HomeActionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const HomeActionCard({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 200.w,
          height: 200.h,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.font20Bold.copyWith(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
