import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController  animationController;

  const ChatMessage({Key? key, required this.text, required this.uid, required this.animationController}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: this.uid == authService.user!.uid
          ? _myMessage()
          :_notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    // ignore: prefer_const_constructors
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),
        padding: EdgeInsets.all(8.0),
        child: Text(this.text, style: TextStyle(color: Colors.white),),
        decoration: BoxDecoration(
          color: Color(0xff4d9ef6),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, left: 5, right: 50),
        padding: EdgeInsets.all(8.0),
        child: Text(this.text, style: TextStyle(color: Colors.black87),),
        decoration: BoxDecoration(
          color: Color(0xffe4e5e8),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }
}