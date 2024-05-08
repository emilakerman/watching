import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/src/src.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShowCubit>().getAllFeatured();
  }

  bool isShowCase = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShowCubit, ShowCubitState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingAnimation();
          }
          final List<String> strings = [];
          for (final Show show in state.shows) {
            strings.add(show.image!.original.toString());
          }
          return isShowCase
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FanCarouselImageSlider(
                      initalPageIndex: 0,
                      imagesLink: strings,
                      isAssets: false,
                      autoPlay: true,
                    ),
                    Flexible(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isShowCase = false;
                          });
                        },
                        child: Text("See details"),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Featured shows",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                        IconButton(
                                          onPressed: () => setState(() {
                                            isShowCase = true;
                                          }),
                                          icon: const Icon(
                                            Icons.image_search_outlined,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SearchView(
                            shows: state.shows,
                            deleteFeature: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
