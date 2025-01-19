import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/joke.dart';

class JokeProvider with ChangeNotifier {
  List<Joke> _jokes = [];
  List<Joke> get jokes => _jokes;
  List<Joke> _favoriteJokes = [];
  List<Joke> get favoriteJokes => _favoriteJokes;
  final Set<String> _favoriteJokeIds = <String>{};

  JokeProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJokeIds = prefs.getStringList('favoriteJokeIds') ?? [];
    _favoriteJokeIds.addAll(favoriteJokeIds);
    notifyListeners();
  }

  Future<void> toggleFavorite(Joke joke) async {
    final prefs = await SharedPreferences.getInstance();

    if (joke.isFavorite) {
      _favoriteJokeIds.add(joke.id.toString());
    } else {
      _favoriteJokeIds.remove(joke.id.toString());
    }

    joke.isFavorite = !joke.isFavorite;

    _jokes
        .where((j) => j.id == joke.id)
        .forEach((j) => j.isFavorite = joke.isFavorite);

    await prefs.setStringList('favoriteJokeIds', _favoriteJokeIds.toList());

    _favoriteJokes = _jokes.where((j) => j.isFavorite).toList();

    notifyListeners();
  }

  void setJokes(List<Joke> jokesFromApi) {
    _jokes = jokesFromApi.map((joke) {
      return joke.copyWith(
        isFavorite: _favoriteJokeIds.contains(joke.id.toString()),
      );
    }).toList();

    notifyListeners();
  }
}
