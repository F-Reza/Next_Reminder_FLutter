class Reminder {
  int? id;
  String title;
  String description;
  String category;
  DateTime dateTime; // Store DateTime for scheduling notifications

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
  });

  // Convert the reminder to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dateTime': dateTime.toIso8601String(), // Store as ISO string in the database
    };
  }

  // Create a Reminder instance from a map (e.g., from the database)
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      dateTime: DateTime.parse(map['dateTime']), // Convert ISO string back to DateTime
    );
  }
}
