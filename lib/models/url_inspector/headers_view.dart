import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/components/ui/bordered_bottom.dart';
import 'package:http/http.dart';

class HeadersView extends StatelessWidget {
  final Response response;

  const HeadersView({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedAll(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Headers", style: Theme.of(context).textTheme.headline6,),
            ...response.headers.entries
                .map(
                  (e) => BorderedBottom(
                    child: Row(
                      children: [
                        SelectableText("${e.key}: ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        SelectableText(e.value),
                      ],
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
