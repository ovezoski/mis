import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mis_app/models/event.dart';

class EventRepository {
  static const String _eventsKey = 'events';

  Future<void> saveEvents(Map<DateTime, List<Event>> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = jsonEncode(events.map((key, value) => MapEntry(
        key.toIso8601String(), value.map((event) => event.toJson()).toList())));
    await prefs.setString(_eventsKey, eventsJson);
  }

  Future<Map<DateTime, List<Event>>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_eventsKey);

    if (eventsJson == null) {
      return {};
    }

    try {
      final jsonMap = jsonDecode(eventsJson) as Map<String, dynamic>;
      return jsonMap.map((key, value) => MapEntry(
          DateTime.parse(key),
          (value as List<dynamic>)
              .map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList()));
    } catch (e) {
      return {};
    }
  }

  Future<void> addEvent(Event event) async {
    final events = await loadEvents();
    final date = event.dateTime;
    final existingEvents = events[date] ?? [];
    events[date] = [...existingEvents, event];
    await saveEvents(events);
  }

  Future<void> deleteEvent(Event event) async {
    final events = await loadEvents();
    final date = event.dateTime;
    events[date]?.remove(event);
    await saveEvents(events);
  }
}
