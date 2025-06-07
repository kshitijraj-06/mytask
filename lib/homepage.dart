import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytask/service.dart';
import 'package:mytask/task-model.dart';

class HomePage extends StatelessWidget {
  final TaskService taskController = Get.put(TaskService());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMaster'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: taskController.tasks.isNotEmpty
                ? Chip(
              key: ValueKey(taskController.tasks.length),
              backgroundColor: Colors.blue.withOpacity(0.2),
              label: Text(
                '${taskController.tasks.where((t) => t.isDone).length}/${taskController.tasks.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
                : const SizedBox.shrink(),
          )),
        ],
      ),
      body: Column(
        children: [
          // Add Task Section with animation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: 'What needs to be done?',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => _addTask(),
                      ),
                    ),
                  ),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: textController.text.isEmpty ? 0.8 : 1.0,
                    child: IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.blue),
                      iconSize: 32,
                      onPressed: _addTask,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Task List with animations
          Expanded(
            child: Obx(() {
              if (taskController.tasks.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No tasks yet!\nAdd your first task',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return AnimatedList(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                initialItemCount: taskController.tasks.length,
                itemBuilder: (context, index, animation) {
                  final task = taskController.tasks[index];
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    )),
                    child: _buildTaskTile(task, index, context),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (direction) => taskController.removetask(index),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => taskController.toggleDone(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                // Animated Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.isDone ? Colors.blue : Colors.transparent,
                    border: Border.all(
                      color: task.isDone ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: task.isDone
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 16),
                // Task Text with animation
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 16,
                      decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                      color: task.isDone ? Colors.grey : Colors.black87,
                    ),
                    child: Text(task.title),
                  ),
                ),
                // Priority indicator (optional)
                // if (task.priority != null)
                //   Container(
                //     width: 8,
                //     height: 8,
                //     margin: const EdgeInsets.only(left: 8),
                //     decoration: BoxDecoration(
                //       color: _getPriorityColor(task.priority!),
                //       shape: BoxShape.circle,
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1: return Colors.red;
      case 2: return Colors.orange;
      default: return Colors.green;
    }
  }

  void _addTask() {
    if (textController.text.trim().isNotEmpty) {
      taskController.addTask(textController.text.trim());
      textController.clear();
      // Hide keyboard
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}