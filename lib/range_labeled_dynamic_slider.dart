import 'dart:async';

import 'package:flutter/material.dart';

enum NumericLabelDirection { above, below }

class RangeLabeledDynamicSlider extends StatefulWidget {

  /// Input array values
  final List<int> inputValues;

  /// Value change listener
  final Function(RangeValues val) onValueChanged;

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

  RangeLabeledDynamicSlider({
    Key? key,
    required this.inputValues,
    required this.onValueChanged,
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
    this.labelDirection = NumericLabelDirection.above,
    this.tickMarkRadius = 3,
    this.numericLabelTextStyle = const TextStyle(
        color: Colors.black, fontSize: 14.0, fontFamily: 'Roboto'),
  })  : assert(inputValues.isNotEmpty, "Please add values"),
        super(key: key);

  @override
  _RangeLabeledDynamicSliderState createState() =>
      _RangeLabeledDynamicSliderState();
}

class _RangeLabeledDynamicSliderState extends State<RangeLabeledDynamicSlider> {

  List<int> inputValuesList = [];

  /// Stream controller for slider output values
  late final StreamController<RangeValues> dataController =
      StreamController<RangeValues>.broadcast();
  Stream<RangeValues> get onSliderChange => dataController.stream;
  void updateSliderData(RangeValues value) {
    dataController.sink.add(value);
  }

  @override
  void initState() {
      for (int i = 0; i <= widget.inputValues.length; i++) {
        int val = ((widget.inputValues.length - 1) * i).toInt();
        inputValuesList.add(val);
      }
      print(inputValuesList);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dataController.close();
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
          rangeTickMarkShape: LineSliderTickMarkShape(
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
      child: StreamBuilder<RangeValues>(
          initialData: RangeValues(widget.inputValues.first.toDouble(),
              widget.inputValues.last.toDouble()),
          stream: onSliderChange,
          builder: (context, snapshot) {
            return RangeSlider(
              min: widget.inputValues.first.toDouble(),
              max: widget.inputValues.last.toDouble(),
              values: snapshot.data!,
              divisions: widget.inputValues.length - 1,
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
  }
}

class LineSliderTickMarkShape extends RangeSliderTickMarkShape {
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
  Size getPreferredSize(
      {required SliderThemeData sliderTheme, bool? isEnabled}) {
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox? parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset startThumbCenter,
      required Offset endThumbCenter,
      bool? isEnabled,
      required TextDirection textDirection}) {
    Color? begin;
    Color? end;
    switch (textDirection) {
      case TextDirection.ltr:
        final bool isTickMarkRightOfThumb = center.dx > startThumbCenter.dx;
        begin = isTickMarkRightOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkRightOfThumb
            ? sliderTheme.inactiveTickMarkColor
            : sliderTheme.activeTickMarkColor;

        break;
      case TextDirection.rtl:
        final bool isTickMarkLeftOfThumb = center.dx < endThumbCenter.dx;
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
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    if (tickMarkRadius! > 0) {
      context.canvas.drawCircle(
          Offset(center.dx, center.dy), tickMarkRadius!, tickMarkPaint);

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
              labelDirection == NumericLabelDirection.below
                  ? (center.dy +
                      ((100 * inputValues![index]) / inputValues!.last))
                  : (center.dy -
                      ((100 * inputValues![index]) / inputValues!.last))),
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
              labelDirection == NumericLabelDirection.below
                  ? (center.dx - 12)
                  : (center.dx - 10),
              labelDirection == NumericLabelDirection.below
                  ? (center.dy + 20)
                  : (center.dy -
                      ((100 * inputValues![index]) / inputValues!.last) -
                      20)));
    }
  }
}
