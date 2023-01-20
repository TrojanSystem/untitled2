class TaskModel {
  String content;
  DateTime timeStamp;
  bool done;

  TaskModel({
    required this.content,
    required this.done,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'done': done,
      'timeStamp': timeStamp,
    };
  }

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      content: map['content'],
      done: map['done'],
      timeStamp: map['timeStamp'],
    );
  }
}
