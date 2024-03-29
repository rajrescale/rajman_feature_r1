import "package:flutter/material.dart";

// String uri = 'https://us-central1-offers-6e772.cloudfunctions.net/app';
String uri = 'https://localhost';

class GlobalVariables {
  // colors
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  // static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const secondaryColor = Color.fromARGB(255, 125, 221, 216);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'assets/images/mango1.jpeg',
    'assets/images/mango2.jpeg',
    'assets/images/mango3.jpeg',
    'assets/images/mango4.jpeg',
    'assets/images/mango5.jpeg',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Mango1',
      'image': 'assets/images/mango1.jpeg',
    },
    {
      'title': 'Mango2',
      'image': 'assets/images/mango2.jpeg',
    },
    {
      'title': 'Mango3',
      'image': 'assets/images/mango3.jpeg',
    },
    {
      'title': 'Mango4',
      'image': 'assets/images/mango4.jpeg',
    },
    {
      'title': 'Mango5',
      'image': 'assets/images/mango5.jpeg',
    },
  ];
}
