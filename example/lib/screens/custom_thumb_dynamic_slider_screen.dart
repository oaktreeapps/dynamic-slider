import 'package:flutter/material.dart';
import 'package:dynamic_slider/dynamic_slider/custom_thumb_dynamic_slider.dart';

class CustomThumbDynamicSliderScreen extends StatefulWidget {
  const CustomThumbDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _CustomThumbDynamicSliderScreenState createState() => _CustomThumbDynamicSliderScreenState();
}

class _CustomThumbDynamicSliderScreenState extends State<CustomThumbDynamicSliderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomThumbDynamicSlider(
        min: 12,
        max: 100,
        onValueChanged: (val) {
          print(val.toString());
        },
      ),
    );
  }
}
