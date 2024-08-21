import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
    try {
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/todos"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ).timeout(const Duration(seconds: 10)); // Add a timeout

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonTask) => TaskData.fromJson(jsonTask)).toList();
      } else {
        throw Exception("Failed to get Data: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      print("Network error: $e");
      throw Exception("Network error: Please check your internet connection");
    } on TimeoutException catch (e) {
      print("Request timed out: $e");
      throw Exception("Request timed out: Please try again later");
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("An unexpected error occurred");
    }
  }
}