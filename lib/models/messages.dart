import 'package:chat_app/constants/constant.dart';

class Message
{
  final String message ;
  final String id ;

  Message(this.message , this.id);


  factory Message.fromJsoc(jsonData)
 {
    return Message(jsonData[kMessage] , jsonData['id']);
 }
}