class Joke {
  final int id;
  final String type;
  final String setup;
  final String punchline;
  bool isFavorite;

  Joke({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
    this.isFavorite = false,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      type: json['type'],
      setup: json['setup'],
      punchline: json['punchline'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'setup': setup,
        'punchline': punchline,
        'isFavorite': isFavorite,
      };

  Joke copyWith({bool? isFavorite}) {
    return Joke(
      id: id,
      type: type,
      setup: setup,
      punchline: punchline,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
