import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sat3_todo_upgrade/db/db_helper.dart';
import 'package:sat3_todo_upgrade/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }
  var taskList= <Task>[].obs;
  Future<int> addTask({Task? task})async{
    return await DBHelper.insert(task);
  }
  //get all table data
void getTasks()async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
}
  void delete(Task task){
    DBHelper.delete(task);
  }
  void upd(Task task){
    DBHelper.updated(task);
  }

  void markTaskCompleted(int id)async{
   await DBHelper.update(id);
  }

}