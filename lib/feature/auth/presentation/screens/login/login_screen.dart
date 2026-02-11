import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/routes/routes.dart';
import 'package:order_tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:order_tracking_app/core/widgets/loading_indicator.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/login/login_state.dart';
import 'package:order_tracking_app/feature/auth/presentation/screens/login/widgets/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            showCustomSnackbar(
              context: context,
              message: state.message,
              backgroundColor: AppColors.accentRed,
            );
          } else if (state is LoginSuccess) {
            context.pushReplacementNamed(Routes.homeScreen);
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: LoadingIndicator(color: AppColors.primaryOrange),
            );
          }
          return LoginBody();
        },
      ),
    );
  }
}
