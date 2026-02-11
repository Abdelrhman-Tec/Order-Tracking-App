import 'dart:ui' as ui;

import 'package:flutter/services.dart';

Future<Uint8List> createCustomMarker({
  required String imagePath,
  int width = 50,
}) async {
  final ByteData data = await rootBundle.load(imagePath);
  final ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ByteData? byteData = await frameInfo.image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return byteData!.buffer.asUint8List();
}
