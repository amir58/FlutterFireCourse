/// messageId : ""
/// senderId : ""
/// reciverId : ""
/// message : ""
/// time : ""

// {
// "messageId":"",
// "senderId":"",
// "reciverId":"",
// "message":"",
// "time":""
// }

class Message {
  Message({
      String? messageId, 
      String? senderId, 
      String? reciverId, 
      String? message, 
      String? time,}){
    _messageId = messageId;
    _senderId = senderId;
    _receiverId = reciverId;
    _message = message;
    _time = time;
}

  Message.fromJson(dynamic json) {
    _messageId = json['messageId'];
    _senderId = json['senderId'];
    _receiverId = json['reciverId'];
    _message = json['message'];
    _time = json['time'];
  }
  String? _messageId;
  String? _senderId;
  String? _receiverId;
  String? _message;
  String? _time;

  String? get messageId => _messageId;
  String? get senderId => _senderId;
  String? get reciverId => _receiverId;
  String get message => _message ?? "";
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['messageId'] = _messageId;
    map['senderId'] = _senderId;
    map['reciverId'] = _receiverId;
    map['message'] = _message;
    map['time'] = _time;
    return map;
  }

}