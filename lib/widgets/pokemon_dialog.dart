import 'package:flutter/material.dart';
import 'package:pokemon_app/models/pokemon.dart';

class PokemanStatsDialog extends StatelessWidget {
  const PokemanStatsDialog({super.key, required this.pokemon});

  final Pokemon? pokemon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${pokemon?.name!.toUpperCase() ?? 'Loading Name'} Stats'),
      content: Column(
        children: [
          Expanded(
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                pokemon?.sprites?.frontDefault ?? "loading",
              ),
            ),
          ),
          Text('${pokemon?.moves?.length} Moves'),
          ...pokemon?.stats
                  ?.map((stat) => Text('${stat.stat?.name}: ${stat.baseStat}'))
                  .toList() ??
              [],
        ],
      ),
    );
  }
}
