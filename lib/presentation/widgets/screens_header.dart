import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ScreensHeader extends StatelessWidget {
  final String title;
  final Future<bool> Function() onWillPop;

  const ScreensHeader({
    super.key,
    required this.title,
    required this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            await onWillPop();
          },
          child: SvgPicture.asset(
            'assets/icons/back_button.svg',
            width: 24,
            height: 24,
            fit: BoxFit.none,
          ),
        ),
        const Gap(15),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          '.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.yellowAccent,
              ),
        ),
      ],
    );
  }
}
