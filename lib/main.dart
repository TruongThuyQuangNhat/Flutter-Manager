import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/index.dart';
import 'package:flutter_application_1/theme/theme_colors.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(primaryColor: primary),
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
    ));
