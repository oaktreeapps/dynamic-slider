import 'dart:async';

import 'package:flutter/material.dart';

class RangeCustomThumbDynamicSlider extends StatefulWidget {

  /// Value change listener
  final Function(RangeValues val) onValueChanged;

  /// Number of divisions
  final int? numberOfDivisions;

  /// Min value
  final double min;

  /// Max Value
  final double max;

  /// Radius for thumb
  final double? thumbRadius;

  /// Color for thumb
  final Color? thumbCircleColor;

  /// Radius for thumb overlay
  final double? overlayThumbRadius;

  /// Slider track height
  final double? trackHeight;

  /// Slider thumb color
  final Color? thumbColor;

  /// Active track color of slider
  final Color? activeTrackColor;

  /// Active tick mark color of slider
  final Color? activeTickMarkColor;

  /// Inactive tick mark color of slider
  final Color? inactiveTrackColor;

  /// Color for overlay
  final Color? overlayColor;

  /// Color of value indicator
  final Color? valueIndicatorColor;

  /// Color of inactive tick mark color
  final Color? inactiveTickMarkColor;

  /// Currency prefix for input values
  final String currencyPrefix;

  /// Tick mark radius
  final double? tickMarkRadius;

  /// Thumb label style
  final TextStyle? thumbLabelTextStyle;

  const RangeCustomThumbDynamicSlider({
    Key? key,
    required this.onValueChanged,
    required this.min,
    required this.max,
    this.numberOfDivisions,
    this.trackHeight = 3,
    this.thumbColor = Colors.grey,
    this.activeTrackColor = Colors.blueGrey,
    this.activeTickMarkColor = Colors.green,
    this.inactiveTrackColor = Colors.black12,
    this.overlayColor = Colors.cyan,
    this.valueIndicatorColor = Colors.grey,
    this.inactiveTickMarkColor = Colors.black87,
    this.thumbRadius = 20,
    this.thumbCircleColor = Colors.blue,
    this.overlayThumbRadius = 15,
    this.currencyPrefix = "\$",
    this.tickMarkRadius = 3,
    this.thumbLabelTextStyle = const TextStyle(
        color: Colors.white, fontSize: 14.0, fontFamily: 'Roboto'),
  }) : super(key: key);

  @override
  _RangeCustomThumbDynamicSliderState createState() =>
      _RangeCustomThumbDynamicSliderState();
}

class _RangeCustomThumbDynamicSliderState extends State<RangeCustomThumbDynamicSlider> {

  /// Stream controller for slider output values
  late final StreamController<RangeValues> dataController =
  StreamController<RangeValues>.broadcast();
  Stream<RangeValues> get onSliderChange => dataController.stream;
  void updateSliderData(RangeValues value) {
    dataController.sink.add(value);
  }

  @override
  void dispose() {
    super.dispose();
    dataController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RangeValues>(
        initialData: RangeValues(widget.min, widget.max),
        stream: onSliderChange,
        builder: (context, snapshot) {
          RangeValues value = snapshot.data!;

          return SliderTheme(
            data: SliderThemeData(
              overlayShape: RoundSliderThumbShape(
                  enabledThumbRadius: widget.overlayThumbRadius!),
              thumbColor: widget.thumbColor,
              activeTrackColor: widget.activeTrackColor,
              inactiveTrackColor: widget.inactiveTrackColor,
              activeTickMarkColor: widget.activeTickMarkColor,
              tickMarkShape: RoundSliderTickMarkShape(
                  tickMarkRadius: widget.tickMarkRadius!),
              inactiveTickMarkColor: widget.inactiveTickMarkColor,
              overlayColor: widget.overlayColor,
              trackHeight: widget.trackHeight,
              showValueIndicator: ShowValueIndicator.always,
              rangeValueIndicatorShape: SliderThumbImage(
                  sliderValue: value,
                  thumbCircleColor: widget.thumbCircleColor,
                  thumbRadius: widget.thumbRadius,
                  thumbLabelTextStyle: widget.thumbLabelTextStyle,
                  currencyPrefix: widget.currencyPrefix),
              valueIndicatorColor: Colors.transparent,
              valueIndicatorTextStyle:
                  const TextStyle(color: Colors.transparent),
            ),
            child: StreamBuilder<RangeValues>(
                initialData: RangeValues(widget.min, widget.max),
                stream: onSliderChange,
                builder: (context, snapshot) {
                  return RangeSlider(
                    min: widget.min,
                    max: widget.max,
                    values: snapshot.data!,
                    divisions: widget.numberOfDivisions,
                    labels: RangeLabels(
                      widget.currencyPrefix + snapshot.data!.start.round().toString(),
                      widget.currencyPrefix + snapshot.data!.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      updateSliderData(values);
                      RangeValues rangeValues = RangeValues(
                          double.parse(values.start.toStringAsFixed(0).toString()),
                          double.parse(values.end.toStringAsFixed(0).toString())
                      );
                      widget.onValueChanged(rangeValues);
                    },
                  );
                }),
          );
        });
  }
}

class SliderThumbImage extends RangeSliderValueIndicatorShape {

  /// Thumb label style
  final TextStyle? thumbLabelTextStyle;
  final String? currencyPrefix;
  final RangeValues? sliderValue;
  final Color? thumbCircleColor;
  final double? thumbRadius;

  SliderThumbImage({
    this.thumbRadius,
    this.thumbCircleColor,
    this.thumbLabelTextStyle,
    this.currencyPrefix,
    this.sliderValue,
  });

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      bool? isDiscrete,
      bool? isOnTop,
      required TextPainter labelPainter,
      double? textScaleFactor,
      Size? sizeWithOverflow,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      TextDirection? textDirection,
      double? value,
      Thumb? thumb}) {

    final Paint labelCirclePaint = Paint();
    labelCirclePaint.color = thumbCircleColor!;
    context.canvas.drawCircle(
        Offset(
          center.dx,
          center.dy,
        ),
        thumbRadius!,
        labelCirclePaint);

    TextSpan span = TextSpan(
        style: thumbLabelTextStyle,
        text: currencyPrefix.toString() +
            (value! * 100).toStringAsFixed(0).toString());
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);

    tp.layout();
    tp.paint(context.canvas, Offset(center.dx - 10, center.dy - 9));
  }

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete,
      {required TextPainter labelPainter, required double textScaleFactor}) {
    return const Size(0, 0);
  }
}

