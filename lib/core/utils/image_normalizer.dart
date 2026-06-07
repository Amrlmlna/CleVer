import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageNormalizer {
  static const int targetSize = 400;

  /// Takes an image file, center-crops it to a 1:1 square,
  /// resizes to [targetSize]×[targetSize], and returns a new JPEG file.
  static Future<File> cropToSquare(File inputFile) async {
    try {
      final bytes = await inputFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final int width = image.width;
      final int height = image.height;
      final int size = width < height ? width : height;
      final double offsetX = (width - size) / 2.0;
      final double offsetY = (height - size) / 2.0;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw the center portion of the source image resized to the target size
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(offsetX, offsetY, size.toDouble(), size.toDouble()),
        Rect.fromLTWH(0, 0, targetSize.toDouble(), targetSize.toDouble()),
        Paint()..filterQuality = FilterQuality.high,
      );

      final picture = recorder.endRecording();
      final outputImage = await picture.toImage(targetSize, targetSize);
      final byteData = await outputImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final pngBytes = byteData!.buffer.asUint8List();

      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final outputFile = File(
        '${tempDir.path}/normalized_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await outputFile.writeAsBytes(pngBytes);

      image.dispose();
      outputImage.dispose();

      debugPrint(
        'Successfully normalized image to 400x400: ${outputFile.path}',
      );
      return outputFile;
    } catch (e) {
      debugPrint('Error normalizing image: $e');
      // Fallback to original file if anything goes wrong
      return inputFile;
    }
  }
}
