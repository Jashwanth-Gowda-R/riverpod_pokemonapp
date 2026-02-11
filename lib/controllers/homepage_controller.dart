import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/models/page_data.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/services/http_services.dart';

class HomepageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HttpServices _httpServices;

  HomepageController(super._state) {
    _httpServices = _getIt.get<HttpServices>();
    _setup();
  }

  Future<void> _setup() async {
    await loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? response = await _httpServices.get(
        path: 'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0',
      );
      debugPrint('${response?.data}');

      if (response != null &&
          response.data != null &&
          response.data['results'] != null) {
        PokemonListData data = PokemonListData.fromJson(response.data);
        state = state.copyWith(data: data);
      }
    } else {}
  }
}
