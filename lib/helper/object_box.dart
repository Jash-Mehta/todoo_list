import 'package:todoo_list/model/taskData.dart';
import 'package:todoo_list/objectbox.g.dart';

class ObjectBox {
  late final Store _store;
  late final Box<TaskData> _taskBox;

  ObjectBox._init(this._store) {
    _taskBox = Box<TaskData>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();
    return ObjectBox._init(store);
  }

  // Retrieve all tasks
  List<TaskData> getAllTasks() {
    final tasks = _taskBox.getAll();
    print("Tasks fetched from DB: ${tasks.map((task) => task.title).toList()}");
    return tasks;
  }

  // Add a single task
  int addTask(TaskData task) {
    
    return _taskBox.put(task);
  }

  bool hasData() {
    return _taskBox.count() > 0;
  }

  // Add this new method to add multiple tasks
  void addTasks(List<TaskData> tasks) {
    _taskBox.putMany(tasks);
  }

  bool deleteTask(int id) {
    return _taskBox.remove(id);
  }

  // Update a task by ID
  void updateTask(int id, TaskData updatedTask) {
    final task = _taskBox.get(id);
    if (task != null) {
      task.title = updatedTask.title;
      task.completed = updatedTask.completed;
      _taskBox.put(task);
    }
  }
}
