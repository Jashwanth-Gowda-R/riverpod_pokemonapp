import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/services/database_services.dart';
import 'package:pokemon_app/services/http_services.dart';

final pokemonProvider = FutureProvider.family<Pokemon?, String>((
  ref,
  url,
) async {
  HttpServices http = GetIt.instance.get<HttpServices>();

  Response? response = await http.get(path: url);
  if (response != null && response.data != null) {
    return Pokemon.fromJson(response.data);
  }
  return null;
});

final favoriteProvider = StateNotifierProvider<FavoriteProvider, List<String>>(
  (ref) => FavoriteProvider([]),
);

class FavoriteProvider extends StateNotifier<List<String>> {
  final DatabaseServices _databaseServices = GetIt.instance
      .get<DatabaseServices>();

  String key = 'favorites';

  FavoriteProvider(super._state) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? result = await _databaseServices.getUrlLists(key);
    if (result != null) {
      state = result;
    } else {
      state = [];
    }
  }

  void addFavorite(String url) {
    state = [...state, url];
    _databaseServices.saveUrlLists(key, state);
  }

  void removeFavorite(String url) {
    state = state.where((element) => element != url).toList();
    _databaseServices.saveUrlLists(key, state);
  }
}
