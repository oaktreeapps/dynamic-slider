import 'package:flutter/material.dart';
import 'package:dynamic_slider/dynamic_slider.dart';

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

