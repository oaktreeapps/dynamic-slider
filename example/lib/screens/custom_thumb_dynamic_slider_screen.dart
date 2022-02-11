import 'package:flutter/material.dart';
import 'package:dynamic_slider/dynamic_slider/custom_thumb_dynamic_slider.dart';

class CustomThumbDynamicSliderScreen extends StatefulWidget {
  const CustomThumbDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _CustomThumbDynamicSliderScreenState createState() => _CustomThumbDynamicSliderScreenState();
}

class _CustomThumbDynamicSliderScreenState extends State<CustomThumbDynamicSliderScreen> {

  var value = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomThumbDynamicSlider(
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
