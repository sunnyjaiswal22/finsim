import 'package:flutter/material.dart';

class YearlyAppreciationInfo extends StatelessWidget {
  const YearlyAppreciationInfo({
    Key? key,
    required this.percentage,
    required this.label,
    this.reverseColors = false,
  }) : super(key: key);

  final double percentage;
  final String label;
  final bool reverseColors;

  @override
  Widget build(BuildContext context) {
    Color upColor, downColor;

    if (!reverseColors) {
      upColor = Colors.green;
      downColor = Colors.red;
    } else {
      upColor = Colors.red;
      downColor = Colors.green;
    }

    var selectedColor;
    var selectedIcon;
    if (percentage > 0) {
      selectedColor = upColor;
      selectedIcon = Icons.moving;
    } else {
      selectedColor = downColor;
      selectedIcon = Icons.trending_down;
    }

    return percentage != 0
        ? Row(children: [
            Icon(
              selectedIcon,
              color: selectedColor,
            ),
            Text(
              '$percentage% $label',
              style: TextStyle(color: selectedColor),
            ),
          ])
        : SizedBox.shrink();
  }
}
