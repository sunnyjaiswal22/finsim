import 'package:flutter/material.dart';

class YearlyAppreciationInfo extends StatelessWidget {
  const YearlyAppreciationInfo({
    Key? key,
    required this.percentage,
  }) : super(key: key);

  final percentage;

  @override
  Widget build(BuildContext context) {
    var selectedColor;
    var selectedIcon;
    if (percentage > 0) {
      selectedColor = Colors.green;
      selectedIcon = Icons.moving;
    } else {
      selectedColor = Colors.red;
      selectedIcon = Icons.trending_down;
    }

    return percentage != 0
        ? Row(children: [
            Icon(
              selectedIcon,
              color: selectedColor,
            ),
            Text(
              '$percentage% p.a.',
              style: TextStyle(color: selectedColor),
            ),
          ])
        : SizedBox.shrink();
  }
}
