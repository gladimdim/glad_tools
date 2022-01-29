import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:http/http.dart';

class StatusView extends StatelessWidget {
  final Response response;

  const StatusView({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedAll(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "Response status: ${response.statusCode}",
              style: TextStyle(color: getTextColor()),
            ),
          ],
        ),
      ),
    );
  }

  Color getTextColor() {
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return Colors.green;
    }
    if (response.statusCode >= 400 && response.statusCode <= 599) {
      return Colors.red;
    }
    return Colors.black;
  }
}
