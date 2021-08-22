import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_container_with_side.dart';

class BorderedTop extends StatelessWidget {
  final double width;
  final Color color;
  final Widget child;

  const BorderedTop(
      {this.width = 3.0, this.color = Colors.black, required this.child});

  @override
  Widget build(BuildContext context) {
    return BorderedContainerWithSides(
      child: child,
      borderDirections: [AxisDirection.up],
    );
  }
}
