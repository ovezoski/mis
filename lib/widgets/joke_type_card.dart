import 'package:flutter/material.dart';
import '../models/joke_type.dart';
import '../screens/jokes_by_type_screen.dart';

class JokeTypeCard extends StatelessWidget {
  final JokeType jokeType;

  const JokeTypeCard({super.key, required this.jokeType});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          jokeType.type.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JokesByTypeScreen(type: jokeType.type),
            ),
          );
        },
      ),
    );
  }
}
