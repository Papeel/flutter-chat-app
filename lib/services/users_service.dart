import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';
import 'package:chat/models/users_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final url =  Uri.http(Environment.socketUrlBase, '/api/users');
      final resp = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        }
      );

      final usersResponse = UsersResponse.fromRawJson(resp.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}