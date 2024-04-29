import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot/data/api_services.dart';
import 'package:chatbot/components/constants.dart';
import 'package:chatbot/views/drawer_widget.dart';
import 'package:chatbot/views/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Timer? timer;

  //**********variable declaration************/
  var voice_text = 'Speak...';
  var isListening = false;
  SpeechToText speechToText = SpeechToText();
  late bool isLoading;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround_color,
      endDrawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "ChatBot",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("assets/images/openai_logo.png"),
        ),
        backgroundColor: backGround_color,
      ),
      body: Column(
        children: [
          //build list.......
          const Divider(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                return ChatMessageWidget(
                    text: message.text,
                    chatMessageType: message.chatMessageType);
              },
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Padding(
              padding: EdgeInsets.all(7),
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Divider(
            color: appBar_color,
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: [
                _voice_assistent(),
                isListening == true ? show_voice_text() : _build_input(),
                isListening == true ? Text("") : _submit()
                // build input field......
                //_input(),
                //submit button....
                //_submit()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 50), curve: Curves.easeOut);
  }

  //********show voice text******/
  Widget show_voice_text() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: 26,
        ),
        child: Container(
          color: appBar_color,
          child: Text(
            voice_text,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  //********input**** */
  Widget _build_input() {
    return Expanded(
      child: TextField(
        cursorColor: Color.fromARGB(255, 184, 180, 180),
        style: TextStyle(fontSize: 16, color: Colors.white),
        textCapitalization: TextCapitalization.sentences,
        controller: _textController,
        decoration: InputDecoration(
          fillColor: appBar_color,
          filled: true,
          hintText: "Type your query...",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  //**********Submit******
  Widget _submit() {
    return Visibility(
      child: IconButton(
        icon: Icon(
          Icons.send_rounded,
          color: Colors.white,
        ),
        onPressed: () async {
          //display user input....
          setState(
            () {
              _messages.add(
                ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user),
              );
              isLoading = true;
            },
          );
          var input = _textController.text;
          _textController.clear();
          Future.delayed(Duration(milliseconds: 50)).then((_) => _scrollDown());

          //call chatbot api....
          generateResponse(input).then((value) {
            setState(() {
              isLoading = false;
              _messages.add(ChatMessage(
                  text: value, chatMessageType: ChatMessageType.bot));
            });
          });
          _textController.clear();
          Future.delayed(Duration(milliseconds: 50)).then((_) => _scrollDown());
        },
      ),
    );
  }

  //********voice assistence*******/
  Widget _voice_assistent() {
    return AvatarGlow(
      endRadius: 30,
      animate: isListening,
      duration: Duration(milliseconds: 2000),
      glowColor: Colors.white,
      repeat: true,
      repeatPauseDuration: const Duration(milliseconds: 100),
      showTwoGlows: true,
      child: GestureDetector(
        //*****on tap down */
        onTapDown: (details) async {
          if (!isListening) {
            var available = await speechToText.initialize();
            if (available) {
              setState(() {
                isListening = true;
                speechToText.listen(onResult: (result) {
                  setState(() {
                    voice_text = result.recognizedWords;
                  });
                });
              });
            }
          }
        },
        //******on tap up******* */
        onTapUp: (detaile) {
          setState(() {
            isListening = false;
          });
          speechToText.stop();
          if (voice_text.isNotEmpty && voice_text != "Speak...") {
            _messages.add(ChatMessage(
                text: voice_text, chatMessageType: ChatMessageType.user));
            isLoading = true;
            var input = voice_text;
            Future.delayed(Duration(milliseconds: 50))
                .then((_) => _scrollDown());

            //******calling api******
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(ChatMessage(
                    text: value, chatMessageType: ChatMessageType.bot));
              });
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 80),
                content: Text(
                  "Failed to proceed. Try again!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            );
          }
        },
        child: Icon(
          isListening ? Icons.mic : Icons.mic_none,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
