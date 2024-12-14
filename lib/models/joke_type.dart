class JokeType {
  final String type;

  JokeType({required this.type});

  factory JokeType.fromJson(String type) {
    return JokeType(type: type);
  }
}
