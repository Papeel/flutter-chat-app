import 'dart:io';

import 'package:chat/widgets/chat_message._widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  
  final _textController =  TextEditingController();
  final _focusNode = FocusNode();
  
  List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height:3),
            Text('Melissa Flores', style: TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {  
                  return _messages[index];
                },
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        )
     ),
     
   );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSumit,
                onChanged: ( String text ){

                  setState(() {
                    if (text.trim().length > 0){
                      _isWriting = true;
                    }else{
                      _isWriting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Send Message'
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS 
              ? CupertinoButton(
                child: Text('Send'), 
               onPressed: _isWriting ? () => _handleSumit(_textController.text.trim()) : null,
              )
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.send,),
                    onPressed: _isWriting ? () => _handleSumit(_textController.text.trim()) : null,
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  _handleSumit(String text){
    if(text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage =  ChatMessage(
      text: text, 
      uid: '123',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });

  }
  @override
  void dispose() {
    // TODO: Off del socket
    for( ChatMessage message in _messages){
      message.animationController.dispose();
    }    
    super.dispose();
  }
}