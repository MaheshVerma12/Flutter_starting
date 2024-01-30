class Todo {
  final String id;
  final String title;
  final String description;
  Todo({required this.id, required this.title, required this.description});
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map["_id"], title: map["title"], description: map["description"]);
  }
  factory Todo.fromDBMap(Map<String, dynamic> map) {
    return Todo(
        id: map["id"], title: map["title"], description: map["description"]);
  }
}
