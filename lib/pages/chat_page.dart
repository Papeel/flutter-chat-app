import 'dart:io';

import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_services.dart';
import 'package:chat/widgets/chat_message._widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  
  final _textController =  TextEditingController();
  final _focusNode = FocusNode();
  
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  
  List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.chatService  = Provider.of<ChatService>(context, listen: false);
    this.socketService  = Provider.of<SocketService>(context, listen: false);
    this.authService  = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('personal-message', (data) => _listenMessage(data));
    _loadMessages( this.chatService.userTo.uid );
  }

  void _loadMessages(String userId) async{
    List<Message> chat = await this.chatService.getChat(userId);
    final history = chat.map(
      (m) => 
      new ChatMessage(
        text: m.message, 
        uid: m.from, 
        animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward()
      )
    );
    setState(() {
      _messages.insertAll(0, history);
    });

  }



  void _listenMessage(dynamic payload){
    ChatMessage message =  ChatMessage(
      text: payload['message'],
      uid: payload['from'],
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }


  @override
  Widget build(BuildContext context) {
    final userTo = this.chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(userTo.name.substring(0,2), style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height:3),
            Text(userTo.name, style: TextStyle(color: Colors.black87, fontSize: 12),)
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
      uid: authService.user!.uid,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
    this.socketService.emit('personal-message',{
      'from': this.authService.user!.uid,
      'to': this.chatService.userTo.uid,
      'message': text
    });


  }
  @override
  void dispose() {
    // TODO: Off del socket
    for( ChatMessage message in _messages){
      message.animationController.dispose();
    }    
    this.socketService.socket.off('personal-message');
    super.dispose();
  }
}