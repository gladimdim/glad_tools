import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_container_with_side.dart';

class BorderedBottom extends StatelessWidget {
  final double width;
  final Color color;
  final Widget child;

  const BorderedBottom(
      {Key? key,
      this.width = 3.0,
      this.color = Colors.black,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedContainerWithSides(
      child: child,
      borderDirections: const [AxisDirection.down],
    );
  }
}
