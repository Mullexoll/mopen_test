import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';

import '../widgets/screens_header.dart';
import '../widgets/search_screen_widgets/search_bar.dart';
import '../widgets/search_screen_widgets/search_result_section.dart';

class SearchScreen extends StatelessWidget {
  final Future<bool> Function() onWillPop;

  const SearchScreen({
    super.key,
    required this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 35),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ScreensHeader(
              title: AppLocalizations.of(context)!.search,
              onWillPop: onWillPop,
            ),
            const Gap(15),
            const CustomSearchBar(),
            const Gap(15),
            const SearchResultSection(),
          ],
        ),
      ),
    );
  }
}
