import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/constants/assets.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/constants/style/app_text_style.dart';
import 'package:order_tracking_app/core/routes/routes.dart';
import 'package:order_tracking_app/core/utils/extension.dart';
import 'package:order_tracking_app/core/widgets/custom_button.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/register/register_cubit.dart';
import 'package:order_tracking_app/feature/auth/presentation/screens/register/widgets/register_form.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = .new();
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: context.locale.languageCode == 'ar'
                  ? Image.asset(Assets.arLogo, width: 250.w, height: 250.h)
                  : Image.asset(Assets.enLogo, width: 250.w, height: 250.h),
            ),
            SizedBox(height: 10.h),
            RegisterForm(formKey: formKey),
            SizedBox(height: 30.h),
            CustomButton(
              borderRadius: 8.0,
              backgroundColor: AppColors.primaryOrange,
              text: tr('register'),
              textStyle: AppTextStyle.font18w500.copyWith(
                color: AppColors.white,
              ),
              width: double.infinity,
              onPressed: () => validateThenDoRegister(context, formKey: formKey),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () => context.pushNamed(Routes.loginScreen),
              child: Text.rich(
                TextSpan(
                  text: tr('already_have_account'),
                  style: AppTextStyle.font15w400.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                  children: [
                    TextSpan(
                      text: tr('login'),
                      style: AppTextStyle.font15Bold.copyWith(
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).paddingSymmetric(h: 20.w, v: 20.h),
    );
  }

  void validateThenDoRegister(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
  }) {
    if (formKey.currentState?.validate() ?? false) {
      context.read<RegisterCubit>().emitRegisterStates();
    }
  }
}
