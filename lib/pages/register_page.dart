import 'package:flutter/material.dart';

import 'package:chat/widgets/logo_widget.dart';
import 'package:chat/widgets/labels_widget.dart';
import 'package:chat/widgets/custom_input_widget.dart';
import 'package:chat/widgets/blue_button_widget.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.9) ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Sign Up',),
                _Form(),
                Labels(ruta:'login', title: '¿Ya tienes cuenta?', subtitle: 'Ingresa ahora',),
                Text('Téminos y condiciones de uso',style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
   );
  }
}




class _Form extends StatefulWidget {

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final userdCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person,
            placeholder: 'User',
            keyboardType: TextInputType.text,
            textControler: userdCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textControler: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Password',
            keyboardType: TextInputType.emailAddress,
            isPassword: true,
            textControler: passwordCtrl,
          ),
          BlueButton(
            text: 'Create Account',
            onPressed: () {
              print(emailCtrl.text);
              print(passwordCtrl.text);
            },
          )
        ],
      ),
    );
  }
}


