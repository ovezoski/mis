import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/joke.dart';
import '../services/api_services.dart';
import '../providers/joke_provider.dart';

class JokesByTypeScreen extends StatefulWidget {
  final String type;

  const JokesByTypeScreen({super.key, required this.type});

  @override
  State<JokesByTypeScreen> createState() => _JokesByTypeScreenState();
}

class _JokesByTypeScreenState extends State<JokesByTypeScreen> {
  late Future<List<Joke>> _jokesFuture;

  @override
  void initState() {
    super.initState();
    _jokesFuture = ApiServices.fetchJokesByType(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type.toUpperCase()} Jokes'),
      ),
      body: FutureBuilder<List<Joke>>(
        future: _jokesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jokes found'));
          }

          final jokeProvider =
              Provider.of<JokeProvider>(context, listen: false);
          jokeProvider.setJokes(snapshot.data!);

          return ChangeNotifierProvider.value(
            value: jokeProvider,
            child: Consumer<JokeProvider>(
              builder: (context, jokeProvider, child) {
                return ListView.builder(
                  itemCount: jokeProvider.jokes.length,
                  itemBuilder: (context, index) {
                    final joke = jokeProvider.jokes[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(joke.setup,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 10),
                                  Text(joke.punchline,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => jokeProvider.toggleFavorite(joke),
                            icon: Icon(
                                joke.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: joke.isFavorite ? Colors.red : null),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
