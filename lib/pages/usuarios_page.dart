import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:chat/models/models.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {



  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);


  final users = <User>[
    User(email: 'nelson@gmail.com',name: 'Nelson', uid: '1', online: false,),
    User(email: 'juan@gmail.com',name: 'Juan', uid: '2', online: true,),
    User(email: 'fernando@gmail.com',name: 'Fernando', uid: '3', online: true,),
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(authService.user?.name ?? 'Sin nombre', style: TextStyle(color: Colors.black54),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.black54,),
          onPressed: (){
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400],),
            // child: Icon(Icons.check_circle, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        onRefresh: _loadUsers,
        controller: _refreshController,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue[400]!,
        ),
        child: _listViewUser(),
      ),
   );
  }

  ListView _listViewUser() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_ , i) => _userListTile(users[i]), 
      separatorBuilder: (_, i) => Divider(), 
      itemCount: users.length
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  void _loadUsers() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

