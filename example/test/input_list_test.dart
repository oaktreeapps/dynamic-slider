import 'package:flutter_test/flutter_test.dart';

void main() {
  test('List should not be empty', () {
    var inputValues = [
      5,
      8,
      10,
      12,
      18,
      30,
      45,
      60,
    ];

    /// success when array size > 0
    expect(inputValues.isNotEmpty, true);
    expect(inputValues.isEmpty, false);

    /// success when array type is List<int>
    expect(inputValues.runtimeType == List<int>, true);
    expect(inputValues.runtimeType != List<int>, false);
  });

  test('Asset List should not be empty', () {
    List<String> imagesList = [
      "assets/smile1.png",
      "assets/smile2.png",
      "assets/smile3.png",
      "assets/smile4.png",
      "assets/smile5.png",
    ];

    /// success when array size > 0
    expect(imagesList.isNotEmpty, true);
    expect(imagesList.isEmpty, false);

    /// success when array type is List<String>
    expect(imagesList.runtimeType == List<String>, true);
    expect(imagesList.runtimeType != List<String>, false);

    var list = imagesList
        .where(
            (element) => element.contains(".png") || element.contains(".jpg"))
        .toList();

    /// success when array element image is .png or .jpg format
    expect(list.length == imagesList.length, true);
    expect(list.length != imagesList.length, false);
  });
}
