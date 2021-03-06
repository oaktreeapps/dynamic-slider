import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AssetDirection {
  above,
  below,
}

class RatingDynamicSlider extends StatefulWidget {
  /// Value change listener
  final Function(double val) onValueChanged;

  /// Radius of thumb
  final double? thumbRadius;

  /// Radius of overlay thumb
  final double? overlayThumbRadius;

  /// Slider track height
  final double? trackHeight;

  /// Slider thumb color
  final Color? thumbColor;

  /// Active track color
  final Color? activeTrackColor;

  /// Active tick mark color
  final Color? activeTickMarkColor;

  /// Inactive tick mark color
  final Color? inactiveTrackColor;

  /// Color of overlay
  final Color? overlayColor;

  /// Color of value indicator
  final Color? valueIndicatorColor;

  /// Color of inactive tick mark
  final Color? inactiveTickMarkColor;

  /// Asset direction
  final AssetDirection? assetDirection;

  /// Tick mark radius
  final double? tickMarkRadius;

  /// Asset image list
  final List<String> imagesList;

  const RatingDynamicSlider({
    Key? key,
    required this.onValueChanged,
    required this.imagesList,
    this.trackHeight = 3,
    this.thumbColor = Colors.blue,
    this.activeTrackColor = Colors.blueGrey,
    this.activeTickMarkColor = Colors.green,
    this.inactiveTrackColor = Colors.black12,
    this.overlayColor = Colors.cyan,
    this.valueIndicatorColor = Colors.grey,
    this.inactiveTickMarkColor = Colors.black87,
    this.thumbRadius = 11,
    this.overlayThumbRadius = 15,
    this.assetDirection = AssetDirection.below,
    this.tickMarkRadius = 4,
  })  : assert(imagesList.length >= 2, "Please add more than 2 images to draw the slider"),
        super(key: key);

  @override
  _RatingDynamicSliderState createState() => _RatingDynamicSliderState();
}

class _RatingDynamicSliderState extends State<RatingDynamicSlider> {
  /// Array of images
  List<ui.Image> images = [];

  /// Stream controller for slider output values
  final StreamController<double> dataController = StreamController<double>.broadcast();

  Stream<double> get onSliderChange => dataController.stream;

  void updateSliderData(double value) {
    dataController.sink.add(value);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
    dataController.close();
  }

  void _load() async {
    for (var element in widget.imagesList) {
      var bytes = await rootBundle.load(element);
      var image = await decodeImageFromList(bytes.buffer.asUint8List());
      images.add(image);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
          overlayShape: RoundSliderThumbShape(enabledThumbRadius: widget.overlayThumbRadius!),
          thumbColor: widget.thumbColor,
          activeTrackColor: widget.activeTrackColor,
          inactiveTrackColor: widget.inactiveTrackColor,
          activeTickMarkColor: widget.activeTickMarkColor,
          tickMarkShape: LineSliderTickMarkShape(
              tickMarkRadius: widget.tickMarkRadius, labelDirection: widget.assetDirection!, images: images),
          inactiveTickMarkColor: widget.inactiveTickMarkColor,
          overlayColor: widget.overlayColor,
          trackHeight: widget.trackHeight,
          showValueIndicator: ShowValueIndicator.always,
          valueIndicatorColor: Colors.transparent,
          valueIndicatorTextStyle: const TextStyle(color: Colors.transparent),
          thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: widget.thumbRadius!,
          )),
      child: StreamBuilder<double>(
          initialData: 0,
          stream: onSliderChange,
          builder: (context, snapshot) {
            double value = snapshot.data!.toDouble();
            return Slider(
              value: value,
              min: 0,
              max: widget.imagesList.length - 1,
              divisions: widget.imagesList.length - 1,
              onChanged: (double value) {
                updateSliderData(value);
                widget.onValueChanged(value);
              },
            );
          }),
    );
  }
}

class LineSliderTickMarkShape extends SliderTickMarkShape {
  final double? tickMarkRadius;
  final AssetDirection? labelDirection;
  final List<double> canvasXIndex = [];
  List<ui.Image> images;

  LineSliderTickMarkShape({
    this.tickMarkRadius,
    this.labelDirection,
    required this.images,
  });

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

  /// paint method
  @override
  Future<void> paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) async {
    switch (textDirection) {
      case TextDirection.ltr:
        break;
      case TextDirection.rtl:
        break;
    }

    /// array to store index
    if (canvasXIndex.length != images.length) {
      canvasXIndex.add(center.dx);
    }

    /// tick mark radius
    final double tickMarkRadius = getPreferredSize(
          isEnabled: isEnabled,
          sliderTheme: sliderTheme,
        ).width /
        3;

    if (tickMarkRadius > 0) {
      int index = 0;
      for (var element in canvasXIndex) {
        if (element == center.dx) {
          break;
        }
        index++;
      }

      try {
        /// draw image
        if (images.isNotEmpty) {
          Paint paint = Paint()..color = Colors.green;
          context.canvas.save();
          context.canvas.drawImage(images[index],
              Offset(center.dx - 18, labelDirection == AssetDirection.below ? center.dy + 18 : center.dy - 48), paint);
          context.canvas.restore();
        }
      } catch (exception) {
        return;
      }
    }
  }
}
