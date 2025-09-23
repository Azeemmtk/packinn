import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';
import '../../../../../../core/utils/debounser.dart';
import '../provider/bloc/search/search_bloc.dart';
import '../provider/bloc/search/search_event.dart';
import '../provider/bloc/search/search_state.dart';
import '../provider/cubit/search_filter/search_filter_cubit.dart';
import '../provider/cubit/search_filter/search_filter_state.dart';
import 'filter_section_widget.dart';

class SearchFieldWidget extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchFieldWidget({super.key, this.focusNode, this.controller, this.onChanged});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Column(
      children: [
        BlocBuilder<SearchFilterCubit, SearchFilterState>(
          builder: (context, filterState) {
            return TextFormField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              onChanged: (value) {
                widget.onChanged?.call(value);
                _debouncer.run(() {
                  if (value.isEmpty) {
                    context.read<SearchBloc>().add(GetAutocompleteSuggestionsEvent(''));
                  } else {
                    context.read<SearchBloc>().add(GetAutocompleteSuggestionsEvent(value));
                    context.read<SearchBloc>().add(SearchHostelsEvent(value, filterState));
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search hostel',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.controller?.text.isNotEmpty ?? false)
                      IconButton(
                        onPressed: () {
                          widget.controller?.clear();
                          widget.onChanged?.call('');
                          context.read<SearchBloc>().add(GetAutocompleteSuggestionsEvent(''));
                          context.read<SearchBloc>().add(SearchHostelsEvent('', filterState));
                        },
                        icon: Icon(
                          Icons.clear,
                          size: width * 0.06,
                          color: customGrey,
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (bottomSheetContext) => BlocProvider.value(
                            value: BlocProvider.of<SearchFilterCubit>(parentContext),
                            child: FilterSectionWidget(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.filter_list_sharp,
                        size: width * 0.06,
                        color: customGrey,
                      ),
                    ),
                  ],
                ),
                prefixIcon: Icon(CupertinoIcons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
              ),
            );
          },
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            // Only show suggestions if the state is AutocompleteSuggestionsLoaded,
            // the suggestions list is not empty, and the search query is not empty
            if (state is AutocompleteSuggestionsLoaded &&
                state.suggestions.isNotEmpty &&
                (widget.controller?.text.isNotEmpty ?? false)) {
              return SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: state.suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.suggestions[index]),
                      onTap: () {
                        widget.controller?.text = state.suggestions[index];
                        context.read<SearchBloc>().add(
                            SearchHostelsEvent(state.suggestions[index], context.read<SearchFilterCubit>().state));
                        context.read<SearchBloc>().add(GetAutocompleteSuggestionsEvent(''));
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}