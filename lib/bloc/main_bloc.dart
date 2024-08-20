import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_list/bloc/main_event.dart';
import 'package:todoo_list/bloc/main_state.dart';
import 'package:todoo_list/model/taskData.dart';
import 'package:todoo_list/services/web_services.dart';

class MainBloc extends Bloc<MainEvents, MainState> {
  final WebServices webServices;

  MainBloc({required this.webServices}) : super(TaskLoadingState()) {
    on<GetAllTaskEvent>(_onGetAllTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<AddTaskEvent>(_onAddTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

Future<void> _onGetAllTask(GetAllTaskEvent event, Emitter<MainState> emit) async {
  emit(TaskLoadingState());
  try {
    final tasks = await webServices.getAllTasks();
    emit(TaskLoadedState(tasks));
  } catch (e) {
    emit(TaskErrorState(e.toString()));
  }
}

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<MainState> emit) async {
    try {
      webServices.objectBox.updateTask(event.id, event.task);
      final tasks = webServices.objectBox.getAllTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<MainState> emit) async {
    try {
      final newTaskId = webServices.objectBox.addTask(event.task);
      final tasks = webServices.objectBox.getAllTasks();
      tasks.sort((a, b) => b.id.compareTo(a.id));
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<MainState> emit) async {
    try {
      webServices.objectBox.deleteTask(event.id);
       final tasks = webServices.objectBox.getAllTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }
}
