import 'package:objectbox/objectbox.dart';

@Entity()
class TaskData {
  @Id()
  int id;  
  String? title;
  bool? completed;

  TaskData({
    this.id = 0,  
    this.title,
    this.completed,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: 0, 
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
    );
  }
}
