class TaskModel {
  final String id;
  final String title;
  late final String description;
  late final String dueDate;
  final bool status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  factory TaskModel.fromFirestore(Map<String, dynamic> map, String docId) {
    return TaskModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] ?? '',
      status: map['status'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? dueDate,
    bool? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  String get statusText {
    if (status == true) {
      return 'Completed';
    } else {
      return 'Pending';
    }
  }
}
