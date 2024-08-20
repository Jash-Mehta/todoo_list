import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_list/bloc/main_bloc.dart';
import 'package:todoo_list/bloc/main_event.dart';
import 'package:todoo_list/bloc/main_state.dart';
import 'package:todoo_list/model/taskData.dart';
import 'package:todoo_list/objectbox.g.dart';

Widget taskCard(TaskData task, MainBloc _mainBloc) {
  return BlocBuilder<MainBloc, MainState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: task.completed!
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: task.completed,
                    onChanged: (bool? value) {
                      task.completed = value ?? false;
                      BlocProvider.of<MainBloc>(context)
                          .add(UpdateTaskEvent(task, task.id));
                    },
                    activeColor: Theme.of(context).hintColor,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
               const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 25,
                  ),
                  onPressed: () {
                    showUpdateTaskDialog(context, task, _mainBloc);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 25,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _mainBloc.add(DeleteTaskEvent(id: task.id));
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showAddTaskDialog(BuildContext context, MainBloc _mainBloc) {
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Add Task',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 50.0,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the task name';
                  }
                  return null;
                },
                controller: _taskNameController,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              final newTask = TaskData(
                title: _taskNameController.text,
                completed: false,
              );
              _mainBloc.add(AddTaskEvent(newTask));

              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.0,
            ),
            onPressed: () {
              // Handle the cancel action
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

void showUpdateTaskDialog(
    BuildContext context, TaskData task, MainBloc _mainBloc) {
  TextEditingController _taskNameController =
      TextEditingController(text: task.title);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Update Task',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 50.0,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the task name';
                  }
                  return null;
                },
                controller: _taskNameController,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              task.title = _taskNameController.text;
              _mainBloc.add(UpdateTaskEvent(task, task.id));
              Navigator.of(context).pop();
            },
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.0,
            ),
            onPressed: () {
              // Handle the cancel action
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
