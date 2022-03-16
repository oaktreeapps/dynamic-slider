import 'package:flutter/material.dart';
import 'package:dynamic_slider/range_custom_thumb_dynamic_slider.dart';

class RangeCustomThumbDynamicSliderScreen extends StatefulWidget {
  const RangeCustomThumbDynamicSliderScreen({Key? key}) : super(key: key);
  @override
  _RangeCustomThumbDynamicSliderScreenState createState() => _RangeCustomThumbDynamicSliderScreenState();
}

class _RangeCustomThumbDynamicSliderScreenState extends State<RangeCustomThumbDynamicSliderScreen> {

  var value = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RangeCustomThumbDynamicSlider(
              thumbRadius: 23,
              currencyPrefix: "\$",
              min: 0,
              max: 100,
              onValueChanged: (val) {
                value = val.toString();
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              "Output : " + value,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
