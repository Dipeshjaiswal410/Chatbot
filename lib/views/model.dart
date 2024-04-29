import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:chatbot/components/constants.dart';
import 'package:flutter/material.dart';

enum ChatMessageType { user, bot }

class ChatMessage {
  final String text;
  final ChatMessageType chatMessageType;
  ChatMessage({
    required this.text,
    required this.chatMessageType,
  });
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    Key? key,
    required this.text,
    required this.chatMessageType,
  }) : super(key: key);

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      color: chatMessageType==ChatMessageType.bot
      ?appBar_color
      :backGround_color,
      child: Row(   
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType==ChatMessageType.bot
          ? Container(
            child: CircleAvatar( 
              backgroundColor: appBar_color, 
              child: Image.asset("assets/images/chat_logo.png",width: 30,height: 30,),
            ),
          )
          :Container(
            margin: EdgeInsets.only(right: 3),
            child: CircleAvatar(  
              backgroundColor: backGround_color,
              child: Image.asset("assets/images/person.png",width: 30,height: 30,
              ),
            ),
          ),
          Expanded(
            child: Padding(  
              padding: EdgeInsets.all(7),
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(  
                    text,
                    textStyle: TextStyle(fontSize: 16,color: Colors.white)
                  )
                ],
              ),
            ),
          ),
          chatMessageType==ChatMessageType.bot
          ? IconButton(
            icon: Icon(Icons.copy,size: 17,color: Colors.white,),
            onPressed: (){
              Flushbar(
                maxWidth: 135,
                backgroundColor: Colors.lightGreen,
                flushbarPosition: FlushbarPosition.TOP,
                duration: Duration(seconds: 2),
                message: "Content copied",
              )..show(context);
              Clipboard.setData(new ClipboardData(text: text));
            },
          )
          :const Text("")
        ],
      ),
    );
  }
}
