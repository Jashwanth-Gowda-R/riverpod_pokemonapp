import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/providers/pokemon_data_provider.dart';
import 'package:pokemon_app/widgets/pokemon_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerStatefulWidget {
  final String pokemonUrl;

  const PokemonListTile({super.key, required this.pokemonUrl});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PokemonListTileState();
}

class _PokemonListTileState extends ConsumerState<PokemonListTile> {
  @override
  Widget build(BuildContext context) {
    final pokemon = ref.watch(pokemonProvider(widget.pokemonUrl));
    // return Container(child: ListTile(title: Text(widget.pokemonUrl)));

    return pokemon.when(
      data: (pokemon) => ListViewWidgetPokemon(
        pokemon: pokemon,
        isLoading: false,
        pokemonUrl: widget.pokemonUrl,
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => ListViewWidgetPokemon(
        pokemon: null,
        isLoading: true,
        pokemonUrl: widget.pokemonUrl,
      ),
    );
  }
}

class ListViewWidgetPokemon extends ConsumerWidget {
  Pokemon? pokemon;
  bool isLoading;
  late FavoriteProvider _favoriteProvider;
  late List<String> _favoriteList;
  final String pokemonUrl;
  ListViewWidgetPokemon({
    super.key,
    required this.pokemon,
    required this.isLoading,
    required this.pokemonUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoriteProvider = ref.watch(favoriteProvider.notifier);
    _favoriteList = ref.watch(favoriteProvider);

    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (context) => PokemanStatsDialog(pokemon: pokemon),
            );
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              pokemon?.sprites?.frontDefault ?? "loading",
            ),
          ),
          title: Text(pokemon?.name?.toUpperCase() ?? 'loading...'),
          subtitle: Text('Has ${pokemon?.moves?.length ?? 0} moves'),
          // favorite icon button
          trailing: IconButton(
            icon: _favoriteList.contains(pokemonUrl)
                ? const Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {
              if (_favoriteList.contains(pokemonUrl)) {
                _favoriteProvider.removeFavorite(pokemonUrl);
              } else {
                _favoriteProvider.addFavorite(pokemonUrl);
              }
            },
          ),
        ),
      ),
    );
  }
}
