import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/helps/app_colors.dart';
import '../controllers/task_controller.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.statusCompleted;
      case 'pending':
        return AppColors.statusPending;
      default:
        return AppColors.statusOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              Get.defaultDialog(
                title: 'Import Tasks',
                middleText: 'Do you want to fetch tasks from the API?',
                textCancel: 'Cancel',
                textConfirm: 'Yes',
                confirmTextColor: Colors.white,
                cancelTextColor: AppColors.primary,
                titleStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                buttonColor: AppColors.primary,
                backgroundColor: AppColors.white,
                onConfirm: () async {
                  Get.back();
                  await controller.fetchApiAndSave();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.taskList.isEmpty) {
          return const Center(child: Text('No tasks available.'));
        }

        return ListView.builder(
          itemCount: controller.taskList.length,
          itemBuilder: (context, index) {
            final task = controller.taskList[index];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(task.dueDate, style: const TextStyle(fontSize: 15)),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.statusText),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.statusText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                onTap: () => Get.to(() => TaskDetailScreen(taskId: task.id)),
              ),
            );
          },
        );
      }),
    );
  }
}
