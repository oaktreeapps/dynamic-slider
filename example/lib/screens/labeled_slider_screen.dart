import 'package:dynamic_slider/dynamic_slider.dart';
import 'package:flutter/material.dart';

class LabeledDynamicSliderScreen extends StatefulWidget {
  const LabeledDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _LabeledDynamicSliderScreenState createState() => _LabeledDynamicSliderScreenState();
}

class _LabeledDynamicSliderScreenState extends State<LabeledDynamicSliderScreen> {
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
            DynamicSlider(
              isDivisible: true,
              inputValues: inputValues,
              onValueChanged: (val) {
                value = val.toString();
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
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
