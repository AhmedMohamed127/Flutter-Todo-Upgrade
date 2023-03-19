import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:sat3_todo_upgrade/controllers/task_controller.dart';
import 'package:sat3_todo_upgrade/models/task.dart';
import 'package:sat3_todo_upgrade/ui/theme.dart';
import 'package:sat3_todo_upgrade/ui/widjets/button.dart';
import 'package:sat3_todo_upgrade/ui/widjets/input_field.dart';

class UpdateTaskPage extends StatefulWidget {
  const UpdateTaskPage({Key? key}) : super(key: key);

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final TaskController _taskController2 = Get.put(TaskController());
  final TextEditingController _titleController2 = TextEditingController();
  final TextEditingController _noteController2 = TextEditingController();
  DateTime _selectedDate2 = DateTime.now();
  String _endtTime2 = DateFormat("hh::mm a").format(DateTime.now()).toString();
  String _startTime2 = DateFormat("hh::mm a").format(DateTime.now()).toString();
  int _selectedRemind2 = 5;
  List<int> remindList2 = [5, 10, 15, 20];

  String _selectedRebeat2 = "None";
  List<String> repeatList2 = ["None", "Daily",];
  int _selectedClr2 = 0;

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
              MyInputField(title: "عنوان المهمه", hint: "ادخل عنوان المهمه",controller: _titleController2,),
              SizedBox(
                height: 10,
              ),
              MyInputField(title: "ملاحظاتك", hint: _titleController2.text,controller: _noteController2,),
              SizedBox(
                height: 10,
              ),
              MyInputField(
                title: "التاريخ",
                hint: DateFormat.yMd().format(_selectedDate2),
                widget: IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "موعد البدء",
                        hint: _startTime2,
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
                        hint: _endtTime2,
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
                height: 10,
              ),
              MyInputField(
                title: "التذكير",
                hint: "$_selectedRemind2 دقيقة باكراً",
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
                        _selectedRemind2 = int.parse(newValue!);
                      });
                    },
                    items:
                    remindList2.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList()),
              ),
              SizedBox(
                height: 10,
              ),
              MyInputField(
                title: "التكرار",
                hint: "$_selectedRebeat2ً",
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
                        _selectedRebeat2 = newValue!;
                      });
                    },
                    items: repeatList2
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList()),
              ),
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
                    _taskController2.getTasks();
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
    if(_titleController2.text.isNotEmpty && _noteController2.text.isNotEmpty){
      //add to database
      _addTaskToDB();
      Get.back();
    }else if(_titleController2.text.isEmpty || _noteController2.text.isEmpty){
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
    int value =await  _taskController2.addTask(
        task: Task(
          note:_noteController2.text ,
          title:_titleController2.text ,
          date: DateFormat.yMd().format(_selectedDate2),
          startTime: _startTime2,
          endTime:_endtTime2 ,
          remind:_selectedRemind2 ,
          repeat:_selectedRebeat2 ,
          color: _selectedClr2,
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
                  _selectedClr2 = index;
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
                  child: _selectedClr2 == index
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
        _selectedDate2 = _pickerDate;
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
        _startTime2 = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endtTime2 = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime2.split(":")[0]),
          minute: int.parse(_startTime2.split(":")[0]),
        ));
  }


}
