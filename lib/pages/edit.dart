import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/contants/base_api.dart';
import 'package:flutter_application_1/contants/util.dart';
import 'package:flutter_application_1/theme/theme_colors.dart';
import 'package:http/http.dart' as http;

class Roles {
  String name;
  String id;
}

class EditUser extends StatefulWidget {
  String userId;
  String firstname;
  String lastname;
  String email;
  String phone;
  String address;
  List roles;
  EditUser({
    this.userId = "",
    this.firstname = "",
    this.lastname = "",
    this.email = "",
    this.phone = "",
    this.address = "",
    this.roles,
  });
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _controllerFirstName =
      new TextEditingController();
  final TextEditingController _controllerLastName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();
  final TextEditingController _controllerPhone = new TextEditingController();
  final TextEditingController _controllerAddress = new TextEditingController();
  // controllerRoles
  String userId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userId = widget.userId;
      _controllerFirstName.text = widget.firstname;
      _controllerLastName.text = widget.lastname;
      _controllerEmail.text = widget.email;
      _controllerPhone.text = widget.phone;
      _controllerAddress.text = widget.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edition User"),
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
              editUser();
            },
            child: Text(
              "Done",
              style: TextStyle(color: white),
            ))
      ],
    );
  }

  editUser() async {
    var firstname = _controllerFirstName.text;
    var lastname = _controllerLastName.text;
    var email = _controllerEmail.text;
    var phone = _controllerPhone.text;
    var address = _controllerAddress.text;
    List roles = widget.roles;
    var arr = roles.map((e) {
      return e["id"];
    });
    if (firstname.isNotEmpty &&
        email.isNotEmpty &&
        lastname.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty) {
      var url = BASE_API + "user/$userId";
      var bodyData = jsonEncode({
        "firstname": firstname.toString(),
        "lastname": lastname.toString(),
        "email": email.toString(),
        "phone": phone.toString(),
        "address": address.toString(),
        "roles": [...arr],
      });
      var response = await http.put(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: bodyData);
      if (response.statusCode == 200) {
        var messageSuccess = json.decode(response.body)['message'];
        showMessage(context, messageSuccess);
      } else {
        var messageError = "Can not update this user!!";
        showMessage(context, messageError);
      }
    }
  }
}
