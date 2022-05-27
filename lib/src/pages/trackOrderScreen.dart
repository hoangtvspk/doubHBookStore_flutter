// import 'package:flutter/material.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:timelines/timelines.dart';
// class ShowcaseDeliveryTimeline extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Showcase(
//       title: 'Delivery Timeline',
//       app: _DeliveryTimelineApp(),
//       description:
//       'A simple timeline with few steps to show the current status of '
//           'an order.',
//       template: SimpleTemplate(reverse: false),
//       theme: TemplateThemeData(
//         frameTheme: FrameThemeData(
//           statusBarBrightness: Brightness.dark,
//           frameColor: const Color(0xFF215C3F),
//         ),
//         flutterLogoColor: FlutterLogoColor.original,
//         brightness: Brightness.dark,
//         backgroundColor: const Color(0xFFE9E9E9),
//         titleTextStyle: GoogleFonts.neuton(
//           fontSize: 80,
//           fontWeight: FontWeight.bold,
//           color: const Color(0xFF2C7B54),
//         ),
//         descriptionTextStyle: GoogleFonts.yantramanav(
//           fontSize: 24,
//           height: 1.2,
//           color: const Color(0xFF2C7B54),
//         ),
//         buttonTextStyle: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           letterSpacing: 2,
//         ),
//         buttonIconTheme: const IconThemeData(color: Colors.white),
//         buttonTheme: ButtonThemeData(
//           buttonColor: const Color(0xFF2C7B54),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//           padding: const EdgeInsets.all(16),
//         ),
//       ),
//       links: [
//         LinkData.github('https://github.com/JHBitencourt/timeline_tile'),
//       ],
//       logoLink: LinkData(
//         icon: Image.asset(
//           'assets/built_by_jhb_black.png',
//           fit: BoxFit.fitHeight,
//         ),
//         url: 'https://github.com/JHBitencourt',
//       ),
//     );
//   }
// }
//
