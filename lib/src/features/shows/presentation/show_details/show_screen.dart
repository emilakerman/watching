import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

String removePTagsAndBTags(String text) {
  final String cleanText = text.replaceAll(RegExp(r'</?(p|b)>'), '');
  return cleanText;
}

class ShowScreen extends StatelessWidget {
  const ShowScreen({
    required this.showId,
    super.key,
  });
  final int? showId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ShowCubit, ShowCubitState, Show?>(
      selector: (state) {
        if (showId == null) const LoadingAnimation();
        return state.getShowbyId(showId ?? 1);
      },
      builder: (context, show) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      width: double.infinity,
                      height: 550,
                      fit: BoxFit.cover,
                      imageUrl: show?.image?.original ??
                          'https://i.imgur.com/U0xPF44.jpeg',
                      progressIndicatorBuilder: (context, url, progress) =>
                          const LoadingAnimation(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Theme.of(context).scaffoldBackgroundColor,
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                    ),
                    const PopButtonRow(),
                    ShowTextColumn(
                      showName: show?.name ?? 'Show name',
                      showGenres: show?.genres ?? [],
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Text(
                    removePTagsAndBTags(show?.summary ?? 'Summary'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                style: ButtonStyle(
                  fixedSize: const MaterialStatePropertyAll(
                    Size(50, 50),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.grey[800],
                  ),
                ),
                onPressed: show == null
                    ? null
                    : () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => FavoriteAlert(
                            show: show,
                            userId: context
                                .read<AuthCubit>()
                                .state
                                .user!
                                .uid
                                .hashCode,
                          ),
                        );
                      },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                style: ButtonStyle(
                  fixedSize: const MaterialStatePropertyAll(
                    Size(50, 50),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.grey[800],
                  ),
                ),
                onPressed: show == null
                    ? null
                    : () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => WatchingAlert(
                            show: show,
                            userId: context
                                .read<AuthCubit>()
                                .state
                                .user!
                                .uid
                                .hashCode,
                          ),
                        );
                      },
                icon: Icon(
                  Icons.add,
                  color: Colors.red[400],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShowTextColumn extends StatelessWidget {
  const ShowTextColumn({
    required this.showName,
    required this.showGenres,
    super.key,
  });
  final String showName;
  final List<String> showGenres;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Positioned(
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$showName',
              style: textTheme.displayLarge,
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 30,
              width: 900,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                shrinkWrap: true,
                itemCount: showGenres.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.blue[800]?.withOpacity(0.5),
                      ),
                    ),
                    onPressed: null,
                    child: Text(
                      style: const TextStyle(color: Colors.white),
                      showGenres[index],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class PopButtonRow extends StatelessWidget {
  const PopButtonRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 55, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.grey[600],
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
