import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/constants/style/app_text_style.dart';
import 'package:order_tracking_app/core/utils/app_validator.dart';
import 'package:order_tracking_app/core/widgets/custom_text_field.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/login/login_cubit.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const LoginForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Email
          CustomTextFormField(
            controller: cubit.emailController,
            label: tr('email'),
            hint: tr('enter_email'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Icons.email_outlined,
            style: AppTextStyle.font15w400.copyWith(
              color: AppColors.primaryBlue,
            ),
            hintStyle: AppTextStyle.font15w400.copyWith(
              color: AppColors.primaryBlue,
            ),
            filled: true,
            fillColor: AppColors.white,
            validator: AppValidators.email,
          ),
          SizedBox(height: 20.h),

          // Password
          CustomTextFormField(
            controller: cubit.passwordController,
            label: tr('password'),
            hint: tr('enter_password'),
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            style: AppTextStyle.font15w400.copyWith(
              color: AppColors.primaryBlue,
            ),
            hintStyle: AppTextStyle.font15w400.copyWith(
              color: AppColors.primaryBlue,
            ),
            filled: true,
            fillColor: AppColors.white,
            validator: AppValidators.password,
          ),
        ],
      ),
    );
  }
}
