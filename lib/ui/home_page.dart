import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sat3_todo_upgrade/controllers/task_controller.dart';
import 'package:sat3_todo_upgrade/models/task.dart';
import 'package:sat3_todo_upgrade/services/notification_services.dart';
import 'package:sat3_todo_upgrade/services/theme_services.dart';
import 'package:sat3_todo_upgrade/ui/add_task_bar.dart';
import 'package:sat3_todo_upgrade/ui/theme.dart';
import 'package:sat3_todo_upgrade/ui/update.dart';
import 'package:sat3_todo_upgrade/ui/widjets/button.dart';
import 'package:sat3_todo_upgrade/ui/widjets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var notifyHelper;
DateTime _selectedDate = DateTime.now();
final _taskController = Get.put(TaskController());

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
    // notifyHelper.requesIOSPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (__, index) {
              Task task = _taskController.taskList[index];
              // print(task.toJson());
              if(task.repeat=='Daily'){
                DateTime date = DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task
                );
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                    context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              }
              if(task.date==DateFormat.yMd().format(_selectedDate)){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                    context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              }else{
                return Container();
              }
            });
      }),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: (
            TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        dayTextStyle:(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        monthTextStyle: (
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ اضف مهمه",
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }
}

_showBottomSheet(BuildContext context, Task task) {
  Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery
            .of(context)
            .size
            .height * 0.40
            : MediaQuery
            .of(context)
            .size
            .height * 0.40,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(label: "انهاء المهمه",
                onTap: () {
                  _taskController.markTaskCompleted(task.id!);
                  _taskController.getTasks();
                  Get.back();
                },
                clr: primaryClr,
                context:context
            ),
            _bottomSheetButton(label: "حذف المهمه",
                onTap: () {
                  _taskController.delete(task);
                  _taskController.getTasks();
                  Get.back();
                },
                clr: Colors.red[300]!,
                context:context
            ),
            _bottomSheetButton(label: "تعديل المهمه",
                onTap: () {
                  Get.back();
                  Get.to(() => updTaskPage());
                  _taskController.upd(task);
                },
                clr: Colors.orange,
                context:context
            ),
            SizedBox(height: 20,),
            _bottomSheetButton(label: "اغلاق",
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
                isClose: true,
                context:context
            ),
            SizedBox(height: 20,),

          ],
        ),
      )
  );
}

_bottomSheetButton({
  required String label,
  required Function()? onTap,
  required Color clr,
  bool isClose = false,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 55,
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isClose==true?Colors.red:clr,
        ),
        borderRadius: BorderRadius.circular(20),
        color: isClose==true?Colors.transparent:clr,
      ),
      child:
      Center(
        child: Text(
          label,
          style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
        ),
      ),
    ),
  );
}

_appBar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text('Sat3Todo'),
    leading: GestureDetector(
      onTap: () {
        ThemeServices().switchTheme();
        notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? "Activated Light Theme"
                : "Activated Dark Theme");

        //not so important
        // notifyHelper.scheduledNotification();
      },
      child: const Icon(
        Icons.nightlight_round,
        size: 20,
        color: Colors.amberAccent,
      ),
    ),
    actions: const [
      CircleAvatar(
        backgroundImage: AssetImage("images/sat3Todo.png"),
      ),
      SizedBox(
        width: 20,
      ),
    ],
  );
}
