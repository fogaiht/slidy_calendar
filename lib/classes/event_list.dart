class EventList<T> {
  Map<DateTime, List<T>> events;

  EventList({
    this.events,
  });

  void add(DateTime date, T event) {
    if (events == null) {
      events = {
        date: [event]
      };
    } else if (!events.containsKey(date)) {
      events[date] = [event];
    } else {
      events[date].add(event);
    }
  }

  void addAll(DateTime date, List<T> events) {
    if (this.events == null) {
      this.events = {date: events};
    } else if (!this.events.containsKey(date)) {
      this.events[date] = events;
    } else {
      this.events[date].addAll(events);
    }
  }

  bool remove(DateTime date, T event) {
    return events != null && events.containsKey(date) ? events[date].remove(event) : false;
  }

  List<T> removeAll(DateTime date) {
    return events != null && events.containsKey(date) ? events.remove(date) : [];
  }

  void clear() {
    if (events != null) {
      events.clear();
    } else {
      events = {};
    }
  }

  List<T> getEvents(DateTime date) {
    if (events != null) {
      List<DateTime> eventsKeys = events.keys.map((e) => DateTime(e.year, e.month, e.day)).toList();
      if (eventsKeys.contains(date)) {
        DateTime dateT = events.keys.firstWhere(
          (element) => element.day == date.day && element.month == date.month && element.year == date.year,
        );
        return events[dateT];
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  List<T> getAllEvents() {
    return events != null ? events.values.expand((element) => element).toList() : [];
  }

  @override
  String toString() => 'EventList(events: $events)';
}
