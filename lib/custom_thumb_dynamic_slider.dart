import 'dart:async';
import 'package:flutter/material.dart';

class CustomThumbDynamicSlider extends StatefulWidget {

  /// value change listener
  final Function(int val) onValueChanged;

  /// division numbers
  final int minValue;

  /// division numbers
  final int maxValue;

  /// radius of thumb
  final double? thumbRadius;

  /// color of thumb
  final Color? thumbCircleColor;

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

  /// currency prefix of value
  final String currencyPrefix;

  /// tick mark radius
  final double? tickMarkRadius;

  /// thumb label style
  final TextStyle? thumbLabelTextStyle;

  const CustomThumbDynamicSlider({
    Key? key,
    required this.onValueChanged,
    required this.minValue,
    required this.maxValue,
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
  _CustomThumbDynamicSliderState createState() =>
      _CustomThumbDynamicSliderState();
}

class _CustomThumbDynamicSliderState extends State<CustomThumbDynamicSlider> {

  /// stream controller for slider output values
  late final StreamController<double> dataController = StreamController<double>.broadcast();
  Stream<double> get onSliderChange => dataController.stream;
  void updateSliderData(double value) {
    dataController.sink.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        initialData: widget.minValue.toDouble(),
        stream: onSliderChange,
      builder: (context, snapshot) {

        double value = snapshot.data!.toDouble();

        return SliderTheme(
          data: SliderThemeData(
            overlayShape: RoundSliderThumbShape(
                enabledThumbRadius: widget.overlayThumbRadius!),
            thumbColor: widget.thumbColor,
            activeTrackColor: widget.activeTrackColor,
            inactiveTrackColor: widget.inactiveTrackColor,
            activeTickMarkColor: widget.activeTickMarkColor,
            tickMarkShape:
                RoundSliderTickMarkShape(tickMarkRadius: widget.tickMarkRadius!),
            inactiveTickMarkColor: widget.inactiveTickMarkColor,
            overlayColor: widget.overlayColor,
            trackHeight: widget.trackHeight,
            showValueIndicator: ShowValueIndicator.always,
            valueIndicatorShape: SliderThumbImage(
                sliderValue:value,
                thumbCircleColor: widget.thumbCircleColor,
                thumbRadius: widget.thumbRadius,
                thumbLabelTextStyle: widget.thumbLabelTextStyle,
                currencyPrefix: widget.currencyPrefix),
            valueIndicatorColor: Colors.transparent,
            valueIndicatorTextStyle: const TextStyle(color: Colors.transparent),
            thumbShape: SliderThumbImage(
                sliderValue:value,
                thumbCircleColor: widget.thumbCircleColor,
                thumbRadius: widget.thumbRadius,
                thumbLabelTextStyle: widget.thumbLabelTextStyle,
                currencyPrefix: widget.currencyPrefix),
          ),
          child: Slider(
            value: value,
            min: widget.minValue.toDouble(),
            max: widget.maxValue.toDouble(),
            onChanged: (double value) {
              widget.onValueChanged(value.toInt());
              updateSliderData(value);
            },
          ),
        );
      }
    );
  }
}

class SliderThumbImage extends SliderComponentShape {

  /// thumb label style
  final TextStyle? thumbLabelTextStyle;
  final String? currencyPrefix;
  final double? sliderValue;
  final Color? thumbCircleColor;
  final double? thumbRadius;

  SliderThumbImage({this.thumbRadius,this.thumbCircleColor,this.thumbLabelTextStyle, this.currencyPrefix,this.sliderValue});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {

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
            sliderValue!.toInt().toString());

    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);

    tp.layout();
    tp.paint(context.canvas, Offset(center.dx - 10, center.dy - 9));
  }
}
