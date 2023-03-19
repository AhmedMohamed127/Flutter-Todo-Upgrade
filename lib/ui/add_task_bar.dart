import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:sat3_todo_upgrade/controllers/task_controller.dart';
import 'package:sat3_todo_upgrade/models/task.dart';
import 'package:sat3_todo_upgrade/ui/theme.dart';
import 'package:sat3_todo_upgrade/ui/widjets/button.dart';
import 'package:sat3_todo_upgrade/ui/widjets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endtTime = DateFormat("hh::mm a").format(DateTime.now()).toString();
  String _startTime = DateFormat("hh::mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String _selectedRebeat = "None";
  List<String> repeatList = ["None", "Daily"];
  int _selectedClr = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.only(right: 20, left: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "اضافة المهام",
                style: headingStyle,
              ),
              MyInputField(title: "عنوان المهمه", hint: "ادخل عنوان المهمه",controller: _titleController,),
              SizedBox(
                height: 20,
              ),
              MyInputField(title: "ملاحظاتك", hint: "ادخل ملاحظاتك",controller: _noteController,),
              SizedBox(
                height: 20,
              ),
              MyInputField(
                title: "التاريخ",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "موعد البدء",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: MyInputField(
                        title: "موعد الانتهاء",
                        hint: _endtTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // MyInputField(
              //   title: "التذكير",
              //   hint: "$_selectedRemind دقيقة باكراً",
              //   widget: DropdownButton(
              //       icon: Icon(
              //         Icons.keyboard_arrow_down,
              //         color: Colors.grey,
              //       ),
              //       iconSize: 32,
              //       elevation: 4,
              //       style: subTitleStyle,
              //       underline: Container(
              //         height: 0,
              //       ),
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           _selectedRemind = int.parse(newValue!);
              //         });
              //       },
              //       items:
              //       remindList.map<DropdownMenuItem<String>>((int value) {
              //         return DropdownMenuItem<String>(
              //           value: value.toString(),
              //           child: Text(value.toString()),
              //         );
              //       }).toList()),
              // ),
             // SizedBox(
               // height: 20,
              //),
              /*  MyInputField(
                title: "التكرار",
                hint: "$_selectedRebeatً",
                widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRebeat = newValue!;
                      });
                    },
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList()),
              ),*/
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ClrPalatte(),
                  MyButton(label: "انشئ المهمه", onTap: (){
                    _validateData();
                    _taskController.getTasks();
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      //add to database
      _addTaskToDB();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("مطلوب", "كل الحقول يجب ادخالها!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.red,
          icon: Icon(Icons.warning_amber_rounded,
            color: Colors.red,
          )
      );
    }
  }



  _addTaskToDB() async{
    int value =await  _taskController.addTask(
        task: Task(
          note:_noteController.text ,
          title:_titleController.text ,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime:_endtTime ,
          remind:_selectedRemind ,
          repeat:_selectedRebeat ,
          color: _selectedClr,
          isCompleted: 0,
        )
    );
    print("My id is "+"$value");
  }
  _ClrPalatte(){
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الاهمية",
          style: titleStyle,
        ),
        Wrap(
          children: List<Widget>.generate(6, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedClr = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      :index==1?pinkClr
                      :index==2? yellowClr
                      :index==3?Colors.red
                      :index==4?Colors.deepPurple
                      :Colors.green,
                  child: _selectedClr == index
                      ? Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 16,
                  )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );

  }


  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text('Sat3Todo'),
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back_ios,
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
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2023));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("somethimg wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endtTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[0]),
        ));
  }


}
