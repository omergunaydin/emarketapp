class Message {
  String? id;
  String? name;
  String? phoneNumber;
  String? text;
  String? subject;
  String? type;

  Message({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.text,
    required this.subject,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; //Map<String, dynamic>()
    data['id'] = id;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['text'] = text;
    data['subject'] = subject;
    data['type'] = type;
    return data;
  }

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    text = json['text'];
    subject = json['subject'];
    type = json['type'];
  }
}
