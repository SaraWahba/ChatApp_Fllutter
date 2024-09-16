import 'package:chat_app/constants/constant.dart';
import 'package:chat_app/models/messages.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  static String id = "ChatPage";

  final _controller = ScrollController();


  CollectionReference messages = FirebaseFirestore.instance.collection(
      kMessagesCollections);

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAt, descending : true).snapshots(),
        builder: (context, snapshot) {

          if(snapshot.hasData)
            {
            List<Message> messagesList = [] ;
            for(int i=0 ; i<snapshot.data!.docs.length ; i++)
            {
               messagesList.add(Message.fromJsoc(snapshot.data!.docs[i]));
            }
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    "Chat App",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontFamily: 'Merriweather',
                        fontWeight: FontWeight.bold),
                  ),
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFF179872),
                        Color(0xFFFF8C93),
                      ]),
                    ),
                  ),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse : true ,
                        controller : _controller ,
                        itemCount:messagesList.length ,
                        itemBuilder: (context, index) {
                          return messagesList[index].id == email ? ChatBuble(message:messagesList[index] ,) :
                          ChatBubleForFriend(message:messagesList[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Merriweather',
                          fontSize: 18,
                        ),
                        controller: controller,
                        onSubmitted: (data) {
                          messages.add({
                            kMessage : data,
                            kCreatedAt : DateTime.now() ,
                            'id' : email ,
                          });
                          controller.clear();
                          _controller.animateTo(
                            0,
                            // _controller.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Send Message',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Merriweather',
                            fontSize: 16,
                          ),
                          suffixIcon: Icon(
                            Icons.send,
                            color: kPrimaryColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: kPrimaryColor, width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: kPrimaryColor, width: 3),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }else{
            return Text('Loading.........') ;
          }
        },
    );
  }
  }
