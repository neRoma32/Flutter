class TodoItem {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  //А категорії завдань
  final String? category; 

  TodoItem({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.category, 
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'category': category, 
    };
  }

  TodoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    String? category, 
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category, 
    );
  }
}