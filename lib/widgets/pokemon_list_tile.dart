import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/providers/pokemon_data_provider.dart';
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
      data: (pokemon) =>
          ListViewWidgetPokemon(pokemon: pokemon, isLoading: false),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => ListViewWidgetPokemon(pokemon: null, isLoading: true),
    );
  }
}

class ListViewWidgetPokemon extends StatelessWidget {
  Pokemon? pokemon;
  bool isLoading;
  ListViewWidgetPokemon({
    super.key,
    required this.pokemon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
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
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {},
        ),
      ),
    );
  }
}
