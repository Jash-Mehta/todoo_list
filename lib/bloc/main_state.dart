
import 'package:todoo_list/model/taskData.dart';

class MainState {
  @override
  String toString() {
    return super.toString();
  }
}

class MainInitialState extends MainState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class TaskLoadingState extends MainState {}

class TaskLoadedState extends MainState {
  final List<TaskData> tasks;
  TaskLoadedState(this.tasks);
}

class TaskErrorState extends MainState {
  final String message;
  TaskErrorState(this.message);
}