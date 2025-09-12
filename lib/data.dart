import 'package:flutter/widgets.dart';

class Donut {
  final String name;
  final String image;
  final String overlayImage;
  final Color color;

  Donut({
    required this.name,
    required this.image,
    required this.overlayImage,
    required this.color,
  });
}

final List<Donut> donutList = [
  Donut(
    name: "strawberry",
    image: "assets/images/strawberry_donut.png",
    overlayImage: "assets/images/strawberry.png",
    color: const Color.fromARGB(255, 249, 8, 4),
  ),
  Donut(
    name: "chocolate",
    image: "assets/images/chocolate_donut.png",
    overlayImage: "assets/images/chocolate.png",
    color: const Color.fromARGB(255, 240, 160, 23),
  ),
  Donut(
    name: "blueberry",
    image: "assets/images/blueberry_donut.png",
    overlayImage: "assets/images/blueberry.png",
    color: const Color.fromARGB(255, 25, 139, 238),
  ),
  Donut(
    name: "blackberry",
    image: "assets/images/blackberry_donut.png",
    overlayImage: "assets/images/blackberry.png",
    color: const Color.fromARGB(255, 191, 40, 103),
  ),
];
