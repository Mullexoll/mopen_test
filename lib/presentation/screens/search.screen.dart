import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mopen_test/presentation/widgets/search_screen_widgets/search_bar.dart';
import 'package:mopen_test/presentation/widgets/search_screen_widgets/search_result_section.dart';

import '../widgets/screens_header.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ScreensHeader(
              title: 'Search',
            ),
            Gap(15),
            CustomSearchBar(),
            Gap(15),
            SearchResultSection(),
          ],
        ),
      ),
    );
  }
}
