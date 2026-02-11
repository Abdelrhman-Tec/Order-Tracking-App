import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/routes/routes.dart';
import 'package:order_tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:order_tracking_app/core/widgets/loading_indicator.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/register/register_cubit.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/register/register_state.dart';
import 'package:order_tracking_app/feature/auth/presentation/screens/register/widgets/register_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterError) {
            showCustomSnackbar(
              context: context,
              message: state.message,
              backgroundColor: AppColors.accentRed,
            );
          } else if (state is RegisterSuccess) {
            context.pushReplacementNamed(Routes.loginScreen);
          }
        },
        builder: (context, state) {
          if (state is RegisterLoading) {
            return Center(
              child: LoadingIndicator(color: AppColors.primaryOrange),
            );
          }
          return RegisterBody();
        },
      ),
    );
  }
}
