import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/pages.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'user': ( _ ) => UserPage(),
  'chat': ( _ ) => ChatPage(),
  'login': ( _ ) => LoginPage(),
  'register': ( _ ) => RegisterPage(),
  'loading': ( _ ) => LoadingPage(),
};
