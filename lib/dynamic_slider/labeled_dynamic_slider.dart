library dynamic_slider;
import 'dart:async';
import 'package:flutter/material.dart';

enum NumericLabelDirection { up, down }

class LabeledDynamicSlider extends StatefulWidget {
  /// input array values
  final List<int> inputValues;

  /// value change listener
  final Function(double val) onValueChanged;

  /// division numbers
  final int? numberOfDivisions;

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

  /// currency prefix of value
  final String currencyPrefix;

  /// numeric label direction
  final NumericLabelDirection? labelDirection;

  /// tick mark radius
  final double? tickMarkRadius;

  /// numeric label style
  final TextStyle? numericLabelTextStyle;

  const LabeledDynamicSlider({
    Key? key,
    required this.inputValues,
    required this.onValueChanged,
    this.numberOfDivisions,
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
    this.currencyPrefix = "\$",
    this.labelDirection = NumericLabelDirection.down,
      this.tickMarkRadius = 3,
    this.numericLabelTextStyle = const TextStyle(
        color: Colors.black, fontSize: 14.0, fontFamily: 'Roboto'),
  }) : super(key: key);

  @override
  _LabeledDynamicSliderState createState() => _LabeledDynamicSliderState();
}

class _LabeledDynamicSliderState extends State<LabeledDynamicSlider> {

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
    _initInputValues();
  }

  /// inputted array divisions
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
          thumbShape:
              RoundSliderThumbShape(enabledThumbRadius: widget.thumbRadius!)),
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
  final List<double> canvasIndex = [];
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
    assert(sliderTheme != null);
    assert(sliderTheme.trackHeight != null);
    assert(isEnabled != null);
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

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

    if (canvasIndex.length != inputValues!.length) {
      canvasIndex.add(center.dx);
    }

    final Paint paint = Paint()
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    final Paint markerPaint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    if (tickMarkRadius! > 0) {
      context.canvas
          .drawCircle(Offset(center.dx, center.dy), tickMarkRadius!, paint);

      int index = 0;
      for (var element in canvasIndex) {
        if (element == center.dx) {
          break;
        }
        index++;
      }

      context.canvas.drawLine(
          Offset(center.dx, center.dy),
          Offset(
              center.dx,
              labelDirection == NumericLabelDirection.down
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
              labelDirection == NumericLabelDirection.down
                  ? (center.dx - 12)
                  : (center.dx - 10),
              labelDirection == NumericLabelDirection.down
                  ? (center.dy + 20)
                  : (center.dy - 35)));
    }
  }
}
