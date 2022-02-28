import 'package:dynamic_slider/range_labeled_dynamic_slider.dart';
import 'package:flutter/material.dart';

class RangeLabeledDynamicSliderScreen extends StatefulWidget {
  const RangeLabeledDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _RangeLabeledDynamicSliderScreenState createState() =>
      _RangeLabeledDynamicSliderScreenState();
}

class _RangeLabeledDynamicSliderScreenState
    extends State<RangeLabeledDynamicSliderScreen> {
  late List<int> inputValues;
  var value = "";

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
      20,
      40,
      45,
      60,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RangeLabeledDynamicSlider(
              onValueChanged: (val) {
                value = val.toString();
                setState(() {});
              },
              inputValues: inputValues,
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
