import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:mytask/noti_service.dart';
import 'package:mytask/task-model.dart';

class TaskService extends GetxController{
  final NotificationService notificationService = NotificationService();
  final box = GetStorage();
  var tasks = [].obs;
  final String _storagekey = 'task';

  @override
  void onInit(){
    super.onInit();
    notificationService.initialize();

  final storedTasks = box.read<List>(_storagekey);
  if(storedTasks != null){
    tasks.assignAll(
      storedTasks.map((item) => Task.fromMap(item)).toList()
    );
  }

  }

  void saveTasks(){
    box.write(_storagekey, tasks.map((task)=> task.toMap()).toList());
  }

  void addTask(String title, int priority){
    final task = Task(title: title, priority: priority);
    task.notificationId = DateTime.now().millisecondsSinceEpoch % 100000; // Generate ID

    notificationService.scheduleTaskReminder(
      id: task.notificationId!,
      title: task.title,
      delay: const Duration(seconds: 10),
    );

    tasks.add(task);
    saveTasks();
  }

  void toggleDone(int index){
    final task = tasks[index];
    task.isDone = !task.isDone;

    // Cancel notification if task is completed
    if (task.isDone && task.notificationId != null) {
      notificationService.cancelNotification(task.notificationId!);
    }

    tasks.refresh();
    saveTasks();
  }

  void removetask(int index){
    tasks.removeAt(index);
    saveTasks();
  }

  void updateTask(int index, String newTitle, int newPriority) {
    tasks[index].title = newTitle;
    tasks[index].priority = newPriority;
    tasks.refresh();
  }

}
