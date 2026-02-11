import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracking_app/core/constants/assets.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/constants/style/app_text_style.dart';
import 'package:order_tracking_app/core/routes/routes.dart';
import 'package:order_tracking_app/core/utils/app_validator.dart';
import 'package:order_tracking_app/core/utils/extension.dart';
import 'package:order_tracking_app/core/widgets/custom_button.dart';
import 'package:order_tracking_app/core/widgets/custom_snackbar.dart';
import 'package:order_tracking_app/core/widgets/custom_text_field.dart';
import 'package:order_tracking_app/core/widgets/loading_indicator.dart';
import 'package:order_tracking_app/feature/order/data/model/order_model.dart';
import 'package:order_tracking_app/feature/order/presentation/cubit/order_cubit.dart';
import 'package:order_tracking_app/feature/order/presentation/cubit/order_state.dart';
import 'package:place_picker_google/place_picker_google.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _orderNameController = TextEditingController();
  final TextEditingController _orderArrivalDateController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LatLng? orderLocation;
  LatLng? userLocation;
  String orderLocationDeatils = '';
  void selectDateOrder(
    BuildContext context, {
    required TextEditingController controller,
  }) {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: AppColors.white,
              onSurface: AppColors.primaryBlue,
            ),
            scaffoldBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryOrange,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        String dataFormatText = DateFormat("yyyy-MM-dd").format(value);
        controller.text = dataFormatText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Icon(Icons.arrow_back_ios, color: AppColors.white),
            ),
            const Spacer(),
            Text(
              'Add Order',
              style: AppTextStyle.font18Bold.copyWith(color: AppColors.white),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const LoadingIndicator(color: AppColors.primaryOrange),
            );
          } else if (state is OrderSuccess) {
            context.pop();
            CustomSnackBar.showSuccess(
              message: 'Order created successfully',
              context: context,
            );
            _orderArrivalDateController.clear();
            _orderIdController.clear();
            _orderNameController.clear();
            orderLocation = null;
            orderLocationDeatils = '';
          } else if (state is OrderError) {
            context.pop();
            CustomSnackBar.showError(message: state.message, context: context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Center(
                      child: (context.locale.languageCode == 'ar'
                          ? Image.asset(Assets.arLogo, width: 250.w)
                          : Image.asset(Assets.enLogo, width: 250.w)),
                    ),

                    CustomTextFormField(
                      validator: (value) => AppValidators.requiredField(value),
                      controller: _orderIdController,
                      hint: 'Order Id',
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      validator: (value) => AppValidators.requiredField(value),
                      controller: _orderNameController,
                      hint: 'Order Name',
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      validator: (value) => AppValidators.requiredField(value),
                      ontap: () => selectDateOrder(
                        context,
                        controller: _orderArrivalDateController,
                      ),
                      controller: _orderArrivalDateController,
                      hint: 'Order Arrival Date',
                      readOnly: true,
                    ),

                    SizedBox(height: 40),
                    CustomButton(
                      onPressed: () async {
                        LatLng? latLng = await context.push<LatLng?>(
                          Routes.placePickerScreen,
                        );
                        if (latLng != null) {
                          orderLocation = latLng;

                          List<Placemark> placeMark =
                              await placemarkFromCoordinates(
                                orderLocation!.latitude,
                                orderLocation!.longitude,
                              );

                          setState(() {
                            orderLocationDeatils =
                                '${placeMark.first.country} - ${placeMark.first.locality} - ${placeMark.first.street}';
                          });

                          log("Selected location: $orderLocation");
                          log("Address: $orderLocationDeatils");
                        }
                      },
                      icon: Icons.map_outlined,
                      text: 'Select Order Location',
                      backgroundColor: AppColors.primaryOrange,
                      textStyle: AppTextStyle.font15Bold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    orderLocationDeatils.isNotEmpty
                        ? Text(
                            orderLocationDeatils,
                            style: AppTextStyle.font15Bold.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: 15),
                    CustomButton(
                      text: 'Create Order',
                      backgroundColor: AppColors.primaryOrange,
                      textStyle: AppTextStyle.font15Bold.copyWith(
                        color: AppColors.white,
                      ),
                      onPressed: () => validateCreateOrder(),
                    ),
                  ],
                ).paddingSymmetric(h: 20.w, v: 20.h),
              ),
            ),
          );
        },
      ),
    );
  }

  void validateCreateOrder() {
    if (_formKey.currentState!.validate()) {
      if (orderLocation == null) {
        CustomSnackBar.showWarning(
          message: 'Please select order location',
          context: context,
        );
        return;
      }
      OrderModel order = OrderModel(
        orderId: _orderIdController.text,
        orderName: _orderNameController.text,
        orderUserId: FirebaseAuth.instance.currentUser!.uid,
        orderDate: DateTime.parse(_orderArrivalDateController.text),
        orderLatitude: orderLocation!.latitude,
        orderLongitude: orderLocation!.longitude,
        userLatitude: null,
        userLongitude: null,
        status: 'not started',
      );
      context.read<OrderCubit>().createOrder(order);
    }
  }
}

class PlacePickerScreen extends StatelessWidget {
  const PlacePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? apiKey = dotenv.env['API_KEY'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Icon(Icons.arrow_back_ios, color: AppColors.white),
            ),
            const Spacer(),
            Text(
              'Place Picker',
              style: AppTextStyle.font18Bold.copyWith(color: AppColors.white),
            ),
            const Spacer(),
          ],
        ),
      ),

      body: PlacePicker(
        apiKey: apiKey!,
        onPlacePicked: (LocationResult result) {
          final selectedLatLng = result.latLng;
          if (selectedLatLng != null) {
            context.pop(selectedLatLng);
          }
        },
        initialLocation: const LatLng(29.378586, 47.990341),
        searchInputConfig: SearchInputConfig(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          autofocus: false,
          textDirection: .ltr,
        ),
        searchInputDecorationConfig: const SearchInputDecorationConfig(
          hintText: "Search for a building, street or ...",
        ),
      ),
    );
  }
}
