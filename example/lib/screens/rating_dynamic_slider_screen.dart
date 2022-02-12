import 'package:dynamic_slider/rating_dynamic_slider.dart';
import 'package:flutter/material.dart';

class RatingDynamicSliderScreen extends StatefulWidget {
  const RatingDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _RatingDynamicSliderScreenState createState() => _RatingDynamicSliderScreenState();
}

class _RatingDynamicSliderScreenState extends State<RatingDynamicSliderScreen> {
  final List<String> imagesList = [];
  var value = "";

  @override
  void initState() {
    super.initState();

    imagesList.add("assets/smile1.png");
    imagesList.add("assets/smile2.png");
    imagesList.add("assets/smile3.png");
    imagesList.add("assets/smile4.png");
    imagesList.add("assets/smile5.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingDynamicSlider(
              onValueChanged: (val) {
                value = val.toString();
                setState(() {});
              },
              assetDirection: AssetDirection.ABOVE,
              imagesList: imagesList,
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
