import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShaderConverter {
  late ui.FragmentShader _shader;

  Future<void> loadShader() async {
    _shader = (await ui.FragmentProgram.fromAsset('shaders/mask.frag'))
        .fragmentShader();
  }

  Future<void> captureAndSave() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, const Rect.fromLTWH(0, 0, 256, 256));

    _shader.setFloat(0, 256);
    _shader.setFloat(1, 256);

    Paint paint = Paint()..shader = _shader;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 256, 256), paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(256, 256);

    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final directory = Directory.current.path;
    final file = File("$directory/mask.png");
    await file.writeAsBytes(buffer);
  }
}
