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
        title: const Text('TaskMaster Pro'),
        actions: [
          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: taskController.tasks.isNotEmpty
                ? Chip(
              label: Text(
                '${taskController.tasks.where((t) => t.isDone).length}/${taskController.tasks.length}',
              ),
            )
                : const SizedBox.shrink(),
          )),
        ],
      ),
      body: Column(
        children: [
          _buildAddTaskField(),
          Expanded(
            child: Obx(() {
              if (taskController.tasks.isEmpty) {
                return _buildEmptyState();
              }
              return _buildTaskList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Add new task...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _addTask,
            child: const Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No tasks yet!\nTap + to add your first task',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: taskController.tasks.length,
      itemBuilder: (context, index) {
        final task = taskController.tasks[index];
        return _buildTaskTile(task, index);
      },
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    return Dismissible(
      key: Key(task.id),
      background: _buildDeleteBackground(),
      secondaryBackground: _buildEditBackground(),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _showEditDialog(task, index);
        } else {
          taskController.removetask(index);
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: _buildPriorityIndicator(task.priority),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? Colors.grey : null,
            ),
          ),
          trailing: Checkbox(
            value: task.isDone,
            onChanged: (_) => taskController.toggleDone(index),
          ),
          onTap: () => _showEditDialog(task, index),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(int priority) {
    final colors = [
      Colors.red,    // High
      Colors.orange, // Medium
      Colors.green,  // Low
    ];
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: colors[priority - 1],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red[100],
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      child: const Icon(Icons.delete, color: Colors.red),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      color: Colors.blue[100],
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.edit, color: Colors.blue),
    );
  }

  void _showEditDialog(Task task, int index) {
    final editController = TextEditingController(text: task.title);
    int selectedPriority = task.priority;

    Get.defaultDialog(
      title: 'Edit Task',
      content: Column(
        children: [
          TextField(
            controller: editController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Task description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          _buildPrioritySelector(selectedPriority, (value) {
            selectedPriority = value;
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            taskController.updateTask(
              index,
              editController.text,
              selectedPriority,
            );
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector(int currentPriority, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPriorityButton(1, 'High', currentPriority, onChanged),
        _buildPriorityButton(2, 'Medium', currentPriority, onChanged),
        _buildPriorityButton(3, 'Low', currentPriority, onChanged),
      ],
    );
  }

  Widget _buildPriorityButton(
      int value,
      String label,
      int currentPriority,
      Function(int) onChanged,
      ) {
    final isSelected = value == currentPriority;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onChanged(value),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
      selectedColor: _getPriorityColor(value),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1: return Colors.red;
      case 2: return Colors.orange;
      case 3: return Colors.green;
      default: return Colors.grey;
    }
  }
  void _addTask() async {
    final trimmedText = textController.text.trim();
    if (trimmedText.isNotEmpty) {
      taskController.addTask(trimmedText, 3);
      textController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}