import 'dart:async';
import 'package:flutter/material.dart';

class RangeDynamicSlider extends StatefulWidget {
  /// Value change listener
  final Function(RangeValues val) onValueChanged;

  /// Total number of divisions
  final int? numberOfDivisions;

  /// Radius for thumb
  final double? thumbRadius;

  /// Radius for thumb overlay
  final double? overlayThumbRadius;

  /// Min Value
  final double min;

  /// Max Value
  final double max;

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

  RangeDynamicSlider({
    Key? key,
    required this.onValueChanged,
    required this.min,
    required this.max,
    this.numberOfDivisions,
    this.trackHeight = 5,
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
  }) : super(key: key);

  @override
  _RangeDynamicSliderState createState() => _RangeDynamicSliderState();
}

class _RangeDynamicSliderState extends State<RangeDynamicSlider> {

  /// Stream controller for slider output values
  final StreamController<RangeValues> dataController = StreamController<RangeValues>.broadcast();
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
          valueIndicatorColor: widget.valueIndicatorColor,
          thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: widget.thumbRadius!,
          )),
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
                widget.onValueChanged(values);
              },
            );
          }),
    );
  }
}
