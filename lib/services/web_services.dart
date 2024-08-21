import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todoo_list/helper/object_box.dart';
import 'package:todoo_list/model/taskData.dart';


  class WebServices {
  late ObjectBox objectBox;

  WebServices(this.objectBox);

  Future<List<TaskData>> getAllTasks() async {
    if (objectBox.hasData()) {
    
      return objectBox.getAllTasks();
    } else {
      return await fetchAndStoreTasksFromAPI();
    }
  }

  Future<List<TaskData>> fetchAndStoreTasksFromAPI() async {
    print("Fetching tasks from API");
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/todos"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final tasks = data.map((jsonTask) => TaskData.fromJson(jsonTask)).toList();
      
      objectBox.addTasks(tasks);
      
      return tasks;
    } else {
      throw Exception("Failed to get Data: ${response.statusCode}");
    }
  }
}