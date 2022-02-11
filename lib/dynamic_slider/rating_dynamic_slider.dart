library dynamic_slider;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class RatingDynamicSlider extends StatefulWidget {

  /// value change listener
  final Function(double val) onValueChanged;

  /// radius of thumb
  final double? thumbRadius;

  /// radius of overlay thumb radius
  final double? overlayThumbRadius;

  /// slider track height
  final double? trackHeight;

  /// slider thumb color
  final Color? thumbColor;

  /// active track color of slider
  final Color? activeTrackColor;

  /// active tick mark color of slider
  final Color? activeTickMarkColor;

  /// inactive tick mark color of slider
  final Color? inactiveTrackColor;

  /// color of overlay
  final Color? overlayColor;

  /// color of value indicator
  final Color? valueIndicatorColor;

  /// color of inactive tick mark color
  final Color? inactiveTickMarkColor;

  /// asset direction
  final AssetDirection? assetDirection;

  /// tick mark radius
  final double? tickMarkRadius;

  /// asset image list
  final List<String> imagesList;

  const RatingDynamicSlider({
    Key? key,
    required this.onValueChanged,
    required this.imagesList,
    this.trackHeight = 5,
    this.thumbColor = Colors.grey,
    this.activeTrackColor = Colors.blueGrey,
    this.activeTickMarkColor = Colors.green,
    this.inactiveTrackColor = Colors.black12,
    this.overlayColor = Colors.cyan,
    this.valueIndicatorColor = Colors.grey,
    this.inactiveTickMarkColor = Colors.black87,
    this.thumbRadius = 11,
    this.overlayThumbRadius = 15,
    this.assetDirection = AssetDirection.down,
    this.tickMarkRadius = 4,
  }) : super(key: key);

  @override
  _RatingDynamicSliderState createState() => _RatingDynamicSliderState();
}

class _RatingDynamicSliderState extends State<RatingDynamicSlider> {
  List<ui.Image> images = [];

  /// stream controller for slider output values
  late final StreamController<double> dataController;
  Stream<double> get onSliderChange => dataController.stream;
  void updateSliderData(double value) {
    dataController.sink.add(value);
  }

  @override
  void initState() {
    super.initState();
    dataController = StreamController<double>.broadcast();
    _load();
  }

  /// load assets
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
          overlayShape: RoundSliderThumbShape(
              enabledThumbRadius: widget.overlayThumbRadius!),
          thumbColor: widget.thumbColor,
          activeTrackColor: widget.activeTrackColor,
          inactiveTrackColor: widget.inactiveTrackColor,
          activeTickMarkColor: widget.activeTickMarkColor,
          tickMarkShape: LineSliderTickMarkShape(
              tickMarkRadius: widget.tickMarkRadius,
              labelDirection: widget.assetDirection!,
              images: images),
          inactiveTickMarkColor:
              widget.inactiveTickMarkColor,
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

enum AssetDirection { up, down }

class LineSliderTickMarkShape extends SliderTickMarkShape {
  final double? tickMarkRadius;
  final AssetDirection? labelDirection;
  final List<double> canvasIndex = [];
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

    if (canvasIndex.length != images.length) {
      canvasIndex.add(center.dx);
    }

    final double tickMarkRadius = getPreferredSize(
          isEnabled: isEnabled,
          sliderTheme: sliderTheme,
        ).width /
        3;

    if (tickMarkRadius > 0) {

      int index = 0;
      for (var element in canvasIndex) {
        if (element == center.dx) {
          break;
        }
        index++;
      }

      try{
        if(images.isNotEmpty){
          Paint paint = Paint()..color = Colors.green;
          context.canvas.save();
          context.canvas.drawImage(
              images[index],
              Offset(
                  center.dx - 18,
                  labelDirection == AssetDirection.down
                      ? center.dy + 15
                      : center.dy - 45),
              paint);
          context.canvas.restore();
        }
      }catch(execption){

      }
    }
  }
}
