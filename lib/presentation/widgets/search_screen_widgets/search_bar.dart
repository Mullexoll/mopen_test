import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mopen_test/bloc/app_bloc.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  CustomSearchBarState createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _textController = TextEditingController();

  CustomSearchBarState();

  _onSearchBarSubmitted(String value) {
    final _ = BlocProvider.of<AppBloc>(context).add(
      FetchSearchedMovies(query: value),
    );

    setState(() {
      _textController.text = value;
    });
  }

  _onSearchBarChanged(String value) {
    setState(() {
      _textController.text = value;
    });
  }

  clearSearchBar() {
    final _ = BlocProvider.of<AppBloc>(context).add(
      ClearSearchedList(),
    );
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: _textController,
      backgroundColor: WidgetStateProperty.all(
        const Color(0xFF2B2B2B),
      ),
      overlayColor: WidgetStateProperty.all(
        const Color(0xFF2B2B2B),
      ),
      side: WidgetStateProperty.all(
        _textController.text != ''
            ? const BorderSide(
                color: Colors.yellowAccent,
              )
            : BorderSide.none,
      ),
      hintText: 'Search',
      hintStyle: WidgetStateProperty.all(
        Theme.of(context).textTheme.titleMedium,
      ),
      textStyle: WidgetStateProperty.all(
        Theme.of(context).textTheme.titleMedium,
      ),
      shape: WidgetStateProperty.all(
        const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
      onSubmitted: (String value) => _onSearchBarSubmitted(value),
      onChanged: (String value) => _onSearchBarChanged(value),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: SvgPicture.asset(
          'assets/icons/search_disable_icon.svg',
          width: 24,
          height: 24,
          fit: BoxFit.none,
        ),
      ),
      trailing: [
        if (_textController.text != '')
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => clearSearchBar(),
              child: SvgPicture.asset(
                'assets/icons/close_icon.svg',
                width: 24,
                height: 24,
                fit: BoxFit.none,
              ),
            ),
          )
      ],
    );
  }
}
