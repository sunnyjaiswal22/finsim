import 'package:flutter/material.dart';

class EmptyListInfo extends StatelessWidget {
  const EmptyListInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This list is empty. Tap', style: TextStyle(color: Colors.grey)),
          Icon(Icons.add, color: Colors.grey),
          Text('to add an item', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
