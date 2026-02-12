import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pokemon_app/controllers/homepage_controller.dart';
import 'package:pokemon_app/models/page_data.dart';
import 'package:pokemon_app/providers/pokemon_data_provider.dart';
import 'package:pokemon_app/widgets/pokemon_card.dart';
import 'package:pokemon_app/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomepageController, HomePageData>(
      (ref) => HomepageController(HomePageData.initial()),
    );

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late HomepageController _controller;
  late HomePageData _data;
  late List<String> _favoriteUrls;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // if (_scrollController.position.pixels ==
    //     _scrollController.position.maxScrollExtent) {
    //   _controller.loadData();
    // }
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _controller.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller = ref.watch(homePageControllerProvider.notifier);
    _data = ref.watch(homePageControllerProvider);
    _favoriteUrls = ref.watch(favoriteProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Riverpod - Pokemon App")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // favorite pokemon list
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Favorite Pokemons",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // grid view of favorite pokemon with horizontal scroll
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_favoriteUrls.isEmpty)
                              SizedBox(
                                child: Text(
                                  "No favorite pokemon yet!",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (_favoriteUrls.isNotEmpty)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _favoriteUrls.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        crossAxisCount: 2,
                                      ),
                                  itemBuilder: (context, index) {
                                    return PokemonCard(
                                      pokemonUrl: _favoriteUrls[index],
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // all pokemon list
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "All Pokemons",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _data.data?.results?.length ?? 0,
                          itemBuilder: (context, index) {
                            // return ListTile(
                            //   title: Text(
                            //     _data.data?.results?[index].name ?? "",
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            //   subtitle: Text(
                            //     _data.data?.results?[index].url ?? "",
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.normal,
                            //     ),
                            //   ),
                            // );
                            return PokemonListTile(
                              pokemonUrl: _data.data?.results?[index].url ?? "",
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
