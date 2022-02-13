import 'dart:async';

import 'package:flutter/material.dart';

class DynamicSlider extends StatefulWidget {
  /// Input array values
  final List<int> inputValues;

  /// Set false to remove division points across slider
  final bool isDivisible;

  /// Value change listener
  final Function(double val) onValueChanged;

  /// Total number of divisions
  final int? numberOfDivisions;

  /// Radius for thumb
  final double? thumbRadius;

  /// Radius for thumb overlay
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

  /// Color for overlay
  final Color? overlayColor;

  /// Color for values indicator
  final Color? valueIndicatorColor;

  /// Color for inactive tick mark color
  final Color? inactiveTickMarkColor;

  /// Currency prefix for input values
  final String currencyPrefix;

  /// Tick mark radius
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
  })  : assert(inputValues.isNotEmpty, "Input Values cannot be empty."),
        super(key: key);

  @override
  _DynamicSliderState createState() => _DynamicSliderState();
}

class _DynamicSliderState extends State<DynamicSlider> {
  /// Stream controller for slider output values
  final StreamController<double> dataController = StreamController<double>.broadcast();
  Stream<double> get onSliderChange => dataController.stream;
  void updateSliderData(double value) {
    dataController.sink.add(value);
  }

  @override
  void initState() {
    super.initState();
    _initInputValues();
  }

  @override
  void dispose() {
    super.dispose();
    dataController.close();
  }

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
          overlayShape: RoundSliderThumbShape(enabledThumbRadius: widget.overlayThumbRadius!),
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
          initialData: widget.isDivisible && widget.numberOfDivisions != null ? 0 : widget.inputValues.first.toDouble(),
          stream: onSliderChange,
          builder: (context, snapshot) {
            double value = snapshot.data!.toDouble();

            return Slider(
              value: value,
              min: widget.isDivisible ? 0 : widget.inputValues.first.toDouble(),
              max: widget.isDivisible ? widget.inputValues.length - 1 : widget.inputValues.last.toDouble(),
              divisions: widget.isDivisible ? widget.inputValues.length - 1 : widget.inputValues.last,
              label: widget.isDivisible
                  ? widget.currencyPrefix + widget.inputValues[value.toInt()].toString()
                  : widget.currencyPrefix + value.toInt().toString(),
              onChanged: (double value) {
                widget.onValueChanged(widget.isDivisible ? widget.inputValues[value.toInt()].toDouble() : value);
                updateSliderData(value);
              },
            );
          }),
    );
  }
}
