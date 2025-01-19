class Event {
  final DateTime dateTime;
  final String place;
  final String description;

  Event(
      {required this.dateTime, required this.place, required this.description});

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.millisecondsSinceEpoch,
        'place': place,
        'description': description,
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
        place: json['place'],
        description: json['description'],
      );
}
