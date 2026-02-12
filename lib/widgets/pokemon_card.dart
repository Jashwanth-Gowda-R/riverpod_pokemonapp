import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/providers/pokemon_data_provider.dart';
import 'package:pokemon_app/widgets/pokemon_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerStatefulWidget {
  final String pokemonUrl;
  const PokemonCard({super.key, required this.pokemonUrl});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PokemonCardState();
}

class _PokemonCardState extends ConsumerState<PokemonCard> {
  @override
  Widget build(BuildContext context) {
    final pokemon = ref.watch(pokemonProvider(widget.pokemonUrl));
    return pokemon.when(
      data: (pokemon) => FavoriteCard(
        pokemon: pokemon,
        isLoading: false,
        pokemonUrl: widget.pokemonUrl,
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => FavoriteCard(
        pokemon: null,
        isLoading: true,
        pokemonUrl: widget.pokemonUrl,
      ),
    );
  }
}

// create a ConsumerWidget to create favouite card to show facvorite pokemon
class FavoriteCard extends ConsumerWidget {
  Pokemon? pokemon;
  bool isLoading;
  late FavoriteProvider _favoriteProvider;
  late List<String> _favoriteList;
  final String pokemonUrl;

  FavoriteCard({
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
        child: SizedBox(
          child: Card(
            elevation: 5,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      pokemon?.name!.toUpperCase() ?? 'Loading Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '# ${pokemon?.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      pokemon?.sprites?.frontDefault ?? "loading",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${pokemon?.moves?.length} Moves',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
