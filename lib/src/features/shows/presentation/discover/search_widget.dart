import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    required this.searchCallback,
    required this.searchController,
    super.key,
  });
  final VoidCallback searchCallback;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        controller: searchController,
        trailing: [
          searchController.text != ''
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () {
                      searchController.clear();
                      searchCallback();
                    },
                    child: const Icon(
                      Icons.clear,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
        onChanged: (value) => searchCallback(),
      ),
    );
  }
}
