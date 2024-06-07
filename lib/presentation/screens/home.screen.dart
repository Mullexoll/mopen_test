import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../widgets/home_screen_widgets/latest_section.dart';
import '../widgets/home_screen_widgets/top_five_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TopFiveSection(),
            Gap(10),
            LatestSection(),
          ],
        ),
      ),
    );
  }
}
