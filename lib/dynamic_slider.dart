import 'dart:async';
import 'package:flutter/material.dart';

class DynamicSlider extends StatefulWidget {
  /// input array values
  final List<int> inputValues;

  /// Set false to remove divisions
  final bool isDivisible;

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

  /// tick mark radius
  final double? tickMarkRadius;

  DynamicSlider({
    Key? key,
    required this.inputValues,
    required this.isDivisible,
    required this.onValueChanged,
    this.numberOfDivisions,
    this.trackHeight = 3,
    this.thumbColor = Colors.blue,
    this.activeTrackColor = Colors.blueGrey,
    this.activeTickMarkColor = Colors.blue,
    this.inactiveTrackColor = Colors.black12,
    this.overlayColor = Colors.cyan,
    this.valueIndicatorColor = Colors.lightBlue,
    this.inactiveTickMarkColor = Colors.black87,
    this.thumbRadius = 11,
    this.overlayThumbRadius = 15,
    this.tickMarkRadius = 3,
    this.currencyPrefix = "\$",
  }) : assert(inputValues.isNotEmpty,"Please add values"),super(key: key);

  @override
  _DynamicSliderState createState() => _DynamicSliderState();
}

class _DynamicSliderState extends State<DynamicSlider> {

  /// stream controller for slider output values
  final StreamController<double> dataController = StreamController<double>.broadcast();
  Stream<double> get onSliderChange => dataController.stream;
  void updateSliderData(double value) {
    dataController.sink.add(value);
  }

  /// init state
  @override
  void initState() {
    super.initState();
    _initInputValues();
  }

  /// inputted array divisions
  _initInputValues() {
    if (widget.isDivisible && widget.numberOfDivisions != null) {
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
          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: widget.tickMarkRadius!),
          inactiveTickMarkColor: widget.inactiveTickMarkColor,
          overlayColor: widget.overlayColor,
          trackHeight: widget.trackHeight,
          showValueIndicator: ShowValueIndicator.always,
          valueIndicatorColor: widget.valueIndicatorColor,
          thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: widget.thumbRadius!,
          )),
      child: StreamBuilder<double>(
          initialData:
          widget.isDivisible && widget.numberOfDivisions != null
              ? 0
              : widget.inputValues.first.toDouble(),
          stream: onSliderChange,
          builder: (context, snapshot) {
            double value = snapshot.data!.toDouble();

            return Slider(
              value: value,
              min: widget.isDivisible
                  ? 0
                  : widget.inputValues.first.toDouble(),
              max: widget.isDivisible
                  ? widget.inputValues.length - 1
                  : widget.inputValues.last.toDouble(),
              divisions: widget.isDivisible
                  ? widget.inputValues.length - 1
                  : widget.inputValues.last,
              label: widget.isDivisible
                  ? widget.currencyPrefix +
                  widget.inputValues[value.toInt()].toString()
                  : widget.currencyPrefix + value.toInt().toString(),
              onChanged: (double value) {
                widget.onValueChanged(widget.isDivisible
                    ? widget.inputValues[value.toInt()].toDouble()
                    : value);
                updateSliderData(value);
              },
            );
          }),
    );
  }
}
