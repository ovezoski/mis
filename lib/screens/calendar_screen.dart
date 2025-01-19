import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mis_app/models/event.dart';
import 'package:mis_app/repository/event_repository.dart';
import 'map_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final EventRepository _eventRepository = EventRepository();
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final loadedEvents = await _eventRepository.loadEvents();
    setState(() {
      _events = loadedEvents;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Widget _buildCalendar() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final startingWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _selectDate(
                  DateTime(_selectedDate.year, _selectedDate.month - 1)),
            ),
            Text('${_selectedDate.month}/${_selectedDate.year}'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => _selectDate(
                  DateTime(_selectedDate.year, _selectedDate.month + 1)),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7),
          itemCount: daysInMonth + startingWeekday,
          itemBuilder: (context, index) {
            if (index < startingWeekday) return const SizedBox.shrink();
            final day = index - startingWeekday + 1;
            final currentDate =
                DateTime(_selectedDate.year, _selectedDate.month, day);
            final dateString = currentDate.toString();
            final hasEvent = _events.containsKey(dateString);

            return GestureDetector(
              onTap: () => _selectDate(currentDate),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: currentDate == _selectedDate
                      ? Colors.blue
                      : hasEvent
                          ? Colors.orange.withOpacity(0.5)
                          : null,
                ),
                alignment: Alignment.center,
                child: Text('$day'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    final eventsOnSelectedDate = _events.entries
        .where((entry) =>
            entry.key.year == _selectedDate.year &&
            entry.key.month == _selectedDate.month &&
            entry.key.day == _selectedDate.day)
        .expand((entry) => entry.value)
        .toList();

    return eventsOnSelectedDate.isEmpty
        ? const Text('No events for this day.')
        : Expanded(
            child: ListView.builder(
            itemCount: eventsOnSelectedDate.length,
            itemBuilder: (context, index) {
              final event = eventsOnSelectedDate[index];
              final formattedTime = DateFormat.Hm().format(event.dateTime);
              return ListTile(
                leading: const Icon(Icons.event),
                title: Text(formattedTime),
                subtitle: Text('${event.place} - ${event.description}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const MapDialog(),
                    );
                  },
                  child: const Text('Show Map'),
                ),
              );
            },
          ));
  }

  Future<String?> _showInputDialog(String label) async {
    String? inputText;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $label'),
          content: TextField(
            onChanged: (value) => inputText = value,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
    return inputText;
  }

  void _addEvent() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final place = await _showInputDialog('Place');
      final description = await _showInputDialog('Description');

      if (place != null && description != null) {
        final newEvent = Event(
            dateTime: DateTime(_selectedDate.year, _selectedDate.month,
                _selectedDate.day, selectedTime.hour, selectedTime.minute),
            place: place,
            description: description);
        await _eventRepository.addEvent(newEvent);
        _loadEvents();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 20),
          _buildEventList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
