import 'package:example/screens/custom_thumb_dynamic_slider_screen.dart';
import 'package:example/screens/labeled_oak_slider_screen.dart';
import 'package:example/screens/oak_slider_screen.dart';
import 'package:example/screens/rating_oak_slider_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Slider Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dynamic Slider'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _navigateToScreen(BuildContext context,Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(onPressed: (){
              _navigateToScreen(context, const DynamicSliderScreen());
            }, child: const Text("Dynamic Slider")),

            ElevatedButton(onPressed: (){
              _navigateToScreen(context, const LabeledDynamicSliderScreen());
            }, child: const Text("Labeled Dynamic Slider")),

            ElevatedButton(onPressed: (){
              _navigateToScreen(context, const RatingDynamicSliderScreen());
            }, child: const Text("Rating Dynamic Slider")),

            ElevatedButton(onPressed: (){
              _navigateToScreen(context, const CustomThumbDynamicSliderScreen());
            }, child: const Text("Custom Thumb Dynamic Slider")),

          ],
        ),
      ),
    );
  }
}
