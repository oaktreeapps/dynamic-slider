import 'package:flutter/material.dart';
import 'package:dynamic_slider/dynamic_slider/dynamic_slider.dart';

class DynamicSliderScreen extends StatefulWidget {

  const DynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _DynamicSliderScreenState createState() => _DynamicSliderScreenState();
}

class _DynamicSliderScreenState extends State<DynamicSliderScreen> {

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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DynamicSlider(
          isDivisible: true,
          numberOfDivisions: 5,
          inputValues: inputValues,
          onValueChanged: (val) {
            print(val.toString());
          },
        ),
      ),
    );
  }
}

