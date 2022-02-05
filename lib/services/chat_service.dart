import 'package:chat/models/messages_response.dart';
import 'package:chat/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/global/environment.dart';




class ChatService with ChangeNotifier {
  late User userTo;


  Future<List<Message>> getChat( String userId) async {
    try {
      final url =  Uri.http(Environment.socketUrlBase, '/api/messages/$userId');
      final resp = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        }
      );

      final messagesResponse = MessagesResponse.fromRawJson(resp.body);
      return messagesResponse.messages;
    } catch (e) {
      return [];
    }
  }
}


