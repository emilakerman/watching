import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/features/shows/cubits/cubits.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    required this.resetSearch,
    required this.searchController,
    super.key,
  });
  final VoidCallback resetSearch;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 7),
      child: SearchBar(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: const MaterialStatePropertyAll(Color(0xff1b1b22)),
        controller: searchController,
        trailing: [
          BlocBuilder<ShowCubit, ShowCubitState>(
            builder: (context, state) {
              return Row(
                children: [
                  searchController.text != ''
                      ? Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                            onTap: () {
                              searchController.clear();
                              resetSearch();
                            },
                            child: const Icon(
                              Icons.clear,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  IconButton(
                    onPressed: () async {
                      if (searchController.text.isNotEmpty) {
                        await context.read<ShowCubit>().getShowByName(
                              showName: searchController.text,
                            );
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
