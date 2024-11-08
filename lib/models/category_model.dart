class Category {
  int? id;
  String name;

  Category({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  Category.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
}
