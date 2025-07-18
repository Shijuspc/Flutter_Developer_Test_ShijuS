import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final taskList = <TaskModel>[].obs;
  final isLoading = false.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void showSnack(String title, String message, {bool isError = true}) {
    final context = Get.context!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _initData() async {
    await fetchTasksFromFirebase();
  }

  Future<void> fetchTasksFromFirebase() async {
    try {
      isLoading.value = true;

      final snapshot = await _db.collection('tasks').orderBy('id').get();
      taskList.value = snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // showSnack('Success', 'Tasks loaded successfully', isError: false);
    } catch (e) {
      showSnack('Error', 'Failed to fetch tasks. Check your connection.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTaskStatus(String taskId, bool newStatus) async {
    try {
      await _db.collection('tasks').doc(taskId).update({'status': newStatus});
      final index = taskList.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        taskList[index] = taskList[index].copyWith(status: newStatus);
      }
      showSnack('Success', 'Task status updated', isError: false);
    } catch (e) {
      showSnack('Update Failed', 'Could not update task status.');
    }
  }

  Future<void> updateTaskDetails(
    String taskId,
    String newDescription,
    String newDueDate,
  ) async {
    try {
      await _db.collection('tasks').doc(taskId).update({
        'description': newDescription,
        'dueDate': newDueDate,
      });

      final index = taskList.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        taskList[index] = taskList[index].copyWith(
          description: newDescription,
          dueDate: newDueDate,
        );
        taskList.refresh();
      }
      showSnack('Success', 'Task details updated', isError: false);
    } catch (e) {
      showSnack('Update Error', 'Could not update task details.');
    }
  }

  Future<void> fetchApiAndSave() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Accept': 'application/json', 'User-Agent': 'FlutterApp/1.0'},
      );

      if (response.statusCode == 200) {
        _storage.write('cachedTasks', response.body);
        final List data = json.decode(response.body);
        for (var item in data.take(3)) {
          TaskModel task = TaskModel(
            id: item['id'].toString(),
            title: item['title'],
            description: '',
            status: item['completed'],
            dueDate: '',
          );
          await _db.collection('tasks').doc(task.id).set(task.toMap());
        }
        fetchTasksFromFirebase();
        showSnack(
          'Success',
          'Tasks fetched from API and saved',
          isError: false,
        );
      } else {
        showSnack('API Error', 'Status ${response.statusCode} from server.');
      }
    } catch (e) {
      showSnack('Network Error', 'No internet. Loading cached data...');
      final cached = _storage.read('cachedTasks');
      if (cached != null) {
        final List data = json.decode(cached);
        for (var item in data.take(3)) {
          TaskModel task = TaskModel(
            id: item['id'].toString(),
            title: item['title'],
            description: '',
            status: item['completed'],
            dueDate: '',
          );
          await _db.collection('tasks').doc(task.id).set(task.toMap());
        }
        fetchTasksFromFirebase();
        showSnack('Success', 'Loaded from cache', isError: false);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
