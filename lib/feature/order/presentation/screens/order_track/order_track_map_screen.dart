// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/services/locations_services.dart';
import 'package:order_tracking_app/core/utils/marker_helper.dart';
import 'package:order_tracking_app/feature/order/data/model/order_model.dart';
import 'package:order_tracking_app/feature/order/presentation/cubit/order_cubit.dart';

class OrderTrackMapScreen extends StatefulWidget {
  final OrderModel orderModel;
  const OrderTrackMapScreen({super.key, required this.orderModel});

  @override
  State<OrderTrackMapScreen> createState() => _OrderTrackMapScreenState();
}

class _OrderTrackMapScreenState extends State<OrderTrackMapScreen> {
  final Completer<GoogleMapController> controller = .new();
  final CustomInfoWindowController _customInfoWindowController = .new();
  final Set<Marker> markers = {};
  StreamSubscription<Position>? locationSub;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  bool isLoading = false;
  String? errorMessage;

  LatLng? cureentUserLocation;

  CameraPosition get initialCameraPosition => CameraPosition(
    target: LatLng(
      widget.orderModel.orderLatitude ?? 30.0444,
      widget.orderModel.orderLongitude ?? 31.2357,
    ),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints(apiKey: dotenv.env['API_KEY']!);
    loadDriverAndOrderLocations();
    listenToUserLocation();
  }

  @override
  void dispose() {
    locationSub?.cancel();
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Future<void> loadDriverAndOrderLocations() async {
    await getCurrentLocationDriver();
    _getPolyline();
    await _loadOrderLocationMarker();
  }

  void listenToUserLocation() {
    locationSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(distanceFilter: 10),
        ).listen((position) {
          if (!mounted) return;
          cureentUserLocation = LatLng(position.latitude, position.longitude);
          updateDriverLocation(cureentUserLocation!);
          if (widget.orderModel.orderId != null) {
            context.read<OrderCubit>().updateOrder(
              orderId: widget.orderModel.orderId!,
              userLatitude: cureentUserLocation!.latitude,
              userLongitude: cureentUserLocation!.longitude,
              status: 'on the way',
            );
          }

          _getPolyline();
        });
  }

  void updateDriverLocation(LatLng newLocation) {
    setState(() {
      markers.removeWhere(
        (marker) =>
            marker.markerId.value == FirebaseAuth.instance.currentUser!.uid,
      );
      loadDriverLocationMarker(newLocation);
    });
  }

  Future<void> _loadOrderLocationMarker() async {
    final Uint8List orderMarker = await createCustomMarker(
      imagePath: 'assets/images/order.png',
      width: 60,
    );

    final LatLng orderLatLng = LatLng(
      widget.orderModel.orderLatitude!,
      widget.orderModel.orderLongitude!,
    );

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(widget.orderModel.orderId!),
          position: orderLatLng,
          icon: BitmapDescriptor.bytes(orderMarker),
          infoWindow: const InfoWindow(title: 'موقع الطلب'),
          onTap: () => OrderInfo(
            orderModel: widget.orderModel,
            controller: _customInfoWindowController,
            orderLatLng: orderLatLng,
          ).show(),
        ),
      );
    });
  }

  Future<void> loadDriverLocationMarker(LatLng driverLocation) async {
    final Uint8List driverMarker = await createCustomMarker(
      imagePath: 'assets/images/truck.png',
      width: 60,
    );

    final LatLng driverLatLng = driverLocation;

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid),
          position: driverLatLng,
          icon: BitmapDescriptor.bytes(driverMarker),
          infoWindow: const InfoWindow(title: 'موقع السائق'),
        ),
      );
    });

    _animateToPositioned(driverLatLng);
  }

  Future<void> _animateToPositioned(LatLng latLng) async {
    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)),
    );
  }

  Future<void> getCurrentLocationDriver() async {
    Position position = await LocationsServices.determinePosition();
    cureentUserLocation = LatLng(position.latitude, position.longitude);
    loadDriverLocationMarker(cureentUserLocation!);
  }

  void _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppColors.primaryOrange,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  Future<void> _getPolyline() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      polylineCoordinates.clear();
      polylines.clear();
    });

    try {
      final result = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          origin: PointLatLng(
            cureentUserLocation!.latitude,
            cureentUserLocation!.longitude,
          ),
          destination: PointLatLng(
            widget.orderModel.orderLatitude!,
            widget.orderModel.orderLongitude!,
          ),
        ),
      );

      if (result.primaryRoute?.polylinePoints case List<PointLatLng> points) {
        for (var point in points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _addPolyLine();
      } else {
        setState(() {
          errorMessage = result.errorMessage ?? 'No route found';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            onTap: (_) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (_) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController mapController) {
              controller.complete(mapController);
              _customInfoWindowController.googleMapController = mapController;
            },
            polylines: Set<Polyline>.of(polylines.values),
          ),

          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 120,
            width: 200,
            offset: 50,
          ),
        ],
      ),
    );
  }
}

class OrderInfo {
  final OrderModel orderModel;
  final CustomInfoWindowController controller;
  final LatLng orderLatLng;

  OrderInfo({
    required this.orderModel,
    required this.controller,
    required this.orderLatLng,
  });

  void show() {
    controller.addInfoWindow!(
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${orderModel.orderId ?? ''}'),
            Text('Order Name: ${orderModel.orderName ?? ''}'),
            Text('Status: ${orderModel.status ?? ''}'),
          ],
        ),
      ),
      orderLatLng,
    );
  }
}
