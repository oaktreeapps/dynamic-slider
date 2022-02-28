import 'package:dynamic_slider/range_dynamic_slider.dart';
import 'package:flutter/material.dart';

class RangeDynamicSliderScreen extends StatefulWidget {
  const RangeDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _RangeDynamicSliderScreenState createState() => _RangeDynamicSliderScreenState();
}

class _RangeDynamicSliderScreenState extends State<RangeDynamicSliderScreen> {
  var value = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RangeDynamicSlider(
              numberOfDivisions: 10,
              onValueChanged: (val) {
                value = val.toString();
                setState(() {});
              },
              max: 100,
              min: 0,
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
