import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/components/ui/bordered_bottom.dart';
import 'package:http/http.dart';

class BodyView extends StatelessWidget {
  final Response response;

  const BodyView({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedAll(
      child: ExpansionTile(
        title: Text(
          "Body",
          style: Theme.of(context).textTheme.headline6,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(
              response.body,
            ),
          ),
        ],
      ),
    );
  }
}
