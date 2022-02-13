import 'package:dynamic_slider/labeled_dynamic_slider.dart';
import 'package:flutter/material.dart';

class DynamicSliderScreen extends StatefulWidget {
  const DynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _DynamicSliderScreenState createState() => _DynamicSliderScreenState();
}

class _DynamicSliderScreenState extends State<DynamicSliderScreen> {
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
      45,
      60,
      80,
      100,
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
            LabeledDynamicSlider(
              inputValues: inputValues,
              onValueChanged: (val) {
                value = val.toString();
                setState(() {});
              },
              labelDirection: NumericLabelDirection.below,
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
