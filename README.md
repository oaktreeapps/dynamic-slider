<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# dynamic_slider

A custom implementation of ``Slider`` widget in Flutter that lets us set custom values.
## Getting started


## Install

In the ``pubspec.yaml`` of your flutter project, add the following dependency:

```yaml
dependencies:
  dynamic_slider: <latest_version>
```

Add then following import:

```dart
import 'package:dynamic_slider/custom_thumb_dynamic_slider.dart';
```


## Getting Started

Example:

```dart
import 'package:example/screens/custom_thumb_dynamic_slider_screen.dart';
import 'package:example/screens/dynamic_slider_screen.dart';
import 'package:example/screens/labeled_slider_screen.dart';
import 'package:example/screens/rating_dynamic_slider_screen.dart';
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
  void _navigateToScreen(BuildContext context, Widget widget) {
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
            ElevatedButton(
                onPressed: () {
                  _navigateToScreen(context, const DynamicSliderScreen());
                },
                child: const Text("Dynamic Slider")),
            ElevatedButton(
                onPressed: () {
                  _navigateToScreen(context, const LabeledDynamicSliderScreen());
                },
                child: const Text("Labeled Dynamic Slider")),
            ElevatedButton(
                onPressed: () {
                  _navigateToScreen(context, const RatingDynamicSliderScreen());
                },
                child: const Text("Rating Dynamic Slider")),
            ElevatedButton(
                onPressed: () {
                  _navigateToScreen(context, const CustomThumbDynamicSliderScreen());
                },
                child: const Text("Custom Thumb Dynamic Slider")),
          ],
        ),
      ),
    );
  }
}

```


## Demo
<p align="center">
<img src="https://github.com/oaktreeapps/dynamic-slider/blob/main/assets/demo.gif" width="300"/>
</p>


## Contributions

Feel free to contribute to this project.

* If you find a bug or want have a new feature request, please file an [issue][issue].
* If you fixed a bug or implemented a feature, please send a [pull request][pr].


<!-- Links -->
[issue]: https://github.com/oaktreeapps/dynamic-slider/issues
[pr]: https://github.com/oaktreeapps/dynamic-slider/pulls
