class Task {
  int? id;
  int? isCompleted;
  int? color;
  int? remind;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  String? repeat;

  Task({
    this.id,
    this.isCompleted,
    this.color,
    this.title,
    this.date,
    this.endTime,
    this.note,
    this.remind,
    this.repeat,
    this.startTime,
  });

Task.fromJson(Map<String,dynamic> json){
  id=json['id'];
  title=json['title'];
  date=json['date'];
  note=json['note'];
  isCompleted=json['isCompleted'];
  startTime=json['startTime'];
  endTime=json['endTime'];
  color=json['color'];
  remind=json['remind'];
  repeat=json['repeat'];
}

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;

    return data;
}
}