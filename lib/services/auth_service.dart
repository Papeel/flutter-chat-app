
import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier{
  User? user;
  bool _authenticating = false;
  final _storage =  FlutterSecureStorage();

  bool get authenticating => this._authenticating;

  set authenticating( bool value ) {
    this._authenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken()async{
    final _storage =  FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;

  }

  static Future<void> deleteToken()async{
    final _storage =  FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future<bool> login(String email, String password) async {
    this.authenticating = true;

    final data = {
      'email': email,
      'password': password
    };

    final url =  Uri.http(Environment.socketUrlBase, '/api/login');

    final resp = await http.post(url, 
      body : jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    this.authenticating = false;

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    }
    return false;
  }


  Future<String> register(String name, String email, String password) async {
    this.authenticating = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final url =  Uri.http(Environment.socketUrlBase, '/api/login/new');

    final resp = await http.post(url, 
      body : jsonEncode(data),
      headers: {'Content-Type': 'application/json'}
    );
    this.authenticating = false;

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return '';
    }
    final respBody = jsonDecode(resp.body);
    return respBody['msg'] ?? "Authentication error";
  }

  Future<bool> isLoggedIn() async{
    final token = await this._storage.read(key: 'token');
    final url =  Uri.http(Environment.socketUrlBase, '/api/login/renew');

    final resp = await http.get(url, 
      headers: {
        'Content-Type': 'application/json',
        'x-token':token ?? ''
      }
    );

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    }
    this.logout();
    return false;
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async{
    return await _storage.delete(key: 'token');
  }
  
}