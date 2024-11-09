class Reminder {
  int? id;
  String title;
  String description;
  String category;
  DateTime dateTime;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}


