import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_application_1/contants/base_api.dart';
import 'package:flutter_application_1/pages/create.dart';
import 'package:flutter_application_1/pages/edit.dart';
import 'package:flutter_application_1/theme/theme_colors.dart';
import 'package:http/http.dart' as http;

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  ScrollController controller;
  List users = [];
  bool isLoading = false;
  int pageNum = 1;
  int totalRecord = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser(pageNum);
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  fetchUser(int pageNum) async {
    setState(() {
      isLoading = true;
    });
    var url = BASE_API +
        "user?page=" +
        pageNum.toString() +
        "&limit=10&role=[]&search=";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
        totalRecord = json.decode(response.body)['totalCount'];
        users = items;
        isLoading = false;
      });
    } else {
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listing Users"),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateUser()));
              },
              child: Icon(
                Icons.add,
                color: white,
              )),
        ],
      ),
      body: Scrollbar(controller: controller, child: getBody()),
    );
  }

// Scrollbar(controller: controller, child: getBody()),
  void _scrollListener() async {
    if (totalRecord == users.length) {
      return;
    }
    if (controller.position.extentAfter <= 0) {
      setState(() {
        pageNum++;
      });
      var url = BASE_API +
          "user?page=" +
          pageNum.toString() +
          "&limit=10&role=[]&search=";
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          totalRecord = json.decode(response.body)['totalCount'];
        });
        var items = json.decode(response.body)['data'];
        setState(() {
          users.addAll(items);
        });
      }
    }
  }

  Widget getBody() {
    if (isLoading || users.length == 0) {
      return Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(primary)));
    }
    return ListView.builder(
        controller: controller,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return cardItem(users[index]);
        });
  }

  Widget buildSearch(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
      onSubmitted: (value) {
        setState(() {
          users = [];
        });
      },
    );
  }

  Widget cardItem(item) {
    var fullname = item['firstname'] + item['lastname'];
    var email = item['email'];
    return Card(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: Text(fullname),
            subtitle: Text(email),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Edit',
            color: Colors.blueAccent,
            icon: Icons.edit,
            onTap: () => editUser(item),
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => showDeleteAlert(context, item),
          ),
        ],
      ),
    );
  }

  editUser(item) {
    List roles = item['roles'];
    var userId = item['id'].toString();
    var firstname = item['firstname'].toString();
    var lastname = item['lastname'].toString();
    var email = item['email'].toString();
    var phone = item['phone'].toString();
    var address = item['address'].toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditUser(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                email: email,
                phone: phone,
                address: address,
                roles: roles)));
  }

  deleteUser(userId) async {
    var url = BASE_API + "user/$userId";
    var response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      setState(() {
        users = [];
      });
      for (int i = 1; i <= pageNum; i++) {
        var url = BASE_API +
            "user?page=" +
            i.toString() +
            "&limit=10&role=[]&search=";
        var response = await http.get(url);
        if (response.statusCode == 200) {
          setState(() {
            totalRecord = json.decode(response.body)['totalCount'];
          });
          var items = json.decode(response.body)['data'];
          setState(() {
            users.addAll(items);
          });
        }
      }
    }
  }

  showDeleteAlert(BuildContext context, item) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: primary),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.pop(context);

        deleteUser(item['id']);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Would you like to delete this user?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
