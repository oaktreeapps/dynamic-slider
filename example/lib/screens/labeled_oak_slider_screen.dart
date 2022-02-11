import 'package:flutter/material.dart';
import 'package:dynamic_slider/dynamic_slider/labeled_dynamic_slider.dart';

class LabeledDynamicSliderScreen extends StatefulWidget {
  const LabeledDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _LabeledDynamicSliderScreenState createState() => _LabeledDynamicSliderScreenState();
}

class _LabeledDynamicSliderScreenState extends State<LabeledDynamicSliderScreen> {
  late List<int> inputValues;

  @override
  void initState() {
    super.initState();
    inputValues = [
      5,
      8,
      10,
      12,
      18,
      30,
      45,
      60,
      80,
      100,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LabeledDynamicSlider(
        inputValues: inputValues,
        onValueChanged: (val) {
          print(val.toString());
        },
        labelDirection: NumericLabelDirection.down,
      ),
    );
  }
}
