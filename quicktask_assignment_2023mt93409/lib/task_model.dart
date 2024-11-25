class Task {
  String? objectId;
  final String title;
  final DateTime? dueDate;
  final bool completed; // Updated variable for completion status
  final String description;

  Task({
    this.objectId,
    required this.title,
    required this.dueDate,
    required this.completed,
    required this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      objectId: json['objectId'],
      title: json['title'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'].toString()) : null,
      completed: json['completed'] ?? false, // Assign default value if not provided
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'title': title,
      'dueDate': dueDate != null ? dueDate!.toIso8601String() : null, // Convert DateTime to ISO 8601 string
      'completed': completed,
      'description': description,
    };
  }

  // Define copyWith method
  Task copyWith({
    String? title,
    DateTime? dueDate,
    bool? completed,
    String? description,
  }) {
    return Task(
      objectId: this.objectId,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      description: description ?? this.description,
    );
  }
}
