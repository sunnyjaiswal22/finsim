import 'package:flutter/material.dart';

class FinSimAppBar {
  static AppBar appbar({required String title}) {
    return AppBar(
      title: Center(
        child: Text('$title'),
      ),
    );
  }
}
