import 'package:chat/routes/routes.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/chat_service.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ )=> AuthService()),
        ChangeNotifierProvider(create: ( _ )=> SocketService()),
        ChangeNotifierProvider(create: ( _ )=> ChatService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print('hola');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
     initialRoute: 'loading',
     routes: appRoutes,
    );
  }
}