import 'package:flutter/material.dart';
import '../models/joke_type.dart';
import '../services/api_services.dart';
import '../widgets/joke_type_card.dart';
import 'random_joke_screen.dart';

class JokeTypesScreen extends StatefulWidget {
  const JokeTypesScreen({super.key});

  @override
  _JokeTypesScreenState createState() => _JokeTypesScreenState();
}

class _JokeTypesScreenState extends State<JokeTypesScreen> {
  late Future<List<JokeType>> _jokeTypesFuture;

  @override
  void initState() {
    super.initState();
    _jokeTypesFuture = ApiServices.fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RandomJokeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<JokeType>>(
        future: _jokeTypesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No joke types found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return JokeTypeCard(jokeType: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
