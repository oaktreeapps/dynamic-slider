import 'dart:async';
import 'package:flutter/material.dart';

enum NumericLabelDirection { ABOVE, BELOW }

class LabeledDynamicSlider extends StatefulWidget {
  /// Input array values
  final List<int> inputValues;

  /// Value change listener
  final Function(double val) onValueChanged;

  /// Total number of divisions
  final int? numberOfDivisions;

  /// Radius for thumb
  final double? thumbRadius;

  /// Radius for overlay thumb
  final double? overlayThumbRadius;

  /// Slider track height
  final double? trackHeight;

  /// Slider thumb color
  final Color? thumbColor;

  /// Active track color of slider
  final Color? activeTrackColor;

  /// Active tick mark color
  final Color? activeTickMarkColor;

  /// Inactive tick mark color
  final Color? inactiveTrackColor;

  /// Color of overlay
  final Color? overlayColor;

  /// Color of value indicator
  final Color? valueIndicatorColor;

  /// Color of inactive tick mark color
  final Color? inactiveTickMarkColor;

  /// Currency prefix for input values
  final String currencyPrefix;

  /// Numeric label direction
  final NumericLabelDirection? labelDirection;

  /// Tick mark radius
  final double? tickMarkRadius;

  /// Numeric label style
  final TextStyle? numericLabelTextStyle;

  LabeledDynamicSlider({
    Key? key,
    required this.inputValues,
    required this.onValueChanged,
    this.numberOfDivisions,
    this.trackHeight = 3,
    this.thumbColor = Colors.blue,
    this.activeTrackColor = Colors.blueGrey,
    this.activeTickMarkColor = Colors.blue,
    this.inactiveTrackColor = Colors.black12,
    this.overlayColor = Colors.cyan,
    this.valueIndicatorColor = Colors.grey,
    this.inactiveTickMarkColor = Colors.black87,
    this.thumbRadius = 11,
    this.overlayThumbRadius = 15,
    this.currencyPrefix = "\$",
    this.labelDirection = NumericLabelDirection.BELOW,
      this.tickMarkRadius = 3,
    this.numericLabelTextStyle = const TextStyle(
        color: Colors.black, fontSize: 14.0, fontFamily: 'Roboto'),
  }) : assert(inputValues.isNotEmpty,"Please add values"),super(key: key);

  @override
  _LabeledDynamicSliderState createState() => _LabeledDynamicSliderState();
}

class _LabeledDynamicSliderState extends State<LabeledDynamicSlider> {

  /// Stream controller for slider output values
  late final StreamController<double> dataController= StreamController<double>.broadcast();
  Stream<double> get onSliderChange => dataController.stream;
  void updateSliderData(double value) {
    dataController.sink.add(value);
  }

  @override
  void initState() {
    super.initState();
    _initInputValues();
  }

  _initInputValues() {
    if (widget.numberOfDivisions != null) {
      int lastValue = widget.inputValues.last;
      widget.inputValues.clear();
      for (int i = 1; i <= widget.numberOfDivisions!; i++) {
        int val = ((lastValue / widget.numberOfDivisions!) * i).toInt();
        widget.inputValues.add(val);
      }
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
              inputValues: widget.inputValues,
              tickMarkRadius: widget.tickMarkRadius,
              labelDirection: widget.labelDirection,
              numericLabelTextStyle: widget.numericLabelTextStyle,
              currencyPrefix: widget.currencyPrefix),
          inactiveTickMarkColor: widget.inactiveTickMarkColor,
          overlayColor: widget.overlayColor,
          trackHeight: widget.trackHeight,
          showValueIndicator: ShowValueIndicator.always,
          valueIndicatorColor: Colors.transparent,
          valueIndicatorTextStyle: const TextStyle(color: Colors.transparent),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: widget.thumbRadius!)),
      child: StreamBuilder<double>(
          initialData: 0,
          stream: onSliderChange,
          builder: (context, snapshot) {
            double value = snapshot.data!.toDouble();
            return Slider(
              value: value,
              min: 0,
              max: widget.inputValues.length - 1,
              divisions: widget.inputValues.length - 1,
              onChanged: (double value) {
                widget.onValueChanged(
                    widget.inputValues[value.toInt()].toDouble());
                updateSliderData(value);
              },
            );
          }),
    );
  }
}

class LineSliderTickMarkShape extends SliderTickMarkShape {

  final double? tickMarkRadius;
  final NumericLabelDirection? labelDirection;
  late final TextStyle? numericLabelTextStyle;
  final List<int>? inputValues;
  final List<double> canvasXIndex = [];
  final String? currencyPrefix;

  LineSliderTickMarkShape(
      {this.tickMarkRadius,
      this.labelDirection,
      this.numericLabelTextStyle,
      this.inputValues,
      this.currencyPrefix});

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

  /// Paint method
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    Color? begin;
    Color? end;
    switch (textDirection) {
      case TextDirection.ltr:
        final bool isTickMarkRightOfThumb = center.dx > thumbCenter.dx;
        begin = isTickMarkRightOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkRightOfThumb
            ? sliderTheme.inactiveTickMarkColor
            : sliderTheme.activeTickMarkColor;

        break;
      case TextDirection.rtl:
        final bool isTickMarkLeftOfThumb = center.dx < thumbCenter.dx;
        begin = isTickMarkLeftOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkLeftOfThumb
            ? sliderTheme.inactiveTickMarkColor
            : sliderTheme.activeTickMarkColor;
        break;
    }

    /// Array to store index
    if (canvasXIndex.length != inputValues!.length) {
      canvasXIndex.add(center.dx);
    }

    /// Tick mark paint
    final Paint tickMarkPaint = Paint()
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    /// Marker paint
    final Paint markerPaint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    if (tickMarkRadius! > 0) {
      context.canvas
          .drawCircle(Offset(center.dx, center.dy), tickMarkRadius!, tickMarkPaint);

      int index = 0;
      for (var element in canvasXIndex) {
        if (element == center.dx) {
          break;
        }
        index++;
      }

      context.canvas.drawLine(
          Offset(center.dx, center.dy),
          Offset(
              center.dx,
              labelDirection == NumericLabelDirection.BELOW
                  ? (center.dy + 15)
                  : (center.dy - 15)),
          markerPaint);

      TextSpan span = TextSpan(
          style: numericLabelTextStyle,
          text: currencyPrefix! + inputValues![index].toString());

      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);

      tp.layout();
      tp.paint(
          context.canvas,
          Offset(
              labelDirection == NumericLabelDirection.BELOW
                  ? (center.dx - 12)
                  : (center.dx - 10),
              labelDirection == NumericLabelDirection.BELOW
                  ? (center.dy + 20)
                  : (center.dy - 35)));
    }
  }
}
