import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/joke_provider.dart';

class FavouriteJokesScreen extends StatelessWidget {
  const FavouriteJokesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jokeProvider = Provider.of<JokeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Jokes')),
      body: jokeProvider.favoriteJokes.isEmpty
          ? const Center(child: Text('No favorite jokes yet.'))
          : ListView.builder(
              itemCount: jokeProvider.favoriteJokes.length,
              itemBuilder: (context, index) {
                final joke = jokeProvider.favoriteJokes[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(joke.setup),
                    subtitle: Text(joke.punchline),
                  ),
                );
              },
            ),
    );
  }
}
