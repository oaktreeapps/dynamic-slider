import 'package:flutter/material.dart';
import 'package:dynamic_slider/dynamic_slider/rating_dynamic_slider.dart';

class RatingDynamicSliderScreen extends StatefulWidget {
  const RatingDynamicSliderScreen({Key? key}) : super(key: key);

  @override
  _RatingDynamicSliderScreenState createState() => _RatingDynamicSliderScreenState();
}

class _RatingDynamicSliderScreenState extends State<RatingDynamicSliderScreen> {
  final List<String> imagesList = [];

  @override
  void initState() {
    super.initState();

    imagesList.add("assets/smile1.png");
    imagesList.add("assets/smile5.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RatingDynamicSlider(
        onValueChanged: (val) {
          print(val.toString());
        },
        assetDirection: AssetDirection.up, imagesList: imagesList,
      ),
    );
  }
}
