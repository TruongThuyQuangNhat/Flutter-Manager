import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/contants/base_api.dart';
import 'package:flutter_application_1/contants/util.dart';
import 'package:flutter_application_1/theme/theme_colors.dart';
import 'package:http/http.dart' as http;

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _controllerFirstName =
      new TextEditingController();
  final TextEditingController _controllerLastName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();
  final TextEditingController _controllerPhone = new TextEditingController();
  final TextEditingController _controllerAddress = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Creation User"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      padding: EdgeInsets.all(30),
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerFirstName,
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "First Name",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerLastName,
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "Last Name",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerEmail,
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "Email",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerPhone,
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "Phone",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerAddress,
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "Address",
          ),
        ),
        SizedBox(
          height: 40,
        ),
        FlatButton(
            color: primary,
            onPressed: () {
              createNewUser();
            },
            child: Text(
              "Done",
              style: TextStyle(color: white),
            ))
      ],
    );
  }

  createNewUser() async {
    var firstname = _controllerFirstName.text;
    var lastname = _controllerLastName.text;
    var email = _controllerEmail.text;
    var phone = _controllerPhone.text;
    var address = _controllerAddress.text;
    List roles = [56, 59];
    if (firstname.isNotEmpty &&
        email.isNotEmpty &&
        lastname.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty) {
      var url = BASE_API + "user";
      var bodyData = jsonEncode({
        "firstname": firstname.toString(),
        "lastname": lastname.toString(),
        "email": email.toString(),
        "phone": phone.toString(),
        "address": address.toString(),
        "roles": roles,
      });
      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: bodyData);
      if (response.statusCode == 201) {
        var message = json.decode(response.body)['message'];
        showMessage(context, message);
        setState(() {
          _controllerFirstName.text = "";
          _controllerLastName.text = "";
          _controllerEmail.text = "";
          _controllerPhone.text = "";
          _controllerAddress.text = "";
        });
      } else {
        var messageError = "Can not create new user!!";
        showMessage(context, messageError);
      }
    }
  }
}
