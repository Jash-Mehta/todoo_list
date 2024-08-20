import 'package:todoo_list/model/taskData.dart';

class MainEvents {}

class GetAllTaskEvent extends MainEvents {}

class UpdateTaskEvent extends MainEvents {
  final TaskData task;
  final int id;
  UpdateTaskEvent(this.task, this.id);
}

class AddTaskEvent extends MainEvents {
  final TaskData task;
  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends MainEvents {
  final int id;
  DeleteTaskEvent({
    required this.id,
  });
  
}
